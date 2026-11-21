From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import Contract PidMemory UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From FivePidDfNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m(b&p&a&bc&c&u0&u1&e0&e1&e2&x&EQ&P);subst args.
 destruct(update_call_summary m b p a bc c u0 u1 e0 e1 e2 x P)as[mf[EV POST]].
 eapply defined_evaluator_no_error;[vm_compute;reflexivity|vm_compute;repeat constructor;simpl;intuition discriminate|exact EV].
Qed.
Print Assumptions no_error_proved.
