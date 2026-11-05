From Stdlib Require Import List.
From compcert Require Import Values Memory Floats Csem Smallstep.
Require FiveSum2.Execution FiveSum3.Execution.
Import ListNotations.

Definition Returns (ge : Csem.genv) (entry : list val -> mem -> Csem.state)
    (args : list val) (before : mem) (value : val) (after : mem) : Prop :=
  exists t, star Csem.step ge (entry args before) t
    (Csem.Returnstate value Csem.Kstop after).

Definition Sum2EqualsSum3 : Prop :=
  forall (a b c ab lhs rhs : float32) m2 m2' m2'' m3 m3',
    Returns FiveSum2.Execution.ge FiveSum2.Execution.entry
      [Vsingle a; Vsingle b] m2 (Vsingle ab) m2' ->
    Returns FiveSum2.Execution.ge FiveSum2.Execution.entry
      [Vsingle ab; Vsingle c] m2' (Vsingle lhs) m2'' ->
    Returns FiveSum3.Execution.ge FiveSum3.Execution.entry
      [Vsingle a; Vsingle b; Vsingle c] m3 (Vsingle rhs) m3' ->
    Float32.to_bits lhs = Float32.to_bits rhs.
