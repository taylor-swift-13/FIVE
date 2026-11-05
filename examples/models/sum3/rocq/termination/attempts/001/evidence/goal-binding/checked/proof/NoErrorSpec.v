From Stdlib Require Import List.
From compcert Require Import Values Memory Floats.
From FiveSum3.proof Require Import Obligations.
Import ListNotations.

Definition typed_arguments (args : list val) (_ : mem) : Prop :=
  exists a b c : float32, args = [Vsingle a; Vsingle b; Vsingle c].

Definition Goal : Prop := FiveSum3.proof.Obligations.no_error_goal typed_arguments.
