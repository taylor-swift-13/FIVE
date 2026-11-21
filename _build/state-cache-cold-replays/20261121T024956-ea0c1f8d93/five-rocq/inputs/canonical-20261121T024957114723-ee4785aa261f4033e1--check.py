from pathlib import Path
import importlib.util
IMPORTS = ['StateSpeedCacheProtocolProblem.Spec', 'StateSpeedCacheProtocolAttempt001.Proof']
BINDINGS = [{'requested_goal': 'repeated_hit', 'theorem': 'StateSpeedCacheProtocolAttempt001.Proof.proved_repeated_hit', 'type': 'StateSpeedCacheProtocolProblem.Spec.RepeatedHitGoal'}, {'requested_goal': 'protocol', 'theorem': 'StateSpeedCacheProtocolAttempt001.Proof.proved_protocol', 'type': 'StateSpeedCacheProtocolProblem.Spec.ProtocolGoal'}, {'requested_goal': 'invalidation', 'theorem': 'StateSpeedCacheProtocolAttempt001.Proof.proved_invalidation', 'type': 'StateSpeedCacheProtocolProblem.Spec.InvalidationGoal'}, {'requested_goal': 'freshness_refutation', 'theorem': 'StateSpeedCacheProtocolAttempt001.Proof.proved_freshness_refutation', 'type': 'StateSpeedCacheProtocolProblem.Spec.FreshnessRefutationGoal'}, {'requested_goal': 'history_refutation', 'theorem': 'StateSpeedCacheProtocolAttempt001.Proof.proved_history_refutation', 'type': 'StateSpeedCacheProtocolProblem.Spec.HistoryRefutationGoal'}]
OUTCOME = 'proved'
if __name__=='__main__':
 root=next(p for p in Path(__file__).resolve().parents if (p/'scripts/five_telemetry.py').is_file())
 p=root/'paparazzi/relations/state_speed_ecef_cache_protocol/support/Check.py'
 spec=importlib.util.spec_from_file_location('cache_checker',p)
 engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine);engine.main(Path(__file__))
