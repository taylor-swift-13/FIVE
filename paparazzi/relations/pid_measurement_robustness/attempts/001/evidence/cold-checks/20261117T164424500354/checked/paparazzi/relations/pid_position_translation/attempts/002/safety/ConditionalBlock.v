From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation BlockExecution PhaseComposition PureIfShell.
From PidPositionSafety Require Import PureSound.
From PidPositionTranslationCore Require Import ConditionalStrategy CoreTail CoreSemantics.
Lemma singleton_certificate:forall ge target,certificate ge(fun s=>s=target)target.
Proof. intros;split;[intros;auto|intros s t next EQ NE;contradiction]. Qed.
Lemma join_certificate:forall ge P Q middle target,
 certificate ge P middle ->certificate ge Q target ->Q middle ->
 certificate ge(fun s=>P s\/Q s)target.
Proof.
 intros ge P Q middle target[PP PC][QP QC]QM;split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[STEP PN]]]].
     * subst;destruct(QP middle QM)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
     * right;eauto.
   + destruct(QP s QS)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
 - intros s t next[PS|QS]NF STEP.
   + destruct(classic(s=middle))as[EQ|NE].
     * subst;right;eapply QC;eauto.
     * left;eapply PC;eauto.
   + right;eapply QC;eauto.
Qed.
Lemma prepend_transition:forall ge initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 exists Q,certificate ge Q target/\Q initial.
Proof.
 intros ge initial middle P target TRANS CERT PI;exists(fun s=>s=initial\/P s);split;[|auto].
 eapply chain_certificate with(P:=fun s=>s=initial)(middle:=initial)(initial:=middle);
 [apply singleton_certificate|exact CERT|exact TRANS|exact PI].
Qed.
Lemma sequence_transition:forall ge f st tail k e m,
 unique_transition ge(State f(Ssequence st tail)k e m)(State f st(Kseq tail k)e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;auto].
 all:repeat match goal with H:_\/_|-_=>destruct H end;discriminate.
Qed.
Lemma skip_sequence_transition:forall ge f tail k e m,
 unique_transition ge(State f Sskip(Kseq tail k)e m)(State f tail k e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;cbn in *;try contradiction;auto].
Qed.
Lemma sequence_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 exists R,certificate ge R target/\R(State f(Ssequence first second)k e m).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI.
 pose proof(chain_certificate ge P Q _ _ target CP CQ(skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_transition;[apply sequence_transition|exact JOIN|left;exact PI].
Qed.
Lemma normal_statement_path:forall ge e m st mf,
 exec_stmt ge e m st E0 mf Out_normal ->forall f,
 star Csem.step ge(State f st Kstop e m)E0(State f Sskip Kstop e mf).
Proof.
 intros ge e m st mf EV f.
 destruct(Cstrategy.exec_stmt_to_steps ge e m st E0 mf Out_normal EV f Kstop)as[reached[PATH END]].
 inversion END;subst;apply strategy_star_csem;exact PATH.
Qed.
Lemma normal_block_certificate:forall ge f e k m st mf,
 block_stmt st=true ->exec_stmt ge e m st E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf)/\P(State f st k e m).
Proof.
 intros ge f e k m st mf SYN EXEC.
 exists(block_context_invariant ge k f e mf);split.
 - split;[apply block_context_progress|apply block_context_all_successors].
 - eapply block_context_entry;[exact SYN|eapply normal_statement_path;exact EXEC].
Qed.
Fixpoint conditional_block(s:statement):bool:=match s with
| Sskip=>true
| Sdo a=>match a with Eassign l r ty=>source_simple l&&conditional_shape r&&
 (if Ctypes.type_eq(typeof l)ty then true else false)&&nv ty|_=>atomic_expr a end
| Ssequence a b=>conditional_block a&&conditional_block b
| Sifthenelse c yes no=>source_simple c&&conditional_block yes&&conditional_block no
| _=>false end.
Theorem conditional_block_from_normal:forall ge f e st m mf,
 conditional_block st=true ->exec_stmt ge e m st E0 mf Out_normal ->
 forall k,exists P,certificate ge P(State f Sskip k e mf)/\P(State f st k e m).
Proof.
 intros ge f e st;induction st;intros m mf SH EXEC k;cbn[conditional_block]in SH;try discriminate.
 - inversion EXEC;subst;exists(fun s=>s=State f Sskip k e mf);split;[apply singleton_certificate|reflexivity].
 - destruct e0;try solve[eapply normal_block_certificate;[exact SH|exact EXEC]];core_unpack.
   destruct(Ctypes.type_eq(typeof e0_1)ty)as[TY|NE];try discriminate.
   eapply original_conditional_assignment_from_normal;eauto.
 - apply andb_true_iff in SH as[S1 S2].
   destruct(sequence_normal_inv ge e _ _ _ _ EXEC)as[mid[E1 E2]].
   destruct(IHst1 m mid S1 E1(Kseq st2 k))as[P[CP IP]].
   destruct(IHst2 mid mf S2 E2 k)as[Q[CQ IQ]].
   eapply sequence_certificate;[exact CP|exact IP|exact CQ|exact IQ].
 - core_unpack.
   inversion EXEC;subst.
   match goal with EX:eval_expression ge e m e0 ?tt ?mm ?vv|-_=>
   inversion EX;subst end.
   match goal with EV:eval_expr ge e m RV e0 ?tt ?mm ?af|-_=>
   destruct(strategy_simple_identity ge e m RV e0 tt mm af EV ltac:(assumption))as[TT[MM AA]];
   subst tt mm af end.
   cbn in H4;subst t2.
   assert(PV:pure_rval ge e m e0=Some v1).
   { apply(proj1(simple_big_denotation ge e m));[assumption|apply source_simple_is_simple;assumption]. }
   assert(BR:exists Q,certificate ge Q(State f Sskip k e mf)/\
     Q(State f(if b then st1 else st2)k e m)).
   { destruct b;[eapply IHst1|eapply IHst2];eauto. }
   destruct BR as[Q[CQ IQ]].
   pose proof(PureIfShell.if_certificate ge f e k m e0 st1 st2 v1 b
     (source_simple_is_simple e0 CORE1)PV H8)as CI.
   eexists;split.
   + eapply join_certificate;[exact CI|exact CQ|exact IQ].
   + left;apply PureIfShell.initial.
Qed.
Print Assumptions conditional_block_from_normal.

Fixpoint conditional_prefix(n:nat)(s:statement):bool:=
 match n with O=>true|S n=>match s with
 | Ssequence a b=>conditional_block a&&conditional_prefix n b
 | _=>conditional_block s end end.
Theorem conditional_prefix_certificate:forall n ge f e s m mid,
 conditional_prefix n s=true ->
 exec_stmt ge e m(first_statements n s)E0 mid Out_normal ->
 forall k Q target,certificate ge Q target ->Q(State f(drop_statements n s)k e mid) ->
 exists P,certificate ge P target/\P(State f s k e m).
Proof.
 induction n;intros ge f e s m mid SH EX k Q target CQ IQ.
 - cbn[first_statements]in EX;inversion EX;subst;exists Q;auto.
 - destruct s;cbn[conditional_prefix first_statements drop_statements]in SH,EX,IQ.
   all:try solve[
    destruct(conditional_block_from_normal ge f e _ m mid SH EX k)as[P[CP IP]];
    exists(fun s=>P s\/Q s);split;[eapply join_certificate;[exact CP|exact CQ|exact IQ]|left;exact IP]].
   apply andb_true_iff in SH as[S1 S2].
   destruct(sequence_normal_inv ge e _ _ _ _ EX)as[ma[A B]].
   destruct(conditional_block_from_normal ge f e s1 m ma S1 A(Kseq s2 k))as[P[CP IP]].
   destruct(IHn ge f e s2 ma mid S2 B k Q target CQ IQ)as[R[CR IR]].
   eapply sequence_certificate;[exact CP|exact IP|exact CR|exact IR].
Qed.
