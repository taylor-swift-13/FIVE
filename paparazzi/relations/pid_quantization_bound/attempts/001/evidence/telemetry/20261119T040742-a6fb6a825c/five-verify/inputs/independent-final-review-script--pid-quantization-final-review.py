from pathlib import Path
import json,hashlib,importlib.util,sys
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
rel=r/'paparazzi/relations/pid_quantization_bound';attempt=rel/'attempts/001'
rootrun=Path((r/'_build/pid-quantization-bound/root-run.txt').read_text().strip())
old=json.loads((rootrun/'evidence/reused-artifact-freeze.json').read_text())['files']
for x in old:
 assert hashlib.sha256((r/x['path']).read_bytes()).hexdigest()==x['sha256'],x['path']
status=json.loads((rel/'problem/status.json').read_text())
assert status['status']=='proved' and len(status['requested_goals'])==6
assert all(status['goal_status'][x]=='proved' for x in status['requested_goals'])
v=json.loads((attempt/'evidence/goal-validation.json').read_text())
assert set(x['requested_goal'] for x in v['goal_bindings'])==set(status['requested_goals'])
ns=0
for x in v['inputs']:
 assert hashlib.sha256((r/x['path']).read_bytes()).hexdigest()==x['sha256'],x['path']
 if x.get('snapshot'):
  assert hashlib.sha256((r/x['snapshot']).read_bytes()).hexdigest()==x['sha256'],x['snapshot']
  ns+=1
kr=json.loads((r/v['kernel_evidence']).read_text())
raw=json.loads((r/kr['run']/'run.json').read_text())
cmd=next(x for x in raw['commands'] if x['id']==kr['command_id'])
assert cmd['status']=='passed' and cmd['exit_code']==0
assert cmd['argv'][:2]==['rocq','check']
assert not any(x in {'-admit','-norec'} for x in cmd['argv'])
spec=importlib.util.spec_from_file_location('artifact_validator',r/'scripts/check-example-artifacts.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
validator=m.Validator(r,allowed_proof_efforts={'ultra'})
validator.proof_problem(rel/'problem')
print(json.dumps({'pre_existing_frozen_artifacts_unchanged':len(old),
 'canonical_requested_goals':status['requested_goals'],'exact_goal_binding_count':len(v['goal_bindings']),
 'current_compiled_snapshots_match':ns,'actual_independent_kernel_command':cmd['id'],
 'actual_kernel_status':cmd['status'],'actual_kernel_exit_code':cmd['exit_code'],
 'validator_errors':validator.errors,'mathematical_adequacy_review':[
 'All dynamic shift rounding is removed through exact scaled integer numerators, with universal exact Q interpretation of PD/feedforward/integral/two command clamps.',
 'Reference preserves original encoded gains, existing input clamps and actual saturation constants; this is not a textbook PID with a different integrator.',
 'ActualCycles quantifies actual original CompCert NormalCall steps with arbitrary admissible symbolic AxisSample inputs and fixed symbolic gains, both axes.',
 'Initial actual integral is arbitrary and reference is exactly related by SameStart; EnvironmentStep preserves it.',
 'Arbitrary horizon output bound is for n>=1, integral bound for all n; one-sided bias requires existing nonnegative gains.',
 'Ready-driver return existence is proved using actual original function totality, plus a symbolic executable nonvacuity family.',
 'Actual observations are the original stored integral, global command and active returned int32 field; radians use exact Q12 decoding.'
 ]},indent=2))
raise SystemExit(bool(validator.errors))

