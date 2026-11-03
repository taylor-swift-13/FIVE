From Stdlib Require Import List.
From compcert Require Import Floats Values Memory.
Import ListNotations.

(** Only the C calling convention: exactly three binary32 values.
    All float32 values (including NaNs and infinities) and every initial
    CompCert memory are allowed.  No numeric-domain restriction is imposed. *)
Definition typed_inputs (args : list val) (_ : mem) : Prop :=
  exists a b c : float32, args = [Vsingle a; Vsingle b; Vsingle c].
