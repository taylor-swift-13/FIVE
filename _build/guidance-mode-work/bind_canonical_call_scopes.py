from pathlib import Path
import json
R=Path('/home/yangfp/five')
for entry,side in [('gh_update_ref_from_speed_sp','Speed'),('gh_update_ref_from_accel_sp','Accel')]:
 d=R/'paparazzi/models'/entry/'rocq/cbmc_recheck';p=d/'problem/Spec.v';s=p.read_text().replace('Require Import Adapters.','Require Import Adapters CanonicalCallScope.');s=s.replace(': Prop := GuardTrace.helper_guard_sites',f': Prop := CanonicalCallScope.{side}CallScope /\\ GuardTrace.helper_guard_sites');p.write_text(s)
 p=d/'attempts/001/Proof.v';s=p.read_text().replace('Require Import Adapters.','Require Import Adapters CanonicalCallScope.');s=s.replace('split; [exact GuardSiteMap.actual_helper_guard_site_map',f'split; [exact CanonicalCallScope.{side.lower()}_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map');p.write_text(s)
 p=d/'property-map.json';rows=json.loads(p.read_text())
 for r in rows:
  if r['property_id'].startswith('five_sqrtf.'):r['proposition']=f'CanonicalCallScope.{side}CallScope /\\ '+r['proposition']
 p.write_text(json.dumps(rows,indent=2)+'\n')
print('EveryhelperID now includes whole-entryANYcall, bothreferencebranches, actualreadiness andnonvacuousinitializedtwo-memory inputwitnesses.')
