From Stdlib Require Import ZArith Reals Lia Lra Psatz.
From compcert Require Import Integers Floats IEEE754_extra.
From Flocq Require Import Core.Core IEEE754.Binary.
Local Open Scope Z_scope.
Lemma power_bound:forall k,-126<=k<=127 -> SpecFloat.bounded 24 128 8388608 (k-23)=true.
Proof.
 intros k H;unfold SpecFloat.bounded,SpecFloat.canonical_mantissa,SpecFloat.fexp,SpecFloat.emin.
 change (Z.eqb (Z.max (24+(k-23)-24) (-149)) (k-23) && Z.leb (k-23) 104 = true)%bool.
 rewrite Z.max_l by lia;apply andb_true_intro;split;[apply Z.eqb_eq|apply Z.leb_le];lia.
Qed.
Definition power32(k:Z):float32:=
 match Z_le_dec (-126) k,Z_le_dec k 127 with
 |left L,left U=>B754_finite 24 128 false 8388608 (k-23)(power_bound k (conj L U))
 |_,_=>Float32.zero end.
Definition real32(f:float32):R:=B2R 24 128 f.
Definition finite32(f:float32):Prop:=is_finite 24 128 f=true.
Lemma power_real:forall k,-126<=k<=127 ->real32(power32 k)=bpow radix2 k.
Proof.
 intros k H;unfold power32;destruct(Z_le_dec (-126) k);[|lia];destruct(Z_le_dec k 127);[|lia].
 unfold real32;cbn[B2R F2R];change (8388608*bpow radix2(k-23)=bpow radix2 k)%R.
 replace 8388608%R with (bpow radix2 23) by reflexivity.
 rewrite <- bpow_plus;f_equal;lia.
Qed.
Lemma power_finite:forall k,-126<=k<=127 ->finite32(power32 k).
Proof. intros k H;unfold finite32,power32;destruct(Z_le_dec (-126) k);[|lia];destruct(Z_le_dec k 127);[reflexivity|lia]. Qed.
Lemma power_positive:forall k,-126<=k<=127 ->(0<real32(power32 k))%R.
Proof. intros;rewrite power_real by assumption;apply bpow_gt_0. Qed.
Print Assumptions power_real.

Lemma strict_nonzero:forall f,finite32 f->real32 f<>0%R->is_finite_strict 24 128 f=true.
Proof. intros [s|s|s pl H|s m e H];cbn[finite32 real32 is_finite is_finite_strict B2R];intros;try discriminate;try contradiction;reflexivity. Qed.
Lemma power_format:forall k,-126<=k<=127 ->generic_format radix2(SpecFloat.fexp 24 128)(bpow radix2 k).
Proof. intros k H;apply generic_format_bpow;unfold SpecFloat.fexp,SpecFloat.emin;apply Z.max_lub;lia. Qed.
Lemma power_mul:forall a b,-126<=a<=127 ->-126<=b<=127 ->-126<=a+b<=127 ->
 Float32.mul(power32 a)(power32 b)=power32(a+b).
Proof.
 intros a b A B C.
 pose proof(Bmult_correct 24 128 eq_refl eq_refl Float32.binop_nan BinarySingleNaN.mode_NE (power32 a)(power32 b))as H.
 change (B2R 24 128 (power32 a)) with (real32(power32 a)) in H.
 change (B2R 24 128 (power32 b)) with (real32(power32 b)) in H.
 rewrite !power_real in H by assumption.
 rewrite <- bpow_plus in H.
 rewrite round_generic in H by (first [apply BinarySingleNaN.valid_rnd_round_mode|apply power_format;assumption]).
 rewrite Rabs_pos_eq in H by (apply Rlt_le;apply bpow_gt_0).
 rewrite Rlt_bool_true in H by (apply bpow_lt;lia).
 destruct H as[R[F SIGN]].
 change (real32(Float32.mul(power32 a)(power32 b))=bpow radix2(a+b)) in R.
 rewrite (power_finite a A),(power_finite b B) in F;cbn in F.
 change (finite32(Float32.mul(power32 a)(power32 b))) in F.
 apply B2R_inj.
 - apply strict_nonzero;[exact F|rewrite R;apply Rgt_not_eq;apply bpow_gt_0].
 - apply strict_nonzero;[apply power_finite;exact C|pose proof(power_positive(a+b)C);lra].
 - change (real32(Float32.mul(power32 a)(power32 b))=real32(power32(a+b))).
   rewrite R,power_real by assumption;reflexivity.
Qed.

Lemma power_div:forall a b,-126<=a<=127 ->-126<=b<=127 ->-126<=a-b<=127 ->
 Float32.div(power32 a)(power32 b)=power32(a-b).
Proof.
 intros a b A B C.
 assert(N:B2R 24 128(power32 b)<>0%R)by(change(real32(power32 b)<>0%R);pose proof(power_positive b B);lra).
 pose proof(Bdiv_correct 24 128 eq_refl eq_refl Float32.binop_nan BinarySingleNaN.mode_NE (power32 a)(power32 b) N)as H.
 change (B2R 24 128 (power32 a)) with (real32(power32 a)) in H.
 change (B2R 24 128 (power32 b)) with (real32(power32 b)) in H.
 rewrite !power_real in H by assumption.
 assert(E:(bpow radix2 a/bpow radix2 b=bpow radix2(a-b))%R).
 { unfold Rdiv;rewrite <- bpow_opp,<- bpow_plus;f_equal;lia. }
 rewrite E in H.
 rewrite round_generic in H by (first [apply BinarySingleNaN.valid_rnd_round_mode|apply power_format;assumption]).
 rewrite Rabs_pos_eq in H by (apply Rlt_le;apply bpow_gt_0).
 rewrite Rlt_bool_true in H by (apply bpow_lt;lia).
 destruct H as[R[F SIGN]].
 change (real32(Float32.div(power32 a)(power32 b))=bpow radix2(a-b)) in R.
 rewrite (power_finite a A) in F.
 change (finite32(Float32.div(power32 a)(power32 b))) in F.
 apply B2R_inj.
 - apply strict_nonzero;[exact F|rewrite R;apply Rgt_not_eq;apply bpow_gt_0].
 - apply strict_nonzero;[apply power_finite;exact C|pose proof(power_positive(a-b)C);lra].
 - change(real32(Float32.div(power32 a)(power32 b))=real32(power32(a-b))).
   rewrite R,power_real by assumption;reflexivity.
Qed.
Lemma power_zeros:forall k,-126<=k<=127 ->
 Float32.mul(power32 k)Float32.zero=Float32.zero /\
 Float32.mul Float32.zero(power32 k)=Float32.zero /\
 Float32.sub(power32 k)Float32.zero=power32 k /\
 Float32.add(power32 k)Float32.zero=power32 k /\
 Float32.div Float32.zero(power32 k)=Float32.zero /\
 Float32.div(Float32.neg Float32.zero)(power32 k)=Float32.neg Float32.zero /\
 Float32.abs(power32 k)=power32 k.
Proof.
 intros k H;unfold power32;destruct(Z_le_dec (-126) k);[|lia];destruct(Z_le_dec k 127);[|lia].
 repeat split;reflexivity.
Qed.
Lemma double_widen:forall f,finite32 f ->
 B2R 53 1024(Float.of_single f)=real32 f /\ is_finite 53 1024(Float.of_single f)=true.
Proof.
 intros f F;pose proof(Bconv_widen_exact 24 128 53 1024 eq_refl eq_refl eq_refl ltac:(lia) ltac:(lia) Float.of_single_nan BinarySingleNaN.mode_NE f F)as[R[FIN S]].
 split;assumption.
Qed.
Print Assumptions power_mul.
Print Assumptions power_div.
