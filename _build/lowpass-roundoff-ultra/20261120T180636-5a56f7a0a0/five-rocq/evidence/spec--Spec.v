From Stdlib Require Import List ZArith Reals.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
From Flocq Require Import IEEE754.Binary.
Require FiveLowpassUpdate.Execution FiveLowpassUpdateCase.Contract.
From FiveLowpassRoundoffSupport Require Import Recurrence.
Import ListNotations.
Local Open Scope R_scope.
Module U:=FiveLowpassUpdateCase.Contract.
Definition real32(f:float32):R:=B2R 24 128 f.
Definition finite32(f:float32):Prop:=is_finite 24 128 f=true.
Definition delta:R:=1/1048576.
Definition Admissible(c:float32)(x:nat->float32)(y0:float32):Prop:=
 finite32 c /\ 1<=real32 c<=2 /\
 finite32 y0 /\ Rabs(real32 y0)<=1 /\
 forall n,finite32(x n) /\ Rabs(real32(x n))<=1.
Fixpoint actual(c:float32)(x:nat->float32)(y0:float32)(n:nat):float32:=
 match n with O=>y0 | S k=>U.output c (x k)(actual c x y0 k)(x(S k)) end.
Definition ideal(c:float32)(x:nat->float32)(y0:float32)(n:nat):R:=
 reference(real32 c)(fun k=>real32(x k))(real32 y0)n.
Definition NumericInvariant:Prop:=forall c x y0,Admissible c x y0->
 forall n,finite32(actual c x y0 n) /\ Rabs(real32(actual c x y0 n))<=2.
Definition LocalRoundoff:Prop:=forall c x y0,Admissible c x y0->
 forall n,Rabs(real32(actual c x y0(S n))-
 reference_step(real32 c)(real32(x(S n)))(real32(x n))(real32(actual c x y0 n)))<=delta.
Definition ArbitraryHorizon:Prop:=forall c x y0,Admissible c x y0->
 forall n,Rabs(real32(actual c x y0 n)-ideal c x y0 n)<=envelope delta n /\
 Rabs(real32(actual c x y0 n)-ideal c x y0 n)<=1/524288.

Definition Call(b:block)(p:ptrofs)(input:float32)(m:mem)(t:trace)(r:val)(mf:mem):Prop:=
 star Csem.step FiveLowpassUpdate.Execution.ge
 (FiveLowpassUpdate.Execution.entry[Vptr b p;Vsingle input]m)t(Returnstate r Kstop mf).
Inductive Calls(b:block)(p:ptrofs)(x:nat->float32):nat->mem->mem->list val->Prop:=
 | calls_zero:forall m,Calls b p x O m m []
 | calls_succ:forall n m0 m1 m2 rs t r,
 Calls b p x n m0 m1 rs ->
 Call b p (x(S n)) m1 t r m2 ->
 Calls b p x (S n) m0 m2(rs++[r]).
Definition Returns(c:float32)(x:nat->float32)(y0:float32)(n:nat):list val:=
 map(fun k=>Vsingle(actual c x y0(S k)))(seq O n).
Definition Observed(c:float32)(x:nat->float32)(y0:float32)(n:nat)
 (b:block)(p:ptrofs)(m0 mf:mem):Prop:=
 U.Initialized mf b p c (x n)(actual c x y0 n) /\
 Mem.loadbytes mf b(Ptrofs.unsigned p)4=Mem.loadbytes m0 b(Ptrofs.unsigned p)4 /\
 U.Frame m0 mf b p /\
 ((0<n)%nat->
 Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle(x n))) /\
 Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle(actual c x y0 n)))).
Definition ExecutionExists:Prop:=forall c x y0 m b p,
 Admissible c x y0->U.Initialized m b p c(x O)y0->
 forall n,exists mf,Calls b p x n m mf(Returns c x y0 n) /\
 Observed c x y0 n b p m mf.
Definition EveryExecution:Prop:=forall c x y0 m b p,
 Admissible c x y0->U.Initialized m b p c(x O)y0->
 forall n mf rs,Calls b p x n m mf rs->
 rs=Returns c x y0 n /\ Observed c x y0 n b p m mf /\
 Rabs(real32(actual c x y0 n)-ideal c x y0 n)<=envelope delta n /\
 finite32(actual c x y0 n) /\ Rabs(real32(actual c x y0 n))<=2.
Definition Nonvacuity:Prop:=
 (exists c x y0,Admissible c x y0) /\
 (forall c x y0,Admissible c x y0->exists m b p,U.Initialized m b p c(x O)y0).
