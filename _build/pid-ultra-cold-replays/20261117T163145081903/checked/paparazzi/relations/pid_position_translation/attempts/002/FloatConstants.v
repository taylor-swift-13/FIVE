From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats IEEE754_extra.
Open Scope Z_scope.
Local Transparent Float.of_int Float.of_bits.
Lemma source_sixteen_bits : Float.of_bits(Int64.repr 4625196817309499392)=Float.of_int(Int.repr 16).
Proof. rewrite <-(Float.of_to_bits(Float.of_int(Int.repr 16))). f_equal. Qed.

Lemma float_bits_ext : forall a b, Float.to_bits a=Float.to_bits b -> a=b.
Proof. intros a b H;rewrite <-(Float.of_to_bits a),<-(Float.of_to_bits b);rewrite H;reflexivity. Qed.
