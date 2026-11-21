From PidPositionRunPosNoErrorProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import MainGoals.
Theorem no_error : PidPositionRunPosNoErrorProblem.Spec.RequestedGoal.
Proof. exact MainGoals.proved_no_error. Qed.
Definition goal_0 : PidPositionRunPosNoErrorProblem.Spec.RequestedGoal := no_error.
Print Assumptions no_error.
Print Assumptions goal_0.
