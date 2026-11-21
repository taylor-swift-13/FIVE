import json,hashlib,re,sys
from pathlib import Path
ROOT=Path('/home/yangfp/five'); RUN=ROOT/'runs/20261121T074153-c841f29790/five-rocq'
sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def worker():
  data={}
  for case in ('float_mat_inv_2d','float_mat_inv_3d'):
    c=ROOT/'paparazzi/models'/case
    entry={'handoff_bindings':[],'frozen_files':{}}
    for stage in ('prepare','cbmc','align'):
      h=json.loads((c/stage/'handoff.json').read_text())
      for o in h['outputs']:
        p=c/o['path']; actual=sha(p)
        entry['handoff_bindings'].append({'stage':stage,'role':o['role'],'path':o['path'],'expected':o['sha256'],'actual':actual,'matches':actual==o['sha256']})
    for p in sorted((c/'rocq').rglob('*.v')):
      entry['frozen_files'][str(p.relative_to(c))]=sha(p)
    raw=json.loads((c/'cbmc/results.json').read_text())
    print(case,'raw root',type(raw),len(raw))
    for item in raw:
      if 'result' not in item: continue
      props=item['result']; entry['actual_property_ids']=[p['property'] for p in props]
      entry['counts']={s:sum(p['status']==s for p in props) for s in set(p['status'] for p in props)}
      print('property example',json.dumps(props[0],indent=2))
      entry['failed_raw_traces']=[]
      for prop in props:
        if prop['status']!='FAILURE':continue
        print('FAILURE',prop['property'],prop.keys())
        trace=prop.get('trace',[])
        summary={'property':prop['property'],'description':prop.get('description'),'sourceLocation':prop.get('sourceLocation'),'trace_steps':len(trace),'trace_sha256':hashlib.sha256(json.dumps(trace,sort_keys=True,separators=(',',':')).encode()).hexdigest(),'steps':[]}
        for i,t in enumerate(trace):
          if t.get('stepType') in ['assignment','failure']:
            summary['steps'].append({'index':i,**t})
        entry['failed_raw_traces'].append(summary)
        print('first assignments',json.dumps(summary['steps'][:16],indent=2))
        print('last assignments',json.dumps(summary['steps'][-8:],indent=2))
    data[case]=entry
  (RUN/'evidence/source-trace-audit.json').write_text(json.dumps(data,indent=2)+'\n')
  print('ALL HANDOFF HASHES MATCH:',all(h['matches'] for x in data.values() for h in x['handoff_bindings']))
if __name__=='__main__':
  if len(sys.argv)>1:worker()
  else:
    r=Run(RUN);cmd=r.command(['python3',__file__,'worker'],'source-and-trace-audit',timeout=180,cwd=ROOT);print((RUN/cmd['stdout']).read_text())
