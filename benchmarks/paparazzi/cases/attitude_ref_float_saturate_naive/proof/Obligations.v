(* Generated targets only: precondition pending; both proofs pending.
   All possible original CompCert Csem steps are covered, without a fuel bound. *)
From Stdlib Require Import List.
From compcert Require Import Values Memory Ctypes Csem.
From FiveShared.verification Require Import Obligations.
From Paparazzi.attitude_saturation Require Import Source.
From Paparazzi.attitude_saturation.entries.attitude_ref_float_saturate_naive.proof Require Import Precondition.

Definition goal_ge : Csem.genv := Csem.globalenv Paparazzi.attitude_saturation.Source.prog.
Definition goal_entry (args : list val) (m : mem) : Csem.state :=
  Callstate (Ctypes.Internal Paparazzi.attitude_saturation.Source.f_attitude_ref_float_saturate_naive) args Kstop m.

(* [pre] is a bound parameter, not a global axiom or a chosen input domain. *)
Definition no_error_goal (pre : Paparazzi.attitude_saturation.entries.attitude_ref_float_saturate_naive.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.no_error goal_ge (goal_entry args m).

Definition termination_goal (pre : Paparazzi.attitude_saturation.entries.attitude_ref_float_saturate_naive.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.terminates goal_ge (goal_entry args m).
