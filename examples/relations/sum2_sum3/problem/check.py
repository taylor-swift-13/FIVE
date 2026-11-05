from pathlib import Path
import shutil,subprocess,tempfile
e=Path(__file__).resolve().parents[3]; r=e.parent
with tempfile.TemporaryDirectory(prefix='five-example-relation-') as tmp:
 b=Path(tmp); flags=[]; files=[]
 for name,ns in [('sum2','FiveSum2'),('sum3','FiveSum3')]:
  d=b/name;d.mkdir();flags+=['-Q',str(d),ns]
  for f in ('Source.v','Execution.v'):
   p=d/f;shutil.copyfile(e/'models'/name/'align/model'/f,p);files.append(p)
 d=b/'relation';d.mkdir();flags+=['-Q',str(d),'FiveExampleRelation'];spec=e/'relations/sum2_sum3/problem/Spec.v';shutil.copyfile(spec,d/'Spec.v');files.append(d/'Spec.v')
 for p in files:subprocess.run(['rocq','compile',*flags,str(p)],cwd=r,check=True)
 subprocess.run(['rocq','check','-silent',*flags,'FiveExampleRelation.Spec'],cwd=r,check=True)
print('Cross-model specification compiled and kernel checked.')
