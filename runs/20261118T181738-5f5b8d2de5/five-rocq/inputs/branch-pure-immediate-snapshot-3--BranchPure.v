From Coq Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.

From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore PureProgress Total.
Import ListNotations.

(** This denotation is used to establish uniqueness of normal executions.
    Execution remains the complete error-preserving operational model. *)
Definition branch_world: world := World (fun _ _ => None) (fun _ _ _ => None) (fun _ _ _ _ => None).

Fixpoint branch_simple(a:expr):bool :=
 match a with
 |Eval _ ty|Evar _ ty|Eloc _ _ _ ty|Esizeof _ ty|Ealignof _ ty=>nv ty
 |Evalof a ty|Ederef a ty|Eaddrof a ty|Eunop _ a ty|Ecast a ty
 |Eparen a _ ty=>nv ty && branch_simple a
 |Ebinop _ a b ty=>nv ty && branch_simple a && branch_simple b
 |Econdition a b c ty=>nv ty && branch_simple a && branch_simple b && branch_simple c
 |_=>false end.

Section DENOTATION.
Variable ge: genv.
Variable e: env.
Variable m: mem.

Fixpoint branch_rval (a: expr): option val :=
  match a with
  | Eval v _ => Some v
  | Evalof l ty =>
      if type_eq ty (typeof l) then
      match branch_lval l with
      | Some (b,ofs,bf) =>
          match Cexec.do_deref_loc ge branch_world ty m b ofs bf with
          | Some (_,_,v) => Some v | None => None end
      | None => None end else None
  | Eaddrof l _ =>
      match branch_lval l with Some (b,ofs,Full) => Some (Vptr b ofs) | _ => None end
  | Eunop op a _ =>
      match branch_rval a with Some v => sem_unary_operation op v (typeof a) m | None => None end
  | Ebinop op a b _ =>
      match branch_rval a, branch_rval b with
      | Some v, Some w => sem_binary_operation ge op v (typeof a) w (typeof b) m
      | _,_ => None end
  | Ecast a ty =>
      match branch_rval a with Some v => sem_cast v (typeof a) ty m | None => None end
  | Econdition a b c ty =>
      match branch_rval a with
      |Some v=>match bool_val v (typeof a) m with
        |Some choice=>let chosen:=if choice then b else c in
          match branch_rval chosen with
          |Some w=>sem_cast w (typeof chosen) ty m|None=>None end
        |None=>None end|None=>None end
  | Eparen a castty _ =>
      match branch_rval a with Some v=>sem_cast v (typeof a) castty m|None=>None end
  | Esizeof ty _ => Some (Vptrofs (Ptrofs.repr (sizeof ge ty)))
  | Ealignof ty _ => Some (Vptrofs (Ptrofs.repr (alignof ge ty)))
  | _ => None
  end
with branch_lval (a: expr): option (block * ptrofs * bitfield) :=
  match a with
  | Eloc b ofs bf _ => Some (b,ofs,bf)
  | Evar id ty =>
      match PTree.get id e with
      | Some (b,ty') => if type_eq ty ty' then Some (b,Ptrofs.zero,Full) else None
      | None => match Genv.find_symbol ge id with Some b => Some (b,Ptrofs.zero,Full) | None => None end end
  | Ederef a _ =>
      match branch_rval a with Some (Vptr b ofs) => Some (b,ofs,Full) | _ => None end
  | Efield a id _ =>
      match branch_rval a with
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

Definition branch_eq (k: kind) (a b: expr): Prop :=
  match k with RV => branch_rval a = branch_rval b | LV => branch_lval a = branch_lval b end.

Lemma context_type_eq:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> typeof (C a) = typeof (C b).
Proof. induction 1; simpl; intros; auto. Qed.

Lemma branch_context_congr:
  forall from to C, context from to C -> forall a b,
  typeof a = typeof b -> branch_eq from a b -> branch_eq to (C a) (C b).
Proof.
  induction 1; simpl; intros a b HT HE; auto;
    try (rewrite (IHcontext a b HT HE); reflexivity);
    try (rewrite (context_type_eq _ _ _ H a b HT), (IHcontext a b HT HE); reflexivity).
Qed.

End DENOTATION.

Lemma branch_context_hole:
  forall from to C, context from to C -> forall a,
  branch_simple (C a) = true -> branch_simple a = true.
Proof.
  induction 1; simpl; intros a HA; core_unpack; try discriminate; eauto.
Qed.

Lemma branch_lred:
  forall ge e a m a' m', branch_simple a=true -> lred ge e a m a' m' ->
  m' = m /\ typeof a' = typeof a /\ branch_simple a' = true /\
  branch_lval ge e m a = branch_lval ge e m a'.
Proof.
  intros ge e a m a' m' SIMPLE H; inversion H; subst; simpl in SIMPLE; core_unpack;try discriminate; simpl; repeat split; auto;
    try rewrite H0; try rewrite H1; try rewrite H2; try rewrite dec_eq_true; auto.
Qed.

Lemma branch_rred:
  forall ge e a m t a' m', branch_simple a = true -> rred ge a m t a' m' ->
  m' = m /\ t = E0 /\ typeof a' = typeof a /\ branch_simple a' = true /\
  branch_rval ge e m a = branch_rval ge e m a'.
Proof.
  intros ge e a m t a' m' HA HR; inversion HR; subst; simpl in HA; core_unpack; try discriminate;
    simpl; repeat split; core_build; auto; try rewrite H; auto.
  - eapply deref_loc_silent; eauto.
  - assert (HT: t = E0) by (eapply deref_loc_silent; eauto). subst t.
    rewrite dec_eq_true.
    rewrite (do_deref_loc_complete ge branch_world ty m' b ofs bf branch_world E0 v H (possible_trace_nil _)).
    reflexivity.
  - destruct b;assumption.
Qed.


Ltac branch_options H := repeat match type of H with
 |context[match ?x with _=>_ end]=>let E:=fresh "OPT"in destruct x eqn:E;try discriminate end.
Ltac branch_literals := repeat match goal with
 |H:branch_rval _ _ _ (Eval _ _) = Some _ |- _=>cbn[branch_rval]in H;inversion H;subst;clear H
 |H:branch_lval _ _ _ (Eloc _ _ _ _) = Some _ |- _=>cbn[branch_lval]in H;inversion H;subst;clear H end.
Ltac branch_child := match goal with
 |IH:forall v,branch_rval ?ge ?e ?m ?a=Some v->_,H:branch_rval ?ge ?e ?m ?a=Some ?v|-_=>exact(IH v H)
 |IH:forall b ofs bf,branch_lval ?ge ?e ?m ?a=Some(b,ofs,bf)->_,H:branch_lval ?ge ?e ?m ?a=Some(?b,?ofs,?bf)|-_=>exact(IH b ofs bf H)
 end.
Lemma branch_immediate : forall a ge e m,
 branch_simple a=true ->
 (forall v,branch_rval ge e m a=Some v -> Csem.imm_safe ge e RV a m) /\
 (forall b ofs bf,branch_lval ge e m a=Some(b,ofs,bf)-> Csem.imm_safe ge e LV a m).
Proof.
 induction a;intros ge e m SIMPLE;cbn[branch_simple]in SIMPLE;core_unpack;try discriminate;
 repeat match goal with IH:forall ge e m,branch_simple ?a=true -> _ /\ _|-_=>
  let R:=fresh "RV"in let L:=fresh "LV"in
  pose proof(IH ge e m ltac:(assumption))as[R L];clear IH end;
 split;intros;cbn[branch_rval branch_lval]in H;try discriminate.
 - constructor.
 - branch_options H;inversion H;subst;
   first[solve[eapply Csem.imm_safe_lred with(C:=fun x=>x);[eapply red_var_local;eauto|apply Csem.ctx_top]]
        |solve[eapply Csem.imm_safe_lred with(C:=fun x=>x);[eapply red_var_global;eauto|apply Csem.ctx_top]]].
 - branch_options H;inversion H;subst.
   destruct(literal LV a)eqn:LI.
   + destruct(literal_l_inv _ LI)as[bb[oo[ff[tt EQ]]]];subst a;branch_literals.
     match goal with D:do_deref_loc _ _ _ _ _ _ _=Some _|-_=>
      destruct(do_deref_loc_sound _ _ _ _ _ _ _ _ _ _ D)as[DR _]end.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_rvalof;eauto|constructor].
   + eapply lift_immediate with(from:=LV)(C:=fun x=>Evalof x ty);eauto using ctx_rvalof,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_lred with(C:=fun x=>x);[constructor|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ederef x ty);eauto using ctx_deref,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal LV a)eqn:LI.
   + destruct(literal_l_inv _ LI)as[bb[oo[ff[tt EQ]]]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
   + eapply lift_immediate with(from:=LV)(C:=fun x=>Eaddrof x ty);eauto using ctx_addrof,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_unop;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eunop op x ty);eauto using ctx_unop,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a1)eqn:L1.
   + destruct(literal_r_inv _ L1)as[vv[tt EQ]];subst a1;branch_literals.
     destruct(literal RV a2)eqn:L2.
     * destruct(literal_r_inv _ L2)as[vv2[tt2 EQ]];subst a2;branch_literals.
       eapply imm_safe_rred with(C:=fun x=>x);[eapply red_binop;eauto|constructor].
     * eapply lift_immediate with(from:=RV)(C:=fun x=>Ebinop op _ x ty);eauto using ctx_binop_right,ctx_top.
       branch_child.
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ebinop op x a2 ty);eauto using ctx_binop_left,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_cast;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ecast x ty);eauto using ctx_cast,ctx_top.
     branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a1)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a1;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_condition;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Econdition x a2 a3 ty);eauto using ctx_condition,ctx_top.
     branch_child.
 - eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
 - eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_paren;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eparen x tycast ty);eauto using ctx_paren,ctx_top.
     branch_child.
 - constructor.
Qed.
