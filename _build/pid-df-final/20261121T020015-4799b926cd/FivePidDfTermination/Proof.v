From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import Contract PidMemory UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From FivePidDfTermination Require Import Spec.
Theorem termination:Spec.AllSuccessorsTerminate.
Proof. intros args m;apply normal_all_successors_terminate;vm_compute;reflexivity. Qed.
Print Assumptions termination.
