From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import Total PureEval.
From PprzTrigInitSupport Require Import Control.
Import ListNotations.

Definition nibble_expr :=
  match fn_body Source.f_get_nibble with
  | Sreturn (Some a)=>a | _=>Eval Vundef Tvoid
  end.
Lemma nibble_body_shape : fn_body Source.f_get_nibble=Sreturn (Some nibble_expr).
Proof. reflexivity. Qed.
Lemma nibble_expr_simple : simple nibble_expr=true.
Proof. vm_compute; reflexivity. Qed.

Theorem get_nibble_body_total : forall Q k e m result returned mf,
  pure_rval (Csem.globalenv Source.prog) e m nibble_expr=Some result ->
  sem_cast result (typeof nibble_expr) (fn_return Source.f_get_nibble) m=Some returned ->
  Mem.free_list m (blocks_of_env (Csem.globalenv Source.prog) e)=Some mf ->
  Total.total (Csem.globalenv Source.prog) Q (Returnstate returned (call_cont k) mf) ->
  Total.total (Csem.globalenv Source.prog) Q
    (State Source.f_get_nibble (fn_body Source.f_get_nibble) k e m).
Proof.
  intros; rewrite nibble_body_shape.
  eapply Control.return_pure_total; eauto using nibble_expr_simple.
Qed.

Theorem get_nibble_call_total : forall Q args k m e m0 m1 result returned mf,
  do_alloc_variables (Csem.globalenv Source.prog) empty_env m
    (fn_params Source.f_get_nibble ++ fn_vars Source.f_get_nibble)=(e,m0) ->
  sem_bind_parameters (Csem.globalenv Source.prog) Control.quiet e m0
    (fn_params Source.f_get_nibble) args=Some m1 ->
  pure_rval (Csem.globalenv Source.prog) e m1 nibble_expr=Some result ->
  sem_cast result (typeof nibble_expr) (fn_return Source.f_get_nibble) m1=Some returned ->
  Mem.free_list m1 (blocks_of_env (Csem.globalenv Source.prog) e)=Some mf ->
  Total.total (Csem.globalenv Source.prog) Q (Returnstate returned (call_cont k) mf) ->
  Total.total (Csem.globalenv Source.prog) Q
    (Callstate (Internal Source.f_get_nibble) args k m).
Proof.
  intros; eapply Control.internal_function_total; eauto.
  - vm_compute; repeat constructor; simpl; intuition discriminate.
  - eapply get_nibble_body_total; eauto.
Qed.
