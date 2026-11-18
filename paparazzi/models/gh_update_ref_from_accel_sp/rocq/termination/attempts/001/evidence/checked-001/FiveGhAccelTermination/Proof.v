From FiveGhAccelTermination Require Import Spec.
From FiveGuidanceSemantics Require Import AccelSource.
Theorem termination:Spec.Goal.
Proof. exact AccelSource.all_successor_termination. Qed.
Print Assumptions termination.
