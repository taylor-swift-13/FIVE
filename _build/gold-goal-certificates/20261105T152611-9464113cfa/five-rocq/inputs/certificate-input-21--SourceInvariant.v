From Coq Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveSum2 Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
Import ListNotations.

(** These predicates constrain syntax only.  Values, argument lists, memories,
    allocation, initialization, alignment and permissions remain arbitrary. *)
Definition nv (ty: type) := negb (type_is_volatile ty).
Fixpoint core_expr (a: expr): bool :=
  match a with
  | Eval _ ty | Evar _ ty | Eloc _ _ _ ty => nv ty
  | Efield a _ ty | Evalof a ty | Ederef a ty | Eaddrof a ty
  | Eunop _ a ty | Ecast a ty | Eparen a _ ty => nv ty && core_expr a
  | Ebinop _ a b ty | Eassign a b ty => nv ty && core_expr a && core_expr b
  | _ => false
  end.
Fixpoint core_stmt (s: statement): bool :=
  match s with
  | Sskip | Sreturn None => true
  | Sdo a | Sreturn (Some a) => core_expr a
  | Ssequence a b => core_stmt a && core_stmt b
  | _ => false
  end.
Fixpoint core_cont (k: cont): bool :=
  match k with
  | Kstop => true
  | Kseq s k => core_stmt s && core_cont k
  | _ => false
  end.
Definition core_expr_cont (k: cont): bool :=
  match k with Kdo k | Kreturn k => core_cont k | _ => false end.

Ltac core_unpack := repeat match goal with H: _ && _ = true |- _ =>
  apply andb_true_iff in H; let A := fresh "CORE" in let B := fresh "CORE" in destruct H as [A B] end.
Ltac core_build := repeat match goal with |- _ && _ = true => apply andb_true_iff; split end.

Lemma core_expr_no_builtin:
  forall a, core_expr a = true -> no_builtin a = true.
Proof.
  induction a; simpl; intros H; core_unpack; try discriminate; core_build; eauto.
Qed.

Lemma core_context_hole:
  forall from to C, context from to C -> forall a,
  core_expr (C a) = true -> core_expr a = true.
Proof.
  induction 1; simpl; intros a HA; core_unpack; try discriminate; eauto.
Qed.

Lemma core_context_replace:
  forall from to C, context from to C -> forall a b,
  core_expr (C a) = true -> core_expr b = true -> core_expr (C b) = true.
Proof.
  induction 1; simpl; intros a b HA HB; core_unpack; try discriminate;
    core_build; eauto.
Qed.

Lemma core_lred:
  forall ge e a m a' m', core_expr a = true -> lred ge e a m a' m' -> core_expr a' = true.
Proof.
  intros ge e a m a' m' HA HR; inversion HR; subst; simpl in *; core_unpack; auto.
Qed.

Lemma deref_loc_silent:
  forall ge ty m b ofs bf t v, nv ty = true -> deref_loc ge ty m b ofs bf t v -> t = E0.
Proof.
  intros ge ty m b ofs bf t v NV HR; unfold nv in NV; apply negb_true_iff in NV.
  inversion HR; subst; auto; congruence.
Qed.
Lemma assign_loc_silent:
  forall ge ty m b ofs bf v t m' v', nv ty = true -> assign_loc ge ty m b ofs bf v t m' v' -> t = E0.
Proof.
  intros ge ty m b ofs bf v t m' v' NV HR; unfold nv in NV; apply negb_true_iff in NV.
  inversion HR; subst; auto; congruence.
Qed.
Lemma core_rred:
  forall ge a m t a' m', core_expr a = true -> rred ge a m t a' m' ->
  t = E0 /\ core_expr a' = true.
Proof.
  intros ge a m t a' m' HA HR; inversion HR; subst; simpl in HA; core_unpack; try discriminate;
    split; simpl; eauto using deref_loc_silent, assign_loc_silent.
Qed.
Lemma core_no_callred:
  forall ge a m fd args ty, core_expr a = true -> callred ge a m fd args ty -> False.
Proof. intros ge a m fd args ty HA HR; inversion HR; subst; discriminate. Qed.

Lemma core_cont_call:
  forall k, core_cont k = true -> call_cont k = Kstop.
Proof.
  induction k; simpl; intros H; core_unpack; try discriminate; auto.
Qed.
Lemma core_cont_is_call:
  forall k, core_cont k = true -> is_call_cont k -> k = Kstop.
Proof. destruct k; simpl; intros; try discriminate; tauto. Qed.

Definition sum2_function := Source.f_sum2.
Definition sum2_ge := Csem.globalenv Source.prog.
Definition source_state (S: Csem.state): Prop :=
  match S with
  | State f s k _ _ => f = sum2_function /\ core_stmt s = true /\ core_cont k = true
  | ExprState f a k _ _ => f = sum2_function /\ core_expr a = true /\ core_expr_cont k = true
  | Callstate fd _ k _ => fd = Internal sum2_function /\ k = Kstop
  | Returnstate _ k _ => k = Kstop
  | Stuckstate => True
  end.

Lemma sum2_body_core: core_stmt (fn_body sum2_function) = true.
Proof. vm_compute; reflexivity. Qed.

Lemma source_callback_free:
  forall S, source_state S -> callback_free_state S.
Proof.
  destruct S; simpl; intros H; intuition try discriminate.
  - eapply core_expr_no_builtin; eauto.
  - destruct fd; simpl; auto; congruence.
Qed.

Lemma source_estep:
  forall ge S t S', source_state S -> estep ge S t S' -> t = E0 /\ source_state S'.
Proof.
  intros ge S t S' INV STEP; inversion STEP; subst; simpl in INV; destruct INV as [HF [HA HK]].
  - split; auto. simpl; repeat split; auto.
    eapply (core_context_replace LV RV C H0 a a' HA).
    eapply core_lred; [exact (core_context_hole LV RV C H0 a HA)|exact H].
  - assert (Hcore: core_expr a = true) by (exact (core_context_hole RV RV C H0 a HA)).
    destruct (core_rred _ _ _ _ _ _ Hcore H) as [HT HA']; split; auto.
    simpl; repeat split; auto. exact (core_context_replace RV RV C H0 a a' HA HA').
  - exfalso. eapply core_no_callred; [exact (core_context_hole RV RV C H0 a HA)|exact H].
  - split; auto; exact I.
Qed.

Lemma source_sstep:
  forall ge S t S', source_state S -> sstep ge S t S' -> t = E0 /\ source_state S'.
Proof.
  intros ge S t S' INV STEP; inversion STEP; subst; simpl in INV; try tauto;
    repeat match goal with H: _ /\ _ |- _ => destruct H end;
    core_unpack; try discriminate; split; auto; simpl;
    try (repeat split; auto; fail).
  - repeat split; auto. apply andb_true_iff; auto.
  - apply core_cont_call; assumption.
  - apply core_cont_call; assumption.
  - eapply core_cont_is_call; eauto.
  - assert (HF: f = sum2_function) by congruence. subst f; subst k.
    repeat split; auto using sum2_body_core.
Qed.

Theorem source_step_invariant:
  forall ge S t S', source_state S -> Csem.step ge S t S' -> t = E0 /\ source_state S'.
Proof. intros ge S t S' INV [H|H]; eauto using source_estep, source_sstep. Qed.

Theorem source_silent:
  forall ge S, source_state S -> silent_state ge S.
Proof. intros ge S INV t S' H; exact (proj1 (source_step_invariant _ _ _ _ INV H)). Qed.

Theorem source_do_step_exact:
  forall cb asm w S t S', source_state S ->
  ((exists rule, In (TR rule t S') (Cexec.do_step sum2_ge cb asm w S)) <-> Csem.step sum2_ge S t S').
Proof.
  intros; apply pure_do_step_exact; eauto using source_callback_free, source_silent.
Qed.

Definition sum2_start (a b:val) (m:mem):Csem.state :=
  Callstate (Internal sum2_function) [a;b] Kstop m.
Theorem sum2_start_source: forall a b m,source_state(sum2_start a b m).
Proof. intros;split;reflexivity. Qed.
