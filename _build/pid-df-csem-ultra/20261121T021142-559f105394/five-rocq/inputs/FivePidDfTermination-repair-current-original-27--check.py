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
verify_problem(attempt,'FivePidDfTermination',[{'requested_goal': 'AllSuccessorsTerminate', 'theorem': 'FivePidDfTermination.Proof.termination', 'type': 'FivePidDfTermination.Spec.AllSuccessorsTerminate'}],args.record_run,args.build_directory)
