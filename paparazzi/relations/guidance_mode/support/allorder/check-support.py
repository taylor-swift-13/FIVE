from pathlib import Path
import hashlib,json,shutil,sys
root=Path('/home/yangfp/five')
sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
run=Run(root/'_build/guidance-mode-allorder/20261106T122019-5fbabb1f83/five-rocq')
support=root/'paparazzi/relations/guidance_mode/support/allorder'
build=support/'evidence/checked-001'
if build.exists():raise RuntimeError('Immutable snapshot already exists')
ns={'FiveGuidanceSemantics':root/'paparazzi/relations/guidance_mode/support/semantics','FiveGuidanceAllOrder':support}
mods=[('FiveGuidanceSemantics','SemanticsSupport')]+[('FiveGuidanceAllOrder',n) for n in ['PureSyntax','PureDenotation','PureProgress','AtomicDenotation','AtomicProgress','CallfreeExecution']]
flags=[];rows=[]
for name in ns:
 d=build/name;d.mkdir(parents=True,exist_ok=True);flags+=['-Q',str(d),name]
for name,mod in mods:
 src=ns[name]/(mod+'.v');dst=build/name/(mod+'.v');shutil.copyfile(src,dst)
 rows.append({'path':str(src.relative_to(root)),'sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'snapshot':str(dst.relative_to(root))})
for i,(name,mod) in enumerate(mods):
 run.command(['rocq','compile',*flags,str(build/name/(mod+'.v'))],'canonical-allorder-support-'+str(i),timeout=150,cwd=str(root))
receipt=run.command(['rocq','check','-silent',*flags,'FiveGuidanceAllOrder.CallfreeExecution'],'canonical-allorder-kernel',timeout=150,cwd=str(root))
(build/'checked-inputs.json').write_text(json.dumps({'schema':'five-proof-support-check/1','status':'proved-support-only','whole-effectful-entry-goals':'pending','inputs':rows,'kernel_command_id':receipt['id'],'theorems':['FiveGuidanceAllOrder.AtomicProgress.all_order_atomic_expression','FiveGuidanceAllOrder.CallfreeExecution.normal_witness_certifies_all_orders','FiveGuidanceAllOrder.CallfreeExecution.normal_witness_excludes_all_errors']},indent=2)+'\n')
print('Fresh full compile and independent kernel checks passed for all-order callfree support.')
