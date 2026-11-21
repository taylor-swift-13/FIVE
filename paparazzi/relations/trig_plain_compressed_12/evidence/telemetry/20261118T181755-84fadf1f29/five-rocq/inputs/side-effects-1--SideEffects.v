From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore Total PureEval.
From PprzTrigInitSupport Require Import Control.
Import ListNotations.
Local Open Scope bool_scope.

(** Syntax-only trace check.  It admits original calls, postincrements and
    compound assignments; it imposes no value or memory condition. *)
Fixpoint quiet_expr (a:expr) : bool :=
  match a with
  | Eval _ ty | Evar _ ty | Eloc _ _ _ ty
  | Esizeof _ ty | Ealignof _ ty => nv ty
  | Efield a _ ty | Evalof a ty | Ederef a ty | Eaddrof a ty
  | Eunop _ a ty | Ecast a ty | Epostincr _ a ty | Eparen a _ ty =>
      nv ty && quiet_expr a
  | Ebinop _ a b ty | Eseqand a b ty | Eseqor a b ty
  | Eassign a b ty | Eassignop _ a b _ ty | Ecomma a b ty =>
      nv ty && quiet_expr a && quiet_expr b
  | Econdition a b c ty => nv ty && quiet_expr a && quiet_expr b && quiet_expr c
  | Ecall a args ty => nv ty && quiet_expr a && quiet_exprlist args
  | Ebuiltin _ _ _ _ => false
  end
with quiet_exprlist (args:exprlist) : bool :=
  match args with Enil=>true | Econs a args=>quiet_expr a && quiet_exprlist args end.

Lemma quiet_no_builtin : forall a,
  quiet_expr a=true -> no_builtin a=true
with quiet_list_no_builtin : forall args,
  quiet_exprlist args=true -> no_builtin_list args=true.
Proof.
  induction a; simpl; intros H; core_unpack; try discriminate;
    core_build; eauto using quiet_list_no_builtin.
  induction args; simpl; intros H; core_unpack; core_build;
    eauto using quiet_no_builtin.
Qed.

Lemma quiet_context_hole : forall from to C,
  Csem.context from to C -> forall a,
  quiet_expr (C a)=true -> quiet_expr a=true
with quiet_contextlist_hole : forall from C,
  Csem.contextlist from C -> forall a,
  quiet_exprlist (C a)=true -> quiet_expr a=true.
Proof.
  induction 1; simpl; intros a Q; core_unpack; try discriminate; eauto.
  induction 1; simpl; intros a Q; core_unpack; try discriminate; eauto.
Qed.

Lemma quiet_rred : forall ge a m t a' m',
  quiet_expr a=true -> rred ge a m t a' m' -> t=E0.
Proof.
  intros ge a m t a' m' Q R; inversion R; subst; simpl in Q;
    core_unpack; try discriminate; eauto using deref_loc_silent, assign_loc_silent.
Qed.

Lemma quiet_expression_silent : forall ge f a k e m,
  quiet_expr a=true -> silent_state ge (ExprState f a k e m).
Proof.
  intros ge f a k e m Q t next [EX|ST].
  - inversion EX; subst; auto.
    eapply quiet_rred; eauto using quiet_context_hole.
  - inversion ST; reflexivity.
Qed.

Lemma quiet_singleton_total : forall ge Q f a k e m next rule,
  quiet_expr a=true ->
  Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet
    (ExprState f a k e m) = [TR rule E0 next] ->
  Total.total ge Q next -> Total.total ge Q (ExprState f a k e m).
Proof.
  intros ge Q f a k e m next rule QUIET DS END.
  eapply Control.singleton_total; eauto using quiet_expression_silent.
  apply quiet_no_builtin; exact QUIET.
Qed.
