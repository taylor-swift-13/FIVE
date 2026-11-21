From Stdlib Require Import ZArith Reals Lia Lra Psatz.
From compcert Require Import Integers Floats.
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
