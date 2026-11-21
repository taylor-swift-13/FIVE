From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
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
  - inversion EX; subst; try reflexivity.
    eapply quiet_rred.
    + eapply quiet_context_hole; eauto.
    + eassumption.
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

Lemma quiet_successors_total : forall ge Q f a k e m,
  quiet_expr a=true ->
  (exists rule t next,
    In (TR rule t next)
      (Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet
        (ExprState f a k e m))) ->
  (forall rule t next,
    In (TR rule t next)
      (Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet
        (ExprState f a k e m)) -> Total.total ge Q next) ->
  Total.total ge Q (ExprState f a k e m).
Proof.
  intros ge Q f a k e m QUIET [rule [t [next IN]]] ALL.
  assert (CB: callback_free_state (ExprState f a k e m)).
  { apply quiet_no_builtin; exact QUIET. }
  assert (SIL: silent_state ge (ExprState f a k e m))
    by (apply quiet_expression_silent; exact QUIET).
  apply Total.total_next.
  - exists t,next.
    apply (proj1 (pure_do_step_exact ge Control.none_callback Control.none_callback
      Control.quiet _ _ _ CB SIL)); exists rule; exact IN.
  - intros u s STEP.
    destruct (proj2 (pure_do_step_exact ge Control.none_callback Control.none_callback
      Control.quiet _ _ _ CB SIL) STEP) as [r R].
    eapply ALL; exact R.
Qed.

Lemma postincr_variable_total : forall ge Q f id x ty k e m b,
  nv ty=true -> e!x=Some(b,ty) ->
  Total.total ge Q (ExprState f (Epostincr id (Eloc b Ptrofs.zero Full ty) ty) k e m) ->
  Total.total ge Q (ExprState f (Epostincr id (Evar x ty) ty) k e m).
Proof.
  intros ge Q f id x ty k e m b NV ENV END.
  eapply quiet_singleton_total.
  - cbn [quiet_expr]; rewrite NV; reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite ENV,dec_eq_true; reflexivity.
  - exact END.
Qed.

Lemma postincr_head_total : forall ge Q f id b ofs bf ty k e m v,
  nv ty=true ->
  Cexec.do_deref_loc ge Control.quiet ty m b ofs bf = Some(Control.quiet,E0,v) ->
  Total.total ge Q
    (ExprState f
      (Ecomma
        (Eassign (Eloc b ofs bf ty)
          (Ebinop (match id with Incr=>Oadd | Decr=>Osub end)
            (Eval v ty) (Eval (Vint Int.one) type_int32s) (incrdecr_type ty)) ty)
        (Eval v ty) ty) k e m) ->
  Total.total ge Q (ExprState f (Epostincr id (Eloc b ofs bf ty) ty) k e m).
Proof.
  intros ge Q f id b ofs bf ty k e m v NV DEREF END.
  eapply quiet_singleton_total.
  - cbn [quiet_expr]; rewrite NV; reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite dec_eq_true,DEREF; reflexivity.
  - exact END.
Qed.

Lemma assignop_head_total : forall ge Q f op b ofs bf ty v2 ty2 tyres k e m v1,
  nv ty=true -> nv ty2=true ->
  Cexec.do_deref_loc ge Control.quiet ty m b ofs bf = Some(Control.quiet,E0,v1) ->
  Total.total ge Q
    (ExprState f (Eassign (Eloc b ofs bf ty)
      (Ebinop op (Eval v1 ty) (Eval v2 ty2) tyres) ty) k e m) ->
  Total.total ge Q
    (ExprState f (Eassignop op (Eloc b ofs bf ty) (Eval v2 ty2) tyres ty) k e m).
Proof.
  intros ge Q f op b ofs bf ty v2 ty2 tyres k e m v1 NV NV2 DEREF END.
  eapply quiet_singleton_total.
  - cbn [quiet_expr]; rewrite NV,NV2; reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite dec_eq_true,DEREF; reflexivity.
  - exact END.
Qed.

Lemma comma_head_total : forall ge Q f v ty1 a ty k e m,
  nv ty=true -> nv ty1=true -> quiet_expr a=true -> typeof a=ty ->
  Total.total ge Q (ExprState f a k e m) ->
  Total.total ge Q (ExprState f (Ecomma (Eval v ty1) a ty) k e m).
Proof.
  intros ge Q f v ty1 a ty k e m NV NV1 QUIET TY END.
  eapply quiet_singleton_total.
  - cbn [quiet_expr]; rewrite NV,NV1,QUIET; reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite TY,dec_eq_true; reflexivity.
  - exact END.
Qed.

Lemma paren_head_total : forall ge Q f v ty1 castty ty k e m res,
  nv ty=true -> nv ty1=true ->
  sem_cast v ty1 castty m=Some res ->
  Total.total ge Q (ExprState f (Eval res ty) k e m) ->
  Total.total ge Q (ExprState f (Eparen (Eval v ty1) castty ty) k e m).
Proof.
  intros ge Q f v ty1 castty ty k e m res NV NV1 CAST END.
  eapply quiet_singleton_total.
  - cbn [quiet_expr]; rewrite NV,NV1; reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite CAST; reflexivity.
  - exact END.
Qed.
