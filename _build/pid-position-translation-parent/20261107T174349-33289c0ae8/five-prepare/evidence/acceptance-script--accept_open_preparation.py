
from pathlib import Path
import json,hashlib,re,shutil
root=Path('/home/yangfp/five');c=root/'paparazzi/models/guidance_pid_h_run_pos';u=root/'_build/paparazzi/upstream'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
hp=c/'prepare/handoff.json';h=json.loads(hp.read_text());assert h['stage']=='prepare' and h['status']=='pending'
for row in h['outputs']:
 p=(c/row['path']).resolve();assert p.is_relative_to(c) and sha(p)==row['sha256'],row
s=(c/'prepare/source/guidance_pid_h_run_pos.c').read_text()
def body(text,name):
 m=re.search(r'\b'+re.escape(name)+r'\s*\([^;{}]*\)\s*\{',text);assert m,name
 i=text.index('{',m.start());depth=0
 for j in range(i,len(text)):
  depth+=(text[j]=='{')-(text[j]=='}')
  if depth==0:return text[i:j+1]
 raise ValueError(name)
rows=[]
for name,path in [('guidance_pid_h_run_pos','sw/airborne/firmwares/rotorcraft/guidance/guidance_pid.c'),('guidance_pid_h_run','sw/airborne/firmwares/rotorcraft/guidance/guidance_pid.c'),('stateGetPositionNed_i','sw/airborne/state.h'),('stateGetSpeedNed_i','sw/airborne/state.h'),('stab_sp_from_ltp_i','sw/airborne/firmwares/rotorcraft/stabilization.c')]:
 orig=body((u/path).read_text(),name);actual=body(s,name);assert orig==actual,name;rows.append({'function':name,'source':path,'body_sha256':hashlib.sha256(actual.encode()).hexdigest(),'identical':True})
e=c/'prepare/report/evidence';e.mkdir(parents=True,exist_ok=True)
pending=e/'handoff-before-open-module-acceptance.json';assert not pending.exists();shutil.copyfile(hp,pending)
a=e/'open-module-acceptance.json';a.write_text(json.dumps({'status':'frozen-open-module','prepared_c_sha256':sha(c/'prepare/source/guidance_pid_h_run_pos.c'),'exact_function_bodies':rows,'configuration_scope':'Explicit controller configuration COMMANDS_NB4 COMMAND_THRUST3 and recorded original controller constants, not a production-airframe whole-build equivalence claim.','external_interfaces':'Original stateCalcPositionNed_i/stateCalcSpeedNed_i/atan2f names and declarations retained, no synthetic implementations.','external_implementation_and_environment_coverage':'pending','prior_pending_handoff_sha256':sha(pending)},indent=2)+chr(10))
h['status']='passed';h['preparation_scope']='Frozen OPEN C module only; source, configuration and original interface bindings recorded. Full external implementation/environment coverage pending.';h['external_implementation_coverage']='pending';h['outputs'].append({'role':'open-module-preparation-acceptance','path':str(a.relative_to(c)),'sha256':sha(a)});hp.write_text(json.dumps(h,indent=2)+chr(10))
print(json.dumps({'stage':'prepare','status':'passed','scope':'open-module-freeze','full_environment_coverage':'pending','exact_bodies':len(rows)}))
