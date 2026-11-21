From Stdlib Require Import List.
From compcert Require Import Coqlib Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax AtomicDenotation CallfreeExecution PhaseComposition.

Lemma atomic_statement_evaluates:forall ge e ret a m v mf,
 atomic_eval ge e m a=Some(v,mf) ->stmt_eval ge e ret(Sdo a)m=Some(Nnormal,mf).
Proof. intros;cbn[stmt_eval];rewrite H;reflexivity. Qed.
Lemma sequence_evaluates:forall ge e ret first second m ma mf,
 stmt_eval ge e ret first m=Some(Nnormal,ma) ->
 stmt_eval ge e ret second ma=Some(Nnormal,mf) ->
 stmt_eval ge e ret(Ssequence first second)m=Some(Nnormal,mf).
Proof. intros;cbn[stmt_eval];rewrite H;exact H0. Qed.

Lemma evaluator_certificate:forall ge v mf,
 certificate ge
 (fun s=>normal_state s=true /\call_names s /\state_eval ge s=Some(v,mf))
 (Returnstate v Kstop mf).
Proof.
 intros ge v mf;split.
 - intros s[N[CN EV]].
   destruct(invariant_progress ge s(conj N(conj CN(ex_intro _ (v,mf)EV))))as[DONE|STEP].
   + destruct DONE as[w[m E]];subst s;cbn[state_eval]in EV;injection EV as W M;subst;auto.
   + destruct STEP as[t[next STEP]];right;exists t,next;split;[exact STEP|].
     destruct(normal_step_forward ge s t next(v,mf)N EV STEP)as[NN NE].
     split;[exact NN|];split;[exact(normal_step_names ge s t next N CN STEP)|exact NE].
 - intros s t next[N[CN EV]]NE STEP.
   destruct(normal_step_forward ge s t next(v,mf)N EV STEP)as[NN EN].
   split;[exact NN|];split;[exact(normal_step_names ge s t next N CN STEP)|exact EN].
Qed.

Lemma certificate_has_return:forall ge P target s,
 certificate ge P target ->P s ->Acc(successor ge)s ->
 exists t,star Csem.step ge s t target.
Proof.
 intros ge P target s CERT PI ACC;revert PI;induction ACC as[s ACC IH];intros PI.
 destruct(proj1 CERT s PI)as[EQ|[t[next[STEP PN]]]].
 - subst s;exists E0;constructor.
 - destruct(IH next(ex_intro _ t STEP)PN)as[tr PATH].
   exists(t**tr);eapply star_step;[exact STEP|exact PATH|reflexivity].
Qed.

Lemma skip_seq_unique:forall ge f tail k e m,
 unique_transition ge(State f Sskip(Kseq tail k)e m)(State f tail k e m).
Proof. intros;split;[right;apply step_skip_seq|intros t next[ES|SS];[inversion ES|inversion SS;subst;auto;contradiction]]. Qed.
Lemma sequence_unique:forall ge f first tail k e m,
 unique_transition ge(State f(Ssequence first tail)k e m)(State f first(Kseq tail k)e m).
Proof.
 intros;split;[right;apply step_seq|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;auto].
 all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
Qed.
Lemma prepend_certificate:forall ge P target initial next,
 certificate ge P target ->P next ->unique_transition ge initial next ->
 certificate ge(fun s=>s=initial \/P s)target.
Proof.
 intros ge P target initial next CERT PN[STEP UNIQUE];split.
 - intros s[EQ|PS].
   + subst s;right;exists E0,next;split;[exact STEP|right;exact PN].
   + destruct(proj1 CERT s PS)as[EQ|[t[nxt[ST NP]]]].
     * left;exact EQ.
     * right;exists t,nxt;split;[exact ST|right;exact NP].
 - intros s t nxt[EQ|PS]NE ST.
   + subst s;destruct(UNIQUE t nxt ST)as[TT EQ];subst nxt;right;exact PN.
   + right;eapply(proj2 CERT);eauto.
Qed.
Print Assumptions evaluator_certificate.
Print Assumptions certificate_has_return.
