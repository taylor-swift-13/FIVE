from pathlib import Path
import json,hashlib,shutil
r=Path('/home/yangfp/five')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for e in ['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']:
 c=r/'paparazzi/models'/e;a=c/'rocq/execution_correspondence/attempts/001';p=a/'evidence/goal-validation.json';d=json.loads(p.read_text());history=a/'evidence/current-before-metadata-refresh.json'
 if not history.exists():shutil.copyfile(p,history)
 for row in d['inputs']:
  source=r/row['path'];h=sha(source)
  if source.suffix in ('.c','.v'):assert h==row['sha256'],source
  else:row['sha256']=h
 existing={row['path'] for row in d['inputs']}
 for stage in ['prepare','align']:
  hand=c/stage/'handoff.json'
  if not hand.exists():continue
  obj=json.loads(hand.read_text())
  for row in obj['outputs']:
   q=c/row['path'];assert q.is_file() and sha(q)==row['sha256'],q
  rel=str(hand.relative_to(r))
  if rel not in existing:d['inputs'].append({'path':rel,'sha256':sha(hand)})
 p.write_text(json.dumps(d,indent=2)+'\n')
 print(e,'source-preserving metadata refresh and prepare/align handoff verification passed')
