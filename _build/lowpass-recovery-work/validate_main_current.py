from pathlib import Path
import json,sys
R=Path('/home/yangfp/five');sys.path.insert(0,str(R/'scripts'));from example_proof_gate import validate_current
rows=[]
for e in ['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']:
 for kind in ['functional','no_error','termination']:
  p=R/'paparazzi/models'/e/'rocq'/kind/'problem';s=json.loads((p/'status.json').read_text());a=(p/s['active_attempt']).resolve();validate_current(R,p.resolve(),a,s);rows.append(str(p.relative_to(R)))
p=R/'paparazzi/relations/lowpass_recovery/problem';s=json.loads((p/'status.json').read_text());validate_current(R,p.resolve(),(p/s['active_attempt']).resolve(),s);rows.append(str(p.relative_to(R)))
result={'status':'passed','unchanged_validator':'scripts/example_proof_gate.py:validate_current','problems':rows,'count':len(rows),'source_goal_count':18,'proof_run':'_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq'}
p=R/'_build/lowpass-recovery-work/main-current-goal-validation.json';p.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
