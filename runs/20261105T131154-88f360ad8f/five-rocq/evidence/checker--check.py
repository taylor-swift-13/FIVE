#!/usr/bin/env python3
from pathlib import Path
import shutil,subprocess,tempfile,os,sys
root=Path(__file__).resolve().parents[7]
case=root/'examples/models/sum2'
attempt=Path(__file__).resolve().parent
telemetry=None
if os.environ.get('FIVE_RECHECK_RUN'):
 sys.path.insert(0,str(root/'scripts'))
 from five_telemetry import Run
 telemetry=Run(os.environ['FIVE_RECHECK_RUN'])
def execute(args,label):
 if telemetry:
  result=telemetry.command(args,label,timeout=240,cwd=root)
  if result['status']!='passed': raise RuntimeError(result)
 else:subprocess.run(args,cwd=root,check=True)

with tempfile.TemporaryDirectory(prefix='five-sum2-attempt-') as tmp:
 b=Path(tmp); model=b/'model';proof=b/'proof';shared=b/'shared'
 model.mkdir();proof.mkdir()
 for f in ['Source.v','Execution.v','proof/Precondition.v','proof/Obligations.v']:
  p=model/f;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(case/'align/model'/f,p)
 for f in ['SourceInvariant','NormalCorrespondence','PureProgress','Invariant','Entry']:
  shutil.copyfile(case/'rocq/support'/f'{f}.v',proof/f'{f}.v')
 (proof/'support').mkdir();shutil.copyfile(case/'rocq/support/NormalCorrespondence.v',proof/'support/NormalCorrespondence.v')
 shutil.copyfile(case/'rocq/no_error/problem/Spec.v',proof/'NoErrorSpec.v')
 shutil.copyfile(case/'rocq/termination/problem/Spec.v',proof/'TerminationSpec.v')
 shutil.copyfile(case/'rocq/termination/attempts/001/Proof.v',proof/'Termination.v')
 shutil.copyfile(case/'rocq/cbmc_recheck/problem/Spec.v',proof/'RecheckSpec.v')
 shutil.copyfile(attempt/'Proof.v',proof/'Attempt.v')
 shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vos','*.vok','__pycache__'))
 flags=['-Q',str(model),'FiveSum2','-Q',str(proof),'FiveSum2Proof','-Q',str(shared),'FiveShared']
 order=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',model/'Source.v',model/'Execution.v',model/'proof/Precondition.v',model/'proof/Obligations.v']+[proof/f'{f}.v' for f in ['SourceInvariant','support/NormalCorrespondence','PureProgress','Invariant','Entry','NoErrorSpec','TerminationSpec','Termination','RecheckSpec','Attempt']]
 for p in order:
  if telemetry:telemetry.capture(p,'compile-'+str(p.relative_to(b)).replace('/','-'),area='inputs')
  execute(['rocq','compile',*flags,str(p)],'compile-'+p.stem)
 if os.environ.get('FIVE_RECHECK_KEEP'):
  kept=Path(os.environ['FIVE_RECHECK_KEEP']).resolve()
  shutil.copytree(b,kept)
  flags=['-Q',str(kept/'model'),'FiveSum2','-Q',str(kept/'proof'),'FiveSum2Proof','-Q',str(kept/'shared'),'FiveShared']
  if telemetry:
   for source in [case/'align/model/Source.v',case/'align/model/Execution.v',kept/'proof/RecheckSpec.v',kept/'proof/Attempt.v']:
    telemetry.capture(source,'permanent-'+source.stem,area='inputs')
  for source in [kept/'proof/RecheckSpec.v',kept/'proof/Attempt.v']:
   execute(['rocq','compile',*flags,str(source)],'compile-permanent-'+source.stem)
 execute(['rocq','check','-silent',*flags,'FiveSum2Proof.Attempt'],'independent-kernel-check')
 print('Rebuilt input model and dependencies; independently kernel-checked Attempt.')
