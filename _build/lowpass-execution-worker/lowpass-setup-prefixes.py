from pathlib import Path
import json,sys,hashlib
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'));from codex_usage import receipt
out=r/'paparazzi/report/lowpass_recovery/cost-inputs';out.mkdir(parents=True,exist_ok=True);rows=[]
actors=[('main','_build/lowpass-recovery-work/20261106T182324-5fa7b7400d/five-prepare/run.json'),('execution_evidence','_build/lowpass-execution-worker/20261106T182525-bd199eec90/five-rocq/run.json'),('proof_support','runs/20261106T182428-935707452d/five-rocq/run.json')]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for actor,relative in actors:
 p=r/relative;d=json.loads(p.read_text());b=d['codex_usage_boundary'];first=b['before'];session=b['session_file'];empty={'thread_id':first['thread_id'],'last_event_id':None};usage=receipt(session,after=empty,before=first)
 assert usage['boundaries']['after_event_id'] is None and usage['boundaries']['before_event_id']==first['last_event_id']
 if actor=='main':assert (len(usage['events']),usage['totals']['input_tokens'],usage['totals']['output_tokens'],usage['total_tokens'],usage['totals']['cached_input_tokens'])==(7,203520,1073,204593,179456)
 q=out/(actor+'-setup-prefix.usage.json');q.write_text(json.dumps(usage,indent=2)+'\n')
 rows.append({'actor':actor,'attribution':'setup_unattributed','boundary_run':relative,'boundary_run_sha256':sha(p),'prefix_after':empty,'prefix_before':first,'usage_receipt':str(q.relative_to(r)),'usage_receipt_sha256':sha(q),'event_count':len(usage['events']),'time':{'wall_seconds':None,'tool_cpu_seconds':None},'memory':{'tool_peak_rss_bytes':None},'unknown_reason':'Real prefix model events are known exactly. Setup tools had no instrumentation boundary, so their CPU/RSS and setup wall scope remain unknown; no per-stage allocation or replay substitutes them.'})
 print(actor,len(usage['events']),usage['totals'],usage['total_tokens'])
(out/'setup-prefix-index.json').write_text(json.dumps({'schema':'five-setup-prefix-index/1','attribution':'setup_unattributed','scope':'Exactly three fresh actor session prefixes before their first actual stage boundary; excludes root older long session and is not attributed to prepare/CBMC/Rocq.','records':rows,'aggregation':'Event-ID union with later stage receipts; explicit before/after boundaries; no estimated split.'},indent=2)+'\n')
