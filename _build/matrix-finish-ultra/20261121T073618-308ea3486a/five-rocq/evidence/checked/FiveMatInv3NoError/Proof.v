From compcert Require Import Values Memory.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract Call.
From FiveMatInv3NoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. intros args m(bo&bi&po&pi&f&EQ&NE&W&RD);subst args.
 destruct(call_summary m bo bi po pi f NE W RD)as[mf[EV POST]].
 eapply defined_evaluator_no_error;[vm_compute;reflexivity|vm_compute;repeat constructor;simpl;intuition discriminate|exact EV]. Qed.
Print Assumptions no_error_proved.
