From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From PidPositionRunPos Require Import Source.
From CoreCBMC Require Import ArithmeticObservation.
From PidPositionSafety Require Import ConditionalBlock GuardedCallee SubtractionObservation.
Theorem prepend_core_observed_certificate:forall ge initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 arithmetic_observation ge Source.f_guidance_pid_h_run initial ->
 (forall s,P s->arithmetic_observation ge Source.f_guidance_pid_h_run s) ->
 exists Q,certificate ge Q target/\Q initial/\(forall s,Q s->arithmetic_observation ge Source.f_guidance_pid_h_run s).
Proof.
 intros ge initial middle P target STEP CERT IN OI OP.
 exists(fun s=>s=initial\/P s);split.
 - eapply GuardedCallee.certificate_prepend;[exact STEP|exact CERT|exact IN].
 - split;[left;reflexivity|];intros s[EQ|PS];[subst;exact OI|apply OP;exact PS].
Qed.
Theorem sequence_core_observed_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 (forall s,P s->arithmetic_observation ge Source.f_guidance_pid_h_run s) ->
 (forall s,Q s->arithmetic_observation ge Source.f_guidance_pid_h_run s) ->
 exists R,certificate ge R target/\R(State f(Ssequence first second)k e m)/\
 (forall s,R s->arithmetic_observation ge Source.f_guidance_pid_h_run s).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI OP OQ.
 pose proof(chain_certificate ge P Q _ _ target CP CQ
 (ConditionalBlock.skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_core_observed_certificate.
 - apply ConditionalBlock.sequence_transition.
 - exact JOIN.
 - left;exact PI.
 - exact I.
 - intros s[PS|QS];[apply OP;exact PS|apply OQ;exact QS].
Qed.
Print Assumptions sequence_core_observed_certificate.
