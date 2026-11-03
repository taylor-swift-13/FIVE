From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats Values Memory Ctypes Cop Ctypesdefs Csyntax.
Local Open Scope Z_scope.

Theorem binary32_add_total : forall (ce:composite_env) a b m,
 sem_binary_operation ce Oadd (Vsingle a)tfloat(Vsingle b)tfloat m =
 Some(Vsingle(Float32.add a b)).
Proof. reflexivity. Qed.
Theorem binary32_sub_total : forall (ce:composite_env) a b m,
 sem_binary_operation ce Osub (Vsingle a)tfloat(Vsingle b)tfloat m =
 Some(Vsingle(Float32.sub a b)).
Proof. reflexivity. Qed.
Theorem binary32_mul_total : forall (ce:composite_env) a b m,
 sem_binary_operation ce Omul (Vsingle a)tfloat(Vsingle b)tfloat m =
 Some(Vsingle(Float32.mul a b)).
Proof. reflexivity. Qed.
Theorem binary32_div_total : forall (ce:composite_env) a b m,
 sem_binary_operation ce Odiv (Vsingle a)tfloat(Vsingle b)tfloat m =
 Some(Vsingle(Float32.div a b)).
Proof. reflexivity. Qed.
Theorem binary32_div_zero_is_not_blocked : forall (ce:composite_env) a m,
 exists v,sem_binary_operation ce Odiv(Vsingle a)tfloat(Vsingle Float32.zero)tfloat m=Some v.
Proof. intros;rewrite binary32_div_total;eauto. Qed.
Print Assumptions binary32_div_total.
