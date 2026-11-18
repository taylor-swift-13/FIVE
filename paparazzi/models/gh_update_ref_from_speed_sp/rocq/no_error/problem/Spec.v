From Stdlib Require Import List.
From compcert Require Import Values Memory Csem.
From FiveShared.verification Require Import Obligations.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
Require FiveGhSpeed.Execution.
Import ListNotations.
Definition Goal:Prop:=forall s sp m bg src o,
 speed_initial s sp m bg src o ->no_error FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr src o]m).
