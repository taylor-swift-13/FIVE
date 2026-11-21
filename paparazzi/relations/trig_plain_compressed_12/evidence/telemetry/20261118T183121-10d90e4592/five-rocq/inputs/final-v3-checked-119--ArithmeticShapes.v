From Stdlib Require Import ZArith.
From compcert Require Import Coqlib AST Values Memory Ctypes Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ProducerSteps ProducerContexts ArithmeticOriginsExpr.

Lemma add_origin_lred_left : forall from C,Csem.context from RV C->forall ge e m a a' mf b,
 add_origin(C a)b->Csem.lred ge e a m a' mf->add_origin(C a')b.
Proof.
 intros from C CT ge e m a a' mf b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]] R;unfold add_origin.
 - left;split;[rewrite(@lred_context_type _ _ _ CT ge e m a a' mf R);exact TY|exact P].
 - exfalso;eapply literal_context_no_lred;eauto.
 - right;right;left;split;[eapply producer_lred_context;eauto|exact EQ].
 - right;right;right;split;[eapply producer_lred_context;eauto|exact EQ].
Qed.
Lemma add_origin_lred_right : forall from C,Csem.context from RV C->forall ge e m a a' mf b,
 add_origin b(C a)->Csem.lred ge e a m a' mf->add_origin b(C a').
Proof.
 intros from C CT ge e m a a' mf b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]] R;unfold add_origin.
 - left;split;[exact TY|eapply producer_lred_context;eauto].
 - right;left;split;[exact EQ|eapply producer_lred_context;eauto].
 - exfalso;eapply literal_context_no_lred;eauto.
 - exfalso;eapply literal_context_no_lred;eauto.
Qed.
Lemma mul_origin_lred_left : forall from C,Csem.context from RV C->forall ge e m a a' mf b,
 mul_origin(C a)b->Csem.lred ge e a m a' mf->mul_origin(C a')b.
Proof. intros from C CT ge e m a a' mf b [[EQ B]|[EQ P]]R;exfalso;eapply literal_context_no_lred;eauto. Qed.
Lemma mul_origin_lred_right : forall from C,Csem.context from RV C->forall ge e m a a' mf b,
 mul_origin b(C a)->Csem.lred ge e a m a' mf->mul_origin b(C a').
Proof.
 intros from C CT ge e m a a' mf b [[B EQ]|[EQ P]]R;unfold mul_origin.
 - exfalso;eapply literal_context_no_lred;eauto.
 - right;split;[exact EQ|eapply producer_lred_context;eauto].
Qed.

Lemma add_origin_rred_left : forall from C,Csem.context from RV C->forall (ge:Csem.genv)te m a a' t mf b,
 add_origin(C a)b->Ctyping.wt_expr_kind ge te from a->Csem.rred ge a m t a' mf->add_origin(C a')b.
Proof.
 intros from C CT ge te m a a' t mf b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]]W R;unfold add_origin.
 - left;split;[rewrite(@rred_context_type _ _ _ CT ge m a a' t mf R);exact TY|exact P].
 - exfalso;eapply literal_context_no_rred;eauto.
 - right;right;left;split;[eapply producer_rred_context;eauto|exact EQ].
 - right;right;right;split;[eapply producer_rred_context;eauto|exact EQ].
Qed.
Lemma add_origin_rred_right : forall from C,Csem.context from RV C->forall (ge:Csem.genv)te m a a' t mf b,
 add_origin b(C a)->Ctyping.wt_expr_kind ge te from a->Csem.rred ge a m t a' mf->add_origin b(C a').
Proof.
 intros from C CT ge te m a a' t mf b [[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]]W R;unfold add_origin.
 - left;split;[exact TY|eapply producer_rred_context;eauto].
 - right;left;split;[exact EQ|eapply producer_rred_context;eauto].
 - exfalso;eapply literal_context_no_rred;eauto.
 - exfalso;eapply literal_context_no_rred;eauto.
Qed.
Lemma mul_origin_rred_left : forall from C,Csem.context from RV C->forall (ge:Csem.genv)te m a a' t mf b,
 mul_origin(C a)b->Ctyping.wt_expr_kind ge te from a->Csem.rred ge a m t a' mf->mul_origin(C a')b.
Proof. intros from C CT ge te m a a' t mf b [[EQ B]|[EQ P]]W R;exfalso;eapply literal_context_no_rred;eauto. Qed.
Lemma mul_origin_rred_right : forall from C,Csem.context from RV C->forall (ge:Csem.genv)te m a a' t mf b,
 mul_origin b(C a)->Ctyping.wt_expr_kind ge te from a->Csem.rred ge a m t a' mf->mul_origin b(C a').
Proof.
 intros from C CT ge te m a a' t mf b [[B EQ]|[EQ P]]W R;unfold mul_origin.
 - exfalso;eapply literal_context_no_rred;eauto.
 - right;split;[exact EQ|eapply producer_rred_context;eauto].
Qed.
