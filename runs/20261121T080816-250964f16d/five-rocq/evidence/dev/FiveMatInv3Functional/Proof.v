From Stdlib Require Import ZArith Lia.
From compcert Require Import Values Memory Csem Smallstep.
From FiveLowpassSupport Require Import Straightline.
From FiveGuidanceAllOrder Require Import CallfreeExecution.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract Call.
From FiveMatInv3Functional Require Import Spec.
Local Open Scope Z_scope.
Lemma evaluator_post:forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 exists mf,state_eval Execution.ge(Execution.entry(Args bo bi po pi)m)=Some(Status f,mf)/\Spec.Post m mf bo bi po pi f.
Proof. intros m bo bi po pi f NE W RD;destruct(call_summary m bo bi po pi f NE W RD)as[mf[EV[BYTES[FR[WF[BL AC]]]]]].
 exists mf;split;[exact EV|];split;[exact BYTES|];split;[exact FR|];split;[exact WF|];split;[exact BL|];split;[exact AC|].
 apply FR;[exact(reads_valid m bi pi 9 f ltac:(lia)RD)|left;congruence]. Qed.
Theorem normal_call:Spec.NormalCall.
Proof. intros m bo bi po pi f NE W RD;destruct(evaluator_post m bo bi po pi f NE W RD)as[mf[EV POST]].
 exists mf;split;[|exact POST];eapply defined_evaluator_return_exists;[vm_compute;reflexivity|vm_compute;repeat constructor;simpl;intuition discriminate|exact EV]. Qed.
Theorem all_normal_observations:Spec.AllNormalObservations.
Proof. intros m bo bi po pi f NE W RD t v mf PATH;destruct(evaluator_post m bo bi po pi f NE W RD)as[expected[EV POST]].
 destruct(defined_evaluator_exact_return Execution.ge(Execution.entry(Args bo bi po pi)m)(Status f)expected t v mf ltac:(vm_compute;reflexivity)EV PATH)as[-> ->];split;[reflexivity|exact POST]. Qed.
Print Assumptions normal_call.
Print Assumptions all_normal_observations.
