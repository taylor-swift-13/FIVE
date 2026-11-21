#!/usr/bin/env python3
from pathlib import Path
import argparse,sys
attempt=Path(__file__).resolve().parent
sys.path.insert(0,str(attempt.parents[2]/"support"))
from build import verify_problem
parser=argparse.ArgumentParser()
parser.add_argument("--record-run")
parser.add_argument("--build-directory")
args=parser.parse_args()
verify_problem(attempt,'FivePidDfFunctional',[{'requested_goal': 'NormalCompletion', 'theorem': 'FivePidDfFunctional.Proof.normal_completion', 'type': 'FivePidDfFunctional.Spec.NormalCompletion'}, {'requested_goal': 'AllReturns', 'theorem': 'FivePidDfFunctional.Proof.all_returns', 'type': 'FivePidDfFunctional.Spec.AllReturns'}, {'requested_goal': 'Nonvacuity', 'theorem': 'FivePidDfFunctional.Proof.nonvacuity', 'type': 'FivePidDfFunctional.Spec.Nonvacuity'}],args.record_run,args.build_directory)
