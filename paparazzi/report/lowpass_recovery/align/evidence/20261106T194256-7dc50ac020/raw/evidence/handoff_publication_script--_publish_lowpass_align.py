from pathlib import Path
import json,hashlib,shutil,os
R=Path('/home/yangfp/five');task=json.loads((R/'_build/lowpass-recovery-parent/task.json').read_text())
names=['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']
runs=[R/'_build/lowpass-recovery-work'/d/'five-align'for d in ['20261106T182525-506f0be054','20261106T182537-b10b6d24a1','20261106T182702-5e8d8be790']]
runs += [Path(task['align_finalization_run']),Path(task['align_package_run'])]
D=R/'paparazzi/report/lowpass_recovery/align';D.mkdir(parents=True,exist_ok=True)
def write(p,d):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(d,indent=2)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
records=[];events={}
for run in runs:
 raw=json.loads((run/'run.json').read_text());m=json.loads((run/'metrics.json').read_text())
 assert raw['status']!='running'
 dest=D/'evidence'/run.parent.name;shutil.copytree(run,dest/'raw',dirs_exist_ok=False)
 session=Path(raw['codex_usage_boundary']['session_file']);last=None;sid=None
 for line in session.read_text().splitlines():
  e=json.loads(line);p=e.get('payload',{})
  if e.get('type')=='session_meta'and sid is None:sid=p['id']
  if e.get('type')=='turn_context':last=p
 assert last['model']=='gpt-6.1-sol'and last['effort']=='medium'
 write(dest/'runtime-config.json',{'model':last['model'],'requested_reasoning_effort':'medium','actual_reasoning_effort':last['effort'],'session_id':sid,'source_session':str(session),'source':'Observed actual Codex turn_context fields only'})
 write(dest/'cost-audit.json',raw['cost_audit'])
 for event in raw.get('tokens',{}).get('events',[]):events[event['event_id']]=event
 rel=lambda p:str(p.relative_to(D))
 row={'stage':'five-align','run':rel(dest/'raw'),'status':'recorded','shared_batch_id':'lowpass_recovery_align','shared_cases':names,
 'measurement_scope':'Actual shared export/audit/packaging window including failed commands. Not an invented exclusive per-case allocation. Some historical normalization/export windows overlap preparation; global tokens use event-ID union rather than adding these totals. Nested exporter CPU is already inside the measured outer command.',
 'agent':{'model':'gpt-6.1-sol','requested_reasoning_effort':'medium','actual_reasoning_effort':'medium','session_id':sid,'evidence':rel(dest/'runtime-config.json')},
 'time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':m['time']['cpu_tool_seconds']},
 'token':{'input':m['tokens']['input_tokens'],'output':m['tokens']['output_tokens'],'total':m['tokens']['total_tokens'],'cached_input':m['tokens']['cached_input_tokens'],'reasoning_output':m['tokens']['reasoning_output_tokens']},
 'memory':{'tool_peak_rss_bytes':m['memory']['peak_process_tree_rss_sampled_bytes'],'tool_max_individual_process_rss_bytes':m['memory']['max_individual_process_rss_bytes']},
 'evidence':[rel(dest/'raw/run.json'),rel(dest/'raw/metrics.json'),rel(dest/'runtime-config.json'),rel(dest/'cost-audit.json')],
 'cost_audit_status':raw['cost_audit']['status'],'cost_audit_issues':raw['cost_audit']['issues'],'tool_verdict':raw['status'],
 'memory_scope':'Observed launched-tool10ms sampled RSS, may miss short peaks/count shared pages twice; excludes model-serving memory.'}
 missing=m['memory'].get('commands_without_sampled_tree_peak',[])
 if missing:row['memory']['commands_without_sampled_tree_peak']=missing
 if row['time']['tool_cpu_seconds']is None:row['unknown_reasons']={'time.tool_cpu_seconds':'A required complete tool CPU receipt is unavailable; original audit lists missing records. No total is estimated.'}
 records.append(row)
shared={'schema':'five-stage-costs/1','records':records,'accounting':'One shared three-case align batch; repeated case references are not additional work. Nested export provenance is not added again. Global cost uses unique token event IDs.','unique_token_total':sum(x['input_tokens']+x['output_tokens']for x in events.values())}
write(D/'costs.json',shared)
for name in names:
 c=R/'paparazzi/models'/name;p=c/'align';out=p/'report'
 rows=json.loads(json.dumps(records))
 for row in rows:
  row['run']=os.path.relpath(D/row['run'],out)
  row['evidence']=[os.path.relpath(D/q,out)for q in row['evidence']]
  row['agent']['evidence']=os.path.relpath(D/row['agent']['evidence'],out)
  row['shared_costs']=os.path.relpath(D/'costs.json',out)
 write(out/'costs.json',{'schema':'five-stage-costs/1','records':rows,'accounting':shared['accounting']})
 files=[p/'request.json',out/'report.md',out/'costs.json',out/'evidence/provenance-audit.json']
 files += [q for q in sorted((p/'model').rglob('*'))if q.is_file()and q.suffix in ('.v','.json','.i','.ml','.mli')]
 handoff={'schema':'five-stage-handoff/1','case_id':name,'stage':'five-align','status':'generated','input_handoff':'cbmc/handoff.json','input_handoff_sha256':sha(c/'cbmc/handoff.json'),'prepare_handoff':'prepare/handoff.json','prepare_handoff_sha256':sha(c/'prepare/handoff.json'),'cbmc_handoff':'cbmc/handoff.json','cbmc_handoff_sha256':sha(c/'cbmc/handoff.json'),'outputs':[{'path':str(q.relative_to(c)),'sha256':sha(q)}for q in files],'cbmc_mapping_status':'mapped','spec_map':'align/model/spec-map.json','implementation_issues':{'shared_batch':'lowpass_recovery_align','found':2,'resolved':2,'unresolved':0},'proof_boundary':'Generated model/parameterized obligations and mapped pending propositions. Actual proofs: rocq/<task>/attempts/<id>/Proof.v; canonical questions: rocq/<task>/problem/Spec.v.','limitations':['Standalone entry only: static inline declaration normalization, unchanged original body; CompCert target semantics, no separate GCC/hardware equivalence claim.']}
 write(p/'handoff.json',handoff)
print(json.dumps({'status':'generated','cases':names,'shared_receipts':len(records),'unique_align_window_tokens':shared['unique_token_total']},indent=2))
