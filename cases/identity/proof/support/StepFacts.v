From Coq Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers Floats Values AST Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem.
From FiveCases.identity.model Require Import Source.
Import ListNotations.
Local Open Scope Z_scope.

Lemma context_Evar_inv :
  forall from to C, context from to C ->
  forall a x ty, C a = Evar x ty ->
  from = to /\ a = Evar x ty /\ (forall z, C z = z).
Proof.
  intros from to C H; inversion H; intros; simpl in *; try discriminate.
  subst; auto.
Qed.

Lemma context_Eloc_inv :
  forall from to C, context from to C ->
  forall a b ofs bf ty, C a = Eloc b ofs bf ty ->
  from = to /\ a = Eloc b ofs bf ty /\ (forall z, C z = z).
Proof.
  intros from to C H; inversion H; intros; simpl in *; try discriminate.
  subst; auto.
Qed.

Lemma context_Eval_inv :
  forall from to C, context from to C ->
  forall a v ty, C a = Eval v ty ->
  from = to /\ a = Eval v ty /\ (forall z, C z = z).
Proof.
  intros from to C H; inversion H; intros; simpl in *; try discriminate.
  subst; auto.
Qed.

Lemma context_Evalof_var_inv :
  forall from C, context from RV C ->
  forall a x ty1 ty2, C a = Evalof (Evar x ty1) ty2 ->
    (from = RV /\ a = Evalof (Evar x ty1) ty2 /\ (forall z, C z = z))
    \/
    (from = LV /\ a = Evar x ty1 /\ (forall z, C z = Evalof z ty2)).
Proof.
  intros from C HC a x ty1 ty2 HE; inversion HC; subst; simpl in HE; try discriminate.
  - subst; left; auto.
  - injection HE as Heq Hty; subst.
    match goal with
    | HC : Csem.context _ LV ?D, HE : ?D ?a = Evar ?x ?ty |- _ =>
      destruct (context_Evar_inv _ _ _ HC _ _ _ HE) as [? [? ?]]
    end.
    subst; right; repeat split; auto. intros; f_equal; auto.
Qed.

Lemma context_Evalof_loc_inv :
  forall from C, context from RV C ->
  forall a b ofs bf ty1 ty2, C a = Evalof (Eloc b ofs bf ty1) ty2 ->
    (from = RV /\ a = Evalof (Eloc b ofs bf ty1) ty2 /\ (forall z, C z = z))
    \/
    (from = LV /\ a = Eloc b ofs bf ty1 /\ (forall z, C z = Evalof z ty2)).
Proof.
  intros from C HC a b ofs bf ty1 ty2 HE; inversion HC; subst; simpl in HE; try discriminate.
  - subst; left; auto.
  - injection HE as Heq Hty; subst.
    match goal with
    | HC : Csem.context _ LV ?D, HE : ?D ?a = Eloc ?b ?ofs ?bf ?ty |- _ =>
      destruct (context_Eloc_inv _ _ _ HC _ _ _ _ _ HE) as [? [? ?]]
    end.
    subst; right; repeat split; auto. intros; f_equal; auto.
Qed.

Lemma not_stuck_evalof_var :
  forall ge e m x ty1 ty2 b,
  PTree.get x e = Some (b, ty1) ->
  not_stuck ge e (Evalof (Evar x ty1) ty2) m.
Proof.
  intros ge e m x ty1 ty2 b Hlookup.
  assert (HV: imm_safe ge e LV (Evar x ty1) m).
  { eapply imm_safe_lred with (C := fun z => z).
    - apply red_var_local; exact Hlookup.
    - apply ctx_top. }
  assert (HR: imm_safe ge e RV (Evalof (Evar x ty1) ty2) m).
  { eapply imm_safe_lred with (C := fun z => Evalof z ty2).
    - apply red_var_local; exact Hlookup.
    - apply ctx_rvalof; apply ctx_top. }
  intros kind C a HC HE.
  symmetry in HE.
  destruct (context_Evalof_var_inv _ _ HC _ _ _ _ HE)
    as [[? [? ?]] | [? [? ?]]]; subst; assumption.
Qed.

Lemma not_stuck_evalof_loc :
  forall ge e m b ofs bf ty1 ty2 t v,
  deref_loc ge ty1 m b ofs bf t v ->
  ty1 = ty2 ->
  not_stuck ge e (Evalof (Eloc b ofs bf ty1) ty2) m.
Proof.
  intros ge e m b ofs bf ty1 ty2 t v HD; intros; subst ty2.
  assert (HR: imm_safe ge e RV (Evalof (Eloc b ofs bf ty1) ty1) m).
  { eapply imm_safe_rred with (C := fun z => z).
    - apply red_rvalof; exact HD.
    - apply ctx_top. }
  intros kind C a HC HE; symmetry in HE.
  destruct (context_Evalof_loc_inv _ _ HC _ _ _ _ _ _ HE)
    as [[? [? ?]] | [? [? ?]]]; subst; auto using imm_safe_loc.
Qed.

Lemma lred_evalof_var_context :
  forall ge e m a a1 m1 C x ty1 ty2 b,
  PTree.get x e = Some (b, ty1) ->
  lred ge e a m a1 m1 ->
  context LV RV C ->
  C a = Evalof (Evar x ty1) ty2 ->
  C a1 = Evalof (Eloc b Ptrofs.zero Full ty1) ty2 /\ m1 = m.
Proof.
  intros ge e m a a1 m1 C x ty1 ty2 b HL HR HC HE.
  destruct (context_Evalof_var_inv _ _ HC _ _ _ _ HE)
    as [[Hbad _] | [_ [HA HEQ]]]; try discriminate.
  subst a. inversion HR; subst.
  - split; [rewrite HEQ; f_equal; congruence | reflexivity].
  - congruence.
Qed.

Lemma no_rred_evalof_var_context :
  forall ge (e: env) m a t a1 m1 C x ty1 ty2,
  rred ge a m t a1 m1 ->
  context RV RV C ->
  C a = Evalof (Evar x ty1) ty2 -> False.
Proof.
  intros ge e m a t a1 m1 C x ty1 ty2 HR HC HE.
  destruct (context_Evalof_var_inv _ _ HC _ _ _ _ HE)
    as [[_ [HA _]] | [Hbad _]]; try discriminate.
  subst a; inversion HR.
Qed.

Lemma no_callred_evalof_var_context :
  forall ge (e: env) m a fd args ty C x ty1 ty2,
  callred ge a m fd args ty ->
  context RV RV C ->
  C a = Evalof (Evar x ty1) ty2 -> False.
Proof.
  intros ge e m a fd args ty C x ty1 ty2 HR HC HE.
  destruct (context_Evalof_var_inv _ _ HC _ _ _ _ HE)
    as [[_ [HA _]] | [Hbad _]]; try discriminate.
  subst a; inversion HR.
Qed.

Lemma step_evalof_var_unique :
  forall ge f k e m x ty1 ty2 b t s1,
  PTree.get x e = Some (b, ty1) ->
  step ge (ExprState f (Evalof (Evar x ty1) ty2) k e m) t s1 ->
  t = E0 /\ s1 = ExprState f (Evalof (Eloc b Ptrofs.zero Full ty1) ty2) k e m.
Proof.
  intros ge f k e m x ty1 ty2 b t s1 HL [HS | HS].
  - inversion HS; subst.
    + match goal with
      | HR: lred _ _ _ _ _ _, HC: Csem.context LV RV _,
        HE: _ = Evalof (Evar _ _) _ |- _ =>
        destruct (lred_evalof_var_context _ _ _ _ _ _ _ _ _ _ _ HL HR HC HE)
          as [HA HM]; subst; rewrite HA; auto
      end.
    + exfalso; eapply no_rred_evalof_var_context; eauto.
    + exfalso; eapply no_callred_evalof_var_context; eauto.
    + exfalso; match goal with
      | HN: ~ imm_safe _ _ _ _ _ |- _ =>
        apply HN; eapply (not_stuck_evalof_var ge e m x ty1 ty2 b HL); eauto
      end.
  - inversion HS.
Qed.

Lemma deref_loc_float_unique :
  forall ge m b ofs t v w,
  Mem.loadv Mfloat32 m (Vptr b ofs) = Some w ->
  deref_loc ge tfloat m b ofs Full t v ->
  t = E0 /\ v = w.
Proof.
  intros ge m b ofs t v w HL HD.
  inversion HD; subst; simpl in *; try discriminate.
  match goal with HA: By_value Mfloat32 = By_value ?chunk |- _ =>
    inversion HA; subst chunk
  end.
  simpl in *; split; auto; congruence.
Qed.

Lemma no_lred_evalof_loc_context :
  forall ge e m a a1 m1 C b ofs bf ty1 ty2,
  lred ge e a m a1 m1 ->
  context LV RV C ->
  C a = Evalof (Eloc b ofs bf ty1) ty2 -> False.
Proof.
  intros ge e m a a1 m1 C b ofs bf ty1 ty2 HR HC HE.
  destruct (context_Evalof_loc_inv _ _ HC _ _ _ _ _ _ HE)
    as [[Hbad _] | [_ [HA _]]]; try discriminate.
  subst a; inversion HR.
Qed.

Lemma rred_evalof_float_context :
  forall ge m a t a1 m1 C b ofs w,
  Mem.loadv Mfloat32 m (Vptr b ofs) = Some w ->
  rred ge a m t a1 m1 ->
  context RV RV C ->
  C a = Evalof (Eloc b ofs Full tfloat) tfloat ->
  t = E0 /\ C a1 = Eval w tfloat /\ m1 = m.
Proof.
  intros ge m a t a1 m1 C b ofs w HL HR HC HE.
  destruct (context_Evalof_loc_inv _ _ HC _ _ _ _ _ _ HE)
    as [[_ [HA HEQ]] | [Hbad _]]; try discriminate.
  subst a; inversion HR; subst.
  match goal with HD: deref_loc _ _ _ _ _ _ _ _ |- _ =>
    destruct (deref_loc_float_unique _ _ _ _ _ _ _ HL HD) as [? ?]; subst
  end.
  rewrite HEQ; auto.
Qed.

Lemma no_callred_evalof_loc_context :
  forall ge m a fd args ty C b ofs bf ty1 ty2,
  callred ge a m fd args ty ->
  context RV RV C ->
  C a = Evalof (Eloc b ofs bf ty1) ty2 -> False.
Proof.
  intros ge m a fd args ty C b ofs bf ty1 ty2 HR HC HE.
  destruct (context_Evalof_loc_inv _ _ HC _ _ _ _ _ _ HE)
    as [[_ [HA _]] | [Hbad _]]; try discriminate.
  subst a; inversion HR.
Qed.

Lemma step_evalof_float_unique :
  forall ge f k e m b ofs w t s1,
  Mem.loadv Mfloat32 m (Vptr b ofs) = Some w ->
  step ge (ExprState f (Evalof (Eloc b ofs Full tfloat) tfloat) k e m) t s1 ->
  t = E0 /\ s1 = ExprState f (Eval w tfloat) k e m.
Proof.
  intros ge f k e m b ofs w t s1 HL [HS | HS].
  - inversion HS; subst.
    + exfalso; eapply no_lred_evalof_loc_context; eauto.
    + match goal with
      | HR: rred _ _ _ _ _ _, HC: Csem.context RV RV _,
        HE: _ = Evalof (Eloc _ _ _ _) _ |- _ =>
        destruct (rred_evalof_float_context _ _ _ _ _ _ _ _ _ _ HL HR HC HE)
          as [? [HA HM]]; subst; rewrite HA; auto
      end.
    + exfalso; eapply no_callred_evalof_loc_context; eauto.
    + exfalso; match goal with
      | HN: ~ imm_safe _ _ _ _ _ |- _ =>
        apply HN; eapply (not_stuck_evalof_loc ge e m b ofs Full tfloat tfloat E0 w);
          eauto using deref_loc_value; try reflexivity
      end.
      eapply deref_loc_value; [reflexivity | reflexivity | exact HL].
  - inversion HS.
Qed.

Lemma not_stuck_eval :
  forall ge e m v ty, not_stuck ge e (Eval v ty) m.
Proof.
  intros ge e m v ty kind C a HC HE; symmetry in HE.
  destruct (context_Eval_inv _ _ _ HC _ _ _ HE) as [? [? ?]].
  subst; apply imm_safe_val.
Qed.

Lemma no_estep_eval :
  forall ge f k e m v ty t s1,
  estep ge (ExprState f (Eval v ty) k e m) t s1 -> False.
Proof.
  intros ge f k e m v ty t s1 HS; inversion HS; subst.
  - match goal with HC: Csem.context _ RV ?C, HE: ?C ?a = Eval _ _ |- _ =>
      destruct (context_Eval_inv _ _ _ HC _ _ _ HE) as [HB [? ?]]; discriminate
    end.
  - match goal with HC: Csem.context _ RV ?C, HE: ?C ?a = Eval _ _ |- _ =>
      destruct (context_Eval_inv _ _ _ HC _ _ _ HE) as [_ [HA ?]]; subst
    end.
    match goal with HR: rred _ _ _ _ _ _ |- _ => inversion HR end.
  - match goal with HC: Csem.context _ RV ?C, HE: ?C ?a = Eval _ _ |- _ =>
      destruct (context_Eval_inv _ _ _ HC _ _ _ HE) as [_ [HA ?]]; subst
    end.
    match goal with HR: callred _ _ _ _ _ _ |- _ => inversion HR end.
  - match goal with HN: ~ imm_safe _ _ _ _ _ |- _ =>
      apply HN; eapply (not_stuck_eval ge e m v ty); eauto
    end.
Qed.

Lemma step_return1_unique :
  forall ge f x k e m t s1,
  step ge (State f (Sreturn (Some x)) k e m) t s1 ->
  t = E0 /\ s1 = ExprState f x (Kreturn k) e m.
Proof.
  intros ge f x k e m t s1 [HS | HS].
  - inversion HS.
  - inversion HS; subst; auto; intuition discriminate.
Qed.

Lemma step_return2_unique :
  forall ge f v ty k e m vret mf t s1,
  sem_cast v ty (fn_return f) m = Some vret ->
  Mem.free_list m (blocks_of_env ge e) = Some mf ->
  step ge (ExprState f (Eval v ty) (Kreturn k) e m) t s1 ->
  t = E0 /\ s1 = Returnstate vret (call_cont k) mf.
Proof.
  intros ge f v ty k e m vret mf t s1 HC HF [HS | HS].
  - exfalso; eapply no_estep_eval; exact HS.
  - inversion HS; subst; split; congruence.
Qed.

Lemma no_step_Returnstate_Kstop :
  forall ge v m t s1,
  step ge (Returnstate v Kstop m) t s1 -> False.
Proof.
  intros ge v m t s1 [HS | HS]; inversion HS.
Qed.
