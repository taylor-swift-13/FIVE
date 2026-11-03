"""Automatic CompCert frontend and original Cexec embedding; no C translator."""
import hashlib,json,os,re,shutil,sys,tempfile
from pathlib import Path
from five_telemetry import Run,sha

ROOT=Path(__file__).resolve().parents[1]
SCHEMA='five-compcert-backend/1'
SEMANTIC_FILES=['compcert.config','lib/Integers.v','lib/Floats.v','common/Memory.v',
 'cfrontend/Ctypes.v','cfrontend/Cop.v','cfrontend/Csem.v','cfrontend/Cexec.v']

def normalized_ast(text):
    return re.sub(r'Definition source_file := "(?:[^"\\]|\\.)*"\.',
                  'Definition source_file := "<source-path>".',text)

def digest_text(text):return hashlib.sha256(text.encode()).hexdigest()
def validate_ast_target(text,target):
    info=re.search(r'Module Info\.(.*?)End Info\.',text,re.S)
    if not info:raise RuntimeError('Missing clightgen target metadata')
    info=info.group(1)
    for field in ['version','arch','model','abi']:
        match=re.search(r'Definition '+field+r' := "([^"\n]*)"\.',info)
        if not match or match.group(1)!=target[field]:raise RuntimeError('clightgen AST target differs from formal library: '+field)
    bits=re.search(r'Definition bitsize := ([0-9]+)\.',info)
    endian=re.search(r'Definition big_endian := (true|false)\.',info)
    if not bits or int(bits.group(1))!=target['bitsize'] or not endian or (endian.group(1)=='true')!=(target['endianness']=='big'):
        raise RuntimeError('clightgen AST bit width/endianness differs from formal library')
def ref(path):
    path=Path(path).resolve()
    try:return str(path.relative_to(ROOT))
    except ValueError:return str(path)
def resolve(path):return (ROOT/str(path)).resolve()
def save(path,data):
    path=Path(path);temporary=path.with_suffix(path.suffix+'.tmp')
    temporary.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n');temporary.replace(path)

def target_of(lib):
    config={}
    for line in (lib/'compcert.config').read_text().splitlines():
        if line and not line.startswith('#') and '=' in line:
            k,v=line.split('=',1);config[k]=v
    return {'semantics':'CompCert Csem/Cexec','version':config['COMPCERT_VERSION'],
      'arch':config['COMPCERT_ARCH'],'model':config['COMPCERT_MODEL'],
      'abi':config['COMPCERT_ABI'],'bitsize':int(config['COMPCERT_BITSIZE']),
      'system':config['COMPCERT_SYSTEM'],'endianness':config['COMPCERT_ENDIANNESS'],
      'float32':'IEEE754 binary32','rounding':'round-to-nearest-ties-to-even',
      'nan_policy':'CompCert Floats and target Archi definitions; hashes bind exact policy',
      'trust_boundary':'CompCert C semantics; no automatic GCC binary or hardware equivalence'}

def tool_paths(clightgen=None,lib=None):
    executable=shutil.which(clightgen or 'clightgen')
    if not executable:raise RuntimeError('clightgen unavailable; no manual-translation fallback')
    executable=Path(executable).resolve()
    library=Path(lib).resolve() if lib else executable.parent.parent/'lib/coq/user-contrib/compcert'
    if not (library/'compcert.config').is_file():raise RuntimeError('CompCert formal library/config unavailable')
    return executable,library

def wrapper(namespace,function):
    return f'''From Stdlib Require Import List String.
From compcert Require Import AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Smallstep.
From {namespace} Require Import Source.
Import ListNotations.
Definition ge := Csem.globalenv Source.prog.
Definition entry(args:list val)(m:mem):Csem.state :=
  Callstate(Ctypes.Internal Source.{function})args Kstop m.
Definition callback := string -> signature -> Senv.t -> world -> list val -> mem ->
  option(world*trace*val*mem).
Definition transitions(cb asm:callback)(w:world)(s:Csem.state):list Cexec.transition :=
  Cexec.do_step ge cb asm w s.
Definition model_step(cb asm:callback)(w:world)(_:unit)(s:Csem.state)(t:trace)(s':Csem.state):Prop :=
  exists rule,In(TR rule t s')(transitions cb asm w s).
Definition normal_return(s:Csem.state):Prop := exists v m,s=Returnstate v Kstop m.
Definition source_error(s:Csem.state):Prop := ~normal_return s /\\ nostep Csem.step ge s.
Definition observe_bytes(m:mem)(b:block)(ofs n:Z) := Mem.loadbytes m b ofs n.
(* This adapter is only for call-free, quiet cases with a checked coverage proof.
   None means no implemented callback; it is NOT an automatic C error diagnosis.
   Traceful worlds require a separately checked driver/world evolution. *)
Definition no_external:callback := fun _ _ _ _ _ _ => None.
Definition quiet_world:world := World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None).
Definition closed_transitions := transitions no_external no_external quiet_world.
'''.replace('Require Import List String.','Require Import List String ZArith.')

def export(source,function,output,namespace='FiveCompCert',include_dirs=(),defines=(),
           request=None,session=None,clightgen=None,lib=None):
    if not re.fullmatch(r'f_[A-Za-z_][A-Za-z_0-9]*',function):raise ValueError('Function must be exported f_NAME identifier')
    if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*',namespace):raise ValueError('Invalid Rocq namespace')
    source=Path(source).resolve();output=Path(output).resolve()
    if not source.is_file():raise FileNotFoundError(source)
    if output==source.parent:raise ValueError('Use a separate generated output directory')
    exe,library=tool_paths(clightgen,lib)
    target=target_of(library)
    if request:
        fixed=json.loads(Path(request).read_text())
        if fixed.get('purpose')!='execution-translation' or fixed.get('execution_backend')!='compcert-csyntax-cexec' or fixed.get('target')!=target or not fixed.get('domain'):
            raise RuntimeError('Frozen request must select this CompCert target and full execution purpose/domain')
    if (target['arch'],target['model'],target['system'],target['endianness'])!=('x86','64','linux','little'):
        raise RuntimeError('Current FIVE standard is CompCert x86-64 Linux little-endian; explicitly port target before exporting')
    output.mkdir(parents=True,exist_ok=True)
    manifest_path=output/'compcert-manifest.json'
    save(manifest_path,{'schema':SCHEMA,'status':'preparing'})
    run=Run.start(ROOT/'runs','five-align',[('original-c',source)],
      {'kind':'automatic-compcert-export','purpose':'execution-translation','source':ref(source),
       'target':target,'scope':'Generate AST and executable Cexec wrapper, not certify whole-execution correspondence or independent approval'},
      invocation_kind='skill-session' if session else 'tool-replay',usage_session=session)
    cpp=[*[('-I'+str(Path(p).resolve())) for p in include_dirs],*[('-D'+d) for d in defines]]
    try:
        c=run.command([str(exe),*cpp,'-E',str(source)],'compcert-preprocess',cwd=source.parent)
        (output/'preprocessed.i').write_bytes((run.folder/c['stdout']).read_bytes())
        run.command([str(exe),'-csyntax','-o',str(output/'Source.v'),str(output/'preprocessed.i')],
                    'compcert-export-csyntax',cwd=source.parent)
        validate_ast_target((output/'Source.v').read_text(),target)
        (output/'Execution.v').write_text(wrapper(namespace,function))
        (output/'Extraction.v').write_text(f'From Stdlib Require Import Extraction ExtrOcamlBasic ExtrOcamlString.\nFrom {namespace} Require Import Execution.\nExtraction Language OCaml.\nExtraction "{(output/"execution.ml").as_posix()}" entry transitions closed_transitions.\n')
        run.command([sys.executable,str(ROOT/'scripts/generate-obligations.py'),
          '--source-module',namespace+'.Source','--function',function,
          '--precondition-module',namespace+'.proof.Precondition',
          '--output',str(output/'proof/Obligations.v')],
          'generate-pending-safety-termination',cwd=output)
        rocq=shutil.which('rocq')
        if not rocq:raise RuntimeError('Rocq unavailable')
        for name in ['Source','Execution','Extraction']:
            run.command([rocq,'compile','-Q',str(output),namespace,str(output/(name+'.v'))],
                        'compile-'+name,cwd=output)
        # Build the shared proposition definitions in isolation; do not leave
        # library caches or require execution of the exported model.
        with tempfile.TemporaryDirectory(prefix='five-obligation-support-') as td:
            shared=Path(td)/'shared'
            support=shared/'verification/Obligations.v'
            support.parent.mkdir(parents=True)
            shutil.copyfile(ROOT/'shared/verification/Obligations.v',support)
            flags=['-Q',str(output),namespace,'-Q',str(shared),'FiveShared']
            run.command([rocq,'compile',*flags,str(support)],'compile-obligation-definitions',cwd=output)
            for name in ['Precondition','Obligations','Proofs']:
                run.command([rocq,'compile',*flags,str(output/'proof'/(name+'.v'))],
                            'compile-pending-'+name,cwd=output)
            run.command([rocq,'check','-silent',*flags,namespace+'.Source',namespace+'.Execution',
                         namespace+'.proof.Obligations',namespace+'.proof.Proofs'],
                        'kernel-check-generated-wrapper-and-goal-definitions',cwd=output)
        arch='x86_64/Archi.v'
        semantic={str(library/p):sha(library/p) for p in [*SEMANTIC_FILES,arch]}
        files={n:{'path':ref(output/n),'sha256':sha(output/n)} for n in
               ['preprocessed.i','Source.v','Execution.v','Extraction.v','execution.ml',
                'proof/Precondition.v','proof/Obligations.v','proof/Proofs.v']}
        manifest={'schema':SCHEMA,'status':'generated','backend':'compcert-csyntax-cexec',
          'source':{'path':ref(source),'sha256':sha(source)},'cpp_arguments':cpp,'cpp_cwd':str(source.parent),
          'tool':{'path':str(exe),'sha256':sha(exe)},'formal_library':str(library),'semantic_dependencies':semantic,'target':target,
          'namespace':namespace,'function':function,'files':files,
          'ast_semantic_sha256':digest_text(normalized_ast((output/'Source.v').read_text())),
          'request':{'path':ref(request),'sha256':sha(request)} if request else None,
          'generation_run':ref(run.folder),'coverage_status':'pending',
          'generated_obligations':{'schema':'five-pending-obligations/1',
           'goals':['no_error_goal','termination_goal'],
           'precondition_status':'pending-authoring-or-review',
           'proof_status':'not-attempted','status':'generated-and-typechecked',
           'pending_obligations':['LLM-authored explicit precondition','no-error proof','all-executions termination proof'],
           'generation_scope':'Parameterized propositions only; no concrete precondition or proof inferred',
           'dependencies':{ref(ROOT/p):sha(ROOT/p) for p in
             ['scripts/generate-obligations.py','shared/verification/Obligations.v']}},
          'pending_obligations':['source/frontend trust boundary','all-reachable Cexec/Csem correspondence',
           'external callbacks, builtins and world coverage','normal/error and byte observations',
           'CBMC specification re-verification in Rocq','all alignment issues resolved'],
          'execution_modes':{'relation':'original Csem','step':'original Cexec.do_step with all successors',
           'rocq_vm':'not guaranteed; opaque memory-permission well-founded proofs may obstruct reduction',
           'extraction':'execution.ml generated by standard Rocq Extraction; runtime/toolchain is a separate trust boundary'}}
        save(manifest_path,manifest)
        run.finish('passed','CompCert model and parameterized safety/termination targets generated and checked. Precondition authoring and program proofs were not attempted; full delivery remains pending.',
          {'manifest':manifest_path,'ast':output/'Source.v','execution':output/'Execution.v',
           'precondition-interface':output/'proof/Precondition.v',
           'unproved-goals':output/'proof/Obligations.v','proof-authoring-file':output/'proof/Proofs.v'})
        return manifest
    except Exception as exc:
        save(manifest_path,{'schema':SCHEMA,'status':'failed','reason':str(exc),'generation_run':ref(run.folder)})
        run.finish('failed',str(exc),{});raise

def audit(manifest_path,run=None):
    manifest_path=Path(manifest_path).resolve();m=json.loads(manifest_path.read_text())
    if m.get('schema')!=SCHEMA or m.get('status')!='generated' or m.get('backend')!='compcert-csyntax-cexec':
        raise RuntimeError('Missing successful automatic CompCert export')
    bindings={ref(manifest_path):sha(manifest_path)}
    library=Path(m['formal_library'])
    expected_dependencies={str(library/p) for p in [*SEMANTIC_FILES,'x86_64/Archi.v']}
    if set(m['semantic_dependencies'])!=expected_dependencies or target_of(library)!=m['target']:
        raise RuntimeError('Incomplete/mismatched CompCert semantics or target configuration')
    for row in [m['source'],m['tool'],*m['files'].values()]:
        p=resolve(row['path'])
        if not p.is_file() or sha(p)!=row['sha256']:raise RuntimeError('Stale CompCert input/output/tool: '+str(p))
        bindings[ref(p)]=row['sha256']
    for name,digest in m['semantic_dependencies'].items():
        if sha(resolve(name))!=digest:raise RuntimeError('Stale CompCert semantic dependency: '+name)
        bindings[ref(name)]=digest
    if m.get('request'):
        row=m['request']
        if sha(resolve(row['path']))!=row['sha256']:raise RuntimeError('Changed original request')
        bindings[row['path']]=row['sha256']
    expected=wrapper(m['namespace'],m['function'])
    validate_ast_target(resolve(m['files']['Source.v']['path']).read_text(),m['target'])
    if resolve(m['files']['Execution.v']['path']).read_text()!=expected:
        raise RuntimeError('Execution wrapper is not the original Cexec embedding template')
    if m.get('generated_obligations'):
        from importlib.util import spec_from_file_location,module_from_spec
        spec=spec_from_file_location('five_obligation_generator',ROOT/'scripts/generate-obligations.py')
        generator=module_from_spec(spec);spec.loader.exec_module(generator)
        templates=generator.pending_templates(m['namespace']+'.Source','prog',m['function'],
                                             m['namespace']+'.proof.Precondition')
        expected_deps={ref(ROOT/p) for p in
          ['scripts/generate-obligations.py','shared/verification/Obligations.v']}
        deps=m['generated_obligations']['dependencies']
        if set(deps)!=expected_deps:raise RuntimeError('Incomplete obligation generator dependencies')
        for name,digest in deps.items():
            if sha(resolve(name))!=digest:raise RuntimeError('Stale obligation dependency: '+name)
            bindings[name]=digest
        for name in ['Precondition.v','Obligations.v','Proofs.v']:
            if 'proof/'+name not in m['files']:raise RuntimeError('Missing pending-goal artifact: '+name)
        if resolve(m['files']['proof/Obligations.v']['path']).read_text()!=templates['Obligations.v']:
            raise RuntimeError('Generated obligations differ from the Csem template')
    # Re-export independently: matching hashes alone do not establish AST origin.
    owns=run is None
    if owns:
        run=Run.start(ROOT/'runs','five-align',[],{'kind':'compcert-provenance-audit','scope':'Fresh preprocessing and AST comparison; not whole-execution certification'},invocation_kind='tool-replay')
    try:
        with tempfile.TemporaryDirectory(prefix='compcert-audit-',dir=ROOT/'_build') as td:
            temp=Path(td)
            c=run.command([m['tool']['path'],*m['cpp_arguments'],'-E',str(resolve(m['source']['path']))],
                          'audit-preprocess',cwd=m['cpp_cwd'])
            pre=(run.folder/c['stdout']).read_bytes()
            if hashlib.sha256(pre).hexdigest()!=m['files']['preprocessed.i']['sha256']:
                raise RuntimeError('Preprocessing/header/configuration drift')
            (temp/'preprocessed.i').write_bytes(pre)
            run.command([m['tool']['path'],'-csyntax','-o',str(temp/'Source.v'),str(temp/'preprocessed.i')],
                        'audit-export-csyntax',cwd=m['cpp_cwd'])
            if digest_text(normalized_ast((temp/'Source.v').read_text()))!=m['ast_semantic_sha256']:
                raise RuntimeError('Exported Csyntax AST differs from frozen original program')
        if owns:run.finish('passed','CompCert provenance freshly audited; no delivery approval issued.',{'manifest':manifest_path})
        return {'status':'passed','bindings':bindings,'delivery_accepted':False}
    except Exception as exc:
        if owns:run.finish('failed',str(exc),{})
        raise
