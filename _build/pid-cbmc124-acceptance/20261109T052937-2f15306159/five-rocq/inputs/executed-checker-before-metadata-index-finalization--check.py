#!/usr/bin/env python3
"""Rebuild only the unchanged original PID all124 CBMC proof closure.

Run source scripts/env.sh first. --publish writes current003 receipts;
normal replay checks the same sources without changing published evidence.
All actual source inputs are captured by the metered run. Original source
paths are the checked snapshots, so no second delivered source tree exists.
"""
from pathlib import Path
import argparse, hashlib, importlib.util, json, re, shlex, sys
ATTEMPT = Path(__file__).resolve().parent
ROOT = ATTEMPT.parents[6]
sys.path.insert(0, str(ROOT / 'scripts'))
from five_telemetry import Run
from example_proof_gate import certificate_source, input_index

def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def relative(p): return str(Path(p).resolve().relative_to(ROOT))
def dump(p,d):
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--run',type=Path)
    ap.add_argument('--publish',action='store_true')
    ap.add_argument('--plan',action='store_true')
    ap.add_argument('--timeout',type=int,default=1800)
    args=ap.parse_args()
    original=ROOT/'paparazzi/relations/pid_position_translation/attempts/002/check.py'
    spec=importlib.util.spec_from_file_location('pid_existing_checker',original)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    pairs=[(d,n) for d,n in mod.config() if '/rocq/no_error/' not in d and '/rocq/termination/' not in d and not d.endswith('/cbmc_recheck/attempts/002')]
    pairs.append((relative(ATTEMPT),'PidPositionRunPosCBMCAttempt003'))
    flags=[x for d,n in pairs for x in ['-Q',d,n]]
    old=json.loads((ATTEMPT.parent/'002/evidence/expected-bindings.json').read_text())
    bindings=[{k:v.replace('PidPositionRunPosCBMCAttempt002','PidPositionRunPosCBMCAttempt003') if isinstance(v,str) else v for k,v in b.items()} for b in old['bindings']]
    imports=[n.replace('PidPositionRunPosCBMCAttempt002','PidPositionRunPosCBMCAttempt003') for n in old['imports']]
    problem=ATTEMPT.parents[1]/'problem'
    goals=json.loads((problem/'status.json').read_text())['requested_goals']
    if len(bindings)!=124 or [b['requested_goal'] for b in bindings]!=goals: raise ValueError('Original all124 goal ledger mismatch')
    owned=args.run is None
    run=Run(args.run.resolve()) if args.run else Run.start(ROOT/'_build/pid-cbmc124-replays','five-rocq',[],{'scope':'tool-only unchanged all124 proof replay'},invocation_kind='tool-only')
    if run.read('run.json')['status']!='running': raise ValueError('Closed run cannot be extended')
    try:
        if not args.publish and (ATTEMPT/'provenance.json').exists():
            _,index=input_index(ROOT,ATTEMPT)
            for p,h in index.items():
                if digest(p)!=h: raise ValueError('Published source changed: '+str(p))
        excluded={'runs','inputs','checked','exploratory','__pycache__','cold-checks','evidence'}
        files=set()
        for d,n in pairs:
            base=ROOT/d
            for p in base.rglob('*.v'):
                if not (set(p.relative_to(base).parts)&excluded) and re.fullmatch('[A-Za-z_][A-Za-z_0-9]*',p.stem): files.add(p.resolve())
        dep=run.command(['rocq','dep',*flags,*[relative(p) for p in sorted(files)]],'cbmc124-dependency-graph',timeout=120,cwd=ROOT)
        graph={}
        for line in (run.folder/dep['stdout']).read_text().replace('\\\n','').splitlines():
            if ':' not in line: continue
            lhs,rhs=line.split(':',1);targets=shlex.split(lhs)
            if targets and targets[0].endswith('.vo'):
                p=(ROOT/targets[0]).with_suffix('.v').resolve()
                graph[p]=[(ROOT/x).with_suffix('.v').resolve() for x in shlex.split(rhs) if x.endswith('.vo') and (ROOT/x).with_suffix('.v').is_file()]
        order=[];done=set();visiting=set()
        def visit(p):
            p=p.resolve()
            if p in done:return
            if p in visiting or not p.is_relative_to(ROOT) or '/attempts/001/' in str(p) or p not in graph: raise ValueError('Invalid original dependency: '+str(p))
            visiting.add(p)
            for q in graph[p]:visit(q)
            visiting.remove(p);done.add(p);order.append(p)
        visit(ATTEMPT/'Proof.v')
        if args.plan:
            print(json.dumps({'sources':[relative(p) for p in order],'count':len(order)},indent=2))
            if owned:run.finish('passed','Dependency plan only.',{})
            return
        current={p:digest(p) for p in order}
        print('CBMC124 sources:',len(order),flush=True)
        for p,h in current.items():run.capture(p,'cbmc124-source-'+hashlib.sha256(relative(p).encode()).hexdigest()[:20],area='inputs')
        for i,p in enumerate(order):
            run.command(['rocq','compile','-q',*flags,relative(p)],'cbmc124-compile-'+p.stem,timeout=args.timeout,cwd=ROOT)
            print('compiled',i+1,'/',len(order),relative(p),flush=True)
        names=[b['theorem'] for b in bindings]
        kernel=run.command(['rocq','check','-silent',*flags,'PidPositionRunPosCBMCAttempt003.Proof'],'cbmc124-independent-proof-kernel',timeout=args.timeout,cwd=ROOT)
        hashes={relative(p):h for p,h in current.items()}
        evidence=ATTEMPT/'evidence' if args.publish else run.folder/'evidence'
        proof_receipt=evidence/'kernel-check.json'
        dump(proof_receipt,{'kind':'rocq-kernel-check','run':relative(run.folder),'command_id':kernel['id'],'theorems':names,'statement_artifacts':[relative(ATTEMPT/'Proof.v')],'dependency_sha256':hashes})
        target=ATTEMPT/'GoalBinding.v'
        # The standard gate requires this exact deterministic certificate text.
        text=certificate_source(imports,bindings)
        if target.exists() and target.read_text()!=text: raise ValueError('Certificate changed')
        target.write_text(text)
        run.capture(target,'cbmc124-exact-goal-certificate',area='inputs')
        print('all124 proof kernel passed; starting exact certificate and assumptions',flush=True)
        compile_cmd=run.command(['rocq','compile','-q',*flags,relative(target)],'cbmc124-exact-goalbinding-assumptions',timeout=args.timeout,cwd=ROOT)
        print('all124 exact certificate and assumptions passed; starting independent certificate kernel',flush=True)
        cert_module='PidPositionRunPosCBMCAttempt003.GoalBinding'
        ck=run.command(['rocq','check','-silent',*flags,cert_module],'cbmc124-exact-goalbinding-kernel',timeout=args.timeout,cwd=ROOT)
        cert_receipt=evidence/'certificate-kernel-check.json'
        dump(cert_receipt,{'kind':'rocq-kernel-check','run':relative(run.folder),'command_id':ck['id'],'theorems':[cert_module+'.goal_'+str(i) for i in range(124)],'statement_artifacts':[relative(target)],'dependency_sha256':{**hashes,relative(target):digest(target)}})
        for p,h in current.items():
            if digest(p)!=h:raise ValueError('Source changed during proof: '+str(p))
        if args.publish:
            manifest=ROOT/'paparazzi/models/guidance_pid_h_run_pos/align/model/compcert-manifest.json'
            indexed=dict(hashes)
            extras=[Path(__file__).resolve(),original,original.parent/'core/BuildConfiguration.py',manifest,ROOT/'scripts/example_proof_gate.py',ROOT/'scripts/compcert_gate.py',ROOT/'paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c',ROOT/'paparazzi/models/guidance_pid_h_run_pos/prepare/source/bindings.json']
            for p in extras:indexed[relative(p)]=digest(p)
            index=ATTEMPT/'provenance.json'
            dump(index,{'schema':'five-proof-inputs/1','dependency_sha256':indexed,'semantic_dependencies':json.loads(manifest.read_text())['semantic_dependencies']})
            validation=evidence/'goal-validation.json'
            dump(validation,{'schema':'five-proof-validation/1','index':{'path':relative(index),'sha256':digest(index)},'inputs':[{'path':p,'sha256':h,**({'snapshot':p} if ROOT/p in current else {})} for p,h in sorted(indexed.items())],'kernel_evidence':relative(proof_receipt),'goal_bindings':bindings,'certificate':{'path':relative(target),'sha256':digest(target),'module':cert_module,'imports':imports,'run':relative(run.folder),'compile_command_id':compile_cmd['id'],'kernel_command_id':ck['id'],'kernel_evidence':relative(cert_receipt)}})
        print(json.dumps({'status':'passed','sources':len(order),'goals':124,'run':relative(run.folder),'kernel_evidence':relative(proof_receipt)},indent=2),flush=True)
        if owned:run.finish('passed','All124 exact theorem bindings, assumptions and independent kernel passed.',{'kernel':proof_receipt,'certificate_kernel':cert_receipt})
    except BaseException:
        if owned and run.read('run.json')['status']=='running':run.finish('failed','All124 checker did not complete; actual failure retained.',{})
        raise
if __name__=='__main__':main()
