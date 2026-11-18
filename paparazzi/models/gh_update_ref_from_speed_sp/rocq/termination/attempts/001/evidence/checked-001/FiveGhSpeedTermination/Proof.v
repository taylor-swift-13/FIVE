From FiveGhSpeedTermination Require Import Spec.
From FiveGuidanceSemantics Require Import SpeedSource.
Theorem termination:Spec.Goal.
Proof. exact SpeedSource.all_successor_termination. Qed.
Print Assumptions termination.
