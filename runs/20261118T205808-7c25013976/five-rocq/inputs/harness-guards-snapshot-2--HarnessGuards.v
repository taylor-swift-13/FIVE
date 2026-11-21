From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Csem.
Require PprzTrigPlain.Execution PprzTrigLow.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix Normalizer PlainBody PlainClosed LowClosed InitComplete InitialMemory.
From PprzTrigCBMC Require Import TypedGuards SineGuards.
Import ListNotations.
Local Open Scope Z_scope.
(** Exact integer reference contract written in the frozen CBMC harness;
    this is a specification, never a substitute source execution model. *)
Definition harness_fold(z:Z):Z:=if z>?6433 then 12867-z else if z<? -6433 then -12867-z else z.
Definition harness_expected(a:Int.int):Z:=let f:=harness_fold(Int.signed a)in if f<?0 then -table_at(-f)else table_at f.
Lemma harness_fold_source_front : forall z,harness_fold z=Normalizer.fold z.
Proof. reflexivity. Qed.
Theorem harness_reference_guards : forall a,Spec.normalized_angle a ->
 signed32(12867-Int.signed a) /\signed32(-12867-Int.signed a) /\
 -6433<=harness_fold(Int.signed a)<=6433 /\signed32(-harness_fold(Int.signed a)) /\
 (0<=harness_fold(Int.signed a)->0<=harness_fold(Int.signed a)<6434) /\
 (harness_fold(Int.signed a)<0->0<= -harness_fold(Int.signed a)<6434) /\
 -16383<=harness_expected a<=16383.
Proof.
 intros a RANGE.
 pose proof(Normalizer.fold_bounds(Int.signed a)RANGE)as F.
 change(-6433<=harness_fold(Int.signed a)<=6433)in F.
 assert(E:-16383<=harness_expected a<=16383).
 { unfold harness_expected;destruct(Z.ltb_spec(harness_fold(Int.signed a))0)as[N|P].
   - pose proof(literal_value_at_bounds(-harness_fold(Int.signed a))ltac:(lia))as V.
     change(0<=table_at(-harness_fold(Int.signed a))<=16383)in V;lia.
   - pose proof(literal_value_at_bounds(harness_fold(Int.signed a))ltac:(lia))as V.
     change(0<=table_at(harness_fold(Int.signed a))<=16383)in V;lia. }
 unfold Spec.normalized_angle in RANGE;unfold signed32;repeat split;lia.
Qed.
Lemma literal_result_reference : forall a,Spec.normalized_angle a ->literal_result a=Int.repr(harness_expected a).
Proof.
 intros a RANGE.
 assert(F:Int.signed(folded a)=harness_fold(Int.signed a)).
 { rewrite folded_repr by exact RANGE.
   rewrite Int.signed_repr;[reflexivity|].
   pose proof(Normalizer.fold_bounds(Int.signed a)RANGE);unfold Normalizer.half_pi;change(-2147483648<=Normalizer.fold(Int.signed a)<=2147483647);lia. }
 unfold literal_result,table_result,harness_expected.
 rewrite<-F;destruct(Int.cmp Cge(folded a)Int.zero)eqn:POS.
 - apply cmp_nonneg in POS;rewrite Z.ltb_ge by exact POS;reflexivity.
 - assert(N:Int.signed(folded a)<0).
   { destruct(Z_le_gt_dec 0(Int.signed(folded a)));[|lia].
     assert(E:Int.cmp Cge(folded a)Int.zero=true)by(apply cmp_nonneg;lia);congruence. }
   rewrite Z.ltb_lt by exact N;unfold literal_lookup;rewrite Int.neg_repr;reflexivity.
Qed.
Theorem plain_harness_actual_assertion : forall mp a v mf,
 Spec.initial_plain mp ->Spec.normalized_angle a ->
 Spec.Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry[Vint a]mp v mf ->
 exists r,v=Vint r /\ -16383<=Int.signed r<=16383.
Proof.
 intros mp a v mf INIT RANGE RETURN.
 destruct(plain_normal_returns_value_and_frame mp a v mf INIT RANGE RETURN)as[VALUE FRAME].
 exists(literal_result a);split;[exact VALUE|].
 rewrite literal_result_reference by exact RANGE.
 pose proof(harness_reference_guards a RANGE)as G;repeat match goal with H:_/\_|-_=>destruct H end.
 rewrite Int.signed_repr by(change(-2147483648<=harness_expected a<=2147483647);lia);lia.
Qed.
Theorem low_harness_actual_assertion : forall ml ml' a v mf,
 Spec.initial_low ml ->Spec.init_returns ml(Vint Int.zero)ml' ->Spec.normalized_angle a ->
 Spec.Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry[Vint a]ml' v mf ->
 v=Vint(Int.repr(harness_expected a)).
Proof.
 intros ml ml' a v mf INIT INITRETURN RANGE RETURN.
 destruct buffer_symbol_info_exists as[b[SYMBOL INFO]].
 pose proof(initialized_packed ml ml' b INIT SYMBOL INITRETURN)as PACKED.
 pose proof(low_buffer_symbol b SYMBOL)as LOWSYMBOL.
 destruct(low_normal_returns_value_and_frame ml' b a v mf RANGE LOWSYMBOL PACKED RETURN)as[VALUE FRAME].
 rewrite VALUE,literal_result_reference by exact RANGE;reflexivity.
Qed.
Print Assumptions harness_reference_guards.
Print Assumptions plain_harness_actual_assertion.
Print Assumptions low_harness_actual_assertion.
