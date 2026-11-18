From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats AST.
Local Open Scope Z_scope.
(** Exact source-order denotation of frozen integer-restoring five_sqrtf.c.
    This algorithm denotation does not assume an IEEE accuracy theorem. *)
Definition inf_encoding : int := Int.repr 2139095040.
Definition normalize_step (me:int*int) : int*int :=
 let '(mantissa,exponent):=me in
 if Int.cmpu Clt mantissa (Int.repr 8388608)
 then (Int.shl mantissa (Int.repr 1),Int.sub exponent (Int.repr 1))
 else (mantissa,exponent).
Fixpoint normalize_steps (n:nat) (me:int*int) : int*int :=
 match n with O=>me|S k=>normalize_steps k (normalize_step me)end.
Definition restore_step (radicand:int64) (shift:Z) (rr:int*int):int*int :=
 let '(remainder,root):=rr in
 let pair:=Int.repr(Int64.unsigned(Int64.and
 (Int64.shru radicand(Int64.repr shift))(Int64.repr 3)))in
 let remainder:=Int.or(Int.shl remainder(Int.repr 2))pair in
 let trial:=Int.or(Int.shl root(Int.repr 2))(Int.repr 1)in
 if Int.cmpu Cge remainder trial
 then (Int.sub remainder trial,Int.or(Int.shl root(Int.repr 1))(Int.repr 1))
 else (remainder,Int.shl root(Int.repr 1)).
Fixpoint restore_steps (n:nat) (radicand:int64) (rr:int*int):int*int :=
 match n with O=>rr|S k=>restore_steps k radicand(restore_step radicand(2*Z.of_nat k)rr)end.
Definition software_sqrt (x:float32):float32 :=
 let bits:=Float32.to_bits x in
 let magnitude:=Int.and bits(Int.repr 2147483647)in
 if Int.cmpu Cgt magnitude inf_encoding then
 Float32.of_bits(Int.or bits(Int.repr 4194304))
 else if Int.eq magnitude Int.zero then x
 else if negb(Int.eq(Int.and bits(Int.repr 2147483648))Int.zero)then
 Float32.of_bits(Int.repr 2143289344)
 else if Int.eq magnitude inf_encoding then x else
 let exponent_bits:=Int.shru magnitude(Int.repr 23)in
 let mantissa:=Int.and magnitude(Int.repr 8388607)in
 let '(mantissa,exponent):=
 if Int.eq exponent_bits Int.zero
 then normalize_steps 23(mantissa,Int.repr(-126))
 else (Int.or mantissa(Int.repr 8388608),Int.sub exponent_bits(Int.repr 127))in
 let '(mantissa,exponent):=
 if negb(Int.eq(Int.mods exponent(Int.repr 2))Int.zero)
 then (Int.shl mantissa(Int.repr 1),Int.sub exponent(Int.repr 1))else(mantissa,exponent)in
 let radicand:=Int64.shl(Int64.repr(Int.unsigned mantissa))(Int64.repr 23)in
 let '(remainder,root):=restore_steps 24 radicand(Int.zero,Int.zero)in
 let root:=if Int.cmpu Cgt remainder root then Int.add root(Int.repr 1)else root in
 let result_exponent:=Int.add(Int.divs exponent(Int.repr 2))(Int.repr 127)in
 let '(root,result_exponent):=
 if Int.eq root(Int.repr 16777216)
 then(Int.shru root(Int.repr 1),Int.add result_exponent(Int.repr 1))else(root,result_exponent)in
 Float32.of_bits(Int.or(Int.shl result_exponent(Int.repr 23))(Int.and root(Int.repr 8388607))).
Lemma software_sqrt_positive_zero:software_sqrt Float32.zero=Float32.zero.
Proof. reflexivity. Qed.
Lemma software_sqrt_negative_zero:software_sqrt(Float32.neg Float32.zero)=Float32.neg Float32.zero.
Proof. reflexivity. Qed.
Lemma normalize_steps_successor:forall n me,
 normalize_steps(S n)me=normalize_steps n(normalize_step me).
Proof. reflexivity. Qed.
Lemma restore_steps_successor:forall n rad rr,
 restore_steps(S n)rad rr=restore_steps n rad(restore_step rad(2*Z.of_nat n)rr).
Proof. reflexivity. Qed.
Print Assumptions software_sqrt_positive_zero.
Print Assumptions restore_steps_successor.
