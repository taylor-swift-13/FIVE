From Stdlib Require Import ZArith.
From compcert Require Import Coqlib AST Values Memory Ctypes Csyntax Csem Ctyping.
From PprzTrigRelationSupport Require Import PureEval ClosedCalls.
From PprzTrigCBMC Require Import ProducerSteps.

Lemma literal_context_no_lred : forall from to C,
 Csem.context from to C->forall ge e m a a' mf z,
 C a=lit z ->Csem.lred ge e a m a' mf ->False.
Proof.
 intros from to C CT ge e m a a' mf z EQ RED.
 destruct(@ClosedCalls.leaf_context from to C CT a(lit z)eq_refl EQ)as[KK[AA ID]].
 subst a;unfold lit in RED;inversion RED.
Qed.
Lemma literal_context_no_rred : forall from to C,
 Csem.context from to C->forall ge m a a' t mf z,
 C a=lit z ->Csem.rred ge a m t a' mf ->False.
Proof.
 intros from to C CT ge m a a' t mf z EQ RED.
 destruct(@ClosedCalls.leaf_context from to C CT a(lit z)eq_refl EQ)as[KK[AA ID]].
 subst a;unfold lit in RED;inversion RED.
Qed.

Lemma lred_context_type : forall from to C,Csem.context from to C ->
 forall ge e m a a' mf,Csem.lred ge e a m a' mf ->typeof(C a')=typeof(C a).
Proof.
 intros from to C CT ge e m a a' mf RED;eapply PureEval.context_type_eq;[exact CT|].
 exact(@Ctyping.lred_same_type ge e a m a' mf RED).
Qed.
Lemma rred_context_type : forall from to C,Csem.context from to C ->
 forall ge m a a' t mf,Csem.rred ge a m t a' mf ->typeof(C a')=typeof(C a).
Proof.
 intros from to C CT ge m a a' t mf RED;eapply PureEval.context_type_eq;[exact CT|].
 exact(@Ctyping.rred_same_type ge a m t a' mf RED).
Qed.

Theorem producer_lred_context : forall from to C,Csem.context from to C ->
 forall ge e m a a' mf kind,producer kind(C a) ->Csem.lred ge e a m a' mf ->producer kind(C a').
Proof.
 intros from to C CT;induction CT;intros ge e m a a' mf kind P RED.
 - exfalso;eapply producer_no_lred;eauto.
 all:try(solve[inversion P]).
 all:pose proof(@lred_context_type _ _ _ CT ge e m a a' mf RED)as TY.
 all:inversion P;subst;clear P.
 all:try(solve[econstructor;rewrite TY;assumption]).
 all:try(solve[econstructor;eapply IHCT;eauto]).
 all:try(solve[exfalso;eapply literal_context_no_lred;[exact CT| |exact RED];eauto]).
 all:match goal with |- ?G=>idtac "LRED-CONTEXT-LEFT" G end.
Qed.

Theorem producer_rred_context : forall from to C,Csem.context from to C ->
 forall (ge:Csem.genv)te m a a' t mf kind,producer kind(C a) ->
 Ctyping.wt_expr_kind ge te from a ->Csem.rred ge a m t a' mf ->producer kind(C a').
Proof.
 intros from to C CT;induction CT;intros ge te m a a' t mf kind P WT RED.
 - destruct k;[exfalso;eapply producer_no_lred;[exact P|inversion RED]|].
   exact(@producer_head_rred ge te kind a m t a' mf P WT RED).
 all:try(solve[inversion P]).
 all:pose proof(@rred_context_type _ _ _ CT ge m a a' t mf RED)as TY.
 all:inversion P;subst;clear P.
 all:try(solve[econstructor;rewrite TY;assumption]).
 all:try(solve[econstructor;eapply IHCT;eauto]).
 all:try(solve[exfalso;eapply literal_context_no_rred;[exact CT| |exact RED];eauto]).
 all:match goal with |- ?G=>idtac "RRED-CONTEXT-LEFT" G end.
Qed.
