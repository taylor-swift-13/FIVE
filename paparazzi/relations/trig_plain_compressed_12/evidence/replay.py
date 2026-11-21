#!/usr/bin/env python3
"""Rebuild the requested checked source dependency closure in a fresh directory."""
from pathlib import Path
import hashlib,json,shutil,subprocess,tempfile

def run(target):
 root=next(p for p in Path(__file__).resolve().parents if(p/'scripts/env.sh').is_file())
 plan=json.loads((root/'paparazzi/relations/trig_plain_compressed_12/evidence/proof-build-plan.json').read_text())
 rows={x['module']:x for x in plan['order']};needed=set()
 def visit(n):
  if n in needed:return
  needed.add(n)
  for d in rows[n]['imports']:visit(d)
 visit(target)
 with tempfile.TemporaryDirectory(prefix='five-pprz-replay-')as tmp:
  temp=Path(tmp);flags=[]
  for i in range(0,len(plan['flags']),3):flags+=['-Q',str(temp/plan['flags'][i+1]),plan['flags'][i+2]]
  for row in plan['order']:
   if row['module']not in needed:continue
   src=root/row['source'];assert hashlib.sha256(src.read_bytes()).hexdigest()==row['sha256'],str(src)
   dst=temp/row['source'];dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst)
  for row in plan['order']:
   if row['module']in needed:subprocess.run(['rocq','compile',*flags,str(temp/row['source'])],cwd=root,check=True)
  subprocess.run(['rocq','check','-silent',*flags,target],cwd=root,check=True)
 print(target+': fresh compilation and independent kernel check passed.')
