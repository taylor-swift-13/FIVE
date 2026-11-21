#!/usr/bin/env python3
import argparse,datetime,hashlib,json,sys,os,copy
from pathlib import Path
ROOT=Path('/home/yangfp/five')
sys.path.insert(0,str(ROOT/'scripts'))
from codex_usage import load,KEYS
def stamp(s):
 return datetime.datetime.fromisoformat(s.replace('Z','+00:00'))
def read(p): return json.loads(Path(p).read_text())
def relative(p):
 try:return str(Path(p).resolve().relative_to(ROOT))
 except ValueError:return str(p)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def sums(events):
 result={k:sum(e[k]for e in events)for k in KEYS}
 result['total_tokens']=result['input_tokens']+result['output_tokens']
 return result
def norm_tokens(t):
 return dict(input=t['input_tokens'],output=t['output_tokens'],total=t['input_tokens']+t['output_tokens'],cached_input=t['cached_input_tokens'],reasoning_output=t['reasoning_output_tokens'])
def session_for(run):
 d=read(run/'run.json')
 refs=[x.get('reference')for x in d.get('tokens',{}).get('sources',[])if x.get('kind')=='codex-session-event']
 if not refs:
  m=read(run/'metrics.json')
  refs=[x.get('reference')for x in m.get('tokens',{}).get('sources',[])if x.get('kind')=='codex-session-event']
 if refs:return Path(refs[0])
 boundary=d.get('codex_usage_boundary',{})
 for k in ['session','session_path','path','source_session']:
  if boundary.get(k):return Path(boundary[k])
 raise ValueError('No own session reference for '+str(run))
def runtime_observations(path,end):
 vals=[]
 for line in path.read_text().splitlines():
  try:r=json.loads(line)
  except json.JSONDecodeError:continue
  if r.get('type')!='turn_context':continue
  ts=r.get('timestamp')
  if ts and stamp(ts)>end:continue
  p=r.get('payload',{})
  vals.append({'timestamp':ts,'model':p.get('model'),'reasoning_effort':p.get('effort')or p.get('reasoning_effort')})
 return vals
def main():
 ap=argparse.ArgumentParser()
 ap.add_argument('--include-final-cold',action='store_true')
 ap.add_argument('--cutoff')
 ap.add_argument('--output',default='paparazzi/report/pid_position_translation/ultra-retry')
 a=ap.parse_args()
 cutoff=stamp(a.cutoff)if a.cutoff else datetime.datetime.now(datetime.timezone.utc)
 cutoff_s=cutoff.isoformat().replace('+00:00','Z')
 boundary=read(ROOT/'_build/pid-position-translation-ultra-parent/task-boundary.json')
 start=stamp(boundary['request_timestamp'])
 case=ROOT/'paparazzi/relations/pid_position_translation/attempts/002'
 lead=ROOT/'_build/pid-position-translation-ultra-lead/20261108T041545-03e97f7214/five-rocq'
 core=case/'core/runs/20261108T041531-b910be4c42/five-rocq'
 candidates=list((case/'safety/runs').glob('*/five-rocq/run.json'))
 assert len(candidates)==1,[str(x)for x in candidates]
 safety=candidates[0].parent
 parent=ROOT/'_build/pid-position-translation-ultra-parent/20261108T041328-72f6bf20cf/five-verify'
 publication=Path(Path('/tmp/pid-publication-run').read_text())
 first_cold=ROOT/'_build/pid-ultra-cold-checks/20261108T073530-6b17da91a4/five-rocq'
 final_cold=ROOT/'_build/pid-ultra-cold-checks/20261108T085131-16087d4672/five-rocq'
 runs=[('lead-proof',lead),('core-proof',core),('safety-proof',safety),('root-orchestration',parent),('main-cold-check',first_cold),('publication',publication)]
 if a.include_final_cold:
  assert read(final_cold/'run.json').get('finished_at'),'Final cold check is not closed'
  runs.append(('final-cbmc-cold-check',final_cold))
 sources={'root':Path(boundary['root_session']),'lead':session_for(lead),'core':session_for(core),'safety':session_for(safety)}
 actors={};all_events={}
 for role,path in sources.items():
  identity,events,previous,notes=load(path)
  selected=[e for e in events if stamp(e['timestamp'])<=cutoff and(role!='root'or stamp(e['timestamp'])>=start)]
  if role!='root':assert stamp(identity['started_at'])>=start,(role,identity)
  for e in selected:
   if e['event_id']in all_events:assert all_events[e['event_id']]==e,'Conflicting event'
   all_events[e['event_id']]=e
  rt=runtime_observations(path,cutoff)
  if role!='root':
   assert rt and all(x['model']=='gpt-6.1-sol'and x['reasoning_effort']=='ultra'for x in rt),(role,rt)
  actors[role]={'session':str(path),'identity':identity,'events':selected,'totals':sums(selected),'parser_notes':notes,'runtime_observations':rt}
 output=ROOT/a.output;output.mkdir(parents=True,exist_ok=True)
 for actor,v in actors.items():
  if actor=='root':continue
  last=v['runtime_observations'][-1]
  write_runtime={'actual':{'model':last['model'],'effort':last['reasoning_effort'],'session_id':v['identity']['thread_id']},'source':v['session'],'runtime_observations':v['runtime_observations'],'scope':'Copied actual turn_context metadata; no conversation/reasoning content or relabeled historical config.'}
  (output/('runtime-'+actor+'.json')).write_text(json.dumps(write_runtime,indent=2)+'\n')
 records=[];tools=[];run_hashes=[]
 for role,folder in runs:
  d=read(folder/'run.json');m=read(folder/'metrics.json')
  closed=bool(d.get('finished_at'))
  commands=[c for c in d.get('commands',[])if stamp(c['finished_at'])<=cutoff]
  missing_gnu=[];missing_sampled=[];cpu=0.0;maxrss=0;maxtree=0
  for c in commands:
   g=c.get('gnu_time')or{}
   ok=all(isinstance(g.get(k),(int,float))for k in ['user_seconds','system_seconds','max_process_rss_kib'])
   if ok:
    cpu+=g['user_seconds']+g['system_seconds'];maxrss=max(maxrss,int(g['max_process_rss_kib']*1024))
   else:missing_gnu.append(c['id'])
   sample=c.get('peak_process_tree_rss_sampled_bytes')
   if isinstance(sample,(int,float))and sample>0:maxtree=max(maxtree,int(sample))
   else:missing_sampled.append(c['id'])
  actor='root'if role=='root-orchestration'else'lead'if role in ['lead-proof','publication']else'core'if role=='core-proof'else'safety'if role=='safety-proof'else None
  if actor:
   lo=stamp(d['started_at']);hi=min(cutoff,stamp(d['finished_at']))if closed else cutoff
   own=[e for e in actors[actor]['events']if lo<=stamp(e['timestamp'])<=hi]
   tok=norm_tokens(sums(own))
   contexts=actors[actor]['runtime_observations']
   last=contexts[-1]if contexts else{}
   agent={'session_id':actors[actor]['identity']['thread_id'],'model':last.get('model'),'actual_reasoning_effort':last.get('reasoning_effort'),'requested_reasoning_effort':'ultra'if actor!='root'else None,'source':'actual turn_context; metadata only, no conversation or reasoning content archived'}
  else:
   tok=dict(input=0,output=0,total=0,cached_input=0,reasoning_output=0)
   assert d.get('invocation_kind')!='skill-session'
   agent={'model':None,'actual_reasoning_effort':None,'role':'tool-only cold replay; mathematical authorship remains with three actual Ultra sessions'}
  wall=m['time']['wall_seconds']if closed else(cutoff-stamp(d['started_at'])).total_seconds()
  result=d.get('result',{})
  record={'stage':d['skill'],'run':relative(folder),'role':role,'status':'recorded','proof_or_tool_verdict':result.get('verdict')if isinstance(result,dict)else result,'closed':closed,'agent':agent,'evidence':[relative(folder/'run.json'),relative(folder/'metrics.json')],'measurement_scope':'Actual own command receipts and own actor events within this run boundary; shared proof work serves relation/model goals jointly. Records are references, not additive token totals.','time':{'wall_seconds':wall,'tool_cpu_seconds':cpu if closed and not missing_gnu else None,'recorded_tool_cpu_seconds':cpu},'token':tok,'memory':{'tool_peak_rss_bytes':maxtree if closed and not missing_sampled else None,'tool_max_individual_process_rss_bytes':maxrss if closed and not missing_gnu else None,'observed_max_command_tree_rss_bytes':maxtree or None,'observed_max_individual_process_rss_bytes':maxrss or None,'model_server_memory_bytes':None},'unobserved_reason':'Missing GNU receipts and zero/missing sampler observations stay unknown; observed lower bounds are separate. Concurrent joint peak and model-server memory are not measured. Publication is reported through the explicit cutoff.','command_count':len(commands),'failed_command_count':sum(c['status']=='failed'for c in commands),'timeout_command_count':sum(c['status']=='timeout'for c in commands),'missing_gnu_receipts':missing_gnu,'missing_sampled_memory':missing_sampled}
  record['evidence']=[os.path.relpath(folder/n,output)for n in ['run.json','metrics.json']]
  if actor and actor!='root':record['agent']['evidence']='runtime-'+actor+'.json'
  records.append(record);tools.append((folder,commands,cpu,maxrss,maxtree,missing_gnu,missing_sampled,closed))
  run_hashes.extend({'path':relative(folder/n),'sha256':sha(folder/n)}for n in ['run.json','metrics.json'])
 ordered=sorted(all_events.values(),key=lambda e:(e['timestamp'],e['event_id']))
 totals=sums(ordered)
 missing=[{'run':relative(t[0]),'gnu':t[5],'sampled':t[6]}for t in tools if t[5]or t[6]]
 output=ROOT/a.output;output.mkdir(parents=True,exist_ok=True)
 events_receipt={'schema':'five-usage-event-union/1','status':'recorded','request_timestamp':boundary['request_timestamp'],'observed_cutoff':cutoff_s,'rule':'Only root events at/after request; all three fresh actor events through cutoff. Union by event_id. No related_sessions tree and no historical medium events.','actors':{k:{kk:vv for kk,vv in v.items()if kk not in ['events']}for k,v in actors.items()},'events':ordered,'totals':totals}
 ep=output/'usage-events.json';ep.write_text(json.dumps(events_receipt,indent=2)+'\n')
 aggregate={'status':'recorded','request_timestamp':boundary['request_timestamp'],'observed_cutoff':cutoff_s,'time':{'wall_seconds':(cutoff-start).total_seconds(),'tool_cpu_seconds':None if missing or any(not t[7]for t in tools)else sum(t[2]for t in tools),'recorded_tool_cpu_seconds':sum(t[2]for t in tools)},'token':norm_tokens(totals),'memory':{'tool_peak_rss_bytes':None,'tool_max_individual_process_rss_bytes':None if any(t[5]for t in tools)else max(t[3]for t in tools),'observed_max_individual_process_rss_bytes':max(t[3]for t in tools),'observed_max_command_tree_rss_bytes':max(t[4]for t in tools),'model_server_memory_bytes':None},'usage_event_count':len(ordered),'usage_event_receipt':relative(ep),'usage_event_receipt_sha256':sha(ep),'tool_aggregation':'Each recorded run/command included once; no sum of stage walls. Per-command CPU only, not nested wrapper child summary. Missing receipts not estimated. No concurrent combined-memory measurement.','missing_receipts':missing,'pending_final_cold_check':not a.include_final_cold,'live_publication_cutoff':'Public-facing numbers are exact recorded events/finished commands through cutoff; later model outputs and publication command work are outside this snapshot.'}
 if a.include_final_cold:
  fdata=read(final_cold/'run.json')
  aggregate['final_cold_verdict']=fdata['result']['verdict']
  aggregate['final_cold_proof_kernel_status']=next(c['status']for c in fdata['commands']if c['id']=='224-cold-independent-proof-kernel')
  aggregate['extra_current_goalbinding_replay_status']=fdata['commands'][-1]['status']
 data={'schema':'five-stage-costs/1','scope':'Current Ultra retry only; historical medium attempt costs are referenced separately and never added.','records':records,'aggregate':aggregate,'raw_run_hashes_at_cutoff':run_hashes,'historical_reference':{'path':'paparazzi/report/pid_position_translation/costs.json','excluded_from_current_total':True},'counting_rule':'token total=input+output; cached input and reasoning output are subsets; event_id union is authoritative. Do not sum per-run token rows.'}
 (output/'costs.json').write_text(json.dumps(data,indent=2)+'\n')
 rocq=[]
 for x in records:
  if x['role']not in ['lead-proof','core-proof','safety-proof']:continue
  r=copy.deepcopy(x);r['evidence']=[os.path.relpath((output/ref).resolve(),case)for ref in r['evidence']]
  r['agent']['evidence']=os.path.relpath((output/r['agent']['evidence']).resolve(),case)
  rocq.append(r)
 (case/'costs.json').write_text(json.dumps({'schema':'five-stage-costs/1','scope':'Shared current PID relation and model proof work. Three genuine Ultra authors plus tool-only cold checks; all failures/timeouts included. Per-problem allocation is unobserved, so these records must not be added to copied per-model references. Root audit/publication lives in the separate aggregate.','records':rocq,'shared_aggregate':os.path.relpath(output/'costs.json',case),'shared_tool_costs':os.path.relpath(output/'costs.json',case)},indent=2)+'\n')
 print(json.dumps({'output':relative(output),'cutoff':cutoff_s,'aggregate':aggregate,'actor_tokens':{k:norm_tokens(v['totals'])for k,v in actors.items()},'runs':[{'run':x['run'],'token':x['token'],'closed':x['closed'],'commands':x['command_count']}for x in records]},indent=2))
if __name__=='__main__':main()
