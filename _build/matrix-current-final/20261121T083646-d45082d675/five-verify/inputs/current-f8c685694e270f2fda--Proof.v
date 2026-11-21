From FiveInv2Functional Require Import Spec.
From FiveInv2Case Require Import Contract Call.
From FiveMatrixInverseSupport Require Import Witness.
Theorem normal_call:Spec.NormalCall.
Proof. intros m bo bi po pi f IN;destruct(call_summary m bo bi po pi f IN)as[mf[[t PATH][POST OTHER]]];exists t,mf;auto. Qed.
Theorem all_returns:Spec.AllReturns.
Proof. intros m bo bi po pi f IN t result mf PATH;destruct(call_summary m bo bi po pi f IN)as[after[EX[POST[SAFE ALL]]]];destruct(ALL t result mf PATH)as[R M];subst result mf;auto. Qed.
Theorem nonvacuity:Spec.Nonvacuity.
Proof. exact matrix4_inhabited. Qed.
Print Assumptions normal_call.
Print Assumptions all_returns.
Print Assumptions nonvacuity.
