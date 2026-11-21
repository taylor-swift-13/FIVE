From Stdlib Require Import ZArith.
From PidPositionTranslationSupport Require Import WitnessSetup.
Example original_memory_preparation_succeeds :
 match prepare_witness 0%Z false with Some _=>true | None=>false end=true.
Proof. lazy;reflexivity. Qed.
Example lazy_first_witness_check : witness_check 1600 0%Z false false=true.
Proof. lazy;reflexivity. Qed.
