import sys,json,importlib.util
from pathlib import Path
sys.path.insert(0,"/home/yangfp/five/scripts")
r=Path("/home/yangfp/five")
s=importlib.util.spec_from_file_location("five_artifact_validator",r/"scripts/check-example-artifacts.py");m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
v=m.Validator(r,{"medium","ultra"})
v.proof_problem(r/'paparazzi/relations/trig_plain_compressed_12/problem')
v.case(r/'paparazzi/models/trig_plain/pprz_itrig_sin')
v.proof_problem(r/'paparazzi/models/trig_plain/pprz_itrig_sin/rocq/execution_correspondence/problem')
v.case(r/'paparazzi/models/trig_compressed_12/pprz_itrig_sin')
v.proof_problem(r/'paparazzi/models/trig_compressed_12/pprz_itrig_sin/rocq/execution_correspondence/problem')
v.case(r/'paparazzi/models/trig_compressed_12/pprz_trig_int_init')
v.proof_problem(r/'paparazzi/models/trig_compressed_12/pprz_trig_int_init/rocq/execution_correspondence/problem')

print(json.dumps({"status":"failed"if v.errors else"passed","errors":v.errors,"active_attempts":[str(p.relative_to(r))for p in v.active]},indent=2));sys.exit(bool(v.errors))
