From Stdlib Require Import List Arith Lia Wellfounded String.
From compcert Require Import Coqlib AST Values Memory Events Ctypes Cop Csyntax Csem Cexec Smallstep.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import TypedGuards SourceObservations Cutpoint MathCoverage.
Import ListNotations.
Local Open Scope string_scope.
Definition state_math_guard(ge:Csem.genv)(s:Csem.state):Prop:=match s with
 ExprState _ a _ e m=>math_guarded ge e m a|_=>True end.
Inductive guarded_covers(ge:Csem.genv)(P:Csem.state->Prop):Csem.state->Prop:=
| guarded_here:forall s,state_math_guard ge s->P s->guarded_covers ge P s
| guarded_next:forall s,state_math_guard ge s->(exists t next,Csem.step ge s t next)->
 (forall t next,Csem.step ge s t next->guarded_covers ge P next)->guarded_covers ge P s.
Lemma guarded_covers_forget : forall ge P s,guarded_covers ge P s->covers ge P s.
Proof. intros ge P s H;induction H;[constructor;assumption|apply covers_next;assumption]. Qed.
Lemma guarded_covers_current : forall ge P s,guarded_covers ge P s->state_math_guard ge s.
Proof. intros ge P s H;inversion H;assumption. Qed.
Inductive guarded_total(ge:Csem.genv)(Q:val->mem->Prop):Csem.state->Prop:=
| guarded_final:forall v m,Q v m->guarded_total ge Q(Returnstate v Kstop m)
| guarded_total_next:forall s,state_math_guard ge s->(exists t next,Csem.step ge s t next)->
 (forall t next,Csem.step ge s t next->guarded_total ge Q next)->guarded_total ge Q s.
Theorem guarded_total_every_prefix : forall ge Q s tr current,
 guarded_total ge Q s->star Csem.step ge s tr current->state_math_guard ge current.
Proof.
 intros ge Q s tr current T PATH;revert T;induction PATH;intros GT.
 - inversion GT;subst;try exact I;assumption.
 - apply IHPATH;inversion GT;subst;[exfalso;eapply Total.final_nostep;eauto|eauto].
Qed.
Theorem guarded_covers_bind : forall ge P Q s,
 guarded_covers ge P s->(forall current,P current->guarded_total ge Q current)->guarded_total ge Q s.
Proof. intros ge P Q s H END;induction H;[apply END;assumption|apply guarded_total_next;auto]. Qed.
Theorem guarded_prefix_binary_guard : forall ge Q s tr f a k e m op l r,
 guarded_total ge Q s->star Csem.step ge s tr(ExprState f a k e m)->
 BinaryOperationOccurrence a op l r->binary_math_guard op l r.
Proof.
 intros ge Q s tr f a k e m op l r T PATH[C[tl[trt[ty[CTX EQ]]]]];subst a.
 pose proof(guarded_total_every_prefix ge Q s tr _ T PATH)as MG.
 pose proof(proj1 general_math_context_hole RV RV C CTX ge e m _ MG)as[_[_ G]].
 exact(G l r eq_refl eq_refl).
Qed.
Theorem guarded_prefix_unary_guard : forall ge Q s tr f a k e m op v,
 guarded_total ge Q s->star Csem.step ge s tr(ExprState f a k e m)->
 UnaryOperationOccurrence a op v->unary_math_guard op v.
Proof.
 intros ge Q s tr f a k e m op v T PATH[C[tl[ty[CTX EQ]]]];subst a.
 pose proof(guarded_total_every_prefix ge Q s tr _ T PATH)as MG.
 pose proof(proj1 general_math_context_hole RV RV C CTX ge e m _ MG)as[_ G].
 exact(G v eq_refl).
Qed.
Lemma singleton_guarded : forall ge P s next rule,
 state_math_guard ge s->callback_free_state s->silent_state ge s->
 Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet s=[TR rule E0 next]->
 guarded_covers ge P next->guarded_covers ge P s.
Proof.
 intros ge P s next rule G CB SIL DS END;apply guarded_next;[exact G| |].
 - exists E0,next;apply(proj1(FiveShared.pure_semantics.SemanticsSupport.pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s E0 next CB SIL)). exists rule;rewrite DS;cbn;auto.
 - intros t s' STEP;destruct(proj2(FiveShared.pure_semantics.SemanticsSupport.pure_do_step_exact ge Control.none_callback Control.none_callback Control.quiet s t s' CB SIL)STEP)as[r IN].
   rewrite DS in IN;cbn in IN;destruct IN as[EQ|BAD];[inversion EQ;subst;exact END|contradiction].
Qed.
Lemma math_estep_expression : forall ge f a k e m t a' m',
 branch_simple a=true->math_guarded ge e m a->Csem.estep ge(ExprState f a k e m)t(ExprState f a' k e m')->math_guarded ge e m' a'.
Proof. intros;destruct(math_estep _ _ _ _ _ _ _ _ H H0 H1)as[B|[b[E[S M]]]];[discriminate|inversion E;subst;exact M]. Qed.
Lemma math_flat_estep_expression : forall ge f a k e m t a' m',
 branch_flat a=true->math_guarded ge e m a->Csem.estep ge(ExprState f a k e m)t(ExprState f a' k e m')->
 branch_flat a'=true /\math_guarded ge e m' a'.
Proof. intros;destruct(math_flat_estep _ _ _ _ _ _ _ _ H H0 H1)as[B|[b[mm[E[S M]]]]];[discriminate|inversion E;subst;auto]. Qed.
Theorem math_observation_prefix_guarded : forall ge Q f e m k a v,
 branch_simple a=true ->branch_rval ge e m a=Some v ->math_guarded ge e m a ->
 guarded_covers ge Q(ExprState f(Eval v(typeof a))k e m)->guarded_covers ge Q(ExprState f a k e m).
Proof.
 intros ge Q f e m k.
 apply(well_founded_induction(well_founded_ltof _ branch_rank)
  (fun a=>forall v,branch_simple a=true->branch_rval ge e m a=Some v->math_guarded ge e m a->
   guarded_covers ge Q(ExprState f(Eval v(typeof a))k e m)->guarded_covers ge Q(ExprState f a k e m))).
 intros a IH v SA EV MG END;destruct a eqn:EA;try discriminate SA;try discriminate EV.
 all:try(simpl in EV;inversion EV;subst;exact END).
 all:apply guarded_next;[exact MG| |].
 all:try(eapply branch_nonvalue_progress;eauto;intros;discriminate).
 all:intros t next STEP;destruct STEP as[ES|SS].
 all:try(inversion SS;subst;discriminate).
 all:destruct(branch_estep _ _ _ _ _ _ _ _ SA ES)as[BAD|[a'[EQ[TY[SA' EV']]]]].
 all:try(exfalso;eapply(branch_estep_not_stuck _ _ _ _ _ _ _ _ _ SA EV ES);exact BAD).
 all:subst next;apply IH with(v:=v);auto.
 all:try(unfold ltof;eapply branch_estep_rank;eauto).
 all:try(rewrite <-EV';exact EV).
 all:try(eapply math_estep_expression;eauto).
 all:rewrite TY;exact END.
Qed.
Theorem math_flat_prefix_guarded : forall ge Q f e k a m v mf,
 flat_expr a=true -> core_expr a=true ->branch_flat a=true ->math_guarded ge e m a -> flat_eval ge e m a=Some(v,mf) ->
 guarded_covers ge Q (ExprState f (Eval v (typeof a)) k e mf) ->
 guarded_covers ge Q (ExprState f a k e m).
Proof.
 intros ge Q f e k.
 apply(well_founded_induction(well_founded_ltof _ expr_rank)
  (fun a=>forall m v mf,flat_expr a=true -> core_expr a=true ->branch_flat a=true ->math_guarded ge e m a ->
   flat_eval ge e m a=Some(v,mf) ->
   guarded_covers ge Q (ExprState f (Eval v (typeof a)) k e mf) -> guarded_covers ge Q (ExprState f a k e m))).
 intros a IH m v mf FL CO BF MG EV END.
 destruct a eqn:EA;try discriminate FL.
 all: try (simpl in EV;inversion EV;subst;exact END).
 all: apply guarded_next;[exact MG| |].
 all: try (eapply flat_nonvalue_progress;eauto;intros;discriminate).
 all: intros t next STEP;destruct STEP as[ES|SS].
 all: try(inversion SS;subst;discriminate).
 all: destruct(flat_estep _ _ _ _ _ _ _ _ FL CO ES) as[BAD|[a'[m'[EQ[TY[FL'[CO' EV']]]]]]].
 all: try(exfalso;eapply(flat_estep_not_stuck _ _ _ _ _ _ _ _ _ _ FL EV ES);exact BAD).
 all: subst next;apply IH with(v:=v)(mf:=mf);auto.
 all: try(unfold ltof;eapply flat_estep_rank;eauto).
 all: try(rewrite <-EV';exact EV).
 all: try(exact(proj1(math_flat_estep_expression _ _ _ _ _ _ _ _ _ BF MG ES))).
 all: try(exact(proj2(math_flat_estep_expression _ _ _ _ _ _ _ _ _ BF MG ES))).
 all: rewrite TY;exact END.
Qed.
