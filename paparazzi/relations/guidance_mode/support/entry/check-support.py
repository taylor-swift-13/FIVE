#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,shutil,sys
root=Path('/home/yangfp/five')
sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
run=Run(root/'runs/20261106T111221-7a25959e59/five-rocq')
support=root/'paparazzi/relations/guidance_mode/support/entry'
build=support/'evidence/checked-001'
if build.exists():raise RuntimeError('Immutable check snapshot exists')
ns={
 'FivePaparazziState':root/'paparazzi/relations/parameter_order/support',
 'FiveGhSpeed':root/'paparazzi/models/gh_update_ref_from_speed_sp/align/model',
 'FiveGuidanceEntry':support}
modules=[('FivePaparazziState','State'),('FivePaparazziState','MemorySupport'),
 ('FiveGhSpeed','Source'),('FiveGhSpeed','Execution'),
 ('FiveGuidanceEntry','SoftwareSqrt'),('FiveGuidanceEntry','Entry'),
 ('FiveGuidanceEntry','BigstepSupport'),('FiveGuidanceEntry','SymbolicPrefix'),('FiveGuidanceEntry','PrelimitBody')]
flags=[];rows=[]
for name in ns:
 d=build/name;d.mkdir(parents=True,exist_ok=True);flags+=['-Q',str(d),name]
for name,mod in modules:
 src=ns[name]/(mod+'.v');dst=build/name/(mod+'.v');shutil.copyfile(src,dst)
 rows.append({'path':str(src.relative_to(root)),'sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'snapshot':str(dst.relative_to(root))})
for i,(name,mod) in enumerate(modules):
 run.command(['rocq','compile',*flags,str(build/name/(mod+'.v'))],'entry-support-full-'+str(i),timeout=90,cwd=str(root))
receipt=run.command(['rocq','check','-silent',*flags,'FiveGuidanceEntry.PrelimitBody'],'entry-support-independent-kernel',timeout=90,cwd=str(root))
meta=[]
session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/06/rollout-2026-11-06T19-11-06-01a1b08e-1efa-7763-bf97-cbc5e9fca28d.jsonl')
for line in session.read_text().splitlines():
 r=json.loads(line)
 if r.get('type')=='turn_context':
  p=r['payload'];meta.append({k:p[k] for k in ['model','effort','reasoning_effort'] if k in p})
(build/'runtime.json').write_text(json.dumps({'actor_path':'/root/guidance_mode_complete_medium/guidance_entry','session':str(session),'turn_context':meta},indent=2)+'\n')
(build/'checked-inputs.json').write_text(json.dumps({'schema':'five-proof-support-check/1','status':'proved-support-only','requested_whole_entry_goals':'pending','inputs':rows,'kernel_command_id':receipt['id'],'theorems':['FiveGuidanceEntry.PrelimitBody.body_prelimit','FiveGuidanceEntry.SymbolicPrefix.source_integration_exec','FiveGuidanceEntry.SymbolicPrefix.source_raw_accel_exec','FiveGuidanceEntry.SymbolicPrefix.saturation_call_original_path']},indent=2)+'\n')
print('Checked current exact support snapshots; universal body prelimit theorem is proved, full entries pending.')
