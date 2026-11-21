from pathlib import Path
import os,sys,json,hashlib,subprocess,traceback
R=Path('/home/yangfp/five');os.chdir(R);sys.path.insert(0,str(R/'scripts'))
from five_telemetry import Run
RUN=R/'_build/matrix-cbmc-snapshot-replay/20261121T083410-b9f09d7425/five-cbmc';run=Run(RUN)
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p):return str(p.relative_to(R))
def write(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
def trace_sha(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()
cases=[]
try:
 run.capture(Path(__file__),'replay-driver',area='inputs')
 for dim in ['2d','3d']:
  c=R/'paparazzi/models'/('float_mat_inv_'+dim);sm=read(c/'align/spec-map.json');old=R/sm['cbmc_run'];m=read(old/'run.json');cmd=next(x for x in m['commands'] if x['id']==sm['cbmc_command_id'])
  for label,p in [('source',c/'prepare/source'/('float_mat_inv_'+dim+'.c')),('harness',c/'cbmc/harness.c'),('bindings',c/'prepare/source/bindings.json'),('request',c/'prepare/verification-request.json'),('prepare-handoff',c/'prepare/handoff.json')]:run.capture(p,dim+'-'+label,area='inputs')
  cases.append((dim,c,sm,old,cmd))
 tool=Path(cases[0][4]['argv'][0]);run.command([str(tool),'--version'],'actual-cbmc-version',timeout=20,cwd=str(R))
 rows=[]
 for dim,c,sm,old,cmd in cases:
  for name,h in sm['cbmc_input_sha256'].items():assert sha(R/name)==h
  try:rec=run.command(cmd['argv'],'snapshot-replay-'+dim,timeout=120,cwd=cmd['cwd'])
  except RuntimeError:
   rec=run.read('commands.json')[-1]
   if rec.get('exit_code')!=10:raise
  assert rec['exit_code']==cmd['exit_code']==10
  original=read(old/cmd['stdout']);fresh=read(RUN/rec['stdout'])
  a=[p for b in original for p in b.get('result',[])];b=[p for block in fresh for p in block.get('result',[])]
  if a!=b:
   write(RUN/'evidence/nonidentical-replay.json',{'case':c.name,'original_properties':a,'fresh_properties':b})
   raise AssertionError('Original complete property/trace objects differ: '+c.name)
  count=190 if dim=='2d' else 208;assert len(a)==count
  rows.append({'case_id':c.name,'original_run':str(old.relative_to(R)),'original_command_id':cmd['id'],'original_stdout':rel(old/cmd['stdout']),'original_stdout_sha256':sha(old/cmd['stdout']),
   'fresh_run':rel(RUN),'fresh_command_id':rec['id'],'fresh_stdout':rel(RUN/rec['stdout']),'fresh_stdout_sha256':sha(RUN/rec['stdout']),
   'input_sha256':sm['cbmc_input_sha256'],'exact_argv_and_cwd_equal':rec['argv']==cmd['argv'] and rec['cwd']==cmd['cwd'],'complete_property_objects_equal':True,'properties':len(a),'proved':sum(p['status']=='SUCCESS' for p in a),'refuted':sum(p['status']=='FAILURE' for p in a),
   'failed_trace_sha256':{p['property']:trace_sha(p['trace']) for p in a if p['status']=='FAILURE'}})
  print('IDENTICAL',c.name,len(a),'full property/result/trace objects',flush=True)
 comparison=RUN/'evidence/original-replay-comparison.json';write(comparison,{'schema':'five-cbmc-source-snapshot-replay/1','status':'identical','tool_path':str(tool),'tool_sha256':sha(tool),'cases':rows,'boundary':'Original closed CBMC input index was empty; fresh input captures precede direct invocations. Original commands, results, stage handoffs, mappings, trace constants and formal source files remain unchanged.'})
 run.finish('passed','Original398 CBMC property/result/trace objects reproduced identically with before-command source/harness snapshots; numerical assertions remain394 proved and4 refuted.',{'comparison':comparison})
except Exception:
 if run.read('run.json')['status']=='running':run.finish('failed',traceback.format_exc(),{})
 raise
metrics=read(RUN/'metrics.json');t=metrics['tokens'];mem=metrics['memory'];tm=metrics['time']
p=subprocess.run([sys.executable,'scripts/audit-costs.py','--run',str(RUN)],capture_output=True,text=True);audit=json.loads(p.stdout)
for dim,c,sm,old,cmd in cases:
 ep=c/'cbmc/report/evidence/source-snapshot-replay.json';write(ep,{'schema':'five-cbmc-source-snapshot-replay-reference/1','run':rel(RUN),'comparison':rel(comparison),'comparison_sha256':sha(comparison),'case':next(x for x in rows if x['case_id']==c.name),'status':'identical'})
 cost=c/'cbmc/report/costs.json';x=read(cost)
 record={'stage':'five-cbmc','run':rel(RUN),'status':'recorded','scope':'Shared independent exact repeat for both matrix cases, with actual before-command input snapshots. Source/model/proof/historical mappings are unchanged. Count provider event IDs once.',
  'time':{'wall_seconds':tm['wall_seconds'],'tool_cpu_seconds':tm['cpu_tool_seconds']},'token':{'input':t['input_tokens'],'output':t['output_tokens'],'total':t['total_tokens'],'cached_input':t['cached_input_tokens'],'reasoning_output':t['reasoning_output_tokens']},'memory':{'tool_peak_rss_bytes':mem['peak_process_tree_rss_sampled_bytes']},
  'evidence':[os.path.relpath(RUN/'run.json',cost.parent),os.path.relpath(RUN/'metrics.json',cost.parent),os.path.relpath(comparison,cost.parent)],'cost_audit':audit}
 x['records']=[v for v in x['records'] if v.get('run')!=rel(RUN)]+[record];write(cost,x)
 report=c/'cbmc/report/report.md';text=report.read_text()
 if 'source-snapshot-replay.json' not in text:text+='\n## Input snapshot replay\n\nThe historical CBMC run retained its original direct invocation and raw results, but its input snapshot index was empty. A fresh direct invocation captured the canonical source, original harness, bindings and request before execution. The exact original argv/cwd, every property object and all complete counterexample traces were reproduced identically. No source, original result, frozen handoff, mapping or formal model was changed. Current Rocq acceptance binds this fresh raw run and retains the original evidence. See [comparison](evidence/source-snapshot-replay.json) and [costs](costs.json).\n'
 report.write_text(text)
print(json.dumps({'run':rel(RUN),'cases':rows,'cost_audit':audit['status']},ensure_ascii=False),flush=True)
