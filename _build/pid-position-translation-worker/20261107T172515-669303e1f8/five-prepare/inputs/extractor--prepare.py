from pathlib import Path
import re,json,hashlib,shutil,sys
root=Path.cwd();up=root/'_build/paparazzi/upstream';case=root/'paparazzi/models/guidance_pid_h_run_pos';out=case/'prepare'
for p in ('source','report','original'): (out/p).mkdir(parents=True,exist_ok=True)
files=list((up/'sw/airborne/math').glob('*.h'))+[up/'sw/include/std.h',up/'sw/airborne/state.h']+list((up/'sw/airborne/firmwares/rotorcraft').glob('*.h'))+list((up/'sw/airborne/firmwares/rotorcraft/guidance').glob('*.h'))+list((up/'sw/airborne/firmwares/rotorcraft/stabilization').glob('*.h'))
files+=list((up/'sw/include').glob('*.h'));files+=[up/'sw/airborne/paparazzi.h'];texts={p:p.read_text() for p in files}; slices=[]
def grab(p,pattern):
 s=p.read_text();m=re.search(pattern,s,re.M|re.S);assert m,(p,pattern)
 z=m.group();slices.append((p,z));return z
structs={}
for p,s in texts.items():
 for m in re.finditer(r'^struct (\w+)\s*\{.*?^};',s,re.M|re.S):structs.setdefault(m[1],(p,m.group()))
done=set();parts=[]
def typ(n):
 if n in done:return
 done.add(n);p,z=structs[n]
 for d in re.findall(r'\bstruct (\w+)\b',re.sub(r'/\*.*?\*/|//[^\n]*','',z,flags=re.S))[1:]:
  if d!=n:typ(d)
 parts.append(z);slices.append((p,z))
for n in ('GuidancePID','HorizontalGuidance','State','Stabilization','VerticalGuidance'):typ(n)
# Original helper and selected entry bodies, unchanged.
pid=up/'sw/airborne/firmwares/rotorcraft/guidance/guidance_pid.c';state=up/'sw/airborne/state.h';stab=up/'sw/airborne/firmwares/rotorcraft/stabilization.c'
funcs=[grab(state,r'^static inline struct NedCoor_i \*stateGetPositionNed_i\(void\)\n\{.*?^}'),grab(state,r'^static inline struct NedCoor_i \*stateGetSpeedNed_i\(void\)\n\{.*?^}'),grab(stab,r'^struct StabilizationSetpoint stab_sp_from_ltp_i\(.*?^}'),grab(pid,r'^static struct StabilizationSetpoint guidance_pid_h_run\(.*?^}'),grab(pid,r'^struct StabilizationSetpoint guidance_pid_h_run_pos\(.*?^}')]
# Only actual macro definitions referenced by the retained type/body closure.
macros={}
for p,s in list(texts.items())+[(pid,pid.read_text())]:
 lines=s.splitlines(keepends=True);i=0
 while i<len(lines):
  z=lines[i];i+=1
  if not re.match(r'^\s*#\s*define\s+',z):continue
  while z.rstrip().endswith(chr(92)) and i<len(lines):z+=lines[i];i+=1
  m=re.match(r'^\s*#\s*define\s+(\w+)',z)
  if m:macros.setdefault(m[1],(p,z.rstrip()))

profile={'COMMANDS_NB':'4','COMMAND_THRUST':'3'}
macro_done=set();mp=[]
def macro(n):
 if n in macro_done or n not in macros or n in profile:return
 macro_done.add(n);p,z=macros[n]
 for dep in sorted(set(re.findall(r'\b[A-Za-z_]\w*\b',z))-{n,'define'}):macro(dep)
 mp.append(z);slices.append((p,z))
for n in sorted(set(re.findall(r'\b[A-Za-z_]\w*\b','\n'.join(parts+funcs)))):macro(n)
text='/* Exact pinned original slices; open external bindings are explicit. */\n#include <stdint.h>\n#include <stdbool.h>\n#include <math.h>\n'+''.join('#define '+k+' '+v+'\n' for k,v in profile.items())+'\n\n'.join(mp+parts)+'\n\n'
text+='struct GuidancePID guidance_pid;\nstruct Int32Vect2 guidance_pid_pos_err, guidance_pid_speed_err, guidance_pid_trim_att_integrator;\nstruct HorizontalGuidance guidance_h;\nstruct VerticalGuidance guidance_v;\nstruct Stabilization stabilization;\nstruct State state;\nextern void stateCalcPositionNed_i(void);\nextern void stateCalcSpeedNed_i(void);\n\n'+'\n\n'.join(funcs)+'\n'
source=out/'source/guidance_pid_h_run_pos.c';source.write_text(text)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
index=[]
for p,z in slices:
 dest=out/'original'/p.relative_to(up);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
 index.append({'path':str(p.relative_to(up)),'source_sha256':sha(p),'slice_sha256':hashlib.sha256(z.encode()).hexdigest(),'start_line':p.read_text()[:p.read_text().index(z)].count('\n')+1})
json.dump({'method':'mechanically unchanged dependency/type/macro/function slices','slices':index,'profile':profile,'profile_scope':'selected exact dependencies; no complete aircraft configuration claimed','open_calls':['stateCalcPositionNed_i','stateCalcSpeedNed_i','atan2f']},open(out/'extraction.json','w'),indent=2)
shutil.copyfile(up/'COPYING',out/'COPYING')
print('types',len(done),'macros',len(mp),'source_bytes',len(text))
