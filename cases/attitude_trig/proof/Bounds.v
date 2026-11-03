From Stdlib Require Import ZArith Lia.
From compcert Require Import Integers.
Local Open Scope Z_scope.

Theorem copy4_index_bounds : forall i,0<=i<4 -> 0<=i /\ i+1<=4.
Proof. intros;lia. Qed.
Theorem product_index_bounds : forall i,0<=i<8 -> 0<=i<9.
Proof. intros;lia. Qed.
Theorem product_bit_access_bounds : forall bit,
 0<=bit<288 -> 0<=bit/32<9 /\ 0<=bit mod 32<32.
Proof.
 intros bit B;split.
 - split;[apply Z.div_pos;lia|apply Z.div_lt_upper_bound;lia].
 - apply Z.mod_pos_bound;lia.
Qed.
Theorem reduction_shift_bounds : forall exponent,
 126<=exponent<=254 ->
 152<=256-(exponent-150)<=280 /\
 151<=256-(exponent-150)-1<=279 /\
 153<=256-(exponent-150)+1<=281.
Proof. intros;lia. Qed.
Theorem fractional_bit_index_bounds : forall shift i,
 152<=shift<=280 -> 0<=i<64 -> 88<=shift-64+i<=279.
Proof. intros;lia. Qed.
Theorem signed_loop_arithmetic_representable : forall i,
 0<=i<64 -> Int.min_signed<=i+1<=Int.max_signed.
Proof. intros;change(-2147483648<=i+1<=2147483647);lia. Qed.
Print Assumptions product_bit_access_bounds.
Print Assumptions fractional_bit_index_bounds.
