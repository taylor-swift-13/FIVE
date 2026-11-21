From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import Contract PidMemory UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From FivePidDfFunctional Require Import Spec.
Theorem normal_completion:Spec.NormalCompletion.
Proof. exact update_call_execution. Qed.
Theorem all_returns:Spec.AllReturns.
Proof. exact update_call_observed. Qed.
From FivePidDfCase Require Import Witness.
Theorem nonvacuity:Spec.Nonvacuity.
Proof. intros a bc c u0 u1 e0 e1 e2;destruct(initialized_inhabited a bc c u0 u1 e0 e1 e2)as[m[b P]];exists m,b,Ptrofs.zero;exact P. Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
Print Assumptions nonvacuity.
