From Stdlib Require Import List.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry ConditionalCompletion.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import PhaseComposition SpeedExecution AccelExecution.
Require FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.

Theorem speed_all_returns_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->forall fa,speed_call m src o fa ->
 exists sf,speed_update fixed_maximum s sp=Some sf /\repr sf fa bg.
Proof.
 intros SQ s sp m bg src o INIT fa[t[v PATH]].
 destruct(speed_entry_certificate SQ s sp m bg src o INIT)as(sf&mf&P&UPDATE&CERT&PI&REP&REST).
 destruct(certificate_normal_unique _ P Vundef mf _ CERT PI t v fa PATH)as[EV EM];subst fa.
 exists sf;auto.
Qed.
Theorem accel_all_returns_given_software:
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->forall s sp m bg src o,
 accel_initial s sp m bg src o ->forall fa,accel_call m src o fa ->
 exists sf,accel_update fixed_maximum s sp=Some sf /\repr sf fa bg.
Proof.
 intros SQ s sp m bg src o INIT fa[t[v PATH]].
 destruct(accel_entry_certificate SQ s sp m bg src o INIT)as(sf&mf&P&UPDATE&CERT&PI&REP&REST).
 destruct(certificate_normal_unique _ P Vundef mf _ CERT PI t v fa PATH)as[EV EM];subst fa.
 exists sf;auto.
Qed.
Theorem all_final_formula_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->AllFinalStateFormula.
Proof.
 intros SQ AQ;unfold AllFinalStateFormula;intros s sp a ma mb ba bb pa pb oa ob fa fb IA IB MATCH CA CB.
 destruct MATCH as[si[INT BITS]];apply vector_bits_injective in BITS;subst a.
 destruct(speed_all_returns_given_software SQ s sp ma ba pa oa IA fa CA)as[sf[US RS]].
 destruct(accel_all_returns_given_software AQ s(raw_speed_accel si sp)mb bb pb ob IB fb CB)as[sg[UA RA]].
 pose proof(matching_accel_after_integration fixed_maximum s si sp INT)as MATCHUPDATE.
 rewrite <-MATCHUPDATE,US in UA;injection UA as EQ;subst sg.
 exists sf;auto.
Qed.
Theorem all_final_named_bits_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->AllFinalNamedBits.
Proof.
 intros SQ AQ;unfold AllFinalNamedBits;intros s sp a ma mb ba bb pa pb oa ob fa fb sa sb IA IB MATCH CA CB RSA RSB.
 destruct(all_final_formula_given_software SQ AQ s sp a ma mb ba bb pa pb oa ob fa fb IA IB MATCH CA CB)
 as[sf[UPDATE[RS RA]]].
 pose proof(repr_unique sa sf fa ba RSA RS)as EQA.
 pose proof(repr_unique sb sf fb bb RSB RA)as EQB;subst;reflexivity.
Qed.
Theorem speed_no_error_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->forall t reached,
 star Csem.step FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t reached ->
 (exists mf,reached=Returnstate Vundef Kstop mf) \/exists tr next,Csem.step FiveGhSpeed.Execution.ge reached tr next.
Proof.
 intros SQ s sp m bg src o INIT t reached PATH.
 destruct(speed_entry_certificate SQ s sp m bg src o INIT)as(sf&mf&P&UPDATE&CERT&PI&REP&REST).
 assert(STOP:nostep Csem.step FiveGhSpeed.Execution.ge(Returnstate Vundef Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 destruct(certificate_no_error _ P _ _ CERT PI STOP t reached PATH)as[EQ|STEP];[left;eauto|auto].
Qed.
Theorem accel_no_error_given_software:
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->forall s sp m bg src o,
 accel_initial s sp m bg src o ->forall t reached,
 star Csem.step FiveGhAccel.Execution.ge(FiveGhAccel.Execution.entry[Vptr src o]m)t reached ->
 (exists mf,reached=Returnstate Vundef Kstop mf) \/exists tr next,Csem.step FiveGhAccel.Execution.ge reached tr next.
Proof.
 intros SQ s sp m bg src o INIT t reached PATH.
 destruct(accel_entry_certificate SQ s sp m bg src o INIT)as(sf&mf&P&UPDATE&CERT&PI&REP&REST).
 assert(STOP:nostep Csem.step FiveGhAccel.Execution.ge(Returnstate Vundef Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 destruct(certificate_no_error _ P _ _ CERT PI STOP t reached PATH)as[EQ|STEP];[left;eauto|auto].
Qed.
Print Assumptions all_final_formula_given_software.
Print Assumptions all_final_named_bits_given_software.
Print Assumptions speed_no_error_given_software.
Print Assumptions accel_no_error_given_software.
