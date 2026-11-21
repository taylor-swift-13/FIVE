from pathlib import Path
import sys,json,hashlib,importlib.util
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
rel=r/'paparazzi/relations/pid_saturation_placement';a=rel/'attempts/001'
root=Path((r/'_build/pid-saturation-placement/root-run.txt').read_text().strip())
old=json.loads((root/'evidence/reused-artifact-freeze.json').read_text())['files']
for x in old:assert hashlib.sha256((r/x['path']).read_bytes()).hexdigest()==x['sha256'],x['path']
s=json.loads((rel/'problem/status.json').read_text())
assert s['status'] in {'proved','refuted'} and len(s['requested_goals'])==3
assert all(s['goal_status'][x]=='proved' for x in s['requested_goals'])
v=json.loads((a/'evidence/goal-validation.json').read_text())
assert {x['requested_goal'] for x in v['goal_bindings']}==set(s['requested_goals'])
count=0
for x in v['inputs']:
 assert hashlib.sha256((r/x['path']).read_bytes()).hexdigest()==x['sha256'],x['path']
 if x.get('snapshot'):
  assert hashlib.sha256((r/x['snapshot']).read_bytes()).hexdigest()==x['sha256'],x['snapshot']
  count+=1
k=json.loads((r/v['kernel_evidence']).read_text());run=json.loads((r/k['run']/'run.json').read_text())
cmd=next(x for x in run['commands'] if x['id']==k['command_id'])
assert cmd['status']=='passed' and cmd['exit_code']==0 and cmd['argv'][:2]==['rocq','check']
spec=importlib.util.spec_from_file_location('v',r/'scripts/check-example-artifacts.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
validator=m.Validator(r,allowed_proof_efforts={'ultra'});validator.proof_problem(rel/'problem')
print(json.dumps({'pre_existing_artifacts_unchanged':len(old),'current_compiled_sources_match':count,'exact_goal_bindings':v['goal_bindings'],
 'kernel_command_id':cmd['id'],'kernel_status':cmd['status'],'validator_errors':validator.errors,
 'adequacy_review':[
 'Only original C command saturation placement is compared against an executable Z reference; all rounding, error clamps, PD-integral update and integral clipping are shared.',
 'SourceComparison quantifies arbitrary valid symbolic input/gains on both axes and requires real original NormalCall existence plus all returned-memory observations.',
 'Updated integral proves b in[-1429,1429], so staged final3216 clamp is inactive; equality iff abs(total)<=1429 and strict directions/excess bound are source linked.',
 'Both actual counterexamples construct valid memory with real Mem.store, ReadAxis and original calls; zero-integral witness1429/2000 refutes unconditional equality.',
 'Negative-initial-integral429/1000 witness is a legal starting state and makes no reset-history reachability claim.',
 'No new C model generation, CBMC or old proof modification is claimed.'
 ]},ensure_ascii=False,indent=2))
raise SystemExit(bool(validator.errors))

