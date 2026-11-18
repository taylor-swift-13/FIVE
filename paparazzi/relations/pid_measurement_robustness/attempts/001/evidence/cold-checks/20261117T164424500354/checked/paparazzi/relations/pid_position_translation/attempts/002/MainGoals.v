From Stdlib Require Import List.
From compcert Require Import AST Values Memory Events Csem Smallstep.
From PidPositionRunPos Require Import Execution.
From PidPositionTranslationProblem Require Import Spec.
From FiveGuidanceAllOrder Require Import PhaseComposition BlockExecution.
From PidPositionSafety Require Import PidTermination.
From PidPositionTranslationAttempt002 Require Import EntryAllOrder ComputedRelation NonemptyInput.

Theorem original_entry_all_normal_memories_unique :
 forall m gh ret flight af bf,InputGood m gh ret ->
 NormalCall gh ret flight m af ->NormalCall gh ret flight m bf ->af=bf.
Proof.
 intros m gh ret flight af bf GOOD[ta[va PA]][tb[vb PB]].
 destruct(original_entry_all_orders m gh ret flight GOOD)as[mf[P[CERT INIT]]].
 destruct(certificate_normal_unique Execution.ge P Vundef mf _ CERT INIT ta va af PA)as[_ A].
 destruct(certificate_normal_unique Execution.ge P Vundef mf _ CERT INIT tb vb bf PB)as[_ B].
 congruence.
Qed.

Theorem proved_position_translation : PositionTranslationGoal.
Proof.
 intros gh ret a b dx dy flight PAIR.
 destruct(constructed_original_position_translation gh ret a b dx dy flight PAIR)
 as[af[bf[CA[CB REL]]]].
 split;[exists af,bf;auto|].
 intros af' bf' CA' CB'.
 assert(A:af'=af)by(eapply original_entry_all_normal_memories_unique;[exact(proj1 PAIR)|exact CA'|exact CA]).
 assert(B:bf'=bf)by(eapply original_entry_all_normal_memories_unique;[exact(proj1(proj2 PAIR))|exact CB'|exact CB]).
 subst af' bf';exact REL.
Qed.

Theorem proved_no_error : NoErrorGoal.
Proof.
 intros gh ret m flight GOOD t reached PATH.
 destruct(original_entry_all_orders m gh ret flight GOOD)as[mf[P[CERT INIT]]].
 pose proof(return_stop_nostep Execution.ge Vundef mf)as STOP.
 destruct(certificate_no_error Execution.ge P _ _ CERT INIT STOP t reached PATH)
 as[EQ|[tr[next STEP]]].
 - subst reached;intros[NONNORMAL NS];apply NONNORMAL;exists Vundef,mf;reflexivity.
 - intros[NONNORMAL NS];eapply NS;exact STEP.
Qed.

Theorem proved_all_successor_termination : AllSuccessorTerminationGoal.
Proof.
 intros gh ret m flight GOOD.
 exact(PidTermination.all_successor_termination(call_args gh ret flight)m).
Qed.
Theorem proved_input_nonvacuity : InputNonvacuityGoal.
Proof. exact canonical_input_nonvacuity. Qed.
Theorem proved_nonzero_nonvacuity : NonzeroNonvacuityGoal.
Proof. exact canonical_nonzero_execution_nonvacuity. Qed.
Print Assumptions proved_position_translation.
Print Assumptions proved_no_error.
Print Assumptions proved_all_successor_termination.
Print Assumptions proved_input_nonvacuity.
Print Assumptions proved_nonzero_nonvacuity.
