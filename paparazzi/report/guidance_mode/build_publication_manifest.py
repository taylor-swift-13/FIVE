#!/usr/bin/env python3
"""Index explicit text evidence; exclude rebuilt objects and installed tool binaries."""
from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[3]
allowed={'.v','.c','.h','.i','.json','.log','.md','.py','.txt','.ml','.mli','.config','.csv','.patch'}
files=set()
def add(p):
 p=Path(p).resolve()
 if p.is_file()and p.is_relative_to(R)and(p.suffix in allowed or p.name=='COPYING')and p.name!='publication-evidence.json':files.add(p)
for rel in ['paparazzi/models/gh_update_ref_from_speed_sp','paparazzi/models/gh_update_ref_from_accel_sp','paparazzi/relations/guidance_mode','paparazzi/report/guidance_mode']:
 for p in (R/rel).rglob('*'):add(p)
add(R/'paparazzi/README.md')
index=json.loads((R/'paparazzi/report/guidance_mode/evidence/cost-run-index.json').read_text())
for item in index['runs']:
 run=R/item['run'];data=json.loads((run/'run.json').read_text())
 for name in ['run.json','metrics.json','report.md']:add(run/name)
 for row in data.get('inputs',[]):
  if row.get('path'):add(run/row['path'])
 for sub in ['logs','evidence']:
  for p in (run/sub).rglob('*'):add(p)
# Active proofs can share immutable source snapshots outside their case tree.
for root in [R/'paparazzi/models/gh_update_ref_from_speed_sp/rocq',R/'paparazzi/models/gh_update_ref_from_accel_sp/rocq',R/'paparazzi/relations/guidance_mode']:
 for p in root.glob('**/goal-validation.json'):
  data=json.loads(p.read_text())
  for row in data.get('inputs',[]):
   if row.get('snapshot'):add(R/row['snapshot'])
rows=[{'path':str(p.relative_to(R)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size}for p in sorted(files)]
out=R/'paparazzi/report/guidance_mode/publication-evidence.json'
out.write_text(json.dumps({'schema':'five-publication-evidence/1','scope':'Explicit owned source, model, reports, actual command/input/evidence text and retained failed attempts; no whole _build tree, tool binaries or regenerated Rocq objects. Final review/global-close files are refreshed by the owner after completion.','files':rows,'file_count':len(rows),'bytes':sum(x['bytes']for x in rows),'excluded':['.vo','.vos','.vok','.glob','.aux','executables','installed CompCert/Rocq libraries; version/hash dependencies retained in manifests']},indent=2)+'\n')
print(json.dumps({'manifest':str(out.relative_to(R)),'files':len(rows),'bytes':sum(x['bytes']for x in rows)}))
