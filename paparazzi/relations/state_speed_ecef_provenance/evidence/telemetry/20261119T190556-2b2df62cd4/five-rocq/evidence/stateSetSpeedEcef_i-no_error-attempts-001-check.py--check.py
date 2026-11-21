#!/usr/bin/env python3
"""Replay exact worker-authored goals using the shared cold checker."""
from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedSetEcefINoErrorProblem.Spec', 'StateSpeedSetEcefINoErrorAttempt001.Proof']
BINDINGS = [{'requested_goal': 'no_error',
  'theorem': 'StateSpeedSetEcefINoErrorAttempt001.Proof.proved_no_error',
  'type': 'StateSpeedSetEcefINoErrorProblem.Spec.NoErrorGoal'},
 {'requested_goal': 'normal_result',
  'theorem': 'StateSpeedSetEcefINoErrorAttempt001.Proof.proved_normal_result',
  'type': 'StateSpeedSetEcefINoErrorProblem.Spec.NormalResultGoal'}]
OUTCOME = 'proved'

if __name__ == '__main__':
    root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
    path=root/'paparazzi/relations/state_speed_ecef_provenance/support/Check.py'
    spec=importlib.util.spec_from_file_location('state_speed_cold_checker',path)
    engine=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(engine)
    engine.main(Path(__file__))
