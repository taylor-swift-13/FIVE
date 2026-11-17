From PidPositionRunPosTerminationProblem Require Import Spec.
From PidPositionSafety Require Import GoalBinding.
Theorem termination : PidPositionRunPosTerminationProblem.Spec.RequestedGoal.
Proof. exact GoalBinding.all_successor_termination_goal. Qed.
Definition goal_0 : PidPositionRunPosTerminationProblem.Spec.RequestedGoal := termination.
Print Assumptions termination.
Print Assumptions goal_0.
