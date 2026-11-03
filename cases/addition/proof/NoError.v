From Stdlib Require Import List.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveCases.addition.proof.support Require Import SourceInvariant Invariant.
From FiveCases.addition.proof Require Import Entry.
From FiveShared.strict_execution Require Import SourceInvariant ExecutionModel.
Import ListNotations.
Module Narrow := FiveCases.addition.proof.support.SourceInvariant.

Definition calling_pre(args:list val):Prop :=
 exists a b:float32,args=[Vsingle a;Vsingle b].

Lemma pure_model_step_exact : forall s t s',Narrow.source_state s ->
 (model_step tt s t s' <-> Csem.step source_ge s t s').
Proof.
 intros;unfold model_step,transitions;apply pure_do_step_exact;
 eauto using Narrow.source_callback_free,Narrow.source_silent.
Qed.
Lemma model_paths_are_source_paths : forall initial t s,
 Narrow.source_state initial ->star model_step tt initial t s ->
 star Csem.step source_ge initial t s.
Proof.
 intros initial t s SOURCE PATH;revert SOURCE;induction PATH;intros SOURCE.
 - constructor.
 - apply pure_model_step_exact in H;auto.
   eapply star_step;[exact H| |exact H0].
   apply IHPATH;exact(proj2(Narrow.source_step_invariant _ _ _ _ SOURCE H)).
Qed.
Theorem addition_whole_execution_exact : forall args m t s,
 star model_step tt(execution_entry Addition args m)t s <->
 star Csem.step source_ge(execution_entry Addition args m)t s.
Proof.
 intros;split;intro PATH.
 - eapply model_paths_are_source_paths;[split;reflexivity|exact PATH].
 - assert(SOURCE:Narrow.source_state(execution_entry Addition args m))by(split;reflexivity).
   revert SOURCE;induction PATH;intros SOURCE;[constructor|].
   eapply star_step;[apply pure_model_step_exact;eauto| |exact H0].
   apply IHPATH;exact(proj2(Narrow.source_step_invariant _ _ _ _ SOURCE H)).
Qed.

Theorem all_reachable_source_no_error : forall args m,
 calling_pre args -> forall t s,
 star Csem.step source_ge(execution_entry Addition args m)t s ->
 ~ExecutionModel.source_error s.
Proof.
 intros args m[a[b EQ]]t s PATH;subst args.
 change(star Csem.step addition_ge(addition_start(Vsingle a)(Vsingle b)m)t s)in PATH.
 change(~Invariant.source_error s);apply invariant_excludes_error.
 eapply reachable_invariant;[apply typed_entry_establishes_invariant|exact PATH].
Qed.
Theorem all_reachable_model_no_error : forall args m,
 calling_pre args ->forall t s,
 star model_step tt(execution_entry Addition args m)t s ->~model_error s.
Proof.
 intros args m[a[b EQ]]t s PATH[NOTRETURN EMPTY];subst args.
 apply addition_whole_execution_exact in PATH.
 change(star Csem.step addition_ge(addition_start(Vsingle a)(Vsingle b)m)t s)in PATH.
 pose proof(reachable_invariant _ _ _ (typed_entry_establishes_invariant m a b)PATH)as INV.
 destruct(invariant_progress s INV)as[RETURN|[u[next STEP]]].
 - apply NOTRETURN;exact RETURN.
 - apply pure_model_step_exact in STEP;[|exact(proj1 INV)].
   destruct STEP as[rule IN];rewrite EMPTY in IN;contradiction.
Qed.
Theorem all_binary32_bits_no_error : forall a b m t s,
 star model_step tt(add_bits_entry a b m)t s ->~model_error s.
Proof.
 intros a b m t s PATH;eapply all_reachable_model_no_error;[|exact PATH].
 unfold calling_pre;eauto 7.
Qed.
Theorem calling_pre_inhabited : calling_pre[Vsingle Float32.zero;Vsingle Float32.zero].
Proof. unfold calling_pre;eauto 7. Qed.
Print Assumptions addition_whole_execution_exact.
Print Assumptions all_reachable_model_no_error.
