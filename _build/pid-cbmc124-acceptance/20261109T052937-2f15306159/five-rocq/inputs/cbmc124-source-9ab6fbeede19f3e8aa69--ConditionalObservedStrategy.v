From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Errors Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PhaseComposition.
From PidPositionSafety Require Import PureSound.
From PidPositionTranslationCore Require Import ConditionalPure ConditionalAssignment.

From CoreCBMC Require Import NumericBounds ArithmeticTree ArithmeticAssignment.
From PidPositionSafety Require Import SubtractionObservation.
From PidPositionTranslationCore Require Import ConditionalStrategy.
Theorem raw_conditional_assignment_observed:forall ge f e k m mf ty rty b ofs bf vr vc vout l r,
 nv ty=true ->sem_cast vr rty ty m=Some vc ->
 Cexec.do_assign_loc ge quiet_world ty m b ofs bf vc=Some(quiet_world,E0,mf,vout) ->
 ArithmeticAssignment.pending ge e m ty rty b ofs bf vr l r ->
 arithmetic_tree ge e m(Eassign l r ty) ->
 exists P,certificate ge P(State f Sskip k e mf)/\
 P(State f(Sdo(Eassign l r ty))k e m)/\(forall s,P s->subtraction_observation ge f s).
Proof.
 intros ge f e k m mf ty rty b ofs bf vr vc vout l r NV CAST STORE PENDING TREE.
 pose proof(ArithmeticAssignment.conditional_arithmetic_assignment_certificate ge f e k m mf ty rty b ofs bf vr vc vout
 NV CAST STORE l r PENDING TREE)as CERT.
 eexists;split;[exact CERT|];split;[apply ArithmeticAssignment.conditional_arithmetic_assignment_initial|].
 intros s IN;destruct s;try exact I.
 apply arithmetic_subtraction_observation;eapply ArithmeticAssignment.conditional_arithmetic_assignment_observation;exact IN.
Qed.
Theorem conditional_assignment_observed_from_normal:
 forall ge f e k m mf l r ty,
 source_simple l=true ->conditional_shape r=true ->
 typeof l=ty ->nv ty=true ->
 arithmetic_tree ge e m(Eassign l r ty) ->
 exec_stmt ge e m(Sdo(Eassign l r ty))E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f(Sdo(Eassign l r ty))k e m)/\(forall s,P s->subtraction_observation ge f s).
Proof.
 intros ge f e k m mf l r ty LS RS LT NV TREE EXEC;subst ty.
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
  eapply(raw_conditional_assignment_observed ge f e k m mf(typeof l)(typeof r)
    bb oo bfield input converted output l r NV CAST STORE);[|exact TREE];
  unfold ArithmeticAssignment.pending;split;[apply source_simple_is_simple;exact LS|];split;[reflexivity|];split;
  [eapply(proj2(simple_big_denotation ge e m));[eassumption|apply source_simple_is_simple;exact LS]
  |split;[reflexivity|exact VALUE]]
 end.
Qed.

Print Assumptions conditional_assignment_observed_from_normal.
