From Stdlib Require Import ZArith Bool Reals Psatz Lia.
From compcert Require Import Integers Floats IEEE754_extra.
Open Scope Z_scope.
Local Transparent Float32.cmp Float32.compare Float32.of_int Float32.mul Float32.to_int.
Lemma single_between_finite : forall lo h hi,
 Binary.is_finite 24 128 lo=true ->
 Binary.is_finite 24 128 hi=true ->
 Float32.cmp Cle lo h=true ->Float32.cmp Cle h hi=true ->
 Binary.is_finite 24 128 h=true.
Proof.
 intros lo h hi LF HF LO HI;destruct h;try reflexivity.
 all:unfold Float32.cmp,Float32.compare in LO,HI.
 all:destruct lo;cbn[Binary.is_finite]in LF;try discriminate;
     destruct hi;cbn[Binary.is_finite]in HF;try discriminate.
 all:repeat match goal with b:bool|-_=>destruct b end;
     cbn[Binary.Bcompare cmp_of_comparison]in LO,HI;discriminate.
Qed.
Lemma single_cle_real : forall a b,
 Binary.is_finite 24 128 a=true ->Binary.is_finite 24 128 b=true ->
 Float32.cmp Cle a b=true ->
 (Binary.B2R 24 128 a<=Binary.B2R 24 128 b)%R.
Proof.
 intros a b AF BF LE;unfold Float32.cmp,Float32.compare in LE.
 rewrite(Binary.Bcompare_correct _ _ _ _ AF BF)in LE.
 apply Raux.Rcompare_not_Gt_inv;intro EQ;rewrite EQ in LE;discriminate.
Qed.
Lemma single_small_integer_exact : forall n,
 -16777216<=n<=16777216 ->
 Binary.B2R 24 128(Float32.of_int(Int.repr n))=IZR n /\
 Binary.is_finite 24 128(Float32.of_int(Int.repr n))=true.
Proof.
 intros n RANGE;unfold Float32.of_int;rewrite Int.signed_repr
 by(change(-2147483648<=n<=2147483647);lia).
 destruct(BofZ_exact 24 128 eq_refl eq_refl n RANGE)as[REAL[FINITE SIGN]];auto.
Qed.
Lemma heading_real_bounds : forall h,
 Float32.cmp Cle(Float32.of_int(Int.repr(-3)))h=true ->
 Float32.cmp Cle h(Float32.of_int(Int.repr 3))=true ->
 Binary.is_finite 24 128 h=true /\(-3<=Binary.B2R 24 128 h<=3)%R.
Proof.
 intros h LO HI.
 destruct(single_small_integer_exact(-3)ltac:(lia))as[LREAL LF].
 destruct(single_small_integer_exact 3 ltac:(lia))as[HREAL HF].
 pose proof(single_between_finite _ h _ LF HF LO HI)as FIN.
 split;[exact FIN|].
 pose proof(single_cle_real _ _ LF FIN LO)as L.
 pose proof(single_cle_real _ _ FIN HF HI)as H.
 rewrite LREAL in L;rewrite HREAL in H;split;lra.
Qed.

Definition single_round(x:R):R :=
 Generic_fmt.round Zaux.radix2(SpecFloat.fexp 24 128)
 (BinarySingleNaN.round_mode BinarySingleNaN.mode_NE)x.
Lemma single_round_mono : forall x y,(x<=y)%R ->(single_round x<=single_round y)%R.
Proof.
 intros x y LE;apply Generic_fmt.round_le.
 - apply Binary.fexp_correct;reflexivity.
 - apply BinarySingleNaN.valid_rnd_round_mode.
 - exact LE.
Qed.
Lemma single_small_integer_round : forall n,-16777216<=n<=16777216 ->
 single_round(IZR n)=IZR n.
Proof.
 intros n RANGE;apply Generic_fmt.round_generic.
 - apply BinarySingleNaN.valid_rnd_round_mode.
 - exact(proj2(IEEE754_extra.integer_representable_n 24 128 eq_refl eq_refl n RANGE)).
Qed.

Theorem heading_angle_cast_defined : forall h,
 Float32.cmp Cle(Float32.of_int(Int.repr(-3)))h=true ->
 Float32.cmp Cle h(Float32.of_int(Int.repr 3))=true ->
 exists heading,
 Float32.to_int(Float32.mul h(Float32.of_int(Int.repr 4096)))=Some heading /\
 -12288<=Int.signed heading<=12288.
Proof.
 intros h LO HI.
 destruct(heading_real_bounds h LO HI)as[HF[HL HH]].
 destruct(single_small_integer_exact 4096 ltac:(lia))as[KR KF].
 set(k:=Float32.of_int(Int.repr 4096))in *.
 set(raw:=(Binary.B2R 24 128 h*Binary.B2R 24 128 k)%R).
 assert(RAW:(IZR(-12288)<=raw<=IZR 12288)%R)by(unfold raw;rewrite KR;nra).
 assert(ROUND:(IZR(-12288)<=single_round raw<=IZR 12288)%R).
 { split.
   - pose proof(single_round_mono _ _(proj1 RAW))as L.
     rewrite(single_small_integer_round(-12288)ltac:(lia))in L;exact L.
   - pose proof(single_round_mono _ _(proj2 RAW))as H.
     rewrite(single_small_integer_round 12288 ltac:(lia))in H;exact H. }
 assert(ABS:(Rabs(single_round raw)<=12288)%R).
 { apply Rabs_le;split;lra. }
 assert(BIG:(12288<Raux.bpow Zaux.radix2 128)%R).
 { change(12288<340282366920938463463374607431768211456)%R;lra. }
 assert(NOOFLOW:Raux.Rlt_bool(Rabs(single_round raw))(Raux.bpow Zaux.radix2 128)=true).
 { apply Raux.Rlt_bool_true;lra. }
 pose proof(Binary.Bmult_correct 24 128 eq_refl eq_refl Float32.binop_nan BinarySingleNaN.mode_NE h k)as MULT.
 lazymatch type of MULT with (if ?c then _ else _) =>
 assert(C:c=true)by exact NOOFLOW;rewrite C in MULT end.
 destruct MULT as[REAL[FINITE _]];rewrite HF,KF in FINITE;cbn in FINITE.
 set(p:=Float32.mul h k)in *.
 assert(PFINITE:Binary.is_finite 24 128 p=true)by exact FINITE.
 assert(PBOUND:(IZR(-12288)<=Binary.B2R 24 128 p<=IZR 12288)%R).
 { change(Binary.B2R 24 128 p=single_round raw)in REAL;rewrite REAL;exact ROUND. }
 set(z:=Raux.Ztrunc(Binary.B2R 24 128 p)).
 assert(ZBOUND:-12288<=z<=12288).
 { unfold z;pose proof(Raux.Ztrunc_le _ _(proj1 PBOUND))as L.
   pose proof(Raux.Ztrunc_le _ _(proj2 PBOUND))as H.
   rewrite Raux.Ztrunc_IZR in L,H;lia. }
 assert(LZ:(Int.min_signed<=?z)=true)by(apply Z.leb_le;change(-2147483648<=z);lia).
 assert(HZ:(z<=?Int.max_signed)=true)by(apply Z.leb_le;change(z<=2147483647);lia).
 exists(Int.repr z);split.
 - change(Float32.to_int p=Some(Int.repr z)).
   unfold Float32.to_int;rewrite ZofB_range_correct;fold z;rewrite PFINITE,LZ,HZ;reflexivity.
 - rewrite Int.signed_repr;[exact ZBOUND|change(-2147483648<=z<=2147483647);lia].
Qed.
Print Assumptions heading_angle_cast_defined.
