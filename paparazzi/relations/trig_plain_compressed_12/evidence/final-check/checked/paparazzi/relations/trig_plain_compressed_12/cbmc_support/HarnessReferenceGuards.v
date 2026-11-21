From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix.
From PprzTrigCBMC Require Import TypedGuards HarnessGuards InitReference.
Local Open Scope Z_scope.
Local Opaque ordinary_values init_reference_values.
(** Both frozen compressed harness reference_table.h files have SHA256
40317370ba6970341e62a9c31c59e96c6204446d27dadc92b79d05d0ef05c87c.
InitReference reifies those identical literal bytes, not a source execution. *)
Theorem reference_positive_fold_guard : forall a,Spec.normalized_angle a->signed32(12867-Int.signed a).
Proof. intros;exact(proj1(harness_reference_guards a H)). Qed.
Theorem reference_negative_fold_guard : forall a,Spec.normalized_angle a->signed32(-12867-Int.signed a).
Proof. intros;exact(proj1(proj2(harness_reference_guards a H))). Qed.
Theorem reference_negative_index_guard : forall a,Spec.normalized_angle a->signed32(-harness_fold(Int.signed a)).
Proof. intros;exact(proj1(proj2(proj2(proj2(harness_reference_guards a H))))). Qed.
Theorem reference_positive_index_bounds : forall a,Spec.normalized_angle a->0<=harness_fold(Int.signed a)->
 0<=harness_fold(Int.signed a)<Z.of_nat(length init_reference_values).
Proof.
 intros a A POS;rewrite init_reference_length;change(0<=harness_fold(Int.signed a)<6434).
 exact(proj1(proj2(proj2(proj2(proj2(harness_reference_guards a A)))) )POS).
Qed.
Theorem reference_negative_index_bounds : forall a,Spec.normalized_angle a->harness_fold(Int.signed a)<0->
 0<= -harness_fold(Int.signed a)<Z.of_nat(length init_reference_values).
Proof.
 intros a A NEG;rewrite init_reference_length;change(0<= -harness_fold(Int.signed a)<6434).
 exact(proj1(proj2(proj2(proj2(proj2(proj2(harness_reference_guards a A))))))NEG).
Qed.
Theorem reference_value_negation_guard : forall a,Spec.normalized_angle a->harness_fold(Int.signed a)<0->
 signed32(-nth(Z.to_nat(-harness_fold(Int.signed a)))init_reference_values 0).
Proof.
 intros a A NEG;rewrite init_reference_at.
 pose proof(reference_negative_index_bounds a A NEG)as INDEX;rewrite init_reference_length in INDEX.
 change(0<= -harness_fold(Int.signed a)<6434)in INDEX.
 pose proof(literal_value_at_bounds(-harness_fold(Int.signed a))INDEX)as B.
 change(0<=table_at(-harness_fold(Int.signed a))<=16383)in B;unfold signed32;lia.
Qed.
Print Assumptions reference_value_negation_guard.
