#!/usr/bin/env python3
from pathlib import Path
import shutil,subprocess,hashlib,json,sys
root=Path(__file__).resolve().parents[7]
attempt=Path(__file__).resolve().parent
case=root/'examples/models/sum3'
build=Path(sys.argv[1]).resolve()
build.mkdir(parents=True,exist_ok=True)
model=build/'model'; proof=build/'proof'; shared=build/'shared'
model.mkdir(exist_ok=True); proof.mkdir(exist_ok=True)
inputs={}
def copy(src,dst):
 dst.parent.mkdir(parents=True,exist_ok=True)
 shutil.copyfile(src,dst)
 inputs[str(src.relative_to(root))]=hashlib.sha256(src.read_bytes()).hexdigest()
for f in ['Source.v','Execution.v','proof/Precondition.v','proof/Obligations.v']:
 copy(case/'align/model'/f,model/f)
for f in ['SourceInvariant','PureProgress','Invariant','Entry','Functional']:
 copy(case/'rocq/support'/(f+'.v'),proof/(f+'.v'))
copy(case/'rocq/support/NormalCorrespondence.v',proof/'support/NormalCorrespondence.v')
copy(case/'rocq/cbmc_recheck/problem/Spec.v',proof/'RecheckSpec.v')
copy(case/'rocq/cbmc_recheck/problem/FullSpec.v',proof/'FullSpec.v')
copy(case/'rocq/no_error/problem/Spec.v',proof/'NoErrorSpec.v')
copy(case/'rocq/termination/problem/Spec.v',proof/'TerminationSpec.v')
copy(case/'rocq/termination/attempts/001/Proof.v',proof/'Termination.v')
copy(attempt/'Proof.v',proof/'Proof.v')
for src in (root/'shared').rglob('*.v'):
 copy(src,shared/src.relative_to(root/'shared'))
(build/'compiled-inputs.json').write_text(json.dumps(inputs,indent=2)+'\n')
flags=['-Q',str(model),'FiveSum3','-Q',str(proof),'FiveSum3Proof','-Q',str(shared),'FiveShared']
order=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',model/'Source.v',model/'Execution.v',model/'proof/Precondition.v',model/'proof/Obligations.v',proof/'SourceInvariant.v',proof/'support/NormalCorrespondence.v',proof/'PureProgress.v',proof/'Invariant.v',proof/'Entry.v',proof/'Functional.v',proof/'RecheckSpec.v',proof/'NoErrorSpec.v',proof/'TerminationSpec.v',proof/'Termination.v',proof/'FullSpec.v',proof/'Proof.v']
for src in order:
 subprocess.run(['rocq','compile',*flags,str(src)],cwd=root,check=True)
subprocess.run(['rocq','check','-silent',*flags,'FiveSum3Proof.Proof'],cwd=root,check=True)
print('Current-model Csem result and bit theorem compiled and independently checked.')
