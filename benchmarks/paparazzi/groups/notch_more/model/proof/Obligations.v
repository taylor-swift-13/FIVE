(* Generated targets only: precondition pending; both proofs pending.
   All possible original CompCert Csem steps are covered, without a fuel bound. *)
From Stdlib Require Import List.
From compcert Require Import Values Memory Ctypes Csem.
From FiveShared.verification Require Import Obligations.
From Paparazzi.notch_more Require Import Source.
From Paparazzi.notch_more.proof Require Import Precondition.

Definition goal_ge : Csem.genv := Csem.globalenv Paparazzi.notch_more.Source.prog.
Definition goal_entry (args : list val) (m : mem) : Csem.state :=
  Callstate (Ctypes.Internal Paparazzi.notch_more.Source.f_notch_filter_set_sampling_frequency) args Kstop m.

(* [pre] is a bound parameter, not a global axiom or a chosen input domain. *)
Definition no_error_goal (pre : Paparazzi.notch_more.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.no_error goal_ge (goal_entry args m).

Definition termination_goal (pre : Paparazzi.notch_more.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.terminates goal_ge (goal_entry args m).
