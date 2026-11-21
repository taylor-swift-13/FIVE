From Stdlib Require Import List Arith Lia Wellfounded.
From compcert Require Import Coqlib Integers AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From PprzTrigRelationSupport Require Import PlainCore BranchPure.

(** Every edge is an ORIGINAL Csem expression edge; this is just its finite
    prefix closure before a statement continuation executes. *)
Inductive expression_prefix(ge:Csem.genv)(f:function)(k:cont)(e:env):mem->expr->mem->expr->Prop :=
| expression_prefix_refl:forall m a,expression_prefix ge f k e m a m a
| expression_prefix_step:forall m a t m1 a1 mf af,
 Csem.estep ge(ExprState f a k e m)t(ExprState f a1 k e m1) ->
 expression_prefix ge f k e m1 a1 mf af ->expression_prefix ge f k e m a mf af.
Definition source_observation(ge:Csem.genv)(e:env)(m:mem)(a:expr)(v:val):Prop :=
 branch_simple a=true /\branch_rval ge e m a=Some v.
Theorem observation_all_orders : forall ge f k e m a v mf af,
 source_observation ge e m a v ->expression_prefix ge f k e m a mf af ->
 mf=m /\typeof af=typeof a /\source_observation ge e mf af v.
Proof.
 intros ge f k e m a v mf af O H;revert v O.
 induction H;intros v[S V].
 - repeat split;auto.
 - destruct(branch_estep ge f a k e m t(ExprState f a1 k e m1)S H)as[BAD|[b[EQ[TY[SB EV]]]]];[discriminate|].
   inversion EQ;subst b m1.
   destruct(IHexpression_prefix v(conj SB(eq_trans(eq_sym EV)V)))as[MM[TT[SS VV]]].
   subst mf;repeat split;auto;congruence.
Qed.
Theorem observation_terminal_unique : forall ge f k e m a v mf w ty,
 source_observation ge e m a v ->expression_prefix ge f k e m a mf(Eval w ty) ->mf=m /\w=v.
Proof.
 intros ge f k e m a v mf w ty O H.
 destruct(observation_all_orders _ _ _ _ _ _ _ _ _ O H)as[M[T[S V]]].
 cbn[branch_rval]in V;inversion V;subst;auto.
Qed.
Theorem observation_evaluation_exists : forall ge f k e m a v,
 source_observation ge e m a v ->expression_prefix ge f k e m a m(Eval v(typeof a)).
Proof.
 intros ge f k e m a;pattern a.
 apply(well_founded_induction(well_founded_ltof _ branch_rank));clear a.
 intros a IH v[S V].
 destruct a eqn:A;try (cbn[branch_rval]in V;inversion V;subst;constructor).
 all:rewrite<-A in S,V,IH|-*.
 all:assert(NV:forall w ty,a<>Eval w ty)by(intros w ty EQ;rewrite A in EQ;discriminate).
 all:destruct(branch_nonvalue_progress ge f a k e m v S V NV)as[t[next STEP]].
 all:destruct STEP as[ES|SS];[|inversion SS;subst;discriminate].
 all:destruct(branch_estep ge f a k e m t next S ES)as[BAD|[a'[EQ[TY[SA EV]]]]].
 all:try(subst next;exfalso;eapply(branch_estep_not_stuck ge f a k e m t Stuckstate v S V ES);reflexivity).
 all:subst next;rewrite<-TY.
 all:eapply expression_prefix_step;[exact ES|].
 all:apply IH;[unfold ltof;eapply branch_estep_rank;eauto|].
 all:split;[exact SA|congruence].
Qed.
Print Assumptions observation_evaluation_exists.
