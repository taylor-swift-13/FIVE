From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Csyntax Csem Cexec Cstrategy.
From PprzTrigRelationSupport Require Import PureEval PureProgress.

Lemma simple_bigstep_self : forall ge e m,
  (forall a v, eval_simple_rvalue ge e m a v ->
     Cstrategy.eval_expr ge e m RV a E0 m a) /\
  (forall a b ofs bf, eval_simple_lvalue ge e m a b ofs bf ->
     Cstrategy.eval_expr ge e m LV a E0 m a).
Proof.
  intros ge e m; apply eval_simple_rvalue_lvalue_ind; intros;
    eauto using Cstrategy.eval_val, Cstrategy.eval_valof,
      Cstrategy.eval_addrof, Cstrategy.eval_unop, Cstrategy.eval_binop,
      Cstrategy.eval_cast, Cstrategy.eval_sizeof, Cstrategy.eval_alignof,
      Cstrategy.eval_var, Cstrategy.eval_deref, Cstrategy.eval_field.
Qed.

Theorem pure_expression_bigstep : forall ge e m a v,
  Cstrategy.simple a = true -> PureEval.pure_rval ge e m a = Some v ->
  Cstrategy.eval_expression ge e m a E0 m v.
Proof.
  intros ge e m a v SIMPLE EV.
  pose proof (proj1 (PureProgress.pure_eval_big a ge e m SIMPLE) v EV) as BIG.
  econstructor.
  - eapply (proj1 (simple_bigstep_self ge e m)); exact BIG.
  - exact BIG.
Qed.
