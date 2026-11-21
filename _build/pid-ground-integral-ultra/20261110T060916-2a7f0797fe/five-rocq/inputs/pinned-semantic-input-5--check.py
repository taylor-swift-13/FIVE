#!/usr/bin/env python3
"""Rebuild the focused original dependency closure, check kernels and bind exact goals.

Run from repository root after source scripts/env.sh. --run appends to an open
real authoring session. Default replay creates a distinct tool-only record and
leaves the published evidence unchanged. --publish installs fresh receipts.
"""
from pathlib import Path
import argparse,hashlib,importlib.util,json,re,shlex,sys
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parents[5]
ATTEMPT=Path(__file__).resolve().parent
PROBLEM=ATTEMPT.parents[1]/'problem'
sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
from example_proof_gate import certificate_source,input_index
OWNED_RUN=None

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rel(p):return str(Path(p).resolve().relative_to(ROOT))
def dump(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n')
def configuration():
 p=ROOT/'paparazzi/relations/pid_position_translation/attempts/002/core/BuildConfiguration.py'
 s=importlib.util.spec_from_file_location('old_pid_config',p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
 return m.LOADPATHS+[(rel(PROBLEM),'PidGroundIntegralProblem'),(rel(ATTEMPT),'PidGroundIntegralAttempt001')]
def closure(run,pairs,flags):
 files=[]
 for d,_ in pairs:
  for p in (ROOT/d).rglob('*.v'):
   if not set(p.relative_to(ROOT/d).parts)&{'runs','inputs','checked','exploratory','__pycache__','cold-checks'} and re.fullmatch('[A-Za-z_][A-Za-z_0-9]*',p.stem):files.append(rel(p))
 c=run.command(['rocq','dep',*flags,*sorted(files)],'focused-dependency-graph',timeout=120,cwd=ROOT)
 graph={}
 for line in (run.folder/c['stdout']).read_text().replace('\\\n','').splitlines():
  if ':' not in line:continue
  lhs,rhs=line.split(':',1);ts=shlex.split(lhs)
  if ts and ts[0].endswith('.vo'):
   graph[ts[0][:-3]+'.v']=[i[:-3]+'.v' for i in shlex.split(rhs) if i.endswith('.vo') and (ROOT/(i[:-3]+'.v')).is_file()]
 order=[];seen=set()
 def visit(p):
  if p in seen:return
  seen.add(p)
  for d in graph[p]:visit(d)
  order.append(p)
 visit(rel(ATTEMPT/'Proof.v'))
 return order

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--run',type=Path);ap.add_argument('--publish',action='store_true')
 ap.add_argument('--reuse-compiled-in-run',action='store_true',help='publication only: require all current sources actually compiled in this same open run')
 args=ap.parse_args();owned=args.run is None
 global OWNED_RUN
 run=Run(args.run) if args.run else Run.start(ROOT/'_build/pid-ground-integral-replays','five-rocq',[],{'scope':'tool-only full proof reproduction; no model authoring'},invocation_kind='tool-only')
 OWNED_RUN=run if owned else None
 if run.read('run.json')['status']!='running':raise ValueError('closed historical run')
 old_attempt=ROOT/'paparazzi/relations/pid_position_translation/attempts/002'
 _,old_inputs=input_index(ROOT,old_attempt)
 for p,h in old_inputs.items():
  if sha(p)!=h:raise ValueError('frozen original proof/model input changed: '+str(p))
 original_c=ROOT/'paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c'
 if sha(original_c)!='8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04':raise ValueError('original C hash changed')
 if (ATTEMPT/'provenance.json').is_file() and not args.publish:
  _,current_inputs=input_index(ROOT,ATTEMPT)
  for p,h in current_inputs.items():
   if sha(p)!=h:raise ValueError('published input changed: '+str(p))
 pairs=configuration();flags=[x for d,n in pairs for x in ['-Q',d,n]];order=closure(run,pairs,flags)
 sources={ROOT/p:sha(ROOT/p) for p in order}
 if args.reuse_compiled_in_run:
  if not(args.publish and args.run):raise ValueError('reuse only for publication into same actual authoring run')
  compiled={str((Path(c['cwd'])/v).resolve()) for c in run.read('commands.json') if c['status']=='passed' and c['argv'][:2]==['rocq','compile'] for v in c['argv'] if v.endswith('.v')}
  if not all(str(p.resolve()) in compiled and p.with_suffix('.vo').exists() for p in sources):raise ValueError('current dependency missing actual same-run compilation')
  for p in sources:
   if p.is_relative_to(ATTEMPT.parents[1]):
    run.command(['rocq','compile','-q',*flags,rel(p)],'fresh-owned-compile-'+p.stem,timeout=900,cwd=ROOT)
 else:
  for p in sources:
   print('Compile',rel(p),flush=True)
   run.command(['rocq','compile','-q',*flags,rel(p)],'compile-'+p.stem,timeout=900,cwd=ROOT)
 names=['ground_integral_independence','ground_relational_frame','ground_no_error','ground_all_successor_termination','ground_different_integrals_nonvacuity']
 goals=json.loads((PROBLEM/'status.json').read_text())['requested_goals']
 if len(goals)!=len(names):raise ValueError('unexpected requested goal count')
 bindings=[{'requested_goal':g,'theorem':'PidGroundIntegralAttempt001.Proof.'+n,'type':'PidGroundIntegralProblem.Spec.'+g} for g,n in zip(goals,names)]
 kernel=run.command(['rocq','check','-silent',*flags,'PidGroundIntegralAttempt001.Proof'],'independent-proof-kernel',timeout=360,cwd=ROOT)
 certificate=ATTEMPT/'GoalBinding.v';imports=['PidGroundIntegralProblem.Spec','PidGroundIntegralAttempt001.Proof']
 expected=certificate_source(imports,bindings)
 if args.publish:certificate.write_text(expected)
 elif certificate.read_text()!=expected:raise ValueError('published certificate differs from exact current goals')
 run.capture(certificate,'exact-goalbinding',area='inputs')
 cc=run.command(['rocq','compile','-q',*flags,rel(certificate)],'exact-goalbinding',timeout=360,cwd=ROOT)
 ck=run.command(['rocq','check','-silent',*flags,'PidGroundIntegralAttempt001.GoalBinding'],'independent-goalbinding-kernel',timeout=360,cwd=ROOT)
 if any(sha(p)!=h for p,h in sources.items()):raise ValueError('source changed during actual proof build')
 if args.publish:
  model=ROOT/'paparazzi/models/guidance_pid_h_run_pos'
  manifests=[model/'prepare/source/guidance_pid_h_run_pos.c',model/'prepare/source/bindings.json',model/'align/model/compcert-manifest.json',model/'align/handoff.json',old_attempt/'provenance.json',Path(__file__).resolve()]
  manifest=json.loads((model/'align/model/compcert-manifest.json').read_text())
  index={rel(p):h for p,h in sources.items()};index.update({rel(p):sha(p) for p in manifests})
  dump(ATTEMPT/'provenance.json',{'schema':'five-proof-inputs/1','dependency_sha256':index,'semantic_dependencies':manifest['semantic_dependencies'],'model_configuration':rel(model/'align/model/compcert-manifest.json'),'source_semantics':'original Csem, unchanged original model and bindings','actual_model':'gpt-6.1-sol','requested_effort':'ultra'})
  hashes={rel(p):h for p,h in sources.items()}
  for i,p in enumerate(sources):run.capture(p,'compiled-source-'+str(i),area='inputs')
  for i,p in enumerate(manifests):run.capture(p,'pinned-semantic-input-'+str(i),area='inputs')
  e=ATTEMPT/'evidence';proof=e/'kernel-check.json';cert=e/'certificate-kernel-check.json'
  dump(proof,{'kind':'rocq-kernel-check','run':rel(run.folder),'command_id':kernel['id'],'theorems':[b['theorem'] for b in bindings],'statement_artifacts':[rel(ATTEMPT/'Proof.v'),rel(PROBLEM/'Spec.v')],'dependency_sha256':hashes})
  dump(cert,{'kind':'rocq-kernel-check','run':rel(run.folder),'command_id':ck['id'],'theorems':['PidGroundIntegralAttempt001.GoalBinding.goal_'+str(i) for i in range(len(bindings))],'statement_artifacts':[rel(certificate)],'dependency_sha256':{**hashes,rel(certificate):sha(certificate)}})
  dump(e/'goal-validation.json',{'schema':'five-proof-validation/1','index':{'path':rel(ATTEMPT/'provenance.json'),'sha256':sha(ATTEMPT/'provenance.json')},'inputs':[{'path':p,'sha256':h,**({'snapshot':p} if ROOT/p in sources else {})} for p,h in index.items()],'kernel_evidence':rel(proof),'goal_bindings':bindings,'certificate':{'path':rel(certificate),'sha256':sha(certificate),'imports':imports,'module':'PidGroundIntegralAttempt001.GoalBinding','run':rel(run.folder),'compile_command_id':cc['id'],'kernel_command_id':ck['id'],'kernel_evidence':rel(cert)}})
 for p in [*sources,certificate]:
  for ext in ['.vo','.vos','.vok','.glob']:
   p.with_suffix(ext).unlink(missing_ok=True)
  (p.parent/('.'+p.stem+'.aux')).unlink(missing_ok=True)
 if owned:run.finish('passed' ,'Focused original dependency rebuild, exact goal binding and independent kernels passed.',{})
 print('ALL FIVE GOALS AND BOTH KERNELS PASSED',flush=True)
if __name__=='__main__':
 try:main()
 except BaseException as exc:
  if OWNED_RUN is not None and OWNED_RUN.read('run.json')['status']=='running':
   OWNED_RUN.finish('interrupted' if isinstance(exc,KeyboardInterrupt) else 'failed',str(exc),{})
  raise
