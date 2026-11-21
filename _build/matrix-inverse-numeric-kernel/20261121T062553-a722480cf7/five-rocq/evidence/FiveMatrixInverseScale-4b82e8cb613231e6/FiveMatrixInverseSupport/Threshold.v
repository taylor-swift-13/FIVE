From Stdlib Require Import ZArith Reals Lia Lra Psatz.
From compcert Require Import Integers Floats Values.
From Flocq Require Import Core.Core IEEE754.Binary.
From FiveMatrixInverseSupport Require Import Dyadic Kernels.
Local Open Scope Z_scope.
Local Transparent Float.cmp Float.compare Float.abs.
Definition Threshold2:Floats.float:=Float.of_bits(Int64.repr 4547007122018943789).
Definition Epsilon:float32:=Float32.of_bits(Int.repr 872415232).
Lemma threshold2_finite:is_finite 53 1024 Threshold2=true.
Proof. vm_compute;reflexivity. Qed.
Lemma threshold2_bounds:
 (bpow radix2(-14)<B2R 53 1024 Threshold2 /\B2R 53 1024 Threshold2<bpow radix2(-12))%R.
Proof. change(/16384<7378697629483821/73786976294838206464 /\7378697629483821/73786976294838206464< /4096)%R;split;lra. Qed.
Lemma epsilon_finite:finite32 Epsilon.
Proof. vm_compute;reflexivity. Qed.
Lemma epsilon_real:real32 Epsilon=bpow radix2(-23).
Proof. change(8388608/70368744177664= /8388608)%R;field. Qed.
Lemma reject2_safe:forall k,-20<=k<=20 ->
 D2.Reject(Diag2(power32 k))=Z.ltb k(-6).
Proof.
 intros k K;unfold D2.Reject;rewrite det2_safe by exact K.
 destruct(power_zeros(2*k)ltac:(lia))as[_[_[_[_[_[_ ABS]]]]]];rewrite ABS.
 pose proof(double_widen(power32(2*k))(power_finite(2*k)ltac:(lia)))as[R F].
 change(Float.cmp Clt(Float.of_single(power32(2*k)))Threshold2=Z.ltb k(-6)).
 unfold Float.cmp,Float.compare.
 rewrite Bcompare_correct by assumption || exact threshold2_finite.
 rewrite R,power_real by lia.
 destruct threshold2_bounds as[LO HI].
 destruct(Z.ltb k(-6))eqn:E.
 - apply Z.ltb_lt in E;rewrite Rcompare_Lt;[reflexivity|].
   eapply Rle_lt_trans with(r2:=bpow radix2(-14));[apply bpow_le;lia|exact LO].
 - apply Z.ltb_ge in E;rewrite Rcompare_Gt;[reflexivity|].
   eapply Rlt_le_trans with(r2:=bpow radix2(-12));[exact HI|apply bpow_le;lia].
Qed.
Lemma accept3_safe:forall k,-20<=k<=20 ->
 D3.Accept(Diag3(power32 k))=Z.leb(-7)k.
Proof.
 intros k K;unfold D3.Accept;rewrite det3_safe by exact K.
 pose proof(double_widen(power32(3*k))(power_finite(3*k)ltac:(lia)))as[R F].
 pose proof(double_widen Epsilon epsilon_finite)as[RE FE].
 change(Float.cmp Cgt(Float.abs(Float.of_single(power32(3*k))))(Float.of_single Epsilon)=Z.leb(-7)k).
 unfold Float.cmp,Float.compare,Float.abs.
 rewrite Bcompare_correct by(first[rewrite is_finite_Babs;exact F|exact FE]).
 rewrite B2R_Babs,R,RE,epsilon_real,power_real by lia.
 rewrite Rabs_pos_eq by(apply Rlt_le;apply bpow_gt_0).
 destruct(Z.leb(-7)k)eqn:E.
 - apply Z.leb_le in E;rewrite Rcompare_Gt;[reflexivity|apply bpow_lt;lia].
 - apply Z.leb_gt in E;rewrite Rcompare_Lt;[reflexivity|apply bpow_lt;lia].
Qed.
Print Assumptions reject2_safe.
Print Assumptions accept3_safe.
