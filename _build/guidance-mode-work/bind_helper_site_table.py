from pathlib import Path
import json,re
R=Path('/home/yangfp/five')
for entry,side in [('gh_update_ref_from_speed_sp','Speed'),('gh_update_ref_from_accel_sp','Accel')]:
 d=R/'paparazzi/models'/entry/'rocq/cbmc_recheck';p=d/'problem/Spec.v';s=p.read_text().replace('Import GuardTrace GuardExecution.','Import GuardTrace GuardExecution GuardSiteMap.')
 s=re.sub(r': Prop := (GuardExecution\.'+side+r'ExecutedHelperGuard \d+)\.',r': Prop := GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\\ \1.',s);p.write_text(s)
 p=d/'attempts/001/Proof.v';s=p.read_text().replace('Import GuardTrace GuardExecution.','Import GuardTrace GuardExecution GuardSiteMap.')
 s=s.replace(f'apply GuardExecution.{side.lower()}_executed_helper_guard; lia.',f'split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.{side.lower()}_executed_helper_guard; lia].');p.write_text(s)
 p=d/'property-map.json';rows=json.loads(p.read_text())
 for r in rows:
  if r['property_id'].startswith('five_sqrtf.'):r['proposition']='GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\\ '+r['proposition']
 p.write_text(json.dumps(rows,indent=2)+'\n')
print('Every helper goal additionally binds full actual AST guard list to explicit53-ID expected site table.')
