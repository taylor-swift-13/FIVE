from pathlib import Path
import subprocess,json
root=Path(__file__).resolve().parents[4]
run='_build/lowpass-readback/20261107T032054-5f16295536/five-rocq'
for ns,row in json.loads((root/'paparazzi/report/lowpass_readback/support/goal-index.json').read_text()).items():
 print('FINAL exact receipt: '+ns,flush=True)
 subprocess.run(['python3',row['attempt']+'/check.py','--record-run',run],cwd=root,check=True)
