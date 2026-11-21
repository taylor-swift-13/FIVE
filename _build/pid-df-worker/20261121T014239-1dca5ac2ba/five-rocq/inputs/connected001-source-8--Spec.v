From Stdlib Require Import List ZArith Reals.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
Require FivePidDf.Execution FivePidDfCase.Contract.
From FivePidDfRoundoffSupport Require Export Sequence.
Import ListNotations.
Local Open Scope R_scope.
Module U:=FivePidDfCase.Contract.

Definition ExactArithmetic:Prop:=forall P H D x,x O=0->forall n,
 incremental(P+H+D)(-P+H-2*D)D x n=positional P H D x n.
Definition CoefficientPerturbation:Prop:=forall a b c A B C x,
 (forall k,Rabs(x k)<=1)->forall n,
 Rabs(incremental a b c x n-incremental A B C x n)<=INR n*Delta a b c A B C.
Definition NumericInvariant:Prop:=forall a b c x,Admissible a b c x->forall n,
 finite(actual a b c x n) /\ Rabs(r32(actual a b c x n))<=16777216 /\
 Rabs(r32(actual a b c x n))<=9*INR n.
Definition LocalRoundoff:Prop:=forall a b c x,Admissible a b c x->forall n,
 Rabs(r32(actual a b c x(S n))-
 (r32(actual a b c x n)+r32 a*r32(x(S n))+r32 b*r32(x n)+r32 c*previous(fun k=>r32(x k))n))
 <=32*u*(INR n+1).
Definition ArbitraryHorizon:Prop:=forall a b c x,Admissible a b c x->forall P H D n,
 Rabs(r32(actual a b c x n)-positional P H D(fun k=>r32(x k))n)<=
 /1048576*INR n*(INR n+1)+INR n*Delta(r32 a)(r32 b)(r32 c)(P+H+D)(-P+H-2*D)D.
Definition OriginalInitCoefficients:Prop:=forall Kp Kd Ki Ts x,
 r32 Ts<>0->
 Admissible(stored_a Kp Kd Ki Ts)(stored_b Kp Kd Ki Ts)(stored_c Kp Kd Ki Ts)x->
 forall n,Rabs(r32(actual(stored_a Kp Kd Ki Ts)(stored_b Kp Kd Ki Ts)(stored_c Kp Kd Ki Ts)x n)-
 positional(r32 Kp)(nominal_H Ki Ts)(nominal_D Kd Ts)(fun k=>r32(x k))n)<=
 /1048576*INR n*(INR n+1)+INR n*
 Delta(r32(stored_a Kp Kd Ki Ts))(r32(stored_b Kp Kd Ki Ts))(r32(stored_c Kp Kd Ki Ts))
 (r32 Kp+nominal_H Ki Ts+nominal_D Kd Ts)
 (-r32 Kp+nominal_H Ki Ts-2*nominal_D Kd Ts)(nominal_D Kd Ts).

Definition prev_actual(a b c:float32)(x:nat->float32)(n:nat):float32:=
 match n with O=>Float32.zero|S k=>actual a b c x k end.
Definition prev2(x:nat->float32)(n:nat):float32:=match n with O=>Float32.zero|S k=>prev32 x k end.
Definition Call(b:block)(p:ptrofs)(input:float32)(m:mem)(t:trace)(r:val)(mf:mem):Prop:=
 star Csem.step FivePidDf.Execution.ge
 (FivePidDf.Execution.entry[Vptr b p;Vsingle input]m)t(Returnstate r Kstop mf).
Inductive Calls(b:block)(p:ptrofs)(x:nat->float32):nat->mem->mem->list val->Prop:=
 |calls_zero:forall m,Calls b p x O m m []
 |calls_succ:forall n m0 m1 m2 rs t r,Calls b p x n m0 m1 rs->
 Call b p(x(S n))m1 t r m2->Calls b p x(S n)m0 m2(rs++[r]).
Definition Returns(a b c:float32)(x:nat->float32)(n:nat):list val:=
 map(fun k=>Vsingle(actual a b c x(S k)))(seq O n).
Definition Observed(a b c:float32)(x:nat->float32)(n:nat)(b0:block)(p:ptrofs)(m0 mf:mem):Prop:=
 U.Initialized mf b0 p a b c(actual a b c x n)(prev_actual a b c x n)(x n)(prev32 x n)(prev2 x n) /\
 U.Frame m0 mf b0 p /\ U.PreservesValid m0 mf /\
 ((0<n)%nat->U.WrittenBytes mf b0 p a b c(prev_actual a b c x n)(prev32 x n)(prev2 x n)(x n)).
Definition Initial(m:mem)(b0:block)(p:ptrofs)(a b c:float32):Prop:=
 U.Initialized m b0 p a b c Float32.zero Float32.zero Float32.zero Float32.zero Float32.zero.
Definition ExecutionExists:Prop:=forall a b c x,Admissible a b c x->
 forall m b0 p,Initial m b0 p a b c->forall n,exists mf,
 Calls b0 p x n m mf(Returns a b c x n) /\ Observed a b c x n b0 p m mf.
Definition EveryExecution:Prop:=forall a b c x,Admissible a b c x->
 forall m b0 p,Initial m b0 p a b c->forall n mf rs,
 Calls b0 p x n m mf rs->
 rs=Returns a b c x n /\ Observed a b c x n b0 p m mf /\
 finite(actual a b c x n) /\
 forall P H D,Rabs(r32(actual a b c x n)-positional P H D(fun k=>r32(x k))n)<=
 /1048576*INR n*(INR n+1)+INR n*Delta(r32 a)(r32 b)(r32 c)(P+H+D)(-P+H-2*D)D.
Definition Nonvacuity:Prop:=
 (exists a b c x,Admissible a b c x) /\
 (forall a b c,exists m b0 p,Initial m b0 p a b c).
