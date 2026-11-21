From Stdlib Require Import List.
From compcert Require Import Values Memory Floats Csem Smallstep.
From FiveSum2.proof Require Import Obligations.
From FiveShared.verification Require Import Obligations.
From FiveSum2Proof Require Import SourceInvariant Invariant Entry NoErrorSpec.
Import ListNotations.
Theorem generated_no_error_goal : NoErrorSpec.Goal.
Proof.
 unfold NoErrorSpec.Goal, FiveSum2.proof.Obligations.no_error_goal,
 FiveShared.verification.Obligations.no_error.
 intros args m [a [b EQ]] t reached PATH; subst args.
 change (~source_error reached).
 apply invariant_excludes_error.
 eapply reachable_invariant; [|exact PATH].
 split; [apply sum2_start_source|]. split; [reflexivity|].
 destruct(typed_entry_result2 m a b) as [mf EVAL]. eexists;exact EVAL.
Qed.
Print Assumptions generated_no_error_goal.
