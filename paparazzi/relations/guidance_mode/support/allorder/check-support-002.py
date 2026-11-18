from pathlib import Path
import hashlib,json,shutil,sys
root=Path('/home/yangfp/five')
sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
run=Run(root/'_build/guidance-mode-allorder/20261106T122019-5fbabb1f83/five-rocq')
support=root/'paparazzi/relations/guidance_mode/support/allorder'
build=support/'evidence/checked-002'
if build.exists():raise RuntimeError('Immutable snapshot already exists')
ns={'FiveGuidanceSemantics':root/'paparazzi/relations/guidance_mode/support/semantics','FiveGuidanceAllOrder':support}
mods=[('FiveGuidanceSemantics',n) for n in ['SemanticsSupport','SourceClosure']]+[('FiveGuidanceAllOrder',n) for n in ['PureSyntax','PureDenotation','PureProgress','AtomicDenotation','AtomicProgress','CallfreeExecution','ContinuationLift','BlockExecution','PhaseComposition','FactorShell','StandaloneCallShell']]
flags=[];rows=[]
for name in ns:
 d=build/name;d.mkdir(parents=True,exist_ok=True);flags+=['-Q',str(d),name]
for name,mod in mods:
 src=ns[name]/(mod+'.v');dst=build/name/(mod+'.v');shutil.copyfile(src,dst)
 rows.append({'path':str(src.relative_to(root)),'sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'snapshot':str(dst.relative_to(root))})
for i,(name,mod) in enumerate(mods):
 run.command(['rocq','compile',*flags,str(build/name/(mod+'.v'))],'canonical-allorder002-support-'+str(i),timeout=150,cwd=str(root))
receipt=run.command(['rocq','check','-silent',*flags,'FiveGuidanceAllOrder.StandaloneCallShell'],'canonical-allorder002-kernel',timeout=150,cwd=str(root))
(build/'checked-inputs.json').write_text(json.dumps({'schema':'five-proof-support-check/1','status':'proved-support-only','whole-effectful-entry-goals':'pending-concrete-instantiation','inputs':rows,'kernel_command_id':receipt['id'],'theorems':['FiveGuidanceAllOrder.AtomicProgress.all_order_atomic_expression','FiveGuidanceAllOrder.CallfreeExecution.normal_witness_certifies_all_orders','FiveGuidanceAllOrder.CallfreeExecution.normal_witness_excludes_all_errors','FiveGuidanceAllOrder.ContinuationLift.callee_invariant_all_successors','FiveGuidanceAllOrder.BlockExecution.block_context_all_successors','FiveGuidanceAllOrder.BlockExecution.block_context_entry','FiveGuidanceAllOrder.FactorShell.factor_all_successors','FiveGuidanceAllOrder.FactorShell.factor_progress','FiveGuidanceAllOrder.StandaloneCallShell.call_certificate','FiveGuidanceAllOrder.PhaseComposition.certificate_normal_unique']},indent=2)+'\n')
session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/06/rollout-2026-11-06T20-19-04-01a1b0cc-58bc-7273-9fa6-8daa0b95c589.jsonl')
meta=[]
for line in session.read_text().splitlines():
 r=json.loads(line)
 if r.get('type')=='turn_context':
  pp=r['payload'];meta.append({k:pp[k] for k in ['model','effort','reasoning_effort'] if k in pp})
(build/'runtime.json').write_text(json.dumps({'actor_path':'/root/guidance_mode_complete_medium/guidance_allorder','session':str(session),'turn_context':meta},indent=2)+chr(10))
print('Fresh full compile and independent kernel checks passed for all generic all-order support.')
