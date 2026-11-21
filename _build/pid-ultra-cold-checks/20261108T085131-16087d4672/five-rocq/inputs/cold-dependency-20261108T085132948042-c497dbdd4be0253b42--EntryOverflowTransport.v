From Stdlib Require Import ZArith.
From compcert Require Import AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition BlockExecution.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import EntryOverflowGoal SubtractionObservation.
Open Scope Z_scope.
Definition OriginalEntryObservedCertificateGoal:Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 exists mf P,certificate Execution.ge P(Returnstate Vundef Kstop mf)/\
 P(Execution.entry(call_args gh ret flight)m)/\
 (forall s,P s->subtraction_observation Execution.ge Source.f_guidance_pid_h_run_pos s).
Theorem entry_subtraction_events_from_certificate:
 OriginalEntryObservedCertificateGoal ->EntrySubtractionEventGoal.
Proof.
 intros CERTIFICATES m gh ret flight GOOD t C x y k e ma PATH CT.
 destruct(CERTIFICATES m gh ret flight GOOD)as[mf[P[CERT[INITIAL OBS]]]].
 pose proof(certificate_reachable Execution.ge P _ _ CERT INITIAL
 (return_stop_nostep Execution.ge Vundef mf)t _ PATH)as REACHED.
 exact(OBS _ REACHED eq_refl C x y CT eq_refl).
Qed.
Print Assumptions entry_subtraction_events_from_certificate.
