from pathlib import Path
from datetime import datetime,timezone
from decimal import Decimal
import hashlib,json,os,sys
root=Path(__file__).resolve().parents[4];sys.path.insert(0,str(root/'scripts'))
from codex_usage import load
report=root/'paparazzi/report/lowpass_update_readback';case=root/'paparazzi/models/update_first_order_low_pass';relation=root/'paparazzi/relations/lowpass_update_readback'
parent=root/'_build/lowpass-update-readback-parent/20261107T055822-213c1c3ee8/five-verify'
maprun=root/'_build/lowpass-update-readback-parent/20261107T064309-d6174ef3de/five-align'
root_session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/03/rollout-2026-11-03T15-56-18-01a1a068-b2f7-7500-a3c6-86e0924879f5.jsonl')
worker_session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/07/rollout-2026-11-07T13-59-16-01a1b496-fd37-75f1-9982-f10250215e88.jsonl')
START='2026-11-07T05:57:43.620Z'
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,x):Path(p).parent.mkdir(parents=True,exist_ok=True);Path(p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+chr(10))
def stamp(x):return datetime.fromisoformat(x.replace('Z','+00:00'))
def token(events):
 keys=['input_tokens','output_tokens','cached_input_tokens','reasoning_output_tokens'];x={k:sum(e[k]for e in events)for k in keys};x['total_tokens']=x['input_tokens']+x['output_tokens'];return x
def fields(x):return {k:x.get(v)for k,v in [('input','input_tokens'),('output','output_tokens'),('total','total_tokens'),('cached_input','cached_input_tokens'),('reasoning_output','reasoning_output_tokens')]}
def publish(cutoff,publication_run):
 publication_run=Path(publication_run);runs=sorted(p for p in(root/'_build/lowpass-update-readback').glob('*/*')if(p/'run.json').is_file())+[parent,maprun]
 assert read(parent/'run.json')['status']=='passed' and read(publication_run/'run.json')['status']=='passed'
 assert all(read(p/'run.json')['status']!='running'for p in runs)
 # Real task actors only, using supplier event IDs and exact latest accepted user time.
 events={};actors=[];notes=[]
 for label,path in [('root',root_session),('worker',worker_session)]:
  identity,observed,_,warnings=load(path);notes+=warnings
  chosen=[e for e in observed if stamp(START)<=stamp(e['timestamp'])<=stamp(cutoff)]
  for e in chosen:
   if e['event_id']in events:assert events[e['event_id']]==e
   events[e['event_id']]=e
  actors.append({'actor':label,'thread_id':identity['thread_id'],'session':str(path),'selected_events':len(chosen),'first_event':chosen[0]['event_id']if chosen else None,'last_event':chosen[-1]['event_id']if chosen else None,'token':token(chosen),'scope':'Root: exact request timestamp through cutoff; worker: fresh current task actor including preflight and publication, through cutoff.'})
 all_events=sorted(events.values(),key=lambda e:(e['timestamp'],e['event_id']));all_token=token(all_events)
 command_rows=[];cpu=Decimal('0');missing_cpu=[];missing_sample=[];largest=None
 for run in runs:
  for c in read(run/'run.json').get('commands',[]):
   g=c.get('gnu_time');key=str(run.relative_to(root))+':'+c['id'];value=None
   if g is None or g.get('user_seconds')is None or g.get('system_seconds')is None:missing_cpu.append(key)
   else:value=Decimal(str(g['user_seconds']))+Decimal(str(g['system_seconds']));cpu+=value
   rss=c.get('peak_process_tree_rss_sampled_bytes')
   if rss is None or rss==0:missing_sample.append(key)
   if rss is not None:largest=max(largest or 0,rss)
   command_rows.append({'run':str(run.relative_to(root)),'command_id':c['id'],'outcome':c['status'],'gnu_cpu_seconds':float(value)if value is not None else None,'sampled_tree_peak_bytes':rss,'stdout':c['stdout'],'stderr':c['stderr'],'gnu_time_log':c['time_log']})
 assert len({(x['run'],x['command_id'])for x in command_rows})==len(command_rows)
 supplement=read(report/'evidence/root-concurrent-diagnostic/diagnostic-receipt.json');suppcpu=Decimal(str(supplement['time']['tool_cpu_seconds']));assert not any(x['command_id']==supplement['command_id']and x['run']==supplement['run']for x in command_rows)
 observed_cpu=cpu+suppcpu
 # Actual per-invocation records. Root wrapper inclusive child totals are never added again.
 stage_rows=[];assigned=set();child_ids=set()
 for run in runs:
  if run!=parent:child_ids.update(e['event_id']for e in read(run/'run.json').get('tokens',{}).get('events',[]))
 for run in runs:
  meta=read(run/'run.json');m=read(run/'metrics.json');owned=meta.get('tokens',{}).get('events',[])
  if run==parent:owned=[e for e in owned if e['event_id']not in child_ids]
  assigned.update(e['event_id']for e in owned)
  cmd=[x for x in command_rows if x['run']==str(run.relative_to(root))];known=[x['gnu_cpu_seconds']for x in cmd if x['gnu_cpu_seconds']is not None];rr=[x['sampled_tree_peak_bytes']for x in cmd if x['sampled_tree_peak_bytes']is not None]
  row={'stage':meta['skill'],'run':str(run.relative_to(root)),'status':'recorded','outcome':meta['status'],'time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':float(sum(Decimal(str(v))for v in known))if len(known)==len(cmd)else None},'token':fields(token(owned)),'memory':{'tool_peak_rss_bytes':max(rr)if rr else None},'cost_audit':meta.get('cost_audit',{}),'evidence':[os.path.relpath(run/'run.json',report),os.path.relpath(run/'metrics.json',report)],'scope':'Direct wall and actual invocation token events; metered own command GNU CPU and sampled command-tree peak. Root wrapper tokens exclude assigned child IDs and CPU excludes child command rows. Per-invocation RSS is an observed individual-command maximum, never a concurrent task peak.'}
  if '20261107T065613-c368bec83c'in row['run']:row.update(exclusive_authoring_token=None,exclusive_authoring_wall_seconds=None,authoring_boundary_limitation='0 observed session events inside the tool-only binding interval. Script authoring was in preceding actual CBMC interval; independent full mapping-authoring split is unknown. Task event union includes the real events.')
  stage_rows.append(row)
 unattributed=[e for e in all_events if e['event_id']not in assigned]
 wall=(stamp(cutoff)-stamp(START)).total_seconds()
 limits=['Task begins exact latest accepted user response_item at root session line22572; no whole historical root session is charged. Only current root/worker actor events through explicit cutoff are selected.','Input/output are real token_count deltas; cached-input and reasoning-output are subsets, not added to total. Unique event IDs are unioned once; per-attempt shared references do not add charges.','Stage authoring failures, terminated proof searches, failed19-row certificate, initial metadata gate failure, genuine corrective CBMC/mapping runs and final publication authoring are included. Historical getter model/proof expenses are excluded; new independent rechecks are included.','Root wrapper inclusive-child1505.20s is not added to child CPU. Direct chosen command IDs are summed once plus genuine orphan diagnostic GNU0.05s exactly once. Some pre-boundary setup/orchestration was outside those command meters, so inclusive all-tool CPU remains null.','Prepare/Rocq/extra align fast-read commands have missing tree RSS samples; observed maxima are scoped values. Root and worker ran concurrently without joint sampling, so concurrent total tool-tree peak and model-service/desktop memory remain null.','The tiny corrective mapping boundary has0 recorded events inside one tool call; full mapping authoring allocation is null/shared with preceding actual CBMC interval, not an asserted0 complete thought cost.','Cutoff is taken in final publishing invocation after all stage/parent/publication closures and authoring. Subsequent deterministic rendering/hash generation, final chat and Windows mirroring are explicitly outside the measured cutoff; no later usage is silently charged to this receipt.']
 result={'schema':'five-task-cost-union/1','status':'recorded','requested_at':START,'cutoff_utc':cutoff,'request_evidence':{'session':str(root_session),'source_line':22572,'exact_text':'继续做','timestamp':START},'actors':actors,'token':all_token,'unique_event_count':len(all_events),'events':all_events,'unattributed_actual_events':{'count':len(unattributed),'token':token(unattributed),'reason':'Preflight, gaps and post-closure authoring events with no exclusive stage boundary; retained in task union without retrospective allocation.'},'time':{'task_wall_seconds':wall,'direct_command_gnu_cpu_seconds':float(cpu),'supplementary_diagnostic_gnu_cpu_seconds':float(suppcpu),'observed_command_cpu_seconds':float(observed_cpu),'inclusive_all_tool_cpu_seconds':None},'memory':{'largest_observed_individual_command_tree_peak_bytes':largest,'concurrent_combined_task_peak_bytes':None,'inclusive_all_tool_peak_bytes':None,'model_service_peak_bytes':None},'commands':command_rows,'missing_gnu_receipts':missing_cpu,'commands_without_sampled_peak':missing_sample,'supplementary_receipt':'paparazzi/report/lowpass_update_readback/evidence/root-concurrent-diagnostic/diagnostic-receipt.json','limitations':limits,'notes':notes}
 dump(report/'evidence/task-token-union.json',result)
 dump(report/'costs.json',{'schema':'five-stage-costs/1','records':stage_rows,'task_aggregate_status':'recorded at final explicit cutoff; unknowns are null with reasons','task_aggregate':{k:result[k]for k in ['requested_at','cutoff_utc','token','unique_event_count','unattributed_actual_events','time','memory','limitations']},'task_union_receipt':'evidence/task-token-union.json','historical_getter_reuse':'Unchanged prior artifact and cost records, excluded from new task expense.'})
 for stage in ['prepare','cbmc','align','rocq']:
  rows=[]
  for x in stage_rows:
   if x['stage']=='five-'+stage:
    y=dict(x);y['evidence']=[os.path.relpath(root/x['run']/'run.json',case/stage/'report'),os.path.relpath(root/x['run']/'metrics.json',case/stage/'report')];rows.append(y)
  dump(case/stage/'report/costs.json',{'schema':'five-stage-costs/1','records':rows})
 dump(report/'evidence/cost-run-index.json',{'schema':'five-cost-run-index/1','closed_observed_runs':[str(p.relative_to(root))for p in runs],'cutoff_utc':cutoff,'task_union':'evidence/task-token-union.json','task_scope':'Exact latest user request plus two current actors only. All stage records are actual; no historical getter charge.','unobserved':'Concurrent combined RSS, model memory and inclusive unmetered CPU are null. See union limitations.'})
 # Bind the already performed independent root review, without rerunning a test.
 pm=read(parent/'run.json');selected=[x for x in pm['commands']if x['id'].startswith('020-')or x['id'].startswith('021-')or(x['id'].startswith('013-')and'independent-cold'in x['id'])];assert len(selected)==3 and all(x['status']=='passed'for x in selected)
 dump(report/'evidence/parent-final-review.json',{'run':str(parent.relative_to(root)),'status':pm['status'],'commands':[{'command_id':x['id'],'stdout':x['stdout'],'stderr':x['stderr'],'exit_code':x['exit_code']}for x in selected],'root_wrapper_wall_seconds':read(parent/'metrics.json')['time']['wall_seconds'],'note':'Closed once. Cold relation kernel, corrected full11 gate and candidate/report hash/readability review all passed. Failed019 packaging gate remains in immutable raw run.'})
 # Replace the human phase table; actual calls stay separate and per-attempt nulls stay explicit.
 lines=['| 实际调用 | token总数 | 直接墙钟秒 | 自身工具CPU秒 | 已观测单命令树RSS bytes |','| --- | ---: | ---: | ---: | ---: |']
 for x in stage_rows:lines.append('| '+x['stage']+' / '+x['run'].split('/')[-2]+' | '+str(x['token']['total'])+' | '+format(x['time']['wall_seconds'],'.3f')+' | '+str(x['time']['tool_cpu_seconds'])+' | '+str(x['memory']['tool_peak_rss_bytes'])+' |')
 lines.append('| 独立补充诊断（不重复计费） | null | null | 0.05 | null |')
 p=report/'review-report.zh-CN.md';text=p.read_text();a=text.index('| 实际阶段调用 |');z=text.index(chr(10)+'成本口径：',a);text=text[:a]+chr(10).join(lines)+chr(10)+text[z:]
 text=text.replace('最终任务事件并集与主 agent 收尾费用在父、子两个最终边界关闭后汇总，不提前估计。','父 run、worker finalverify 和本次真实 publication 边界均已关闭；最终任务事件并集、所有新调用和诊断补充已按明确截止点汇总。')
 text+=chr(10)+'最终成本截止点：`'+cutoff+'`；任务从最新原话“继续做”的 `'+START+'` 开始，端到端直接墙钟 '+format(wall,'.3f')+' 秒。'+chr(10)
 text+=chr(10)+'| 最终任务口径 | 实际记录 |'+chr(10)+'| --- | ---: |'+chr(10)+'| 去重token（input+output） | '+str(all_token['total_tokens'])+' |'+chr(10)+'| input / output | '+str(all_token['input_tokens'])+' / '+str(all_token['output_tokens'])+' |'+chr(10)+'| cached-input / reasoning-output（子集） | '+str(all_token['cached_input_tokens'])+' / '+str(all_token['reasoning_output_tokens'])+' |'+chr(10)+'| 端到端墙钟秒 | '+format(wall,'.3f')+' |'+chr(10)+'| 已计量命令GNU CPU秒（含补充0.05一次） | '+str(float(observed_cpu))+' |'+chr(10)+'| 含未计量setup的全部工具CPU | null |'+chr(10)+'| 已观测最大单命令工具树RSS bytes | '+str(largest)+' |'+chr(10)+'| 任务并发联合工具树RSS / 模型服务端内存 | null / null |'+chr(10)
 text+=chr(10)+'完整真实事件ID、实际调用三元成本、未知项原因、截止范围和去重命令集合见 [task-token-union.json](evidence/task-token-union.json) 与 [costs.json](costs.json)。'+chr(10)+'[主 agent 最终独立回执](evidence/parent-final-review.json) 保留冷关系内核、完整11问题门禁及102项候选哈希复核。所有新51个目标是精确类型绑定角色，不虚称51项彼此独立的数学性质。证明问题无 pending；原始库假设和固定 CompCert 边界按前文及各 attempt 报告保持。'+chr(10)+'本截止之后的确定性报告渲染、哈希清单生成、最终聊天和 Windows 镜像明确排除；它们不用于补造此前未观测资源。'+chr(10)
 p.write_text(text)
 temp=report/'phase-costs.zh-CN.txt'
 if temp.exists():temp.unlink()
 # Final publication binds reports/costs, core and every retained required raw receipt.
 files=set();excluded={'.vo','.vos','.vok','.glob','.aux','.pyc'}
 for base in [report,case,relation,root/'paparazzi/models/get_first_order_low_pass',*runs]:
  for q in base.rglob('*'):
   if q.is_file()and q.suffix not in excluded and '__pycache__'not in q.parts and q.name!='publication-manifest.json':files.add(q)
 local=read(report/'evidence/local-delivery-gate.json')
 for rr in local['result']['input_copy_audit']['runs']:
  for q in(root/rr).rglob('*'):
   if q.is_file():files.add(q)
 candidate=read(report/'evidence/core-candidate-002.json')
 for x in candidate['files']:
  q=root/x['path'];assert sha(q)==x['sha256'];files.add(q)
 manifest={'schema':'five-publication-manifest/1','status':'complete','cost_cutoff_utc':cutoff,'measurement_after_cutoff_excluded':['deterministic rendering and hashing','final chat','Windows mirroring'],'candidate':{'path':'paparazzi/report/lowpass_update_readback/evidence/core-candidate-002.json','sha256':sha(report/'evidence/core-candidate-002.json')},'new_goal_bindings':51,'active_problems':11,'actual_cbmc_properties':36,'report':'paparazzi/report/lowpass_update_readback/review-report.zh-CN.md','costs':'paparazzi/report/lowpass_update_readback/costs.json','files':[{'path':str(q.relative_to(root)),'sha256':sha(q)}for q in sorted(files)],'self_hash':'Not included to avoid a circular hash; consumer may hash this manifest separately.'}
 dump(report/'publication-manifest.json',manifest)
 return {'cutoff_utc':cutoff,'requested_at':START,'token':all_token,'unique_event_count':len(all_events),'time':result['time'],'memory':result['memory'],'manifest_files':len(files),'manifest_sha256':sha(report/'publication-manifest.json'),'report':str(p.relative_to(root)),'publication_run':str(publication_run.relative_to(root))}
