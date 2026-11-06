From FiveGhSetOmegaTermination Require Import Spec.
From FiveGhSetOmegaProof Require Import Entry Public.
Theorem termination:Spec.Goal.
Proof.
 unfold Spec.Goal,FiveGhSetOmega.proof.Obligations.termination_goal.
 intros args m PRE;exact(Entry.entry_terminates args m).
Qed.
Print Assumptions termination.
