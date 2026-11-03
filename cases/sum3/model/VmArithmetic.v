From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats.
Local Open Scope Z_scope.
(* Arithmetic-only check. This does not evaluate Cexec or parameter memory. *)
Definition arithmetic_only := Int.unsigned(Float32.to_bits
 (Float32.add(Float32.add(Float32.of_bits(Int.repr 1266679808))
 (Float32.of_bits(Int.repr 1065353216)))
 (Float32.of_bits(Int.repr 3414163456)))).
Eval vm_compute in arithmetic_only.
Example arithmetic_only_bits : arithmetic_only=0.
Proof. vm_compute. reflexivity. Qed.
Print Assumptions arithmetic_only_bits.
