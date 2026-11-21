Require Import StateSpeedRelationProblem.Spec.
Require Import StateSpeedRelationAttempt001.Proof.
Definition goal_0 : StateSpeedRelationProblem.Spec.ActualProtocolGoal := StateSpeedRelationAttempt001.Proof.proved_actual_protocol.
Print Assumptions goal_0.
Definition goal_1 : StateSpeedRelationProblem.Spec.ReadAfterWriteRefutationGoal := StateSpeedRelationAttempt001.Proof.proved_read_after_write_refutation.
Print Assumptions goal_1.
Definition goal_2 : StateSpeedRelationProblem.Spec.HistoryIndependenceRefutationGoal := StateSpeedRelationAttempt001.Proof.proved_history_independence_refutation.
Print Assumptions goal_2.
