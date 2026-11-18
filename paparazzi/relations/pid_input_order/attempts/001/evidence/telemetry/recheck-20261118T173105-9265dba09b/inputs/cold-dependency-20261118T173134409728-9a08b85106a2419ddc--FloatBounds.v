From Stdlib Require Import ZArith Reals Lia.
From compcert Require Import Integers Floats IEEE754_extra.
From PidPositionTranslationAttempt002 Require Import ClampSemantics.
From CoreCBMC Require Import NumericBounds.
Open Scope Z_scope.
Local Transparent Float.of_int Float.cmp Float.compare.
Lemma double_signed_integer_exact:forall n,
 Binary.B2R 53 1024(Float.of_int n)=IZR(Int.signed n) /\
 Binary.is_finite 53 1024(Float.of_int n)=true.
Proof.
 intro n;unfold Float.of_int.
 assert(RANGE:-9007199254740992<=Int.signed n<=9007199254740992).
 { pose proof(Int.signed_range n);change(-2147483648<=Int.signed n<=2147483647)in H;lia. }
 destruct(BofZ_exact 53 1024 eq_refl eq_refl(Int.signed n)RANGE)as[R[F S]];auto.
Qed.
Lemma double_integer_clt:forall a b,
 Float.cmp Clt(Float.of_int a)(Float.of_int b)=true <->Int.signed a<Int.signed b.
Proof.
 intros a b;destruct(double_signed_integer_exact a)as[RA FA];destruct(double_signed_integer_exact b)as[RB FB].
 unfold Float.cmp,Float.compare;rewrite(Binary.Bcompare_correct _ _ _ _ FA FB),RA,RB,Raux.Rcompare_IZR.
 destruct(Z.compare(Int.signed a)(Int.signed b))eqn:C;cbn[cmp_of_comparison].
 - apply Z.compare_eq_iff in C;split;[discriminate|lia].
 - apply Z.compare_lt_iff in C;split;auto.
 - apply Z.compare_gt_iff in C;split;[discriminate|lia].
Qed.
Lemma double_integer_cgt:forall a b,
 Float.cmp Cgt(Float.of_int a)(Float.of_int b)=true <->Int.signed b<Int.signed a.
Proof.
 intros a b;change(Float.cmp(swap_comparison Clt)(Float.of_int a)(Float.of_int b)=true <->Int.signed b<Int.signed a).
 rewrite Float.cmp_swap;apply double_integer_clt.
Qed.
Lemma original_front_clamp_bound:forall n bound,
 0<=bound<=2147483647 ->
 int_bound(clamp_bits n(Int.repr bound))bound.
Proof.
 intros n bound B;unfold clamp_bits,int_bound.
 assert(SP:Int.signed(Int.repr bound)=bound)by(apply Int.signed_repr;change(-2147483648<=bound<=2147483647);lia).
 assert(SN:Int.signed(Int.neg(Int.repr bound))= -bound).
 { rewrite Int.neg_repr,Int.signed_repr;[reflexivity|change(-2147483648<= -bound<=2147483647);lia]. }
 destruct(Float.cmp Clt(Float.of_int n)(Float.of_int(Int.neg(Int.repr bound))))eqn:LOW.
 - rewrite SN;lia.
 - destruct(Float.cmp Cgt(Float.of_int n)(Float.of_int(Int.repr bound)))eqn:HIGH.
   + rewrite SP;lia.
   + assert(LO:-bound<=Int.signed n).
     { destruct(Z_lt_ge_dec(Int.signed n)(-bound));[|lia].
       assert(E:Float.cmp Clt(Float.of_int n)(Float.of_int(Int.neg(Int.repr bound)))=true).
       { apply double_integer_clt;rewrite SN;assumption. } congruence. }
     assert(HI:Int.signed n<=bound).
     { destruct(Z_lt_ge_dec bound(Int.signed n));[|lia].
       assert(E:Float.cmp Cgt(Float.of_int n)(Float.of_int(Int.repr bound))=true).
       { apply double_integer_cgt;rewrite SP;assumption. } congruence. }
     lia.
Qed.
Print Assumptions original_front_clamp_bound.
