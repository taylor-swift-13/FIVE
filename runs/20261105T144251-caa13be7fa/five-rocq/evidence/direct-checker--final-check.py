#!/usr/bin/env python3
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[7]/'scripts'))
from five_telemetry import Run
root=Path(__file__).resolve().parents[7]
a=Path(__file__).resolve().parent
run=Run(root/sys.argv[1]);build=root/'_build/sum3-recheck-002'
flags=['-Q',str(build/'model'),'FiveSum3','-Q',str(build/'proof'),'FiveSum3Proof','-Q',str(build/'shared'),'FiveShared','-Q',str(a),'FiveSum3Attempt','-Q',str(a.parents[1]/'problem'),'FiveSum3Problem']
# Each actual source is captured immediately before its final compile/check.
inputs=[root/p for p in __import__('json').loads((build/'compiled-inputs.json').read_text())]
inputs+=[root/'examples/models/sum3/prepare/source/sum3.c',root/'examples/models/sum3/cbmc/harness.c']
inputs+=[root/'examples/models/sum3/align/model/compcert-manifest.json',root/'examples/models/sum3/prepare/source/bindings.json']
inputs+=list(build.rglob('*.v'))+[a/'check.py',a/'final-check.py']
serial=len(run.read('inputs/manifest.json'))
for i,p in enumerate(dict.fromkeys(inputs)):
 run.capture(p,f'final-pass-{serial}-input-{i}','inputs')
run.command(['rocq','compile',*flags,str(a.parents[1]/'problem/Spec.v')],'permanent-problem-compile',120,cwd=root)
run.command(['rocq','compile',*flags,str(a/'Proof.v')],'permanent-proof-compile',120,cwd=root)
run.command(['rocq','check','-silent',*flags,'FiveSum3Problem.Spec','FiveSum3Attempt.Proof'],'permanent-independent-kernel',180,cwd=root)
