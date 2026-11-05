#!/usr/bin/env python3
from pathlib import Path
import shutil,subprocess,tempfile,json,hashlib,datetime
root=Path(__file__).resolve().parents[7]
case=root/'examples/models/sum2'
attempt=Path(__file__).resolve().parent
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
 shutil.copyfile(attempt/'Proof.v',proof/'Attempt.v')
 shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vos','*.vok','__pycache__'))
 flags=['-Q',str(model),'FiveSum2','-Q',str(proof),'FiveSum2Proof','-Q',str(shared),'FiveShared']
 order=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',model/'Source.v',model/'Execution.v',model/'proof/Precondition.v',model/'proof/Obligations.v']+[proof/f'{f}.v' for f in ['SourceInvariant','support/NormalCorrespondence','PureProgress','Invariant','Entry','NoErrorSpec','TerminationSpec','Attempt']]
 evidence=attempt/'evidence';evidence.mkdir(exist_ok=True)
 snapshot=evidence/'checked-inputs';snapshot.mkdir(exist_ok=True)
 inputs=[]
 for src in order:
  rel=src.relative_to(b);dst=snapshot/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst)
  inputs.append({'path':str(rel),'sha256':hashlib.sha256(src.read_bytes()).hexdigest()})
 receipt={'schema':'five-checker-run/1','status':'running','inputs':inputs,'commands':[],'theorem_module':'FiveSum2Proof.Attempt'}
 def run(argv):
  command={'argv':argv,'started_at':datetime.datetime.now(datetime.timezone.utc).isoformat()}
  print('Execute:',*argv,flush=True)
  result=subprocess.run(argv,cwd=root)
  command.update(exit_code=result.returncode,finished_at=datetime.datetime.now(datetime.timezone.utc).isoformat())
  receipt['commands'].append(command)
  (evidence/'checker-run.json').write_text(json.dumps(receipt,indent=2)+'\n')
  result.check_returncode()
 for p in order:run(['rocq','compile',*flags,str(p)])
 run(['rocq','check','-silent',*flags,'FiveSum2Proof.Attempt'])
 receipt['status']='passed'
 (evidence/'checker-run.json').write_text(json.dumps(receipt,indent=2)+'\n')
 print('Rebuilt input model and dependencies; independently kernel-checked Attempt.')
