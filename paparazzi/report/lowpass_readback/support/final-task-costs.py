from pathlib import Path
from datetime import datetime,timezone
import json,sys,hashlib
root=Path(__file__).resolve().parents[4];sys.path.insert(0,str(root/'scripts'))
from codex_usage import load,snapshot
report=root/'paparazzi/report/lowpass_readback';parent=root/'_build/lowpass-readback-parent/20261107T025508-95071a24e8/five-verify'
worker=root/'_build/lowpass-readback/20261107T032720-ddeef023e7/five-verify'
corrected_parent=root/'_build/lowpass-readback-parent/20261107T033425-a0410ae821/five-verify'
assert json.loads((corrected_parent/'run.json').read_text())['status']=='passed'
assert json.loads((parent/'run.json').read_text())['status']=='passed'
assert json.loads((worker/'run.json').read_text())['status']=='passed'
root_session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/03/rollout-2026-11-03T15-56-18-01a1a068-b2f7-7500-a3c6-86e0924879f5.jsonl')
worker_session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/07/rollout-2026-11-07T10-54-09-01a1b3ed-81ea-7553-a106-7d239b861b27.jsonl')
start='2026-11-07T02:53:02.782Z';end=datetime.now(timezone.utc).isoformat()
rows=[];events={};notes=[];bounds={}
for label,path in [('root',root_session),('worker',worker_session)]:
 identity,observed,totals,warnings=load(path);notes+=warnings;bounds[label]=snapshot(path)
 chosen=[e for e in observed if e['timestamp']>=start]
 for e in chosen:
  if e['event_id']in events:assert events[e['event_id']]==e
  events[e['event_id']]=e
 rows.append({'actor':label,'thread_id':identity['thread_id'],'session':str(path),'events':len(chosen),'source':'genuine codex token_count cumulative deltas; no text-length estimate'})
# Capture independent direct command receipts once, excluding all nested backend runs not selected here.
runs=sorted([p for p in (root/'_build/lowpass-readback').glob('*/*')if(p/'run.json').exists()]+[parent,corrected_parent])
commands=[];cpu=0;missing=[];maxrss=None
for run in runs:
 meta=json.loads((run/'run.json').read_text());assert meta['status']!='running'
 for cmd in meta.get('commands',[]):
  key=str(run.relative_to(root))+':'+cmd['id'];g=cmd.get('gnu_time')
  if g is None or g.get('user_seconds')is None or g.get('system_seconds')is None:missing.append(key)
  else:cpu+=g['user_seconds']+g['system_seconds']
  rss=cmd.get('peak_process_tree_rss_sampled_bytes')
  if rss is not None:maxrss=max(rss,maxrss or 0)
  commands.append({'run':str(run.relative_to(root)),'command_id':cmd['id'],'status':cmd['status'],'gnu_cpu_seconds':None if g is None else g.get('user_seconds',0)+g.get('system_seconds',0),'sampled_tree_peak_bytes':rss})
keys=['input_tokens','output_tokens','cached_input_tokens','reasoning_output_tokens']
totals={k:sum(e[k]for e in events.values())for k in keys};totals['total_tokens']=totals['input_tokens']+totals['output_tokens']
duration=(datetime.fromisoformat(end)-datetime.fromisoformat(start.replace('Z','+00:00'))).total_seconds()
result={'schema':'five-task-cost-union/1','status':'recorded','requested_at':start,'cutoff_utc':end,'boundaries':bounds,'actors':rows,'token':totals,'unique_event_count':len(events),'events':list(events.values()),'time':{'task_wall_seconds':duration,'metered_tools_observed_cpu_seconds':cpu,'metered_cpu_total_seconds':cpu if not missing else None,'inclusive_all_tool_cpu_seconds':None},'memory':{'largest_observed_individual_command_tree_peak_bytes':maxrss,'concurrent_combined_task_peak_bytes':None,'inclusive_all_tool_peak_bytes':None},'commands':commands,'missing_gnu_receipts':missing,'limitations':['Task root token selection begins exact latest accepted user-message timestamp; worker is fresh task actor. Cutoff is explicit current observed token-event boundaries; subsequent final rendering/reporting events are outside this receipt.','Root inclusive-child metrics are not summed; direct selected command IDs and genuine token event IDs are counted once. Historical reused reset expenses excluded; fresh verification/review costs included.','Some authoring/setup helpers were outside Run.command, so inclusive total CPU/RSS are genuinely unknown/null. Observed command-scoped GNU CPU and requested10ms sampled tree RSS remain exact recorded readings.','Root and worker tools overlap, so there is no observed combined concurrent memory peak; maximum individual command sample is not a total peak.'],'notes':notes}
(report/'evidence/task-token-union.json').write_text(json.dumps(result,indent=2)+'\n')
p=report/'costs.json';costs=json.loads(p.read_text());costs['task_aggregate_status']='recorded at explicit cutoff; unknown inclusive CPU/RSS null';costs['task_aggregate']={k:result[k]for k in ['requested_at','cutoff_utc','token','unique_event_count','time','memory','limitations']};costs['root_verification_reference']={'run':str(corrected_parent.relative_to(root)),'metrics_sha256':hashlib.sha256((corrected_parent/'metrics.json').read_bytes()).hexdigest(),'note':'Corrected finalverify successfully closed; prior original root close failed and its immutable metrics may be stale. Both actual command sets and actual root task token events are included once.'};p.write_text(json.dumps(costs,indent=2)+'\n')
print(json.dumps({k:result[k]for k in ['requested_at','cutoff_utc','token','unique_event_count','time','memory']},indent=2))
