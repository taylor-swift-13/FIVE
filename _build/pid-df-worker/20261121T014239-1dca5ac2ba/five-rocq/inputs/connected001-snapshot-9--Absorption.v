From Stdlib Require Import Reals ZArith Lia Lra Psatz.
From Flocq.Core Require Import Core.
From Flocq.IEEE754 Require Import Binary.
From compcert Require Import Integers Floats.
From FiveLowpassRoundoffSupport Require Export FloatBounds.
Open Scope R_scope.
Local Instance prec24 : Prec_gt_0 24 := eq_refl.

Lemma RN_safe_absorption : forall z, Rabs z <= 33554432 ->
 Rlt_bool (Rabs (RN z)) (bpow radix2 128) = true.
Proof.
 intros z H; apply Rlt_bool_true.
 eapply Rle_lt_trans; [apply (RN_abs_bound_pow z 25); [lia|exact H]|].
 change 33554432 with (bpow radix2 25); apply bpow_lt; lia.
Qed.
Lemma add_real_absorption_safe : forall x y, finite x -> finite y ->
 Rabs (r32 x + r32 y) <= 33554432 ->
 finite (Float32.add x y) /\ r32 (Float32.add x y) = RN (r32 x + r32 y).
Proof.
 intros x y Fx Fy Hxy.
 pose proof (Bplus_correct 24 128 eq_refl eq_refl Float32.binop_nan BinarySingleNaN.mode_NE x y Fx Fy) as H.
 pose proof (RN_safe_absorption _ Hxy) as Hb.
 unfold RN,r32 in Hb.
 change (FLT_exp (-149) 24) with (SpecFloat.fexp 24 128) in Hb.
 change ZnearestE with (BinarySingleNaN.round_mode BinarySingleNaN.mode_NE) in Hb.
 rewrite Hb in H; destruct H as [Hr [Hf Hs]]; auto.
Qed.

Definition bound32 : float32 := Float32.of_bits (Int.repr 1266679808).
Definition one32 : float32 := Float32.of_bits (Int.repr 1065353216).
Definition negbound32 : float32 := Float32.of_bits (Int.repr 3414163456).
Definition negone32 : float32 := Float32.of_bits (Int.repr 3212836864).
Lemma finite_bound32 : finite bound32. Proof. vm_compute; reflexivity. Qed.
Lemma finite_one32 : finite one32. Proof. vm_compute; reflexivity. Qed.
Lemma finite_negbound32 : finite negbound32. Proof. vm_compute; reflexivity. Qed.
Lemma finite_negone32 : finite negone32. Proof. vm_compute; reflexivity. Qed.
Lemma real_bound32 : r32 bound32 = 16777216.
Proof. change (8388608 * 2 = 16777216). ring. Qed.
Lemma real_one32 : r32 one32 = 1.
Proof. change (8388608 * /8388608 = 1). field. Qed.
Lemma real_negbound32 : r32 negbound32 = -16777216.
Proof. change (-8388608 * 2 = -16777216). ring. Qed.
Lemma real_negone32 : r32 negone32 = -1.
Proof. change (-8388608 * /8388608 = -1). field. Qed.
Lemma add_upper_endpoint_real : r32 (Float32.add bound32 one32) = 16777216.
Proof. change (8388608 * 2 = 16777216). ring. Qed.
Lemma add_lower_endpoint_real : r32 (Float32.add negbound32 negone32) = -16777216.
Proof. change (-8388608 * 2 = -16777216). ring. Qed.
Lemma RN_upper_endpoint : RN 16777217 = 16777216.
Proof.
 destruct (add_real_absorption_safe bound32 one32 finite_bound32 finite_one32) as [F H].
 { rewrite real_bound32,real_one32,Rabs_right; lra. }
 rewrite add_upper_endpoint_real,real_bound32,real_one32 in H.
 replace (16777216+1) with 16777217 in H by ring. symmetry; exact H.
Qed.
Lemma RN_lower_endpoint : RN (-16777217) = -16777216.
Proof.
 destruct (add_real_absorption_safe negbound32 negone32 finite_negbound32 finite_negone32) as [F H].
 { rewrite real_negbound32,real_negone32,Rabs_left; lra. }
 rewrite add_lower_endpoint_real,real_negbound32,real_negone32 in H.
 replace (-16777216 + -1) with (-16777217) in H by ring. symmetry; exact H.
Qed.

Lemma RN_bound_absorption : forall z, Rabs z <= 16777217 ->
 Rabs (RN z) <= 16777216.
Proof.
 intros z Hz.
 assert (Hrange : -16777217 <= z <= 16777217) by (apply Rabs_le_inv; exact Hz).
 pose proof (RN_le (-16777217) z (proj1 Hrange)) as Hl.
 pose proof (RN_le z 16777217 (proj2 Hrange)) as Hu.
 rewrite RN_lower_endpoint in Hl; rewrite RN_upper_endpoint in Hu.
 apply Rabs_le; lra.
Qed.
Lemma add_absorption : forall x y,
 finite x -> finite y -> Rabs (r32 x) <= 16777216 -> Rabs (r32 y) <= 1 ->
 finite (Float32.add x y) /\
 Rabs (r32 (Float32.add x y)) <= 16777216 /\
 Rabs (r32 (Float32.add x y) - (r32 x + r32 y)) <= u * Rabs (r32 x + r32 y) + eta /\
 Rabs (r32 (Float32.add x y)) <= Rabs (r32 x) + 3.
Proof.
 intros x y Fx Fy Hx Hy.
 assert (Hsum : Rabs (r32 x + r32 y) <= 16777217).
 { eapply Rle_trans; [apply Rabs_triang|]; lra. }
 destruct (add_real_absorption_safe x y Fx Fy ltac:(lra)) as [F R].
 split; [exact F|]. rewrite R.
 split; [apply RN_bound_absorption; exact Hsum|].
 split; [apply RN_error|].
 pose proof (RN_error (r32 x+r32 y)) as E.
 assert (E2 : Rabs (RN (r32 x+r32 y) - (r32 x+r32 y)) <= 2).
 { rewrite u_value,eta_value in E. eapply Rle_trans; [exact E|]; lra. }
 replace (RN (r32 x + r32 y)) with
   ((RN (r32 x+r32 y) - (r32 x+r32 y)) + (r32 x+r32 y)) by ring.
 eapply Rle_trans; [apply Rabs_triang|].
 pose proof (Rabs_triang (r32 x) (r32 y)); lra.
Qed.
Lemma add_absorption_error_two : forall x y,
 finite x -> finite y -> Rabs (r32 x) <= 16777216 -> Rabs (r32 y) <= 1 ->
 Rabs (r32 (Float32.add x y) - (r32 x+r32 y)) <= 2.
Proof.
 intros x y Fx Fy Hx Hy.
 destruct (add_absorption x y Fx Fy Hx Hy) as [F [B [E G]]].
 pose proof (Rabs_triang (r32 x) (r32 y)) as T.
 rewrite u_value,eta_value in E; eapply Rle_trans; [exact E|]; lra.
Qed.
Print Assumptions RN_upper_endpoint.
Print Assumptions RN_lower_endpoint.
Print Assumptions add_absorption.
Print Assumptions add_absorption_error_two.
