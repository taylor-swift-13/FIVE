From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep.
Require PprzTrigPlain.Execution PprzTrigLow.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigCBMC Require Import TypedGuards MathCoverage PlainGuarded LowGuarded UnwindCoverage HarnessGuards HarnessReferenceGuards InitReference.
Import ListNotations.
Local Open Scope Z_scope.

Definition plain_binary : Prop := forall initial a prefix f expr k e m op l rv,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)prefix(ExprState f expr k e m) ->
 BinaryOperationOccurrence expr op l rv ->binary_math_guard op l rv.
Theorem prove_plain_binary : plain_binary.
Proof. exact PlainGuarded.original_plain_every_binary_guard. Qed.

Definition plain_unary : Prop := forall initial a prefix f expr k e m op v,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)prefix(ExprState f expr k e m) ->
 UnaryOperationOccurrence expr op v ->unary_math_guard op v.
Theorem prove_plain_unary : plain_unary.
Proof. exact PlainGuarded.original_plain_every_unary_guard. Qed.

Definition low_binary : Prop := forall initial initialized a tr f expression k e current op v w,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr(ExprState f expression k e current)->
 BinaryOperationOccurrence expression op v w->binary_math_guard op v w.
Theorem prove_low_binary : low_binary.
Proof. exact LowGuarded.original_low_every_binary_guard. Qed.

Definition low_unary : Prop := forall initial initialized a tr f expression k e current op v,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr(ExprState f expression k e current)->
 UnaryOperationOccurrence expression op v->unary_math_guard op v.
Theorem prove_low_unary : low_unary.
Proof. exact LowGuarded.original_low_every_unary_guard. Qed.

Definition initialized_decoder_binary : Prop := forall initial initialized a tr f expression k e current op v w,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->0<=Int.signed a<6434->
 star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal LowDecoder.decoder)[Vint a]Kstop initialized)tr(ExprState f expression k e current)->
 BinaryOperationOccurrence expression op v w->binary_math_guard op v w.
Theorem prove_initialized_decoder_binary : initialized_decoder_binary.
Proof. exact LowGuarded.initialized_decoder_every_binary_guard. Qed.

Definition plain_zero_unwind : Prop := forall initial a tr f v ty guard body k e current,
 Spec.normalized_angle a->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)tr
 (ExprState f(Eval v ty)(Kwhile1 guard body k)e current)->bool_val v ty current=Some false.
Theorem prove_plain_zero_unwind : plain_zero_unwind.
Proof. exact UnwindCoverage.plain_normalizer_zero_unwind. Qed.

Definition low_zero_unwind : Prop := forall initialized a tr f v ty guard body k e current,
 Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr
 (ExprState f(Eval v ty)(Kwhile1 guard body k)e current)->bool_val v ty current=Some false.
Theorem prove_low_zero_unwind : low_zero_unwind.
Proof. exact UnwindCoverage.low_normalizer_zero_unwind. Qed.

Definition plain_harness_assertion : Prop := forall mp a v mf,
 Spec.initial_plain mp ->Spec.normalized_angle a ->
 Spec.Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry[Vint a]mp v mf ->
 exists r,v=Vint r /\ -16383<=Int.signed r<=16383.
Theorem prove_plain_harness_assertion : plain_harness_assertion.
Proof. exact HarnessGuards.plain_harness_actual_assertion. Qed.

Definition low_harness_assertion : Prop := forall ml ml' a v mf,
 Spec.initial_low ml ->Spec.init_returns ml(Vint Int.zero)ml' ->Spec.normalized_angle a ->
 Spec.Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry[Vint a]ml' v mf ->
 v=Vint(Int.repr(harness_expected a)).
Theorem prove_low_harness_assertion : low_harness_assertion.
Proof. exact HarnessGuards.low_harness_actual_assertion. Qed.

Definition reference_positive_fold : Prop := forall a,Spec.normalized_angle a->signed32(12867-Int.signed a).
Theorem prove_reference_positive_fold : reference_positive_fold.
Proof. exact HarnessReferenceGuards.reference_positive_fold_guard. Qed.

Definition reference_negative_fold : Prop := forall a,Spec.normalized_angle a->signed32(-12867-Int.signed a).
Theorem prove_reference_negative_fold : reference_negative_fold.
Proof. exact HarnessReferenceGuards.reference_negative_fold_guard. Qed.

Definition reference_negative_index : Prop := forall a,Spec.normalized_angle a->signed32(-harness_fold(Int.signed a)).
Theorem prove_reference_negative_index : reference_negative_index.
Proof. exact HarnessReferenceGuards.reference_negative_index_guard. Qed.

Definition reference_positive_bounds : Prop := forall a,Spec.normalized_angle a->0<=harness_fold(Int.signed a)->
 0<=harness_fold(Int.signed a)<Z.of_nat(length init_reference_values).
Theorem prove_reference_positive_bounds : reference_positive_bounds.
Proof. exact HarnessReferenceGuards.reference_positive_index_bounds. Qed.

Definition reference_negative_bounds : Prop := forall a,Spec.normalized_angle a->harness_fold(Int.signed a)<0->
 0<= -harness_fold(Int.signed a)<Z.of_nat(length init_reference_values).
Theorem prove_reference_negative_bounds : reference_negative_bounds.
Proof. exact HarnessReferenceGuards.reference_negative_index_bounds. Qed.

Definition reference_negated_value : Prop := forall a,Spec.normalized_angle a->harness_fold(Int.signed a)<0->
 signed32(-nth(Z.to_nat(-harness_fold(Int.signed a)))init_reference_values 0).
Theorem prove_reference_negated_value : reference_negated_value.
Proof. exact HarnessReferenceGuards.reference_value_negation_guard. Qed.

Print Assumptions prove_low_binary.
Print Assumptions prove_plain_zero_unwind.
