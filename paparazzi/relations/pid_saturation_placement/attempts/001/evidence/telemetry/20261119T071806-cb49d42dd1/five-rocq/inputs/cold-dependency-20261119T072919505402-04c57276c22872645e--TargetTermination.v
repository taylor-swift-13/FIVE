From Stdlib Require Import List Bool Arith Lia Wellfounded.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import WeightedTermination.
Import ListNotations.
Local Open Scope nat_scope.

(** Function-target-aware expression rank.  Different functions having the
    same C type retain distinct budgets.  No evaluation-order restriction. *)
Section TARGET.
Variable ge:genv.
Variable block_cost:block -> nat.
Variable symbol_cost:ident -> nat.
Hypothesis symbol_cost_binding:forall id b,Genv.find_symbol ge id=Some b -> symbol_cost id=block_cost b.
Definition pointer_cost(v:val):nat :=
 match v with Vptr b _=>block_cost b|_=>0 end.
Definition lvalue_cost(a:expr):nat :=
 match a with Evar id _=>symbol_cost id|Eloc b _ _ _=>block_cost b|_=>0 end.
Definition function_cost(a:expr):nat :=
 match a with Eval v _=>pointer_cost v|Evalof a _=>lvalue_cost a|_=>0 end.
Inductive function_lvalue:expr -> Prop :=
 | fl_var:forall id ps ret cc,function_lvalue(Evar id(Tfunction ps ret cc))
 | fl_loc:forall b ofs ps ret cc,function_lvalue(Eloc b ofs Full(Tfunction ps ret cc)).
Inductive function_value:expr -> Prop :=
 | fv_literal:forall v ty,function_value(Eval v ty)
 | fv_load:forall a ty,function_lvalue a -> function_value(Evalof a ty).
Definition preserves_designators(a b:expr):Prop :=
 (function_lvalue a -> function_lvalue b /\ lvalue_cost a=lvalue_cost b) /\
 (function_value a -> function_value b /\ function_cost a=function_cost b).
Definition env_no_functions(e:env):Prop :=
 forall id b ps ret cc,e!id<>Some(b,Tfunction ps ret cc).
Scheme context_target_ind := Induction for context Sort Prop
with contextlist_target_ind := Induction for contextlist Sort Prop.
Combined Scheme contexts_target_ind from context_target_ind,contextlist_target_ind.
Lemma designators_context_mut:
 (forall from to C,context from to C -> forall a b,
 preserves_designators a b -> preserves_designators(C a)(C b)) /\
 (forall from C,contextlist from C -> True).
Proof.
 apply contexts_target_ind;intros;simpl;try exact I.
 all: try solve[split;intros BAD;inversion BAD].
 - exact H.
 - split;intros BAD;inversion BAD;subst.
   destruct(H a b H0)as[LOC VAL].
   match goal with FL:function_lvalue(C a) |- _=>
   destruct(LOC FL)as[LB EQ];split;[constructor;exact LB|exact EQ] end.
Qed.
Lemma designators_context:forall from to C,context from to C -> forall a b,
 preserves_designators a b -> preserves_designators(C a)(C b).
Proof. exact(proj1 designators_context_mut). Qed.
Lemma lred_designators:forall e a m b m',
 env_no_functions e -> lred ge e a m b m' -> preserves_designators a b.
Proof.
 intros e a m b m' EN RED;inversion RED;subst;split;intros DF;inversion DF;subst.
 - exfalso;eapply EN;eassumption.
 - split;[constructor|simpl;eapply symbol_cost_binding;eassumption].
Qed.
Lemma rred_designators:forall a m t b m',
 rred ge a m t b m' -> preserves_designators a b.
Proof.
 intros a m t b m' RED;inversion RED;subst;split;intros DF;inversion DF;subst.
 match goal with F:function_lvalue(Eloc _ _ _ _) |- _=>inversion F;subst end.
 match goal with D:deref_loc _ _ _ _ _ _ _ _ |- _=>inversion D;subst;try discriminate end.
 split;[constructor|reflexivity].
Qed.

Fixpoint core_expr(a:expr):Prop :=
 match a with
 | Eval _ _ | Eloc _ _ _ _ | Evar _ _ | Esizeof _ _ | Ealignof _ _=>True
 | Efield a _ _ | Evalof a _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _ | Epostincr _ a _=>core_expr a
 | Ebinop _ a b _ | Eassign a b _ | Ecomma a b _
 | Eseqand a b _ | Eseqor a b _ | Eassignop _ a b _ _=>core_expr a /\ core_expr b
 | Econdition a b c _=>core_expr a /\ core_expr b /\ core_expr c
 | Ecall a al _=>core_expr a /\ core_exprlist al /\ function_value a
 | Ebuiltin _ _ al _=>core_exprlist al
 end
with core_exprlist(al:exprlist):Prop :=
 match al with Enil=>True|Econs a al=>core_expr a /\ core_exprlist al end.
Ltac unpack := repeat match goal with H:_ /\ _ |- _=>destruct H end.
Lemma core_context_mut:
 (forall from to C,context from to C -> forall a b,
 core_expr(C a) -> core_expr a /\
 (preserves_designators a b -> core_expr b -> core_expr(C b))) /\
 (forall from C,contextlist from C -> forall a b,
 core_exprlist(C a) -> core_expr a /\
 (preserves_designators a b -> core_expr b -> core_exprlist(C b))).
Proof.
 apply contexts_target_ind;simpl;intros;unpack;
 try solve[split;auto;intros;repeat split;auto].
 all: try match goal with IH:forall a b,_ |- _=>
 specialize(IH a b ltac:(assumption));destruct IH as[HO HR];
 split;auto;intros;repeat split;auto end.
 all: try match goal with CT:Csem.context _ _ ?C,FV:function_value(?C ?A),
 PD:preserves_designators ?A ?B |- _=>
 exact(proj1((proj2(designators_context _ _ _ CT A B PD))FV)) end.
Qed.
Lemma core_context_hole:forall from to C,context from to C -> forall a,
 core_expr(C a) -> core_expr a.
Proof. intros;exact(proj1(proj1 core_context_mut _ _ _ H a a H0)). Qed.
Lemma core_context_replace:forall from to C,context from to C -> forall a b,
 core_expr(C a) -> preserves_designators a b -> core_expr b -> core_expr(C b).
Proof. intros;eapply(proj2(proj1 core_context_mut _ _ _ H a b H0));eauto. Qed.
Lemma core_lred:forall e a m b m',lred ge e a m b m' -> core_expr b.
Proof. intros;inversion H;subst;simpl;exact I. Qed.
Lemma core_rred:forall a m t b m',
 core_expr a -> rred ge a m t b m' -> core_expr b.
Proof. intros a m t b m' CO RED;inversion RED;subst;simpl in *;unpack;auto;
 try(repeat split;auto);destruct b0;simpl;auto. Qed.
Lemma call_to_literal_designators:forall a al ty v ty',
 preserves_designators(Ecall a al ty)(Eval v ty').
Proof. intros;split;intros BAD;inversion BAD. Qed.

Fixpoint expression_rank(a:expr):nat :=
 match a with
 | Eval _ _ | Eloc _ _ _ _=>0
 | Evar _ _ | Esizeof _ _ | Ealignof _ _=>1
 | Efield a _ _ | Evalof a _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _=>S(expression_rank a)
 | Ebinop _ a b _ | Eassign a b _ | Ecomma a b _=>S(expression_rank a+expression_rank b)
 | Eassignop _ a b _ _=>3+expression_rank a+expression_rank b
 | Epostincr _ a _=>4+expression_rank a
 | Eseqand a b _ | Eseqor a b _=>2+expression_rank a+expression_rank b
 | Econdition a b c _=>2+expression_rank a+expression_rank b+expression_rank c
 | Ecall a al _=>1+function_cost a+expression_rank a+expressionlist_rank al
 | Ebuiltin _ _ al _=>1+expressionlist_rank al
 end
with expressionlist_rank(al:exprlist):nat :=
 match al with Enil=>0|Econs a al=>expression_rank a+expressionlist_rank al end.
Lemma lred_rank_decreases:forall e a m b m',
 lred ge e a m b m' -> expression_rank b<expression_rank a.
Proof. intros;inversion H;subst;simpl;lia. Qed.
Lemma rred_rank_decreases:forall a m t b m',
 rred ge a m t b m' -> expression_rank b<expression_rank a.
Proof. intros;inversion H;subst;simpl;try lia;destruct b0;simpl;lia. Qed.
Lemma context_rank_decreases_mut:
 (forall from to C,context from to C -> forall a b,
 core_expr(C a) -> preserves_designators a b ->
 expression_rank b<expression_rank a -> expression_rank(C b)<expression_rank(C a)) /\
 (forall from C,contextlist from C -> forall a b,
 core_exprlist(C a) -> preserves_designators a b ->
 expression_rank b<expression_rank a -> expressionlist_rank(C b)<expressionlist_rank(C a)).
Proof.
 apply contexts_target_ind;simpl;intros;unpack;try lia.
 all: try match goal with IH:forall a b,_ |- _=>
 specialize(IH a b ltac:(assumption) ltac:(assumption) ltac:(assumption));try lia end.
 match goal with CT:Csem.context _ _ ?C,FV:function_value(?C ?A),
 PD:preserves_designators ?A ?B |- _=>
 pose proof(proj2((proj2(designators_context _ _ _ CT A B PD))FV))as EQ;
 rewrite <-EQ;lia end.
Qed.
Lemma context_rank_decreases:forall from to C,context from to C -> forall a b,
 core_expr(C a) -> preserves_designators a b ->
 expression_rank b<expression_rank a -> expression_rank(C b)<expression_rank(C a).
Proof. exact(proj1 context_rank_decreases_mut). Qed.

Fixpoint statement_rank(s:statement):nat :=
 match s with
 | Sskip | Sreturn None=>1
 | Sdo a | Sreturn(Some a)=>expression_rank a+4
 | Ssequence a b=>statement_rank a+statement_rank b+2
 | Sifthenelse a b c=>expression_rank a+statement_rank b+statement_rank c+6
 | _=>0 end.
Fixpoint core_stmt(s:statement):Prop :=
 match s with
 | Sskip | Sreturn None=>True
 | Sdo a | Sreturn(Some a)=>core_expr a
 | Ssequence a b=>core_stmt a /\ core_stmt b
 | Sifthenelse a b c=>core_expr a /\ core_stmt b /\ core_stmt c
 | _=>False end.
Inductive core_cont:cont -> Prop :=
 | core_stop:core_cont Kstop
 | core_seq:forall s k,core_stmt s -> core_cont k -> core_cont(Kseq s k)
 | core_do:forall k,core_cont k -> core_cont(Kdo k)
 | core_return:forall k,core_cont k -> core_cont(Kreturn k)
 | core_if:forall a b k,core_stmt a -> core_stmt b -> core_cont k -> core_cont(Kifthenelse a b k)
 | core_call:forall f e C ty k,
 context RV RV C -> env_no_functions e ->
 (forall v,core_expr(C(Eval v ty))) ->
 (forall v,expression_rank(C(Eval v ty))=expression_rank(C(Eval Vundef ty))) ->
 core_cont k -> core_cont(Kcall f e C ty k).
Fixpoint continuation_rank(k:cont):nat :=
 match k with
 | Kstop=>0
 | Kseq s k=>statement_rank s+continuation_rank k+1
 | Kdo k | Kreturn k=>continuation_rank k+2
 | Kifthenelse a b k=>statement_rank a+statement_rank b+continuation_rank k+3
 | Kcall _ _ C ty k=>expression_rank(C(Eval Vundef ty))+continuation_rank k+2
 | _=>0 end.
Definition activation_rank(fd:Csyntax.fundef):nat :=
 match fd with Internal f=>statement_rank(fn_body f)+2|External _ _ _ _=>2 end.
Definition state_rank(s:Csem.state):nat :=
 match s with
 | State _ st k _ _=>statement_rank st+continuation_rank k+1
 | ExprState _ a k _ _=>expression_rank a+continuation_rank k+1
 | Callstate fd _ k _=>activation_rank fd+continuation_rank k
 | Returnstate _ k _=>continuation_rank k+1
 | Stuckstate=>0 end.
Variable allowed:Csyntax.fundef -> Prop.
Definition source_state(s:Csem.state):Prop :=
 match s with
 | State _ st k e _=>core_stmt st /\ core_cont k /\ env_no_functions e
 | ExprState _ a k e _=>core_expr a /\ core_cont k /\ env_no_functions e
 | Callstate fd _ k _=>allowed fd /\ core_cont k
 | Returnstate _ k _=>core_cont k
 | Stuckstate=>True end.
Hypothesis allowed_call:forall v fd,Genv.find_funct ge v=Some fd -> allowed fd.
Hypothesis internal_body:forall f,allowed(Internal f) -> core_stmt(fn_body f).
Hypothesis internal_env:forall f,allowed(Internal f) -> forall m e m',
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e m' -> env_no_functions e.
Hypothesis call_budget:forall v fd,Genv.find_funct ge v=Some fd ->
 activation_rank fd+2<1+pointer_cost v.

Lemma core_call_cont:forall k,core_cont k -> core_cont(call_cont k).
Proof. induction 1;simpl;auto using core_cont. Qed.
Lemma call_cont_rank:forall k,core_cont k ->
 continuation_rank(call_cont k)<=continuation_rank k.
Proof. induction 1;simpl;lia. Qed.

Lemma call_not_designator_context_mut:
 (forall from to C,context from to C -> forall a al ty,
 ~function_lvalue(C(Ecall a al ty)) /\ ~function_value(C(Ecall a al ty))) /\
 (forall from C,contextlist from C -> True).
Proof.
 apply contexts_target_ind;intros;try exact I;split;intros BAD;inversion BAD;subst.
 match goal with IH:forall a al ty,_ /\ _,FL:function_lvalue(C(Ecall _ _ _)) |- _=>
 eapply(proj1(IH _ _ _));exact FL end.
Qed.
Lemma call_context_additive_mut:
 (forall from to C,context from to C -> forall a al ty,
 core_expr(C(Ecall a al ty)) -> forall v,
 expression_rank(C(Ecall a al ty))=
 expression_rank(C(Eval v ty))+expression_rank(Ecall a al ty)) /\
 (forall from C,contextlist from C -> forall a al ty,
 core_exprlist(C(Ecall a al ty)) -> forall v,
 expressionlist_rank(C(Ecall a al ty))=
 expressionlist_rank(C(Eval v ty))+expression_rank(Ecall a al ty)).
Proof.
 apply contexts_target_ind;simpl;intros;unpack;try lia.
 all: try match goal with IH:forall a al ty,_, CO:core_expr(?C(Ecall ?A ?AL ?TY)) |- _=>
 specialize(IH A AL TY CO v);try lia end.
 all: try match goal with IH:forall a al ty,_, CO:core_exprlist(?C(Ecall ?A ?AL ?TY)) |- _=>
 specialize(IH A AL TY CO v);try lia end.
 all: exfalso;match goal with CT:Csem.context _ _ ?C,
 FV:function_value(?C(Ecall ?A ?AL ?TY)) |- _=>
 exact(proj2(proj1 call_not_designator_context_mut _ _ _ CT A AL TY)FV) end.
Qed.
Lemma call_context_rank:forall C a al ty,context RV RV C ->
 core_expr(C(Ecall a al ty)) -> forall v,
 expression_rank(C(Eval v ty))=expression_rank(C(Eval Vundef ty)).
Proof.
 intros C a al ty CT CO v.
 pose proof(proj1 call_context_additive_mut _ _ _ CT a al ty CO v).
 pose proof(proj1 call_context_additive_mut _ _ _ CT a al ty CO Vundef).
 lia.
Qed.

Lemma source_estep:forall s t next,
 source_state s -> estep ge s t next -> source_state next.
Proof.
 intros s t next INV STEP;inversion STEP;subst;simpl in INV;unpack.
 - simpl;repeat split;auto.
   eapply core_context_replace;[eassumption|eassumption|eapply lred_designators;eauto|eapply core_lred;eauto].
 - simpl;repeat split;auto.
   eapply core_context_replace;[eassumption|eassumption|eapply rred_designators;eauto|].
   eapply core_rred;[eapply core_context_hole;eauto|eassumption].
 - simpl;split.
   + inversion H;subst;eapply allowed_call;eassumption.
   + eapply core_call;[eassumption|eassumption| | |eassumption].
     * intros v;inversion H;subst.
       eapply core_context_replace;[eassumption|eassumption|apply call_to_literal_designators|exact I].
     * intros v;inversion H;subst;eapply call_context_rank;eauto.
 - exact I.
Qed.
Lemma source_sstep:forall s t next,
 source_state s -> sstep ge s t next -> source_state next.
Proof.
 intros s t next INV STEP;inversion STEP;subst;simpl in INV;unpack;try contradiction;
 simpl;try(repeat split;eauto using core_cont,core_call_cont,internal_body,internal_env;fail).
 all: try match goal with CC:core_cont(Kseq _ _) |- _=>inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kdo _) |- _=>inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kifthenelse _ _ _) |- _=>inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kreturn _) |- _=>inversion CC;subst;eauto using core_call_cont end.
 all: try match goal with CC:core_cont(Kcall _ _ _ _ _) |- _=>inversion CC;subst;auto end.
 all: try match goal with CC:core_cont ?K |- _=>tryif is_var K then fail else(inversion CC;subst;auto)end.
 destruct b;auto.
Qed.
Lemma source_step:forall s t next,
 source_state s -> Csem.step ge s t next -> source_state next.
Proof. intros s t next INV[ES|SS];eauto using source_estep,source_sstep. Qed.
Lemma cast_arguments_rank:forall m el types vals,
 cast_arguments m el types vals -> expressionlist_rank el=0.
Proof. induction 1;simpl;auto. Qed.
Lemma estep_rank_decreases:forall s t next,
 source_state s -> estep ge s t next -> state_rank next<state_rank s.
Proof.
 intros s t next INV STEP;inversion STEP;subst;simpl in INV;unpack;cbn[state_rank].
 - assert(DEC:expression_rank(C a')<expression_rank(C a)).
   { eapply context_rank_decreases;[eassumption|eassumption|eapply lred_designators;eauto|eapply lred_rank_decreases;eauto]. } lia.
 - assert(DEC:expression_rank(C a')<expression_rank(C a)).
   { eapply context_rank_decreases;[eassumption|eassumption|eapply rred_designators;eauto|eapply rred_rank_decreases;eauto]. } lia.
 - inversion H;subst.
   pose proof(proj1 call_context_additive_mut _ _ _ H0 _ _ _ ltac:(eassumption) Vundef)as ADD.
   match goal with CA:cast_arguments _ _ _ _ |- _=>pose proof(cast_arguments_rank _ _ _ _ CA)as AR end.
   match goal with FF:Genv.find_funct _ _=Some _ |- _=>pose proof(call_budget _ _ FF)as BUD end.
   cbn[expression_rank function_cost]in ADD;rewrite AR in ADD.
   cbn[continuation_rank].
   lia.
 - lia.
Qed.
Lemma sstep_rank_decreases:forall s t next,
 source_state s -> sstep ge s t next -> state_rank next<state_rank s.
Proof.
 intros s t next INV STEP;inversion STEP;subst;simpl in INV;unpack;try contradiction;
 simpl[state_rank activation_rank statement_rank continuation_rank];try lia.
 all: try match goal with CC:core_cont ?K |- _=>inversion CC;subst;simpl in *;try contradiction;try lia end.
 all: try match goal with CC:core_cont ?K |- _=>pose proof(call_cont_rank K CC);lia end.
 all: try(destruct b;simpl;lia).
 all: try match goal with UNIFORM:forall v,expression_rank(_(Eval v _))=_ |- _=>rewrite UNIFORM;lia end.
Qed.
Theorem all_successors_accessible:forall s,source_state s -> Acc(successor ge)s.
Proof.
 apply(well_founded_induction(well_founded_ltof _ state_rank)
 (fun s=>source_state s -> Acc(successor ge)s)).
 intros s IH INV;constructor;intros next[t STEP];apply IH.
 - unfold ltof;destruct STEP as[ES|SS];eauto using estep_rank_decreases,sstep_rank_decreases.
 - eapply source_step;eauto.
Qed.
End TARGET.
Print Assumptions all_successors_accessible.
