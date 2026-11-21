from pathlib import Path
import importlib.util,json
here=Path(__file__).resolve().parent
root=here.parents[4]
spec=importlib.util.spec_from_file_location("checker",root/"paparazzi/report/quat_rotation_paths/evidence_tools.py")
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
print(m.check(json.loads((here/"check-config.json").read_text())))
