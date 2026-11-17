From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Errors Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PhaseComposition.
From PidPositionSafety Require Import PureSound.
From PidPositionTranslationCore Require Import ConditionalPure ConditionalAssignment.

Lemma source_simple_is_simple:forall a,source_simple a=true ->simple a=true.
Proof. induction a;cbn[source_simple simple];intros H;core_unpack;try discriminate;core_build;eauto. Qed.
Lemma conditional_simple_big:forall ge e m a v,
 eval_simple_rvalue ge e m a v ->source_simple a=true ->conditional_value ge e m a v.
Proof.
 intros ge e m a v EV SI;apply cv_simple;[apply source_simple_is_simple;exact SI|].
 apply(proj1(simple_big_denotation ge e m) a v EV);apply source_simple_is_simple;exact SI.
Qed.

Lemma strategy_simple_identity:forall ge e m kind a t mf af,
 eval_expr ge e m kind a t mf af ->source_simple a=true ->
 t=E0 /\mf=m /\af=a.
Proof.
 intros ge e m kind a t mf af EV;induction EV;intros SI;
 cbn[source_simple]in SI;core_unpack;try discriminate.
 all:try solve[repeat split;reflexivity].
 all:repeat lazymatch goal with IH:source_simple ?A=true ->_ /\_ /\_ |-_=>
   specialize(IH ltac:(assumption));destruct IH as[TT[MM AA]];subst end.
 all:try solve[repeat split;reflexivity].
 all:repeat lazymatch goal with NV:negb _=true|-_=>apply negb_true_iff in NV end;congruence.
Qed.

Fixpoint conditional_shape(a:expr):bool:=
 match a with
 | Econdition c yes no _=>source_simple c &&conditional_shape yes &&conditional_shape no
 | _=>source_simple a end.

Lemma strategy_conditional_value:forall a,conditional_shape a=true ->
 forall ge e m t mf af result,eval_expr ge e m RV a t mf af ->
 eval_simple_rvalue ge e mf af result ->
 t=E0 /\mf=m /\conditional_value ge e m a result.
Proof.
 induction a;intros SH ge e m t mf af result EV FINAL.
 all:try solve[
  cbn[conditional_shape]in SH;
  destruct(strategy_simple_identity _ _ _ _ _ _ _ _ EV SH)as[TT[MM AA]];subst t mf af;
  split;[reflexivity|];split;[reflexivity|];eapply conditional_simple_big;eauto].
 cbn[conditional_shape]in SH;core_unpack.
 inversion EV;subst.
 lazymatch goal with TEST:eval_expr ge e m RV a1 ?tt ?mm ?aa|-_ =>
  destruct(strategy_simple_identity _ _ _ _ _ _ _ _ TEST ltac:(assumption))as[T0[M0 A0]];subst end.
 lazymatch goal with BR:eval_expr ge e m RV(if ?taken then a2 else a3) ?bt ?bm ?ba,
                 BF:eval_simple_rvalue ge e ?bm ?ba ?bv|-_ =>
  assert(CB:bt=E0 /\bm=m /\conditional_value ge e m(if taken then a2 else a3)bv)
   by(destruct taken;[eapply IHa2|eapply IHa3];eauto);
  destruct CB as[T0[M0 CV]];subst end.
 inversion FINAL;subst;split;[reflexivity|];split;[reflexivity|].
 eapply cv_condition.
 - apply source_simple_is_simple;assumption.
 - eapply(proj1(simple_big_denotation ge e m));[eassumption|apply source_simple_is_simple;assumption].
 - eassumption.
 - eassumption.
 - eassumption.
Qed.

Theorem original_conditional_assignment_from_normal:
 forall ge f e k m mf l r ty,
 source_simple l=true ->conditional_shape r=true ->
 typeof l=ty ->nv ty=true ->
 exec_stmt ge e m(Sdo(Eassign l r ty))E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f(Sdo(Eassign l r ty))k e m).
Proof.
 intros ge f e k m mf l r ty LS RS LT NV EXEC;subst ty.
 inversion EXEC;subst.
 lazymatch goal with EX:eval_expression ge e m(Eassign l r(typeof l))E0 mf _|-_=>inversion EX;subst end.
 lazymatch goal with EX:eval_expr ge e m RV(Eassign l r(typeof l))E0 mf _|-_=>inversion EX;subst end.
 lazymatch goal with LE:eval_expr ge e m LV l ?t1 ?m1 ?l1|-_ =>
  destruct(strategy_simple_identity _ _ _ _ _ _ _ _ LE LS)as[T1[M1 L1]];subst end.
 lazymatch goal with RE:eval_expr ge e m RV r ?t2 ?m2 ?r2,
                 RR:eval_simple_rvalue ge e ?m2 ?r2 ?vr|-_ =>
  destruct(strategy_conditional_value r RS ge e m t2 m2 r2 vr RE RR)as[T2[M2 CV]];subst end.
 lazymatch goal with
 AS:assign_loc ge(typeof l)m ?bb ?oo ?bfield ?converted ?tt mf ?output,
 VALUE:conditional_value ge e m r ?input,
 CAST:sem_cast ?input(typeof r)(typeof l)m=Some ?converted|-_ =>
  assert(TT:tt=E0)by(eapply assign_loc_silent;[exact NV|exact AS]);subst tt;
  pose proof(Cexec.do_assign_loc_complete ge quiet_world _ _ _ _ _ _ quiet_world E0 _ _ AS(possible_trace_nil _))as STORE;
  eapply(conditional_assignment_certificate ge f e k m mf(typeof l)(typeof r)
    bb oo bfield input converted output NV CAST STORE l r);
  unfold pending;split;[apply source_simple_is_simple;exact LS|];split;[reflexivity|];split;
  [eapply(proj2(simple_big_denotation ge e m));[eassumption|apply source_simple_is_simple;exact LS]
  |split;[reflexivity|exact VALUE]]
 end.
Qed.
Print Assumptions original_conditional_assignment_from_normal.
