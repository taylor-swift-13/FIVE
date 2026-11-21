From Stdlib Require Import List ZArith Lia Reals Lra Psatz.
From compcert Require Import Integers Floats Values IEEE754_extra.
From Flocq Require Import Core.Core IEEE754.Binary.
From FiveMatrixInverseSupport Require Import Dyadic.
Require FiveInv2Case.Contract FiveMatInv3Case.Scalar.
Import ListNotations.
Local Open Scope Z_scope.
Module D2:=FiveInv2Case.Contract.
Module D3:=FiveMatInv3Case.Scalar.
Definition Diag2(x:float32)(i:Z):float32:=if (Z.eqb i 0||Z.eqb i 3)%bool then x else Float32.zero.
Definition Diag3(x:float32)(i:Z):float32:=if (Z.eqb i 0||Z.eqb i 4||Z.eqb i 8)%bool then x else Float32.zero.
Lemma det2_safe:forall k,-20<=k<=20 ->D2.Det(Diag2(power32 k))=power32(2*k).
Proof.
 intros k K;unfold D2.Det,Diag2;cbn.
 change (Float32.sub(Float32.mul(power32 k)(power32 k))Float32.zero=power32(2*k)).
 rewrite power_mul by lia;replace (k+k) with(2*k)by lia.
 destruct(power_zeros(2*k)ltac:(lia))as[_[_[S _]]];exact S.
Qed.
Lemma minors_safe:forall k,-20<=k<=20 ->
 D3.M00(Diag3(power32 k))=power32(2*k) /\
 D3.M10(Diag3(power32 k))=Float32.zero /\
 D3.M20(Diag3(power32 k))=Float32.zero /\
 D3.M01(Diag3(power32 k))=Float32.zero /\
 D3.M11(Diag3(power32 k))=power32(2*k) /\
 D3.M21(Diag3(power32 k))=Float32.zero /\
 D3.M02(Diag3(power32 k))=Float32.zero /\
 D3.M12(Diag3(power32 k))=Float32.zero /\
 D3.M22(Diag3(power32 k))=power32(2*k).
Proof.
 intros k K;destruct(power_zeros k ltac:(lia))as[MR[ML REST]].
 destruct(power_zeros(2*k)ltac:(lia))as[_[_[SZ _]]].
 repeat split;unfold D3.M00,D3.M10,D3.M20,D3.M01,D3.M11,D3.M21,D3.M02,D3.M12,D3.M22,Diag3;cbn;
 rewrite ?MR,?ML;try reflexivity;
 rewrite power_mul by lia;replace(k+k)with(2*k)by lia;exact SZ.
Qed.
Lemma det3_safe:forall k,-20<=k<=20 ->D3.Det(Diag3(power32 k))=power32(3*k).
Proof.
 intros k K;destruct(minors_safe k K)as[M00[M10[M20 REST]]].
 unfold D3.Det;rewrite M00,M10,M20;unfold Diag3;cbn.
 change(Float32.add(Float32.sub(Float32.mul(power32 k)(power32(2*k)))Float32.zero)Float32.zero=power32(3*k)).
 rewrite power_mul by lia;replace(k+2*k)with(3*k)by lia.
 destruct(power_zeros(3*k)ltac:(lia))as[_[_[SZ[AZ _]]]].
 rewrite SZ;exact AZ.
Qed.
Lemma output2_safe:forall k,-20<=k<=20 ->
 map(D2.Output(Diag2(power32 k)))[0;1;2;3]=
 [power32(-k);Float32.neg Float32.zero;Float32.neg Float32.zero;power32(-k)].
Proof.
 intros k K.
 change([Float32.div(power32 k)(D2.Det(Diag2(power32 k)));
 Float32.div(Float32.neg Float32.zero)(D2.Det(Diag2(power32 k)));
 Float32.div(Float32.neg Float32.zero)(D2.Det(Diag2(power32 k)));
 Float32.div(power32 k)(D2.Det(Diag2(power32 k)))]=
 [power32(-k);Float32.neg Float32.zero;Float32.neg Float32.zero;power32(-k)]).
 rewrite det2_safe by exact K.
 destruct(power_zeros(2*k)ltac:(lia))as[_[_[_[_[DZ[DN _]]]]]].
 rewrite DN;rewrite power_div by lia;replace(k-2*k)with(-k)by lia;reflexivity.
Qed.
Lemma output3_safe:forall k,-20<=k<=20 ->
 map(D3.Output(Diag3(power32 k)))[0;1;2;3;4;5;6;7;8]=
 [power32(-k);Float32.neg Float32.zero;Float32.zero;
 Float32.neg Float32.zero;power32(-k);Float32.neg Float32.zero;
 Float32.zero;Float32.neg Float32.zero;power32(-k)].
Proof.
 intros k K;destruct(minors_safe k K)as[M00[M10[M20[M01[M11[M21[M02[M12 M22]]]]]]]].
 unfold D3.Output;cbn[map];rewrite det3_safe by exact K.
 rewrite M00,M10,M20,M01,M11,M21,M02,M12,M22.
 destruct(power_zeros(3*k)ltac:(lia))as[_[_[_[_[DZ[DN _]]]]]].
 rewrite DZ,DN;rewrite power_div by lia;replace(2*k-3*k)with(-k)by lia;reflexivity.
Qed.

Definition one:float32:=Float32.of_bits(Int.repr 1065353216).
Definition small:float32:=Float32.of_bits(Int.repr 998244352).
Definition big2:float32:=Float32.of_bits(Int.repr 1904214016).
Definition big3:float32:=Float32.of_bits(Int.repr 1484783616).
Definition base2:=Diag2 one.
Definition small2:=Diag2 small.
Definition large2:=Diag2 big2.
Definition base3:=Diag3 one.
Definition small3:=Diag3 small.
Definition large3:=Diag3 big3.
Definition words2(f:Z->float32):list int:=map(fun i=>Float32.to_bits(D2.Output f i))[0;1;2;3].
Definition words3(f:Z->float32):list int:=map(fun i=>Float32.to_bits(D3.Output f i))[0;1;2;3;4;5;6;7;8].
Lemma base2_kernel:D2.Result base2=Vint Int.zero /\
 Float32.to_bits(D2.Det base2)=Int.repr 1065353216 /\
 words2 base2=map Int.repr[1065353216;2147483648;2147483648;1065353216].
Proof. vm_compute;repeat split;reflexivity. Qed.
Lemma small2_kernel:D2.Result small2=Vint Int.one /\
 Float32.to_bits(D2.Det small2)=Int.repr 931135488.
Proof. vm_compute;split;reflexivity. Qed.
Lemma large2_kernel:D2.Result large2=Vint Int.zero /\
 Float32.to_bits(D2.Det large2)=Int.repr 2139095040 /\
 words2 large2=map Int.repr[0;2147483648;2147483648;0].
Proof. vm_compute;repeat split;reflexivity. Qed.
Lemma base3_kernel:D3.Status base3=Vint Int.zero /\
 Float32.to_bits(D3.Det base3)=Int.repr 1065353216 /\
 words3 base3=map Int.repr[1065353216;2147483648;0;2147483648;1065353216;2147483648;0;2147483648;1065353216].
Proof. vm_compute;repeat split;reflexivity. Qed.
Lemma small3_kernel:D3.Status small3=Vint Int.one /\
 Float32.to_bits(D3.Det small3)=Int.repr 864026624.
Proof. vm_compute;split;reflexivity. Qed.
Lemma large3_kernel:D3.Status large3=Vint Int.zero /\
 Float32.to_bits(D3.Det large3)=Int.repr 2139095040 /\
 words3 large3=map Int.repr[0;2147483648;0;2147483648;0;2147483648;0;2147483648;0].
Proof. vm_compute;repeat split;reflexivity. Qed.
Definition residual2(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(D2.Output f 0))one.
Definition residual3(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(D3.Output f 0))one.
Lemma large2_residual:Float32.to_bits(residual2 large2)=Int.repr 3212836864.
Proof. vm_compute;reflexivity. Qed.
Lemma large3_residual:Float32.to_bits(residual3 large3)=Int.repr 3212836864.
Proof. vm_compute;reflexivity. Qed.
Lemma RefuteScaleStatus2:D2.Result base2<>D2.Result small2.
Proof. vm_compute;discriminate. Qed.
Lemma RefuteScaleStatus3:D3.Status base3<>D3.Status small3.
Proof. vm_compute;discriminate. Qed.
Definition SmallResidual(r:float32):bool:=
 (Float32.cmp Cgt r(Float32.of_bits(Int.repr 3204448256)) &&
 Float32.cmp Clt r(Float32.of_bits(Int.repr 1056964608)))%bool.
Lemma RefuteLargeResidual2:D2.Result large2=Vint Int.zero /\SmallResidual(residual2 large2)=false.
Proof. vm_compute;split;reflexivity. Qed.
Lemma RefuteLargeResidual3:D3.Status large3=Vint Int.zero /\SmallResidual(residual3 large3)=false.
Proof. vm_compute;split;reflexivity. Qed.
Print Assumptions base2_kernel.
Print Assumptions small2_kernel.
Print Assumptions large2_kernel.
Print Assumptions base3_kernel.
Print Assumptions small3_kernel.
Print Assumptions large3_kernel.
