From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassUpdateCase Require Import Contract UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassUpdateFunctional Require Import Spec.
Theorem normal_completion:Spec.NormalCompletion.
Proof. unfold Spec.NormalCompletion;intros m b p tc li lo value P.
 destruct(update_call_summary m b p tc li lo value P)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args b p value)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p value)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 destruct(defined_evaluator_return_exists Execution.ge _ _ _ N CN EV)as[t PATH];exists t,mf;auto. Qed.
Theorem all_returns:Spec.AllReturns.
Proof. unfold Spec.AllReturns;intros m b p tc li lo value P t result after PATH.
 destruct(update_call_summary m b p tc li lo value P)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args b p value)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p value)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 destruct(defined_evaluator_exact_return Execution.ge _ _ _ _ _ _ N EV PATH)as[VR MR];subst result after;auto. Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
