from pathlib import Path
import json,hashlib,os,sys
R=Path('/home/yangfp/five');os.chdir(R);sys.path.insert(0,str(R/'scripts'));from five_telemetry import Run
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
entries=['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']
for e in entries:
 c=R/'paparazzi/models'/e;prior=json.loads((c/'align/handoff.json').read_text());outs=[];seen=set()
 def add(role,p):
  p=Path(p);rel=str(p.relative_to(c))
  if rel in seen:return
  assert p.is_file(),p;seen.add(rel);outs.append({'role':role,'path':rel,'sha256':sha(p)})
 for row in prior['outputs']:
  p=c/row['path'];assert sha(p)==row['sha256'],p
  add('inherited_align_'+row.get('role',str(len(outs))),p)
 add('input_align_handoff',c/'align/handoff.json')
 goals={}
 for problem in sorted((c/'rocq').glob('*/problem')):
  name=problem.parent.name;s=json.loads((problem/'status.json').read_text());assert s['status']=='proved',(e,name)
  a=(problem/s['active_attempt']).resolve();goals[name]=list(s['requested_goals'])
  for role,p in [('question',problem/'Spec.v'),('problem_status',problem/'status.json'),('question_report',problem/'report.md'),('active_proof',a/'Proof.v'),('reproducer',a/'check.py'),('attempt_report',a/'report.md'),('attempt_costs',a/'costs.json'),('goal_validation',a/'evidence/goal-validation.json')]:add(name+'_'+role,p)
  for fname in ['provenance.json','evidence/kernel-evidence.json','evidence/certificate-kernel-evidence.json','evidence/runtime-metadata.json','evidence/runtime-agent.json']:
   p=a/fname
   if p.exists():add(name+'_'+fname.replace('/','_'),p)
 for role,rel in [('execution_contract','rocq/execution-contract.json'),('actual_cbmc_recheck','rocq/spec-recheck.json'),('rocq_report','rocq/report/report.md'),('rocq_costs','rocq/report/costs.json')]:add(role,c/rel)
 handoff={'schema':'five-stage-handoff/1','case_id':e,'stage':'five-rocq','status':'proved','input_handoff':'align/handoff.json','target':prior['target'],'paths_relative_to':'case','proved':goals,'pending':[],'outputs':outs,'limitations':['All claims use pinned CompCert3.17 Csem/Cexec, x86-64 Linux little endian binary32 nearest-even and fixed NaN policy; no automatic GCC/hardware transfer.','Final traditional CBMC covers source safety and exact value-copy/frame/return assertions; coefficient arithmetic is proved independently over all typed float32 inputs in Rocq. Earlier arithmetic CBC attempts remain unresolved historical tool attempts.','Historical telemetry and evidence-packaging defects and their transparent amendments are retained. Recorded values and null reasons are separate from proof closure.'],'next_stage':'five-verify'}
 (c/'rocq/handoff.json').write_text(json.dumps(handoff,indent=2)+'\n');print(e,len(outs),'hash-bound outputs')
# Capture the producer and frozen stage handoffs in the live verification run.
r=Run((R/'_build/lowpass-recovery-work/verify-run.txt').read_text().strip())
for e in entries:r.capture(R/'paparazzi/models'/e/'rocq/handoff.json',e+'-final-rocq-handoff',area='inputs')
