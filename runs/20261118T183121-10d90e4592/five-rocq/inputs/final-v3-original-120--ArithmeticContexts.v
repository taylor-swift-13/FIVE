From compcert Require Import Coqlib AST Values Memory Ctypes Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ProducerSteps ProducerContexts ArithmeticOriginsExpr ArithmeticShapes.

Lemma arithmetic_expr_head : forall a,arithmetic_expr a->arithmetic_head a.
Proof. destruct a;intros A;exact(proj1 A). Qed.

Lemma arithmetic_head_lred_context : forall from to C,Csem.context from to C ->
 forall ge e m a a' mf,arithmetic_expr(C a)->Csem.lred ge e a m a' mf->arithmetic_head(C a').
Proof.
 intros from to C CT;destruct CT;intros ge e m a a' mf A RED.
 all:try(solve[exact(arithmetic_expr_head _(@arithmetic_lred_head ge e a m a' mf A RED))]).
 all:pose proof(arithmetic_expr_head _ A)as HEAD.
 all:cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD.
 all:try(destruct op;cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(destruct id;cbn[arithmetic_head]in HEAD|-*;try exact HEAD).
 all:try(match goal with |-match ?TY with Tpointer _ _=>_|_=>_ end=>destruct TY;cbn in HEAD|-*;try exact I end).
 all:try(solve[eapply add_origin_lred_left;eauto|eapply add_origin_lred_right;eauto|
   eapply mul_origin_lred_left;eauto|eapply mul_origin_lred_right;eauto]).
 all:try(solve[exfalso;destruct HEAD as[H EQ];eapply literal_context_no_lred;eauto]).
 all:try(solve[eapply producer_lred_context;eauto]).
 all:try(solve[destruct HEAD as[H EQ];split;[eapply producer_lred_context;eauto|exact EQ]]).
 all:try(solve[destruct HEAD as[TYPE REST];split;[rewrite(@lred_context_type _ _ _ CT ge e m a a' mf RED);exact TYPE|exact REST]]).
 all:try(solve[destruct HEAD as[TYPE[RET[CALC PROD]]];repeat split;try assumption;eapply producer_lred_context;eauto]).
 all:match goal with |- ?G=>idtac "HEAD-LRED-REMAINING" G end.
Qed.

Lemma arithmetic_head_rred_context : forall from to C,Csem.context from to C ->
 forall (ge:Csem.genv)te m a a' t mf,arithmetic_expr(C a)->Ctyping.wt_expr_kind ge te from a->
 Csem.rred ge a m t a' mf->arithmetic_head(C a').
Proof.
 intros from to C CT;destruct CT;intros ge te m a a' t mf A WT RED.
 all:try(solve[exact(arithmetic_expr_head _(@arithmetic_rred_head ge a m t a' mf A RED))]).
 all:pose proof(arithmetic_expr_head _ A)as HEAD.
 all:cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD.
 all:try(destruct op;cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(destruct id;cbn[arithmetic_head]in HEAD|-*;try exact HEAD).
 all:try(match goal with |-match ?TY with Tpointer _ _=>_|_=>_ end=>destruct TY;cbn in HEAD|-*;try exact I end).
 all:try(solve[eapply add_origin_rred_left;eauto|eapply add_origin_rred_right;eauto|
   eapply mul_origin_rred_left;eauto|eapply mul_origin_rred_right;eauto]).
 all:try(solve[exfalso;destruct HEAD as[H EQ];eapply literal_context_no_rred;eauto]).
 all:try(solve[eapply producer_rred_context;eauto]).
 all:try(solve[destruct HEAD as[H EQ];split;[eapply producer_rred_context;eauto|exact EQ]]).
 all:try(solve[destruct HEAD as[TYPE REST];split;[rewrite(@rred_context_type _ _ _ CT ge m a a' t mf RED);exact TYPE|exact REST]]).
 all:try(solve[destruct HEAD as[TYPE[RET[CALC PROD]]];repeat split;try assumption;eapply producer_rred_context;eauto]).
 all:match goal with |- ?G=>idtac "HEAD-RRED-REMAINING" G end.
Qed.

Lemma arithmetic_lred_context : forall from to C,Csem.context from to C ->
 forall ge e m a a' mf,arithmetic_expr(C a)->Csem.lred ge e a m a' mf->arithmetic_expr(C a')
with arithmetic_lred_list : forall from C,Csem.contextlist from C ->
 forall ge e m a a' mf,arithmetic_exprlist(C a)->Csem.lred ge e a m a' mf->arithmetic_exprlist(C a').
Proof.
 - induction 1;intros ge e m a a' mf A RED.
   all:try(solve[eapply arithmetic_lred_head;eauto]).
   all:split;[refine(@arithmetic_head_lred_context _ _ _ _ ge e m a a' mf A RED);econstructor;eassumption|].
   all:cbn[arithmetic_expr]in A;intuition eauto using arithmetic_lred_list.
 - induction 1;intros ge e m a a' mf A RED;cbn in A|-*;intuition eauto using arithmetic_lred_context.
Qed.

Lemma arithmetic_rred_context : forall from to C,Csem.context from to C ->
 forall (ge:Csem.genv)te m a a' t mf,arithmetic_expr(C a)->Ctyping.wt_expr_kind ge te from a->
 Csem.rred ge a m t a' mf->arithmetic_expr(C a')
with arithmetic_rred_list : forall from C,Csem.contextlist from C ->
 forall (ge:Csem.genv)te m a a' t mf,arithmetic_exprlist(C a)->Ctyping.wt_expr_kind ge te from a->
 Csem.rred ge a m t a' mf->arithmetic_exprlist(C a').
Proof.
 - induction 1;intros ge te m a a' t mf A WT RED.
   all:try(solve[eapply arithmetic_rred_head;eauto]).
   all:split;[refine(@arithmetic_head_rred_context _ _ _ _ ge te m a a' t mf A WT RED);econstructor;eassumption|].
   all:cbn[arithmetic_expr]in A;intuition eauto using arithmetic_rred_list.
 - induction 1;intros ge te m a a' t mf A WT RED;cbn in A|-*;intuition eauto using arithmetic_rred_context.
Qed.
