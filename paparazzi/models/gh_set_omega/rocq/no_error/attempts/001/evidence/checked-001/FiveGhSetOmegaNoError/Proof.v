From FiveGhSetOmegaNoError Require Import Spec.
From FiveGhSetOmegaProof Require Import Entry Public.
Theorem no_error:Spec.Goal.
Proof.
 unfold Spec.Goal,FiveGhSetOmega.proof.Obligations.no_error_goal.
 intros args m [s[o[b[-> [SYM[R W]]]]]].
 intros t reached PATH;exact(Entry.entry_no_error s o m b SYM R W t reached PATH).
Qed.
Theorem satisfiable:Spec.SatisfiableGoal.
Proof. exact Public.caller_precondition_satisfiable. Qed.
Print Assumptions no_error.
Print Assumptions satisfiable.
