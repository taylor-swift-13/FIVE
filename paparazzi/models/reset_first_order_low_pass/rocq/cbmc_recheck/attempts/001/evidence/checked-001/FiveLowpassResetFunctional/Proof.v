From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassResetCase Require Import Contract.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline ResetCall.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassResetFunctional Require Import Spec.
Theorem normal_completion:Spec.NormalCompletion.
Proof. unfold Spec.NormalCompletion;intros m b p value P.
 destruct(ResetCall.reset_call_summary m b p value P)as[mf[EV POST]];change(Post m mf b p value)in POST;change(state_eval Execution.ge(Execution.entry(Args b p value)m)=Some(Output value,mf))in EV.
 assert(N:normal_state(Execution.entry(Args b p value)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p value)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 destruct(defined_evaluator_return_exists Execution.ge _ _ _ N CN EV)as[t PATH];exists t,mf;auto. Qed.
Theorem all_returns:Spec.AllReturns.
Proof. unfold Spec.AllReturns;intros m b p value P t result after PATH.
 destruct(ResetCall.reset_call_summary m b p value P)as[mf[EV POST]];change(Post m mf b p value)in POST;change(state_eval Execution.ge(Execution.entry(Args b p value)m)=Some(Output value,mf))in EV.
 assert(N:normal_state(Execution.entry(Args b p value)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p value)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 destruct(defined_evaluator_exact_return Execution.ge _ _ _ _ _ _ N EV PATH)as[VR MR];subst result after;auto. Qed.
Theorem nonvacuity:Spec.Nonvacuity.
Proof. destruct(Mem.alloc Mem.empty 0 12)as[m b]eqn:A;exists m,b,Ptrofs.zero;unfold writable12;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[change(0+12<=18446744073709551616);lia|].
 intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|lia]|constructor]. Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
Print Assumptions nonvacuity.
