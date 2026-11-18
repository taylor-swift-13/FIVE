From Stdlib Require Import Bool List.
From compcert Require Import Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import WeightedTermination.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.

Lemma normal_stmt_finite: forall s,
 normal_stmt s=true -> finite_statement s=true.
Proof. induction s;simpl;intros H;core_unpack;try discriminate;core_build;auto. Qed.
Lemma normal_cont_finite: forall k,
 normal_cont k=true -> finite_continuation k.
Proof.
 induction k;simpl;intros H;core_unpack;try discriminate;constructor;auto using normal_stmt_finite.
Qed.
Lemma normal_state_finite: forall s,
 normal_state s=true -> finite_state s.
Proof.
 destruct s as[f st k e m|f a k e m|fd args k m|v k m|];simpl;intros H;core_unpack;try discriminate;
 try (split;auto using normal_stmt_finite,normal_cont_finite).
 - destruct k;simpl in H;core_unpack;try discriminate;constructor;auto using normal_cont_finite,normal_stmt_finite.
 - destruct fd;destruct k;try discriminate;constructor.
 - destruct k;try discriminate;constructor.
Qed.
Lemma normal_calls_budget: forall ge s,
 normal_state s=true -> calls_within_budget (fun _=>0) ge s.
Proof.
 destruct s;cbn[calls_within_budget];intros N;try exact I.
 intros C sub fd args ty CT EQ CR;exfalso.
 eapply normal_no_callred;[exact N|exact CT|exact EQ|exact CR].
Qed.
Theorem normal_all_successors_terminate: forall ge s,
 normal_state s=true -> Acc(successor ge)s.
Proof.
 intros ge;eapply(all_successors_accessible (fun _=>0) ge (fun s=>normal_state s=true)).
 - exact normal_state_finite.
 - exact(normal_calls_budget ge).
 - intros s t next N [ES|SS].
   + destruct s;inversion ES;subst;eapply normal_estep_backward in ES;eauto;exact(proj1 ES).
   + eapply normal_sstep_preserved;eauto.
Qed.
Theorem defined_evaluator_no_error: forall ge initial result,
 normal_state initial=true -> call_names initial ->
 state_eval ge initial=Some result -> no_error ge initial.
Proof.
 intros ge initial result N CN EV t reached PATH [BAD STOP].
 assert(INV:execution_invariant ge initial)by(repeat split;auto;exists result;exact EV).
 destruct(invariant_progress ge reached (reachable_invariant ge initial t reached INV PATH))as[RET|[tr[next STEP]]].
 - apply BAD;exact RET.
 - exact(STOP tr next STEP).
Qed.
Theorem defined_evaluator_exact_return: forall ge initial v mf t v' mf',
 normal_state initial=true -> state_eval ge initial=Some(v,mf) ->
 star Csem.step ge initial t(Returnstate v' Kstop mf') -> v'=v /\ mf'=mf.
Proof.
 intros ge initial v mf t v' mf' N EV PATH.
 pose proof(all_order_normal_correspondence ge initial t v' mf' N PATH)as EQ.
 rewrite EV in EQ;inversion EQ;auto.
Qed.
Theorem defined_evaluator_safe_termination: forall ge initial result,
 normal_state initial=true -> call_names initial ->
 state_eval ge initial=Some result -> safe_termination ge initial.
Proof.
 intros;split;[eapply defined_evaluator_no_error;eauto|apply normal_all_successors_terminate;auto].
Qed.
Theorem defined_evaluator_return_exists: forall ge initial v mf,
 normal_state initial=true -> call_names initial ->
 state_eval ge initial=Some(v,mf) ->
 exists t,star Csem.step ge initial t(Returnstate v Kstop mf).
Proof.
 intros ge initial v mf N CN EV.
 pose proof(normal_all_successors_terminate ge initial N)as AC.
 assert(INV:execution_invariant ge initial)by(repeat split;auto;exists(v,mf);exact EV).
 revert INV N EV;induction AC as[s AC IH];intros INV N EV.
 destruct(invariant_progress ge s INV)as[[v'[mf' EQ]]|[tr[next STEP]]].
 - subst s;cbn[state_eval]in EV;inversion EV;subst;exists E0;constructor.
 - destruct(normal_step_forward ge s tr next (v,mf) N EV STEP)as[NN EN].
   destruct(IH next ltac:(exists tr;exact STEP)(normal_step_names ge s tr next N CN STEP)(invariant_preserved ge s tr next INV STEP)NN EN)as[tail PATH].
   exists(tr**tail);eapply star_step;eauto.
Qed.
Print Assumptions normal_all_successors_terminate.
Print Assumptions defined_evaluator_safe_termination.
Print Assumptions defined_evaluator_return_exists.
