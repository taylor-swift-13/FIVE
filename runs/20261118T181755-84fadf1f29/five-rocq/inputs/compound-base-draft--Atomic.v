From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total.
Import ListNotations.
Definition atom_expr (a: expr): bool :=
  match a with
 | Eassign l r _ | Eassignop _ l r _ _ => simple l && simple r
 | _ => simple a end.

Definition atom_eval (ge: genv) (e: env) (m: mem) (a: expr): option (val * mem) :=
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
  | Eassignop op l r tyres ty =>
      if type_eq (typeof l) ty then
      match pure_lval ge e m l, pure_rval ge e m r with
      | Some (b,ofs,bf), Some v2 =>
        match Cexec.do_deref_loc ge quiet_world (typeof l) m b ofs bf with
        | Some (_,_,v1) =>
          match sem_binary_operation ge op v1 (typeof l) v2 (typeof r) m with
          | Some v3 => match sem_cast v3 tyres (typeof l) m with
            | Some v4 => match Cexec.do_assign_loc ge quiet_world (typeof l) m b ofs bf v4 with
              | Some (_,_,m',v') => Some(v',m') | None => None end
            | None => None end
          | None => None end
        | None => None end
      | _,_ => None end else None
  | _ => match pure_rval ge e m a with Some v => Some (v,m) | None => None end
  end.

Lemma atom_of_simple:
  forall a, simple a = true -> atom_expr a = true.
Proof. destruct a; simpl; auto; discriminate. Qed.

Lemma atom_eval_simple:
  forall ge e m a, simple a = true ->
  atom_eval ge e m a = match pure_rval ge e m a with Some v => Some (v,m) | None => None end.
Proof. destruct a; simpl; auto; discriminate. Qed.

Lemma atom_context_hole:
  forall from to C, context from to C -> forall a,
  atom_expr (C a) = true -> atom_expr a = true.
Proof.
  induction 1; simpl; intros a HA; core_unpack; try discriminate; eauto using atom_of_simple, simple_context_hole.
Qed.

Lemma atom_context_impure_root:
 forall C, Csem.context RV RV C -> forall a,
 atom_expr(C a)=true -> simple a=false -> forall z,C z=z.
Proof.
 intros C HC a HA SA;inversion HC;subst;simpl in HA;core_unpack;try discriminate;auto;
 exfalso;match goal with
 | H:Csem.context _ _ ?C, P:simple (?C a)=true |- _=>
   pose proof(simple_context_hole _ _ _ H _ P);congruence
 end.
Qed.

Lemma simple_context_replace:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> simple (C a) = true -> simple b = true -> simple (C b) = true.
Proof.
  induction 1; simpl; intros a b HT HA HB; core_unpack; try discriminate; core_build; eauto.
  rewrite <- (context_type_eq _ _ _ H a b HT); assumption.
Qed.

Lemma atom_context_replace:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> atom_expr (C a) = true -> simple b = true -> atom_expr (C b) = true.
Proof.
  induction 1; simpl; intros a b HT HA HB; core_unpack; try discriminate; core_build;
    eauto using simple_context_replace, atom_of_simple.
  rewrite <- (context_type_eq _ _ _ H a b HT); assumption.
Qed.

Lemma atom_context_congr:
  forall ge e m from C, context from RV C -> forall a b,
  typeof a = typeof b -> simple a = true -> simple b = true ->
  pure_eq ge e m from a b -> atom_eval ge e m (C a) = atom_eval ge e m (C b).
Proof.
  intros ge e m from C HC a b HT HA HB HE; inversion HC; subst;
    try (repeat rewrite atom_eval_simple by assumption; simpl in HE; rewrite HE; reflexivity).
  all: try (match goal with
    | |- atom_eval ?ge ?e ?m ?A = atom_eval ?ge ?e ?m ?B =>
      change (option_map (fun v => (v,m)) (pure_rval ge e m A) =
              option_map (fun v => (v,m)) (pure_rval ge e m B))
    end; f_equal; exact (pure_context_congr ge e m _ _ _ HC a b HT HE)).
  - simpl. rewrite ?(context_type_eq _ _ _ H a b HT), (pure_context_congr ge e m _ _ _ H a b HT HE); reflexivity.
  - simpl. rewrite ?(context_type_eq _ _ _ H a b HT), (pure_context_congr ge e m _ _ _ H a b HT HE); reflexivity.
Qed.

Lemma atom_assign_head:
  forall ge e m l r ty t a' m', core_expr (Eassign l r ty) = true ->
  rred ge (Eassign l r ty) m t a' m' ->
  atom_eval ge e m (Eassign l r ty) = atom_eval ge e m' a'.
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

Lemma atom_lred_context:
  forall ge e m a a' m' from C,
  context from RV C -> from = LV -> atom_expr (C a) = true ->
  lred ge e a m a' m' ->
  m' = m /\ atom_expr (C a') = true /\
  atom_eval ge e m (C a) = atom_eval ge e m' (C a').
Proof.
  intros ge e m a a' m' from C HC KIND FLAT HR; subst from.
  destruct (pure_lred _ _ _ _ _ _ HR) as [HM [HT [HS HE]]]; subst m'.
  split; auto; split.
  - eapply (atom_context_replace _ _ _ HC a a'); eauto; symmetry; exact HT.
  - assert (SA: simple a = true) by (inversion HR; subst; simpl; auto).
    exact (atom_context_congr ge e m LV C HC a a' (eq_sym HT) SA HS HE).
Qed.

Lemma atom_assignop_head:
 forall ge e m op l r tyres ty t a' m', core_expr(Eassignop op l r tyres ty)=true ->
 rred ge (Eassignop op l r tyres ty) m t a' m' ->
 atom_expr a'=true /\ atom_eval ge e m (Eassignop op l r tyres ty)=atom_eval ge e m' a'.
Proof.
 intros ge e m op l r tyres ty t a' m' CORE HR;inversion HR;subst;simpl in CORE;core_unpack.
 split;[reflexivity|]. simpl. rewrite dec_eq_true.
 assert(HT:t=E0) by (eapply deref_loc_silent;eauto). subst t.
 match goal with D:deref_loc ge _ _ _ _ _ E0 _ |- _=>
  rewrite(do_deref_loc_complete ge quiet_world _ _ _ _ _ _ quiet_world E0 _ D (possible_trace_nil _)) end.
 reflexivity.
Qed.

Lemma atom_rred_context:
 forall ge e m a a' t m' C,
 Csem.context RV RV C -> atom_expr(C a)=true -> core_expr(C a)=true ->
 rred ge a m t a' m' -> atom_expr(C a')=true /\
 atom_eval ge e m (C a)=atom_eval ge e m' (C a').
Proof.
 intros ge e m a a' t m' C HC FLAT CORE HR.
 destruct(simple a) eqn:SA.
 - destruct(pure_rred ge e a m t a' m' SA HR) as [HM[TT[HT[HS HE]]]];subst m'.
   split.
   + exact(atom_context_replace _ _ _ HC a a' (eq_sym HT) FLAT HS).
   + exact(atom_context_congr ge e m RV C HC a a' (eq_sym HT) SA HS HE).
 - assert(FA:atom_expr a=true) by (eapply atom_context_hole;eauto).
   assert(ID:forall z,C z=z) by (eapply atom_context_impure_root;eauto).
   repeat rewrite ID in FLAT,CORE|-*.
   destruct a;simpl in SA,FA;try congruence.
   + inversion HR;subst;split;[reflexivity|]. eapply atom_assign_head;eauto.
   + eapply atom_assignop_head;eauto.
Qed.
