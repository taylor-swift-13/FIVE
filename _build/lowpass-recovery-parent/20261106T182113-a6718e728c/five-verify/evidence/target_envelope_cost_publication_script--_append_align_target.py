from pathlib import Path
import json,hashlib,shutil,os
R=Path('/home/yangfp/five');t=json.loads((R/'_build/lowpass-recovery-parent/task.json').read_text());run=Path(t['align_target_fix_run'])
D=R/'paparazzi/report/lowpass_recovery/align';shared=json.loads((D/'costs.json').read_text());old=shared['records'][-1]
raw=json.loads((run/'run.json').read_text());m=json.loads((run/'metrics.json').read_text());assert raw['status']=='passed'
dest=D/'evidence'/run.parent.name;shutil.copytree(run,dest/'raw',dirs_exist_ok=False)
shutil.copyfile(D/old['agent']['evidence'],dest/'runtime-config.json')
(dest/'cost-audit.json').write_text(json.dumps(raw['cost_audit'],indent=2)+'\n')
row=json.loads(json.dumps(old));rel=lambda p:str(p.relative_to(D))
row.update(run=rel(dest/'raw'),measurement_scope='Short measured target-envelope correction from frozen model manifests; original handoffs retained as immutable inputs. No mathematical source or model changed.',tool_verdict='passed',cost_audit_status=raw['cost_audit']['status'],cost_audit_issues=raw['cost_audit']['issues'])
row['agent']['evidence']=rel(dest/'runtime-config.json')
row['time']={'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':m['time']['cpu_tool_seconds']}
row['token']={'input':m['tokens']['input_tokens'],'output':m['tokens']['output_tokens'],'total':m['tokens']['total_tokens'],'cached_input':m['tokens']['cached_input_tokens'],'reasoning_output':m['tokens']['reasoning_output_tokens']}
row['memory']={'tool_peak_rss_bytes':m['memory']['peak_process_tree_rss_sampled_bytes'],'tool_max_individual_process_rss_bytes':m['memory']['max_individual_process_rss_bytes']}
row['evidence']=[rel(dest/'raw/run.json'),rel(dest/'raw/metrics.json'),rel(dest/'runtime-config.json'),rel(dest/'cost-audit.json')]
row.pop('unknown_reasons',None);shared['records'].append(row)
events={}
for rec in shared['records']:
 for e in json.loads((D/rec['run']/'run.json').read_text()).get('tokens',{}).get('events',[]):events[e['event_id']]=e
shared['unique_token_total']=sum(e['input_tokens']+e['output_tokens']for e in events.values())
(D/'costs.json').write_text(json.dumps(shared,indent=2)+'\n')
for n in row['shared_cases']:
 c=R/'paparazzi/models'/n;p=c/'align';out=p/'report';rows=json.loads(json.dumps(shared['records']))
 for item in rows:
  item['run']=os.path.relpath(D/item['run'],out)
  item['evidence']=[os.path.relpath(D/x,out)for x in item['evidence']]
  item['agent']['evidence']=os.path.relpath(D/item['agent']['evidence'],out);item['shared_costs']=os.path.relpath(D/'costs.json',out)
 (out/'costs.json').write_text(json.dumps({'schema':'five-stage-costs/1','records':rows,'accounting':shared['accounting']},indent=2)+'\n')
 h=json.loads((p/'handoff.json').read_text())
 for x in h['outputs']:
  if x['path']=='align/report/costs.json':x['sha256']=hashlib.sha256((c/x['path']).read_bytes()).hexdigest()
 (p/'handoff.json').write_text(json.dumps(h,indent=2)+'\n')
print('Target-envelope correction and its measured cost published; all old raw receipts retained.')
