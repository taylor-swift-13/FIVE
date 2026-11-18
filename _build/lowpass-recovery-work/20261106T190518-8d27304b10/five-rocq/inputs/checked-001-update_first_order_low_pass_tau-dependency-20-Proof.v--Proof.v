From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassRetune Require Import Source Execution.
From FiveLowpassRetuneCase Require Import Contract.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline RetuneCall.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassRetuneNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m (b&p&tau&h&EQ&P);subst args.
 destruct(RetuneCall.retune_call_eval m b p tau h P)as[mf[EV POST]];change(Post m mf b p tau h)in POST;change(state_eval Execution.ge(Execution.entry(Args b p tau h)m)=Some(Output tau h,mf))in EV.
 assert(N:normal_state(Execution.entry(Args b p tau h)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p tau h)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 eapply defined_evaluator_no_error;[exact N|exact CN|exact EV]. Qed.
Print Assumptions no_error_proved.
