From Stdlib Require Import List.
From compcert Require Import AST Values Memory Events Ctypes Csem Smallstep.
From FiveSum3Proof Require Import SourceInvariant.
From FiveSum3Proof Require Import Invariant.
From FiveSum3Proof Require Import Core.
From FiveSum3 Require Import Execution.
Import ListNotations.

Definition generated_step := Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Theorem step_exact : forall s t s',source_state s ->
 (generated_step tt s t s' <-> Csem.step Execution.ge s t s').
Proof. intros;change(Core.model_step tt s t s' <-> Csem.step sum3_ge s t s');apply Core.step_exact;assumption. Qed.

Lemma source_path_to_model : forall s t s',source_state s ->
 star Csem.step sum3_ge s t s' -> star generated_step tt s t s'.
Proof.
 intros s t s' SOURCE PATH;revert SOURCE;induction PATH;intros SOURCE.
 - constructor.
 - eapply star_step.
   + apply(proj2(step_exact _ _ _ SOURCE));exact H.
   + apply IHPATH;exact(proj2(source_step_invariant _ _ _ _ SOURCE H)).
   + exact H0.
Qed.
Theorem whole_execution : forall args m t s,
 star generated_step tt(Execution.entry args m)t s <->
 star Csem.step Execution.ge(Execution.entry args m)t s.
Proof.
 intros;split;intro PATH.
 - change(star Core.model_step tt(Core.entry args m)t s)in PATH.
   eapply Core.model_paths_are_source_paths;[unfold Core.entry;split;reflexivity|exact PATH].
 - apply source_path_to_model;[unfold Execution.entry;split;reflexivity|exact PATH].
Qed.
Theorem error_definition_exact : forall s,Execution.source_error s <-> Invariant.source_error s.
Proof. reflexivity. Qed.
Theorem generated_no_error : forall args m,
 sum3_pre args -> forall t s,star generated_step tt(Execution.entry args m)t s -> ~Execution.source_error s.
Proof.
 intros args m PRE t s PATH;apply whole_execution in PATH.
 eapply sum3_all_reachable_no_error;[exact PRE|exact PATH].
Qed.
Print Assumptions whole_execution.
Print Assumptions error_definition_exact.
Print Assumptions generated_no_error.
