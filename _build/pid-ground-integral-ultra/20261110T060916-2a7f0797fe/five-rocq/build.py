from pathlib import Path
import os,sys,importlib.util,re,shlex,json
ROOT=Path('/home/yangfp/five');os.chdir(ROOT);sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
run=Run(Path(__file__).parent)
p=ROOT/'paparazzi/relations/pid_position_translation/attempts/002/core/BuildConfiguration.py'
s=importlib.util.spec_from_file_location('config',p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
pairs=m.LOADPATHS+[
 ('paparazzi/relations/pid_ground_integral_independence/problem','PidGroundIntegralProblem'),
 ('paparazzi/relations/pid_ground_integral_independence/attempts/001','PidGroundIntegralAttempt001')]
flags=[x for d,n in pairs for x in ['-Q',d,n]]
files=[]
for d,_ in pairs:
 for p in (ROOT/d).rglob('*.v'):
  if not set(p.relative_to(ROOT/d).parts)&{'runs','inputs','checked','exploratory','__pycache__','cold-checks'} and re.fullmatch('[A-Za-z_][A-Za-z_0-9]*',p.stem):files.append(str(p.relative_to(ROOT)))
c=run.command(['rocq','dep',*flags,*sorted(files)],'ground-dependency-graph',timeout=120,cwd=ROOT)
graph={}
for line in (run.folder/c['stdout']).read_text().replace('\\\n','').splitlines():
 if ':' not in line:continue
 lhs,rhs=line.split(':',1);ts=shlex.split(lhs)
 if ts and ts[0].endswith('.vo'):
  graph[ts[0][:-3]+'.v']=[i[:-3]+'.v' for i in shlex.split(rhs) if i.endswith('.vo') and (ROOT/(i[:-3]+'.v')).is_file()]
order=[];seen=set()
def visit(p):
 if p in seen:return
 seen.add(p)
 for d in graph[p]:visit(d)
 order.append(p)
visit('paparazzi/relations/pid_ground_integral_independence/attempts/001/Proof.v')
(run.folder/'evidence/build-plan.json').write_text(json.dumps({'pairs':pairs,'order':order},indent=2))
print('DEPENDENCIES',len(order),flush=True)
for i,p in enumerate(order):
 if len(sys.argv)>1 and sys.argv[1]=='resume' and (ROOT/p).with_suffix('.vo').exists():continue
 print('Compile',i+1,len(order),p,flush=True)
 run.command(['rocq','compile','-q',*flags,p],'ground-compile-'+Path(p).stem,timeout=900,cwd=ROOT)
print('BUILD PASS',flush=True)
