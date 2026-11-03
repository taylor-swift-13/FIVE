From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats Archi.
From Comparison Require Import FloatLib.
Open Scope Z_scope.
Local Transparent Archi.choose_nan_32 Archi.default_nan_32.

Definition word (n:Z) := Float32.of_bits (Int.repr n).
Definition bits (f:float32) := Int.unsigned (Float32.to_bits f).
Definition cc_sum3 a b c := Float32.add (Float32.add a b) c.
Definition qcp_sum3 a b c := fp32_add (fp32_add a b) c.

Example compcert_finite : bits (cc_sum3 (word 1266679808)
  (word 1065353216) (word 3414163456)) = 0.
Proof. vm_compute. reflexivity. Qed.
Example qcp_finite : bits (qcp_sum3 (word 1266679808)
  (word 1065353216) (word 3414163456)) = 0.
Proof. vm_compute. reflexivity. Qed.
Example compcert_nan : bits (cc_sum3 (word 2143289410)
  (word 0) (word 0)) = 2143289410.
Proof. vm_compute. reflexivity. Qed.
Example qcp_nan : bits (qcp_sum3 (word 2143289410)
  (word 0) (word 0)) = 2139095041.
Proof. vm_compute. reflexivity. Qed.

Eval vm_compute in bits (cc_sum3 (word 1266679808) (word 1065353216) (word 3414163456)).
Eval vm_compute in bits (qcp_sum3 (word 1266679808) (word 1065353216) (word 3414163456)).
Eval vm_compute in bits (cc_sum3 (word 2143289410) (word 0) (word 0)).
Eval vm_compute in bits (qcp_sum3 (word 2143289410) (word 0) (word 0)).
Print Assumptions compcert_finite.
Print Assumptions qcp_finite.
Print Assumptions compcert_nan.
Print Assumptions qcp_nan.
