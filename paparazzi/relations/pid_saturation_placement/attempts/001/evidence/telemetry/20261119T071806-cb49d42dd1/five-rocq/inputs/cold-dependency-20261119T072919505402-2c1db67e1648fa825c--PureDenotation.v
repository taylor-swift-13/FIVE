From Coq Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport.
From FiveGuidanceAllOrder Require Import PureSyntax.
Import ListNotations.

(** This denotation is used to establish uniqueness of normal executions.
    Execution remains the complete error-preserving operational model. *)
Definition quiet_world: world := World (fun _ _ => None) (fun _ _ _ => None) (fun _ _ _ _ => None).

Section DENOTATION.
Variable ge: genv.
Variable e: env.
Variable m: mem.

Fixpoint pure_rval (a: expr): option val :=
  match a with
  | Eval v _ => Some v
  | Evalof l ty =>
      if type_eq ty (typeof l) then
      match pure_lval l with
      | Some (b,ofs,bf) =>
          match Cexec.do_deref_loc ge quiet_world ty m b ofs bf with
          | Some (_,_,v) => Some v | None => None end
      | None => None end else None
  | Eaddrof l _ =>
      match pure_lval l with Some (b,ofs,Full) => Some (Vptr b ofs) | _ => None end
  | Eunop op a _ =>
      match pure_rval a with Some v => sem_unary_operation op v (typeof a) m | None => None end
  | Ebinop op a b _ =>
      match pure_rval a, pure_rval b with
      | Some v, Some w => sem_binary_operation ge op v (typeof a) w (typeof b) m
      | _,_ => None end
  | Ecast a ty =>
      match pure_rval a with Some v => sem_cast v (typeof a) ty m | None => None end
  | Esizeof ty _ => Some (Vptrofs (Ptrofs.repr (sizeof ge ty)))
  | Ealignof ty _ => Some (Vptrofs (Ptrofs.repr (alignof ge ty)))
  | _ => None
  end
with pure_lval (a: expr): option (block * ptrofs * bitfield) :=
  match a with
  | Eloc b ofs bf _ => Some (b,ofs,bf)
  | Evar id ty =>
      match PTree.get id e with
      | Some (b,ty') => if type_eq ty ty' then Some (b,Ptrofs.zero,Full) else None
      | None => match Genv.find_symbol ge id with Some b => Some (b,Ptrofs.zero,Full) | None => None end end
  | Ederef a _ =>
      match pure_rval a with Some (Vptr b ofs) => Some (b,ofs,Full) | _ => None end
  | Efield a id _ =>
      match pure_rval a with
      | Some (Vptr b ofs) =>
          match typeof a with
          | Tstruct sid _ =>
              match PTree.get sid (genv_cenv ge) with
              | Some co => match field_offset ge id (co_members co) with
                | OK (delta,bf) => Some (b,Ptrofs.add ofs (Ptrofs.repr delta),bf)
                | _ => None end
              | None => None end
          | Tunion sid _ =>
              match PTree.get sid (genv_cenv ge) with
              | Some co => match union_field_offset ge id (co_members co) with
                | OK (delta,bf) => Some (b,Ptrofs.add ofs (Ptrofs.repr delta),bf)
                | _ => None end
              | None => None end
          | _ => None end
      | _ => None end
  | _ => None
  end.

Definition pure_eq (k: kind) (a b: expr): Prop :=
  match k with RV => pure_rval a = pure_rval b | LV => pure_lval a = pure_lval b end.

Lemma context_type_eq:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> typeof (C a) = typeof (C b).
Proof. induction 1; simpl; intros; auto. Qed.

Lemma pure_context_congr:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> pure_eq from a b -> pure_eq to (C a) (C b).
Proof.
  induction 1; simpl; intros a b HT HE; auto;
    try (rewrite (IHcontext a b HT HE); reflexivity);
    try (rewrite (context_type_eq _ _ _ H a b HT), (IHcontext a b HT HE); reflexivity).
Qed.

End DENOTATION.

Lemma simple_context_hole:
  forall from to C, context from to C -> forall a,
  simple (C a) = true -> simple a = true.
Proof.
  induction 1; simpl; intros a HA; core_unpack; try discriminate; eauto.
Qed.

Lemma pure_lred:
  forall ge e a m a' m', lred ge e a m a' m' ->
  m' = m /\ typeof a' = typeof a /\ simple a' = true /\
  pure_lval ge e m a = pure_lval ge e m a'.
Proof.
  intros ge e a m a' m' H; inversion H; subst; simpl; repeat split; auto;
    try rewrite H0; try rewrite H1; try rewrite H2; try rewrite dec_eq_true; auto.
Qed.

Lemma pure_rred:
  forall ge e a m t a' m', simple a = true -> rred ge a m t a' m' ->
  m' = m /\ t = E0 /\ typeof a' = typeof a /\ simple a' = true /\
  pure_rval ge e m a = pure_rval ge e m a'.
Proof.
  intros ge e a m t a' m' HA HR; inversion HR; subst; simpl in HA; core_unpack; try discriminate;
    simpl; repeat split; auto; try rewrite H; auto.
  - eapply deref_loc_silent; eauto.
  - assert (HT: t = E0) by (eapply deref_loc_silent; eauto). subst t.
    rewrite dec_eq_true.
    rewrite (do_deref_loc_complete ge quiet_world ty m' b ofs bf quiet_world E0 v H (possible_trace_nil _)).
    reflexivity.
Qed.

Definition flat_expr (a: expr): bool :=
  match a with Eassign l r _ => simple l && simple r | _ => simple a end.

Definition flat_eval (ge: genv) (e: env) (m: mem) (a: expr): option (val * mem) :=
  match a with
  | Eassign l r ty =>
      if type_eq (typeof l) ty then
      match pure_lval ge e m l, pure_rval ge e m r with
      | Some (b,ofs,bf), Some v =>
          match sem_cast v (typeof r) (typeof l) m with
          | Some v => match Cexec.do_assign_loc ge quiet_world (typeof l) m b ofs bf v with
              | Some (_,_,m',v') => Some (v',m') | None => None end
          | None => None end
      | _,_ => None end else None
  | _ => match pure_rval ge e m a with Some v => Some (v,m) | None => None end
  end.

Lemma flat_of_simple:
  forall a, simple a = true -> flat_expr a = true.
Proof. destruct a; simpl; auto; discriminate. Qed.

Lemma flat_eval_simple:
  forall ge e m a, simple a = true ->
  flat_eval ge e m a = match pure_rval ge e m a with Some v => Some (v,m) | None => None end.
Proof. destruct a; simpl; auto; discriminate. Qed.

Lemma flat_context_hole:
  forall from to C, context from to C -> forall a,
  flat_expr (C a) = true -> flat_expr a = true.
Proof.
  induction 1; simpl; intros a HA; core_unpack; try discriminate; eauto using flat_of_simple, simple_context_hole.
Qed.

Lemma flat_context_assign_root:
  forall C, context RV RV C -> forall l r ty,
  flat_expr (C (Eassign l r ty)) = true -> forall z, C z = z.
Proof.
  intros C HC l r ty HA; inversion HC; subst; simpl in HA; core_unpack; try discriminate; auto;
    exfalso; match goal with
    | H: Csem.context _ _ ?C, P: simple (?C (Eassign _ _ _)) = true |- _ =>
      pose proof (simple_context_hole _ _ _ H _ P); discriminate
    end.
Qed.

Lemma simple_context_replace:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> simple (C a) = true -> simple b = true -> simple (C b) = true.
Proof.
  induction 1; simpl; intros a b HT HA HB; core_unpack; try discriminate; core_build; eauto.
  rewrite <- (context_type_eq _ _ _ H a b HT); assumption.
Qed.

Lemma flat_context_replace:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> flat_expr (C a) = true -> simple b = true -> flat_expr (C b) = true.
Proof.
  induction 1; simpl; intros a b HT HA HB; core_unpack; try discriminate; core_build;
    eauto using simple_context_replace, flat_of_simple.
  rewrite <- (context_type_eq _ _ _ H a b HT); assumption.
Qed.

Lemma flat_context_congr:
  forall ge e m from C, context from RV C -> forall a b,
  typeof a = typeof b -> simple a = true -> simple b = true ->
  pure_eq ge e m from a b -> flat_eval ge e m (C a) = flat_eval ge e m (C b).
Proof.
  intros ge e m from C HC a b HT HA HB HE; inversion HC; subst;
    try (repeat rewrite flat_eval_simple by assumption; simpl in HE; rewrite HE; reflexivity).
  all: try (match goal with
    | |- flat_eval ?ge ?e ?m ?A = flat_eval ?ge ?e ?m ?B =>
      change (option_map (fun v => (v,m)) (pure_rval ge e m A) =
              option_map (fun v => (v,m)) (pure_rval ge e m B))
    end; f_equal; exact (pure_context_congr ge e m _ _ _ HC a b HT HE)).
  - simpl. rewrite ?(context_type_eq _ _ _ H a b HT), (pure_context_congr ge e m _ _ _ H a b HT HE); reflexivity.
  - simpl. rewrite ?(context_type_eq _ _ _ H a b HT), (pure_context_congr ge e m _ _ _ H a b HT HE); reflexivity.
Qed.

Lemma flat_assign_head:
  forall ge e m l r ty t a' m', core_expr (Eassign l r ty) = true ->
  rred ge (Eassign l r ty) m t a' m' ->
  flat_eval ge e m (Eassign l r ty) = flat_eval ge e m' a'.
Proof.
  intros ge e m l r ty t a' m' CORE HR; inversion HR; subst; simpl in CORE; core_unpack.
  simpl. rewrite dec_eq_true.
  match goal with H: sem_cast _ _ _ _ = Some _ |- _ => rewrite H end.
  assert (HT: t = E0) by
    (match goal with A: assign_loc ge ?T ?M ?B ?O ?BF ?V t ?M' ?V' |- _ =>
       exact (assign_loc_silent ge T M B O BF V t M' V' ltac:(assumption) A) end). subst t.
  match goal with A: assign_loc ge _ _ _ _ _ _ E0 _ _ |- _ =>
    rewrite (do_assign_loc_complete ge quiet_world _ _ _ _ _ _ quiet_world E0 _ _ A (possible_trace_nil _)) end.
  reflexivity.
Qed.

Lemma flat_lred_context:
  forall ge e m a a' m' from C,
  context from RV C -> from = LV -> flat_expr (C a) = true ->
  lred ge e a m a' m' ->
  m' = m /\ flat_expr (C a') = true /\
  flat_eval ge e m (C a) = flat_eval ge e m' (C a').
Proof.
  intros ge e m a a' m' from C HC KIND FLAT HR; subst from.
  destruct (pure_lred _ _ _ _ _ _ HR) as [HM [HT [HS HE]]]; subst m'.
  split; auto; split.
  - eapply (flat_context_replace _ _ _ HC a a'); eauto; symmetry; exact HT.
  - assert (SA: simple a = true) by (inversion HR; subst; simpl; auto).
    exact (flat_context_congr ge e m LV C HC a a' (eq_sym HT) SA HS HE).
Qed.

Lemma flat_rred_context:
  forall ge e m a a' t m' C,
  context RV RV C -> flat_expr (C a) = true -> core_expr (C a) = true ->
  rred ge a m t a' m' ->
  flat_expr (C a') = true /\ flat_eval ge e m (C a) = flat_eval ge e m' (C a').
Proof.
  intros ge e m a a' t m' C HC FLAT CORE HR.
  destruct (simple a) eqn:SA.
  - destruct (pure_rred ge e a m t a' m' SA HR) as [HM [TT [HT [HS HE]]]]; subst m'.
    split.
    + exact (flat_context_replace _ _ _ HC a a' (eq_sym HT) FLAT HS).
    + exact (flat_context_congr ge e m RV C HC a a' (eq_sym HT) SA HS HE).
  - assert (FA: flat_expr a = true) by (exact (flat_context_hole _ _ _ HC a FLAT)).
    destruct a; simpl in SA, FA; try congruence.
    assert (ID: forall z, C z = z) by (exact (flat_context_assign_root C HC a1 a2 ty FLAT)).
    repeat rewrite ID in FLAT, CORE |- *.
    inversion HR; subst. split; [reflexivity|].
    repeat rewrite ID. eapply flat_assign_head; eauto.
Qed.

Lemma simple_estep:
  forall ge f a k e m t S', simple a = true -> Csem.estep ge (ExprState f a k e m) t S' ->
  S' = Stuckstate \/
  exists a', S' = ExprState f a' k e m /\ typeof a' = typeof a /\ simple a' = true /\
    pure_rval ge e m a = pure_rval ge e m a'.
Proof.
  intros ge f a k e m t S' SIMPLE STEP; inversion STEP; subst.
  - match goal with LR: lred ge e ?A m ?A' ?M', HC: Csem.context LV RV ?C |- _ =>
      destruct (pure_lred ge e A m A' M' LR) as [HM [HT [HS HE]]]; subst M';
      right; exists (C A'); repeat split; auto;
      [exact (context_type_eq _ _ _ HC A' A HT)
      |exact (simple_context_replace _ _ _ HC A A' (eq_sym HT) SIMPLE HS)
      |exact (pure_context_congr ge e m _ _ _ HC A A' (eq_sym HT) HE)] end.
  - match goal with RR: rred ge ?A m t ?A' ?M', HC: Csem.context RV RV ?C |- _ =>
      let SA := fresh "SA" in assert (SA: simple A = true) by (exact (simple_context_hole _ _ _ HC A SIMPLE));
      destruct (pure_rred ge e A m t A' M' SA RR) as [HM [TT [HT [HS HE]]]]; subst M';
      right; exists (C A'); repeat split; auto;
      [exact (context_type_eq _ _ _ HC A' A HT)
      |exact (simple_context_replace _ _ _ HC A A' (eq_sym HT) SIMPLE HS)
      |exact (pure_context_congr ge e m _ _ _ HC A A' (eq_sym HT) HE)] end.
  - match goal with CR: callred ge ?A _ _ _ _, HC: Csem.context RV RV _ |- _ =>
      let SA := fresh "SA" in assert (SA: simple A = true) by (exact (simple_context_hole _ _ _ HC A SIMPLE));
      inversion CR; subst; discriminate end.
  - left; reflexivity.
Qed.

