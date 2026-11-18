From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassGetCase Require Import Contract GetCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassGetNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m (b&p&value&EQ&P);subst args.
 destruct(get_call_summary m b p value P)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args b p)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 eapply defined_evaluator_no_error;[exact N|exact CN|exact EV]. Qed.
Print Assumptions no_error_proved.
