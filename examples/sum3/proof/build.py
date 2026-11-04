import shutil,subprocess,tempfile
from pathlib import Path
root=Path('/home/yangfp/five'); build=Path(tempfile.mkdtemp(prefix='sum3-proof-',dir=root/'_build'))
examples=build/'examples'; shared=build/'shared'
shutil.copytree(root/'examples/sum3',examples/'sum3',ignore=shutil.ignore_patterns('*.vo','*.glob','*.vok','*.vos','rerun','evidence'))
shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vok','*.vos'))
flags=['-Q',str(examples),'FiveCases','-Q',str(shared),'FiveShared']
files=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',
 examples/'sum3/model/Source.v',examples/'sum3/model/Execution.v',examples/'sum3/model/SourceInvariant.v',
 examples/'sum3/proof/support/NormalCorrespondence.v',examples/'sum3/proof/PureProgress.v',
 examples/'sum3/proof/Invariant.v',examples/'sum3/proof/Entry.v',examples/'sum3/proof/Core.v',
 examples/'sum3/proof/NoError.v',examples/'sum3/proof/Precondition.v',examples/'sum3/proof/Obligations.v',
 examples/'sum3/proof/Proofs.v',examples/'sum3/proof/Functional.v']
for f in files:
 print('Compile',f,flush=True)
 subprocess.run(['/home/yangfp/.opam/five/bin/rocq','compile',*flags,str(f)],check=True,cwd=root)
print('Independent kernel check',flush=True)
subprocess.run(['/home/yangfp/.opam/five/bin/rocq','check','-silent',*flags,'FiveCases.sum3.proof.NoError','FiveCases.sum3.proof.Functional'],check=True,cwd=root)
print('SUCCESS; build directory:',build,flush=True)
