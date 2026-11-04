(* Generated targets only: precondition pending; both proofs pending.
   All possible original CompCert Csem steps are covered, without a fuel bound. *)
From Stdlib Require Import List.
From compcert Require Import Values Memory Ctypes Csem.
From FiveShared.verification Require Import Obligations.
From Paparazzi.vision_undistortion Require Import Source.
From Paparazzi.vision_undistortion.entries.distorted_pixels_to_normalized_coords.proof Require Import Precondition.

Definition goal_ge : Csem.genv := Csem.globalenv Paparazzi.vision_undistortion.Source.prog.
Definition goal_entry (args : list val) (m : mem) : Csem.state :=
  Callstate (Ctypes.Internal Paparazzi.vision_undistortion.Source.f_distorted_pixels_to_normalized_coords) args Kstop m.

(* [pre] is a bound parameter, not a global axiom or a chosen input domain. *)
Definition no_error_goal (pre : Paparazzi.vision_undistortion.entries.distorted_pixels_to_normalized_coords.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.no_error goal_ge (goal_entry args m).

Definition termination_goal (pre : Paparazzi.vision_undistortion.entries.distorted_pixels_to_normalized_coords.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.terminates goal_ge (goal_entry args m).
