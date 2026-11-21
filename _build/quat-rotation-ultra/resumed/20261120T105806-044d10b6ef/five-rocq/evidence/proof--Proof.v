From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory.
From FiveQuatRotation Require Import Spec.
From FiveQuatRotationSupport Require Import Numerics.
Import ListNotations.
Lemma unit_witness_refutes:UnitWitness->Refutation.
Proof.
 intros(m&q&v&a&r&b&ca&cb&md&mr&mf&SEP&DOM&QB&VB&CD&CM&CR&LEFT&RIGHT&FRAME&OBS) E.
 pose proof(E m q v a r b md mr mf DOM CD CM CR)as EQ.
 rewrite LEFT,RIGHT in EQ;vm_compute in EQ;discriminate.
Qed.
From FiveQuatRotationSupport Require Import Witness.
Require FiveQuatVmultRecheck.Proof FiveRmatOfQuatRecheck.Proof FiveRmatVmultRecheck.Proof FiveRmatVmultCase.MemcpyLedger.
Theorem unit_protocol_witness:Spec.UnitWitness.
Proof. exact Witness.unit_witness. Qed.
Theorem actual_cbmc_trace_replayed:Spec.ActualTraceWitness.
Proof. exact Witness.actual_trace_witness. Qed.
Theorem candidate1_refuted:Spec.Refutation.
Proof. apply unit_witness_refutes;exact unit_protocol_witness. Qed.
Theorem all_original_300_proved:Spec.Independent300.
Proof. split;[exact FiveQuatVmultRecheck.Proof.all_original_96_proved|];split;[exact FiveRmatOfQuatRecheck.Proof.all_original_87_proved|];split;[exact FiveRmatVmultRecheck.Proof.all_original_99_proved|exact FiveRmatVmultCase.MemcpyLedger.all_original_18_proved]. Qed.
Print Assumptions unit_protocol_witness.
Print Assumptions actual_cbmc_trace_replayed.
Print Assumptions candidate1_refuted.
Print Assumptions all_original_300_proved.
From compcert Require Import AST Integers Csyntax Csyntaxdefs.
From FiveQuatRotationSupport Require Import Assertion.
Theorem unit_assertion_false:Spec.UnitAssertionFalse.
Proof. split;[exact unit_protocol_witness|].
 intros ge f e m a b LEFT RIGHT;eapply(assertion_false_steps ge f e m a b(Int.repr 1065353216)(Int.repr 1065353214));
 [exact(uint32_vector_firstword m a(Int.repr 1065353216)(Int.repr 0)(Int.repr 0)LEFT)|exact(uint32_vector_firstword m b(Int.repr 1065353214)(Int.repr 0)(Int.repr 0)RIGHT)|reflexivity]. Qed.
Theorem actual_assertion_replayed:Spec.ActualAssertionFalse.
Proof. split;[exact actual_cbmc_trace_replayed|].
 intros ge f e m a b LEFT RIGHT;eapply(assertion_false_steps ge f e m a b(Int.repr 1095327876)(Int.repr 1095327877));
 [exact(uint32_vector_firstword m a(Int.repr 1095327876)(Int.repr 1106339776)(Int.repr 3280478549)LEFT)|exact(uint32_vector_firstword m b(Int.repr 1095327877)(Int.repr 1106339776)(Int.repr 3280478549)RIGHT)|reflexivity]. Qed.
Print Assumptions unit_assertion_false.
Print Assumptions actual_assertion_replayed.
