From Stdlib Require Import List ZArith Lia.
From compcert Require Import Values Memory Floats.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FiveRmatVmult Require Import Execution.
From FiveRmatVmultCase Require Import Contract Call.
From FiveRmatVmultNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof.
 unfold Spec.NoError;intros args m(bo&br&bv&po&pr&pv&f&v&EQ&OR&OV&RV&W&RM&RI);subst args.
 destruct(call_summary m bo br bv po pr pv f v OR OV RV W RM RI)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args bo br bv po pr pv)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args bo br bv po pr pv)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 eapply defined_evaluator_no_error;[exact N|exact CN|exact EV].
Qed.
Print Assumptions no_error_proved.
