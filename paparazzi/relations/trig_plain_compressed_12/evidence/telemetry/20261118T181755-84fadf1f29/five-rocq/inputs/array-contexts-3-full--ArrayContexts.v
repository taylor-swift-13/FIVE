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
   split;[exact LOC|]. split;[exact L|]. split;[|repeat split;exact I].
   destruct op;cbn;try exact I;intro EQ;contradiction.
 - destruct A as[[LOC NEQ]L].
   split;[exact I|]. split;[|repeat split;exact I].
   split;[exact LOC|]. split;[exact L|]. split;[|repeat split;exact I].
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
Lemma array_lred_context:forall from to C,context from to C->from=LV->
 forall e a m a' mf,array_unshadowed ids e->array_expr ge elem ids(C a)->lred ge e a m a' mf->array_expr ge elem ids(C a')
with array_lred_list:forall from C,contextlist from C->from=LV->
 forall e a m a' mf,array_unshadowed ids e->array_exprlist ge elem ids(C a)->lred ge e a m a' mf->array_exprlist ge elem ids(C a').
Proof.
 - induction 1;intros KK e a m a' mf ENV A RED;subst.
   all:try(solve[eapply array_lred_head;eauto]).
   all:split;[refine(@array_head_lred_context _ _ _ _ eq_refl e a m a' mf ENV A RED);econstructor;eassumption|].
   all:cbn[array_expr]in A;intuition eauto using array_lred_list.
 - induction 1;intros KK e a m a' mf ENV A RED;subst;cbn in A|-*;intuition eauto using array_lred_context.
Qed.
Lemma array_rred_context:forall from to C,context from to C->from=RV->
 forall a m t a' mf,array_expr ge elem ids(C a)->rred ge a m t a' mf->array_expr ge elem ids(C a')
with array_rred_list:forall from C,contextlist from C->from=RV->
 forall a m t a' mf,array_exprlist ge elem ids(C a)->rred ge a m t a' mf->array_exprlist ge elem ids(C a').
Proof.
 - induction 1;intros KK a m t a' mf A RED;subst.
   all:try(solve[eapply array_rred_head;eauto]).
   all:split;[refine(@array_head_rred_context _ _ _ _ eq_refl a m t a' mf A RED);econstructor;eassumption|].
   all:cbn[array_expr]in A;intuition eauto using array_rred_list.
 - induction 1;intros KK a m t a' mf A RED;subst;cbn in A|-*;intuition eauto using array_rred_context.
Qed.
Lemma array_head_call_context:forall from to C,context from to C->from=RV->forall fn args ty v,
 array_expr ge elem ids(C(Ecall fn args ty))->array_head ge elem ids(C(Eval v ty)).
Proof.
 intros from to C CT;destruct CT;intros KK fn args ty0 v A;subst.
 all:try(solve[exact I]).
 all:pose proof(array_expr_head _ _ _ _ A)as HEAD.
 all:cbn[array_head]in HEAD|-*;try exact I;try exact HEAD;try tauto.
 all:try(solve[intro EQ;eapply pointer_call_context;[exact CT|reflexivity|apply HEAD;exact EQ]]).
 all:try(solve[intro EQ;eapply lvalue_call_context;[exact CT|reflexivity|apply HEAD;exact EQ]]).
 all:try(destruct op;cbn[array_head]in HEAD|-*;try exact I;try exact HEAD).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exfalso;eapply base_no_call;eauto]).
 all:try(solve[intro EQ;destruct(HEAD EQ)as[n[B T]];exists n;split;[exact B|rewrite(@call_context_type _ _ _ CT fn args ty0 v);exact T]]).
 all:try(solve[destruct HEAD as[LOC REST];split;[intro EQ;eapply lvalue_call_context;eauto|exact REST]]).
Qed.
Lemma array_call_context:forall from to C,context from to C->from=RV->forall fn args ty v,
 array_expr ge elem ids(C(Ecall fn args ty))->array_expr ge elem ids(C(Eval v ty))
with array_call_list:forall from C,contextlist from C->from=RV->forall fn args ty v,
 array_exprlist ge elem ids(C(Ecall fn args ty))->array_exprlist ge elem ids(C(Eval v ty)).
Proof.
 - induction 1;intros KK fn args ty0 v A;subst.
   all:try(solve[apply array_eval]).
   all:split;[refine(@array_head_call_context _ _ _ _ eq_refl fn args ty0 v A);econstructor;eassumption|].
   all:cbn[array_expr]in A;intuition eauto using array_call_list.
 - induction 1;intros KK fn args ty0 v A;subst;cbn in A|-*;intuition eauto using array_call_context.
Qed.
Lemma array_context_hole:forall from to C,context from to C->forall a,array_expr ge elem ids(C a)->array_expr ge elem ids a
with array_contextlist_hole:forall from C,contextlist from C->forall a,array_exprlist ge elem ids(C a)->array_expr ge elem ids a.
Proof.
 induction 1;cbn[array_expr];intros a A;intuition eauto using array_contextlist_hole.
 induction 1;cbn[array_exprlist];intros a A;intuition eauto using array_context_hole.
Qed.
End ARRAYS.


