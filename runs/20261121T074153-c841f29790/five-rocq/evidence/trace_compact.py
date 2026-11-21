import json,sys,re,hashlib
from pathlib import Path
ROOT=Path('/home/yangfp/five');RUN=ROOT/'runs/20261121T074153-c841f29790/five-rocq'
sys.path.insert(0,str(ROOT/'scripts'));from five_telemetry import Run

def words(v):
 if 'binary'in v:return int(v['binary'],2)
 if 'elements'in v:return [words(e['value'])for e in v['elements']]
 if 'members'in v:return {e['name']:words(e['value'])for e in v['members']}
 return v.get('data')
def worker():
 out={}
 for name in ['float_mat_inv_2d','float_mat_inv_3d']:
  c=ROOT/'paparazzi/models'/name
  raw=json.loads((c/'cbmc/results.json').read_text()); props=next(x['result'] for x in raw if 'result'in x)
  mapping=json.loads((c/'align/spec-map.json').read_text())
  print(name,'mapping keys',mapping.keys());print('property count',len(props))
  print('map first',json.dumps(mapping.get('properties',[None])[0],indent=2)[:6000])
  fails=[]
  for p in props:
   if p['status']!='FAILURE':continue
   print('\nRAW TRACE',p['property'],'steps',len(p['trace']),'failure line',p['sourceLocation']['line'])
   selected=[]
   for i,t in enumerate(p['trace']):
    lhs=t.get('lhs','');loc=t.get('sourceLocation',{})
    if t.get('hidden')or t.get('stepType')!='assignment':continue
    if (lhs.startswith(('arbitrary[','base','small','large','guarded','residual')) or (loc.get('function')==name and (lhs.startswith(('inv_out','invA','det','o[')) or '['in lhs))):
     selected.append({'step':i,'lhs':lhs,'bits':words(t.get('value',{})),'file':loc.get('file'),'line':loc.get('line')})
   for s in selected: print(s)
   fails.append({'property':p['property'],'selected_original_steps':selected})
  out[name]=fails
 (RUN/'evidence/compact-original-traces.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':
 if len(sys.argv)>1:worker()
 else:
  r=Run(RUN);cmd=r.command(['python3',__file__,'worker'],'compact-traces-and-map',timeout=180,cwd=ROOT);print((RUN/cmd['stdout']).read_text())
