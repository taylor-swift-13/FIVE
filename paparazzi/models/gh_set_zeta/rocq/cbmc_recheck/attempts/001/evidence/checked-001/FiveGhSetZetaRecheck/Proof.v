From FiveGhSetZetaRecheck Require Import Spec.
From FiveGhSetZetaProof Require Import Entry BitsUnion.
From Stdlib Require Import ZArith Lia.
From compcert Require Import AST Integers Floats Values Memory Ctypes Cop.
From FiveGhSetZeta Require Import Execution.
From FivePaparazziState Require Import State.
Lemma bit_assert_reflexive:forall x m,Spec.BitAssert x x m.
Proof. intros;unfold Spec.BitAssert;cbn [sem_binary_operation sem_cmp classify_cmp];rewrite Int.eq_true;reflexivity. Qed.
Theorem main_assertion_1:Spec.Assertion1.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[-> [RF WF]].
 exists(clamp_zeta o),(clamp_zeta o);split;[reflexivity|].split.
 - unfold repr,set_zeta in RF;simpl in RF;tauto.
 - split;[apply bit_assert_reflexive|].split;[apply bit_assert_reflexive|].split;apply union_observation.
Qed.
Theorem main_assertion_2:Spec.Assertion2.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[RET[RF WF]].
 exists(Float32.mul(clamp_zeta o)(omega s));split.
 - unfold repr,set_zeta in RF;simpl in RF;tauto.
 - split;[apply bit_assert_reflexive|apply union_observation].
Qed.
Theorem main_assertion_3:Spec.Assertion3.
Proof.
 intros s o m b t v mf[SYM[R[W PATH]]].
 destruct(Entry.entry_return_spec s o m b t v mf SYM R W PATH)as[RET[RF WF]].
 exists(set_zeta s o);split;[exact RF|reflexivity].
Qed.
Print Assumptions main_assertion_1.
Print Assumptions main_assertion_2.
Print Assumptions main_assertion_3.
