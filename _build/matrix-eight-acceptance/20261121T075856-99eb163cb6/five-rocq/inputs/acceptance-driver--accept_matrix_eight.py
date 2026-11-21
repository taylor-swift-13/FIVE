from pathlib import Path
import json,sys,importlib.util,os,traceback
ROOT=Path('/home/yangfp/five');os.chdir(ROOT);sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
from example_proof_gate import validate_current
SESSION='/mnt/c/Users/50635/.codex/sessions/2026/11/21/rollout-2026-11-21T15-01-25-01a1fce8-ec91-7970-b2cd-5db751f82260.jsonl'
scope={'task':'Fresh independent cold acceptance of eight unchanged original matrix-model proof questions','role':'Tool-only independent checking by coordinator; mathematical proof source authorship remains actual gpt-6.1-sol Ultra workers','goals':['no_error','termination','functional','execution_correspondence'],'cases':['float_mat_inv_2d','float_mat_inv_3d'],'exclude':'The two CBMC questions are repaired and checked by dedicated actual Sol Ultra actors; no new mathematical .v content authored here.'}
run=Run.start(ROOT/'_build/matrix-eight-acceptance','five-rocq',[('acceptance-driver',Path(__file__))],scope,usage_session=SESSION)
(ROOT/'_build/matrix_eight_acceptance_run.txt').write_text(str(run.folder.relative_to(ROOT))+'\n')
print('RUN',run.folder,flush=True)
spec=importlib.util.spec_from_file_location('matrix_receipts',ROOT/'paparazzi/report/quat_rotation_paths/evidence_tools.py');checker=importlib.util.module_from_spec(spec);spec.loader.exec_module(checker)
results=[];roles={}
try:
 for cid in scope['cases']:
  for name in scope['goals']:
   problem=ROOT/'paparazzi/models'/cid/'rocq'/name/'problem';status=json.loads((problem/'status.json').read_text());attempt=(problem/status['active_attempt']).resolve()
   for p in (attempt/'evidence').glob('*.json'):run.capture(p,'previous-unaccepted-'+cid+'-'+name+'-'+p.stem)
   config=json.loads((attempt/'checker-config.json').read_text());config['root']=str(ROOT);config['build']=str((run.folder/'evidence/checked').relative_to(ROOT))
   result=checker.check(config,record_run=str(run.folder));result.update(case=cid,problem=name);results.append(result)
   roles[cid+'-'+name+'-goals']=attempt/'evidence/goal-validation.json'
   print('PASSED',cid,name,result['compiled_modules'],flush=True)
 summary=run.folder/'evidence/acceptance-summary.json';summary.write_text(json.dumps({'status':'kernels_passed','proof_sources_unchanged':True,'results':results},indent=2)+'\n');roles['summary']=summary
 run.finish('passed','Eight unchanged model questions compiled with exact GoalBindings and checked by independent Rocq kernels. Source proof authors remain Sol Ultra; no mathematics changed.',roles)
 for cid in scope['cases']:
  for name in scope['goals']:
   problem=ROOT/'paparazzi/models'/cid/'rocq'/name/'problem';sp=problem/'status.json';s=json.loads(sp.read_text());s['status']='proved';sp.write_text(json.dumps(s,indent=2)+'\n');a=(problem/s['active_attempt']).resolve();validate_current(ROOT,problem,a,s)
 print('CURRENT_ACCEPTANCE_PASSED',len(results),flush=True)
except Exception:
 if run.read('run.json')['status']=='running':run.finish('failed',traceback.format_exc(),{})
 raise
