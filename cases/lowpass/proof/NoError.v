From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Events Smallstep Csem Cexec.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import NormalCorrespondence.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
From FiveCases.lowpass.model Require Import Execution.
From FiveCases.lowpass.proof Require Import PureProgress.
From FiveCases.lowpass.proof Require Import Invariant.
From FiveCases.lowpass.proof Require Import Entry.
Import ListNotations.

Theorem source_error_matches_executable_error : forall s,source_state s ->
 (source_error s <-> ~normal_return s /\ Execution.transitions s=[]).
Proof.
 intros s SOURCE;unfold source_error;rewrite(blocked_exact s SOURCE);reflexivity.
Qed.

(** Universal over all initialized binary32 fields, all input words, all
    caller memories satisfying the structural precondition, and all paths. *)
Theorem lowpass_all_reachable_no_error : forall m b fs input,
 lowpass_pre m b fs -> forall t reached,
 star Csem.step lowpass_ge
  (lowpass_start(Vptr b Ptrofs.zero)(Vsingle(Float32.of_bits input))m) t reached ->
 ~source_error reached.
Proof.
 intros m b fs input PRE t reached PATH.
 apply invariant_excludes_error.
 eapply reachable_invariant;[eapply structural_pre_establishes_invariant;exact PRE|exact PATH].
Qed.

Theorem lowpass_model_all_reachable_no_error : forall m b fs input,
 lowpass_pre m b fs -> forall t reached,
 star Execution.model_step tt
  (execution_entry_bits(Vptr b Ptrofs.zero)input m) t reached ->
 ~source_error reached.
Proof.
 intros m b fs input PRE t reached PATH.
 eapply lowpass_all_reachable_no_error;[exact PRE|].
 apply all_finite_executions_exact;exact PATH.
Qed.

Theorem lowpass_no_stuck_state : forall m b fs input,
 lowpass_pre m b fs -> forall t,
 ~star Execution.model_step tt
  (execution_entry_bits(Vptr b Ptrofs.zero)input m) t Stuckstate.
Proof.
 intros m b fs input PRE t PATH.
 apply(lowpass_model_all_reachable_no_error m b fs input PRE t Stuckstate PATH).
 split.
 - intros[v[m' EQ]];discriminate.
 - intros t' s' STEP;destruct STEP as [ES|SS];inversion ES || inversion SS.
Qed.

Theorem lowpass_model_progress_at_every_reachable_state : forall m b fs input,
 lowpass_pre m b fs -> forall t reached,
 star Execution.model_step tt
  (execution_entry_bits(Vptr b Ptrofs.zero)input m) t reached ->
 normal_return reached \/ exists rule tr next,
 In(Cexec.TR rule tr next)(Execution.transitions reached).
Proof.
 intros m b fs input PRE t reached PATH.
 assert(INV:execution_invariant reached).
 { eapply reachable_invariant.
   - eapply structural_pre_establishes_invariant;exact PRE.
   - apply all_finite_executions_exact;exact PATH. }
 destruct(invariant_progress _ INV)as [DONE|[tr[next STEP]]];auto.
 right. apply step_exact in STEP;[|exact(proj1 INV)].
 destruct STEP as [rule IN];eauto.
Qed.

Theorem lowpass_every_execution_tree_leaf_no_error : forall m b fs input,
 lowpass_pre m b fs -> forall fuel reached,
 tree_leaf (execute fuel (execution_entry_bits(Vptr b Ptrofs.zero)input m)) reached ->
 ~source_error reached.
Proof.
 intros m b fs input PRE fuel reached LEAF.
 eapply lowpass_model_all_reachable_no_error;[exact PRE|].
 eapply execute_leaf_sound;[apply lowpass_start_source|exact LEAF].
Qed.

Print Assumptions lowpass_all_reachable_no_error.
Print Assumptions lowpass_model_all_reachable_no_error.
Print Assumptions lowpass_no_stuck_state.
Print Assumptions lowpass_model_progress_at_every_reachable_state.
Print Assumptions lowpass_every_execution_tree_leaf_no_error.
