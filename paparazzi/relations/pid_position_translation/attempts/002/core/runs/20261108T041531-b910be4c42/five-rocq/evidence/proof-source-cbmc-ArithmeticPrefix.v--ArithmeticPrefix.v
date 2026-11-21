From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationCore Require Import CoreSemantics CoreTail.
From CoreCBMC Require Import ArithmeticPhases ArithmeticExecution.
Lemma observed_weaken:forall ge O1 O2 initial target,
 (forall s,O1 s->O2 s) ->
 observed_certificate ge O1 initial target ->
 observed_certificate ge O2 initial target.
Proof. intros ge O1 O2 initial target IMP[P[CP[PI PO]]];exists P;split;[exact CP|];split;[exact PI|intros s PS;apply IMP;apply PO;exact PS]. Qed.
Theorem annotated_prefix_certificate:forall n ge e s m mid,
 annotated_execution ge e(first_statements n s)m mid ->
 forall f k target,
 observed_certificate ge(annotated_state ge f)(State f(drop_statements n s)k e mid)target ->
 observed_certificate ge(annotated_state ge f)(State f s k e m)target.
Proof.
 induction n;intros ge e s m mid EX f k target TAIL.
 - cbn[first_statements]in EX;inversion EX;subst;exact TAIL.
 - destruct s;cbn[first_statements drop_statements]in EX,TAIL.
   all:try solve[eapply observed_join;[eapply annotated_execution_certificate;exact EX|exact TAIL]].
   inversion EX;subst.
   eapply observed_sequence;[split;reflexivity|split;reflexivity|eapply annotated_execution_certificate;eassumption|].
   eapply IHn;[eassumption|exact TAIL].
Qed.
Print Assumptions annotated_prefix_certificate.
