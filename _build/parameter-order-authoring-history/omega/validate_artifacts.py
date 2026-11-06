from pathlib import Path
import sys,importlib.util,json
root=Path('/home/yangfp/five');sys.path.insert(0,str(root/'scripts'))
spec=importlib.util.spec_from_file_location('validator',root/'scripts/check-example-artifacts.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
v=module.Validator(root);case=root/'paparazzi/models/gh_set_omega';v.case(case)
for name in ['functional','execution']:v.proof_problem(case/'rocq'/name/'problem')
result=dict(status='failed'if v.errors else'passed',errors=v.errors,active_attempts=[str(p.relative_to(root))for p in v.active]);print(json.dumps(result,indent=2));sys.exit(bool(v.errors))
