#!/usr/bin/env python3
"""Replay exact frozen support sources; run under FIVE telemetry for fresh metrics."""
from pathlib import Path
import hashlib,json,subprocess
here=Path(__file__).resolve().parent
root=here.parents[3]
for row in json.loads((here/'source-bindings.json').read_text()):
 snapshot=root/row['snapshot']
 assert hashlib.sha256(snapshot.read_bytes()).hexdigest()==row['snapshot_sha256'], snapshot
build=here/'build'
flags=['-Q',str(build/'FiveLowpassRoundoffSupport'),'FiveLowpassRoundoffSupport','-Q',str(build/'FivePidDfRoundoffSupport'),'FivePidDfRoundoffSupport']
rocq='/home/yangfp/.opam/five/bin/rocq'
for mod in ['FiveLowpassRoundoffSupport/FloatBounds.v','FivePidDfRoundoffSupport/Absorption.v','FivePidDfRoundoffSupport/GoalBinding.v']:
 subprocess.run([rocq,'compile',*flags,str(build/mod)],cwd=root,check=True)
subprocess.run([rocq,'check','-silent',*flags,'FivePidDfRoundoffSupport.Absorption','FivePidDfRoundoffSupport.GoalBinding'],cwd=root,check=True)
print('Frozen sources compiled, exact goals instantiated, independent kernel check passed.')
