From FiveLowpassSupport Require Import Straightline.
From FiveGuidanceAllOrder Require Import CallfreeExecution.
From FiveMatInv3Termination Require Import Spec.
Theorem termination_proved:Spec.Termination.
Proof. intros args m;apply normal_all_successors_terminate;vm_compute;reflexivity. Qed.
Print Assumptions termination_proved.
