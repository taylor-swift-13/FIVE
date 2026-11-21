From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers.
Import ListNotations.
Local Open Scope Z_scope.

(** Scratch fallback only: the frozen consumed InitState.v is unchanged. *)
Lemma nonnegative_short_cast_symbolic : forall z,
  0 <= z <= 16383 -> Int.sign_ext 16 (Int.repr z) = Int.repr z.
Proof.
  intros z RANGE.
  assert (ZERO : Int.zero_ext 15 (Int.repr z) = Int.repr z).
  { apply Int.unsigned_inj.
    rewrite Int.zero_ext_mod by (change (0 <= 15 < 32); lia).
    rewrite Int.unsigned_repr by (change (0 <= z <= 4294967295); lia).
    change (z mod 32768 = z).
    apply Z.mod_small; lia. }
  rewrite <- ZERO.
  apply Int.sign_zero_ext_widen; lia.
Qed.

Lemma nonnegative_short_cast_certificate :
  forallb (fun n => Int.eq
    (Int.sign_ext 16 (Int.repr (Z.of_nat n)))
    (Int.repr (Z.of_nat n))) (seq 0 16384) = true.
Proof.
  apply forallb_forall.
  intros n IN.
  apply in_seq in IN as [LOW HIGH].
  rewrite nonnegative_short_cast_symbolic by lia.
  apply Int.eq_true.
Qed.

Print Assumptions nonnegative_short_cast_symbolic.
Print Assumptions nonnegative_short_cast_certificate.
