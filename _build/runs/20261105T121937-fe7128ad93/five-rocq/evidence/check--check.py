#!/usr/bin/env python3
"""Isolated compilation, Print Assumptions and independent kernel checking."""
from pathlib import Path
import shutil,subprocess,tempfile
attempt=Path(__file__).resolve().parent
root=attempt.parents[4]
with tempfile.TemporaryDirectory(prefix='five-relation-001-') as tmp:
 b=Path(tmp);flags=[];order=[]
 shared=b/'shared';shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vos','*.vok','__pycache__'))
 flags+=['-Q',str(shared),'FiveShared']
 order += [shared/'pure_semantics/SemanticsSupport.v']
 for name,ns in [('sum2','FiveSum2'),('sum3','FiveSum3')]:
  d=b/name;d.mkdir();flags+=['-Q',str(d),ns]
  for f in ['Source.v','Execution.v']:
   shutil.copyfile(root/'examples/models'/name/'align/model'/f,d/f);order.append(d/f)
  d=b/(name+'proof');d.mkdir();(d/'support').mkdir();flags+=['-Q',str(d),ns+'Proof']
  names=['SourceInvariant.v','NormalCorrespondence.v','PureProgress.v','Invariant.v']
  if name=='sum3':names+=['Entry.v','Core.v']
  for f in names:
   target=d/'support'/f if f=='NormalCorrespondence.v' else d/f
   shutil.copyfile(attempt/'support'/name/f,target);order.append(target)
  f='Sum2Return.v' if name=='sum2' else 'ReturnValue.v'
  shutil.copyfile(attempt/('Sum2Return.v' if name=='sum2' else 'Sum3Return.v'),d/f);order.append(d/f)
 d=b/'relation';d.mkdir();flags+=['-Q',str(d),'FiveExampleRelation']
 for f,source in [('Spec.v',attempt.parent.parent/'problem/Spec.v'),('Proof.v',attempt/'Proof.v')]:
  shutil.copyfile(source,d/f);order.append(d/f)
 for f in order:
  print('Compile',f,flush=True)
  subprocess.run(['rocq','compile',*flags,str(f)],cwd=root,check=True)
 subprocess.run(['rocq','check','-silent',*flags,'FiveExampleRelation.Proof'],cwd=root,check=True)
 print('composition_bits compiled; Print Assumptions emitted; independent rocq check passed.',flush=True)
