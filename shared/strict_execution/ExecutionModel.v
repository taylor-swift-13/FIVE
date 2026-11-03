From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Events Globalenvs Determinism Smallstep Ctypes Cop Csyntax.
From FiveShared.compcert_libc Require Import Library.
From FiveShared.strict_execution Require Import Source.
From compcert Require Import Csem.
From compcert Require Import Cexec.
From FiveShared.strict_execution Require Import SourceInvariant.
Import ListNotations.

(** Full executable embedding of original Csyntax, no input preconditions.
    The relational target and executable animator are distinct definitions;
    Cexec's complete correctness proofs are instantiated below. *)
Definition closed_world : world :=
  World (fun _ _ => None) (fun _ _ _ => None) (fun _ _ _ _ => None).
Definition transitions (s:Csem.state) : list Cexec.transition :=
  Cexec.do_step source_ge Library.do_external_function
    Library.do_inline_assembly closed_world s.

Inductive selected_function := Addition | AdditionStore | BubbleSort.
Definition selected_body (which:selected_function) : function :=
 match which with
 | Addition => Source.f_five_add
 | AdditionStore => Source.f_five_add_store
 | BubbleSort => Source.f_five_bubble_sort
 end.
Definition execution_entry (which:selected_function) (args:list val) (m:mem) :=
  Callstate (Internal (selected_body which)) args Kstop m.
Lemma entry_source : forall which args m, source_state (execution_entry which args m).
Proof. intros; destruct which; split; try exact I; vm_compute; reflexivity. Qed.
Definition add_bits_entry (a b:int) (m:mem) :=
 execution_entry Addition [Vsingle (Float32.of_bits a);Vsingle (Float32.of_bits b)] m.
Definition add_store_bits_entry (a b:int) (dst:val) (m:mem) :=
 execution_entry AdditionStore [Vsingle (Float32.of_bits a);Vsingle (Float32.of_bits b);dst] m.
Definition bubble_bits_entry (a:val) (n:int64) (m:mem) :=
 execution_entry BubbleSort [a;Vlong n] m.
Theorem all_input_bits_preserved : forall word,
 Float32.to_bits (Float32.of_bits word) = word.
Proof. apply Float32.to_of_bits. Qed.

Definition model_step (_:unit) (s:Csem.state) (t:trace) (s':Csem.state) : Prop :=
 exists rule, In (TR rule t s') (transitions s).
Section ExternalEnvironment.
Context {Henv:Library.environment}.
Theorem step_exact : forall s t s', source_state s ->
 (model_step tt s t s' <-> Csem.step source_ge s t s').
Proof.
 intros s t s' INV; split.
 - intros [rule IN].
   destruct (Cexec.do_step_sound source_ge
     Library.do_external_function Library.do_external_sound Library.do_external_complete
     Library.do_inline_assembly Library.do_inline_sound Library.do_inline_complete
     closed_world s rule t s' IN) as [OK|[HT [SS CR]]]; auto.
   destruct CR as [u [U [ST IMP]]].
   specialize (source_silent s INV _ _ ST); intros SIL; subst u.
   exfalso; apply (IMP closed_world); constructor.
 - intros ST. eapply Cexec.do_step_complete;
     eauto using Library.do_external_sound, Library.do_external_complete,
       Library.do_inline_sound, Library.do_inline_complete.
   specialize (source_silent s INV _ _ ST); intros SIL; subst t; constructor.
Qed.
Theorem step_preserves_source : forall s t s',
 source_state s -> model_step tt s t s' -> source_state s'.
Proof.
 intros s t s' INV STEP; apply step_exact in STEP; auto.
 exact (proj2 (source_step_invariant _ _ _ INV STEP)).
Qed.
Theorem model_star_sound : forall s t s',
 star model_step tt s t s' -> source_state s -> star Csem.step source_ge s t s'.
Proof.
 intros s t s' PATH; induction PATH; intros INV; [constructor|].
 eapply star_step; [apply step_exact; eassumption| |eassumption].
 apply IHPATH; eapply step_preserves_source; eauto.
Qed.
Theorem model_star_complete : forall s t s',
 star Csem.step source_ge s t s' -> source_state s -> star model_step tt s t s'.
Proof.
 intros s t s' PATH; induction PATH; intros INV; [constructor|].
 eapply star_step; [apply step_exact; eauto| |eassumption].
 apply IHPATH; exact (proj2 (source_step_invariant _ _ _ INV H)).
Qed.
Theorem all_finite_executions_exact : forall which args m t s,
 star model_step tt (execution_entry which args m) t s <->
 star Csem.step source_ge (execution_entry which args m) t s.
Proof.
 intros; split; intros H;
 [eapply model_star_sound|eapply model_star_complete]; eauto using entry_source.
Qed.

Lemma entry_reachable_source : forall which args m s t,
 star Csem.step source_ge (execution_entry which args m) t s -> source_state s.
Proof.
 intros which args m s t PATH.
 remember (execution_entry which args m) as initial.
 assert (INV:source_state initial) by (subst; apply entry_source).
 clear Heqinitial; induction PATH; auto.
 apply IHPATH; exact (proj2 (source_step_invariant _ _ _ INV H)).
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
      assert (CSTEP: Csem.step source_ge s t s') by (apply step_exact; auto).
      destruct (source_step_invariant _ _ _ INV CSTEP) as [SIL INV'].
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
  star Csem.step source_ge s t last -> source_state s ->
  exists n, bounded_path n s last.
Proof.
  intros s t last PATH; induction PATH; intros INV.
  - exists O; constructor.
  - destruct (source_step_invariant _ _ _ INV H) as [SIL INV'].
    destruct (IHPATH INV') as [n BN]. exists (S n).
    econstructor; [subst; apply step_exact; eauto|exact BN].
Qed.

Theorem every_stopped_source_path_is_executable : forall which args m t last,
  star Csem.step source_ge (execution_entry which args m) t last ->
  stopped last -> exists fuel,
    tree_leaf (execute fuel (execution_entry which args m)) last.
Proof.
  intros which args m t last PATH STOP.
  destruct (source_star_has_bound _ _ _ PATH
    (entry_source _ _ _)) as [fuel BN].
  exists fuel; eapply execute_leaf_complete; eauto.
Qed.

Lemma model_forever_sound : forall s T,
  source_state s -> forever model_step tt s T ->
  forever Csem.step source_ge s T.
Proof.
  cofix IH; intros s T INV RUN; inversion RUN; subst.
  econstructor.
  - apply step_exact; eauto.
  - eapply IH; [eapply step_preserves_source; eauto|eassumption].
Qed.

Lemma model_forever_complete : forall s T,
  source_state s -> forever Csem.step source_ge s T ->
  forever model_step tt s T.
Proof.
  cofix IH; intros s T INV RUN; inversion RUN; subst.
  econstructor.
  - apply step_exact; eauto.
  - eapply IH; [exact (proj2 (source_step_invariant _ _ _ INV H))|eassumption].
Qed.

Theorem all_infinite_executions_exact : forall which args m T,
  forever model_step tt (execution_entry which args m) T <->
  forever Csem.step source_ge (execution_entry which args m) T.
Proof.
  intros; split; intros H.
  - eapply model_forever_sound; eauto using entry_source.
  - eapply model_forever_complete; eauto using entry_source.
Qed.

(** Explicit representation relation: the primary model reuses the complete
    CompCert C state, including the full control stack and memory.
    Thus result values, initialized/undefined byte fragments, permissions,
    block lifetime and successful writes before a fault are preserved. *)
Definition represents (source model:Csem.state) : Prop := source = model.

Theorem representation_initial : forall which args m,
  represents (execution_entry which args m) (execution_entry which args m).
Proof. reflexivity. Qed.

Theorem representation_step : forall source model t source',
  source_state source -> represents source model ->
  Csem.step source_ge source t source' ->
  exists model', model_step tt model t model' /\ represents source' model'.
Proof.
  intros source model t source' INV EQ STEP; unfold represents in EQ; subst.
  exists source'; split; [apply step_exact; auto|reflexivity].
Qed.

Theorem transfer_execution_property : forall (P:val -> mem -> Prop) which args m,
  (forall v m', star model_step tt (execution_entry which args m)
                   E0 (Returnstate v Kstop m') -> P v m') ->
  forall v m', star Csem.step source_ge (execution_entry which args m)
                   E0 (Returnstate v Kstop m') -> P v m'.
Proof. intros P which args m HP v m' H; apply HP; apply all_finite_executions_exact; auto. Qed.

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

Theorem normal_bits_and_memory_exact : forall which args m v m',
 star model_step tt (execution_entry which args m) E0 (Returnstate v Kstop m') <->
 star Csem.step source_ge (execution_entry which args m) E0 (Returnstate v Kstop m').
Proof. intros; apply all_finite_executions_exact. Qed.

Definition model_error_prefix (start:Csem.state) (partial:mem) : Prop :=
  exists before, star model_step tt start E0 before /\
    state_memory before = Some partial /\ model_step tt before E0 Stuckstate.
Definition source_error_prefix (start:Csem.state) (partial:mem) : Prop :=
  exists before, star Csem.step source_ge start E0 before /\
    state_memory before = Some partial /\ Csem.step source_ge before E0 Stuckstate.

Theorem partial_memory_at_fault_exact : forall which args m partial,
  model_error_prefix (execution_entry which args m) partial <->
  source_error_prefix (execution_entry which args m) partial.
Proof.
  intros which args m partial; split;
    intros [before [PATH [MEM STEP]]]; exists before.
  - assert (CPATH: star Csem.step source_ge
        (execution_entry which args m) E0 before)
      by (apply all_finite_executions_exact; auto).
    split; auto. split; auto. apply step_exact; auto.
    eapply entry_reachable_source; eauto.
  - split; [apply all_finite_executions_exact; auto|].
    split; auto. apply step_exact; auto.
    eapply entry_reachable_source; eauto.
Qed.

Theorem invalid_step_exact : forall s,
  source_state s ->
  ((exists rule, In (TR rule E0 Stuckstate) (transitions s)) <->
    Csem.step source_ge s E0 Stuckstate).
Proof. intros; apply step_exact; assumption. Qed.

Theorem blocked_exact : forall s, source_state s ->
  (transitions s = [] <-> nostep Csem.step source_ge s).
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

(** Generic error definition includes explicit stuck and nonfinal semantic
    no-step. Library-access failure can be a blocked external call. *)
Definition normal_return (s:Csem.state) : Prop :=
 exists v m, s = Returnstate v Kstop m.
Definition source_error (s:Csem.state) : Prop :=
 ~ normal_return s /\ nostep Csem.step source_ge s.
Definition model_error (s:Csem.state) : Prop :=
 ~ normal_return s /\ transitions s = [].
Theorem error_state_exact : forall s, source_state s ->
 (model_error s <-> source_error s).
Proof. intros s INV; unfold model_error,source_error; rewrite (blocked_exact s INV); tauto. Qed.
Theorem all_error_executions_exact : forall which args m,
 (exists s t, star model_step tt (execution_entry which args m) t s /\ model_error s) <->
 (exists s t, star Csem.step source_ge (execution_entry which args m) t s /\ source_error s).
Proof.
 intros; split; intros [s[t[PATH ERR]]]; exists s,t.
 - assert (CP:star Csem.step source_ge (execution_entry which args m) t s)
     by (apply all_finite_executions_exact; exact PATH).
   split; auto; apply error_state_exact; auto; eapply entry_reachable_source; eauto.
 - split; [apply all_finite_executions_exact; exact PATH|].
   apply error_state_exact; auto; eapply entry_reachable_source; eauto.
Qed.
Theorem blocked_error_memory_exact : forall which args m partial,
 (exists s t, star model_step tt (execution_entry which args m) t s /\
   model_error s /\ state_memory s = Some partial) <->
 (exists s t, star Csem.step source_ge (execution_entry which args m) t s /\
   source_error s /\ state_memory s = Some partial).
Proof.
 intros; split; intros [s[t[PATH[ERR MEM]]]]; exists s,t.
 - assert (CP:star Csem.step source_ge (execution_entry which args m) t s)
     by (apply all_finite_executions_exact; exact PATH).
   split; auto; split; auto; apply error_state_exact; auto;
     eapply entry_reachable_source; eauto.
 - split; [apply all_finite_executions_exact; exact PATH|].
   split; auto; apply error_state_exact; auto; eapply entry_reachable_source; eauto.
Qed.
Theorem add_complete_execution : forall a b m t s,
 star model_step tt (add_bits_entry a b m) t s <->
 star Csem.step source_ge (add_bits_entry a b m) t s.
Proof. intros; apply all_finite_executions_exact. Qed.
Theorem add_store_complete_execution : forall a b dst m t s,
 star model_step tt (add_store_bits_entry a b dst m) t s <->
 star Csem.step source_ge (add_store_bits_entry a b dst m) t s.
Proof. intros; apply all_finite_executions_exact. Qed.
Theorem bubble_complete_execution : forall a n m t s,
 star model_step tt (bubble_bits_entry a n m) t s <->
 star Csem.step source_ge (bubble_bits_entry a n m) t s.
Proof. intros; apply all_finite_executions_exact. Qed.
Print Assumptions step_exact.
Print Assumptions all_error_executions_exact.
Print Assumptions bubble_complete_execution.

End ExternalEnvironment.
