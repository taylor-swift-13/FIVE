From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats AST.
Local Open Scope Z_scope.
(** Exact source-order denotation of frozen five_sqrtf.c.  No claim here equates
    the algorithm to an ideal IEEE square-root specification. *)
Definition inf_encoding : int := Int.repr 2139095040.
Definition search_step (target : float) (bounds : int*int) : int*int :=
 let '(lo,hi):=bounds in
 let mid:=Int.add lo (Int.shru (Int.sub hi lo) (Int.repr 1)) in
 let candidate:=Float.of_single (Float32.of_bits mid) in
 if Float.cmp Cle (Float.mul candidate candidate) target
 then (mid,hi) else (lo,mid).
Fixpoint search_steps (n : nat) (target : float) (bounds : int*int) : int*int :=
 match n with O=>bounds|S k=>search_steps k target (search_step target bounds) end.
Definition software_sqrt (x : float32) : float32 :=
 let bits:=Float32.to_bits x in
 let magnitude:=Int.and bits (Int.repr 2147483647) in
 if Int.cmpu Cgt magnitude inf_encoding then
   Float32.of_bits (Int.or bits (Int.repr 4194304))
 else if Int.eq magnitude Int.zero then x
 else if negb (Int.eq (Int.and bits (Int.repr 2147483648)) Int.zero) then
   Float32.of_bits (Int.repr 2143289344)
 else if Int.eq magnitude inf_encoding then x
 else
 let target:=Float.of_single x in
 let '(lo,hi):=search_steps 31 target (Int.zero,inf_encoding) in
 let lower:=Float.of_single (Float32.of_bits lo) in
 let upper:=Float.of_single (Float32.of_bits hi) in
 let midpoint:=Float.mul (Float.add lower upper)
  (Float.of_bits (Int64.repr 4602678819172646912)) in
 let midpoint_square:=Float.mul midpoint midpoint in
 Float32.of_bits
 (if Float.cmp Clt target midpoint_square then lo
  else if Float.cmp Cgt target midpoint_square then hi
  else if Int.eq (Int.and lo (Int.repr 1)) Int.zero then lo else hi).
Lemma software_sqrt_positive_zero : software_sqrt Float32.zero=Float32.zero.
Proof. reflexivity. Qed.
Lemma software_sqrt_negative_zero : software_sqrt (Float32.neg Float32.zero)=Float32.neg Float32.zero.
Proof. reflexivity. Qed.
Lemma search_steps_successor : forall n t bounds,
 search_steps (S n) t bounds=search_steps n t (search_step t bounds).
Proof. reflexivity. Qed.
Print Assumptions software_sqrt_positive_zero.
Print Assumptions search_steps_successor.
