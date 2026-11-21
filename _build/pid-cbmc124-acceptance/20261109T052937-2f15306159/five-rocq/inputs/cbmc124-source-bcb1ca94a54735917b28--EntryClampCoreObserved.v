From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationCore Require Import ConditionalStrategy.
From PidPositionSafety Require Import EntryClampObserved.
From CoreCBMC Require Import ArithmeticTree ArithmeticPhases ArithmeticPrefix ArithmeticObservation CoreObservationWiring.
Theorem conditional_assignment_core_observed_from_normal:
 forall ge f e k m mf l r ty,
 source_simple l=true ->conditional_shape r=true ->typeof l=ty ->PureSyntax.nv ty=true ->
 arithmetic_tree ge e m(Eassign l r ty) ->
 exec_stmt ge e m(Sdo(Eassign l r ty))E0 mf Out_normal ->
 observed_certificate ge(arithmetic_observation ge Source.f_guidance_pid_h_run)
 (State f(Sdo(Eassign l r ty))k e m)(State f Sskip k e mf).
Proof.
 intros ge f e k m mf l r ty LS RS LT NV TREE EX.
 eapply observed_weaken;[|eapply observed_conditional_assignment_from_normal;eassumption].
 intros s[SC TS];apply tree_state_observation;exact TS.
Qed.
Theorem entry_clamp_core_observed_from_normal:forall ge f e k m mf id axis shift,
 shift=8%Z \/shift=19%Z ->
 exec_stmt ge e m(entry_clamp_statement id axis shift)E0 mf Out_normal ->
 observed_certificate ge(arithmetic_observation ge Source.f_guidance_pid_h_run)
 (State f(entry_clamp_statement id axis shift)k e m)(State f Sskip k e mf).
Proof.
 intros ge f e k m mf id axis shift SHIFT EXEC.
 unfold entry_clamp_statement in EXEC|-*.
 eapply conditional_assignment_core_observed_from_normal;try reflexivity.
 - exact(entry_clamp_tree ge e m id axis shift SHIFT).
 - exact EXEC.
Qed.
Theorem entry_clamp_pair_core_observed_from_normal:forall ge f e k m mf id shift,
 shift=8%Z \/shift=19%Z ->
 exec_stmt ge e m(entry_clamp_pair id shift)E0 mf Out_normal ->
 observed_certificate ge(arithmetic_observation ge Source.f_guidance_pid_h_run)
 (State f(entry_clamp_pair id shift)k e m)(State f Sskip k e mf).
Proof.
 intros ge f e k m mf id shift SHIFT EXEC.
 unfold entry_clamp_pair in EXEC|-*.
 destruct(sequence_normal_inv ge e _ _ _ _ EXEC)as[mid[X Y]].
 eapply observed_sequence;[exact I|exact I| |].
 - eapply entry_clamp_core_observed_from_normal;eassumption.
 - eapply entry_clamp_core_observed_from_normal;eassumption.
Qed.
Print Assumptions entry_clamp_pair_core_observed_from_normal.
