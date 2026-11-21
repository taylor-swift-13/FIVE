From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Determinism Ctypes Ctypesdefs Cop Csyntax Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitComplete.
From PprzTrigCBMC Require Import TypedGuards ArithmeticCoverage GlobalAccess GlobalSource.
Import ListNotations.
Local Open Scope Z_scope.
Theorem every_initialized_ready_binary_exists:forall initial prefix f C k e mp op v1 ty1 v2 ty2 ty,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop op(Eval v1 ty1)(Eval v2 ty2)ty))k e mp)->context RV RV C->
 exists out,sem_binary_operation PprzTrigInit.Execution.ge op v1 ty1 v2 ty2 mp=Some out.
Proof.
 intros initial prefix f C k e mp op v1 ty1 v2 ty2 ty INIT PATH CT.
 pose proof(@every_reachable_attempt_safe PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)
 prefix f k e mp RV C _(World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))
 (proj1(InitComplete.initializer_total_proved initial INIT))PATH(@init_source_silent []initial prefix _ PATH)CT)as SAFE.
 apply Cexec.imm_safe_t_inv in SAFE;exact SAFE.
Qed.
Theorem every_initialized_add_guard:forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Oadd v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\signed32(Int.signed x+Int.signed y).
Proof.
 intros initial prefix f C k e mp v1 ty1 v2 ty2 INIT PATH CT.
 destruct(@every_initialized_ready_binary_exists initial prefix f C k e mp Oadd v1 ty1 v2 ty2 tint INIT PATH CT)as[out SEM].
 destruct(@every_initializer_add_guard []initial prefix f C k e mp v1 ty1 v2 ty2 out PATH CT SEM)as[x[y[LEFT[RIGHT GUARD]]]].
 exists out,x,y;auto.
Qed.
Theorem every_initialized_mul_guard:forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Omul(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Omul v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\signed32(Int.signed x*Int.signed y).
Proof.
 intros initial prefix f C k e mp v1 ty1 v2 ty2 INIT PATH CT.
 destruct(@every_initialized_ready_binary_exists initial prefix f C k e mp Omul v1 ty1 v2 ty2 tint INIT PATH CT)as[out SEM].
 destruct(@every_initializer_mul_guard []initial prefix f C k e mp v1 ty1 v2 ty2 PATH CT)as[x[y[LEFT[RIGHT GUARD]]]].
 exists out,x,y;auto.
Qed.
Theorem every_initialized_shl_guard:forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oshl(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Oshl v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\0<=Int.signed x/\0<=Int.signed y<32/\signed32(Int.signed x*2^Int.signed y).
Proof.
 intros initial prefix f C k e mp v1 ty1 v2 ty2 INIT PATH CT.
 destruct(@every_initialized_ready_binary_exists initial prefix f C k e mp Oshl v1 ty1 v2 ty2 tint INIT PATH CT)as[out SEM].
 destruct(@every_initializer_shl_guard []initial prefix f C k e mp v1 ty1 v2 ty2 PATH CT)as[x[y[LEFT[RIGHT GUARD]]]].
 exists out,x,y;auto.
Qed.
Theorem every_initialized_shr_count_guard:forall initial prefix f C k e mp v1 ty1 v2 ty2 ty,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oshr(Eval v1 ty1)(Eval v2 ty2)ty))k e mp)->context RV RV C->
 exists out y,sem_binary_operation PprzTrigInit.Execution.ge Oshr v1 ty1 v2 ty2 mp=Some out /\
 v2=Vint y/\0<=Int.signed y<32.
Proof.
 intros initial prefix f C k e mp v1 ty1 v2 ty2 ty INIT PATH CT.
 destruct(@every_initialized_ready_binary_exists initial prefix f C k e mp Oshr v1 ty1 v2 ty2 ty INIT PATH CT)as[out SEM].
 destruct(@every_initializer_shr_guard []initial prefix f C k e mp(Eval v1 ty1)v2 ty2 ty PATH CT)as[y[RIGHT GUARD]].
 exists out,y;auto.
Qed.
Print Assumptions every_initialized_add_guard.
