From Stdlib Require Import List Bool String Arith Lia Wellfounded.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import SourceObservations.
Import ListNotations.
Local Open Scope string_scope.
Definition zero_guard(ge:Csem.genv)(s:Csem.state):Prop:=
 match s with ExprState _ a(Kwhile1 _ _ _)e m=>exists v,branch_rval ge e m a=Some v /\bool_val v(typeof a)m=Some false|_=>True end.
Inductive zero_covers(ge:Csem.genv)(P:Csem.state->Prop):Csem.state->Prop:=
| zero_here:forall s,zero_guard ge s->P s->zero_covers ge P s
| zero_next:forall s,zero_guard ge s->(exists t next,Csem.step ge s t next)->
 (forall t next,Csem.step ge s t next->zero_covers ge P next)->zero_covers ge P s.
Theorem zero_covers_all_prefixes : forall ge P s,
 zero_covers ge P s->(forall endpoint,P endpoint->forall t current,star Csem.step ge endpoint t current->zero_guard ge current)->
 forall t current,star Csem.step ge s t current->zero_guard ge current.
Proof.
 intros ge P s COVER END t current PATH;revert COVER;induction PATH;intros COVER.
 - inversion COVER;subst;assumption.
 - inversion COVER;subst;[eapply END;eauto;eapply star_step;eauto|apply IHPATH;eauto].
Qed.
Lemma singleton_zero : forall ge P s next rule,
 zero_guard ge s->callback_free_state s->silent_state ge s->
 Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet s=[TR rule E0 next]->
 zero_covers ge P next->zero_covers ge P s.
Proof.
 intros ge P s next rule ZG CB SIL DS END;apply zero_next;[exact ZG| |].
 - exists E0,next;apply(proj1(pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s E0 next CB SIL)). exists rule;rewrite DS;cbn;auto.
 - intros t s' STEP;destruct(proj2(pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s t s' CB SIL)STEP)as[r IN].
   rewrite DS in IN;cbn in IN;destruct IN as[EQ|BAD];[inversion EQ;subst;exact END|contradiction].
Qed.
Lemma sequence_zero : forall ge P f a b k e m,
 zero_covers ge P(State f a(Kseq b k)e m)->zero_covers ge P(State f(Ssequence a b)k e m).
Proof. intros;eapply singleton_zero with(rule:="step_seq");eauto using Control.statement_silent;reflexivity. Qed.
Lemma skip_sequence_zero : forall ge P f a k e m,
 zero_covers ge P(State f a k e m)->zero_covers ge P(State f Sskip(Kseq a k)e m).
Proof. intros;eapply singleton_zero with(rule:="step_skip_seq");eauto using Control.statement_silent;reflexivity. Qed.
Lemma do_zero : forall ge P f a k e m,
 zero_covers ge P(ExprState f a(Kdo k)e m)->zero_covers ge P(State f(Sdo a)k e m).
Proof. intros;eapply singleton_zero with(rule:="step_do_1");eauto using Control.statement_silent;reflexivity. Qed.
Lemma do_value_zero : forall ge P f v ty k e m,
 zero_covers ge P(State f Sskip k e m)->zero_covers ge P(ExprState f(Eval v ty)(Kdo k)e m).
Proof. intros;eapply singleton_zero with(rule:="step_do_2");eauto using Control.literal_silent;reflexivity. Qed.
Lemma if_start_zero : forall ge P f a yes no k e m,
 zero_covers ge P(ExprState f a(Kifthenelse yes no k)e m)->zero_covers ge P(State f(Sifthenelse a yes no)k e m).
Proof. intros;eapply singleton_zero with(rule:="step_ifthenelse_1");eauto using Control.statement_silent;reflexivity. Qed.
Lemma if_value_zero : forall ge P f v ty yes no k e m choice,
 bool_val v ty m=Some choice->zero_covers ge P(State f(if choice then yes else no)k e m)->
 zero_covers ge P(ExprState f(Eval v ty)(Kifthenelse yes no k)e m).
Proof.
 intros ge P f v ty yes no k e m choice B END.
 eapply singleton_zero with(rule:="step_ifthenelse_2");
 try exact I;try apply Control.literal_silent;try reflexivity.
 - unfold Cexec.do_step;cbn -[bool_val];rewrite B;reflexivity.
 - exact END.
Qed.
Lemma return_start_zero : forall ge P f a k e m,
 zero_covers ge P(ExprState f a(Kreturn k)e m)->zero_covers ge P(State f(Sreturn(Some a))k e m).
Proof. intros;eapply singleton_zero with(rule:="step_return_1");eauto using Control.statement_silent;reflexivity. Qed.
Lemma internal_zero : forall ge P f args k m e m1 m2,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f))->
 do_alloc_variables ge empty_env m(fn_params f++fn_vars f)=(e,m1)->
 sem_bind_parameters ge Control.quiet e m1(fn_params f)args=Some m2 ->
 zero_covers ge P(State f(fn_body f)k e m2)->zero_covers ge P(Callstate(Internal f)args k m).
Proof.
 intros ge P f args k m e m1 m2 NR AV BP END.
 eapply singleton_zero with(rule:="step_internal_function");try exact I;try apply Control.internal_silent.
 - cbn[Cexec.do_step];destruct(list_norepet_dec ident_eq(var_names(fn_params f)++var_names(fn_vars f)));[rewrite AV,BP;reflexivity|contradiction].
 - exact END.
Qed.
Theorem observation_prefix_zero : forall ge Q f e m k a v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->
 (forall residual,typeof residual=typeof a->branch_rval ge e m residual=Some v->zero_guard ge(ExprState f residual k e m))->
 zero_covers ge Q(ExprState f(Eval v(typeof a))k e m)->zero_covers ge Q(ExprState f a k e m).
Proof.
 intros ge Q f e m k.
 apply(well_founded_induction(well_founded_ltof _ branch_rank)
  (fun a=>forall v,branch_simple a=true->branch_rval ge e m a=Some v->
   (forall residual,typeof residual=typeof a->branch_rval ge e m residual=Some v->zero_guard ge(ExprState f residual k e m))->
   zero_covers ge Q(ExprState f(Eval v(typeof a))k e m)->zero_covers ge Q(ExprState f a k e m))).
 intros a IH v SA EV ZV END;destruct a eqn:EA;try discriminate SA;try discriminate EV.
 all:try(simpl in EV;inversion EV;subst;exact END).
 all:apply zero_next;[apply ZV;[reflexivity|exact EV]| |].
 all:try(eapply branch_nonvalue_progress;eauto;intros;discriminate).
 all:intros t next STEP;destruct STEP as[ES|SS].
 all:try(inversion SS;subst;discriminate).
 all:destruct(branch_estep _ _ _ _ _ _ _ _ SA ES)as[BAD|[a'[EQ[TY[SA' EV']]]]].
 all:try(exfalso;eapply(branch_estep_not_stuck _ _ _ _ _ _ _ _ _ SA EV ES);exact BAD).
 all:subst next;apply IH with(v:=v);auto.
 all:try(unfold ltof;eapply branch_estep_rank;eauto).
 all:try(rewrite <-EV';exact EV).
 all:try(solve[intros residual RT RV;apply ZV;[congruence|exact RV]]).
 all:rewrite TY;exact END.
Qed.
Theorem flat_prefix_zero : forall ge Q f e k a m v mf,
 (match k with Kwhile1 _ _ _=>False|_=>True end)->flat_expr a=true -> core_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 zero_covers ge Q (ExprState f (Eval v (typeof a)) k e mf) ->
 zero_covers ge Q (ExprState f a k e m).
Proof.
 intros ge Q f e k.
 apply(well_founded_induction(well_founded_ltof _ expr_rank)
  (fun a=>forall m v mf,(match k with Kwhile1 _ _ _=>False|_=>True end)->flat_expr a=true -> core_expr a=true ->
   flat_eval ge e m a=Some(v,mf) ->
   zero_covers ge Q (ExprState f (Eval v (typeof a)) k e mf) -> zero_covers ge Q (ExprState f a k e m))).
 intros a IH m v mf NK FL CO EV END.
 destruct a eqn:EA;try discriminate FL.
 all: try (simpl in EV;inversion EV;subst;exact END).
 all: apply zero_next;[destruct k;cbn in NK;try contradiction;exact I| |].
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

Lemma if_pure_zero : forall ge Q f a yes no k e m v choice,
 branch_simple a=true->branch_rval ge e m a=Some v->bool_val v(typeof a)m=Some choice->
 zero_covers ge Q(State f(if choice then yes else no)k e m)->zero_covers ge Q(State f(Sifthenelse a yes no)k e m).
Proof.
 intros;apply if_start_zero;eapply observation_prefix_zero;eauto.
 - intros;exact I.
 - eapply if_value_zero;eauto.
Qed.
Lemma while_start_zero : forall ge Q f a body k e m,
 zero_covers ge Q(ExprState f a(Kwhile1 a body k)e m)->zero_covers ge Q(State f(Swhile a body)k e m).
Proof. intros;eapply singleton_zero with(rule:="step_while");eauto using statement_silent;reflexivity. Qed.
Lemma while_false_value_zero : forall ge Q f a body v ty k e m,
 bool_val v ty m=Some false->zero_covers ge Q(State f Sskip k e m)->
 zero_covers ge Q(ExprState f(Eval v ty)(Kwhile1 a body k)e m).
Proof.
 intros ge Q f a body v ty k e m B END;eapply singleton_zero with(rule:="step_while_false");try exact I;try apply literal_silent.
 - exists v;split;[reflexivity|exact B].
 - unfold Cexec.do_step;cbn -[bool_val];rewrite B;reflexivity.
 - exact END.
Qed.
Lemma while_false_pure_zero : forall ge Q f a body k e m v,
 branch_simple a=true->branch_rval ge e m a=Some v->bool_val v(typeof a)m=Some false->
 zero_covers ge Q(State f Sskip k e m)->zero_covers ge Q(State f(Swhile a body)k e m).
Proof.
 intros ge Q f a body k e m v SIMPLE VAL B END;apply while_start_zero;eapply observation_prefix_zero;[exact SIMPLE|exact VAL| |].
 - intros residual TY EV;exists v;split;[exact EV|rewrite TY;exact B].
 - eapply while_false_value_zero;eauto.
Qed.
