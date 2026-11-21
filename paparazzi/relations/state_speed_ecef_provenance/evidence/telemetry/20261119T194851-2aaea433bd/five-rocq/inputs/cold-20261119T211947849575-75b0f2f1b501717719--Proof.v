From StateSpeedSetEcefISupport Require Import Termination.
From StateSpeedSetEcefITerminationProblem Require Import Spec.
Theorem proved_termination:AllSuccessorsTerminate.
Proof. exact all_successor_termination. Qed.
Print Assumptions proved_termination.
