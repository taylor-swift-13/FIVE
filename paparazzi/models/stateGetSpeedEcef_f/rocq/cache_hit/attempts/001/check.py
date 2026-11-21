from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedGetterCacheProblem.Spec', 'StateSpeedGetterCacheAttempt001.Proof']
BINDINGS = [{'requested_goal': 'safety', 'theorem': 'StateSpeedGetterCacheAttempt001.Proof.proved_safety', 'type': 'StateSpeedGetterCacheProblem.Spec.SafetyGoal'}, {'requested_goal': 'termination', 'theorem': 'StateSpeedGetterCacheAttempt001.Proof.proved_termination', 'type': 'StateSpeedGetterCacheProblem.Spec.TerminationGoal'}, {'requested_goal': 'exact_return', 'theorem': 'StateSpeedGetterCacheAttempt001.Proof.proved_exact_return', 'type': 'StateSpeedGetterCacheProblem.Spec.ExactReturnGoal'}, {'requested_goal': 'byte_frame', 'theorem': 'StateSpeedGetterCacheAttempt001.Proof.proved_byte_frame', 'type': 'StateSpeedGetterCacheProblem.Spec.ByteFrameGoal'}]
OUTCOME = 'proved'
if __name__=='__main__':
 root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
 p=root/'paparazzi/relations/state_speed_ecef_cache_protocol/support/Check.py'
 spec=importlib.util.spec_from_file_location('cache_checker',p)
 engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine);engine.main(Path(__file__))
