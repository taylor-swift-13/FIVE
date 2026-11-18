From FiveGhAccelNoError Require Import Spec.
From FiveGuidanceAllOrder Require Import Unconditional.
Theorem no_error:Spec.Goal.
Proof. intros s sp m bg src o INIT;exact(proj1(accel_safe_termination s sp m bg src o INIT)). Qed.
Print Assumptions no_error.
