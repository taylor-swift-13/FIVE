Require Import PidMeasurementProblem.Spec.
Require Import PidMeasurementAttempt001.Proof.
Definition goal_0 : PidMeasurementProblem.Spec.ArbitraryHorizonGoal := PidMeasurementAttempt001.Proof.proved_arbitrary_horizon.
Print Assumptions goal_0.
Definition goal_1 : PidMeasurementProblem.Spec.ExecutionTotalGoal := PidMeasurementAttempt001.Proof.proved_execution_total.
Print Assumptions goal_1.
Definition goal_2 : PidMeasurementProblem.Spec.EveryCallNoErrorGoal := PidMeasurementAttempt001.Proof.proved_every_call_no_error.
Print Assumptions goal_2.
Definition goal_3 : PidMeasurementProblem.Spec.EveryCallTerminationGoal := PidMeasurementAttempt001.Proof.proved_every_call_termination.
Print Assumptions goal_3.
Definition goal_4 : PidMeasurementProblem.Spec.ZeroPerturbationGoal := PidMeasurementAttempt001.Proof.proved_zero_perturbation.
Print Assumptions goal_4.
