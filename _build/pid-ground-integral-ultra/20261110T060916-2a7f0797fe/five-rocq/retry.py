from pathlib import Path
import sys,json,os
ROOT=Path('/home/yangfp/five');os.chdir(ROOT);sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
r=Run(Path(__file__).parent);pairs=json.loads((r.folder/'evidence/build-plan.json').read_text())['pairs'];flags=[x for d,n in pairs for x in ['-Q',d,n]]
try:
 c=r.command(['rocq','compile','-q',*flags,'paparazzi/relations/pid_ground_integral_independence/attempts/001/Proof.v'],'repair-ground-Proof',timeout=900,cwd=ROOT)
 print((r.folder/c['stdout']).read_text())
except Exception as e:
 c=r.read('commands.json')[-1];print((r.folder/c['stdout']).read_text());print((r.folder/c['stderr']).read_text()[-6000:]);raise
