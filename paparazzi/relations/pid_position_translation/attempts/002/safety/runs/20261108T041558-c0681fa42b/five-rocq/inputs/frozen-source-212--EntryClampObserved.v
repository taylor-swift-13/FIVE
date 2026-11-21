From Stdlib Require Import List Bool ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Floats Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PhaseComposition.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationAttempt002 Require Import EntryPrefix ClampSemantics ClampCombination.
From PidPositionSafety Require Import ConditionalObservedStrategy SubtractionObservation SubtractionWiring.
From CoreCBMC Require Import NumericBounds ArithmeticTree.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Lemma universal_binary_condition:forall ge e m op a b,
 (forall va vb,binary_safe op(typeof a)(typeof b)va vb) ->
 binary_condition ge e m op a b.
Proof.
 intros ge e m op a b SAFE;unfold binary_condition.
 destruct(pure_rval ge e m a)as[va|];[destruct(pure_rval ge e m b)as[vb|]|];try exact I;apply SAFE.
Qed.
Lemma universal_unary_condition:forall ge e m op a,
 (forall va,unary_safe op(typeof a)va) ->unary_condition ge e m op a.
Proof.
 intros ge e m op a SAFE;unfold unary_condition.
 destruct(pure_rval ge e m a)as[va|];[apply SAFE|exact I].
Qed.
Lemma floating_clamp_tree:forall ge e m r b,
 typeof b=tdouble ->arithmetic_tree ge e m r ->arithmetic_tree ge e m b ->
 arithmetic_tree ge e m
 (Econdition(Ebinop Olt r(Eunop Oneg b tdouble)tint)
 (Eunop Oneg b tdouble)
 (Econdition(Ebinop Ogt r b tint)b r tdouble)tdouble).
Proof.
 intros ge e m r b BT RT BTR;cbn[arithmetic_tree];repeat split;try assumption.
 all:try solve[apply universal_binary_condition;intros va vb;destruct va,vb;exact I].
 all:apply universal_unary_condition;intros va;destruct va;cbn[unary_safe];rewrite ?BT;exact I.
Qed.
Lemma bound_8_tree:forall ge e m,arithmetic_tree ge e m(source_bound 8).
Proof.
 intros;unfold source_bound;cbn[arithmetic_tree];split;[exact I|];split.
 - cbn[arithmetic_tree];split;[exact I|];split;[exact I|].
   vm_compute;intuition discriminate.
 - apply universal_binary_condition;intros va vb;destruct va,vb;exact I.
Qed.
Lemma bound_19_tree:forall ge e m,arithmetic_tree ge e m(source_bound 19).
Proof.
 intros;unfold source_bound;cbn[arithmetic_tree];split;[exact I|];split.
 - cbn[arithmetic_tree];split;[exact I|];split;[exact I|].
   vm_compute;intuition discriminate.
 - apply universal_binary_condition;intros va vb;destruct va,vb;exact I.
Qed.
Definition entry_clamp_statement(id axis:ident)(shift:Z):statement:=
 Sdo(Eassign(pid_axis_lvalue id axis)
 (source_clamp(Evalof(pid_axis_lvalue id axis)tint)shift)tint).
Definition entry_clamp_pair(id:ident)(shift:Z):statement:=
 Ssequence(entry_clamp_statement id S._x shift)(entry_clamp_statement id S._y shift).
Lemma entry_clamp_tree:forall ge e m id axis shift,
 shift=8\/shift=19 ->
 match entry_clamp_statement id axis shift with
 | Sdo a=>arithmetic_tree ge e m a|_=>False end.
Proof.
 intros ge e m id axis shift SHIFT;unfold entry_clamp_statement;cbn[arithmetic_tree].
 split;[exact I|];unfold source_clamp;apply floating_clamp_tree.
 - reflexivity.
 - exact I.
 - destruct SHIFT as[EQ|EQ];subst shift;[apply bound_8_tree|apply bound_19_tree].
Qed.
Theorem entry_clamp_observed_from_normal:forall ge f e k m mf id axis shift,
 shift=8\/shift=19 ->
 exec_stmt ge e m(entry_clamp_statement id axis shift)E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf)/\
 P(State f(entry_clamp_statement id axis shift)k e m)/\
 (forall s,P s->subtraction_observation ge f s).
Proof.
 intros ge f e k m mf id axis shift SHIFT EXEC.
 unfold entry_clamp_statement in EXEC|-*.
 eapply conditional_assignment_observed_from_normal;try reflexivity.
 - exact(entry_clamp_tree ge e m id axis shift SHIFT).
 - exact EXEC.
Qed.
Theorem entry_clamp_pair_observed_from_normal:forall ge f e k m mf id shift,
 shift=8\/shift=19 ->
 exec_stmt ge e m(entry_clamp_pair id shift)E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf)/\
 P(State f(entry_clamp_pair id shift)k e m)/\
 (forall s,P s->subtraction_observation ge f s).
Proof.
 intros ge f e k m mf id shift SHIFT EXEC.
 unfold entry_clamp_pair in EXEC|-*.
 destruct(sequence_normal_inv ge e _ _ _ _ EXEC)as[mid[X Y]].
 destruct(entry_clamp_observed_from_normal ge f e(Kseq(entry_clamp_statement id S._y shift)k)m mid id S._x shift SHIFT X)
 as[P[CP[IP OP]]].
 destruct(entry_clamp_observed_from_normal ge f e k mid mf id S._y shift SHIFT Y)
 as[Q[CQ[IQ OQ]]].
 eapply sequence_subtraction_certificate;[exact CP|exact IP|exact CQ|exact IQ|exact OP|exact OQ].
Qed.
Print Assumptions entry_clamp_pair_observed_from_normal.
