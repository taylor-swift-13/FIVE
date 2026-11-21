From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From PidPositionTranslationCore Require Import ConditionalPure ConditionalAssignment.
From CoreCBMC Require Import ArithmeticTree.
Lemma conditional_tree_simple_context:forall ge e m from C,
 context from RV C ->forall a b,
 typeof a=typeof b ->
 (simple a=true ->pure_eq ge e m from a b) ->
 simple(C a)=true ->
 arithmetic_tree ge e m(C a) ->arithmetic_tree ge e m b ->
 arithmetic_tree ge e m(C b).
Proof.
 intros ge e m from C CT a b TY EQ SI TREE NEW.
 eapply arithmetic_context_congr;[exact CT|exact TY| |exact TREE|exact NEW].
 apply EQ;eapply simple_context_hole;[exact CT|exact SI].
Qed.
Lemma conditional_tree_context_congr:forall ge e m from to C,
 context from to C ->forall a b,
 typeof a=typeof b ->
 (simple a=true ->pure_eq ge e m from a b) ->
 to=RV ->forall v,conditional_value ge e m(C a)v ->
 arithmetic_tree ge e m(C a) ->arithmetic_tree ge e m b ->
 arithmetic_tree ge e m(C b).
Proof.
 intros ge e m from to C CT;pose proof CT as WHOLE;induction CT;
 intros a b TY EQ KIND v CV TREE NEW;try discriminate.
 all:try solve[exact NEW].
 all:try solve[
  inversion CV;subst;try discriminate;
  match goal with SI:simple ?whole=true|-_ =>
   exact(conditional_tree_simple_context ge e m _ _ WHOLE a b TY EQ SI TREE NEW)end].
 - inversion CV;subst;try discriminate.
   assert(SA:simple a=true)by(eapply simple_context_hole;[exact CT|exact H3]).
   exact(arithmetic_context_congr ge e m _ _ _ WHOLE a b TY(EQ SA)TREE NEW).
 - inversion CV;subst;try discriminate;cbn[arithmetic_tree]in *;eapply IHCT;eauto.
Qed.
Lemma arithmetic_rred_type:forall ge a m t ar mf,
 rred ge a m t ar mf ->typeof a=typeof ar.
Proof. intros;inversion H;subst;cbn[typeof];auto. Qed.
Lemma conditional_tree_estep:forall ge e m f a k t next v,
 conditional_value ge e m a v ->arithmetic_tree ge e m a ->
 Csem.estep ge(ExprState f a k e m)t next ->
 exists ar,next=ExprState f ar k e m /\arithmetic_tree ge e m ar.
Proof.
 intros ge e m f a k t next v CV TREE STEP.
 destruct(conditional_estep ge e m f a k t next v CV STEP)as[ar[EQ[TT[TY VR]]]].
 exists ar;split;[exact EQ|];subst next;inversion STEP;subst.
 - lazymatch goal with LR:lred ge e ?sub m ?sub' ?mm,CT:Csem.context LV RV ?C|-_ =>
   destruct(pure_lred ge e sub m sub' mm LR)as[MM[TYPE[SI DEN]]];
   eapply conditional_tree_context_congr;[exact CT|symmetry;exact TYPE| |reflexivity|exact CV|exact TREE|];
   [intros _;exact DEN|eapply arithmetic_lred;exact LR]end.
 - lazymatch goal with RR:rred ge ?sub m ?tr ?sub' m,CT:Csem.context RV RV ?C|-_ =>
   pose proof(arithmetic_context_hole ge e m _ _ _ CT sub TREE)as HEAD;
   eapply conditional_tree_context_congr;[exact CT| | |reflexivity|exact CV|exact TREE|];
   [eapply arithmetic_rred_type;exact RR|
    intros SI;destruct(pure_rred ge e sub m tr sub' m SI RR)as[_[_[_[_ DEN]]]];exact DEN|
    eapply arithmetic_rred;[exact HEAD|exact RR]]end.
Qed.
Print Assumptions conditional_tree_estep.
