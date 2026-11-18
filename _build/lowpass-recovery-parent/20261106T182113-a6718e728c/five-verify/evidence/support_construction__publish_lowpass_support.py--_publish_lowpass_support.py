from pathlib import Path
import json,hashlib,shutil,os
R=Path('/home/yangfp/five');t=json.loads((R/'_build/lowpass-recovery-parent/task.json').read_text())
D=R/'paparazzi/report/lowpass_recovery/support/retune_reset';D.mkdir(parents=True,exist_ok=True)
def write(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,indent=2)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
runtime=json.loads((R/'_build/lowpass-recovery-parent/support-runtime-config.json').read_text())
records=[]
for key in ['retune_support_run','retune_valid_blocks_run']:
 run=Path(t[key]);raw=json.loads((run/'run.json').read_text());m=json.loads((run/'metrics.json').read_text())
 assert raw['status']=='passed'
 dest=D/'evidence'/run.parent.name;shutil.copytree(run,dest/'raw',dirs_exist_ok=False)
 write(dest/'runtime-config.json',runtime);write(dest/'cost-audit.json',raw['cost_audit'])
 label='support-proof-report.md' if key=='retune_support_run' else 'retune-valid-block-report.md'
 shutil.copyfile(R/'_build/lowpass-recovery-parent'/label,dest/'report.md')
 rel=lambda p:os.path.relpath(p,D)
 row={'stage':'five-rocq','run':rel(dest/'raw'),'status':'recorded',
 'shared_batch_id':'lowpass_recovery_retune_reset_support','shared_cases':['update_first_order_low_pass_tau','reset_first_order_low_pass'],
 'measurement_scope':'Actual Sol medium support-proof construction and checks, including failed iterations. Shared by canonical proof problems: count these event receipts once.',
 'agent':{**{k:runtime[k]for k in ['model','requested_reasoning_effort','actual_reasoning_effort','session_id']},'evidence':rel(dest/'runtime-config.json')},
 'time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':m['time']['cpu_tool_seconds']},
 'token':{'input':m['tokens']['input_tokens'],'output':m['tokens']['output_tokens'],'total':m['tokens']['total_tokens'],'cached_input':m['tokens']['cached_input_tokens'],'reasoning_output':m['tokens']['reasoning_output_tokens']},
 'memory':{'tool_peak_rss_bytes':m['memory']['peak_process_tree_rss_sampled_bytes'],'tool_max_individual_process_rss_bytes':m['memory']['max_individual_process_rss_bytes']},
 'evidence':[rel(dest/'raw/run.json'),rel(dest/'raw/metrics.json'),rel(dest/'runtime-config.json'),rel(dest/'cost-audit.json'),rel(dest/'report.md')],
 'cost_audit_status':raw['cost_audit']['status'],'cost_audit_issues':raw['cost_audit']['issues'],'model_configs':[]}
 if row['time']['tool_cpu_seconds'] is None:
  row['unknown_reasons']={'time.tool_cpu_seconds':'The first55second kernel timeout killed GNU time before its CPU/RSS receipt; no full CPU total is fabricated. Subsequent complete kernel runs passed. All command logs and observed RSS samples remain.'}
  row['time']['recorded_tool_cpu_seconds']=m['time']['cpu_recorded_tool_seconds']
 for n in row['shared_cases']:
  f=R/'paparazzi/models'/n/'align/model/compcert-manifest.json';row['model_configs'].append({'case':n,'manifest':rel(f),'sha256':sha(f)})
 records.append(row)
write(D/'costs.json',{'schema':'five-stage-costs/1','records':records,'memory_scope':'Sampled launched-tool RSS, excludes model-server/desktop memory; not an overall concurrent-task peak.'})
lines=['# Retune and reset support proofs','','Final source proofs directly compile and pass independent full-dependency Rocq kernel checks. Retune and reset accept arbitrary binary32 values and arbitrary aligned offsets under twelve writable bytes and unsignedp+12<=2^64. No initialized old fields are assumed.','','The final retune summary additionally preserves every original valid block; its previous theorem interface remains a proved corollary. Full call proofs include allocation, parameter binding, actual original Csyntax body, cleanup, exact byte writes and original-valid-block frame. Canonical per-model and relation goals are validated separately.','','Actual model: GPT-6.1 Sol, medium. Model configurations and immutable original run receipts are in [costs.json](costs.json). Shared support work is counted once.','','|Run|Wall seconds|Tokens|Sampled tool RSS bytes|','|---|---:|---:|---:|']
for row in records:lines.append('|'+row['run']+'|'+str(row['time']['wall_seconds'])+'|'+str(row['token']['total'])+'|'+str(row['memory']['tool_peak_rss_bytes'])+'|')
lines+=['','The first development run retains a kernel timeout and its missing GNU-time CPU receipt: total tool CPU is null, with the observed command subtotal retained. A later full-dependency retry and final source checks passed. No resource value is estimated. Each run has a readable report recording its iterations.','']
(D/'report.md').write_text('\n'.join(lines));print('Two actual supporting-proof runs and readable reports published')
