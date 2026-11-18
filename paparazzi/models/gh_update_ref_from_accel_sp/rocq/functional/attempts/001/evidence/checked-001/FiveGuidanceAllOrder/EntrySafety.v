From Stdlib Require Import List.
From compcert Require Import Integers Values Memory Events Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry ConditionalCompletion.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import PhaseComposition SpeedExecution AccelExecution EntryCorollaries.
Require FiveGuidanceSemantics.SpeedSource FiveGuidanceSemantics.AccelSource.
Require FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.

Lemma certificate_normal_path:forall ge P target initial,
 certificate ge P target ->P initial ->Acc(successor ge)initial ->
 exists t,star Csem.step ge initial t target.
Proof.
 intros ge P target initial CERT PI ACCESS;revert PI.
 induction ACCESS as[s ACCESS IH];intros PI.
 destruct(proj1 CERT s PI)as[EQ|[t[next[STEP PN]]]].
 - subst s;exists E0;apply star_refl.
 - destruct(IH next ltac:(exists t;exact STEP)PN)as[tail PATH].
   exists(t**tail);eapply star_step;[exact STEP|exact PATH|reflexivity].
Qed.
Theorem speed_safe_termination_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->
 safe_termination FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr src o]m).
Proof.
 intros SQ s sp m bg src o INIT;split.
 - intros t reached PATH[NOTFINAL STOP].
   destruct(speed_no_error_given_software SQ s sp m bg src o INIT t reached PATH)as[[mf EQ]|[tr[next STEP]]].
   + apply NOTFINAL;exists Vundef,mf;exact EQ.
   + exact(STOP tr next STEP).
 - apply FiveGuidanceSemantics.SpeedSource.all_successor_termination.
Qed.
Theorem accel_safe_termination_given_software:
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->forall s sp m bg src o,
 accel_initial s sp m bg src o ->
 safe_termination FiveGhAccel.Execution.ge(FiveGhAccel.Execution.entry[Vptr src o]m).
Proof.
 intros SQ s sp m bg src o INIT;split.
 - intros t reached PATH[NOTFINAL STOP].
   destruct(accel_no_error_given_software SQ s sp m bg src o INIT t reached PATH)as[[mf EQ]|[tr[next STEP]]].
   + apply NOTFINAL;exists Vundef,mf;exact EQ.
   + exact(STOP tr next STEP).
 - apply FiveGuidanceSemantics.AccelSource.all_successor_termination.
Qed.
Theorem normal_completion_from_all_orders:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->NormalCompletion.
Proof.
 intros SQ AQ;unfold NormalCompletion;intros s sp a ma mb ba bb pa pb oa ob IA IB MATCH.
 destruct MATCH as[si[INT BITS]];apply vector_bits_injective in BITS;subst a.
 destruct(speed_entry_certificate SQ s sp ma ba pa oa IA)as(sf&fa&PS&US&CS&IS&RS&RESTS).
 destruct(accel_entry_certificate AQ s(raw_speed_accel si sp)mb bb pb ob IB)as(sg&fb&PA&UA&CA&INA&RA&RESTA).
 pose proof(matching_accel_after_integration fixed_maximum s si sp INT)as MATCHUPDATE.
 rewrite <-MATCHUPDATE,US in UA;injection UA as EQ;subst sg.
 destruct(certificate_normal_path _ PS _ _ CS IS(FiveGuidanceSemantics.SpeedSource.all_successor_termination _ _))as[ts PATHS].
 destruct(certificate_normal_path _ PA _ _ CA INA(FiveGuidanceSemantics.AccelSource.all_successor_termination _ _))as[ta PATHA].
 exists fa,fb,sf;split.
 - exists ts,Vundef;exact PATHS.
 - split;[exists ta,Vundef;exact PATHA|auto].
Qed.
Print Assumptions speed_safe_termination_given_software.
Print Assumptions accel_safe_termination_given_software.
Print Assumptions normal_completion_from_all_orders.
