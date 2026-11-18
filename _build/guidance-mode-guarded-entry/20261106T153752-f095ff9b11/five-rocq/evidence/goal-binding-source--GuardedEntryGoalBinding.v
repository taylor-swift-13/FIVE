From Stdlib Require Import List ZArith.
From compcert Require Import Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry BigstepSupport.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From FiveGuidanceCbmcAdapters Require Import CallScope GuardedEntryFlowSpeed GuardedEntryFlowAccel.
Import ListNotations.
Local Open Scope Z_scope.
Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Import P B.
Import GuardedEntryFlowSpeed.
Definition guarded_speed_entry_certificate_target:sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->
 exists sf mf P,
 speed_update fixed_maximum s sp=Some sf /\
 certificate ge P(Returnstate Vundef Kstop mf) /\
 P(FiveGhSpeed.Execution.entry[Vptr src o]m) /\
 repr sf mf bg /\writable mf bg /\
 Mem.loadbytes mf bg 0 4=Some(encode_val Mfloat32(Vsingle(accel_x sf))) /\
 Mem.loadbytes mf bg 4 4=Some(encode_val Mfloat32(Vsingle(accel_y sf))) /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(pos_x sf))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(pos_y sf))) /\
 (forall reached,P reached->helper_call_ok S.f_five_sqrtf(norm2(raw_for_speed s sp))
 (saturation_branch fixed_maximum(raw_for_speed s sp))reached)
 :=GuardedEntryFlowSpeed.guarded_speed_entry_certificate.
Print Assumptions guarded_speed_entry_certificate_target.
Definition speed_all_helper_calls_target:forall s sp m bg src o,
 speed_initial s sp m bg src o->forall t args kc mc,
 star Csem.step ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t(Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch fixed_maximum(raw_for_speed s sp)=true /\args=[Vsingle(norm2(raw_for_speed s sp))]
 :=GuardedEntryFlowSpeed.speed_all_helper_calls.
Print Assumptions speed_all_helper_calls_target.
End Speed.
Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Import P B.
Import GuardedEntryFlowAccel.
Definition guarded_accel_entry_certificate_target:sqrt_call_contract ->forall s sp m bg src o,
 accel_initial s sp m bg src o ->
 exists sf mf P,
 accel_update fixed_maximum s sp=Some sf /\
 certificate ge P(Returnstate Vundef Kstop mf) /\
 P(FiveGhAccel.Execution.entry[Vptr src o]m) /\
 repr sf mf bg /\writable mf bg /\
 Mem.loadbytes mf bg 0 4=Some(encode_val Mfloat32(Vsingle(accel_x sf))) /\
 Mem.loadbytes mf bg 4 4=Some(encode_val Mfloat32(Vsingle(accel_y sf))) /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(pos_x sf))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(pos_y sf))) /\
 (forall reached,P reached->helper_call_ok S.f_five_sqrtf(norm2(raw_for_accel s sp))
 (saturation_branch fixed_maximum(raw_for_accel s sp))reached)
 :=GuardedEntryFlowAccel.guarded_accel_entry_certificate.
Print Assumptions guarded_accel_entry_certificate_target.
Definition accel_all_helper_calls_target:forall s sp m bg src o,
 accel_initial s sp m bg src o->forall t args kc mc,
 star Csem.step ge(FiveGhAccel.Execution.entry[Vptr src o]m)t(Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch fixed_maximum(raw_for_accel s sp)=true /\args=[Vsingle(norm2(raw_for_accel s sp))]
 :=GuardedEntryFlowAccel.accel_all_helper_calls.
Print Assumptions accel_all_helper_calls_target.
End Accel.
