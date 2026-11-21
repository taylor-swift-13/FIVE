From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation PhaseComposition.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationCore Require Import ConditionalStrategy.
From CoreCBMC Require Import ArithmeticTree ArithmeticPhases ArithmeticIf.
Inductive annotated_execution(ge:genv)(e:env):statement->mem->mem->Prop:=
| ax_skip:forall m,annotated_execution ge e Sskip m m
| ax_atomic:forall a m mf,
 atomic_expr a=true ->exec_stmt ge e m(Sdo a)E0 mf Out_normal ->
 arithmetic_tree ge e m a ->annotated_execution ge e(Sdo a)m mf
| ax_assignment:forall l r ty m mf,
 source_simple l=true ->conditional_shape r=true ->typeof l=ty ->nv ty=true ->
 exec_stmt ge e m(Sdo(Eassign l r ty))E0 mf Out_normal ->
 arithmetic_tree ge e m(Eassign l r ty) ->
 annotated_execution ge e(Sdo(Eassign l r ty))m mf
| ax_sequence:forall a b m mid mf,
 annotated_execution ge e a m mid ->annotated_execution ge e b mid mf ->
 annotated_execution ge e(Ssequence a b)m mf
| ax_if:forall c yes no m mf value taken,
 simple c=true ->pure_rval ge e m c=Some value ->
 bool_val value(typeof c)m=Some taken ->arithmetic_tree ge e m c ->
 annotated_execution ge e(if taken then yes else no)m mf ->
 annotated_execution ge e(Sifthenelse c yes no)m mf.
Theorem annotated_execution_certificate:forall ge e st m mf,
 annotated_execution ge e st m mf ->forall f k,
 observed_certificate ge(annotated_state ge f)(State f st k e m)(State f Sskip k e mf).
Proof.
 intros ge e st m mf EX;induction EX;intros f k.
 - apply observed_singleton;split;reflexivity.
 - eapply observed_atomic_from_normal;eauto.
 - eapply observed_conditional_assignment_from_normal;eauto.
 - eapply observed_sequence;[split;reflexivity|split;reflexivity|apply IHEX1|apply IHEX2].
 - eapply observed_join.
   + exists(ArithmeticIf.invariant ge f e k m c yes no value taken);split.
     * apply ArithmeticIf.if_certificate;assumption.
     * split;[apply ArithmeticIf.initial|apply ArithmeticIf.observations].
   + apply IHEX.
Qed.
Print Assumptions annotated_execution_certificate.
