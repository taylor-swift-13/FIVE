From Stdlib Require Import List.
From compcert Require Import Values Memory Floats.
From FiveSum2.proof Require Import Obligations.
Import ListNotations.

Definition typed_arguments (args : list val) (_ : mem) : Prop :=
  exists a b : float32, args = [Vsingle a; Vsingle b].

Definition Goal : Prop := FiveSum2.proof.Obligations.no_error_goal typed_arguments.
