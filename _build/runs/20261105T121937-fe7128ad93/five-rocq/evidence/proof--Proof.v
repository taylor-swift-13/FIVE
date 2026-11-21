From compcert Require Import Values Floats.
From FiveExampleRelation Require Import Spec.
Require FiveSum2Proof.Sum2Return FiveSum3Proof.ReturnValue.

Theorem composition_bits : Sum2EqualsSum3.
Proof.
  unfold Sum2EqualsSum3.
  intros a b c ab lhs rhs m2 m2' m2'' m3 m3' [t1 H1] [t2 H2] [t3 H3].
  pose proof (FiveSum2Proof.Sum2Return.sum2_return_value _ _ _ _ _ _ H1) as E1.
  pose proof (FiveSum2Proof.Sum2Return.sum2_return_value _ _ _ _ _ _ H2) as E2.
  pose proof (FiveSum3Proof.ReturnValue.sum3_return_value _ _ _ _ _ _ _ H3) as E3.
  injection E1 as E1. injection E2 as E2. injection E3 as E3.
  now rewrite E2, E1, E3.
Qed.
Print Assumptions composition_bits.
