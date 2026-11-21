#!/usr/bin/env python3
"""Replay exact worker-authored goals using the shared cold checker."""
from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedSetNedIExecutionProblem.Spec', 'StateSpeedSetNedIExecutionAttempt001.Proof']
BINDINGS = [{'requested_goal': 'domain_preservation',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.domain_preservation',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.domain_preservation_goal'},
 {'requested_goal': 'floating_point_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.floating_point_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.floating_point_correspondence_goal'},
 {'requested_goal': 'machine_integer_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.machine_integer_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.machine_integer_correspondence_goal'},
 {'requested_goal': 'memory_access_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.memory_access_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.memory_access_correspondence_goal'},
 {'requested_goal': 'control_and_exhaustion_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.control_and_exhaustion_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.control_and_exhaustion_correspondence_goal'},
 {'requested_goal': 'normal_result_and_memory_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.normal_result_and_memory_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.normal_result_and_memory_correspondence_goal'},
 {'requested_goal': 'invalid_operation_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.invalid_operation_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.invalid_operation_correspondence_goal'},
 {'requested_goal': 'whole_execution_correspondence',
  'theorem': 'StateSpeedSetNedIExecutionAttempt001.Proof.whole_execution_correspondence',
  'type': 'StateSpeedSetNedIExecutionProblem.Spec.whole_execution_correspondence_goal'}]
OUTCOME = 'proved'

if __name__ == '__main__':
    root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
    path=root/'paparazzi/relations/state_speed_ecef_provenance/support/Check.py'
    spec=importlib.util.spec_from_file_location('state_speed_cold_checker',path)
    engine=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(engine)
    engine.main(Path(__file__))
