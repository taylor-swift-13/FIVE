From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats.

(* Pure binary32 calculation corresponding to the concrete CBMC inputs.
   A theorem connecting this value to a Csem return is a separate obligation. *)
Definition sum3_concrete_model : float32 :=
  Float32.add
    (Float32.add (Float32.of_bits (Int.repr 1266679808))
                 (Float32.of_bits (Int.repr 1065353216)))
    (Float32.of_bits (Int.repr 3414163456)).

Theorem sum3_concrete_bits :
  Float32.to_bits sum3_concrete_model = Int.zero.
Proof. vm_compute. reflexivity. Qed.

Print Assumptions sum3_concrete_bits.
