From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import Proof.
Theorem bound_position_translation : Spec.PositionTranslationGoal.
Proof. exact Proof.position_translation. Qed.
Theorem bound_no_error : Spec.NoErrorGoal.
Proof. exact Proof.no_error. Qed.
Theorem bound_all_successor_termination : Spec.AllSuccessorTerminationGoal.
Proof. exact Proof.all_successor_termination. Qed.
Theorem bound_input_nonvacuity : Spec.InputNonvacuityGoal.
Proof. exact Proof.input_nonvacuity. Qed.
Theorem bound_nonzero_nonvacuity : Spec.NonzeroNonvacuityGoal.
Proof. exact Proof.nonzero_nonvacuity. Qed.
Print Assumptions bound_position_translation.
Print Assumptions bound_no_error.
Print Assumptions bound_all_successor_termination.
Print Assumptions bound_input_nonvacuity.
Print Assumptions bound_nonzero_nonvacuity.

Theorem bound_relational_frame : Spec.RelationalFrameGoal.
Proof. exact Proof.relational_frame. Qed.
Print Assumptions bound_relational_frame.
