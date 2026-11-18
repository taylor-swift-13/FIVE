From Stdlib Require Import List.
From compcert Require Import Integers Floats AST Values Memory Ctypes Csyntax Csem Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceCbmcAdapters Require Import CanonicalCalls CanonicalInputWitness GuardedEntryFlowSpeed GuardedEntryFlowAccel.
Import ListNotations.
Definition SpeedReferenceInputs:Prop:=forall s taken,CanonicalControls s ->
 saturation_branch fixed_maximum(reference_raw s(speed_command taken))=taken /\
 (taken=true->norm2(reference_raw s(speed_command taken))=GuardTrace.canonical_sat_norm).
Theorem speed_reference_inputs:SpeedReferenceInputs.
Proof. intros s taken CONTROL;rewrite canonical_reference_raw by exact CONTROL;apply canonical_norm_and_branch. Qed.
Definition AccelReferenceInputs:Prop:=forall taken,
 saturation_branch fixed_maximum(accel_command taken)=taken /\
 (taken=true->norm2(accel_command taken)=GuardTrace.canonical_sat_norm).
Theorem accel_reference_inputs:AccelReferenceInputs.
Proof. exact canonical_norm_and_branch. Qed.
Lemma canonical_speed_raw_for:forall s taken,CanonicalControls s ->
 GuardedEntryFlowSpeed.raw_for_speed s(speed_command taken)=accel_command taken.
Proof.
 intros s taken CONTROL;destruct(canonical_increments s CONTROL)as[X Y].
 unfold GuardedEntryFlowSpeed.raw_for_speed,integrate;rewrite X,Y.
 apply canonical_raw_after_integration;exact CONTROL.
Qed.
Definition SpeedEveryHelperCall:Prop:=forall taken s m bg src o,
 CanonicalControls s ->speed_initial s(speed_command taken)m bg src o ->
 forall t args k mr,
 star Csem.step FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t
 (Callstate(Internal FiveGhSpeed.Source.f_five_sqrtf)args k mr) ->
 taken=true /\args=[Vsingle GuardTrace.canonical_sat_norm].
Theorem speed_every_helper_call:SpeedEveryHelperCall.
Proof.
 intros taken s m bg src o CONTROL INITIAL t args k mr PATH.
 pose proof(GuardedEntryFlowSpeed.speed_all_helper_calls s(speed_command taken)m bg src o INITIAL t args k mr PATH)as[BR ARG].
 rewrite(canonical_speed_raw_for s taken CONTROL)in BR,ARG.
 rewrite(proj1(canonical_norm_and_branch taken))in BR.
 split;[exact BR|]. rewrite(proj2(canonical_norm_and_branch taken)BR)in ARG;exact ARG.
Qed.
Definition AccelEveryHelperCall:Prop:=forall taken s m bg src o,
 CanonicalControls s ->accel_initial s(accel_command taken)m bg src o ->
 forall t args k mr,
 star Csem.step FiveGhAccel.Execution.ge(FiveGhAccel.Execution.entry[Vptr src o]m)t
 (Callstate(Internal FiveGhAccel.Source.f_five_sqrtf)args k mr) ->
 taken=true /\args=[Vsingle GuardTrace.canonical_sat_norm].
Theorem accel_every_helper_call:AccelEveryHelperCall.
Proof.
 intros taken s m bg src o CONTROL INITIAL t args k mr PATH.
 pose proof(GuardedEntryFlowAccel.accel_all_helper_calls s(accel_command taken)m bg src o INITIAL t args k mr PATH)as[BR ARG].
 change(saturation_branch fixed_maximum(accel_command taken)=true)in BR.
 change(args=[Vsingle(norm2(accel_command taken))])in ARG.
 rewrite(proj1(canonical_norm_and_branch taken))in BR.
 split;[exact BR|]. rewrite(proj2(canonical_norm_and_branch taken)BR)in ARG;exact ARG.
Qed.
Definition SpeedCallScope:Prop:=CanonicalInputsExist /\SpeedReferenceInputs /\
 (forall taken,CanonicalSpeedReady taken) /\SpeedEveryHelperCall.
Definition AccelCallScope:Prop:=CanonicalInputsExist /\AccelReferenceInputs /\
 (forall taken,CanonicalAccelReady taken) /\AccelEveryHelperCall.
Theorem speed_call_scope:SpeedCallScope.
Proof. split;[exact canonical_inputs_exist|]. split;[exact speed_reference_inputs|]. split;[exact canonical_speed_ready|exact speed_every_helper_call]. Qed.
Theorem accel_call_scope:AccelCallScope.
Proof. split;[exact canonical_inputs_exist|]. split;[exact accel_reference_inputs|]. split;[exact canonical_accel_ready|exact accel_every_helper_call]. Qed.
Print Assumptions speed_call_scope.
Print Assumptions accel_call_scope.
