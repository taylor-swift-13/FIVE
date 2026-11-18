#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,shutil,sys
root=Path('/home/yangfp/five');sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
run=Run(root/'runs/20261106T111221-7a25959e59/five-rocq')
support=root/'paparazzi/relations/guidance_mode/support/entry';build=support/'evidence/checked-002'
if build.exists():raise RuntimeError('Immutable check snapshot exists')
ns={'FivePaparazziState':root/'paparazzi/relations/parameter_order/support',
'FiveGhSpeed':root/'paparazzi/models/gh_update_ref_from_speed_sp/align/model',
'FiveGhAccel':root/'paparazzi/models/gh_update_ref_from_accel_sp/align/model',
'FiveGuidanceEntry':support,'FiveGuidanceAllocation':root/'paparazzi/relations/guidance_mode/support/allocation',
'FiveGuidanceMode':root/'paparazzi/relations/guidance_mode/problem'}
modules=[('FivePaparazziState','State'),('FivePaparazziState','MemorySupport'),
('FiveGhSpeed','Source'),('FiveGhSpeed','Execution'),('FiveGhAccel','Source'),('FiveGhAccel','Execution'),
('FiveGuidanceEntry','SoftwareSqrt'),('FiveGuidanceEntry','Entry'),('FiveGuidanceEntry','BigstepSupport'),
('FiveGuidanceAllocation','Allocation'),('FiveGuidanceAllocation','StackAllocation'),('FiveGuidanceAllocation','StackWrapper'),
('FiveGuidanceEntry','SymbolicPrefix'),('FiveGuidanceEntry','PrelimitBody'),('FiveGuidanceMode','Spec'),('FiveGuidanceEntry','EntryPrelimit')]
flags=[];rows=[]
for name in ns:
 d=build/name;d.mkdir(parents=True,exist_ok=True);flags+=['-Q',str(d),name]
for name,mod in modules:
 src=ns[name]/(mod+'.v');dst=build/name/(mod+'.v');shutil.copyfile(src,dst)
 rows.append({'path':str(src.relative_to(root)),'sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'snapshot':str(dst.relative_to(root))})
for i,(name,mod) in enumerate(modules):
 run.command(['rocq','compile',*flags,str(build/name/(mod+'.v'))],'prelimit-full-'+str(i),timeout=90,cwd=str(root))
cert=build/'FiveGuidanceEntry/GoalBinding.v'
cert.write_text('From FiveGuidanceMode Require Import Spec.\nFrom FiveGuidanceEntry Require Import EntryPrelimit.\nDefinition goal_actual_prelimit : FiveGuidanceMode.Spec.ActualPrelimitExists := FiveGuidanceEntry.EntryPrelimit.actual_prelimit_exists.\nPrint Assumptions goal_actual_prelimit.\n')
compile_receipt=run.command(['rocq','compile',*flags,str(cert)],'prelimit-canonical-goalbinding',timeout=90,cwd=str(root))
kernel=run.command(['rocq','check','-silent',*flags,'FiveGuidanceEntry.GoalBinding'],'prelimit-canonical-independent-kernel',timeout=90,cwd=str(root))
for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
 for tail in ['prepare/source/'+entry+'.c','prepare/source/five_sqrtf.c','prepare/source/bindings.json','align/model/compcert-manifest.json','align/model/preprocessed.i']:
  p=root/'paparazzi/models'/entry/tail
  rows.append({'path':str(p.relative_to(root)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
rows.append({'path':str(Path(__file__).relative_to(root)),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()})
index=build/'inputs.json';index.write_text(json.dumps({'schema':'five-proof-inputs/1','dependency_sha256':{r['path']:r['sha256'] for r in rows}},indent=2)+'\n')
receipt={'schema':'five-canonical-support-proof/1','status':'proved','scope':'ActualPrelimitExists only; whole normal-return/safety/functional relation remain pending','inputs':rows,'index':{'path':str(index.relative_to(root)),'sha256':hashlib.sha256(index.read_bytes()).hexdigest()},'goal_binding':{'requested_goal':'ActualPrelimitExists','type':'FiveGuidanceMode.Spec.ActualPrelimitExists','theorem':'FiveGuidanceEntry.EntryPrelimit.actual_prelimit_exists'},'certificate':{'path':str(cert.relative_to(root)),'sha256':hashlib.sha256(cert.read_bytes()).hexdigest(),'compile_command_id':compile_receipt['id'],'kernel_command_id':kernel['id']},'run':str(run.folder.relative_to(root))}
(build/'canonical-prelimit-evidence.json').write_text(json.dumps(receipt,indent=2)+'\n')
print('Canonical ActualPrelimitExists goal bound, compiled and independently kernel checked.')
