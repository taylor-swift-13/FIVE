#!/usr/bin/env python3
"""Validate current Paparazzi cases/relation; optionally rebuild every active proof."""
from pathlib import Path
import argparse, importlib.util, json, subprocess, sys
root=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(root/"scripts"))
spec=importlib.util.spec_from_file_location("five_reference_validator",root/"scripts/check-example-artifacts.py")
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
def main():
 parser=argparse.ArgumentParser();parser.add_argument("--compile",action="store_true");args=parser.parse_args()
 validator=module.Validator(root)
 for name in ("gh_set_omega","gh_set_zeta"):
  case=root/"paparazzi/models"/name;validator.case(case)
  for problem in sorted((case/"rocq").glob("*/problem")):
   if problem.parent.name not in ("no_error","termination","cbmc_recheck"):validator.proof_problem(problem)
 validator.proof_problem(root/"paparazzi/relations/parameter_order/problem")
 if validator.errors:
  print(json.dumps({"status":"failed","errors":validator.errors},indent=2));raise SystemExit(1)
 if args.compile:
  for attempt in validator.active:subprocess.run([sys.executable,str(attempt/"check.py")],cwd=root,check=True)
 print(json.dumps({"status":"passed","active_problems":len(validator.active),"compile":args.compile},indent=2))
if __name__=="__main__":main()
