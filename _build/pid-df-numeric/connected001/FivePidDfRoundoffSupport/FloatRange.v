From Stdlib Require Import Reals ZArith Lia Lra Psatz.
From Flocq.Core Require Import Core.
From Flocq.IEEE754 Require Import Binary.
From compcert Require Import Floats.
From FiveLowpassRoundoffSupport Require Export FloatBounds.
Open Scope R_scope.
Local Instance prec24 : Prec_gt_0 24 := eq_refl.

Lemma RN_safe_large : forall x, Rabs x <= 8388608 ->
  Rlt_bool (Rabs (RN x)) (bpow radix2 128) = true.
Proof.
 intros x H;apply Rlt_bool_true.
 eapply Rle_lt_trans;[apply(RN_abs_bound_pow x 23);[lia|exact H]|].
 change 8388608 with (bpow radix2 23);apply bpow_lt;lia.
Qed.
Lemma add_real_large : forall x y, finite x -> finite y ->
 Rabs(r32 x+r32 y)<=8388608 ->
 finite(Float32.add x y) /\ r32(Float32.add x y)=RN(r32 x+r32 y).
Proof.
 intros x y Fx Fy Hxy.
 pose proof(Bplus_correct 24 128 eq_refl eq_refl Float32.binop_nan BinarySingleNaN.mode_NE x y Fx Fy)as H.
 pose proof(RN_safe_large _ Hxy)as Hb.
 unfold RN,r32 in Hb.
 change (FLT_exp (-149) 24)with(SpecFloat.fexp 24 128)in Hb.
 change ZnearestE with(BinarySingleNaN.round_mode BinarySingleNaN.mode_NE)in Hb.
 rewrite Hb in H;destruct H as[Hr[Hf Hs]];auto.
Qed.
Lemma RN_abs_le_one : forall x,Rabs x<=1->Rabs(RN x)<=1.
Proof. intros x H;change 1 with(bpow radix2 0);apply RN_abs_bound_pow;[lia|exact H]. Qed.
Lemma unit_product : forall a x,finite a->finite x->Rabs(r32 a)<=1->Rabs(r32 x)<=1->
 finite(Float32.mul a x) /\ Rabs(r32(Float32.mul a x))<=1 /\
 Rabs(r32(Float32.mul a x)-r32 a*r32 x)<=u+eta.
Proof.
 intros a x Fa Fx Ha Hx.
 assert(H:Rabs(r32 a*r32 x)<=1).
 { rewrite Rabs_mult;pose proof(Rabs_pos(r32 a));pose proof(Rabs_pos(r32 x));nra. }
 destruct(mul_finite_real a x Fa Fx ltac:(lra))as[F R].
 split;[exact F|];rewrite R;split;[apply RN_abs_le_one;exact H|].
 pose proof(RN_error(r32 a*r32 x));pose proof(bpow_gt_0 radix2 (-24));unfold u in *;nra.
Qed.
Lemma add_small_error : forall x y k,finite x->finite y->0<=k<=1048576->
 Rabs(r32 x+r32 y)<=4*k+4->
 finite(Float32.add x y) /\
 Rabs(r32(Float32.add x y)-(r32 x+r32 y))<=u*(4*k+4)+eta /\
 Rabs(r32(Float32.add x y)-(r32 x+r32 y))<=1/3.
Proof.
 intros x y k Fx Fy Hk Hxy.
 destruct(add_real_large x y Fx Fy ltac:(lra))as[F R].
 split;[exact F|];rewrite R;pose proof(RN_error(r32 x+r32 y))as E.
 rewrite u_value,eta_value in *.
 assert(E':Rabs(RN(r32 x+r32 y)-(r32 x+r32 y))<= /16777216*(4*k+4)+/1427247692705959881058285969449495136382746624)by nra.
 split;[exact E'|];eapply Rle_trans;[exact E'|];lra.
Qed.
