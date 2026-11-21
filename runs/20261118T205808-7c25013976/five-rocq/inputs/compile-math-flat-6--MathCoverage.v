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
 |Evalof a _|Ederef a _|Eaddrof a _|Ecast a _|Efield a _ _|Eparen a _ _|Epostincr _ a _=>math_guarded ge e m a
 |Eunop op a _=>math_guarded ge e m a /\forall v,branch_rval ge e m a=Some v->unary_math_guard op v
 |Ebinop op a b _=>math_guarded ge e m a /\math_guarded ge e m b /\
   forall v w,branch_rval ge e m a=Some v->branch_rval ge e m b=Some w->binary_math_guard op v w
 |Econdition a b c _=>math_guarded ge e m a /\math_guarded ge e m b /\math_guarded ge e m c
 |Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>math_guarded ge e m a /\math_guarded ge e m b
 |Ecall a args _=>math_guarded ge e m a /\math_guarded_list ge e m args
 |Ebuiltin _ _ args _=>math_guarded_list ge e m args end
with math_guarded_list(ge:Csem.genv)(e:env)(m:mem)(args:exprlist):Prop:=
 match args with Enil=>True|Econs a rest=>math_guarded ge e m a /\math_guarded_list ge e m rest end.
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

Lemma math_lred : forall ge e a m a' m',branch_simple a=true->math_guarded ge e m a->
 lred ge e a m a' m'->math_guarded ge e m' a'.
Proof. intros ge e a m a' m' S G H;inversion H;subst;cbn[math_guarded];exact I. Qed.
Lemma math_rred : forall ge e a m t a' m',branch_simple a=true->math_guarded ge e m a->
 rred ge a m t a' m'->math_guarded ge e m' a'.
Proof.
 intros ge e a m t a' m' S G H;inversion H;subst;cbn[branch_simple]in S;core_unpack;try discriminate;cbn[math_guarded]in G|-*;try exact I;try tauto.
 match goal with B:bool|-_=>destruct B;tauto end.
Qed.
Lemma math_estep : forall ge f a k e m t next,
 branch_simple a=true->math_guarded ge e m a->Csem.estep ge(ExprState f a k e m)t next->
 next=Stuckstate \/exists a',next=ExprState f a' k e m /\branch_simple a'=true /\math_guarded ge e m a'.
Proof.
 intros ge f a k e m t next SIMPLE MATH STEP;inversion STEP;subst.
 - match goal with LR:lred ge e ?A m ?A' ?M',HC:Csem.context LV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);
   assert(GA:math_guarded ge e m A)by(eapply math_context_hole;eauto);
   destruct(branch_lred ge e A m A' M' SA LR)as[HM[TY[SB EQ]]];subst M';
   right;exists(C A');split;[reflexivity|];split;
   [exact(branch_context_replace _ _ _ HC A A'(eq_sym TY)SIMPLE SB)|
    eapply math_context_replace;[exact HC|exact SIMPLE|exact MATH|symmetry;exact TY|exact EQ|exact(math_lred ge e A m A' m SA GA LR)]]end.
 - match goal with RR:rred ge ?A m t ?A' ?M',HC:Csem.context RV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);
   assert(GA:math_guarded ge e m A)by(eapply math_context_hole;eauto);
   destruct(branch_rred ge e A m t A' M' SA RR)as[HM[TT[TY[SB EQ]]]];subst M';
   right;exists(C A');split;[reflexivity|];split;
   [exact(branch_context_replace _ _ _ HC A A'(eq_sym TY)SIMPLE SB)|
    eapply math_context_replace;[exact HC|exact SIMPLE|exact MATH|symmetry;exact TY|exact EQ|exact(math_rred ge e A m t A' m SA GA RR)]]end.
 - match goal with CR:callred ge ?A _ _ _ _,HC:Csem.context RV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);inversion CR;subst;discriminate end.
 - left;reflexivity.
Qed.
Theorem math_every_expression_prefix : forall ge f k e m original v mf residual,
 source_observation ge e m original v ->math_guarded ge e m original ->
 expression_prefix ge f k e m original mf residual ->math_guarded ge e mf residual.
Proof.
 intros ge f k e m original v mf residual O G H;revert v O G.
 induction H;intros v O G;[exact G|].
 destruct(math_estep ge f a k e m t(ExprState f a1 k e m1)(proj1 O)G H)as[BAD|[b[EQ[S M]]]];[discriminate|].
 inversion EQ;subst b m1.
 pose proof(observation_all_orders ge f k e m a v m a1 O
 (expression_prefix_step ge f k e m a t m a1 m a1 H(expression_prefix_refl ge f k e m a1)))as[_[_O OO]].
 eapply IHexpression_prefix;[exact OO|exact M].
Qed.
Definition BinaryOperationOccurrence(a:expr)(op:binary_operation)(v w:val):Prop :=
 exists C tyv tyw ty,Csem.context RV RV C /\a=C(Ebinop op(Eval v tyv)(Eval w tyw)ty).
Definition UnaryOperationOccurrence(a:expr)(op:unary_operation)(v:val):Prop :=
 exists C tyv ty,Csem.context RV RV C /\a=C(Eunop op(Eval v tyv)ty).
Theorem every_prefix_binary_guard : forall ge f k e m original v mf residual op left right,
 source_observation ge e m original v ->math_guarded ge e m original ->
 expression_prefix ge f k e m original mf residual ->BinaryOperationOccurrence residual op left right ->
 binary_math_guard op left right.
Proof.
 intros ge f k e m original v mf residual op left right O G H[C[tl[tr[ty[CTX EQ]]]]];subst residual.
 pose proof(observation_all_orders _ _ _ _ _ _ _ _ _ O H)as[MM[TY[SS VAL]]].
 pose proof(math_every_expression_prefix _ _ _ _ _ _ _ _ _ O G H)as MG.
 pose proof(math_context_hole RV RV C CTX ge e mf(Ebinop op(Eval left tl)(Eval right tr)ty)SS MG)as[_[_GUARD GUARD]].
 exact(GUARD left right eq_refl eq_refl).
Qed.
Theorem every_prefix_unary_guard : forall ge f k e m original v mf residual op operand,
 source_observation ge e m original v ->math_guarded ge e m original ->
 expression_prefix ge f k e m original mf residual ->UnaryOperationOccurrence residual op operand ->
 unary_math_guard op operand.
Proof.
 intros ge f k e m original v mf residual op operand O G H[C[tl[ty[CTX EQ]]]];subst residual.
 pose proof(observation_all_orders _ _ _ _ _ _ _ _ _ O H)as[MM[TY[SS VAL]]].
 pose proof(math_every_expression_prefix _ _ _ _ _ _ _ _ _ O G H)as MG.
 pose proof(math_context_hole RV RV C CTX ge e mf(Eunop op(Eval operand tl)ty)SS MG)as[_ GUARD].
 exact(GUARD operand eq_refl).
Qed.
Scheme context_math_ind := Induction for Csem.context Sort Prop
with contextlist_math_ind := Induction for Csem.contextlist Sort Prop.
Combined Scheme context_math_mutind from context_math_ind,contextlist_math_ind.
Lemma general_math_context_hole :
 (forall fr to C,Csem.context fr to C->forall ge e m a,math_guarded ge e m(C a)->math_guarded ge e m a) /\
 (forall fr C,Csem.contextlist fr C->forall ge e m a,math_guarded_list ge e m(C a)->math_guarded ge e m a).
Proof. apply context_math_mutind;cbn[math_guarded math_guarded_list];intuition eauto. Qed.
Lemma general_math_context_replace :
 (forall fr to C,Csem.context fr to C->forall ge e m a b,math_guarded ge e m(C a)->
 typeof a=typeof b->branch_eq ge e m fr a b->math_guarded ge e m b->math_guarded ge e m(C b)) /\
 (forall fr C,Csem.contextlist fr C->forall ge e m a b,math_guarded_list ge e m(C a)->
 typeof a=typeof b->branch_eq ge e m fr a b->math_guarded ge e m b->math_guarded_list ge e m(C b)).
Proof.
 apply context_math_mutind;intros;cbn[math_guarded math_guarded_list]in *.
 all:repeat match goal with H:_/\_|-_=>destruct H end.
 all:repeat split;intros;try solve[eauto].
 all:repeat match goal with
 |EV0:branch_eq ?gg ?ee ?mm ?fr ?aa ?bb,TY0:typeof ?aa=typeof ?bb,
 HC:Csem.context ?fr RV ?Ctx,H:branch_rval ?gg ?ee ?mm(?Ctx ?bb)=Some ?vv|-_=>
   rewrite<-(branch_context_congr gg ee mm fr RV Ctx HC aa bb TY0 EV0)in H
 end.
 all:eauto.
Qed.
Print Assumptions every_prefix_binary_guard.

Definition branch_flat(a:expr):bool:=match a with Eassign l r _=>branch_simple l&&branch_simple r|_=>branch_simple a end.
Lemma branch_flat_of_simple : forall a,branch_simple a=true->branch_flat a=true.
Proof. destruct a;cbn[branch_simple branch_flat];intros;auto;discriminate. Qed.
Lemma branch_flat_context_hole : forall from to C,Csem.context from to C->forall a,
 branch_flat(C a)=true->branch_flat a=true.
Proof.
 induction 1;cbn[branch_flat branch_simple];intros a S;core_unpack;try discriminate;
 eauto using branch_flat_of_simple,branch_context_hole.
Qed.
Lemma branch_flat_context_assign_root : forall C,Csem.context RV RV C->forall l r ty,
 branch_flat(C(Eassign l r ty))=true->forall z,C z=z.
Proof.
 intros C HC l r ty S;inversion HC;subst;cbn[branch_flat branch_simple]in S;core_unpack;try discriminate;auto;
 exfalso;match goal with H:Csem.context _ _ ?C,P:branch_simple(?C(Eassign _ _ _))=true|-_=>
 pose proof(branch_context_hole _ _ _ H _ P);discriminate end.
Qed.
Lemma branch_flat_context_replace : forall from to C,Csem.context from to C->forall a b,
 branch_flat(C a)=true->typeof a=typeof b->branch_simple b=true->branch_flat(C b)=true.
Proof.
 induction 1;cbn[branch_flat branch_simple];intros a b S TY SB;core_unpack;try discriminate;
 try core_build;eauto using branch_flat_of_simple,branch_context_replace.
Qed.
Lemma math_flat_estep : forall ge f a k e m t next,
 branch_flat a=true->math_guarded ge e m a->Csem.estep ge(ExprState f a k e m)t next->
 next=Stuckstate \/exists a' m',next=ExprState f a' k e m' /\branch_flat a'=true /\math_guarded ge e m' a'.
Proof.
 intros ge f a k e m t next BF MG STEP;inversion STEP;subst.
 - match goal with LR:lred ge e ?A m ?A' ?M',HC:Csem.context LV RV ?C|-_=>
   assert(BA:branch_flat A=true)by(eapply branch_flat_context_hole;eauto);
   assert(SA:branch_simple A=true)by(inversion LR;subst;exact BA);
   assert(GA:math_guarded ge e m A)by(eapply(proj1 general_math_context_hole);eauto);
   destruct(branch_lred ge e A m A' M' SA LR)as[MM[TY[SB EQ]]];subst M';
   right;exists(C A'),m;split;[reflexivity|];split;
   [eapply branch_flat_context_replace;eauto;symmetry;exact TY|
    eapply(proj1 general_math_context_replace);[exact HC|exact MG|symmetry;exact TY|exact EQ|exact(math_lred ge e A m A' m SA GA LR)]]end.
 - match goal with RR:rred ge ?A m t ?A' ?M',HC:Csem.context RV RV ?C|-_=>
   assert(BA:branch_flat A=true)by(eapply branch_flat_context_hole;eauto);
   assert(GA:math_guarded ge e m A)by(eapply(proj1 general_math_context_hole);eauto);
   destruct A eqn:AA;try(assert(SA:branch_simple A=true)by(rewrite AA;exact BA));subst A end.
   all:try match goal with RR:rred ?GG ?AA ?MM ?TRACE ?AA' ?MM',SA:branch_simple ?AA=true,
    HC:Csem.context RV RV ?C,GM:math_guarded ?GG ?EE ?MM(?C ?AA),GA0:math_guarded ?GG ?EE ?MM ?AA|-_=>
    destruct(branch_rred GG EE AA MM TRACE AA' MM' SA RR)as[MEQ[TT[TY[SB EQ]]]];
    rewrite MEQ in RR|-*;
    right;exists(C AA'),MM;split;[reflexivity|];split;
    [eapply branch_flat_context_replace;eauto;symmetry;exact TY|
     eapply(proj1 general_math_context_replace);[exact HC|exact GM|symmetry;exact TY|exact EQ|exact(math_rred GG EE AA MM TRACE AA' MM SA GA0 RR)]]end.
   all:try match goal with RR:rred _ (Eassign _ _ _) _ _ _ _,HC:Csem.context RV RV ?C|-_=>
    assert(ID:forall z,C z=z)by(eapply branch_flat_context_assign_root;eauto);
    inversion RR;subst;right;repeat eexists;rewrite ID;cbn[branch_flat branch_simple math_guarded]in BA|-*;core_unpack;repeat split;auto end.

 - match goal with CR:callred ge ?A _ _ _ _,HC:Csem.context RV RV ?C|-_=>
   assert(BA:branch_flat A=true)by(eapply branch_flat_context_hole;eauto);inversion CR;subst;discriminate end.
 - left;reflexivity.
Qed.
