import subprocess
from pathlib import Path
root=Path('/home/yangfp/five')
for d in [2,3]:
 e=f'float_mat_inv_{d}d';r=subprocess.run(['bash','-lc',f'source scripts/env.sh && python3 scripts/compcert-align.py export --source paparazzi/models/{e}/prepare/source/{e}.c --function f_{e} --namespace FivePprzFloatMatInv{d}d --output paparazzi/models/{e}/align/model --request paparazzi/models/{e}/align/request.json'],cwd=root,capture_output=True,text=True);print(d,r.returncode,r.stdout,r.stderr,flush=True)
