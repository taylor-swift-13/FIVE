From FiveGhSetOmegaRecheck Require Import Spec.
From FiveGhSetOmegaProof Require Import Entry BitsAdapter.
From Stdlib Require Import ZArith Lia.
From compcert Require Import AST Integers Floats Values Memory Ctypes Csyntaxdefs Cop.
From FiveGhSetOmega Require Import Execution.
From FivePaparazziState Require Import State.
Lemma bit_assert_reflexive:forall x m,Spec.BitAssert x x m.
Proof. intros;unfold Spec.BitAssert,sem_binary_operation,sem_cmp,sem_binarith; simpl;unfold sem_cast; simpl;rewrite ?Int.eq_true;reflexivity. Qed.
Theorem main_assertion_1:Spec.Assertion1.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[-> [RF WF]].
 exists(clamp_omega o),(clamp_omega o);split;[reflexivity|].split.
 - unfold repr,set_omega in RF;simpl in RF;tauto.
 - split;[apply bit_assert_reflexive|].split;[apply bit_assert_reflexive|].split;apply bits_observation.
Qed.
Theorem main_assertion_2:Spec.Assertion2.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[RET[RF WF]].
 exists(Float32.mul(clamp_omega o)(clamp_omega o));split.
 - unfold repr,set_omega in RF;simpl in RF;tauto.
 - split;[apply bit_assert_reflexive|apply bits_observation].
Qed.
Theorem main_assertion_3:Spec.Assertion3.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[RET[RF WF]].
 exists(Float32.mul(zeta s)(clamp_omega o));split.
 - unfold repr,set_omega in RF;simpl in RF;tauto.
 - split;[apply bit_assert_reflexive|apply bits_observation].
Qed.
Theorem main_assertion_4:Spec.Assertion4.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[RET[RF WF]].
 exists(set_omega s o);split;[exact RF|reflexivity].
Qed.
Theorem bits_adapter_guards:Spec.AdapterGuards.
Proof.
 intros x m;split;[apply bits_observation|].
 split;[split;vm_compute;congruence|].split;[split;vm_compute;congruence|].split;reflexivity.
Qed.
Print Assumptions main_assertion_1.
Print Assumptions main_assertion_2.
Print Assumptions main_assertion_3.
Print Assumptions main_assertion_4.
Print Assumptions bits_adapter_guards.
