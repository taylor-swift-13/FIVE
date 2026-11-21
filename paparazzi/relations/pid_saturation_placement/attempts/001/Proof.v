From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import CoreInputs NormalReturn MainGoals.
From PidMeasurementProblem Require Import Spec.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic SemanticBridge.
From PidSaturationAttempt001 Require Import SaturationArithmetic Witness.
From PidSaturationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.

Lemma original_active_tags:forall m gh ret mf,
 InputGood m gh ret ->NormalCall gh ret true m mf ->
 load_path Mint32 mf ret sp_type[P._type]=Some(Vint(Int.repr 2)) /\
 load_path Mint32 mf ret sp_type[P._format]=Some(Vint Int.zero).
Proof.
 intros m gh ret mf GOOD CALL.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 destruct(original_entry_normal_result m gh ret true D GOOD)
 as(out&rx&ry&px&py&sx&sy&vx&vy&sb&NC&STATE&RX&RY&PX&PY&SX&SY&VX&VY&ACTIVE&REST).
 assert(EQ:mf=out)by(eapply original_entry_all_normal_memories_unique;[exact GOOD|exact CALL|exact NC]);subst mf.
 destruct ACTIVE as(T&F&REST0);split;[exact T|exact F].
Qed.

Theorem proved_source_comparison:SourceComparisonGoal.
Proof.
 intros axis gh ret g m x AX[GOOD READ].
 split;[exact(original_entry_normal_return m gh ret true GOOD)|].
 intros mf CALL.
 pose proof(read_axis_bounds axis gh ret m g x AX GOOD READ)as B.
 pose proof(normal_axis_observation axis gh ret m mf g x AX GOOD READ CALL)as[IL[CL RL]].
 pose proof(axis_machine_exact _ _ _ _ _ _ _ _ _ _ B)as[MI MC].
 fold(mi g x)in MI;fold(mc g x)in MC.
 change(Int.signed(mi g x)=updated_integral g x)in MI.
 change(Int.signed(mc g x)=staged_command(total g x)(integral_command g x))in MC.
 pose proof(original_active_tags m gh ret mf GOOD CALL)as[T F].
 exists(Int.signed(mc g x));split.
 - exists(mi g x),(mc g x);repeat split;try assumption;reflexivity.
 - assert(IB:-1429<=integral_command g x<=1429).
   { unfold integral_command,updated_integral;apply integral_command_range. }
   unfold Comparison;rewrite MC;unfold unified.
   fold(unified_command(total g x)(integral_command g x)).
   exact(conj IB(saturation_placement(total g x)(integral_command g x)IB)).
Qed.

Lemma actual_witness:forall old actual reference_code,
 -100000000<=old<=100000000 ->
 updated_integral witness_gains(witness_sample old)=old ->
 zclamp 1429(total witness_gains(witness_sample old))+
 integral_command witness_gains(witness_sample old)=actual ->
 unified witness_gains(witness_sample old)=reference_code ->
 exists gh ret m mf,WitnessInput gh ret m old /\NormalCall gh ret true m mf /\
 AxisObservation P._x ret mf old actual /\
 unified witness_gains(witness_sample old)=reference_code.
Proof.
 intros old actual reference_code RANGE INT CMD UNI.
 destruct(witness_input_exists old RANGE)as(gh&ret&m&INPUT).
 destruct(proved_source_comparison P._x gh ret witness_gains m(witness_sample old)
 ltac:(cbn;auto)INPUT)as[RETURN RESULT].
 destruct RETURN as[mf CALL].
 destruct(RESULT mf CALL)as[ca[OBS COMP]].
 destruct COMP as[IB[FORM REST]].
 rewrite CMD in FORM;subst ca;rewrite INT in OBS.
 exists gh,ret,m,mf;split;[exact INPUT|];split;[exact CALL|];split;assumption.
Qed.

Theorem proved_actual_counterexample:ActualCounterexampleGoal.
Proof.
 split.
 - apply(actual_witness 0 1429 2000);[lia|vm_compute;reflexivity|vm_compute;reflexivity|vm_compute;reflexivity].
 - apply(actual_witness(-65536000)429 1000);[lia|vm_compute;reflexivity|vm_compute;reflexivity|vm_compute;reflexivity].
Qed.

Lemma observed_command_unique:forall axis ret m i j a b,
 AxisObservation axis ret m i a ->AxisObservation axis ret m j b ->a=b.
Proof.
 intros axis ret m i j a b(ia&ca&TA&FA&IA&CA&RA&SIA&SCA)
 (ib&cb&TB&FB&IB&CB&RB&SIB&SCB).
 rewrite CA in CB;injection CB as EQ;subst cb;congruence.
Qed.

Theorem proved_unconditional_equivalence_refuted:UnconditionalEquivalenceRefutedGoal.
Proof.
 intros EQUIV.
 destruct(proj1 proved_actual_counterexample)as(gh&ret&m&mf&INPUT&CALL&OBS&UNI).
 pose proof(EQUIV P._x gh ret witness_gains m(witness_sample 0)mf
 ltac:(cbn;auto)INPUT CALL)as OTHER.
 rewrite UNI in OTHER.
 pose proof(observed_command_unique P._x ret mf 0(updated_integral witness_gains(witness_sample 0))
 1429 2000 OBS OTHER);lia.
Qed.

Print Assumptions proved_source_comparison.
Print Assumptions proved_actual_counterexample.
Print Assumptions proved_unconditional_equivalence_refuted.
