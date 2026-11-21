From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Errors Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllOrder Require Import PureSyntax PhaseComposition.
From PidPositionTranslationCore Require Import ConditionalStrategy.

Lemma sequence_transition:forall ge f st tail k e m,
 unique_transition ge(State f(Ssequence st tail)k e m)(State f st(Kseq tail k)e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;auto].
 all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
Qed.
Lemma skip_sequence_transition:forall ge f tail k e m,
 unique_transition ge(State f Sskip(Kseq tail k)e m)(State f tail k e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;cbn in *;try contradiction;auto].
Qed.
Lemma singleton_certificate:forall ge target,certificate ge(fun s=>s=target)target.
Proof. intros;split;[intros;auto|intros s t next EQ NE;contradiction]. Qed.
Lemma prepend_transition:forall ge initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 exists Q,certificate ge Q target /\Q initial.
Proof.
 intros ge initial middle P target TRANS CERT PI.
 exists(fun s=>s=initial \/P s);split;[|auto].
 eapply chain_certificate with(P:=fun s=>s=initial)(middle:=initial)(initial:=middle);
 [apply singleton_certificate|exact CERT|exact TRANS|exact PI].
Qed.
Lemma sequence_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 exists R,certificate ge R target /\R(State f(Ssequence first second)k e m).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI.
 pose proof(chain_certificate ge P Q _ _ target CP CQ
 (skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_transition;[apply sequence_transition|exact JOIN|left;exact PI].
Qed.
Fixpoint conditional_block(s:statement):bool:=
 match s with
 | Sskip=>true
 | Sdo(Eassign l r ty)=>source_simple l &&conditional_shape r &&nv ty &&
   if Ctypes.type_eq(typeof l)ty then true else false
 | Ssequence a b=>conditional_block a &&conditional_block b
 | _=>false end.
Theorem normal_conditional_block_certificate:forall st ge f e k m mf,
 conditional_block st=true ->exec_stmt ge e m st E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f st k e m).
Proof.
 induction st;intros ge f rho k m mf SH EXEC;cbn[conditional_block]in SH;try discriminate.
 - inversion EXEC;subst;exists(fun s=>s=State f Sskip k rho mf);split;[apply singleton_certificate|reflexivity].
 - destruct e;try discriminate.
   core_unpack;destruct(Ctypes.type_eq(typeof e1)ty)as[TY|NE];try discriminate.
   eapply original_conditional_assignment_from_normal;eauto.
 - core_unpack;inversion EXEC;subst;try contradiction.
   match goal with TRACE:?t1 ** ?t2=E0|-_=>apply Eapp_E0_inv in TRACE;destruct TRACE;subst end.
   match goal with A:exec_stmt ge rho m st1 E0 ?mid Out_normal,
                   B:exec_stmt ge rho ?mid st2 E0 mf Out_normal|-_ =>
    destruct(IHst1 ge f rho(Kseq st2 k)m mid ltac:(assumption)A)as[P[CP PI]];
    destruct(IHst2 ge f rho k mid mf ltac:(assumption)B)as[Q[CQ QI]];
    eapply sequence_certificate;[exact CP|exact PI|exact CQ|exact QI]end.
Qed.
Print Assumptions normal_conditional_block_certificate.
