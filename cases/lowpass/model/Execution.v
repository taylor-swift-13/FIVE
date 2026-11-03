From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Events Globalenvs Determinism Csem Cexec Smallstep.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
Import ListNotations.

(** Executable semantic embedding of the ORIGINAL Csyntax function.
    This entry has no validity, finite-number, initialization or input-domain
    premise.  Private parameter/local blocks are allocated by Cexec itself. *)
Definition closed_world : world :=
  World (fun _ _ => None) (fun _ _ _ => None) (fun _ _ _ _ => None).
Definition no_external
  (_:string) (_:signature) (_:Senv.t) (_:world) (_:list val) (_:mem)
  : option (world * trace * val * mem) := None.

Definition transitions (s:Csem.state) : list Cexec.transition :=
  Cexec.do_step lowpass_ge no_external no_external closed_world s.

Definition execution_entry := lowpass_start.
Definition execution_entry_bits (filter:val) (word:int) (m:mem) :=
  execution_entry filter (Vsingle (Float32.of_bits word)) m.

Theorem all_input_bits_preserved : forall word,
  Float32.to_bits (Float32.of_bits word) = word.
Proof. apply Float32.to_of_bits. Qed.
Definition model_step (_:unit) (s:Csem.state) (t:trace) (s':Csem.state) : Prop :=
  exists rule, In (TR rule t s') (transitions s).

Theorem step_exact : forall s t s', source_state s ->
  (model_step tt s t s' <-> Csem.step lowpass_ge s t s').
Proof. intros; apply source_do_step_exact; assumption. Qed.

Theorem step_preserves_source : forall s t s',
  source_state s -> model_step tt s t s' -> source_state s'.
Proof.
  intros s t s' INV STEP. apply step_exact in STEP; auto.
  exact (proj2 (source_step_invariant _ _ _ _ INV STEP)).
Qed.

Theorem model_star_sound : forall s t s',
  star model_step tt s t s' -> source_state s ->
  star Csem.step lowpass_ge s t s'.
Proof.
  intros s t s' PATH; induction PATH; intros INV; [constructor|].
  eapply star_step.
  - apply step_exact; eassumption.
  - apply IHPATH. eapply step_preserves_source; eauto.
  - eassumption.
Qed.

Theorem model_star_complete : forall s t s',
  star Csem.step lowpass_ge s t s' -> source_state s ->
  star model_step tt s t s'.
Proof.
  intros s t s' PATH; induction PATH; intros INV; [constructor|].
  eapply star_step; [apply step_exact; eauto| |eassumption].
  apply IHPATH. exact (proj2 (source_step_invariant _ _ _ _ INV H)).
Qed.

Theorem all_finite_executions_exact : forall filter value m t s,
  star model_step tt (execution_entry filter value m) t s <->
  star Csem.step lowpass_ge (lowpass_start filter value m) t s.
Proof.
  intros; split; intros H.
  - eapply model_star_sound; eauto using lowpass_start_source.
  - eapply model_star_complete; eauto using lowpass_start_source.
Qed.

(** Each node retains its predecessor state and its complete outgoing list.
    In particular an edge to Stuckstate retains the pre-fault memory.  No
    rollback occurs after a preceding successful write.  Exhaustion is its
    own constructor; it is never interpreted as a normal return. *)
Inductive execution_tree : Type :=
| Returned (v:val) (m:mem)
| Undefined (s:Csem.state)
| Blocked (s:Csem.state)
| Exhausted (s:Csem.state)
| Branch (s:Csem.state) (children:list (string * trace * execution_tree)).

Definition terminal_tree (s:Csem.state) : option execution_tree :=
  match s with
  | Returnstate v Kstop m => Some (Returned v m)
  | Stuckstate => Some (Undefined s)
  | _ => None
  end.

Fixpoint execute (fuel:nat) (s:Csem.state) : execution_tree :=
  match terminal_tree s with
  | Some tree => tree
  | None =>
      match fuel with
      | O => Exhausted s
      | S n =>
          match transitions s with
          | [] => Blocked s
          | ts => Branch s (map (fun tr =>
              match tr with TR rule t s' => (rule,t,execute n s') end) ts)
          end
      end
  end.

(** Leaf membership contains all branches, rather than selecting one path. *)
Inductive tree_leaf : execution_tree -> Csem.state -> Prop :=
| leaf_return : forall v m, tree_leaf (Returned v m) (Returnstate v Kstop m)
| leaf_undefined : forall s, tree_leaf (Undefined s) s
| leaf_blocked : forall s, tree_leaf (Blocked s) s
| leaf_exhausted : forall s, tree_leaf (Exhausted s) s
| leaf_branch : forall s children rule t tree last,
    In (rule,t,tree) children -> tree_leaf tree last ->
    tree_leaf (Branch s children) last.

Lemma terminal_leaf_identity : forall s tree last,
  terminal_tree s = Some tree -> tree_leaf tree last -> s = last.
Proof.
  destruct s; simpl; intros tree last HT HL; try discriminate.
  - destruct k; try discriminate. inversion HT; subst tree.
    inversion HL; reflexivity.
  - inversion HT; subst tree. inversion HL; reflexivity.
Qed.

Lemma terminal_no_transitions : forall s tree,
  terminal_tree s = Some tree -> transitions s = [].
Proof.
  destruct s; simpl; intros tree HT; try discriminate.
  - destruct k; try discriminate; reflexivity.
  - reflexivity.
Qed.

Theorem execute_leaf_sound : forall fuel s last,
  source_state s -> tree_leaf (execute fuel s) last ->
  star model_step tt s E0 last.
Proof.
  induction fuel as [|fuel IH]; intros s last INV HL;
    cbn [execute] in HL; destruct (terminal_tree s) as [tree|] eqn:TERM.
  - apply terminal_leaf_identity with (last:=last) in TERM; auto.
    subst; constructor.
  - inversion HL; subst; constructor.
  - apply terminal_leaf_identity with (last:=last) in TERM; auto.
    subst; constructor.
  - destruct (transitions s) as [|tr ts] eqn:TS.
    + inversion HL; subst; constructor.
    + inversion HL; subst.
      change (In (rule,t,tree)
        (map (fun x => match x with TR r u s' => (r,u,execute fuel s') end)
             (tr::ts))) in H1.
      apply in_map_iff in H1. destruct H1 as [[r u s'] [EQ IN]].
      inversion EQ; subst.
      assert (STEP: model_step tt s t s').
      { exists rule. rewrite TS. exact IN. }
      assert (CSTEP: Csem.step lowpass_ge s t s') by (apply step_exact; auto).
      destruct (source_step_invariant _ _ _ _ INV CSTEP) as [SIL INV'].
      subst t. eapply star_step; [exact STEP|eapply IH; eauto|reflexivity].
Qed.

Inductive bounded_path : nat -> Csem.state -> Csem.state -> Prop :=
| path_zero : forall s, bounded_path O s s
| path_succ : forall n s s' last,
    model_step tt s E0 s' -> bounded_path n s' last ->
    bounded_path (S n) s last.

Definition stopped (s:Csem.state) : Prop :=
  (exists tree, terminal_tree s = Some tree) \/ transitions s = [].

Theorem execute_leaf_complete : forall n s last,
  bounded_path n s last -> stopped last -> forall fuel,
  (n <= fuel)%nat -> tree_leaf (execute fuel s) last.
Proof.
  intros n s last PATH; induction PATH; intros STOP fuel LE.
  - destruct STOP as [[tree TERM]|NIL].
    + destruct fuel; cbn [execute]; rewrite TERM;
        destruct s; simpl in TERM; try discriminate;
        try (inversion TERM; subst; constructor; fail).
      all: destruct k; try discriminate; inversion TERM; subst; constructor.
    + destruct fuel; cbn [execute]; destruct (terminal_tree s) as [tree|] eqn:TERM.
      * destruct s; simpl in TERM; try discriminate;
          try (inversion TERM; subst; constructor; fail).
        destruct k; try discriminate; inversion TERM; subst; constructor.
      * constructor.
      * destruct s; simpl in TERM; try discriminate;
          try (inversion TERM; subst; constructor; fail).
        destruct k; try discriminate; inversion TERM; subst; constructor.
      * rewrite NIL; constructor.
  - destruct fuel as [|fuel]; [inversion LE|]. cbn [execute].
    destruct (terminal_tree s) as [tree|] eqn:TERM.
    + exfalso. destruct H as [r IN].
      rewrite (terminal_no_transitions _ _ TERM) in IN; contradiction.
    + destruct (transitions s) as [|tr ts] eqn:TS.
      * destruct H as [r IN]. rewrite TS in IN; contradiction.
      * destruct H as [r IN].
        eapply leaf_branch with (rule:=r) (t:=E0)
          (tree:=execute fuel s').
        -- apply in_map_iff. exists (TR r E0 s'); split; auto.
           rewrite <- TS; exact IN.
        -- apply IHPATH; auto. apply le_S_n; exact LE.
Qed.

Lemma source_star_has_bound : forall s t last,
  star Csem.step lowpass_ge s t last -> source_state s ->
  exists n, bounded_path n s last.
Proof.
  intros s t last PATH; induction PATH; intros INV.
  - exists O; constructor.
  - destruct (source_step_invariant _ _ _ _ INV H) as [SIL INV'].
    destruct (IHPATH INV') as [n BN]. exists (S n).
    econstructor; [subst; apply step_exact; eauto|exact BN].
Qed.

Theorem every_stopped_source_path_is_executable : forall filter value m t last,
  star Csem.step lowpass_ge (execution_entry filter value m) t last ->
  stopped last -> exists fuel,
    tree_leaf (execute fuel (execution_entry filter value m)) last.
Proof.
  intros filter value m t last PATH STOP.
  destruct (source_star_has_bound _ _ _ PATH
    (lowpass_start_source _ _ _)) as [fuel BN].
  exists fuel; eapply execute_leaf_complete; eauto.
Qed.

Lemma model_forever_sound : forall s T,
  source_state s -> forever model_step tt s T ->
  forever Csem.step lowpass_ge s T.
Proof.
  cofix IH; intros s T INV RUN; inversion RUN; subst.
  econstructor.
  - apply step_exact; eauto.
  - eapply IH; [eapply step_preserves_source; eauto|eassumption].
Qed.

Lemma model_forever_complete : forall s T,
  source_state s -> forever Csem.step lowpass_ge s T ->
  forever model_step tt s T.
Proof.
  cofix IH; intros s T INV RUN; inversion RUN; subst.
  econstructor.
  - apply step_exact; eauto.
  - eapply IH; [exact (proj2 (source_step_invariant _ _ _ _ INV H))|eassumption].
Qed.

Theorem all_infinite_executions_exact : forall filter value m T,
  forever model_step tt (execution_entry filter value m) T <->
  forever Csem.step lowpass_ge (execution_entry filter value m) T.
Proof.
  intros; split; intros H.
  - eapply model_forever_sound; eauto using lowpass_start_source.
  - eapply model_forever_complete; eauto using lowpass_start_source.
Qed.

(** Explicit representation relation: the primary model reuses the complete
    CompCert C state, not just the eight-field auxiliary functional snapshot.
    Thus result values, initialized/undefined byte fragments, permissions,
    block lifetime and successful writes before a fault are preserved. *)
Definition represents (source model:Csem.state) : Prop := source = model.

Theorem representation_initial : forall filter value m,
  represents (lowpass_start filter value m) (execution_entry filter value m).
Proof. reflexivity. Qed.

Theorem representation_step : forall source model t source',
  source_state source -> represents source model ->
  Csem.step lowpass_ge source t source' ->
  exists model', model_step tt model t model' /\ represents source' model'.
Proof.
  intros source model t source' INV EQ STEP; unfold represents in EQ; subst.
  exists source'; split; [apply step_exact; auto|reflexivity].
Qed.

Theorem transfer_execution_property : forall (P:val -> mem -> Prop) filter value m,
  (forall v m', star model_step tt (execution_entry filter value m)
                   E0 (Returnstate v Kstop m') -> P v m') ->
  forall v m', star Csem.step lowpass_ge (lowpass_start filter value m)
                   E0 (Returnstate v Kstop m') -> P v m'.
Proof. intros P filter value m HP v m' H; apply HP; apply all_finite_executions_exact; auto. Qed.

Theorem exhaustion_is_distinct : forall s v m,
  Exhausted s <> Returned v m.
Proof. discriminate. Qed.

Theorem returned_observation_is_exact : forall v m,
  execute O (Returnstate v Kstop m) = Returned v m.
Proof. reflexivity. Qed.

Theorem fault_preserves_predecessor : forall s rule t n,
  In (TR rule t Stuckstate) (transitions s) ->
  In (rule,t,Undefined Stuckstate)
    (map (fun tr => match tr with TR r u s' => (r,u,execute n s') end)
         (transitions s)).
Proof.
  intros; apply in_map_iff. exists (TR rule t Stuckstate); split; auto.
  destruct n; reflexivity.
Qed.

Definition state_memory (s:Csem.state) : option mem :=
  match s with
  | State _ _ _ _ m | ExprState _ _ _ _ m
  | Callstate _ _ _ m | Returnstate _ _ m => Some m
  | Stuckstate => None
  end.

Theorem normal_bits_and_memory_exact : forall filter word m result m',
  star model_step tt (execution_entry_bits filter word m) E0
       (Returnstate (Vsingle (Float32.of_bits result)) Kstop m') <->
  star Csem.step lowpass_ge (execution_entry_bits filter word m) E0
       (Returnstate (Vsingle (Float32.of_bits result)) Kstop m').
Proof. intros; apply all_finite_executions_exact. Qed.

Definition model_error_prefix (start:Csem.state) (partial:mem) : Prop :=
  exists before, star model_step tt start E0 before /\
    state_memory before = Some partial /\ model_step tt before E0 Stuckstate.
Definition source_error_prefix (start:Csem.state) (partial:mem) : Prop :=
  exists before, star Csem.step lowpass_ge start E0 before /\
    state_memory before = Some partial /\ Csem.step lowpass_ge before E0 Stuckstate.

Theorem partial_memory_at_fault_exact : forall filter value m partial,
  model_error_prefix (execution_entry filter value m) partial <->
  source_error_prefix (execution_entry filter value m) partial.
Proof.
  intros filter value m partial; split;
    intros [before [PATH [MEM STEP]]]; exists before.
  - assert (CPATH: star Csem.step lowpass_ge
        (execution_entry filter value m) E0 before)
      by (apply all_finite_executions_exact; auto).
    split; auto. split; auto. apply step_exact; auto.
    eapply lowpass_reachable_source; eauto.
  - split; [apply all_finite_executions_exact; auto|].
    split; auto. apply step_exact; auto.
    eapply lowpass_reachable_source; eauto.
Qed.

Theorem invalid_step_exact : forall s,
  source_state s ->
  ((exists rule, In (TR rule E0 Stuckstate) (transitions s)) <->
    Csem.step lowpass_ge s E0 Stuckstate).
Proof. intros; apply step_exact; assumption. Qed.

Theorem blocked_exact : forall s, source_state s ->
  (transitions s = [] <-> nostep Csem.step lowpass_ge s).
Proof.
  intros s INV; split.
  - intros NIL t s' STEP. apply step_exact in STEP; auto.
    destruct STEP as [r IN]; rewrite NIL in IN; contradiction.
  - intros STOP. destruct (transitions s) as [|[r t s'] rest] eqn:TS; auto.
    exfalso. apply (STOP t s'). apply step_exact; auto.
    exists r; rewrite TS; simpl; auto.
Qed.

Print Assumptions all_finite_executions_exact.
Print Assumptions invalid_step_exact.
Print Assumptions blocked_exact.
Print Assumptions execute_leaf_sound.
Print Assumptions execute_leaf_complete.
Print Assumptions every_stopped_source_path_is_executable.
Print Assumptions all_infinite_executions_exact.
Print Assumptions representation_step.
Print Assumptions transfer_execution_property.
Print Assumptions normal_bits_and_memory_exact.
Print Assumptions partial_memory_at_fault_exact.
