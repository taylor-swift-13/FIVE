from pathlib import Path
import json,os
root=Path(__file__).resolve().parents[4];case=root/'paparazzi/models/get_first_order_low_pass';report=root/'paparazzi/report/lowpass_readback'
def dump(p,o):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+'\n')
def rel(p,b):return os.path.relpath(p,b)
def row(run,base):
 r=json.loads((run/'run.json').read_text());m=json.loads((run/'metrics.json').read_text());t=m['tokens'];stage=r['skill']
 result={'stage':stage,'run':str(run.relative_to(root)),'outcome':r['status'],'status':'recorded','time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':m['time']['cpu_tool_seconds'] if m.get('command_count') else None},'token':{k:t.get(v)for k,v in [('input','input_tokens'),('output','output_tokens'),('total','total_tokens'),('cached_input','cached_input_tokens'),('reasoning_output','reasoning_output_tokens')]},'memory':{'tool_peak_rss_bytes':m['memory']['peak_process_tree_rss_sampled_bytes'] if m.get('command_count') else None},'inclusive_resources':{'tool_cpu_seconds':None,'tool_peak_rss_bytes':None,'reason':'Direct authoring/setup Python file-construction helpers outside Run.command were not sampled. The displayed tool CPU/RSS are the actual metered command set only; inclusive unknowns remain null.'},'evidence':[rel(run/'run.json',base),rel(run/'metrics.json',base)],'measurement_scope':'Genuine skill-session event boundaries and direct elapsed wall. Metered command CPU and requested10ms tool-tree RSS; cache/reasoning subsets; no historical model expense reallocation. RSS may miss short peaks or count shared pages, excludes model service/desktop.'}
 return result
runs=[]
for run in sorted((root/'_build/lowpass-readback').glob('*/*')):
 if not(run/'run.json').exists():continue
 if json.loads((run/'run.json').read_text()).get('status')=='running':continue
 runs.append(run)
for stage in ['prepare','cbmc','align','rocq']:
 p=case/stage/'report/costs.json';records=[row(r,p.parent)for r in runs if json.loads((r/'run.json').read_text())['skill']=='five-'+stage]
 dump(p,{'schema':'five-stage-costs/1','records':records})
dump(report/'evidence/cost-run-index.json',{'schema':'five-cost-run-index/1','closed_worker_runs':[str(r.relative_to(root))for r in runs],'historical_reset_reuse':{'source':'paparazzi/models/reset_first_order_low_pass','costs':'paparazzi/models/reset_first_order_low_pass/rocq/report/costs.json','classification':'historical reuse, excluded from new verification cost; fresh independent parent review expense separately counted'},'inclusive_setup_cpu_rss':'null; genuinely unobserved, no replay or estimate substitutes missing data'})
dump(report/'costs.json',{'schema':'five-stage-costs/1','records':[row(r,report)for r in runs],'historical_reuse_costs':rel(root/'paparazzi/models/reset_first_order_low_pass/rocq/report/costs.json',report),'task_aggregate_status':'awaiting closed parent and worker final verification receipts; every existing record is actual observed expense'})
print('updated exact closed-stage observed costs, inclusive CPU/RSS remain null')
