#!/usr/bin/env python3
"""Replay exact worker-authored goals using the shared cold checker."""
from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedSetEcefITerminationProblem.Spec', 'StateSpeedSetEcefITerminationAttempt001.Proof']
BINDINGS = [{'requested_goal': 'termination',
  'theorem': 'StateSpeedSetEcefITerminationAttempt001.Proof.proved_termination',
  'type': 'StateSpeedSetEcefITerminationProblem.Spec.AllSuccessorsTerminate'}]
OUTCOME = 'proved'

if __name__ == '__main__':
    root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
    path=root/'paparazzi/relations/state_speed_ecef_provenance/support/Check.py'
    spec=importlib.util.spec_from_file_location('state_speed_cold_checker',path)
    engine=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(engine)
    engine.main(Path(__file__))
