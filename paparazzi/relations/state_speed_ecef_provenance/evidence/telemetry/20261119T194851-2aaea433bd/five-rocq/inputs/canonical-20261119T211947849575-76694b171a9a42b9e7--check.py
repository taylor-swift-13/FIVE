#!/usr/bin/env python3
"""Replay exact worker-authored goals using the shared cold checker."""
from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedGetterExecutionProblem.Spec', 'StateSpeedGetterExecutionAttempt001.Proof']
BINDINGS = [{'requested_goal': 'domain_preservation',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_domain_preservation',
  'type': 'StateSpeedGetterExecutionProblem.Spec.domain_preservation_goal'},
 {'requested_goal': 'floating_point_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_floating_point_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.floating_point_correspondence_goal'},
 {'requested_goal': 'machine_integer_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_machine_integer_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.machine_integer_correspondence_goal'},
 {'requested_goal': 'memory_access_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_memory_access_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.memory_access_correspondence_goal'},
 {'requested_goal': 'control_and_exhaustion_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_control_and_exhaustion_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.control_and_exhaustion_correspondence_goal'},
 {'requested_goal': 'normal_result_and_memory_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_normal_result_and_memory_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.normal_result_and_memory_correspondence_goal'},
 {'requested_goal': 'invalid_operation_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_invalid_operation_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.invalid_operation_correspondence_goal'},
 {'requested_goal': 'whole_execution_correspondence',
  'theorem': 'StateSpeedGetterExecutionAttempt001.Proof.proved_whole_execution_correspondence',
  'type': 'StateSpeedGetterExecutionProblem.Spec.whole_execution_correspondence_goal'}]
OUTCOME = 'proved'

if __name__ == '__main__':
    root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
    path=root/'paparazzi/relations/state_speed_ecef_provenance/support/Check.py'
    spec=importlib.util.spec_from_file_location('state_speed_cold_checker',path)
    engine=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(engine)
    engine.main(Path(__file__))
