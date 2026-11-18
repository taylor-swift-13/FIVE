from pathlib import Path
import json,sys,importlib.util
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
spec=importlib.util.spec_from_file_location('reference_validator',r/'scripts/check-example-artifacts.py');mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
v=mod.Validator(r)
from example_proof_gate import validate_current
for e in ['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']:
 p=r/'paparazzi/models'/e/'rocq/execution_correspondence/problem';a=p.parent/'attempts/001'
 v.proof_problem(p);v.costs(a/'costs.json',proof=True);v.links(p/'report.md');v.links(a/'report.md');validate_current(r,p,a,json.loads((p/'status.json').read_text()))
 print(e, 'strict Validator and independent validate_current passed')
assert not v.errors,'\n'.join(v.errors)
print('All 24 exact goal bindings passed unchanged strict reference validation.')
