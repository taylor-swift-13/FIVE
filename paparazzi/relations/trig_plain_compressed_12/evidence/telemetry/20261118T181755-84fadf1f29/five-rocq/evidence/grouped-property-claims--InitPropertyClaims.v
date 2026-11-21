From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigCBMC Require Import TypedGuards SourceOccurrence InitOrigins NibbleGuards EncoderGuards ArithmeticScope ImplicitArithmetic InitHarness InitReference.
Import ListNotations.
Local Open Scope Z_scope.
(** Grouped propositions retain exact original AST certificates and EVERY
    original source-prefix coverage. Per-ID final bindings are case-qualified. *)

Definition initializer_increment_checks:Prop:=
 (actual_init_increment_nodes=
 [source_short_increment PprzTrigInit.Source._i;source_short_increment PprzTrigInit.Source._j;
 source_short_increment PprzTrigInit.Source._cnt;source_short_increment PprzTrigInit.Source._i;
 source_short_increment PprzTrigInit.Source._i;source_short_increment PprzTrigInit.Source._j;
 source_short_increment PprzTrigInit.Source._cnt]) /\
 (forall initial prefix f C k e mp b ofs ty,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Epostincr Incr(Eloc b ofs Full ty)ty))k e mp)->context RV RV C->
 ty=tshort /\exists x,
 Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)/\signed16(Int.signed x)/\signed32(Int.signed x+1)/\
 rred PprzTrigInit.Execution.ge(Epostincr Incr(Eloc b ofs Full ty)ty)mp E0
 (Ecomma(Eassign(Eloc b ofs Full ty)(Ebinop Oadd(Eval(Vint x)ty)(Eval(Vint Int.one)tint)tint)ty)(Eval(Vint x)ty)ty)mp).
Theorem initializer_increment_checks_proved:initializer_increment_checks.
Proof. split;[exact SourceOccurrence.initializer_increment_origins|exact ImplicitArithmetic.every_initialized_postincrement_guard]. Qed.

Definition initializer_addassign_checks:Prop:=
 (actual_init_add_assign_nodes=[actual_single_add_assign;actual_multi_add_assign]) /\
 (forall initial prefix f C k e mp b ofs ty v2 ty2 tyres,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Eassignop Oadd(Eloc b ofs Full ty)(Eval v2 ty2)tyres ty))k e mp)->context RV RV C->
 ty=tshort/\tyres=tint/\exists x y,
 Mem.load Mint16signed mp b(Ptrofs.unsigned ofs)=Some(Vint x)/\v2=Vint y/\signed16(Int.signed x)/\
 signed32(Int.signed x+Int.signed y)/\
 rred PprzTrigInit.Execution.ge(Eassignop Oadd(Eloc b ofs Full ty)(Eval v2 ty2)tyres ty)mp E0
 (Eassign(Eloc b ofs Full ty)(Ebinop Oadd(Eval(Vint x)ty)(Eval v2 ty2)tyres)ty)mp).
Theorem initializer_addassign_checks_proved:initializer_addassign_checks.
Proof. split;[exact SourceOccurrence.initializer_add_assign_origins|exact ImplicitArithmetic.every_initialized_assignadd_guard]. Qed.

Definition initializer_explicit_add_checks:Prop:=
 (filter scalar_add_node init_nodes=[init_single_limit;init_multi_limit;init_ten]) /\
 (forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Oadd v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\signed32(Int.signed x+Int.signed y)).
Theorem initializer_explicit_add_checks_proved:initializer_explicit_add_checks.
Proof. split;[exact InitOrigins.initializer_explicit_add_origins|exact ArithmeticScope.every_initialized_add_guard]. Qed.

Definition initializer_shift_checks:Prop:=
 (filter shl_node init_nodes=[init_shift]) /\
 (forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oshl(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Oshl v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\0<=Int.signed x/\0<=Int.signed y<32/\signed32(Int.signed x*2^Int.signed y)).
Theorem initializer_shift_checks_proved:initializer_shift_checks.
Proof. split;[exact InitOrigins.initializer_shift_origins|exact ArithmeticScope.every_initialized_shl_guard]. Qed.

Definition get_nibble_multiply_checks:Prop:=
 (filter mul_node(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble))=[nibble_shift_expression]) /\
 (forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Omul(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Omul v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\signed32(Int.signed x*Int.signed y)).
Theorem get_nibble_multiply_checks_proved:get_nibble_multiply_checks.
Proof. split;[exact InitOrigins.nibble_multiply_origins|exact ArithmeticScope.every_initialized_mul_guard]. Qed.

Definition get_nibble_distance_checks:Prop:=
 (filter shr_node(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble))=
 [Ebinop Oshr nibble_byte_expression nibble_shift_expression tint]) /\
 (forall initial prefix f C k e mp v1 ty1 v2 ty2 ty,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oshr(Eval v1 ty1)(Eval v2 ty2)ty))k e mp)->context RV RV C->
 exists out y,sem_binary_operation PprzTrigInit.Execution.ge Oshr v1 ty1 v2 ty2 mp=Some out /\
 v2=Vint y/\0<=Int.signed y<32).
Theorem get_nibble_distance_checks_proved:get_nibble_distance_checks.
Proof. split;[exact InitOrigins.nibble_right_shift_origins|exact ArithmeticScope.every_initialized_shr_count_guard]. Qed.

Definition encoder_add_checks:Prop:=
 (filter scalar_add_node(statement_nodes(fn_body PprzTrigInit.Source.f_table_encode_12))=
 [encoder_high_expression;encoder_high_expression]) /\
 (forall initial prefix f C k e mp v1 ty1 v2 ty2,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Ebinop Oadd(Eval v1 ty1)(Eval v2 ty2)tint))k e mp)->context RV RV C->
 exists out x y,sem_binary_operation PprzTrigInit.Execution.ge Oadd v1 ty1 v2 ty2 mp=Some out /\
 v1=Vint x/\v2=Vint y/\signed32(Int.signed x+Int.signed y)).
Theorem encoder_add_checks_proved:encoder_add_checks.
Proof. split;[exact InitOrigins.encoder_add_origins|exact ArithmeticScope.every_initialized_add_guard]. Qed.

Definition genuine_initializer_assertion:Prop:=
 forall initial,Spec.initial_low initial->
 (exists after,Spec.init_returns initial(Vint Int.zero)after)/\
 (forall v after,Spec.init_returns initial v after->v=Vint Int.zero).
Theorem genuine_initializer_assertion_proved:genuine_initializer_assertion.
Proof. exact InitHarness.genuine_init_assertion. Qed.

Definition init_harness_indices:Prop:=
 forall i,0<=Int.signed i<6434->
 0<=Int.signed i<Z.of_nat(length init_reference_values)/\Int.sign_ext 16 i=i.
Theorem init_harness_indices_proved:init_harness_indices.
Proof. exact InitHarness.init_reference_index_guards. Qed.

Definition init_harness_lookup_assertion:Prop:=
 forall initial after i,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->0<=Int.signed i<6434->
 (exists final t,star Csem.step PprzTrigInit.Execution.ge
 (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_12)[Vint i]Kstop after)t
 (Returnstate(Vint(Int.repr(nth(Z.to_nat(Int.signed i))init_reference_values 0)))Kstop final))/\
 (forall v final t,star Csem.step PprzTrigInit.Execution.ge
 (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_12)[Vint i]Kstop after)t(Returnstate v Kstop final)->
 v=Vint(Int.repr(nth(Z.to_nat(Int.signed i))init_reference_values 0))).
Theorem init_harness_lookup_assertion_proved:init_harness_lookup_assertion.
Proof. exact InitHarness.initialized_lookup_literal_assertion. Qed.
