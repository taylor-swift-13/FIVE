From FiveGhSetZetaTermination Require Import Spec.
From FiveGhSetZetaProof Require Import Entry Public.
Theorem termination:Spec.Goal.
Proof.
 unfold Spec.Goal,FiveGhSetZeta.proof.Obligations.termination_goal.
 intros args m PRE;exact(Entry.entry_terminates args m).
Qed.
Print Assumptions termination.
