From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import Total PureEval.
Import ListNotations.
Local Open Scope string_scope.

Definition none_callback : string -> signature -> Senv.t -> world -> list val -> mem ->
  option(world*trace*val*mem) := fun _ _ _ _ _ _ => None.
Definition quiet : world :=
  World (fun _ _=>None) (fun _ _ _=>None) (fun _ _ _ _=>None).

Lemma statement_silent : forall ge f s k e m,
  silent_state ge (State f s k e m).
Proof.
  intros ge f s k e m t next [EX|ST]; inversion EX || inversion ST; reflexivity.
Qed.
Lemma literal_silent : forall ge f v ty k e m,
  silent_state ge (ExprState f (Eval v ty) k e m).
Proof.
  intros ge f v ty k e m t next [EX|ST].
  - pose proof (estep_not_val ge f (Eval v ty) k e m t next EX); discriminate.
  - inversion ST; reflexivity.
Qed.
Lemma internal_silent : forall ge f args k m,
  silent_state ge (Callstate (Internal f) args k m).
Proof.
  intros ge f args k m t next [EX|ST]; inversion EX || inversion ST; reflexivity.
Qed.
Lemma return_silent : forall ge v k m,
  silent_state ge (Returnstate v k m).
Proof.
  intros ge v k m t next [EX|ST]; inversion EX || inversion ST; reflexivity.
Qed.

(** The singleton is checked against Cexec's complete successor list;
    no original Csem successor is discarded. *)
Lemma singleton_total : forall ge Q s next rule,
  callback_free_state s -> silent_state ge s ->
  Cexec.do_step ge none_callback none_callback quiet s = [TR rule E0 next] ->
  Total.total ge Q next -> Total.total ge Q s.
Proof.
  intros ge Q s next rule CB SIL DS END; apply Total.total_next.
  - exists E0,next.
    apply (proj1 (pure_do_step_exact ge none_callback none_callback quiet s E0 next CB SIL)).
    exists rule; rewrite DS; simpl; auto.
  - intros t s' STEP.
    destruct (proj2 (pure_do_step_exact ge none_callback none_callback quiet s t s' CB SIL) STEP)
      as [r IN].
    rewrite DS in IN; simpl in IN; destruct IN as [EQ|BAD]; try contradiction.
    inversion EQ; subst; exact END.
Qed.

Lemma sequence_total : forall ge Q f a b k e m,
  Total.total ge Q (State f a (Kseq b k) e m) ->
  Total.total ge Q (State f (Ssequence a b) k e m).
Proof.
  intros; eapply singleton_total with (rule:="step_seq");
    eauto using statement_silent; reflexivity.
Qed.
Lemma skip_sequence_total : forall ge Q f s k e m,
  Total.total ge Q (State f s k e m) ->
  Total.total ge Q (State f Sskip (Kseq s k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_skip_seq");
    eauto using statement_silent; reflexivity.
Qed.
Lemma do_total : forall ge Q f a k e m,
  Total.total ge Q (ExprState f a (Kdo k) e m) ->
  Total.total ge Q (State f (Sdo a) k e m).
Proof.
  intros; eapply singleton_total with (rule:="step_do_1");
    eauto using statement_silent; reflexivity.
Qed.
Lemma do_value_total : forall ge Q f v ty k e m,
  Total.total ge Q (State f Sskip k e m) ->
  Total.total ge Q (ExprState f (Eval v ty) (Kdo k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_do_2");
    eauto using literal_silent; reflexivity.
Qed.

Lemma if_start_total : forall ge Q f a yes no k e m,
  Total.total ge Q (ExprState f a (Kifthenelse yes no k) e m) ->
  Total.total ge Q (State f (Sifthenelse a yes no) k e m).
Proof.
  intros; eapply singleton_total with (rule:="step_ifthenelse_1");
    eauto using statement_silent; reflexivity.
Qed.
Lemma if_value_total : forall ge Q f v ty yes no k e m choice,
  bool_val v ty m = Some choice ->
  Total.total ge Q (State f (if choice then yes else no) k e m) ->
  Total.total ge Q (ExprState f (Eval v ty) (Kifthenelse yes no k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_ifthenelse_2");
    eauto using literal_silent.
  unfold Cexec.do_step; simpl; rewrite H; reflexivity.
Qed.
Lemma if_pure_total : forall ge Q f a yes no k e m v choice,
  simple a = true -> pure_rval ge e m a = Some v ->
  bool_val v (typeof a) m = Some choice ->
  Total.total ge Q (State f (if choice then yes else no) k e m) ->
  Total.total ge Q (State f (Sifthenelse a yes no) k e m).
Proof.
  intros; apply if_start_total; eapply Total.pure_prefix_total; eauto.
  eapply if_value_total; eauto.
Qed.

Lemma while_start_total : forall ge Q f a body k e m,
  Total.total ge Q (ExprState f a (Kwhile1 a body k) e m) ->
  Total.total ge Q (State f (Swhile a body) k e m).
Proof.
  intros; eapply singleton_total with (rule:="step_while");
    eauto using statement_silent; reflexivity.
Qed.
Lemma while_false_value_total : forall ge Q f a body v ty k e m,
  bool_val v ty m = Some false ->
  Total.total ge Q (State f Sskip k e m) ->
  Total.total ge Q (ExprState f (Eval v ty) (Kwhile1 a body k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_while_false");
    eauto using literal_silent.
  unfold Cexec.do_step; simpl; rewrite H; reflexivity.
Qed.
Lemma while_true_value_total : forall ge Q f a body v ty k e m,
  bool_val v ty m = Some true ->
  Total.total ge Q (State f body (Kwhile2 a body k) e m) ->
  Total.total ge Q (ExprState f (Eval v ty) (Kwhile1 a body k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_while_true");
    eauto using literal_silent.
  unfold Cexec.do_step; simpl; rewrite H; reflexivity.
Qed.
Lemma while_false_pure_total : forall ge Q f a body k e m v,
  simple a = true -> pure_rval ge e m a = Some v ->
  bool_val v (typeof a) m = Some false ->
  Total.total ge Q (State f Sskip k e m) ->
  Total.total ge Q (State f (Swhile a body) k e m).
Proof.
  intros; apply while_start_total; eapply Total.pure_prefix_total; eauto.
  eapply while_false_value_total; eauto.
Qed.
Lemma skip_while_total : forall ge Q f a body k e m,
  Total.total ge Q (State f (Swhile a body) k e m) ->
  Total.total ge Q (State f Sskip (Kwhile2 a body k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_skip_or_continue_while");
    eauto using statement_silent; reflexivity.
Qed.

Lemma return_start_total : forall ge Q f a k e m,
  Total.total ge Q (ExprState f a (Kreturn k) e m) ->
  Total.total ge Q (State f (Sreturn (Some a)) k e m).
Proof.
  intros; eapply singleton_total with (rule:="step_return_1");
    eauto using statement_silent; reflexivity.
Qed.
Lemma return_value_total : forall ge Q f v ty k e m res mf,
  sem_cast v ty (fn_return f) m = Some res ->
  Mem.free_list m (blocks_of_env ge e) = Some mf ->
  Total.total ge Q (Returnstate res (call_cont k) mf) ->
  Total.total ge Q (ExprState f (Eval v ty) (Kreturn k) e m).
Proof.
  intros; eapply singleton_total with (rule:="step_return_2");
    eauto using literal_silent.
  unfold Cexec.do_step; simpl; rewrite H,H0; reflexivity.
Qed.
Lemma return_pure_total : forall ge Q f a k e m v res mf,
  simple a = true -> pure_rval ge e m a = Some v ->
  sem_cast v (typeof a) (fn_return f) m = Some res ->
  Mem.free_list m (blocks_of_env ge e) = Some mf ->
  Total.total ge Q (Returnstate res (call_cont k) mf) ->
  Total.total ge Q (State f (Sreturn (Some a)) k e m).
Proof.
  intros; apply return_start_total; eapply Total.pure_prefix_total; eauto.
  eapply return_value_total; eauto.
Qed.

Lemma internal_function_total : forall ge Q f args k m e m1 m2,
  list_norepet (var_names (fn_params f) ++ var_names (fn_vars f)) ->
  do_alloc_variables ge empty_env m (fn_params f ++ fn_vars f) = (e,m1) ->
  sem_bind_parameters ge quiet e m1 (fn_params f) args = Some m2 ->
  Total.total ge Q (State f (fn_body f) k e m2) ->
  Total.total ge Q (Callstate (Internal f) args k m).
Proof.
  intros; eapply singleton_total with (rule:="step_internal_function");
    eauto using internal_silent.
  unfold Cexec.do_step; rewrite pred_dec_true by exact H.
  rewrite H0,H1; reflexivity.
Qed.

Lemma return_to_caller_total : forall ge Q v f e C ty k m,
  Total.total ge Q (ExprState f (C (Eval v ty)) k e m) ->
  Total.total ge Q (Returnstate v (Kcall f e C ty k) m).
Proof.
  intros; eapply singleton_total with (rule:="step_returnstate");
    eauto using return_silent; reflexivity.
Qed.
