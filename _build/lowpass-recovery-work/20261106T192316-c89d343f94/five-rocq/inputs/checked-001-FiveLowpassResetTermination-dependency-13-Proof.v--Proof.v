From FiveLowpassResetTermination Require Import Spec.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassSupport Require Import Straightline.
Theorem termination:Spec.AllSuccessorsTerminate.
Proof. unfold Spec.AllSuccessorsTerminate;intros args m;apply normal_all_successors_terminate;vm_compute;reflexivity. Qed.
Print Assumptions termination.
