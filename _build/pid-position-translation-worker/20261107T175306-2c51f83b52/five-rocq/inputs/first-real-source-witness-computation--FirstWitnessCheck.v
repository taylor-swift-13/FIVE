From PidPositionTranslationSupport Require Import WitnessSetup.
Example first_witness_check : witness_check 1600 0 false false=true.
Proof. vm_compute; reflexivity. Qed.
