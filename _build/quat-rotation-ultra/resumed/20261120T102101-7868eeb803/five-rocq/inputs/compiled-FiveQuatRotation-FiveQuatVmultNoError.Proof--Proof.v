From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveQuatVmult Require Import Source Execution.
From FiveQuatVmultCase Require Import Contract Body Call.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FiveQuatVmultNoError Require Import Spec.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m(q&v&out&qi&qx&qy&qz&vx&vy&vz&EQ&IN);subst args.
 destruct(call_summary m q v out qi qx qy qz vx vy vz IN)as[mf[EV POST]].
 eapply defined_evaluator_no_error;[vm_compute;reflexivity|vm_compute;repeat constructor;simpl;intuition discriminate|exact EV]. Qed.
Print Assumptions no_error_proved.
