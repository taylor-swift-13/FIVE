From FiveInv2NoError Require Import Spec.
From FiveInv2Case Require Import Contract Call.
Theorem no_error_proved:Spec.NoError.
Proof. intros args m(bo&bi&po&pi&f&EQ&IN);subst args;destruct(call_summary m bo bi po pi f IN)as[mf[PATH[POST[SAFE ALL]]]];exact SAFE. Qed.
Print Assumptions no_error_proved.
