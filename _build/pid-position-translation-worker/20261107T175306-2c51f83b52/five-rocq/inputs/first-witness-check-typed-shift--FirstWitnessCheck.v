From Stdlib Require Import ZArith.
From PidPositionTranslationSupport Require Import WitnessSetup.
Example first_witness_check : witness_check 1600 0%Z false false=true.
Proof. vm_compute; reflexivity. Qed.
