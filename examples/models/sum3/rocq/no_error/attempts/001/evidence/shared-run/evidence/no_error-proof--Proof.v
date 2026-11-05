From Stdlib Require Import List.
From compcert Require Import Values Memory Floats Csem Smallstep.
From FiveSum3.proof Require Import Obligations.
From FiveShared.verification Require Import Obligations.
From FiveSum3Proof Require Import Core Invariant.
From FiveSum3Proof Require Import NoErrorSpec.
Import ListNotations.

Theorem generated_no_error_goal :
  NoErrorSpec.Goal.
Proof.
  unfold NoErrorSpec.Goal, FiveSum3.proof.Obligations.no_error_goal,
         FiveShared.verification.Obligations.no_error.
  intros args m [a [b [c EQ]]] t reached PATH; subst args.
  change (~ Invariant.source_error reached).
  eapply Core.sum3_all_reachable_no_error; [unfold Core.sum3_pre; eauto 7|].
  exact PATH.
Qed.
Print Assumptions generated_no_error_goal.
