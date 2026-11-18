Require Import PidAlternatingProblem.Spec.
Require Import PidAlternatingAttempt001.Proof.
Definition goal_0 : PidAlternatingProblem.Spec.DriftGoal := PidAlternatingAttempt001.Proof.proved_drift.
Print Assumptions goal_0.
Definition goal_1 : PidAlternatingProblem.Spec.InitialExistenceGoal := PidAlternatingAttempt001.Proof.proved_initial_existence.
Print Assumptions goal_1.
Definition goal_2 : PidAlternatingProblem.Spec.ReadyExecutionGoal := PidAlternatingAttempt001.Proof.proved_ready_execution.
Print Assumptions goal_2.
Definition goal_3 : PidAlternatingProblem.Spec.ExecutionExistenceGoal := PidAlternatingAttempt001.Proof.proved_execution_existence.
Print Assumptions goal_3.
