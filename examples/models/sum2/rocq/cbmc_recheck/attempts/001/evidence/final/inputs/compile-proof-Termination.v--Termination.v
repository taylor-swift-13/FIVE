From Stdlib Require Import List Arith Lia Wellfounded.
From compcert Require Import Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveSum2 Require Import Source.
From FiveSum2Proof Require Import SourceInvariant TerminationSpec.
From FiveShared.verification Require Import Obligations.
Import ListNotations.

Fixpoint expression_rank (a:expr) : nat :=
 match a with
 | Eval _ _ | Eloc _ _ _ _ => 0
 | Evar _ _ => 1
 | Evalof a _ | Efield a _ _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _ => S(expression_rank a)
 | Ebinop _ a b _ | Eassign a b _ => S(expression_rank a + expression_rank b)
 | _ => 0
 end.
Fixpoint statement_rank (s:statement) : nat :=
 match s with
 | Sskip | Sreturn None => 1
 | Sdo a | Sreturn(Some a) => expression_rank a + 4
 | Ssequence s1 s2 => statement_rank s1 + statement_rank s2 + 2
 | _ => 0
 end.
Fixpoint continuation_rank (k:cont) : nat :=
 match k with
 | Kseq s k => statement_rank s + continuation_rank k + 1
 | Kdo k | Kreturn k => continuation_rank k + 2
 | _ => 0
 end.
Definition state_rank (s:Csem.state) : nat :=
 match s with
 | State _ stmt k _ _ => statement_rank stmt + continuation_rank k + 1
 | ExprState _ a k _ _ => expression_rank a + continuation_rank k + 1
 | Callstate (Internal f) _ _ _ => statement_rank(fn_body f)+2
 | _ => 0
 end.

Lemma rank_lred : forall ge e a m a' m',
 core_expr a=true -> lred ge e a m a' m' -> expression_rank a' < expression_rank a.
Proof. intros; inversion H0; subst; simpl in *; lia. Qed.
Lemma rank_rred : forall ge a m t a' m',
 core_expr a=true -> rred ge a m t a' m' -> expression_rank a' < expression_rank a.
Proof. intros; inversion H0; subst; simpl in *; core_unpack; try discriminate; lia. Qed.
Lemma rank_context : forall from to C, context from to C -> forall a b,
 core_expr(C a)=true -> expression_rank b < expression_rank a ->
 expression_rank(C b) < expression_rank(C a).
Proof.
 induction 1; simpl; intros; core_unpack; try discriminate; try lia;
 match goal with IH:forall a b, _ |- _ => specialize(IH a b ltac:(assumption) ltac:(assumption));lia end.
Qed.
Lemma core_call_stop : forall k, core_cont k=true -> call_cont k=Kstop.
Proof. induction k; simpl; intros; core_unpack; try discriminate; auto. Qed.

Lemma estep_rank : forall ge s t s', source_state s -> estep ge s t s' ->
 state_rank s' < state_rank s.
Proof.
 intros ge s t s' INV STEP; inversion STEP; subst; simpl in INV;
 destruct INV as [HF [HA HK]]; simpl [state_rank].
 - pose proof(rank_lred _ _ _ _ _ _ (core_context_hole _ _ _ H0 _ HA) H) as D.
   pose proof(rank_context _ _ _ H0 _ _ HA D); lia.
 - pose proof(rank_rred _ _ _ _ _ _ (core_context_hole _ _ _ H0 _ HA) H) as D.
   pose proof(rank_context _ _ _ H0 _ _ HA D); lia.
 - exfalso; eapply core_no_callred; [exact(core_context_hole _ _ _ H0 _ HA)|exact H].
 - lia.
Qed.
Lemma sstep_rank : forall ge s t s', source_state s -> sstep ge s t s' ->
 state_rank s' < state_rank s.
Proof.
 intros ge s t s' INV STEP; inversion STEP; subst; simpl in INV;
 repeat match goal with H:_ /\ _ |- _ => destruct H end;
 core_unpack; try discriminate; simpl [state_rank statement_rank continuation_rank]; try lia.
 subst k; simpl; lia.
Qed.

Theorem source_accessible : forall s, source_state s ->
 Acc (successor sum2_ge) s.
Proof.
 apply (well_founded_induction (well_founded_ltof _ state_rank)
   (fun s => source_state s -> Acc (successor sum2_ge) s)).
 intros s IH SRC. constructor. intros next [t STEP].
 apply IH.
 - unfold ltof. destruct STEP as [ES|SS]; eauto using estep_rank,sstep_rank.
 - exact(proj2(source_step_invariant _ _ _ _ SRC STEP)).
Qed.

Theorem generated_termination_goal : TerminationSpec.Goal.
Proof.
 unfold TerminationSpec.Goal, FiveSum2.proof.Obligations.termination_goal,
   FiveShared.verification.Obligations.terminates.
 intros args m PRE. apply source_accessible.
 split; reflexivity.
Qed.
Print Assumptions generated_termination_goal.
