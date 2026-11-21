From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib AST Integers.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix.
Open Scope Z_scope.
Definition machine_high_address(a:Int.int):Z := Int.signed(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1))).
Definition machine_shift(a:Int.int):Int.int := if Int.eq(Int.mods a(Int.repr 2))Int.zero then Int.repr 8 else Int.repr 4.
Definition machine_high_bits(a:Int.int):Int.int :=
 if Int.cmp Clt a(Int.repr 2145)then(if Int.cmp Clt a(Int.repr 1035)then Int.zero else Int.repr 4096)
 else(if Int.cmp Clt a(Int.repr 3474)then Int.repr 8192 else Int.repr 12288).
Definition machine_lookup(a:Int.int):Int.int := Int.sign_ext 16
 (Int.or(Int.or(machine_high_bits a)
  (Int.and(Int.shl(Int.repr(nth(Z.to_nat(machine_high_address a))expected_bytes 0))(machine_shift a))(Int.repr 3840)))
 (Int.repr(nth(Z.to_nat(Int.signed a))expected_bytes 0))).
Definition machine_ok(n:nat):bool :=
 Int.eq(machine_lookup(Int.repr(Z.of_nat n)))(Int.repr(table_at(Z.of_nat n))) &&
 Z.eqb(machine_high_address(Int.repr(Z.of_nat n)))(high_address(Z.of_nat n)).
Lemma literal_machine_certificate : forallb machine_ok(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma machine_lookup_at : forall z,0<=z<6434 ->
 machine_lookup(Int.repr z)=Int.repr(table_at z) /\machine_high_address(Int.repr z)=high_address z.
Proof.
 intros z Z. pose proof literal_machine_certificate as H.
 apply forallb_forall with(x:=Z.to_nat z)in H.
 - unfold machine_ok in H. rewrite Z2Nat.id in H by lia. apply andb_true_iff in H as[A B].
   apply Int.same_if_eq in A;apply Z.eqb_eq in B;auto.
 - apply in_seq;split;[lia|]. cbn [Nat.add]. change(Z.to_nat z<Z.to_nat 6434)%nat.
   apply(proj1(Z2Nat.inj_lt z 6434 ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma machine_lookup_signed : forall a,0<=Int.signed a<6434 ->
 machine_lookup a=Int.repr(table_at(Int.signed a)) /\machine_high_address a=high_address(Int.signed a).
Proof.
 intros a A. pose proof(machine_lookup_at(Int.signed a)A)as H.
 rewrite Int.repr_signed in H;exact H.
Qed.
