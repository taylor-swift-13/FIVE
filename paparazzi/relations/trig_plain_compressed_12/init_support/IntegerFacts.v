From Stdlib Require Import ZArith Lia.
From compcert Require Import Integers Values Memory Ctypes Cop.
Local Open Scope Z_scope.

Lemma zero_ext16_repr : forall z, 0<=z<=65535 ->
  Int.zero_ext 16 (Int.repr z)=Int.repr z.
Proof.
  intros z RANGE.
  rewrite <- (Int.repr_unsigned (Int.zero_ext 16 (Int.repr z))) at 1.
  rewrite Int.zero_ext_mod by (change (0<=16<32);lia).
  rewrite Int.unsigned_repr by (change (0<=z<=4294967295);lia).
  change (Int.repr(z mod 65536)=Int.repr z).
  rewrite Z.mod_small by lia;reflexivity.
Qed.
Lemma zero_ext8_repr : forall z, 0<=z<=255 ->
  Int.zero_ext 8 (Int.repr z)=Int.repr z.
Proof.
  intros z RANGE.
  rewrite <- (Int.repr_unsigned (Int.zero_ext 8 (Int.repr z))) at 1.
  rewrite Int.zero_ext_mod by (change (0<=8<32);lia).
  rewrite Int.unsigned_repr by (change (0<=z<=4294967295);lia).
  change (Int.repr(z mod 256)=Int.repr z).
  rewrite Z.mod_small by lia;reflexivity.
Qed.
