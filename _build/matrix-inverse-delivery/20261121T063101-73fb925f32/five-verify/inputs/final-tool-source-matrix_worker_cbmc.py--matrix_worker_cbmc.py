import sys,json,shutil
from pathlib import Path
sys.path.insert(0,'/home/yangfp/five/scripts');from five_telemetry import Run
root=Path('/home/yangfp/five');r=Run((root/'_build/matrix_inverse_cbmc_run.txt').read_text());exe=shutil.which('cbmc');print(exe,flush=True)
r.command([exe,'--version'],'cbmc-version',timeout=30,cwd=root)
for d in [2,3]:
 e=f'float_mat_inv_{d}d';c=root/'paparazzi/models'/e
 args=[exe,str(c/f'prepare/source/{e}.c'),str(c/'cbmc/harness.c'),'--function','main','--64','--little-endian','--bounds-check','--pointer-check','--pointer-overflow-check','--signed-overflow-check','--undefined-shift-check','--div-by-zero-check','--unwind','40','--unwinding-assertions','--json-ui','--trace']
 try:r.command(args,f'cbmc-inv{d}-original-body',timeout=240,cwd=root)
 except RuntimeError as exc:print(str(exc),flush=True)
 row=r.read('commands.json')[-1];print(d,row['id'],row['exit_code'],flush=True)
