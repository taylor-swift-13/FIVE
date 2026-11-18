From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cstrategy Smallstep.
Import ListNotations.
Local Open Scope Z_scope.

(** Generic construction lemmas for real Cstrategy executions.  These do not
    replace or alter the generated Csyntax, and make no assumption of a return. *)
Fixpoint source_simple (a : expr) : bool :=
 match a with
 | Eval _ _ | Evar _ _ | Esizeof _ _ | Ealignof _ _=>true
 | Ederef r _ | Efield r _ _ | Eaddrof r _ | Eunop _ r _ | Ecast r _=>source_simple r
 | Evalof l _=>source_simple l && negb(type_is_volatile(typeof l))
 | Ebinop _ r s _=>source_simple r && source_simple s
 | _=>false end.
Lemma simple_eval_expr_refl : forall ge e m,
 (forall a v, Cstrategy.eval_simple_rvalue ge e m a v -> source_simple a=true ->
   Cstrategy.eval_expr ge e m RV a E0 m a) /\
 (forall a b ofs bf, Cstrategy.eval_simple_lvalue ge e m a b ofs bf -> source_simple a=true ->
   Cstrategy.eval_expr ge e m LV a E0 m a).
Proof.
 intros ge e m;apply Cstrategy.eval_simple_rvalue_lvalue_ind;
 intros; simpl in *;
 repeat match goal with H : _ && _ =true |- _ => apply andb_true_iff in H;destruct H end;
 try discriminate;
 try solve [constructor;auto];
 try solve [replace E0 with (E0**E0) by reflexivity; eapply Cstrategy.eval_binop;eauto];
 try solve [eapply Cstrategy.eval_valof;[|eauto];apply negb_true_iff in H0;exact H0].
 all: eapply Cstrategy.eval_valof;[match goal with H: negb _=true |- _=>apply negb_true_iff in H;exact H end|eauto].
Qed.
Lemma simple_expression : forall ge e m a v,
 Cstrategy.eval_simple_rvalue ge e m a v -> source_simple a=true ->
 Cstrategy.eval_expression ge e m a E0 m v.
Proof.
 intros ge e m a v EV SI;eapply Cstrategy.eval_expression_intro;
 [eapply(proj1(simple_eval_expr_refl ge e m));eauto|exact EV].
Qed.
Lemma atomic_assign : forall ge e m l r ty b ofs bf v vc v' mf,
 Cstrategy.eval_simple_lvalue ge e m l b ofs bf -> source_simple l=true ->
 Cstrategy.eval_simple_rvalue ge e m r v -> source_simple r=true ->
 sem_cast v (typeof r) (typeof l) m=Some vc ->
 assign_loc ge (typeof l) m b ofs bf vc E0 mf v' -> ty=typeof l ->
 Cstrategy.exec_stmt ge e m (Sdo(Eassign l r ty)) E0 mf Out_normal.
Proof.
 intros ge e m l r ty b ofs bf v vc v' mf LL SL RR SR CAST STORE TY.
 eapply Cstrategy.exec_Sdo.
 eapply Cstrategy.eval_expression_intro with (a':=Eval v' ty);[|constructor].
 replace E0 with (E0**E0**E0) by reflexivity.
 eapply Cstrategy.eval_assign;
 [eapply(proj2(simple_eval_expr_refl ge e m));eauto|
 eapply(proj1(simple_eval_expr_refl ge e m));eauto|exact LL|exact RR|exact CAST|exact STORE|exact TY].
Qed.
Lemma atomic_assignop : forall ge e m op l r tyres ty b ofs bf vl vr vop vc v' mf,
 Cstrategy.eval_simple_lvalue ge e m l b ofs bf -> source_simple l=true ->
 Cstrategy.eval_simple_rvalue ge e m r vr -> source_simple r=true ->
 deref_loc ge (typeof l) m b ofs bf E0 vl ->
 sem_binary_operation ge op vl (typeof l) vr (typeof r) m=Some vop ->
 sem_cast vop tyres (typeof l) m=Some vc ->
 assign_loc ge (typeof l) m b ofs bf vc E0 mf v' -> ty=typeof l ->
 Cstrategy.exec_stmt ge e m (Sdo(Eassignop op l r tyres ty)) E0 mf Out_normal.
Proof.
 intros ge e m op l r tyres ty b ofs bf vl vr vop vc v' mf LL SL RR SR LOAD OP CAST STORE TY.
 eapply Cstrategy.exec_Sdo.
 eapply Cstrategy.eval_expression_intro with (a':=Eval v' ty);[|constructor].
 replace E0 with (E0**E0**E0**E0) by reflexivity.
 eapply Cstrategy.eval_assignop;
 [eapply(proj2(simple_eval_expr_refl ge e m));eauto|
 eapply(proj1(simple_eval_expr_refl ge e m));eauto|exact LL|exact LOAD|exact RR|exact OP|exact CAST|exact STORE|exact TY].
Qed.
Lemma sequence_normal : forall ge e a b m ma mf out,
 Cstrategy.exec_stmt ge e m a E0 ma Out_normal ->
 Cstrategy.exec_stmt ge e ma b E0 mf out ->
 Cstrategy.exec_stmt ge e m (Ssequence a b) E0 mf out.
Proof. intros;replace E0 with (E0**E0) by reflexivity;eapply Cstrategy.exec_Sseq_1;eauto. Qed.
Lemma read_scalar : forall ge e m l ty chunk b ofs v,
 Cstrategy.eval_simple_lvalue ge e m l b ofs Full ->
 ty=typeof l -> type_is_volatile ty=false -> access_mode ty=By_value chunk ->
 Mem.loadv chunk m (Vptr b ofs)=Some v ->
 Cstrategy.eval_simple_rvalue ge e m (Evalof l ty) v.
Proof. intros; eapply Cstrategy.esr_rvalof;eauto;eapply deref_loc_value;eauto. Qed.
Lemma assign_scalar : forall ge m ty chunk b ofs v mf,
 type_is_volatile ty=false -> access_mode ty=By_value chunk ->
 Mem.storev chunk m (Vptr b ofs) v=Some mf ->
 assign_loc ge ty m b ofs Full v E0 mf v.
Proof. intros;eapply assign_loc_value;eauto. Qed.
Print Assumptions simple_eval_expr_refl.
Print Assumptions atomic_assignop.
Lemma strategy_star_csem : forall ge a t b,
 star Cstrategy.step ge a t b -> star Csem.step ge a t b.
Proof.
 intros ge a t b H;induction H.
 - constructor.
 - eapply star_trans;[apply plus_star;eapply Cstrategy.step_simulation;exact H|exact IHstar|exact H1].
Qed.
Lemma funcall_original_normal : forall ge m fd args t mf res,
 Cstrategy.eval_funcall ge m fd args t mf res ->
 star Csem.step ge (Callstate fd args Kstop m) t (Returnstate res Kstop mf).
Proof.
 intros;apply strategy_star_csem;eapply Cstrategy.eval_funcall_to_steps;[exact H|exact I].
Qed.
Print Assumptions funcall_original_normal.
Definition access_preserved (m mf:mem) : Prop := forall ch b ofs p,
 Mem.valid_access m ch b ofs p -> Mem.valid_access mf ch b ofs p.
Inductive stores_to (allowed:block->Prop) : mem->mem->Prop :=
 | stores_to_refl : forall m, stores_to allowed m m
 | stores_to_step : forall m ma mf ch b ofs v,
 allowed b -> Mem.store ch m b ofs v=Some ma -> stores_to allowed ma mf -> stores_to allowed m mf.
Lemma stores_to_trans : forall P m ma mf,
 stores_to P m ma -> stores_to P ma mf -> stores_to P m mf.
Proof. intros P m ma mf H;induction H;intros;[assumption|eapply stores_to_step;eauto]. Qed.
Lemma stores_to_access : forall P m mf, stores_to P m mf -> access_preserved m mf.
Proof.
 intros P m mf H;induction H;unfold access_preserved in *;intros;[assumption|].
 apply IHstores_to;eapply Mem.store_valid_access_1;eauto.
Qed.
Lemma stores_to_load_frame : forall P m mf, stores_to P m mf ->
 forall ch b ofs, ~P b -> Mem.load ch mf b ofs=Mem.load ch m b ofs.
Proof.
 intros P m mf H;induction H;intros ch0 b0 ofs0 NP;[reflexivity|].
 rewrite IHstores_to by exact NP.
 erewrite Mem.load_store_other by(exact H0||(left;intro;subst;contradiction));reflexivity.
Qed.
Lemma sequence_normal_inv : forall ge e a b m mf,
 Cstrategy.exec_stmt ge e m(Ssequence a b)E0 mf Out_normal ->
 exists ma, Cstrategy.exec_stmt ge e m a E0 ma Out_normal /\
 Cstrategy.exec_stmt ge e ma b E0 mf Out_normal.
Proof.
 intros ge e a b m mf H;inversion H;subst;try contradiction.
 match goal with EQ:?x ** ?y=E0 |- _=>change(x++y=[])in EQ;apply app_eq_nil in EQ as [-> ->] end.
 eexists;split;eassumption.
Qed.
Print Assumptions stores_to_load_frame.
Lemma statement_prefix_path : forall ge e m a mf,
 Cstrategy.exec_stmt ge e m a E0 mf Out_normal -> forall f k tail,
 star Csem.step ge(State f(Ssequence a tail)k e m)E0(State f tail k e mf).
Proof.
 intros ge e m a mf EVAL f k tail.
 destruct(Cstrategy.exec_stmt_to_steps ge e m a E0 mf Out_normal EVAL f(Kseq tail k))as[reached[PATH END]].
 inversion END;subst reached.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_seq| |reflexivity].
 eapply star_trans with(t1:=E0)(t2:=E0).
 - apply strategy_star_csem;exact PATH.
 - apply star_one;right;apply Csem.step_skip_seq.
 - reflexivity.
Qed.
Print Assumptions statement_prefix_path.
Lemma stores_to_weaken : forall P Q m mf,
 (forall b,P b ->Q b) ->stores_to P m mf ->stores_to Q m mf.
Proof.
 intros P Q m mf INC H;induction H;[constructor|eapply stores_to_step;eauto].
Qed.
