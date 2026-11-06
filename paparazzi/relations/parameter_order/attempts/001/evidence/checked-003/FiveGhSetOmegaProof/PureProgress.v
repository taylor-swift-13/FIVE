From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGhSetOmega Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveGhSetOmegaProof Require Import SourceInvariant.
From FiveGhSetOmegaProof Require Import NormalCorrespondence.
Import ListNotations.

Ltac option_cases E :=
 repeat match type of E with
 | context [match ?x with _ => _ end] =>
   let EQ := fresh "EQ" in destruct x eqn:EQ; try discriminate
 end.

Lemma pure_eval_big : forall a ge e m,
 simple a=true ->
 (forall v, pure_rval ge e m a=Some v -> eval_simple_rvalue ge e m a v) /\
 (forall b ofs bf, pure_lval ge e m a=Some(b,ofs,bf) -> eval_simple_lvalue ge e m a b ofs bf).
Proof.
 induction a; intros ge e m SIMPLE; simpl in SIMPLE; core_unpack; try discriminate;
 repeat match goal with
 | IH: forall ge e m, simple ?a=true -> _ /\ _ |- _ =>
   let R:=fresh "RV" in let L:=fresh "LV" in
   pose proof (IH ge e m ltac:(assumption)) as [R L]; clear IH
 end;
 split; intros; cbn [pure_rval pure_lval] in H; try discriminate.
 - inversion H; subst; constructor.
 - option_cases H; inversion H; subst; eauto using esl_var_local, esl_var_global.
 - option_cases H; inversion H; subst; eauto using esl_field_struct, esl_field_union.
 - option_cases H; inversion H; subst.
   match goal with D: do_deref_loc _ _ _ _ _ _ _ = Some _ |- _ =>
    destruct (do_deref_loc_sound _ _ _ _ _ _ _ _ _ _ D) as [DR PT]
   end.
   assert (SIL: t = E0) by (eapply deref_loc_silent; eauto; unfold nv; congruence).
   subst t. econstructor; eauto; try (symmetry; assumption).
   apply negb_true_iff; assumption.
 - option_cases H; inversion H; subst; eauto using esl_deref.
 - option_cases H; inversion H; subst; eauto using esr_addrof.
 - option_cases H; eauto using esr_unop.
 - option_cases H; eauto using esr_binop.
 - option_cases H; eauto using esr_cast.
 - inversion H; subst; constructor.
 - inversion H; subst; constructor.
 - inversion H; subst; constructor.
Qed.

Definition literal (k:kind) (a:expr) : bool :=
 match k,a with RV,Eval _ _ | LV,Eloc _ _ _ _=>true | _,_=>false end.

Lemma lift_immediate : forall ge e m from to C a,
 context from to C -> literal from a=false -> imm_safe ge e from a m ->
 imm_safe ge e to (C a) m.
Proof.
 intros ge e m from to C a CT NL IS; inversion IS; subst; try discriminate.
 - eapply imm_safe_lred with (C:=fun x=>C(C0 x)); eauto using Cstrategy.context_compose.
 - eapply imm_safe_rred with (C:=fun x=>C(C0 x)); eauto using Cstrategy.context_compose.
 - eapply imm_safe_callred with (C:=fun x=>C(C0 x)); eauto using Cstrategy.context_compose.
Qed.

Lemma literal_r_inv : forall a, literal RV a=true -> exists v ty,a=Eval v ty.
Proof. destruct a; simpl; intros; try discriminate; eauto. Qed.
Lemma literal_l_inv : forall a, literal LV a=true -> exists b ofs bf ty,a=Eloc b ofs bf ty.
Proof. destruct a; simpl; intros; try discriminate; eauto. Qed.

Ltac invert_literal_eval :=
 repeat match goal with
 | H:eval_simple_rvalue _ _ _ (Eval _ _) _ |- _ => inversion H; subst; clear H
 | H:eval_simple_lvalue _ _ _ (Eloc _ _ _ _) _ _ _ |- _ => inversion H; subst; clear H
 end.
Lemma big_immediate : forall ge e m,
 (forall a v,eval_simple_rvalue ge e m a v -> imm_safe ge e RV a m) /\
 (forall a b ofs bf,eval_simple_lvalue ge e m a b ofs bf -> imm_safe ge e LV a m).
Proof.
 intros ge e m; apply eval_simple_rvalue_lvalue_ind; intros.
 - constructor.
 - destruct (literal LV l) eqn:LIT.
   + destruct (literal_l_inv _ LIT) as [bl[ol[bfl[tl LITERAL_EQ]]]]; subst l.
     invert_literal_eval; cbn [typeof] in *; subst. eapply imm_safe_rred with (C:=fun x=>x); [|constructor].
     eapply red_rvalof; eauto.
   + eapply lift_immediate with (from:=LV) (C:=fun x=>Evalof x ty); eauto.
     constructor; constructor.
 - destruct (literal LV l) eqn:LIT.
   + destruct (literal_l_inv _ LIT) as [bl[ol[bfl[tl LITERAL_EQ]]]]; subst l.
     invert_literal_eval; cbn [typeof] in *; subst. eapply imm_safe_rred with (C:=fun x=>x); [|constructor].
     constructor.
   + eapply lift_immediate with (from:=LV) (C:=fun x=>Eaddrof x ty); eauto.
     constructor; constructor.
 - destruct (literal RV r1) eqn:LIT.
   + destruct (literal_r_inv _ LIT) as [vr[tr LITERAL_EQ]]; subst r1.
     invert_literal_eval; cbn [typeof] in *; subst. eapply imm_safe_rred with (C:=fun x=>x); [|constructor].
     econstructor; eassumption.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Eunop op x ty); eauto.
     constructor; constructor.
 - destruct (literal RV r1) eqn:L1.
   + destruct (literal_r_inv _ L1) as [vr[tr LITERAL_EQ]]; subst r1. invert_literal_eval; cbn [typeof] in *; subst.
     destruct (literal RV r2) eqn:L2.
     * destruct (literal_r_inv _ L2) as [vr2[tr2 LITERAL_EQ2]]; subst r2. invert_literal_eval; cbn [typeof] in *; subst.
       eapply imm_safe_rred with (C:=fun x=>x); [|constructor]. econstructor; eassumption.
     * eapply lift_immediate with (from:=RV) (C:=fun x=>Ebinop op _ x ty); eauto.
       constructor; constructor.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Ebinop op x r2 ty); eauto.
     constructor; constructor.
 - destruct (literal RV r1) eqn:LIT.
   + destruct (literal_r_inv _ LIT) as [vr[tr LITERAL_EQ]]; subst r1. invert_literal_eval; cbn [typeof] in *; subst.
     eapply imm_safe_rred with (C:=fun x=>x); [|constructor]. econstructor; eassumption.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Ecast x ty); eauto.
     constructor; constructor.
 - eapply imm_safe_rred with (C:=fun x=>x); [|constructor]. constructor.
 - eapply imm_safe_rred with (C:=fun x=>x); [|constructor]. constructor.
 - constructor.
 - eapply imm_safe_lred with (C:=fun x=>x); [|constructor]. econstructor; eassumption.
 - eapply imm_safe_lred with (C:=fun x=>x); [|constructor]. eapply red_var_global; eauto.
 - destruct (literal RV r) eqn:LIT.
   + destruct (literal_r_inv _ LIT) as [vr[tr LITERAL_EQ]]; subst r. invert_literal_eval; cbn [typeof] in *; subst.
     eapply imm_safe_lred with (C:=fun x=>x); [|constructor]. constructor.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Ederef x ty); eauto.
     constructor; constructor.
 - destruct (literal RV r) eqn:LIT.
   + destruct (literal_r_inv _ LIT) as [vr[tr LITERAL_EQ]]; subst r. invert_literal_eval; cbn [typeof] in *; subst.
     eapply imm_safe_lred with (C:=fun x=>x); [|constructor]. eapply red_field_struct; eauto.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Efield x f ty); eauto.
     constructor; constructor.
 - destruct (literal RV r) eqn:LIT.
   + destruct (literal_r_inv _ LIT) as [vr[tr LITERAL_EQ]]; subst r. invert_literal_eval; cbn [typeof] in *; subst.
     eapply imm_safe_lred with (C:=fun x=>x); [|constructor]. eapply red_field_union; eauto.
   + eapply lift_immediate with (from:=RV) (C:=fun x=>Efield x f ty); eauto.
     constructor; constructor.
Qed.

Definition big_defined (ge:genv) (e:env) (m:mem) (k:kind) (a:expr) : Prop :=
 match k with
 | RV=>exists v,eval_simple_rvalue ge e m a v
 | LV=>exists b ofs bf,eval_simple_lvalue ge e m a b ofs bf end.

Lemma big_context_hole : forall from to C,
 context from to C -> forall a ge e m,
 simple(C a)=true -> big_defined ge e m to (C a) -> big_defined ge e m from a.
Proof.
 induction 1; intros a0 ge e m SIMPLE BIG; simpl in SIMPLE; core_unpack; try discriminate; auto;
 unfold big_defined in BIG; repeat match goal with B:exists _,_ |- _=>destruct B end;
 match goal with
 | B:eval_simple_rvalue _ _ _ _ _ |- _=>inversion B; subst
 | B:eval_simple_lvalue _ _ _ _ _ _ _ |- _=>inversion B; subst
 end;
 eapply IHcontext; eauto; unfold big_defined; eauto.
Qed.

Lemma pure_not_stuck : forall ge e m a v,
 simple a=true -> pure_rval ge e m a=Some v -> Csem.not_stuck ge e a m.
Proof.
 intros ge e m a v S EV k C sub CT EQ; subst a.
 pose proof (proj1 (pure_eval_big _ ge e m S) _ EV) as BIG.
 destruct k.
 - destruct (big_context_hole _ _ _ CT sub ge e m S ltac:(unfold big_defined; eauto))
   as [b[ofs[bf L]]]. exact (proj2(big_immediate ge e m) _ _ _ _ L).
 - destruct (big_context_hole _ _ _ CT sub ge e m S ltac:(unfold big_defined; eauto))
   as [w R]. exact (proj1(big_immediate ge e m) _ _ R).
Qed.

Lemma simple_immediate : forall ge e m a,
 simple a=true -> pure_rval ge e m a<>None -> imm_safe ge e RV a m.
Proof.
 intros ge e m a S D. destruct (pure_rval ge e m a) eqn:E; [|contradiction].
 eapply (proj1(big_immediate ge e m)); eapply(proj1(pure_eval_big _ ge e m S)); eauto.
Qed.

Lemma flat_split : forall a,flat_expr a=true ->
 simple a=true \/ exists l r ty,a=Eassign l r ty /\ simple l=true /\ simple r=true.
Proof.
 destruct a; simpl; intros H; try discriminate; try(left;assumption).
 right; exists a1,a2,ty; apply andb_true_iff in H; tauto.
Qed.

Lemma flat_immediate : forall ge e m a v m',
 flat_expr a=true -> flat_eval ge e m a=Some(v,m') -> imm_safe ge e RV a m.
Proof.
 intros ge e m a v m' FL E.
 destruct (flat_split _ FL) as [S|[l[r[ty[EQ[SL SR]]]]]].
 - rewrite (flat_eval_simple ge e m a S) in E.
   eapply simple_immediate; eauto. destruct(pure_rval ge e m a); congruence.
 - subst a. unfold flat_eval in E. option_cases E; inversion E; subst.
   match goal with L:pure_lval _ _ _ _=Some _ |- _=>
    pose proof (proj2(pure_eval_big _ ge e m SL) _ _ _ L) as BL end.
   match goal with R:pure_rval _ _ _ _=Some _ |- _=>
    pose proof (proj1(pure_eval_big _ ge e m SR) _ R) as BR end.
   destruct(literal LV l) eqn:LL.
   + destruct(literal_l_inv _ LL) as [bl[ol[bfl[tl LITERAL_EQ]]]]; subst l.
     invert_literal_eval; cbn [typeof] in *; subst.
     destruct(literal RV r) eqn:LR.
     * destruct(literal_r_inv _ LR) as [vr[tr LITERAL_EQ]]; subst r.
       invert_literal_eval; cbn [typeof] in *; subst.
       match goal with D:do_assign_loc _ _ _ _ _ _ _ _=Some _ |- _=>
        destruct(do_assign_loc_sound _ _ _ _ _ _ _ _ _ _ _ _ D) as [AS PT] end.
       eapply imm_safe_rred with(C:=fun x=>x); [|constructor]. eapply red_assign; eauto.
     * eapply lift_immediate with(from:=RV) (C:=fun x=>Eassign _ x _); eauto.
       constructor; constructor.
       eapply(proj1(big_immediate ge e m)); exact BR.
   + eapply lift_immediate with(from:=LV) (C:=fun x=>Eassign x r _); eauto.
     constructor; constructor.
     eapply(proj2(big_immediate ge e m)); exact BL.
Qed.

Lemma flat_not_stuck : forall ge e m a v m',
 flat_expr a=true -> flat_eval ge e m a=Some(v,m') -> Csem.not_stuck ge e a m.
Proof.
 intros ge e m a v m' FL EV.
 destruct(flat_split _ FL) as [S|[l[r[ty[EQ[SL SR]]]]]].
 - rewrite(flat_eval_simple ge e m a S) in EV.
   destruct(pure_rval ge e m a) eqn:E; try discriminate.
   eapply pure_not_stuck; eauto.
 - subst a. assert(LEFT:exists b ofs bf,pure_lval ge e m l=Some(b,ofs,bf)).
   { unfold flat_eval in EV; option_cases EV; eauto. }
   assert(RIGHT:exists w,pure_rval ge e m r=Some w).
   { unfold flat_eval in EV; option_cases EV; eauto. }
   intros k C sub CT EQ. inversion CT; subst; try discriminate.
   + cbn in EQ; subst sub. eapply flat_immediate; eauto.
   + inversion EQ; subst.
     destruct LEFT as [b[ofs[bf LE]]].
     pose proof(proj2(pure_eval_big _ ge e m SL) _ _ _ LE) as BE.
     match goal with CT:Csem.context _ LV _ |- _ =>
      pose proof(big_context_hole _ _ _ CT sub ge e m SL ltac:(unfold big_defined;eauto)) as HS end.
     destruct k; unfold big_defined in HS.
     * destruct HS as [b0[o0[bf0 HOLE_EVAL]]]. eapply(proj2(big_immediate ge e m));eauto.
     * destruct HS as [w HOLE_EVAL]. eapply(proj1(big_immediate ge e m));eauto.
   + inversion EQ; subst.
     destruct RIGHT as [w RE].
     pose proof(proj1(pure_eval_big _ ge e m SR) _ RE) as BE.
     match goal with CT:Csem.context _ RV _ |- _ =>
      pose proof(big_context_hole _ _ _ CT sub ge e m SR ltac:(unfold big_defined;eauto)) as HS end.
     destruct k; unfold big_defined in HS.
     * destruct HS as [b0[o0[bf0 HOLE_EVAL]]]. eapply(proj2(big_immediate ge e m));eauto.
     * destruct HS as [w0 HOLE_EVAL]. eapply(proj1(big_immediate ge e m));eauto.
Qed.







