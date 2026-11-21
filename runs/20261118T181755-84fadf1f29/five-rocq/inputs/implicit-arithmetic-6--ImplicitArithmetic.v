From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Determinism Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitComplete.
From PprzTrigCBMC Require Import TypedGuards ArithmeticOriginsExpr ArithmeticCoverage ArithmeticScope GlobalAccess GlobalSource.
Import ListNotations.
Local Open Scope Z_scope.
Lemma source_short_deref_trace:forall ge m b ofs t old,
 deref_loc ge tshort m b ofs Full t old->t=E0.
Proof. intros;inversion H;subst;try reflexivity;vm_compute in H0,H1;try discriminate. Qed.
Theorem every_initialized_postincrement_guard:forall initial prefix f C k e mp b ofs ty,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Epostincr Incr(Eloc b ofs Full ty)ty))k e mp)->context RV RV C->
 ty=tshort /\exists x,
 Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)/\signed16(Int.signed x)/\signed32(Int.signed x+1)/\
 rred PprzTrigInit.Execution.ge(Epostincr Incr(Eloc b ofs Full ty)ty)mp E0
 (Ecomma(Eassign(Eloc b ofs Full ty)(Ebinop Oadd(Eval(Vint x)ty)(Eval(Vint Int.one)tint)tint)ty)(Eval(Vint x)ty)ty)mp.
Proof.
 intros initial prefix f C k e mp b ofs ty INIT PATH CT.
 pose proof(@every_initializer_head_origin []initial prefix f C k e mp _ PATH CT)as HEAD.
 change(ty=tshort)in HEAD;subst ty;split;[reflexivity|].
 pose proof(@every_reachable_attempt_safe PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)
 prefix f k e mp RV C _(World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))
 (proj1(InitComplete.initializer_total_proved initial INIT))PATH(@init_source_silent []initial prefix _ PATH)CT)as SAFE.
 apply Cexec.imm_safe_t_inv in SAFE;cbn[Cexec.invert_expr_prop]in SAFE.
 destruct SAFE as[t[old[w'[TYPE[D PT]]]]].
 assert(TRACE:t=E0)by(eapply source_short_deref_trace;eauto);subst t.
 set(next:=Ecomma(Eassign(Eloc b ofs Full tshort)
 (Ebinop Oadd(Eval old tshort)(Eval(Vint Int.one)tint)tint)tshort)(Eval old tshort)tshort).
 assert(RED:rred PprzTrigInit.Execution.ge(Epostincr Incr(Eloc b ofs Full tshort)tshort)mp E0 next mp).
 { unfold next;eapply red_postincr;[exact D|reflexivity]. }
 assert(NEXT:star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix(ExprState f(C next)k e mp)).
 { replace prefix with(prefix**E0)by apply E0_right.
   eapply star_trans;[exact PATH|apply star_one;left;eapply step_rred;[exact RED|exact CT]|reflexivity]. }
 set(CC:=fun a=>C(Ecomma(Eassign(Eloc b ofs Full tshort)a tshort)(Eval old tshort)tshort)).
 assert(CONTEXT:context RV RV CC).
 { unfold CC;eapply Cstrategy.context_compose;[exact CT|]. apply ctx_comma,ctx_assign_right,ctx_top. }
 change(star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(CC(Ebinop Oadd(Eval old tshort)(Eval(Vint Int.one)tint)tint))k e mp))in NEXT.
 destruct(@every_initialized_add_guard initial prefix f CC k e mp old tshort(Vint Int.one)tint INIT NEXT CONTEXT)
 as[out[x[y[SEM[OLD[ONE GUARD]]]]]].
 subst old;inversion ONE;subst y.
 assert(LOAD:Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)).
 { exact(@deref_value_load PprzTrigInit.Execution.ge tshort Mint16signed mp b ofs E0(Vint x)eq_refl eq_refl D). }
 exists x;split;[exact LOAD|]. split.
 - exact(@load_signed16_range mp b(Ptrofs.unsigned ofs)x LOAD).
 - split;[change(signed32(Int.signed x+1))in GUARD;exact GUARD|exact RED].
Qed.
Theorem every_initialized_assignadd_guard:forall initial prefix f C k e mp b ofs ty v2 ty2 tyres,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Eassignop Oadd(Eloc b ofs Full ty)(Eval v2 ty2)tyres ty))k e mp)->context RV RV C->
 ty=tshort/\tyres=tint/\exists x y,
 Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)/\v2=Vint y/\signed16(Int.signed x)/\
 signed32(Int.signed x+Int.signed y)/\
 rred PprzTrigInit.Execution.ge(Eassignop Oadd(Eloc b ofs Full ty)(Eval v2 ty2)tyres ty)mp E0
 (Eassign(Eloc b ofs Full ty)(Ebinop Oadd(Eval(Vint x)ty)(Eval v2 ty2)tyres)ty)mp.
Proof.
 intros initial prefix f C k e mp b ofs ty v2 ty2 tyres INIT PATH CT.
 pose proof(@every_initializer_head_origin []initial prefix f C k e mp _ PATH CT)as HEAD.
 change(ty=tshort/\ty=tshort/\tyres=tint/\producer SmallDelta(Eval v2 ty2))in HEAD.
 destruct HEAD as[TY[_[CALC PROD]]];subst ty tyres;split;[reflexivity|];split;[reflexivity|].
 pose proof(@every_reachable_attempt_safe PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)
 prefix f k e mp RV C _(World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))
 (proj1(InitComplete.initializer_total_proved initial INIT))PATH(@init_source_silent []initial prefix _ PATH)CT)as SAFE.
 apply Cexec.imm_safe_t_inv in SAFE;cbn[Cexec.invert_expr_prop]in SAFE.
 destruct SAFE as[t[old[w'[TYPE[D PT]]]]].
 assert(TRACE:t=E0)by(eapply source_short_deref_trace;eauto);subst t.
 set(next:=Eassign(Eloc b ofs Full tshort)(Ebinop Oadd(Eval old tshort)(Eval v2 ty2)tint)tshort).
 assert(RED:rred PprzTrigInit.Execution.ge(Eassignop Oadd(Eloc b ofs Full tshort)(Eval v2 ty2)tint tshort)mp E0 next mp).
 { unfold next;eapply red_assignop;exact D. }
 assert(NEXT:star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix(ExprState f(C next)k e mp)).
 { replace prefix with(prefix**E0)by apply E0_right.
   eapply star_trans;[exact PATH|apply star_one;left;eapply step_rred;[exact RED|exact CT]|reflexivity]. }
 set(CC:=fun a=>C(Eassign(Eloc b ofs Full tshort)a tshort)).
 assert(CONTEXT:context RV RV CC).
 { unfold CC;eapply Cstrategy.context_compose;[exact CT|]. apply ctx_assign_right,ctx_top. }
 change(star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(CC(Ebinop Oadd(Eval old tshort)(Eval v2 ty2)tint))k e mp))in NEXT.
 destruct(@every_initialized_add_guard initial prefix f CC k e mp old tshort v2 ty2 INIT NEXT CONTEXT)
 as[out[x[y[SEM[OLD[RIGHT GUARD]]]]]].
 subst old.
 assert(LOAD:Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)).
 { exact(@deref_value_load PprzTrigInit.Execution.ge tshort Mint16signed mp b ofs E0(Vint x)eq_refl eq_refl D). }
 exists x,y;split;[exact LOAD|].split;[exact RIGHT|]. split.
 - exact(@load_signed16_range mp b(Ptrofs.unsigned ofs)x LOAD).
 - split;[exact GUARD|exact RED].
Qed.
Print Assumptions every_initialized_postincrement_guard.





