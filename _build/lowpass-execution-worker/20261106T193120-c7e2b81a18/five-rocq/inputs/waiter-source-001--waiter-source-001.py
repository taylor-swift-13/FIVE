from pathlib import Path
import json,subprocess,sys,time
R=Path('/home/yangfp/five');MAIN=R/'_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq';script=Path(sys.argv[1]);deadline=time.monotonic()+1800;last=None
entries=['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass'];foreign=[R/'paparazzi/models'/e/'rocq'/k/'problem/status.json' for e in entries for k in ['execution_correspondence','cbmc_recheck']]
while time.monotonic()<deadline:
 try:
  d=json.loads((MAIN/'run.json').read_text());statuses=[json.loads(p.read_text()).get('status') for p in foreign];state=(d.get('status'),bool(d.get('finished_at') and d.get('finish_epoch') and d.get('cost_audit')),tuple(statuses))
 except (OSError,ValueError):time.sleep(10);continue
 if state!=last:print('Metadata publication gate:',state,flush=True);last=state
 if d.get('status') in ['failed','blocked','timeout','interrupted']:raise SystemExit('Main formal run did not pass; no case metadata published.')
 if state[0]=='passed' and state[1] and all(s=='proved' for s in statuses):
  subprocess.run(['python3',str(script),'--publish'],cwd=R,check=True);raise SystemExit(0)
 time.sleep(20)
raise SystemExit('Bounded metadata wait ended; no publication performed.')
