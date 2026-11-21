From Stdlib Require Import List ZArith Reals.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From Flocq Require Import Core.Core.
From FiveMatrixInverseSupport Require Import Dyadic Kernels Threshold RealMatrix Numerical.
Require FivePprzFloatMatInv2d.Execution FivePprzFloatMatInv3d.Execution FiveMatInv3Case.Contract FiveInv2Functional.Spec FiveMatInv3Functional.Spec.
Import ListNotations.
Local Open Scope R_scope.
Module E2:=FivePprzFloatMatInv2d.Execution.
Module E3:=FivePprzFloatMatInv3d.Execution.
Module C3:=FiveMatInv3Case.Contract.
Module F2:=FiveInv2Functional.Spec.
Module F3:=FiveMatInv3Functional.Spec.
Definition Actual2:Prop:=F2.NormalCall /\F2.AllReturns.
Definition Actual3:Prop:=F3.NormalCall /\F3.AllNormalObservations.
Definition Legal2(f:Z->float32)(wanted:val):Prop:=exists m bo bi mf t,
 D2.Inputs m bo bi Ptrofs.zero Ptrofs.zero f /\
 star Csem.step E2.ge(E2.entry(D2.Args bo bi Ptrofs.zero Ptrofs.zero)m)t(Returnstate wanted Kstop mf) /\
 D2.Post m mf bo bi Ptrofs.zero Ptrofs.zero f.
Definition Legal3(f:Z->float32)(wanted:val):Prop:=exists m bo bi mf t,
 bo<>bi /\FiveMatInv3Case.MatrixMemory.WriteRegion m bo Ptrofs.zero 9 /\FiveMatInv3Case.MatrixMemory.Reads m bi Ptrofs.zero 9 f /\
 star Csem.step E3.ge(E3.entry(C3.Args bo bi Ptrofs.zero Ptrofs.zero)m)t(Returnstate wanted Kstop mf) /\
 F3.Post m mf bo bi Ptrofs.zero Ptrofs.zero f.
Definition SafeFamily2:Prop:=Actual2 /\forall k,(-20<=k<=20)%Z->
 D2.Reject(Diag2(power32 k))=Z.ltb k(-6) /\
 map(D2.Output(Diag2(power32 k)))[0%Z;1%Z;2%Z;3%Z]=[power32(-k);Float32.neg Float32.zero;Float32.neg Float32.zero;power32(-k)] /\
 (Inverts2(Lift2(Diag2(power32 k)))(RDiag(/bpow radix2 k)) /\
 Norm2(Lift2(Diag2(power32 k)))*Norm2(RDiag(/bpow radix2 k))=1 /\
 Residual2(Lift2(Diag2(power32 k)))(Computed2(Diag2(power32 k)))=0) /\
 (forall i,finite32(Diag2(power32 k)i)).
Definition SafeFamily3:Prop:=Actual3 /\forall k,(-20<=k<=20)%Z->
 D3.Accept(Diag3(power32 k))=Z.leb(-7)k /\
 map(D3.Output(Diag3(power32 k)))[0%Z;1%Z;2%Z;3%Z;4%Z;5%Z;6%Z;7%Z;8%Z]=
 [power32(-k);Float32.neg Float32.zero;Float32.zero;Float32.neg Float32.zero;power32(-k);Float32.neg Float32.zero;Float32.zero;Float32.neg Float32.zero;power32(-k)] /\
 (Inverts3(Lift3(Diag3(power32 k)))(RDiag(/bpow radix2 k)) /\
 Norm3(Lift3(Diag3(power32 k)))*Norm3(RDiag(/bpow radix2 k))=1 /\
 Residual3(Lift3(Diag3(power32 k)))(Computed3(Diag3(power32 k)))=0) /\
 (forall i,finite32(Diag3(power32 k)i)).
Definition ScaleRefuted2:Prop:=Actual2 /\
 (forall i,finite32(base2 i) /\finite32(small2 i)) /\
 (ConditionOne2 base2 /\ConditionOne2 small2) /\
 0< /256 /\EqN 2(Lift2 small2)(fun i j=>(/256)*Lift2 base2 i j) /\
 D2.Result base2=Vint Int.zero /\D2.Result small2=Vint Int.one /\
 Legal2 base2(Vint Int.zero) /\Legal2 small2(Vint Int.one).
Definition OverflowRefuted2:Prop:=Actual2 /\
 (forall i,finite32(large2 i)) /\ConditionOne2 large2 /\
 D2.Result large2=Vint Int.zero /\Float32.to_bits(D2.Det large2)=Int.repr 2139095040 /\
 words2 large2=map Int.repr [0%Z;2147483648%Z;2147483648%Z;0%Z] /\
 Residual2(Lift2 large2)(Computed2 large2)=1 /\Legal2 large2(Vint Int.zero).
Definition ScaleRefuted3:Prop:=Actual3 /\
 (forall i,finite32(base3 i) /\finite32(small3 i)) /\
 (ConditionOne3 base3 /\ConditionOne3 small3) /\
 0< /256 /\EqN 3(Lift3 small3)(fun i j=>(/256)*Lift3 base3 i j) /\
 D3.Status base3=Vint Int.zero /\D3.Status small3=Vint Int.one /\
 Legal3 base3(Vint Int.zero) /\Legal3 small3(Vint Int.one).
Definition OverflowRefuted3:Prop:=Actual3 /\
 (forall i,finite32(large3 i)) /\ConditionOne3 large3 /\
 D3.Status large3=Vint Int.zero /\Float32.to_bits(D3.Det large3)=Int.repr 2139095040 /\
 words3 large3=map Int.repr [0%Z;2147483648%Z;0%Z;2147483648%Z;0%Z;2147483648%Z;0%Z;2147483648%Z;0%Z] /\
 Residual3(Lift3 large3)(Computed3 large3)=1 /\Legal3 large3(Vint Int.zero).
