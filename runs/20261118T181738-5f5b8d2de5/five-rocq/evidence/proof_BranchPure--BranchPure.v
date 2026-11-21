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
 |H:branch_lval _ _ _ (Eloc _ _ _ _) = Some _ |- _=>cbn[branch_lval]in H;inversion H;subst;clear H
 |H:Some _=Some _|-_=>inversion H;subst;clear H end.
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
  let R:=fresh "RCH"in let L:=fresh "LCH"in
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
   + eapply lift_immediate with(from:=LV)(C:=fun x=>Evalof x (typeof a));eauto using ctx_rvalof,ctx_top;try branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_lred with(C:=fun x=>x);[constructor|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ederef x ty);eauto using ctx_deref,ctx_top;try branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal LV a)eqn:LI.
   + destruct(literal_l_inv _ LI)as[bb[oo[ff[tt EQ]]]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
   + eapply lift_immediate with(from:=LV)(C:=fun x=>Eaddrof x ty);eauto using ctx_addrof,ctx_top;try branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_unop;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eunop op x ty);eauto using ctx_unop,ctx_top;try branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a1)eqn:L1.
   + destruct(literal_r_inv _ L1)as[vv[tt EQ]];subst a1;branch_literals.
     destruct(literal RV a2)eqn:L2.
     * destruct(literal_r_inv _ L2)as[vv2[tt2 EQ]];subst a2;branch_literals.
       eapply imm_safe_rred with(C:=fun x=>x);[eapply red_binop;eauto|constructor].
     * eapply lift_immediate with(from:=RV)(C:=fun x=>Ebinop op _ x ty);eauto using ctx_binop_right,ctx_top;try branch_child.
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ebinop op x a2 ty);eauto using ctx_binop_left,ctx_top;try branch_child.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_cast;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Ecast x ty);eauto using ctx_cast,ctx_top;try branch_child.
 - destruct(branch_rval ge e m a1)as[guard|]eqn:GUARD;try discriminate.
   destruct(bool_val guard(typeof a1)m)as[choice|]eqn:BOOL;try discriminate.
   destruct(literal RV a1)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a1;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_condition;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Econdition x a2 a3 ty);eauto using ctx_condition,ctx_top;try branch_child.
 - eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
 - eapply imm_safe_rred with(C:=fun x=>x);[constructor|constructor].
 - constructor.
 - branch_options H;inversion H;subst.
   destruct(literal RV a)eqn:LI.
   + destruct(literal_r_inv _ LI)as[vv[tt EQ]];subst a;branch_literals.
     eapply imm_safe_rred with(C:=fun x=>x);[eapply red_paren;eauto|constructor].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eparen x tycast ty);eauto using ctx_paren,ctx_top;try branch_child.
Qed.

Definition branch_defined(ge:Csem.genv)(e:env)(m:mem)(k:kind)(a:expr):Prop :=
 match k with RV=>exists v,branch_rval ge e m a=Some v
 |LV=>exists b ofs bf,branch_lval ge e m a=Some(b,ofs,bf)end.
Lemma branch_context_defined : forall from to C,
 Csem.context from to C -> forall a ge e m,
 branch_simple(C a)=true -> branch_defined ge e m to(C a) -> branch_defined ge e m from a.
Proof.
 induction 1;intros a0 ge e m SIMPLE DEF;cbn[branch_simple]in SIMPLE;core_unpack;try discriminate;auto;
 unfold branch_defined in DEF;repeat match goal with H:exists _,_|-_=>destruct H end;
 match goal with H:branch_rval _ _ _ _=Some _|-_=>cbn[branch_rval branch_lval]in H;branch_options H
                |H:branch_lval _ _ _ _=Some _|-_=>cbn[branch_rval branch_lval]in H;branch_options H end;
 eapply IHcontext;eauto;unfold branch_defined;eauto.
Qed.
Lemma branch_not_stuck : forall ge e m a v,
 branch_simple a=true ->branch_rval ge e m a=Some v -> Csem.not_stuck ge e a m.
Proof.
 intros ge e m a v SA EV k C sub CT EQ;subst a.
 pose proof(branch_context_defined _ _ _ CT sub ge e m SA ltac:(unfold branch_defined;eauto))as DEF.
 pose proof(branch_context_hole _ _ _ CT sub SA)as SIMPLE.
 destruct k;unfold branch_defined in DEF.
 - destruct DEF as[b[ofs[bf D]]];eapply(proj2(branch_immediate _ ge e m SIMPLE));exact D.
 - destruct DEF as[w D];eapply(proj1(branch_immediate _ ge e m SIMPLE));exact D.
Qed.
Lemma branch_context_replace : forall from to C,Csem.context from to C -> forall a b,
 typeof a=typeof b -> branch_simple(C a)=true -> branch_simple b=true ->branch_simple(C b)=true.
Proof.
 induction 1;simpl;intros a b TY SA SB;core_unpack;try discriminate;core_build;eauto.
Qed.
Lemma branch_estep : forall ge f a k e m t next,
 branch_simple a=true -> Csem.estep ge(ExprState f a k e m)t next ->
 next=Stuckstate \/exists a',next=ExprState f a' k e m /\ typeof a'=typeof a /\
 branch_simple a'=true /\branch_rval ge e m a=branch_rval ge e m a'.
Proof.
 intros ge f a k e m t next SIMPLE STEP;inversion STEP;subst.
 - match goal with LR:lred ge e ?A m ?A' ?M',HC:Csem.context LV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);
   destruct(branch_lred ge e A m A' M' SA LR)as[HM[TY[SB EQ]]];subst M';
   right;exists(C A');repeat split;auto;
   [exact(context_type_eq _ _ _ HC A' A TY)|
    exact(branch_context_replace _ _ _ HC A A'(eq_sym TY)SIMPLE SB)|
    exact(branch_context_congr ge e m _ _ _ HC A A'(eq_sym TY)EQ)]end.
 - match goal with RR:rred ge ?A m t ?A' ?M',HC:Csem.context RV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);
   destruct(branch_rred ge e A m t A' M' SA RR)as[HM[TT[TY[SB EQ]]]];subst M';
   right;exists(C A');repeat split;auto;
   [exact(context_type_eq _ _ _ HC A' A TY)|
    exact(branch_context_replace _ _ _ HC A A'(eq_sym TY)SIMPLE SB)|
    exact(branch_context_congr ge e m _ _ _ HC A A'(eq_sym TY)EQ)]end.
 - match goal with CR:callred ge ?A _ _ _ _,HC:Csem.context RV RV ?C|-_=>
   assert(SA:branch_simple A=true)by(eapply branch_context_hole;eauto);inversion CR;subst;discriminate end.
 - left;reflexivity.
Qed.
Local Open Scope nat_scope.
Fixpoint branch_rank(a:expr):nat :=
 match a with
 |Eval _ _|Eloc _ _ _ _=>0
 |Evar _ _|Esizeof _ _|Ealignof _ _=>1
 |Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Eparen a _ _=>S(branch_rank a)
 |Ebinop _ a b _=>S(branch_rank a+branch_rank b)
 |Econdition a b c _=>2+branch_rank a+branch_rank b+branch_rank c
 |_=>0 end.
Lemma branch_rank_lred : forall ge e a m a' m',branch_simple a=true ->
 lred ge e a m a' m' ->branch_rank a'<branch_rank a.
Proof. intros;inversion H0;subst;cbn[branch_simple]in H;core_unpack;try discriminate;cbn[branch_rank];lia. Qed.
Lemma branch_rank_rred : forall ge a m t a' m',branch_simple a=true ->
 rred ge a m t a' m' ->branch_rank a'<branch_rank a.
Proof.
 intros;inversion H0;subst;cbn[branch_simple]in H;core_unpack;try discriminate;
 cbn[branch_rank];try lia;destruct b;cbn[branch_rank];lia.
Qed.
Lemma branch_rank_context : forall from to C,Csem.context from to C ->forall a b,
 branch_simple(C a)=true ->branch_rank b<branch_rank a ->branch_rank(C b)<branch_rank(C a).
Proof.
 induction 1;simpl;intros;core_unpack;try discriminate;try lia;
 match goal with IH:forall a b,_|-_=>specialize(IH a b ltac:(assumption)ltac:(assumption));lia end.
Qed.
Lemma branch_estep_rank : forall ge f a k e m t a',branch_simple a=true ->
 Csem.estep ge(ExprState f a k e m)t(ExprState f a' k e m)->branch_rank a'<branch_rank a.
Proof.
 intros ge f a k e m t a' SA ES;inversion ES;subst.
 - eapply branch_rank_context;eauto using branch_rank_lred,branch_context_hole.
 - eapply branch_rank_context;eauto using branch_rank_rred,branch_context_hole.
Qed.
Lemma branch_estep_not_stuck : forall ge f a k e m t next v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->
 Csem.estep ge(ExprState f a k e m)t next ->next<>Stuckstate.
Proof.
 intros ge f a k e m t next v SA EV ES EQ;subst next;inversion ES;subst.
 pose proof(branch_not_stuck _ _ _ _ _ SA EV)as NS.
 match goal with H:~Csem.imm_safe _ _ _ _ _|-_=>apply H;eapply NS;eauto end.
Qed.
Lemma branch_nonvalue_progress : forall ge f a k e m v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->
 (forall w ty,a<>Eval w ty)->exists t next,Csem.step ge(ExprState f a k e m)t next.
Proof.
 intros ge f a k e m v SA EV NV;pose proof(proj1(branch_immediate _ ge e m SA)_ EV)as IM.
 inversion IM;subst.
 - exfalso;eapply NV;reflexivity.
 - eexists;eexists;left;eapply Csem.step_lred;eauto.
 - eexists;eexists;left;eapply Csem.step_rred;eauto.
 - assert(BAD:branch_simple e0=true)by(eapply branch_context_hole;eauto).
   inversion H;subst;discriminate.
Qed.
Theorem branch_prefix_total : forall ge Q f e m k a v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->
 Total.total ge Q(ExprState f(Eval v(typeof a))k e m)->Total.total ge Q(ExprState f a k e m).
Proof.
 intros ge Q f e m k.
 apply(well_founded_induction(well_founded_ltof _ branch_rank)
  (fun a=>forall v,branch_simple a=true->branch_rval ge e m a=Some v->
   Total.total ge Q(ExprState f(Eval v(typeof a))k e m)->Total.total ge Q(ExprState f a k e m))).
 intros a IH v SA EV END;destruct a eqn:EA;try discriminate SA;try discriminate EV.
 all:try(simpl in EV;inversion EV;subst;exact END).
 all:apply Total.total_next.
 all:try(eapply branch_nonvalue_progress;eauto;intros;discriminate).
 all:intros t next STEP;destruct STEP as[ES|SS].
 all:try(inversion SS;subst;discriminate).
 all:destruct(branch_estep _ _ _ _ _ _ _ _ SA ES)as[BAD|[a'[EQ[TY[SA' EV']]]]].
 all:try(exfalso;eapply(branch_estep_not_stuck _ _ _ _ _ _ _ _ _ SA EV ES);exact BAD).
 all:subst next;apply IH with(v:=v);auto.
 all:try(unfold ltof;eapply branch_estep_rank;eauto).
 all:try(rewrite <-EV';exact EV).
 all:rewrite TY;exact END.
Qed.
Print Assumptions branch_prefix_total.
