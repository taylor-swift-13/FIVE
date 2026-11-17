Require Import PidGroundIntegralProblem.Spec.
Require Import PidGroundIntegralAttempt001.Proof.
Definition goal_0 : PidGroundIntegralProblem.Spec.GroundIndependenceGoal := PidGroundIntegralAttempt001.Proof.ground_integral_independence.
Print Assumptions goal_0.
Definition goal_1 : PidGroundIntegralProblem.Spec.GroundFrameGoal := PidGroundIntegralAttempt001.Proof.ground_relational_frame.
Print Assumptions goal_1.
Definition goal_2 : PidGroundIntegralProblem.Spec.GroundNoErrorGoal := PidGroundIntegralAttempt001.Proof.ground_no_error.
Print Assumptions goal_2.
Definition goal_3 : PidGroundIntegralProblem.Spec.GroundTerminationGoal := PidGroundIntegralAttempt001.Proof.ground_all_successor_termination.
Print Assumptions goal_3.
Definition goal_4 : PidGroundIntegralProblem.Spec.GroundNonvacuityGoal := PidGroundIntegralAttempt001.Proof.ground_different_integrals_nonvacuity.
Print Assumptions goal_4.
