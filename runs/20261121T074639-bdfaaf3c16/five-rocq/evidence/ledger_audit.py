from pathlib import Path
import json,re,hashlib,sys
ROOT=Path('/home/yangfp/five');RUN=ROOT/'runs/20261121T074639-bdfaaf3c16/five-rocq';sys.path.insert(0,str(ROOT/'scripts'));from five_telemetry import Run

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def worker():
 out={}
 prior=json.loads((ROOT/'runs/20261121T074153-c841f29790/five-rocq/evidence/source-trace-audit.json').read_text())
 for case,dim in [('float_mat_inv_2d',2),('float_mat_inv_3d',3)]:
  c=ROOT/'paparazzi/models'/case
  props=next(x['result']for x in json.loads((c/'cbmc/results.json').read_text())if'result'in x)
  maps=json.loads((c/'align/spec-map.json').read_text())['properties']
  text=(c/'rocq/cbmc_recheck/problem/Spec.v').read_text()
  specids=re.findall(r'Actual property: ([^;]+);',text)if dim==2 else re.findall(r'\("([^"]+)",K',text)
  cfg=json.loads((c/'rocq/cbmc_recheck/attempts/001/checker-config.json').read_text())
  bindings=cfg['goal_bindings'];rawids=[p['property']for p in props]
  e={'raw_count':len(props),'raw_ids':rawids,'raw_success':sum(p['status']=='SUCCESS'for p in props),'raw_failure':sum(p['status']=='FAILURE'for p in props),'mapping_ids_equal':rawids==[p['property_id']for p in maps],'spec_ids_equal':rawids==specids,'goal_ids_equal':rawids==[p['requested_goal']for p in bindings],'scope_locations_equal':all(p['sourceLocation']==q['scope']['location']for p,q in zip(props,maps)),'frozen_proof_changes':[],'inputs':{},'failures':[]}
  for name in ['prepare/source/'+case+'.c','align/model/Source.v','align/model/Execution.v','cbmc/harness.c','cbmc/results.json','cbmc/counterexamples.json','cbmc/properties.json','align/spec-map.json']:
   e['inputs'][name]=sha(c/name)
  for file,h in prior[case]['frozen_files'].items():
   actual=sha(c/file)
   if actual!=h:e['frozen_proof_changes'].append({'path':file,'old':h,'new':actual})
  modelwords=re.findall(r'(?:trace_input_words|arbitrary_words_[01]):list Z\s*:?=\s*\[([^]]+)\]',(c/'rocq/support/TraceInputs.v').read_text())
  vectors=[[int(w.strip())for w in s.split(';')]for s in modelwords]
  for p in props:
   if p['status']!='FAILURE':continue
   tr=p['trace'];inputs=[];sourcewrites=[];states={};residual=[]
   for i,t in enumerate(tr):
    if t.get('stepType')!='assignment' or t.get('hidden'):continue
    lhs=t.get('lhs','');v=t.get('value',{});loc=t.get('sourceLocation',{});binary=v.get('binary')
    if binary is not None:
     bits=int(binary,2)
     if re.fullmatch(r'arbitrary\[\d+l\]'if dim==2 else r'arbitrary\[\d+l\]\[\d+l\]',lhs):inputs.append(bits)
     if lhs in ['arbitrary_status','base_status','small_status','large_status']:states[lhs]=bits
     if lhs=='residual':residual.append({'step':i,'bits':bits,'line':loc.get('line')})
     if loc.get('function')==case and re.match(r'(guarded.value|base_out|small_out|large_out)\[',lhs):
      idxs=[int(x)for x in re.findall(r'\[(\d+)l\]',lhs)];index=idxs[0]if dim==2 else 3*idxs[0]+idxs[1]
      sourcewrites.append({'step':i,'lhs':lhs,'index':index,'bits':bits,'line':loc.get('line')})
   match=all(inputs==v for v in vectors)
   order=[0,1,2,3]if dim==2 else[0,3,6,1,4,7,2,5,8]
   expectedbase=[1065353216,2147483648,2147483648,1065353216]if dim==2 else[1065353216,2147483648,0,2147483648,1065353216,2147483648,0,2147483648,1065353216]
   expectedlarge=[0,2147483648,2147483648,0]if dim==2 else[0,2147483648,0,2147483648,0,2147483648,0,2147483648,0]
   checks={}
   for name,words in [('base_out',expectedbase),('large_out',expectedlarge)]:
    wr=[w for w in sourcewrites if w['lhs'].startswith(name+'[')]
    checks[name]={'indices_match_source_order':[w['index']for w in wr]==order,'bits_match_exact':[w['bits']for w in wr]==[words[j]for j in order]}
   checks['small_out_no_writes']=not any(w['lhs'].startswith('small_out[')for w in sourcewrites)
   e['failures'].append({'property':p['property'],'assertion_location':p['sourceLocation'],'trace_sha256_canonical':hashlib.sha256(json.dumps(tr,sort_keys=True,separators=(',',':')).encode()).hexdigest(),'trace_steps':len(tr),'arbitrary_input_bits':inputs,'raw_bits_match_all_model_vectors':match,'actual_statuses':states,'source_write_prefix':sourcewrites,'prefix_checks':checks,'residual_assignments':residual,'failures_in_trace':[{'step':i,'property':t['property'],'line':t.get('sourceLocation',{}).get('line')}for i,t in enumerate(tr)if t.get('stepType')=='failure']})
  out[case]=e
 (RUN/'evidence/original-ledger-verification.json').write_text(json.dumps(out,indent=2)+'\n')
 session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/21/rollout-2026-11-21T15-40-43-01a1fd0c-e57a-7223-b63c-4ac8b75a64a9.jsonl')
 receipt={'session_file':str(session),'session_thread':'01a1fd0c-e57a-7223-b63c-4ac8b75a64a9','observed_configuration':[]}
 for ln,line in enumerate(session.read_text().splitlines(),1):
  try:ev=json.loads(line)
  except:continue
  if ev.get('type')not in ['session_meta','turn_context']:continue
  p=ev.get('payload',{});safe={k:p[k]for k in ['id','parent_thread_id','model','model_provider','reasoning_effort','effort','source','originator','cli_version','cwd']if k in p}
  if safe:receipt['observed_configuration'].append({'line':ln,'event_type':ev['type'],'fields':safe})
 (RUN/'evidence/runtime-configuration.json').write_text(json.dumps(receipt,indent=2)+'\n')
 for case,e in out.items():
  print(case,{k:e[k]for k in ['raw_count','raw_success','raw_failure','mapping_ids_equal','spec_ids_equal','goal_ids_equal','scope_locations_equal','frozen_proof_changes']})
  for f in e['failures']:print(f['property'],'input_match',f['raw_bits_match_all_model_vectors'],'status',f['actual_statuses'],'prefix',f['prefix_checks'],'residual',f['residual_assignments'])
 print('runtime fields',receipt['observed_configuration'][:2])
if __name__=='__main__':
 if len(sys.argv)>1:worker()
 else:
  r=Run(RUN);cmd=r.command(['python3',__file__,'worker'],'original-ledger-and-trace-exactness',timeout=180,cwd=ROOT);print((RUN/cmd['stdout']).read_text())
