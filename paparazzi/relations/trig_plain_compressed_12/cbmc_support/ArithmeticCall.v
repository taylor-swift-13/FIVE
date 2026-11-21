From Stdlib Require Import ZArith.
From compcert Require Import Coqlib AST Values Memory Ctypes Csyntax Csem Ctyping.
From PprzTrigRelationSupport Require Import PureEval ClosedCalls.
From PprzTrigCBMC Require Import ProducerSteps ProducerContexts ArithmeticOriginsExpr ArithmeticContexts.

Lemma literal_context_no_call : forall from to C,Csem.context from to C ->
 forall fn args ty z,C(Ecall fn args ty)=lit z ->False.
Proof.
 intros from to C CT fn args ty z EQ.
 destruct(@ClosedCalls.leaf_context from to C CT(Ecall fn args ty)(lit z)eq_refl EQ)as[KK[AA ID]].
 discriminate AA.
Qed.
Lemma call_context_type : forall from to C,Csem.context from to C ->
 forall fn args ty v,typeof(C(Eval v ty))=typeof(C(Ecall fn args ty)).
Proof. intros;eapply PureEval.context_type_eq;[exact H|reflexivity]. Qed.
Lemma producer_call_context : forall from to C,Csem.context from to C ->
 forall fn args ty v kind,producer kind(C(Ecall fn args ty))->producer kind(C(Eval v ty)).
Proof.
 intros from to C CT;induction CT;intros fn args ty0 v kind P.
 all:try(solve[inversion P]).
 all:pose proof(@call_context_type _ _ _ CT fn args ty0 v)as TY.
 all:inversion P;subst;clear P.
 all:try(solve[econstructor;rewrite TY;assumption]).
 all:try(solve[econstructor;eapply IHCT;eauto]).
 all:try(solve[exfalso;eapply literal_context_no_call;[exact CT|];eauto]).
Qed.
Lemma add_origin_call_left : forall from C,Csem.context from RV C->
 forall fn args ty v b,add_origin(C(Ecall fn args ty))b->add_origin(C(Eval v ty))b.
Proof.
 intros from C CT fn args ty v b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]];unfold add_origin.
 - left;split;[rewrite(@call_context_type _ _ _ CT fn args ty v);exact TY|exact P].
 - exfalso;eapply literal_context_no_call;eauto.
 - right;right;left;split;[eapply producer_call_context;eauto|exact EQ].
 - right;right;right;split;[eapply producer_call_context;eauto|exact EQ].
Qed.
Lemma add_origin_call_right : forall from C,Csem.context from RV C->
 forall fn args ty v b,add_origin b(C(Ecall fn args ty))->add_origin b(C(Eval v ty)).
Proof.
 intros from C CT fn args ty v b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]];unfold add_origin.
 - left;split;[exact TY|eapply producer_call_context;eauto].
 - right;left;split;[exact EQ|eapply producer_call_context;eauto].
 - exfalso;eapply literal_context_no_call;eauto.
 - exfalso;eapply literal_context_no_call;eauto.
Qed.
Lemma mul_origin_call_left : forall from C,Csem.context from RV C->
 forall fn args ty v b,mul_origin(C(Ecall fn args ty))b->mul_origin(C(Eval v ty))b.
Proof. intros from C CT fn args ty v b [[EQ B]|[EQ P]];exfalso;eapply literal_context_no_call;eauto. Qed.
Lemma mul_origin_call_right : forall from C,Csem.context from RV C->
 forall fn args ty v b,mul_origin b(C(Ecall fn args ty))->mul_origin b(C(Eval v ty)).
Proof.
 intros from C CT fn args ty v b [[B EQ]|[EQ P]];unfold mul_origin.
 - exfalso;eapply literal_context_no_call;eauto.
 - right;split;[exact EQ|eapply producer_call_context;eauto].
Qed.
Lemma arithmetic_head_call_context : forall from to C,Csem.context from to C ->
 forall fn args ty v,arithmetic_expr(C(Ecall fn args ty))->arithmetic_head(C(Eval v ty)).
Proof.
 intros from to C CT;destruct CT;intros fn args ty0 v A.
 all:try(solve[exact I]).
 all:pose proof(arithmetic_expr_head _ A)as HEAD.
 all:cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD.
 all:try(destruct op;cbn[arithmetic_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(destruct id;cbn[arithmetic_head]in HEAD|-*;try exact HEAD).
 all:try(match goal with |-match ?TY with Tpointer _ _=>_|_=>_ end=>destruct TY;cbn in HEAD|-*;try exact I end).
 all:try(solve[eapply add_origin_call_left;eauto|eapply add_origin_call_right;eauto|
   eapply mul_origin_call_left;eauto|eapply mul_origin_call_right;eauto]).
 all:try(solve[exfalso;destruct HEAD as[H EQ];eapply literal_context_no_call;eauto]).
 all:try(solve[eapply producer_call_context;eauto]).
 all:try(solve[destruct HEAD as[H EQ];split;[eapply producer_call_context;eauto|exact EQ]]).
 all:try(solve[destruct HEAD as[TYPE REST];split;[rewrite(@call_context_type _ _ _ CT fn args ty0 v);exact TYPE|exact REST]]).
 all:try(solve[destruct HEAD as[TYPE[RET[CALC PROD]]];repeat split;try assumption;eapply producer_call_context;eauto]).
Qed.
Lemma arithmetic_call_context : forall from to C,Csem.context from to C ->
 forall fn args ty v,arithmetic_expr(C(Ecall fn args ty))->arithmetic_expr(C(Eval v ty))
with arithmetic_call_list : forall from C,Csem.contextlist from C ->
 forall fn args ty v,arithmetic_exprlist(C(Ecall fn args ty))->arithmetic_exprlist(C(Eval v ty)).
Proof.
 - induction 1;intros fn args ty0 v A.
   all:try(solve[apply arithmetic_value]).
   all:split;[refine(@arithmetic_head_call_context _ _ _ _ fn args ty0 v A);econstructor;eassumption|].
   all:cbn[arithmetic_expr]in A;intuition eauto using arithmetic_call_list.
 - induction 1;intros fn args ty0 v A;cbn in A|-*;intuition eauto using arithmetic_call_context.
Qed.
