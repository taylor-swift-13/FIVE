From FiveInv2Termination Require Import Spec.
From FiveInv2Case Require Import Closure.
Theorem all_successors_terminate:Spec.AllSuccessorsTerminate.
Proof. exact Closure.all_successor_termination. Qed.
Print Assumptions all_successors_terminate.
