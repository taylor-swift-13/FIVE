From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Ctypes Ctypesdefs Cop Csyntax Csem Ctyping Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigCBMC Require Import TypedGuards SourceTyping ReachableMath ProducerSteps ArithmeticOriginsExpr ArithmeticContexts ArithmeticEntry GlobalAccess.
Local Open Scope Z_scope.
Lemma arithmetic_context_hole:forall from to C,Csem.context from to C->forall a,
 arithmetic_expr(C a)->arithmetic_expr a
with arithmetic_contextlist_hole:forall from C,Csem.contextlist from C->forall a,
 arithmetic_exprlist(C a)->arithmetic_expr a.
Proof.
 induction 1;cbn[arithmetic_expr];intros a A;intuition eauto using arithmetic_contextlist_hole.
 induction 1;cbn[arithmetic_exprlist];intros a A;intuition eauto using arithmetic_context_hole.
Qed.
Theorem every_initializer_head_origin:forall args m prefix f C k e mp a,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix(ExprState f(C a)k e mp)->
 context RV RV C->arithmetic_head a.
Proof.
 intros args m prefix f C k e mp a PATH CT.
 pose proof(@every_initializer_prefix_arithmetic args m prefix _ PATH)as A.
 exact(arithmetic_expr_head a(@arithmetic_context_hole _ _ _ CT a(proj1 A))).
Qed.
Lemma short_plus_some_integer:forall ge m v y out,
 sem_binary_operation ge Oadd v tshort(Vint y)tint m=Some out->exists x,v=Vint x.
Proof.
 intros ge m v y out S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_add sem_binarith classify_add classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64]in S;try discriminate S.
 eauto.
Qed.
Lemma ready_add_math_guard:forall ge te mp v1 ty1 v2 ty2 out,
 arithmetic_head(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint)->
 Ctyping.wt_rvalue ge te(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint)->
 sem_binary_operation ge Oadd v1 ty1 v2 ty2 mp=Some out->
 exists x y,v1=Vint x /\v2=Vint y /\signed32(Int.signed x+Int.signed y).
Proof.
 intros ge te mp v1 ty1 v2 ty2 out A W S.
 change(add_origin(Eval v1 ty1)(Eval v2 ty2))in A.
 destruct A as[[TY P]|[[EQ P]|[[P EQ]|[P EQ]]]].
 - cbn[typeof]in TY;subst ty1.
   destruct(@producer_literal_bounds _ _ _ P)as[y[V2[TY2 B]]];subst v2 ty2.
   destruct(@short_plus_some_integer ge mp v1 y out S)as[x X];subst v1.
   destruct(@typed_ready_binary_operands ge te Oadd(Vint x)tshort(Vint y)tint tint W)as[L R].
   pose proof(@typed_eval_short_range x L)as N.
   exists x,y;split;[reflexivity|];split;[reflexivity|];unfold signed32,signed16,producer_bounds in *;lia.
 - inversion EQ;subst v1 ty1.
   destruct(@producer_literal_bounds _ _ _ P)as[y[V2[TY2 B]]];subst v2 ty2.
   exists(Int.repr 6434),y;split;[reflexivity|];split;[reflexivity|].
   change(signed32(6434+Int.signed y));unfold signed32,producer_bounds in *;lia.
 - inversion EQ;subst v2 ty2.
   destruct(@producer_literal_bounds _ _ _ P)as[x[V1[TY1 B]]];subst v1 ty1.
   exists x,(Int.repr 1);split;[reflexivity|];split;[reflexivity|].
   change(signed32(Int.signed x+1));unfold signed32,producer_bounds in *;lia.
 - inversion EQ;subst v2 ty2.
   destruct(@producer_literal_bounds _ _ _ P)as[x[V1[TY1 B]]];subst v1 ty1.
   exists x,(Int.repr 1);split;[reflexivity|];split;[reflexivity|].
   change(signed32(Int.signed x+1));unfold signed32,producer_bounds in *;lia.
Qed.
Lemma ready_mul_math_guard:forall v1 ty1 v2 ty2,
 arithmetic_head(Ebinop Omul(Eval v1 ty1)(Eval v2 ty2)tint)->
 exists x y,v1=Vint x /\v2=Vint y /\signed32(Int.signed x*Int.signed y).
Proof.
 intros v1 ty1 v2 ty2 A;change(mul_origin(Eval v1 ty1)(Eval v2 ty2))in A.
 destruct A as[[E1 E2]|[E1 P]];inversion E1;subst v1 ty1.
 - inversion E2;subst v2 ty2;exists(Int.repr 3),(Int.repr 3);repeat split;try reflexivity;vm_compute;intuition discriminate.
 - destruct(@producer_literal_bounds _ _ _ P)as[y[V2[TY2 B]]];subst v2 ty2.
   exists(Int.repr 4),y;split;[reflexivity|];split;[reflexivity|].
   change(signed32(4*Int.signed y));unfold signed32,producer_bounds in *;lia.
Qed.
Lemma ready_shl_math_guard:forall v1 ty1 v2 ty2,
 arithmetic_head(Ebinop Oshl(Eval v1 ty1)(Eval v2 ty2)tint)->
 exists x y,v1=Vint x /\v2=Vint y /\0<=Int.signed x /\0<=Int.signed y<32 /\signed32(Int.signed x*2^Int.signed y).
Proof.
 intros v1 ty1 v2 ty2 A;change(producer MaskEight(Eval v1 ty1)/\Eval v2 ty2=lit 1)in A.
 destruct A as[P EQ];inversion EQ;subst v2 ty2.
 destruct(@producer_literal_bounds _ _ _ P)as[x[V1[TY1 B]]];subst v1 ty1.
 exists x,(Int.repr 1);split;[reflexivity|];split;[reflexivity|].
 all:unfold producer_bounds in B;change(Int.signed(Int.repr 1))with 1.
 all:unfold signed32;cbn[Z.pow];lia.
Qed.
Lemma ready_shr_count_guard:forall a v2 ty2 ty,
 arithmetic_head(Ebinop Oshr a(Eval v2 ty2)ty)->exists y,v2=Vint y/\0<=Int.signed y<32.
Proof.
 intros a v2 ty2 ty P;destruct(@producer_literal_bounds _ _ _ P)as[y[Y[TY B]]];exists y;split;[exact Y|exact B].
Qed.
Theorem every_initializer_add_guard:forall args m prefix f C k e mp v1 ty1 v2 ty2 out,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 sem_binary_operation PprzTrigInit.Execution.ge Oadd v1 ty1 v2 ty2 mp=Some out->
 exists x y,v1=Vint x/\v2=Vint y/\signed32(Int.signed x+Int.signed y).
Proof.
 intros args m prefix f C k e mp v1 ty1 v2 ty2 out PATH CT SEM.
 destruct(@original_reachable_redex_typed args m prefix f C k e mp _ PATH CT)as[te W].
 eapply ready_add_math_guard;[eapply every_initializer_head_origin;eauto|exact W|exact SEM].
Qed.
Theorem every_initializer_mul_guard:forall args m prefix f C k e mp v1 ty1 v2 ty2,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Omul(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists x y,v1=Vint x/\v2=Vint y/\signed32(Int.signed x*Int.signed y).
Proof. intros;eapply ready_mul_math_guard;eapply every_initializer_head_origin;eauto. Qed.
Theorem every_initializer_shl_guard:forall args m prefix f C k e mp v1 ty1 v2 ty2,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Oshl(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists x y,v1=Vint x/\v2=Vint y/\0<=Int.signed x/\0<=Int.signed y<32/\signed32(Int.signed x*2^Int.signed y).
Proof. intros;eapply ready_shl_math_guard;eapply every_initializer_head_origin;eauto. Qed.
Theorem every_initializer_shr_guard:forall args m prefix f C k e mp a v2 ty2 ty,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Oshr a(Eval v2 ty2)ty))k e mp)->context RV RV C->
 exists y,v2=Vint y/\0<=Int.signed y<32.
Proof. intros;eapply ready_shr_count_guard;eapply every_initializer_head_origin;eauto. Qed.
Print Assumptions every_initializer_add_guard.
Print Assumptions every_initializer_mul_guard.
Print Assumptions every_initializer_shl_guard.
Print Assumptions every_initializer_shr_guard.

