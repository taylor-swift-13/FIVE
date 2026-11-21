From compcert Require Import Values Memory Events Csem.
From FiveShared.verification Require Import Obligations.
From PidPositionRunPos Require Import Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import PidTermination.
Local Transparent PidTermination.ge.
Theorem all_successor_termination_goal : Spec.AllSuccessorTerminationGoal.
Proof.
 unfold Spec.AllSuccessorTerminationGoal;intros gh ret m flight GOOD.
 pose proof(PidTermination.all_successor_termination(Spec.call_args gh ret flight)m)as ACC.
 unfold PidTermination.ge in ACC;exact ACC.
Qed.
Definition goal_0 : Spec.AllSuccessorTerminationGoal := all_successor_termination_goal.
Print all_successor_termination_goal.
Print Assumptions all_successor_termination_goal.
Print Assumptions goal_0.
