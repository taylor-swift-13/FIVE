From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassResetCase Require Import Contract.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline ResetCall.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassResetNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m (b&p&value&EQ&P);subst args.
 destruct(ResetCall.reset_call_summary m b p value P)as[mf[EV POST]];change(Post m mf b p value)in POST;change(state_eval Execution.ge(Execution.entry(Args b p value)m)=Some(Output value,mf))in EV.
 assert(N:normal_state(Execution.entry(Args b p value)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p value)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 eapply defined_evaluator_no_error;[exact N|exact CN|exact EV]. Qed.
Print Assumptions no_error_proved.
