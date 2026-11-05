#!/usr/bin/env python3
from pathlib import Path
import shutil,subprocess,tempfile
root=Path(__file__).resolve().parents[7]
case=root/'examples/models/sum3'
attempt=Path(__file__).resolve().parent
from contextlib import nullcontext
import os
with (nullcontext(os.environ['FIVE_KEEP_BUILD']) if 'FIVE_KEEP_BUILD' in os.environ else tempfile.TemporaryDirectory(prefix='five-sum3-attempt-')) as tmp:
 b=Path(tmp); model=b/'model';proof=b/'proof';shared=b/'shared'
 model.mkdir();proof.mkdir()
 for f in ['Source.v','Execution.v','proof/Precondition.v','proof/Obligations.v']:
  p=model/f;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(case/'align/model'/f,p)
 for f in ['SourceInvariant','NormalCorrespondence','PureProgress','Invariant','Entry','Core']:
  shutil.copyfile(case/'rocq/support'/f'{f}.v',proof/f'{f}.v')
 (proof/'support').mkdir();shutil.copyfile(case/'rocq/support/NormalCorrespondence.v',proof/'support/NormalCorrespondence.v')
 shutil.copyfile(case/'rocq/no_error/problem/Spec.v',proof/'NoErrorSpec.v')
 shutil.copyfile(case/'rocq/termination/problem/Spec.v',proof/'TerminationSpec.v')
 shutil.copyfile(attempt/'Proof.v',proof/'Attempt.v')
 shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vos','*.vok','__pycache__'))
 flags=['-Q',str(model),'FiveSum3','-Q',str(proof),'FiveSum3Proof','-Q',str(shared),'FiveShared']
 order=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',model/'Source.v',model/'Execution.v',model/'proof/Precondition.v',model/'proof/Obligations.v']+[proof/f'{f}.v' for f in ['SourceInvariant','NoErrorSpec','TerminationSpec','Attempt']]
 for p in order:subprocess.run(['rocq','compile',*flags,str(p)],cwd=root,check=True)
 subprocess.run(['rocq','check','-silent',*flags,'FiveSum3Proof.Attempt'],cwd=root,check=True)
 print('Rebuilt input model and dependencies; independently kernel-checked Attempt.')
