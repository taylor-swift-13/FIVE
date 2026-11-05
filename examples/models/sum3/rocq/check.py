#!/usr/bin/env python3
"""Rebuild and kernel-check the sum3 Rocq specifications in isolation."""
from pathlib import Path
import shutil,subprocess,tempfile
root=Path(__file__).resolve().parents[4]
case=root/'examples/models/sum3'
with tempfile.TemporaryDirectory(prefix='five-sum3-proof-') as tmp:
 b=Path(tmp); model=b/'model'; proof=b/'proof'; shared=b/'shared'
 model.mkdir();proof.mkdir()
 for f in ['Source.v','Execution.v','proof/Precondition.v','proof/Obligations.v']:
  p=model/f;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(case/'align/model'/f,p)
 shutil.copyfile(case/'rocq/support/SourceInvariant.v',proof/'SourceInvariant.v')
 for source, name in [('no_error/problem/Spec.v','NoErrorSpec.v'),('termination/problem/Spec.v','TerminationSpec.v'),('cbmc_recheck/problem/Spec.v','RecheckSpec.v')]:
  shutil.copyfile(case/'rocq'/source,proof/name)
 shutil.copytree(root/'shared',shared,ignore=shutil.ignore_patterns('*.vo','*.glob','*.vos','*.vok','__pycache__'))
 flags=['-Q',str(model),'FiveSum3','-Q',str(proof),'FiveSum3Proof','-Q',str(shared),'FiveShared']
 order=[shared/'pure_semantics/SemanticsSupport.v',shared/'verification/Obligations.v',model/'Source.v',model/'Execution.v',model/'proof/Precondition.v',model/'proof/Obligations.v',proof/'SourceInvariant.v',proof/'NoErrorSpec.v',proof/'TerminationSpec.v',proof/'RecheckSpec.v']
 for p in order:subprocess.run(['rocq','compile',*flags,str(p)],cwd=root,check=True)
 subprocess.run(['rocq','check','-silent',*flags,'FiveSum3Proof.NoErrorSpec','FiveSum3Proof.TerminationSpec','FiveSum3Proof.RecheckSpec'],cwd=root,check=True)
 print('Rebuilt and kernel-checked sum3 specifications.')
