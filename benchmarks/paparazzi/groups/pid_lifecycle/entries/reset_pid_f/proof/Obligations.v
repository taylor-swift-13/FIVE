(* Generated targets only: precondition pending; both proofs pending.
   All possible original CompCert Csem steps are covered, without a fuel bound. *)
From Stdlib Require Import List.
From compcert Require Import Values Memory Ctypes Csem.
From FiveShared.verification Require Import Obligations.
From Paparazzi.pid_lifecycle Require Import Source.
From Paparazzi.pid_lifecycle.entries.reset_pid_f.proof Require Import Precondition.

Definition goal_ge : Csem.genv := Csem.globalenv Paparazzi.pid_lifecycle.Source.prog.
Definition goal_entry (args : list val) (m : mem) : Csem.state :=
  Callstate (Ctypes.Internal Paparazzi.pid_lifecycle.Source.f_reset_pid_f) args Kstop m.

(* [pre] is a bound parameter, not a global axiom or a chosen input domain. *)
Definition no_error_goal (pre : Paparazzi.pid_lifecycle.entries.reset_pid_f.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.no_error goal_ge (goal_entry args m).

Definition termination_goal (pre : Paparazzi.pid_lifecycle.entries.reset_pid_f.proof.Precondition.precondition_type) : Prop :=
  forall args m, pre args m ->
    FiveShared.verification.Obligations.terminates goal_ge (goal_entry args m).
