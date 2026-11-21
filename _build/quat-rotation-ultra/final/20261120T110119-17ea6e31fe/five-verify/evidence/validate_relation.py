from pathlib import Path
import json,sys
root=Path.cwd();sys.path.insert(0,str(root/"scripts"))
from example_proof_gate import validate_current
p=root/"paparazzi/relations/quat_rotation_paths/problem";a=p.parent/"attempts/001"
print(validate_current(root,p,a,json.loads((p/"status.json").read_text())))
