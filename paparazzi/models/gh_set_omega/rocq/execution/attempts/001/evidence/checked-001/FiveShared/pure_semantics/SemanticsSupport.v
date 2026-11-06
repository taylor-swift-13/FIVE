(** Restricted form of the CompCert Cexec animator correctness proof.
    Original Cexec.v copyright INRIA; distributed under the CompCert license. *)
From Coq Require Import Bool List ZArith Classical String.
From compcert Require Import Axioms Coqlib Decidableplus Errors Maps Integers Floats AST Values Memory Events Globalenvs Builtins Determinism Ctypes Cop Csyntax Csem Cexec.
Import ListNotations.
Local Open Scope string_scope.
Local Open Scope list_scope.

(** Syntactic closure only: no conditions on values, memory, permissions or definedness. *)
Fixpoint no_builtin (a: expr): bool :=
  match a with
  | Ebuiltin _ _ _ _ => false
  | Efield a _ _ | Evalof a _ | Ederef a _ | Eaddrof a _
  | Eunop _ a _ | Ecast a _ | Epostincr _ a _ | Eparen a _ _ => no_builtin a
  | Ebinop _ a b _ | Eseqand a b _ | Eseqor a b _
  | Eassign a b _ | Eassignop _ a b _ _ | Ecomma a b _ => no_builtin a && no_builtin b
  | Econdition a b c _ => no_builtin a && no_builtin b && no_builtin c
  | Ecall a al _ => no_builtin a && no_builtin_list al
  | _ => true
  end
with no_builtin_list (al: exprlist): bool :=
  match al with Enil => true | Econs a al => no_builtin a && no_builtin_list al end.

Section LOCAL_EXEC.
Variable ge: genv.
Variable do_external_function do_inline_assembly:
  string -> signature -> Senv.t -> world -> list val -> mem -> option (world * trace * val * mem).
Variable e: env.
Variable w: world.
Local Notation step_expr := (Cexec.step_expr ge do_external_function do_inline_assembly e w).
Local Notation step_exprlist := (Cexec.step_exprlist ge do_external_function do_inline_assembly e w).

Local Hint Constructors context Csem.contextlist : core.
Ltac unpack_nb := repeat match goal with H: _ && _ = true |- _ => apply andb_true_iff in H; let A := fresh "NB" in let B := fresh "NB" in destruct H as [A B] end.
Ltac pure_myinv :=
  match goal with
  | [ H: False |- _ ] => destruct H
  | [ H: _ /\ _ |- _ ] => destruct H; pure_myinv
  | [ H: exists _, _ |- _ ] => destruct H; pure_myinv
  | _ => idtac
  end.
Theorem pure_step_expr_sound:
  forall a k m, no_builtin a = true -> reducts_ok ge e w k a m (step_expr k a m)
with pure_step_exprlist_sound:
  forall al m, no_builtin_list al = true -> list_reducts_ok ge e w al m (step_exprlist al m).
Proof with (try (apply not_invert_ok; simpl; intro; pure_myinv; intuition congruence; fail)).
  induction a; intros k m NB; simpl in NB; unpack_nb; try discriminate; simpl; destruct k; try (apply wrong_kind_ok; simpl; congruence).
(* Eval *)
  split; intros. tauto. simpl; congruence.
(* Evar *)
  destruct (e!x) as [[b ty']|] eqn:?.
  destruct (type_eq ty ty')...
  subst. apply topred_ok; auto. apply red_var_local; auto.
  destruct (Genv.find_symbol ge x) as [b|] eqn:?...
  apply topred_ok; auto. apply red_var_global; auto.
(* Efield *)
  destruct (is_val a) as [[v ty'] | ] eqn:?.
  rewrite (is_val_inv _ _ _ Heqo).
  destruct v...
  destruct ty'...
  (* top struct *)
  destruct (ge.(genv_cenv)!i0) as [co|] eqn:?...
  destruct (field_offset ge f (co_members co)) as [[delta bf]|] eqn:?...
  apply topred_ok; auto. eapply red_field_struct; eauto.
  (* top union *)
  destruct (ge.(genv_cenv)!i0) as [co|] eqn:?...
  destruct (union_field_offset ge f (co_members co)) as [[delta bf]|] eqn:?...
  apply topred_ok; auto. eapply red_field_union; eauto.
  (* in depth *)
  eapply incontext_ok; eauto.
(* Evalof *)
  destruct (is_loc a) as [[[[b ofs] bf] ty']  | ] eqn:?. rewrite (is_loc_inv _ _ _ _ _ Heqo).
  (* top *)
  destruct (type_eq ty ty')... subst ty'.
  destruct (do_deref_loc ge w ty m b ofs bf) as [[[w' t] v] | ] eqn:?.
  exploit do_deref_loc_sound; eauto. intros [A B].
  apply topred_ok; auto. red. split. apply red_rvalof; auto. exists w'; auto.
  apply not_invert_ok; simpl; intros; pure_myinv. exploit do_deref_loc_complete; eauto. congruence.
  (* depth *)
  eapply incontext_ok; eauto.
(* Ederef *)
  destruct (is_val a) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct v... apply topred_ok; auto. apply red_deref; auto.
  (* depth *)
  eapply incontext_ok; eauto.
(* Eaddrof *)
  destruct (is_loc a) as [[[[b ofs] bf ] ty'] | ] eqn:?. rewrite (is_loc_inv _ _ _ _ _ Heqo).
  (* top *)
  destruct bf... 
  apply topred_ok; auto. split. apply red_addrof; auto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* unop *)
  destruct (is_val a) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (sem_unary_operation op v ty' m) as [v'|] eqn:?...
  apply topred_ok; auto. split. apply red_unop; auto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* binop *)
  destruct (is_val a1) as [[v1 ty1] | ] eqn:?.
  destruct (is_val a2) as [[v2 ty2] | ] eqn:?.
  rewrite (is_val_inv _ _ _ Heqo). rewrite (is_val_inv _ _ _ Heqo0).
  (* top *)
  destruct (sem_binary_operation ge op v1 ty1 v2 ty2 m) as [v|] eqn:?...
  apply topred_ok; auto. split. apply red_binop; auto. exists w; constructor.
  (* depth *)
  eapply incontext2_ok; eauto.
  eapply incontext2_ok; eauto.
(* cast *)
  destruct (is_val a) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (sem_cast v ty' ty m) as [v'|] eqn:?...
  apply topred_ok; auto. split. apply red_cast; auto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* seqand *)
  destruct (is_val a1) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (bool_val v ty' m) as [v'|] eqn:?... destruct v'.
  apply topred_ok; auto. split. eapply red_seqand_true; eauto. exists w; constructor.
  apply topred_ok; auto. split. eapply red_seqand_false; eauto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* seqor *)
  destruct (is_val a1) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (bool_val v ty' m) as [v'|] eqn:?... destruct v'.
  apply topred_ok; auto. split. eapply red_seqor_true; eauto. exists w; constructor.
  apply topred_ok; auto. split. eapply red_seqor_false; eauto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* condition *)
  destruct (is_val a1) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (bool_val v ty' m) as [v'|] eqn:?...
  apply topred_ok; auto. split. eapply red_condition; eauto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* sizeof *)
  apply topred_ok; auto. split. apply red_sizeof. exists w; constructor.
(* alignof *)
  apply topred_ok; auto. split. apply red_alignof. exists w; constructor.
(* assign *)
  destruct (is_loc a1) as [[[[b ofs] bf] ty1] | ] eqn:?.
  destruct (is_val a2) as [[v2 ty2] | ] eqn:?.
  rewrite (is_loc_inv _ _ _ _ _ Heqo). rewrite (is_val_inv _ _ _ Heqo0).
  (* top *)
  destruct (type_eq ty1 ty)... subst ty1.
  destruct (sem_cast v2 ty2 ty m) as [v|] eqn:?...
  destruct (do_assign_loc ge w ty m b ofs bf v) as [[[[w' t] m'] v']|] eqn:?.
  exploit do_assign_loc_sound; eauto. intros [P Q].
  apply topred_ok; auto. split. eapply red_assign; eauto. exists w'; auto.
  apply not_invert_ok; simpl; intros; pure_myinv. exploit do_assign_loc_complete; eauto. congruence.
  (* depth *)
  eapply incontext2_ok; eauto.
  eapply incontext2_ok; eauto.
(* assignop *)
  destruct (is_loc a1) as [[[[b ofs] bf] ty1] | ] eqn:?.
  destruct (is_val a2) as [[v2 ty2] | ] eqn:?.
  rewrite (is_loc_inv _ _ _ _ _ Heqo). rewrite (is_val_inv _ _ _ Heqo0).
  (* top *)
  destruct (type_eq ty1 ty)... subst ty1.
  destruct (do_deref_loc ge w ty m b ofs bf) as [[[w' t] v] | ] eqn:?.
  exploit do_deref_loc_sound; eauto. intros [A B].
  apply topred_ok; auto. red. split. apply red_assignop; auto. exists w'; auto.
  apply not_invert_ok; simpl; intros; pure_myinv. exploit do_deref_loc_complete; eauto. congruence.
  (* depth *)
  eapply incontext2_ok; eauto.
  eapply incontext2_ok; eauto.
(* postincr *)
  destruct (is_loc a) as [[[[b ofs] bf] ty'] | ] eqn:?. rewrite (is_loc_inv _ _ _ _ _ Heqo).
  (* top *)
  destruct (type_eq ty' ty)... subst ty'.
  destruct (do_deref_loc ge w ty m b ofs bf) as [[[w' t] v] | ] eqn:?.
  exploit do_deref_loc_sound; eauto. intros [A B].
  apply topred_ok; auto. red. split. apply red_postincr; auto. exists w'; auto.
  apply not_invert_ok; simpl; intros; pure_myinv. exploit do_deref_loc_complete; eauto. congruence.
  (* depth *)
  eapply incontext_ok; eauto.
(* comma *)
  destruct (is_val a1) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (type_eq (typeof a2) ty)... subst ty.
  apply topred_ok; auto. split. apply red_comma; auto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.
(* call *)
  destruct (is_val a) as [[vf tyf] | ] eqn:?.
  destruct (is_val_list rargs) as [vtl | ] eqn:?.
  rewrite (is_val_inv _ _ _ Heqo). exploit is_val_list_all_values; eauto. intros ALLVAL.
  (* top *)
  destruct (classify_fun tyf) as [tyargs tyres cconv|] eqn:?...
  destruct (Genv.find_funct ge vf) as [fd|] eqn:?...
  destruct (sem_cast_arguments vtl tyargs m) as [vargs|] eqn:?...
  destruct (type_eq (type_of_fundef fd) (Tfunction tyargs tyres cconv))...
  apply topred_ok; auto. red. split; auto. eapply red_call; eauto.
  eapply sem_cast_arguments_sound; eauto.
  apply not_invert_ok; simpl; intros; pure_myinv. specialize (H ALLVAL). pure_myinv. congruence.
  apply not_invert_ok; simpl; intros; pure_myinv. specialize (H ALLVAL). pure_myinv.
  exploit sem_cast_arguments_complete; eauto. intros [vtl' [P Q]]. congruence.
  apply not_invert_ok; simpl; intros; pure_myinv. specialize (H ALLVAL). pure_myinv. congruence.
  apply not_invert_ok; simpl; intros; pure_myinv. specialize (H ALLVAL). pure_myinv. congruence.
  (* depth *)
  eapply incontext2_list_ok; eauto.
  eapply incontext2_list_ok; eauto.
(* loc *)
  split; intros. tauto. simpl; congruence.
(* paren *)
  destruct (is_val a) as [[v ty'] | ] eqn:?. rewrite (is_val_inv _ _ _ Heqo).
  (* top *)
  destruct (sem_cast v ty' tycast m) as [v'|] eqn:?...
  apply topred_ok; auto. split. apply red_paren; auto. exists w; constructor.
  (* depth *)
  eapply incontext_ok; eauto.

  induction al; simpl; intros m NB; simpl in NB; unpack_nb.
(* nil *)
  split; intros. tauto. simpl; congruence.
(* cons *)
  eapply incontext2_list_ok'; eauto.
Qed.


Lemma context_no_builtin:
  forall from to C, context from to C ->
  forall a, no_builtin (C a) = true -> no_builtin a = true
with contextlist_no_builtin:
  forall from C, contextlist from C ->
  forall a, no_builtin_list (C a) = true -> no_builtin a = true.
Proof.
  induction 1; intros a NB; simpl in NB; unpack_nb; try discriminate; eauto.
  induction 1; intros a NB; simpl in NB; unpack_nb; eauto.
Qed.
Lemma pure_not_stuckred_imm_safe:
  forall m a k,
  no_builtin a = true ->
  (forall C, ~In (C, Stuckred) (step_expr k a m)) -> imm_safe_t ge e w k a m.
Proof.
  intros m a k NB H. generalize (pure_step_expr_sound a k m NB). intros [A B].
  destruct (step_expr k a m) as [|[C rd] res] eqn:?.
  specialize (B (eq_refl _)). destruct k.
  destruct a; simpl in B; try congruence. constructor.
  destruct a; simpl in B; try congruence. constructor.
  assert (NOTSTUCK: rd <> Stuckred).
    red; intros. elim (H C); subst rd; auto with coqlib.
  exploit A. eauto with coqlib. intros [a' [k' [P [Q R]]]].
  destruct k'; destruct rd; simpl in R; intuition.
  subst a. eapply imm_safe_t_lred; eauto.
  subst a. destruct H1 as [w' PT]. eapply imm_safe_t_rred; eauto.
  subst. eapply imm_safe_t_callred; eauto.
Qed.

Lemma pure_not_imm_safe_stuck_red:
  forall m a k C,
  no_builtin (C a) = true ->
  context k RV C ->
  ~imm_safe_t ge e w k a m ->
  exists C', In (C', Stuckred) (step_expr RV (C a) m).
Proof.
  intros m a k C NB HC HN.
  destruct (classic (exists C', In (C', Stuckred) (step_expr k a m))) as [EX|NEX].
  - destruct EX as [C' IN]. exists (fun x => C (C' x)).
    eapply Cexec.step_expr_context; eauto.
  - exfalso. apply HN. apply pure_not_stuckred_imm_safe.
    + eapply context_no_builtin; eauto.
    + intros D IN. apply NEX. exists D; exact IN.
Qed.
Lemma pure_rred_topred:
  forall w' r1 m1 t r2 m2,
  no_builtin r1 = true -> rred ge r1 m1 t r2 m2 -> possible_trace w t w' ->
  exists rule, step_expr RV r1 m1 = topred (Rred rule r2 m2 t).
Proof.
  intros w' r1 m1 t r2 m2 NB HR; induction HR; simpl in NB; try discriminate; simpl; intros.
(* valof *)
  rewrite dec_eq_true.
  rewrite (do_deref_loc_complete ge _ _ _ _ _ _ _ _ _ H H0). econstructor; eauto.
(* addrof *)
  inv H. econstructor; eauto.
(* unop *)
  inv H0. rewrite H; econstructor; eauto.
(* binop *)
  inv H0. rewrite H; econstructor; eauto.
(* cast *)
  inv H0. rewrite H; econstructor; eauto.
(* seqand *)
  inv H0. rewrite H; econstructor; eauto.
  inv H0. rewrite H; econstructor; eauto.
(* seqor *)
  inv H0. rewrite H; econstructor; eauto.
  inv H0. rewrite H; econstructor; eauto.
(* condition *)
  inv H0. rewrite H; econstructor; eauto.
(* sizeof *)
  inv H. econstructor; eauto.
(* alignof *)
  inv H. econstructor; eauto.
(* assign *)
  rewrite dec_eq_true. rewrite H. rewrite (do_assign_loc_complete ge _ _ _ _ _ _ _ _ _ _ _ H0 H1).
  econstructor; eauto.
(* assignop *)
  rewrite dec_eq_true. rewrite (do_deref_loc_complete ge _ _ _ _ _ _ _ _ _ H H0).
  econstructor; eauto.
(* postincr *)
  rewrite dec_eq_true. subst. rewrite (do_deref_loc_complete ge _ _ _ _ _ _ _ _ _ H H1).
  econstructor; eauto.
(* comma *)
  inv H0. rewrite dec_eq_true. econstructor; eauto.
(* paren *)
  inv H0. rewrite H; econstructor; eauto.
Qed.

End LOCAL_EXEC.

Definition callback_free_state (S: state): Prop :=
  match S with
  | ExprState _ a _ _ _ => no_builtin a = true
  | Callstate (External _ _ _ _) _ _ _ => False
  | _ => True
  end.

Section LOCAL_STATES.
Variable ge: genv.
Variable do_external_function do_inline_assembly:
  string -> signature -> Senv.t -> world -> list val -> mem -> option (world * trace * val * mem).
Local Notation do_step := (Cexec.do_step ge do_external_function do_inline_assembly).
Local Notation step_expr := (Cexec.step_expr ge do_external_function do_inline_assembly).
Ltac myinv :=
  match goal with
  | [ |- In _ nil -> _ ] => let X := fresh "X" in intro X; elim X
  | [ |- In _ (ret _ _) -> _ ] =>
        let X := fresh "X" in
        intro X; elim X; clear X;
        [let EQ := fresh "EQ" in intro EQ; unfold ret in EQ; inv EQ; myinv | myinv]
  | [ |- In _ (_ :: nil) -> _ ] =>
        let X := fresh "X" in
        intro X; elim X; clear X; [let EQ := fresh "EQ" in intro EQ; inv EQ; myinv | myinv]
  | [ |- In _ (match ?x with Some _ => _ | None => _ end) -> _ ] => destruct x eqn:?; myinv
  | [ |- In _ (match ?x with false => _ | true => _ end) -> _ ] => destruct x eqn:?; myinv
  | [ |- In _ (match ?x with left _ => _ | right _ => _ end) -> _ ] => destruct x; myinv
  | _ => idtac
  end.

Local Hint Extern 3 => exact I : core.

Theorem pure_do_step_sound:
  forall w S rule t S',
  callback_free_state S -> In (TR rule t S') (do_step w S) ->
  Csem.step ge S t S' \/ (t = E0 /\ S' = Stuckstate /\ can_crash_world ge w S).
Proof with try (left; right; econstructor; eauto; fail).
  intros until S'. intros NB. destruct S; simpl in NB; simpl.
(* State *)
  destruct s; myinv...
  (* skip *)
  destruct k; myinv...
  (* break *)
  destruct k; myinv...
  (* continue *)
  destruct k; myinv...
  (* goto *)
  destruct p as [s' k']. myinv...
(* ExprState *)
  destruct (is_val r) as [[v ty]|] eqn:?.
  (* expression is a value *)
  rewrite (is_val_inv _ _ _ Heqo).
  destruct k; myinv...
  (* expression reduces *)
  intros. exploit list_in_map_inv; eauto. intros [[C rd] [A B]].
  generalize (pure_step_expr_sound ge do_external_function do_inline_assembly e w r RV m NB). unfold reducts_ok. intros [P Q].
  exploit P; eauto. intros [a' [k' [CTX [EQ RD]]]].
  unfold expr_final_state in A. simpl in A.
  destruct k'; destruct rd; inv A; simpl in RD; try contradiction.
  (* lred *)
  left; left; apply step_lred; auto.
  (* stuck lred *)
  exploit not_imm_safe_t; eauto. intros [R | R]; eauto.
  (* rred *)
  destruct RD. left; left; apply step_rred; auto.
  (* callred *)
  destruct RD; subst m'. left; left; apply step_call; eauto.
  (* stuck rred *)
  exploit not_imm_safe_t; eauto. intros [R | R]; eauto.
(* callstate *)
  destruct fd; simpl in NB; try contradiction; myinv.
  (* internal *)
  destruct (do_alloc_variables ge empty_env m (fn_params f ++ fn_vars f)) as [e m1] eqn:?.
  myinv. left; right; apply step_internal_function with m1. auto.
  change e with (fst (e,m1)). change m1 with (snd (e,m1)) at 2. rewrite <- Heqp.
  apply do_alloc_variables_sound. eapply sem_bind_parameters_sound; eauto.
(* returnstate *)
  destruct k; myinv...
(* stuckstate *)
  contradiction.
Qed.

Theorem pure_do_step_complete:
  forall w S t S' w',
  callback_free_state S -> possible_trace w t w' -> Csem.step ge S t S' -> exists rule, In (TR rule t S') (do_step w S).
Proof with (unfold ret; eauto with coqlib).
  intros until w'; intros NB PT H.
  destruct H.
  (* Expression step *)
  inversion H; subst; exploit estep_not_val; eauto; intro NOTVAL; simpl in NB.
(* lred *)
  unfold do_step; rewrite NOTVAL.
  exploit (lred_topred ge do_external_function do_inline_assembly e w); eauto. intros (rule & STEP).
  exists rule. change (TR rule E0 (ExprState f (C a') k e m')) with (expr_final_state f k e (C, Lred rule a' m')).
  apply in_map.
  generalize (step_expr_context ge do_external_function do_inline_assembly e w _ _ _ H1 a m). unfold reducts_incl.
  intro. replace C with (fun x => C x). apply H2.
  rewrite STEP. unfold topred; auto with coqlib.
  apply extensionality; auto.
(* rred *)
  unfold do_step; rewrite NOTVAL.
  assert (NBA: no_builtin a = true) by (eapply context_no_builtin; eauto).
  destruct (pure_rred_topred ge do_external_function do_inline_assembly e w w' a m t a' m' NBA H0 PT) as [rule STEP].
  exists rule.
  change (TR rule t (ExprState f (C a') k e m')) with (expr_final_state f k e (C, Rred rule a' m' t)).
  apply in_map.
  generalize (step_expr_context ge do_external_function do_inline_assembly e w _ _ _ H1 a m). unfold reducts_incl.
  intro. replace C with (fun x => C x). apply H2.
  rewrite STEP; unfold topred; auto with coqlib.
  apply extensionality; auto.
(* callred *)
  unfold do_step; rewrite NOTVAL.
  exploit (callred_topred ge do_external_function do_inline_assembly e w); eauto.
  intros (rule & STEP). exists rule.
  change (TR rule E0 (Callstate fd vargs (Kcall f e C ty k) m)) with (expr_final_state f k e (C, Callred rule fd vargs ty m)).
  apply in_map.
  generalize (step_expr_context ge do_external_function do_inline_assembly e w _ _ _ H1 a m). unfold reducts_incl.
  intro. replace C with (fun x => C x). apply H2.
  rewrite STEP; unfold topred; auto with coqlib.
  apply extensionality; auto.
(* stuck *)
  assert (NI: ~imm_safe_t ge e w K a m).
  { intro SI; apply H1; eapply imm_safe_t_imm_safe; eauto. }
  destruct (pure_not_imm_safe_stuck_red ge do_external_function do_inline_assembly e w m a K C NB H0 NI) as [C' IN].
  simpl do_step. rewrite NOTVAL.
  exists "step_stuck".
  change (TR "step_stuck" E0 Stuckstate) with (expr_final_state f k e (C', Stuckred)).
  apply in_map. auto.

  (* Statement step *)
  inv H; simpl in NB; try contradiction; simpl; econstructor...
  rewrite H0...
  rewrite H0...
  rewrite H0...
  destruct H0; subst s0...
  destruct H0; subst s0...
  rewrite H0...
  rewrite H0...
  rewrite pred_dec_false...
  rewrite H0...
  rewrite H0...
  destruct H0; subst x...
  rewrite H0...
  rewrite H0; rewrite H1...
  rewrite H1. red in H0. destruct k; try contradiction...
  rewrite H0...
  destruct H0; subst x...
  rewrite H0...

  (* Call step *)
  rewrite pred_dec_true; auto. rewrite (do_alloc_variables_complete ge _ _ _ _ _ H1).
  rewrite (sem_bind_parameters_complete ge _ _ _ _ _ _ H2)...
Qed.


Definition silent_state (S: state): Prop := forall t S', Csem.step ge S t S' -> t = E0.

Theorem pure_do_step_exact:
  forall w S t S', callback_free_state S -> silent_state S ->
  ((exists rule, In (TR rule t S') (do_step w S)) <-> Csem.step ge S t S').
Proof.
  intros w S t S' NB HS; split.
  - intros [rule IN]. destruct (pure_do_step_sound w S rule t S' NB IN) as [OK|[HT [SS CR]]]; auto.
    destruct CR as [u [U [ST IMP]]].
    specialize (HS _ _ ST); subst u. exfalso. apply (IMP w); constructor.
  - intros ST. apply pure_do_step_complete with (w' := w); auto.
    specialize (HS _ _ ST); subst t; constructor.
Qed.
End LOCAL_STATES.
