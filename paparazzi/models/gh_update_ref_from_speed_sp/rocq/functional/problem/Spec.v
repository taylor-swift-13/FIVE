From Stdlib Require Import List.
From compcert Require Import Values Memory Csem.
From FiveShared.verification Require Import Obligations.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
Require FiveGhSpeed.Execution.
Import ListNotations.
Definition NormalCompletion:Prop:=forall s sp m bg src o,
 speed_initial s sp m bg src o ->exists sf mf,
 speed_update fixed_maximum s sp=Some sf /\speed_call m src o mf /\repr sf mf bg.
Definition AllReturns:Prop:=forall s sp m bg src o,
 speed_initial s sp m bg src o ->forall mf,speed_call m src o mf ->exists sf,
 speed_update fixed_maximum s sp=Some sf /\repr sf mf bg.
