From Coq Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport.
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
  | Sifthenelse a b c => core_expr a && core_stmt b && core_stmt c
  | _ => false
  end.
Fixpoint core_cont (k: cont): bool :=
  match k with
  | Kstop => true
  | Kseq s k => core_stmt s && core_cont k
  | _ => false
  end.
Definition core_expr_cont (k: cont): bool :=
  match k with Kdo k | Kreturn k => core_cont k
 | Kifthenelse a b k => core_stmt a && core_stmt b && core_cont k
 | _ => false end.

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

