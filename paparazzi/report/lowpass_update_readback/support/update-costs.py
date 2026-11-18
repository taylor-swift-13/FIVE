from pathlib import Path
import json,os
root=Path(__file__).resolve().parents[4];case=root/'paparazzi/models/update_first_order_low_pass';report=root/'paparazzi/report/lowpass_update_readback'
def dump(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,indent=2)+chr(10))
def row(run,base):
 d=json.loads((run/'run.json').read_text());m=json.loads((run/'metrics.json').read_text());t=m['tokens'];a=d.get('cost_audit',{})
 return {'stage':d['skill'],'run':str(run.relative_to(root)),'outcome':d['status'],'status':'recorded','time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':m['time']['cpu_tool_seconds']},'token':{k:t.get(v)for k,v in [('input','input_tokens'),('output','output_tokens'),('total','total_tokens'),('cached_input','cached_input_tokens'),('reasoning_output','reasoning_output_tokens')]},'memory':{'tool_peak_rss_bytes':m['memory']['peak_process_tree_rss_sampled_bytes']},'cost_audit':{'status':a.get('status'),'issues':a.get('issues',[])},'evidence':[os.path.relpath(run/'run.json',base),os.path.relpath(run/'metrics.json',base)],'scope':'Actual skill-session usage events and direct wall; metered command GNU CPU and sampled tool-tree RSS. Cache/reasoning subsets; sampled RSS may miss short peaks/count shared pages, excludes model server/desktop. All failures/retries included. This is observed command scope, not an exact system-wide memory peak.'}
runs=[p for p in sorted((root/'_build/lowpass-update-readback').glob('*/*'))if(p/'run.json').is_file()and json.loads((p/'run.json').read_text()).get('status')!='running']
additional=root/'_build/lowpass-update-readback-parent/20261107T064309-d6174ef3de/five-align';runs.append(additional)
for stage in ['prepare','cbmc','align','rocq']:
 p=case/stage/'report/costs.json';dump(p,{'schema':'five-stage-costs/1','records':[row(r,p.parent)for r in runs if json.loads((r/'run.json').read_text())['skill']=='five-'+stage]})
dump(report/'evidence/cost-run-index.json',{'schema':'five-cost-run-index/1','closed_observed_runs':[str(r.relative_to(root))for r in runs],'worker_session':'/mnt/c/Users/50635/.codex/sessions/2026/11/07/rollout-2026-11-07T13-59-16-01a1b496-fd37-75f1-9982-f10250215e88.jsonl','preflight':'Actor setup references/session discovery and reusable GetCall inspection preceded prepare boundary. Actual actor events belong to task union as unattributed setup; no retrospective phase split.','historical_getter_reuse':'paparazzi/models/get_first_order_low_pass: all historical model/proof/report/cost files unchanged and excluded from new expenses. Fresh root cold/gate checks have their own actual new costs.','nested_tool_runs':'Internal exporter tool run resources are already inside measured export command; not added twice.','concurrent_task_peak':None,'concurrent_task_peak_reason':'Root review/kernel and worker tools ran concurrently; no joint sampling was established. Per-invocation sampled observations are retained, not promoted to a task-wide peak.'})
dump(report/'costs.json',{'schema':'five-stage-costs/1','records':[row(r,report)for r in runs],'task_aggregate_status':'Awaiting closed root/worker final-verification boundaries and event-ID union. Per-attempt references are not additional charges.','historical_getter_costs':'../../models/get_first_order_low_pass/rocq/report/costs.json','null_policy':'Unobserved per-attempt thinking allocation, pre-boundary phase allocation, model-server memory, concurrent task peak and lost supplemental diagnostic sampler metrics remain null with reasons.','root_supplementary_diagnostic':'evidence/root-concurrent-diagnostic/diagnostic-receipt.json: actual GNU CPU0.05s, standalone GNU RSS retained; root Run wall/sampled RSS unavailable; add CPU once outside overwritten command row.'})
for costpath in [case/'align/report/costs.json',report/'costs.json']:
 data=json.loads(costpath.read_text())
 for record in data['records']:
  if '20261107T065613-c368bec83c' in record['run']:
   record['exclusive_authoring_token']=None
   record['exclusive_authoring_wall_seconds']=None
   record['authoring_boundary_limitation']='Tool-only binding update: 0 session events observed between start/finish within one tool call. Script authoring occurred in preceding actual CBMC interval; task union includes it, exclusive mapping authoring allocation unknown.'
 dump(costpath,data)
rows=[row(r,report)for r in runs]
lines=['| 实际阶段调用 | token总数 | 墙钟秒 | 工具CPU秒 | 已观测工具树RSS bytes |','| --- | ---: | ---: | ---: | ---: |']
for x in rows:lines.append('| '+x['stage']+' / '+x['run'].split('/')[-2]+' | '+str(x['token']['total'])+' | '+str(x['time']['wall_seconds'])+' | '+str(x['time']['tool_cpu_seconds'])+' | '+str(x['memory']['tool_peak_rss_bytes'])+' |')
(report/'phase-costs.zh-CN.txt').write_text(chr(10).join(lines)+chr(10))
print(chr(10).join(lines))
