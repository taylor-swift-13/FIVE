
from pathlib import Path
import json,hashlib,shutil
root=Path('/home/yangfp/five');c=root/'paparazzi/models/guidance_pid_h_run_pos';sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
ev=root/'paparazzi/report/pid_position_translation/evidence/handoff-cost-rebinding';ev.mkdir(parents=True,exist_ok=False)
allowed={'prepare/report/costs.json','align/report/costs.json','prepare/handoff.json','cbmc/handoff.json'}
paths=[c/s/'handoff.json' for s in ['prepare','cbmc','align']];before=[]
for p in paths:
 q=ev/('before-'+p.parent.name+'-handoff.json');shutil.copyfile(p,q);before.append({'path':str(p.relative_to(root)),'snapshot':str(q.relative_to(root)),'sha256':sha(p)})
changes=[]
for p in paths:
 d=json.loads(p.read_text())
 for row in d['outputs']:
  f=(c/row['path']).resolve();assert f.is_relative_to(c),row
  current=sha(f)
  if row['sha256']!=current:
   assert str(f.relative_to(c)) in allowed,('Nonmetadata input changed',row['path'])
   changes.append({'handoff':str(p.relative_to(root)),'role':row['role'],'path':row['path'],'old_sha256':row['sha256'],'new_sha256':current});row['sha256']=current
 p.write_text(json.dumps(d,indent=2)+chr(10))
for p in paths:
 for row in json.loads(p.read_text())['outputs']:assert sha(c/row['path'])==row['sha256'],row
receipt={'schema':'five-handoff-metadata-rebinding/1','reason':'Corrective preparecost was appended after priorhandofffreeze. Rebind only closedcostmetadata and transitivestagehandoff hashes; no source/model/proposition changes and no closedrawrun edits.','status':'passed','before':before,'changes':changes,'after':[{'path':str(p.relative_to(root)),'sha256':sha(p)} for p in paths],'source_sha256':sha(c/'prepare/source/guidance_pid_h_run_pos.c'),'ast_sha256':sha(c/'align/model/Source.v'),'execution_sha256':sha(c/'align/model/Execution.v')}
(ev/'receipt.json').write_text(json.dumps(receipt,indent=2)+chr(10));print(json.dumps(receipt,indent=2))
