From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ArrayBases ArrayResiduals ArrayOrigins ProducerContexts ArithmeticCall.
Section ARRAYS.
Variable ge:Csem.genv.
Variable elem:type.
Variable ids:list(ident*Z).
Lemma array_lred_head:forall e a m a' mf,array_expr ge elem ids a->lred ge e a m a' mf->array_expr ge elem ids a'.
Proof.
 intros e a m a' mf A RED;inversion RED;subst;cbn[array_expr array_head]in A|-*;try contradiction.
 all:split;[|exact I].
 all:intro EQ.
 all:try(solve[exfalso;apply(proj1 A);exact EQ]).
 subst ty.
 pose proof(proj1 A eq_refl)as PTR;inversion PTR;subst.
 eapply lvalue_location;eauto.
Qed.
Lemma array_rred_head:forall a m t a' mf,array_expr ge elem ids a->rred ge a m t a' mf->array_expr ge elem ids a'.
Proof.
 intros a m t a' mf A RED;inversion RED;subst;try(apply array_eval).
 all:cbn[array_expr array_head]in A|-*;try tauto.
 all:try(solve[destruct b;cbn;tauto]).
 - destruct A as[[LOC NEQ][L R]].
   split;[exact LOC|]. split;[exact L|]. split;[|split;apply array_eval].
   destruct op;cbn;try exact I;intro EQ;contradiction.
 - destruct A as[[LOC NEQ]L].
   split;[exact I|]. split;[|apply array_eval].
   split;[exact LOC|]. split;[exact L|]. split;[|split;apply array_eval].
   destruct id;cbn;try exact I;intro EQ;contradiction.
Qed.
Lemma array_head_lred_context:forall from to C,context from to C->from=LV->
 forall e a m a' mf,array_unshadowed ids e->array_expr ge elem ids(C a)->lred ge e a m a' mf->array_head ge elem ids(C a').
Proof.
 intros from to C CT;destruct CT;intros KK e a m a' mf ENV A RED;subst.
 all:try(solve[exact(array_expr_head _ _ _ _(@array_lred_head e a m a' mf A RED))]).
 all:pose proof(array_expr_head _ _ _ _ A)as HEAD.
 all:cbn[array_head]in HEAD|-*;try exact I;try exact HEAD;try tauto.
 all:try(solve[intro EQ;eapply pointer_lred_context;[exact CT|reflexivity|exact ENV|apply HEAD;exact EQ|exact RED]]).
 all:try(solve[intro EQ;eapply lvalue_lred_context;[exact CT|reflexivity|exact ENV|apply HEAD;exact EQ|exact RED]]).
 all:try(destruct op;cbn[array_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exists n;split;[eapply base_lred_context;eauto|exact T]]).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exists n;split;[exact B|rewrite(@lred_context_type _ _ _ CT ge e m a a' mf RED);exact T]]).
 all:try(solve[destruct HEAD as[LOC REST];split;[intro EQ;eapply lvalue_lred_context;eauto|exact REST]]).
 all:match goal with |-?G=>idtac "AH-LR-LEFT" G end.
Qed.
Lemma array_head_rred_context:forall from to C,context from to C->from=RV->
 forall a m t a' mf,array_expr ge elem ids(C a)->rred ge a m t a' mf->array_head ge elem ids(C a').
Proof.
 intros from to C CT;destruct CT;intros KK a m t a' mf A RED;subst.
 all:try(solve[exact(array_expr_head _ _ _ _(@array_rred_head a m t a' mf A RED))]).
 all:pose proof(array_expr_head _ _ _ _ A)as HEAD.
 all:cbn[array_head]in HEAD|-*;try exact I;try exact HEAD;try tauto.
 all:try(solve[intro EQ;eapply pointer_rred_context;[exact CT|reflexivity|apply HEAD;exact EQ|exact RED]]).
 all:try(solve[intro EQ;eapply lvalue_rred_context;[exact CT|reflexivity|apply HEAD;exact EQ|exact RED]]).
 all:try(destruct op;cbn[array_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exists n;split;[eapply base_rred_context;eauto|exact T]]).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exists n;split;[exact B|rewrite(@rred_context_type _ _ _ CT ge m a a' t mf RED);exact T]]).
 all:try(solve[destruct HEAD as[LOC REST];split;[intro EQ;eapply lvalue_rred_context;eauto|exact REST]]).
 all:match goal with |-?G=>idtac "AH-RR-LEFT" G end.
Qed.
End ARRAYS.
