#!/usr/bin/env python3
"""Validate every actual guidance problem and optionally rebuild active proofs."""
from pathlib import Path
import argparse, importlib.util, json, subprocess, sys, hashlib, re
root=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(root/'scripts'))
spec=importlib.util.spec_from_file_location('five_reference_validator',root/'scripts/check-example-artifacts.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
def audit_input_copies(validator):
 """Check retained input bytes, beyond the original source/hash receipt gate."""
 runs=set()
 for attempt in set(validator.active):
  validation=validator.read(attempt/'evidence/goal-validation.json')
  if validation.get('certificate',{}).get('run'):runs.add(validation['certificate']['run'])
  ref=validation.get('kernel_evidence')
  if ref:
   evidence=validator.read(root/ref)
   if evidence.get('run'):runs.add(evidence['run'])
 for name in ('gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp'):
  ledger=validator.read(root/'paparazzi/models'/name/'rocq/spec-recheck.json')
  if ledger.get('cbmc_run'):runs.add(ledger['cbmc_run'])
 checked=0
 for ref in sorted(runs):
  run=(root/ref).resolve()
  if not validator.require(run.is_relative_to(root),'run path outside repository: '+str(run)):continue
  metadata=validator.read(run/'run.json')
  validator.require(metadata.get('status')=='passed','active proof/CBMC run not passed: '+str(run))
  rows=metadata.get('inputs',[]);validator.require(bool(rows),'empty retained input manifest: '+str(run))
  for row in rows:
   relative=row.get('path');expected=row.get('sha256')
   if not validator.require(row.get('status')!='missing'and isinstance(relative,str)and isinstance(expected,str)and re.fullmatch('[0-9a-f]{64}',expected),'missing or malformed retained input: '+str(run)+': '+str(row.get('source'))):continue
   copied=(run/relative).resolve()
   if not validator.require(copied.is_relative_to(run),'captured input escapes run: '+str(copied)):continue
   if validator.file(copied):
    validator.require(hashlib.sha256(copied.read_bytes()).hexdigest()==expected,'captured input SHA mismatch: '+str(copied));checked+=1
 return {'runs':sorted(runs),'input_copies_checked':checked}
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--compile',action='store_true');args=parser.parse_args()
 validator=module.Validator(root)
 for name in ('gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp'):
  case=root/'paparazzi/models'/name;validator.case(case)
  for problem in sorted((case/'rocq').glob('*/problem')):
   if problem.parent.name not in ('no_error','termination','cbmc_recheck'):validator.proof_problem(problem)
 validator.proof_problem(root/'paparazzi/relations/guidance_mode/problem')
 input_copies=audit_input_copies(validator)
 # Both execution and CBMC gates independently inspect current source bindings.
 if not validator.errors:
  for name in ('gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp'):
   case=root/'paparazzi/models'/name
   from compcert_gate import accept_compcert_delivery
   import hashlib
   request=case/'align/request.json'
   try:accept_compcert_delivery(root,request_path=str(request.relative_to(root)),expected_request_sha256=hashlib.sha256(request.read_bytes()).hexdigest(),contract_path=str((case/'rocq/execution-contract.json').relative_to(root)),manifest_path=str((case/'align/model/compcert-manifest.json').relative_to(root)),spec_recheck_path=str((case/'rocq/spec-recheck.json').relative_to(root)))
   except Exception as exc:validator.errors.append('complete execution gate: '+name+': '+str(exc))
 if validator.errors:
  print(json.dumps({'status':'failed','errors':validator.errors},indent=2));return 1
 if args.compile:
  for attempt in dict.fromkeys(validator.active):subprocess.run([sys.executable,str(attempt/'check.py')],cwd=root,check=True)
 print(json.dumps({'status':'passed','active_problems':len(set(validator.active)),'compile':args.compile,'problems':[str(p.relative_to(root)) for p in validator.active],'input_copy_audit':input_copies},indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
