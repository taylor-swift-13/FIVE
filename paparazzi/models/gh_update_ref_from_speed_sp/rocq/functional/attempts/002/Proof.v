From compcert Require Import Values Csem.
From FiveGhSpeedFunctional Require Import Spec.
From FiveGuidanceAllOrder Require Import Unconditional EntryCorollaries EntrySafety SpeedExecution.
Require FiveGuidanceSemantics.SpeedSource.
Theorem normal_completion:Spec.NormalCompletion.
Proof.
 intros s sp m bg src o INIT.
 destruct(speed_entry_certificate speed_sqrt_contract s sp m bg src o INIT)as(sf&mf&P&UPDATE&CERT&PI&REP&REST).
 destruct(certificate_normal_path _ P _ _ CERT PI(FiveGuidanceSemantics.SpeedSource.all_successor_termination _ _))as[t PATH].
 exists sf,mf;split;[exact UPDATE|]. split;[exists t,Vundef;exact PATH|exact REP].
Qed.
Theorem all_returns:Spec.AllReturns.
Proof. exact(speed_all_returns_given_software speed_sqrt_contract). Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
