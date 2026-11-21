From Stdlib Require Import List String.
From compcert Require Import Coqlib AST Values Memory Events Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import Total BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import MathCoverage GuardedCover.
Import ListNotations.
Local Open Scope string_scope.
Lemma guarded_total_current:forall ge Q s,guarded_total ge Q s ->state_math_guard ge s.
Proof. intros;inversion H;subst;[exact I|assumption]. Qed.
Lemma covers_guarded_total:forall ge Q s,
 guarded_covers ge(guarded_total ge Q)s ->guarded_total ge Q s.
Proof. intros;eapply guarded_covers_bind;[exact H|intros;assumption]. Qed.
Lemma guarded_total_forget:forall ge Q s,guarded_total ge Q s ->Total.total ge Q s.
Proof. intros ge Q s H;induction H;[constructor;assumption|apply Total.total_next;assumption]. Qed.
Lemma singleton_total_guarded:forall ge Q s next rule,
 state_math_guard ge s ->callback_free_state s ->silent_state ge s ->
 Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet s=[TR rule E0 next] ->
 guarded_total ge Q next ->guarded_total ge Q s.
Proof.
 intros ge Q s next rule MG CB SIL DS END;apply covers_guarded_total.
 eapply singleton_guarded;[exact MG|exact CB|exact SIL|exact DS|].
 apply guarded_here;[eapply guarded_total_current;exact END|exact END].
Qed.
Lemma return_value_guarded:forall ge P f v ty k e m result mf,
 sem_cast v ty(fn_return f)m=Some result ->Mem.free_list m(blocks_of_env ge e)=Some mf ->
 guarded_covers ge P(Returnstate result(call_cont k)mf) ->
 guarded_covers ge P(ExprState f(Eval v ty)(Kreturn k)e m).
Proof.
 intros ge P f v ty k e m result mf CAST FREE END.
 eapply singleton_guarded with(rule:="step_return_2");eauto using Control.literal_silent;try reflexivity.
 unfold Cexec.do_step;cbn -[sem_cast Mem.free_list];rewrite CAST,FREE;reflexivity.
Qed.
Lemma return_math_guarded:forall ge P f a k e m v result mf,
 branch_simple a=true ->branch_rval ge e m a=Some v ->math_guarded ge e m a ->
 sem_cast v(typeof a)(fn_return f)m=Some result ->Mem.free_list m(blocks_of_env ge e)=Some mf ->
 guarded_covers ge P(Returnstate result(call_cont k)mf) ->
 guarded_covers ge P(State f(Sreturn(Some a))k e m).
Proof.
 intros;apply return_start_guarded;eapply math_observation_prefix_guarded;eauto.
 eapply return_value_guarded;eauto.
Qed.
(** The premise covers the actual resumed expression and therefore includes its
    math_guarded proof; a resumed negation is never discharged as True. *)
Lemma return_to_caller_guarded:forall ge P v f e C ty k m,
 guarded_covers ge P(ExprState f(C(Eval v ty))k e m) ->
 guarded_covers ge P(Returnstate v(Kcall f e C ty k)m).
Proof. intros;eapply singleton_guarded with(rule:="step_returnstate");eauto using Control.return_silent;reflexivity. Qed.
Lemma return_value_total_guarded:forall ge Q f v ty k e m result mf,
 sem_cast v ty(fn_return f)m=Some result ->Mem.free_list m(blocks_of_env ge e)=Some mf ->
 guarded_total ge Q(Returnstate result(call_cont k)mf) ->
 guarded_total ge Q(ExprState f(Eval v ty)(Kreturn k)e m).
Proof.
 intros ge Q f v ty k e m result mf CAST FREE END;apply covers_guarded_total.
 eapply return_value_guarded;[exact CAST|exact FREE|].
 apply guarded_here;[exact I|exact END].
Qed.
Lemma return_to_caller_total_guarded:forall ge Q v f e C ty k m,
 guarded_total ge Q(ExprState f(C(Eval v ty))k e m) ->
 guarded_total ge Q(Returnstate v(Kcall f e C ty k)m).
Proof.
 intros ge Q v f e C ty k m END;apply covers_guarded_total;apply return_to_caller_guarded.
 apply guarded_here;[eapply guarded_total_current;exact END|exact END].
Qed.
Print Assumptions return_value_guarded.
Print Assumptions return_to_caller_guarded.
Print Assumptions guarded_total_forget.
