From Stdlib Require Import Bool List ZArith Lia Arith Wellfounded.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From PprzTrigRelationSupport Require Import PlainCore BranchPure PureEval PureProgress Total.
From PprzTrigCBMC Require Import TypedGuards SourceObservations Cutpoint.
Local Open Scope Z_scope.
Definition binary_math_guard(op:binary_operation)(v w:val):Prop:=
 match v,w with Vint i,Vint j=>match op with
 |Oadd=>signed32(Int.signed i+Int.signed j)
 |Osub=>signed32(Int.signed i-Int.signed j)
 |Oshl=>0<=Int.signed i /\0<=Int.signed j<32 /\signed32(Int.signed i*2^Int.signed j)
 |_=>True end|_,_=>True end.
Definition unary_math_guard(op:unary_operation)(v:val):Prop:=
 match op,v with Oneg,Vint i=>signed32(-Int.signed i)|_,_=>True end.
Fixpoint math_guarded(ge:Csem.genv)(e:env)(m:mem)(a:expr):Prop:=
 match a with
 |Eval _ _|Eloc _ _ _ _|Evar _ _|Esizeof _ _|Ealignof _ _=>True
 |Evalof a _|Ederef a _|Eaddrof a _|Ecast a _|Efield a _ _|Eparen a _ _=>math_guarded ge e m a
 |Eunop op a _=>math_guarded ge e m a /\forall v,branch_rval ge e m a=Some v->unary_math_guard op v
 |Ebinop op a b _=>math_guarded ge e m a /\math_guarded ge e m b /\
   forall v w,branch_rval ge e m a=Some v->branch_rval ge e m b=Some w->binary_math_guard op v w
 |Econdition a b c _=>math_guarded ge e m a /\math_guarded ge e m b /\math_guarded ge e m c
 |_=>True end.
Lemma math_context_hole : forall from to C,Csem.context from to C->forall ge e m a,
 branch_simple(C a)=true->math_guarded ge e m(C a)->math_guarded ge e m a.
Proof.
 induction 1;simpl;intros ge e m a S G;try exact G;core_unpack;try discriminate;
 try(eapply IHcontext;eauto);intuition eauto.
Qed.
Lemma math_context_replace : forall from to C,Csem.context from to C->forall ge e m a b,
 branch_simple(C a)=true->math_guarded ge e m(C a)->typeof a=typeof b ->
 branch_eq ge e m from a b ->math_guarded ge e m b ->math_guarded ge e m(C b).
Proof.
 induction 1;intros ge e m a b S G TY EV GB;try exact GB;
 cbn[math_guarded]in G|-*;cbn[branch_simple]in S;core_unpack;try discriminate.
 all:try(eapply IHcontext;eauto).
 all:try match goal with
 |H:math_guarded _ _ _ _ /\_ |- _=>destruct H end.
 all:try match goal with
 |H:math_guarded _ _ _ _ /\_ |- _=>destruct H end.
 all:try match goal with
 |H:math_guarded _ _ _ _ /\_ |- _=>destruct H end.
 all:repeat split;try assumption;try(eapply IHcontext;eauto).
 all:intros.
 all:repeat match goal with
 |EV0:branch_eq ?gg ?ee ?mm ?fr ?aa ?bb,TY0:typeof ?aa=typeof ?bb,
 HC:Csem.context ?fr RV ?Ctx,H:branch_rval ?gg ?ee ?mm(?Ctx ?bb)=Some ?vv|-_=>
   rewrite<-(branch_context_congr gg ee mm fr RV Ctx HC aa bb TY0 EV0)in H
 end.
 all:eauto.
Qed.
