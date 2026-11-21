#!/usr/bin/env python3
"""Replay exact worker-authored goals using the shared cold checker."""
from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedRelationProblem.Spec', 'StateSpeedRelationAttempt001.Proof']
BINDINGS = [{'requested_goal': 'actual_protocol',
  'theorem': 'StateSpeedRelationAttempt001.Proof.proved_actual_protocol',
  'type': 'StateSpeedRelationProblem.Spec.ActualProtocolGoal'},
 {'requested_goal': 'read_after_write_refutation',
  'theorem': 'StateSpeedRelationAttempt001.Proof.proved_read_after_write_refutation',
  'type': 'StateSpeedRelationProblem.Spec.ReadAfterWriteRefutationGoal'},
 {'requested_goal': 'history_independence_refutation',
  'theorem': 'StateSpeedRelationAttempt001.Proof.proved_history_independence_refutation',
  'type': 'StateSpeedRelationProblem.Spec.HistoryIndependenceRefutationGoal'}]
OUTCOME = 'proved'

if __name__ == '__main__':
    root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
    path=root/'paparazzi/relations/state_speed_ecef_provenance/support/Check.py'
    spec=importlib.util.spec_from_file_location('state_speed_cold_checker',path)
    engine=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(engine)
    engine.main(Path(__file__))
