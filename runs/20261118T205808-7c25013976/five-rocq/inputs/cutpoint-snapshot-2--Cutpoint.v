From Stdlib Require Import List Bool String Arith Lia Wellfounded.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import SourceObservations.
Import ListNotations.
Local Open Scope string_scope.
(** Finite coverage by ALL ORIGINAL Csem successors until a labeled PC.
    The stopping predicate is a proof label, never a replacement machine. *)
Inductive covers(ge:Csem.genv)(P:Csem.state->Prop):Csem.state->Prop :=
| covers_here:forall s,P s->covers ge P s
| covers_next:forall s,(exists t next,Csem.step ge s t next)->
 (forall t next,Csem.step ge s t next->covers ge P next)->covers ge P s.
Theorem coverage_witness : forall ge P s,covers ge P s ->exists t next,star Csem.step ge s t next /\P next.
Proof.
 intros ge P s H;induction H.
 - exists E0,s;split;[constructor|exact H].
 - destruct H as[t[next STEP]];destruct(H1 t next STEP)as[u[last[PATH END]]].
   exists(t**u),last;split;[eapply star_step;eauto|exact END].
Qed.
Definition before_pc_step(ge:Csem.genv)(P:Csem.state->Prop)(next current:Csem.state):Prop :=
 ~P current /\exists t,Csem.step ge current t next.
Theorem coverage_all_orders_termination : forall ge P s,covers ge P s ->Acc(before_pc_step ge P)s.
Proof.
 intros ge P s H;induction H.
 - constructor;intros next[N E];contradiction.
 - constructor;intros next[N[t E]];eauto.
Qed.
Theorem coverage_all_orders_progress : forall ge P s,covers ge P s ->~P s ->exists t next,Csem.step ge s t next.
Proof. intros ge P s H N;inversion H;subst;[contradiction|assumption]. Qed.
Lemma singleton_covers : forall ge P s next rule,
 callback_free_state s->silent_state ge s->
 Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet s=[TR rule E0 next]->
 covers ge P next->covers ge P s.
Proof.
 intros ge P s next rule CB SIL DS END;apply covers_next.
 - exists E0,next;apply(proj1(pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s E0 next CB SIL)). exists rule;rewrite DS;cbn;auto.
 - intros t s' STEP;destruct(proj2(pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s t s' CB SIL)STEP)as[r IN].
   rewrite DS in IN;cbn in IN;destruct IN as[EQ|BAD];[inversion EQ;subst;exact END|contradiction].
Qed.
Lemma sequence_covers : forall ge P f a b k e m,
 covers ge P(State f a(Kseq b k)e m)->covers ge P(State f(Ssequence a b)k e m).
Proof. intros;eapply singleton_covers with(rule:="step_seq");eauto using Control.statement_silent;reflexivity. Qed.
Lemma skip_sequence_covers : forall ge P f a k e m,
 covers ge P(State f a k e m)->covers ge P(State f Sskip(Kseq a k)e m).
Proof. intros;eapply singleton_covers with(rule:="step_skip_seq");eauto using Control.statement_silent;reflexivity. Qed.
Lemma do_covers : forall ge P f a k e m,
 covers ge P(ExprState f a(Kdo k)e m)->covers ge P(State f(Sdo a)k e m).
Proof. intros;eapply singleton_covers with(rule:="step_do_1");eauto using Control.statement_silent;reflexivity. Qed.
Lemma do_value_covers : forall ge P f v ty k e m,
 covers ge P(State f Sskip k e m)->covers ge P(ExprState f(Eval v ty)(Kdo k)e m).
Proof. intros;eapply singleton_covers with(rule:="step_do_2");eauto using Control.literal_silent;reflexivity. Qed.
Lemma if_start_covers : forall ge P f a yes no k e m,
 covers ge P(ExprState f a(Kifthenelse yes no k)e m)->covers ge P(State f(Sifthenelse a yes no)k e m).
Proof. intros;eapply singleton_covers with(rule:="step_if");eauto using Control.statement_silent;reflexivity. Qed.
Lemma if_value_covers : forall ge P f v ty yes no k e m choice,
 bool_val v ty m=Some choice->covers ge P(State f(if choice then yes else no)k e m)->
 covers ge P(ExprState f(Eval v ty)(Kifthenelse yes no k)e m).
Proof.
 intros ge P f v ty yes no k e m choice B END.
 eapply singleton_covers with(rule:=if choice then "step_ifthenelse_true"else "step_ifthenelse_false");
 try exact I;try apply Control.literal_silent.
 - destruct choice;cbn[Cexec.do_step];rewrite B;reflexivity.
 - exact END.
Qed.
Lemma return_start_covers : forall ge P f a k e m,
 covers ge P(ExprState f a(Kreturn k)e m)->covers ge P(State f(Sreturn(Some a))k e m).
Proof. intros;eapply singleton_covers with(rule:="step_return_1");eauto using Control.statement_silent;reflexivity. Qed.
Lemma internal_covers : forall ge P f args k m e m1 m2,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f))->
 do_alloc_variables ge empty_env m(fn_params f++fn_vars f)=(e,m1)->
 sem_bind_parameters ge Control.quiet e m1(fn_params f)args=Some m2 ->
 covers ge P(State f(fn_body f)k e m2)->covers ge P(Callstate(Internal f)args k m).
Proof.
 intros ge P f args k m e m1 m2 NR AV BP END.
 eapply singleton_covers with(rule:="step_internal_function");try exact I;try apply Control.internal_silent.
 - cbn[Cexec.do_step];destruct(list_norepet_dec ident_eq(var_names(fn_params f)++var_names(fn_vars f)));[rewrite AV,BP;reflexivity|contradiction].
 - exact END.
Qed.
Theorem observation_prefix_covers : forall ge Q f e m k a v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->
 covers ge Q(ExprState f(Eval v(typeof a))k e m)->covers ge Q(ExprState f a k e m).
Proof.
 intros ge Q f e m k.
 apply(well_founded_induction(well_founded_ltof _ branch_rank)
  (fun a=>forall v,branch_simple a=true->branch_rval ge e m a=Some v->
   covers ge Q(ExprState f(Eval v(typeof a))k e m)->covers ge Q(ExprState f a k e m))).
 intros a IH v SA EV END;destruct a eqn:EA;try discriminate SA;try discriminate EV.
 all:try(simpl in EV;inversion EV;subst;exact END).
 all:apply covers_next.
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
Theorem flat_prefix_covers : forall ge Q f e k a m v mf,
 flat_expr a=true -> core_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 covers ge Q (ExprState f (Eval v (typeof a)) k e mf) ->
 covers ge Q (ExprState f a k e m).
Proof.
 intros ge Q f e k.
 apply(well_founded_induction(well_founded_ltof _ expr_rank)
  (fun a=>forall m v mf,flat_expr a=true -> core_expr a=true ->
   flat_eval ge e m a=Some(v,mf) ->
   covers ge Q (ExprState f (Eval v (typeof a)) k e mf) -> covers ge Q (ExprState f a k e m))).
 intros a IH m v mf FL CO EV END.
 destruct a eqn:EA;try discriminate FL.
 all: try (simpl in EV;inversion EV;subst;exact END).
 all: apply covers_next.
 all: try (eapply flat_nonvalue_progress;eauto;intros;discriminate).
 all: intros t next STEP;destruct STEP as[ES|SS].
 all: try(inversion SS;subst;discriminate).
 all: destruct(flat_estep _ _ _ _ _ _ _ _ FL CO ES) as[BAD|[a'[m'[EQ[TY[FL'[CO' EV']]]]]]].
 all: try(exfalso;eapply(flat_estep_not_stuck _ _ _ _ _ _ _ _ _ _ FL EV ES);exact BAD).
 all: subst next;apply IH with(v:=v)(mf:=mf);auto.
 all: try(unfold ltof;eapply flat_estep_rank;eauto).
 all: try(rewrite <-EV';exact EV).
 all: rewrite TY;exact END.
Qed.
Print Assumptions coverage_witness.
Print Assumptions flat_prefix_covers.
