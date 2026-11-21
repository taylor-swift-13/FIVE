#!/usr/bin/env python3
"""Read-only current-artifact acceptance. Proof checkers separately offer cold recompilation."""
from pathlib import Path
import hashlib,json,sys
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'scripts'))
from example_proof_gate import validate_current
from compcert_gate import kernel_record
entries=['float_quat_vmult','float_rmat_of_quat','float_rmat_vmult']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
closed=[]
for e in entries:
 C=ROOT/'paparazzi/models'/e
 for stage in ['prepare','cbmc','align','rocq']:
  hand=json.loads((C/stage/'handoff.json').read_text());assert hand['stage']==stage
  assert hand['status']in ['proved','refuted']
  assert(C/stage/'report/report.md').is_file()and(C/stage/'report/costs.json').is_file()
  for row in hand['outputs']:assert sha((C/row['path']).resolve())==row['sha256'],(e,stage,row['role'])
 for kind in ['no_error','termination','cbmc_recheck','execution_correspondence']:
  p=C/'rocq'/kind/'problem';s=json.loads((p/'status.json').read_text());a=(p/s['active_attempt']).resolve()
  validate_current(ROOT,p,a,s);assert(a/'report.md').is_file()and(a/'costs.json').is_file();closed.append(e+'/'+kind)
 ledger=json.loads((C/'rocq/spec-recheck.json').read_text());assert len(ledger['properties'])==301
 assert sum(x['status']=='proved'for x in ledger['properties'])==300 and sum(x['status']=='refuted'for x in ledger['properties'])==1
p=ROOT/'paparazzi/relations/quat_rotation_paths/problem';s=json.loads((p/'status.json').read_text());a=(p/s['active_attempt']).resolve();validate_current(ROOT,p,a,s);closed.append('quat_rotation_paths')
assert(a/'report.md').is_file()and(a/'costs.json').is_file()
for c in [ROOT/'paparazzi/relations/quat_rotation_paths/attempts/001/evidence/gate-kernel-evidence.json']+[ROOT/'paparazzi/models'/e/'rocq/execution_correspondence/attempts/001/evidence/gate-kernel-evidence.json'for e in entries]:kernel_record(ROOT,str(c.relative_to(ROOT)))
run=ROOT/'_build/quat-rotation-ultra/evidence-support/20261120T110255-f59335c660/five-verify';meta=json.loads((run/'run.json').read_text());assert meta['status']=='passed'
gates=json.loads((run/'evidence/gate-results.json').read_text());assert len(gates)==3
for gate in gates:
 assert gate['status']=='accepted'and gate['proved']==300 and gate['refuted']==1
 command=next(c for c in meta['commands']if c['id']==gate['command_id']);assert command['status']=='passed'and command['exit_code']==0
# Re-derive the exact current publication plan/source/kernel preflight without mutating metadata.
import importlib.util
spec=importlib.util.spec_from_file_location('quat_gate',ROOT/'paparazzi/report/quat_rotation_paths/publish_gate.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
plan=module.publication_plan();assert plan['unique_property_count']==301
print(json.dumps({'status':'passed','active_problems':len(closed),'full_shared_property_ids':301,'proved':300,'refuted':1,'accepted_gates':3,'closed':closed},indent=2))
