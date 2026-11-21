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
  all: simpl; rewrite ?(context_type_eq _ _ _ H a b HT), (pure_context_congr ge e m _ _ _ H a b HT HE); reflexivity.
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
 assert(HT:t=E0) by (match goal with D:deref_loc ge ?T ?M ?B ?O ?BF t ?V|-_=> exact(deref_loc_silent ge T M B O BF t V ltac:(assumption) D) end). subst t.
 match goal with D:deref_loc ge _ _ _ _ _ E0 _ |- _=>
  rewrite(do_deref_loc_complete ge quiet_world _ _ _ _ _ quiet_world E0 _ D (possible_trace_nil _)) end.
 repeat rewrite dec_eq_true; reflexivity.
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
   all: repeat rewrite ID.
   + inversion HR;subst;split;[reflexivity|]. eapply atom_assign_head;eauto.
   + eapply atom_assignop_head;eauto.
Qed.

Lemma atom_split : forall a, atom_expr a=true ->
 simple a=true \/
 (exists l r ty,a=Eassign l r ty /\ simple l=true /\ simple r=true) \/
 (exists op l r tyres ty,a=Eassignop op l r tyres ty /\ simple l=true /\ simple r=true).
Proof.
 destruct a; simpl; intros H; try discriminate; try(left;assumption).
 - right;left;exists a1,a2,ty;apply andb_true_iff in H;tauto.
 - right;right;exists op,a1,a2,tyres,ty;apply andb_true_iff in H;tauto.
Qed.

Lemma atom_immediate : forall ge e m a v mf,
 atom_expr a=true -> atom_eval ge e m a=Some(v,mf) -> imm_safe ge e RV a m.
Proof.
 intros ge e m a v mf AT EV.
 destruct(atom_split _ AT) as [S|[[l[r[ty[EQ[SL SR]]]]]|[op[l[r[tyres[ty[EQ[SL SR]]]]]]]]].
 - rewrite(atom_eval_simple ge e m a S) in EV.
   eapply simple_immediate;eauto. destruct(pure_rval ge e m a);congruence.
 - subst a. eapply flat_immediate.
   + cbn [flat_expr];rewrite SL,SR;reflexivity.
   + exact EV.
 - subst a. unfold atom_eval in EV; option_cases EV; inversion EV;subst.
   match goal with L:pure_lval _ _ _ _=Some _|-_=>
     pose proof(proj2(pure_eval_big _ ge e m SL) _ _ _ L) as BL end.
   match goal with R:pure_rval _ _ _ _=Some _|-_=>
     pose proof(proj1(pure_eval_big _ ge e m SR) _ R) as BR end.
   destruct(literal LV l) eqn:LL.
   + destruct(literal_l_inv _ LL) as [bl[ol[bfl[tl LEQ]]]];subst l.
     invert_literal_eval;cbn [typeof] in *;subst.
     destruct(literal RV r) eqn:LR.
     * destruct(literal_r_inv _ LR) as [vr[tr REQ]];subst r.
       invert_literal_eval;cbn [typeof] in *;subst.
       match goal with D:do_deref_loc _ _ _ _ _ _ _=Some _|-_=>
         destruct(do_deref_loc_sound _ _ _ _ _ _ _ _ _ _ D) as [DR PT] end.
       eapply imm_safe_rred with(C:=fun x=>x);[|constructor].
       eapply red_assignop;eauto.
     * eapply lift_immediate with(from:=RV)(C:=fun x=>Eassignop op _ x tyres _);eauto.
       constructor;constructor. eapply(proj1(big_immediate ge e m));exact BR.
   + eapply lift_immediate with(from:=LV)(C:=fun x=>Eassignop op x r tyres _);eauto.
     constructor;constructor. eapply(proj2(big_immediate ge e m));exact BL.
Qed.

Lemma atom_not_stuck : forall ge e m a v mf,
 atom_expr a=true -> atom_eval ge e m a=Some(v,mf) -> Csem.not_stuck ge e a m.
Proof.
 intros ge e m a v mf AT EV.
 destruct(atom_split _ AT) as [S|[[l[r[ty[EQ[SL SR]]]]]|[op[l[r[tyres[ty[EQ[SL SR]]]]]]]]].
 - rewrite(atom_eval_simple ge e m a S) in EV.
   destruct(pure_rval ge e m a)eqn:E;try discriminate;eapply pure_not_stuck;eauto.
 - subst a. eapply flat_not_stuck.
   + cbn [flat_expr];rewrite SL,SR;reflexivity.
   + exact EV.
 - subst a.
   assert(LEFT:exists b ofs bf,pure_lval ge e m l=Some(b,ofs,bf)).
   { unfold atom_eval in EV;option_cases EV;eauto. }
   assert(RIGHT:exists w,pure_rval ge e m r=Some w).
   { unfold atom_eval in EV;option_cases EV;eauto. }
   intros kind C sub CT EQ;inversion CT;subst;try discriminate.
   + cbn in EQ;subst sub;eapply atom_immediate;eauto.
   + inversion EQ;subst. destruct LEFT as [b[ofs[bf LE]]].
     pose proof(proj2(pure_eval_big _ ge e m SL) _ _ _ LE) as BE.
     match goal with CT:Csem.context _ LV _|-_=>
       pose proof(big_context_hole _ _ _ CT sub ge e m SL ltac:(unfold big_defined;eauto)) as HS end.
     destruct kind;unfold big_defined in HS.
     * destruct HS as [b0[o0[bf0 H]]];eapply(proj2(big_immediate ge e m));eauto.
     * destruct HS as [w H];eapply(proj1(big_immediate ge e m));eauto.
   + inversion EQ;subst. destruct RIGHT as [w RE].
     pose proof(proj1(pure_eval_big _ ge e m SR) _ RE) as BE.
     match goal with CT:Csem.context _ RV _|-_=>
       pose proof(big_context_hole _ _ _ CT sub ge e m SR ltac:(unfold big_defined;eauto)) as HS end.
     destruct kind;unfold big_defined in HS.
     * destruct HS as [b0[o0[bf0 H]]];eapply(proj2(big_immediate ge e m));eauto.
     * destruct HS as [w0 H];eapply(proj1(big_immediate ge e m));eauto.
Qed.

Fixpoint atom_rank(a:expr):nat:=
 match a with
 | Eval _ _ | Eloc _ _ _ _=>0%nat
 | Evar _ _ | Esizeof _ _ | Ealignof _ _=>1%nat
 | Efield a _ _ | Evalof a _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _=>S(atom_rank a)
 | Ebinop _ a b _ | Eassign a b _=>S(atom_rank a+atom_rank b)
 | Eassignop _ a b _ _=>(4+atom_rank a+atom_rank b)%nat
 | _=>0%nat end.
Lemma atom_rank_lred:forall ge e a m a' m',
 lred ge e a m a' m'->atom_rank a'<atom_rank a.
Proof. intros;inversion H;subst;simpl;lia. Qed.
Lemma atom_rank_rred:forall ge a m t a' m',
 atom_expr a=true->rred ge a m t a' m'->atom_rank a'<atom_rank a.
Proof. intros;inversion H0;subst;simpl in *;core_unpack;try discriminate;lia. Qed.
Lemma atom_rank_context:forall from to C,context from to C->forall a b,
 atom_expr(C a)=true->atom_rank b<atom_rank a->atom_rank(C b)<atom_rank(C a).
Proof.
 induction 1;simpl;intros;core_unpack;try discriminate;try lia;
 match goal with IH:forall a b,_|-_=>
  assert(D:atom_rank(C b)<atom_rank(C a))by(apply IH;eauto using atom_of_simple);lia end.
Qed.

Lemma atom_estep:forall ge f a k e m t next,
 atom_expr a=true->core_expr a=true->Csem.estep ge(ExprState f a k e m)t next->
 next=Stuckstate \/ exists a' m',next=ExprState f a' k e m' /\ typeof a'=typeof a /\
 atom_expr a'=true /\ core_expr a'=true /\ atom_eval ge e m a=atom_eval ge e m' a'.
Proof.
 intros ge f a k e m t next AT CO ES;inversion ES;subst.
 - destruct(atom_lred_context ge e m a0 a' m' LV C H7 eq_refl AT H6)as[HM[NF EQ]].
   destruct(pure_lred ge e a0 m a' m' H6)as[_[TY[_ _]]]. subst m'.
   right;exists(C a'),m;repeat split;auto.
   + exact(context_type_eq _ _ _ H7 _ _ TY).
   + eapply core_context_replace;[exact H7|exact CO|].
     eapply core_lred;[exact(core_context_hole _ _ _ H7 _ CO)|exact H6].
 - match goal with RR:rred ge ?A m t ?A' ?M',HC:Csem.context RV RV ?C|-_=>
   destruct(atom_rred_context ge e m A A' t M' C HC AT CO RR)as[NF EQ];
   right;exists(C A'),M';repeat split;auto end.
   + eapply context_type_eq;eauto. match goal with RR:rred _ _ _ _ _ _|-_=>inversion RR;subst;simpl;auto end.
   + eapply core_context_replace;eauto.
     eapply(proj2(core_rred _ _ _ _ _ _ ltac:(eapply core_context_hole;eauto)ltac:(eassumption))).
 - exfalso;eapply core_no_callred;[eapply core_context_hole;eauto|eassumption].
 - left;reflexivity.
Qed.

Theorem atom_prefix_total:forall ge Q f e k a m v mf,
 atom_expr a=true->core_expr a=true->atom_eval ge e m a=Some(v,mf)->
 Total.total ge Q(ExprState f(Eval v(typeof a))k e mf)->Total.total ge Q(ExprState f a k e m).
Proof.
 intros ge Q f e k.
 apply(well_founded_induction(well_founded_ltof _ atom_rank)
  (fun a=>forall m v mf,atom_expr a=true->core_expr a=true->atom_eval ge e m a=Some(v,mf)->
    Total.total ge Q(ExprState f(Eval v(typeof a))k e mf)->Total.total ge Q(ExprState f a k e m))).
 intros a IH m v mf AT CO EV END.
 destruct a eqn:EA;try discriminate AT.
 all: try(simpl in EV;inversion EV;subst;exact END).
 all: apply Total.total_next.
 all: try(assert(IM:imm_safe ge e RV _ m)by(eapply atom_immediate;eauto);
   inversion IM;subst;
   [discriminate|eexists;eexists;left;eapply Csem.step_lred;eauto|
    eexists;eexists;left;eapply Csem.step_rred;eauto|
    exfalso; eapply core_no_callred;[eapply core_context_hole;eauto|eassumption]]).
 all: intros t next STEP;destruct STEP as[ES|SS].
 all: try(inversion SS;subst;discriminate).
 all: destruct(atom_estep _ _ _ _ _ _ _ _ AT CO ES)as[BAD|[a'[m'[EQ[TY[AT'[CO' EV']]]]]]].
 all: try(subst next;inversion ES;subst;
   pose proof(atom_not_stuck _ _ _ _ _ _ AT EV)as NS;
   match goal with H:~Csem.imm_safe _ _ _ _ _|-_=>apply H;eapply NS;eauto end).
 all: subst next;apply IH with(v:=v)(mf:=mf);auto.
 all: try(unfold ltof;inversion ES;subst;eapply atom_rank_context;eauto using atom_rank_lred,atom_rank_rred,atom_context_hole).
 all: try(rewrite <-EV';exact EV).
 all: rewrite TY;exact END.
Qed.
