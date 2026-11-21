From StateSpeedSetNedISupport Require Import Termination.
From StateSpeedSetNedITerminationProblem Require Import Spec.
Theorem proved_termination:AllSuccessorsTerminate.
Proof. exact all_successor_termination. Qed.
Print Assumptions proved_termination.
