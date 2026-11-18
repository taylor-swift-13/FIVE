from pathlib import Path
import json,hashlib,os,sys
R=Path('/home/yangfp/five');review=R/sys.argv[1];assert json.loads((review/'run.json').read_text())['status']!='running'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def record(run,base,stage,scope):
 m=json.loads((run/'metrics.json').read_text());t=m['tokens'];cpu=m['time'].get('cpu_tool_seconds');mem=m['memory'].get('peak_process_tree_rss_sampled_bytes')
 x={'stage':stage,'run':os.path.relpath(run,base),'status':'recorded','scope':scope,'evidence':[os.path.relpath(run/'run.json',base),os.path.relpath(run/'metrics.json',base)],'time':{'wall_seconds':m['time']['wall_seconds'],'tool_cpu_seconds':cpu,'recorded_tool_cpu_seconds':m['time'].get('cpu_recorded_tool_seconds')},'token':{'input':t.get('input_tokens'),'output':t.get('output_tokens'),'total':t.get('total_tokens'),'cached_input':t.get('cached_input_tokens'),'reasoning_output':t.get('reasoning_output_tokens')},'memory':{'tool_peak_rss_bytes':mem},'event_ids':[e['event_id']for e in t.get('events',[])]}
 if run==review:
  x['time']['tool_cpu_seconds']=None;x['time']['unknown_reason']='Multi-stage parent scope overlaps its child probes and contains incompletely collected killed solver descendants. No exclusive per-stage CPU allocation is inferred; raw known figures are retained.'
 if cpu is None:x['time']['unknown_reason']='Raw measured complete tool CPU is unavailable; historical failed/timeout lower bounds remain in the original receipts.'
 return x
for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
 c=R/'paparazzi/models'/entry
 for stage,rid in [('prepare',None),('cbmc','20261106T142642-13b1f6db45'),('align','20261106T142930-2d547b8127')]:
  b=c/stage/'report';p=b/'costs.json';d=json.loads(p.read_text());items=[]
  if rid:items.insert(0,(R/'_build/guidance-mode-work'/rid/('five-'+stage),'Shared actual final ledger/handoff authoring; both cases reference the same measured run.'))
  for run,scope in items:
   rel=os.path.relpath(run,b)
   if not any(x.get('run')==rel for x in d['records']):d['records'].append(record(run,b,'five-'+stage,scope))
  normalized=R/'paparazzi/report/guidance_mode/independent-review/authoring-review-costs.json'
  for row in json.loads(normalized.read_text())['records']:
   copy=json.loads(json.dumps(row));copy['run']=os.path.relpath(R/row['run'],b);copy['evidence']=[os.path.relpath(R/x,b)for x in row['evidence']];copy['shared_costs']=os.path.relpath(normalized,b);copy['scope']=row['scope']+' Shared multi-stage reference only; no exclusive per-phase or per-case allocation. Count its actual event IDs once globally.'
   if not any(x.get('run')==copy['run']and x.get('scope')==copy['scope']for x in d['records']):d['records'].append(copy)
  p.write_text(json.dumps(d,indent=2)+'\n')
 # Refresh inherited upstream artifacts in dependency order, retaining original roles.
 for stage in ['prepare','cbmc','align']:
  p=c/stage/'handoff.json';d=json.loads(p.read_text())
  for out in d['outputs']:
   q=(c/out['path']).resolve();assert q.is_file(),q;out['sha256']=sha(q)
  p.write_text(json.dumps(d,indent=2)+'\n')
 print(entry,'CBC/align costs and all inherited handoff hashes frozen')
