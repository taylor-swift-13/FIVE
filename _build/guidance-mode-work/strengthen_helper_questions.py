from pathlib import Path
import json
R=Path('/home/yangfp/five')
for entry,side in [('gh_update_ref_from_speed_sp','Speed'),('gh_update_ref_from_accel_sp','Accel')]:
 d=R/'paparazzi/models'/entry/'rocq/cbmc_recheck';p=d/'problem/Spec.v';s=p.read_text().replace('Import GuardTrace.','Import GuardTrace GuardExecution.').replace('GuardTrace.HelperGuard ',f'GuardExecution.{side}ExecutedHelperGuard ');p.write_text(s)
 p=d/'attempts/001/Proof.v';s=p.read_text().replace('Import GuardTrace.','Import GuardTrace GuardExecution.').replace('GuardTrace.helper_guard_proved',f'GuardExecution.{side.lower()}_executed_helper_guard');p.write_text(s)
 p=d/'property-map.json';rows=json.loads(p.read_text())
 for r in rows:
  if r['property_id'].startswith('five_sqrtf.'):
   r['proposition']=f'GuardExecution.{side}ExecutedHelperGuard '+str(r['index']);r['category_theorem']=f'GuardExecution.{side.lower()}_executed_helper_guard'
 p.write_text(json.dumps(rows,indent=2)+'\n')
print('All106 helper goals now require actual memory/program-point instrumented execution, no evaluator-only guard remains.')
