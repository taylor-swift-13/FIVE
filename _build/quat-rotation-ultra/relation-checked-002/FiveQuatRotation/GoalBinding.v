Require Import FiveQuatRotation.Spec.
Require Import FiveQuatRotation.Proof.
Definition goal_0 : FiveQuatRotation.Spec.UnitWitness := FiveQuatRotation.Proof.unit_protocol_witness.
Print Assumptions goal_0.
Definition goal_1 : FiveQuatRotation.Spec.ActualTraceWitness := FiveQuatRotation.Proof.actual_cbmc_trace_replayed.
Print Assumptions goal_1.
Definition goal_2 : FiveQuatRotation.Spec.Refutation := FiveQuatRotation.Proof.candidate1_refuted.
Print Assumptions goal_2.
Definition goal_3 : FiveQuatRotation.Spec.Independent300 := FiveQuatRotation.Proof.all_original_300_proved.
Print Assumptions goal_3.
Definition goal_4 : FiveQuatRotation.Spec.UnitAssertionFalse := FiveQuatRotation.Proof.unit_assertion_false.
Print Assumptions goal_4.
Definition goal_5 : FiveQuatRotation.Spec.ActualAssertionFalse := FiveQuatRotation.Proof.actual_assertion_replayed.
Print Assumptions goal_5.
