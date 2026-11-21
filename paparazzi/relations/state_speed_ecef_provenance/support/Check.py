#!/usr/bin/env python3
"""Cold-check worker-supplied ECEF-speed proof bindings, without authoring goals.

Each numbered attempt's check.py supplies IMPORTS, BINDINGS and OUTCOME.
--all shares one immutable source build across the current attempts. Publishing
requires successful full compilation, both independent kernels and unchanged
sources. Ordinary replay never replaces published evidence.
"""
from pathlib import Path
import argparse, ast, hashlib, json, re, resource, shlex, shutil, sys
from datetime import datetime, timezone

ROOT=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
REL=ROOT/'paparazzi/relations/state_speed_ecef_provenance'
CASES=[ROOT/'paparazzi/models'/n for n in ('stateSetSpeedNed_i','stateSetSpeedEcef_i','stateGetSpeedEcef_f')]
sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
from example_proof_gate import certificate_source, input_index

BASE_PAIRS=[
 ('shared','FiveShared'),
 ('paparazzi/relations/guidance_mode/support/semantics','FiveGuidanceSemantics'),
 ('paparazzi/relations/guidance_mode/support/allocation','FiveGuidanceAllocation'),
 ('paparazzi/relations/guidance_mode/support/entry','FiveGuidanceEntry'),
 ('paparazzi/relations/guidance_mode/support/allorder','FiveGuidanceAllOrder'),
 ('paparazzi/models/stateSetSpeedNed_i/align/model','StateSpeedSetNedI'),
 ('paparazzi/models/stateSetSpeedEcef_i/align/model','StateSpeedSetEcefI'),
 ('paparazzi/models/stateGetSpeedEcef_f/align/model','StateSpeedGetEcefF'),
 ('paparazzi/relations/state_speed_ecef_provenance/support','StateSpeedMemory'),
 ('paparazzi/relations/state_speed_ecef_provenance/support/setters','StateSpeedSetterSupport'),
 ('paparazzi/models/stateSetSpeedNed_i/rocq/support','StateSpeedSetNedISupport'),
 ('paparazzi/models/stateSetSpeedEcef_i/rocq/support','StateSpeedSetEcefISupport'),
 ('paparazzi/models/stateGetSpeedEcef_f/rocq/support','StateSpeedGetterSupport')]

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rel(p): return str(Path(p).resolve().relative_to(ROOT))
def dump(p,d):
 p=Path(p);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
def read(p): return json.loads(Path(p).read_text())
def configuration(checker):
 """Read literal administrative configuration; never execute the wrapper."""
 checker=Path(checker).resolve(); values={}
 for node in ast.parse(checker.read_text()).body:
  if isinstance(node,ast.Assign):
   for target in node.targets:
    if isinstance(target,ast.Name) and target.id in ('IMPORTS','BINDINGS','OUTCOME'):
     values[target.id]=ast.literal_eval(node.value)
 imports=values.get('IMPORTS');bindings=values.get('BINDINGS');outcome=values.get('OUTCOME','proved')
 if not isinstance(imports,list) or len(imports)!=2 or not imports[0].endswith('.Spec') or not imports[1].endswith('.Proof'):
  raise ValueError('Wrapper must supply exact Spec and Proof imports: '+str(checker))
 if not isinstance(bindings,list) or not bindings or outcome not in ('proved','refuted'):
  raise ValueError('Missing explicit bindings/outcome: '+str(checker))
 attempt=checker.parent;problem=attempt.parent.parent/'problem';status=read(problem/'status.json')
 if (problem/status['active_attempt']).resolve()!=attempt:
  raise ValueError('Checker is not the canonical active attempt: '+str(checker))
 if status['requested_goals']!=[b['requested_goal'] for b in bindings]:
  raise ValueError('Exact requested goals differ from worker bindings: '+str(checker))
 if not all(isinstance(b.get('theorem'),str) and isinstance(b.get('type'),str) for b in bindings):
  raise ValueError('Missing worker-supplied theorem or expected type')
 return dict(checker=checker,attempt=attempt,problem=problem,imports=imports,bindings=bindings,outcome=outcome)

def configurations(require_all=False):
 problems=[p for c in CASES for p in sorted((c/'rocq').glob('*/problem'))]
 if (REL/'problem').is_dir(): problems.append(REL/'problem')
 if require_all:
  expected=[c/'rocq'/n/'problem' for c in CASES for n in ('no_error','termination','execution_correspondence','cbmc_recheck')]
  expected.extend([CASES[2]/'rocq/functional/problem',REL/'problem'])
  if not all(p in problems for p in expected):raise ValueError('The complete 14-problem batch is not yet packaged')
 groups=[]
 for problem in problems:
  if not (problem/'status.json').is_file():
   if require_all:raise ValueError('Unpackaged problem: '+str(problem))
   continue
  status=read(problem/'status.json')
  wrapper=(problem/status['active_attempt']).resolve()/'check.py'
  if not wrapper.is_file():
   if require_all:raise ValueError('Missing checker: '+str(wrapper))
   continue
  groups.append(configuration(wrapper))
 return groups

def namespace(path,pairs):
 choices=[(len(str(ROOT/d)),d,n) for d,n in pairs if Path(path).resolve().is_relative_to(ROOT/d)]
 if not choices: raise ValueError('Missing logical namespace: '+str(path))
 _,d,n=max(choices)
 return n+'.'+'.'.join(Path(path).resolve().relative_to(ROOT/d).with_suffix('').parts)

def frozen_inputs():
 files={Path(__file__).resolve():sha(__file__)};semantics={}
 for name in ('example_proof_gate.py','five_telemetry.py'):
  p=ROOT/'scripts'/name;files[p]=sha(p)
 for case in CASES:
  for stage in ('prepare','cbmc','align'):
   handoff=case/stage/'handoff.json';data=read(handoff)
   if data.get('schema')!='five-stage-handoff/1' or data.get('paths_relative_to')!='case':
    raise ValueError('Unsupported frozen stage handoff: '+str(handoff))
   files[handoff]=sha(handoff)
   for row in data['outputs']:
    p=(case/row['path']).resolve()
    if not p.is_relative_to(ROOT) or not p.is_file() or sha(p)!=row['sha256']:
     raise ValueError('Changed original stage artifact: '+str(p))
    files[p]=row['sha256']
  manifest=read(case/'align/model/compcert-manifest.json')
  pinned=manifest.get('semantic_dependencies')
  if not isinstance(pinned,dict) or not pinned: raise ValueError('Unpinned CompCert semantics')
  for name,digest in pinned.items():
   p=Path(name)
   if not p.is_absolute() or not p.is_file() or sha(p)!=digest: raise ValueError('Changed semantics: '+name)
   if name in semantics and semantics[name]!=digest: raise ValueError('Conflicting semantics pin')
   semantics[name]=digest
 return files,semantics

def source_order(run,pairs,roots):
 flags=[x for d,n in pairs for x in ('-Q',d,n)]
 files=set();exclude={'evidence','runs','inputs','checked','__pycache__','cold-checks'}
 for d,_ in pairs:
  base=ROOT/d
  if not base.is_dir(): continue
  for p in base.rglob('*.v'):
   if not set(p.relative_to(base).parts)&exclude and re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*',p.stem): files.add(p.resolve())
 cmd=run.command(['rocq','dep',*flags,*[rel(p) for p in sorted(files)]],'cold-proof-dependency-graph',timeout=120,cwd=ROOT)
 if cmd['status']!='passed': raise RuntimeError('Dependency graph failed: '+cmd['id'])
 graph={}
 for line in (run.folder/cmd['stdout']).read_text().replace('\\\n','').splitlines():
  if ':' not in line: continue
  lhs,rhs=line.split(':',1);targets=shlex.split(lhs)
  if targets and targets[0].endswith('.vo'):
   source=(ROOT/targets[0]).with_suffix('.v').resolve()
   graph[source]=[(ROOT/x).with_suffix('.v').resolve() for x in shlex.split(rhs)
    if x.endswith('.vo') and (ROOT/x).with_suffix('.v').is_file() and (ROOT/x).resolve().is_relative_to(ROOT)]
 order=[];visiting=set();done=set()
 def visit(p):
  p=p.resolve()
  if p in done:return
  if p in visiting:raise ValueError('Cyclic local import: '+str(p))
  if p not in graph:raise ValueError('Missing dependency declaration: '+str(p))
  visiting.add(p)
  for child in graph[p]:visit(child)
  visiting.remove(p);done.add(p);order.append(p)
 for p in roots:visit(p)
 return order

def main(default_checker=None):
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--run',type=Path);parser.add_argument('--publish',action='store_true')
 parser.add_argument('--all',action='store_true');parser.add_argument('--plan',action='store_true')
 parser.add_argument('--timeout',type=int,default=900);args=parser.parse_args()
 if args.timeout<=0:parser.error('Timeout must be positive')
 cap=3*1024**3;resource.setrlimit(resource.RLIMIT_AS,(cap,cap))
 owned=args.run is None
 run=Run.start(ROOT/'_build/state-speed-cold-replays','five-rocq',[],
  {'role':'tool-only reproduction; exact worker-authored goals, no mathematical authoring'},
  invocation_kind='tool-only') if owned else Run(args.run)
 if run.read('run.json')['status']!='running':raise ValueError('Cannot append to a closed run')
 run.evidence('cold-check-resource-cap.json',{'RLIMIT_AS_bytes':cap,'method':'outer Python limit inherited by unchanged direct rocq argv'})
 try:
  all_groups=configurations(require_all=args.all)
  if args.all:groups=all_groups
  elif default_checker:groups=[configuration(default_checker)]
  else:parser.error('Use a numbered attempt/check.py or --all')
  pairs=list(BASE_PAIRS)
  for g in all_groups:
   pairs.extend([(rel(g['problem']),g['imports'][0].rsplit('.',1)[0]),(rel(g['attempt']),g['imports'][1].rsplit('.',1)[0])])
  if len({n for _,n in pairs})!=len(pairs):raise ValueError('Duplicate logical namespaces')
  frozen,semantics=frozen_inputs()
  for g in groups:
   frozen[g['checker']]=sha(g['checker'])
   if not args.publish and not args.plan and (g['attempt']/'provenance.json').is_file():
    _,old=input_index(ROOT,g['attempt'])
    for p,h in old.items():
     if sha(p)!=h:raise ValueError('Published input changed: '+str(p))
  roots=[g['attempt']/'Proof.v' for g in groups];order=source_order(run,pairs,roots)
  if args.plan:
   p=run.folder/'evidence/state-speed-dependency-plan.json';dump(p,{'sources':[rel(p)for p in order],'goals':sum(len(g['bindings'])for g in groups)})
   if owned:run.finish('passed','Dependency plan only; no proof claim.',{'plan':p})
   print(p.read_text());return
  stamp=datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%f')
  base=(REL/'evidence/cold-checks' if args.publish else ROOT/'_build/state-speed-cold-replays')/stamp
  checked=base/'checked';current={p:sha(p)for p in order};snapshots={}
  # Gate receipts must bind the original C and canonical generated model, in
  # addition to the byte-identical .v copies actually compiled below.
  for p,h in {**frozen,**current}.items():
   run.capture(p,'canonical-'+stamp+'-'+hashlib.sha256(rel(p).encode()).hexdigest()[:18],area='inputs')
  for p,h in current.items():
   dest=checked/rel(p);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
   if sha(dest)!=h:raise ValueError('Source changed while snapshotting: '+str(p))
   snapshots[p]=dest;run.capture(dest,'cold-'+stamp+'-'+hashlib.sha256(rel(p).encode()).hexdigest()[:18],area='inputs')
  flags=[x for d,n in pairs for x in ('-Q',rel(checked/d),n)]
  def command(argv,label):
   result=run.command(argv,label,timeout=args.timeout,cwd=ROOT)
   if result['status']!='passed' or result['exit_code']!=0:raise RuntimeError('Cold check failed: '+result['id'])
   return result
  for p in order:command(['rocq','compile','-q',*flags,rel(snapshots[p])],'cold-compile-'+p.stem)
  theorem_names=list(dict.fromkeys(b['theorem'] for g in groups for b in g['bindings']))
  modules=list(dict.fromkeys(n.rsplit('.',1)[0]for n in theorem_names))
  kernel=command(['rocq','check','-silent',*flags,*modules],'cold-independent-proof-kernel')
  hashes={rel(snapshots[p]):h for p,h in current.items()}
  proof_receipt=base/'proof-kernel-evidence.json'
  dump(proof_receipt,{'kind':'rocq-kernel-check','run':rel(run.folder),'command_id':kernel['id'],
   'theorems':theorem_names,'statement_artifacts':[rel(snapshots[p])for p in roots],'dependency_sha256':hashes})
  source_bound_receipt=base/'source-bound-kernel-evidence.json'
  dump(source_bound_receipt,{'kind':'rocq-kernel-check','run':rel(run.folder),'command_id':kernel['id'],
   'theorems':theorem_names,'statement_artifacts':[rel(snapshots[p])for p in roots],
   'dependency_sha256':{**hashes,**{rel(p):h for p,h in {**frozen,**current}.items()}},
   'canonical_to_compiled_snapshot':[{ 'source':rel(p),'snapshot':rel(snapshots[p]),'sha256':h}for p,h in current.items()],
   'scope':'Same actual independent kernel; canonical C/model inputs were captured in this run and hash-equal .v source snapshots were fully compiled. Canonical proof-goal validation separately binds every source-to-snapshot pair.'})
  certificates=[]
  for g in groups:
   target=checked/rel(g['attempt'])/'GoalBinding.v';target.write_text(certificate_source(g['imports'],g['bindings']))
   run.capture(target,'cold-certificate-'+hashlib.sha256(rel(target).encode()).hexdigest()[:18],area='inputs')
   compiled=command(['rocq','compile','-q',*flags,rel(target)],'cold-exact-goalbinding')
   certificates.append((g,target,compiled,namespace(g['attempt']/'GoalBinding.v',pairs)))
  cert_kernel=command(['rocq','check','-silent',*flags,*[c[3]for c in certificates]],'cold-independent-goalbinding-kernel')
  for p,h in {**frozen,**current}.items():
   if sha(p)!=h:raise ValueError('Input changed during cold check: '+str(p))
  # Recheck pinned semantics and all originally consumed stage files separately.
  fresh,semantics_now=frozen_inputs()
  if semantics_now!=semantics or any(fresh.get(p)!=h for p,h in frozen.items() if p in fresh):
   raise ValueError('Frozen model/source inputs changed during cold check')
  for g,target,compiled,module in certificates:
   cert_receipt=target.parent/'certificate-kernel-evidence.json'
   dump(cert_receipt,{'kind':'rocq-kernel-check','run':rel(run.folder),'command_id':cert_kernel['id'],
    'theorems':[module+'.goal_'+str(i)for i in range(len(g['bindings']))],
    'statement_artifacts':[rel(target)],'dependency_sha256':{**hashes,rel(target):sha(target)}})
   if args.publish:
    index=g['attempt']/'provenance.json'
    if (g['attempt']/'inputs.json').exists():raise ValueError('Competing input indexes')
    indexed={rel(p):h for p,h in {**current,**frozen}.items()}
    dump(index,{'schema':'five-proof-inputs/1','dependency_sha256':indexed,'semantic_dependencies':semantics})
    rows=[{'path':p,'sha256':h,**({'snapshot':rel(snapshots[ROOT/p])}if ROOT/p in snapshots else{})}for p,h in sorted(indexed.items())]
    dump(g['attempt']/'evidence/goal-validation.json',{'schema':'five-proof-validation/1','index':{'path':rel(index),'sha256':sha(index)},
     'inputs':rows,'kernel_evidence':rel(proof_receipt),'source_bound_kernel_evidence':rel(source_bound_receipt),'goal_bindings':g['bindings'],
     'certificate':{'path':rel(target),'sha256':sha(target),'module':module,'imports':g['imports'],
      'run':rel(run.folder),'compile_command_id':compiled['id'],'kernel_command_id':cert_kernel['id'],'kernel_evidence':rel(cert_receipt)}})
    status=read(g['problem']/'status.json')
    if status['requested_goals']!=[b['requested_goal']for b in g['bindings']]:raise ValueError('Canonical goal list changed')
    status.update(status=g['outcome'],goal_status={b['requested_goal']:b.get('outcome','proved')for b in g['bindings']})
    dump(g['problem']/'status.json',status)
  summary={'status':'passed','sources':len(order),'attempts':len(groups),'goals':len(theorem_names),'proof_kernel':rel(proof_receipt),'run':rel(run.folder)}
  print(json.dumps(summary,indent=2))
  if owned:run.finish('passed','Cold snapshots, exact typed worker goals and independent kernels passed.',{'kernel':proof_receipt})
 except BaseException:
  if owned and run.read('run.json')['status']=='running':
   note=run.folder/'evidence/checker-failure.json';dump(note,{'status':'failed','note':'Inspect actual command logs; no new proof acceptance.'})
   run.finish('failed','Cold checker did not complete.',{'failure':note})
  raise

if __name__=='__main__':main()
