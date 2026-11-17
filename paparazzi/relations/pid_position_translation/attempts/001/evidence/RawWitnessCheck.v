From Stdlib Require Import ZArith.
From PidPositionTranslationSupport Require Import RawWitness.
Example raw_input_preparation_succeeds :
 match raw_prepare 0%Z false with Some _=>true | None=>false end=true.
Proof. vm_compute;reflexivity. Qed.
Example actual_raw_input_normal_return : raw_witness_check 1600 0%Z false false=true.
Proof. vm_compute;reflexivity. Qed.
