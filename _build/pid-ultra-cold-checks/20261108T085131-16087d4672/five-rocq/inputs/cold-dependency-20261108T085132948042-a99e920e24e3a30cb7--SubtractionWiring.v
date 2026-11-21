From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From PidPositionSafety Require Import ConditionalBlock GuardedCallee SubtractionObservation.
Theorem prepend_subtraction_certificate:forall ge f initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 subtraction_observation ge f initial ->
 (forall s,P s->subtraction_observation ge f s) ->
 exists Q,certificate ge Q target/\Q initial/\(forall s,Q s->subtraction_observation ge f s).
Proof.
 intros ge f initial middle P target STEP CERT IN OI OP.
 exists(fun s=>s=initial\/P s);split.
 - eapply GuardedCallee.certificate_prepend;[exact STEP|exact CERT|exact IN].
 - split;[left;reflexivity|];intros s[EQ|PS];[subst;exact OI|apply OP;exact PS].
Qed.
Theorem sequence_subtraction_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 (forall s,P s->subtraction_observation ge f s) ->
 (forall s,Q s->subtraction_observation ge f s) ->
 exists R,certificate ge R target/\R(State f(Ssequence first second)k e m)/\
 (forall s,R s->subtraction_observation ge f s).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI OP OQ.
 pose proof(chain_certificate ge P Q _ _ target CP CQ
 (ConditionalBlock.skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_subtraction_certificate.
 - apply ConditionalBlock.sequence_transition.
 - exact JOIN.
 - left;exact PI.
 - exact I.
 - intros s[PS|QS];[apply OP;exact PS|apply OQ;exact QS].
Qed.
Print Assumptions sequence_subtraction_certificate.
