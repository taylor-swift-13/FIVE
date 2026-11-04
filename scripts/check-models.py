"""Rebuild retained formal artifacts in a temporary directory, leaving no caches."""
from pathlib import Path
import tempfile,shutil,re,subprocess,json,hashlib
R=Path(__file__).resolve().parents[1]
def logical(p):
 a=p.with_suffix('').parts
 return ('FiveCases' if a[0]=='cases' else 'FiveShared')+'.'+'.'.join(a[1:])
with tempfile.TemporaryDirectory(prefix='five-check-') as tmp:
 B=Path(tmp)
 shutil.copytree(R/'examples',B/'cases')
 shutil.copytree(R/'shared',B/'shared')
 mods={logical(p.relative_to(B)):p for d in ['cases','shared'] for p in (B/d).rglob('*.v') if 'rerun' not in p.parts}
 deps={k:set() for k in mods}
 for k,p in mods.items():
  for pre,names in re.findall(r'From (FiveCases[\w.]*|FiveShared[\w.]*) Require (?:Import|Export)\s+([\w\s]+)\.',p.read_text()):
   deps[k].update(pre+'.'+n for n in names.split())
 order=[]
 while len(order)<len(mods):
  ready=[k for k in mods if k not in order and deps[k]<=set(order)]
  if not ready:raise RuntimeError('Missing dependency or import cycle')
  order+=ready
 flags=['-Q',str(B/'cases'),'FiveCases','-Q',str(B/'shared'),'FiveShared']
 for k in order:
  print('Compile',k,flush=True)
  subprocess.run(['rocq','c',*flags,str(mods[k])],check=True)
 subprocess.run(['rocq','check',*flags,*order],check=True)
 result={'compiled':True,'independent_kernel_check':True,'modules':order,'source_sha256':{str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for d in ['examples','shared'] for p in (R/d).rglob('*.v') if 'rerun' not in p.parts}}
 (R/'reports/validation.json').write_text(json.dumps(result,indent=2))
 print('PASS: temporary compiled objects removed on exit.')
