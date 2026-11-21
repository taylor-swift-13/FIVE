From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Integers.
From PprzTrigRelationSupport Require Import TrigData TrigTrace TrigEmission.
Open Scope Z_scope.
Definition k_value(c:chunk):Z := Z.lor(second c)(Z.shiftl(Z.land(third c)8)1).
Definition machine_k(c:chunk):Int.int :=Int.or(Int.repr(second c))(Int.shl(Int.and(Int.repr(third c))(Int.repr 8))(Int.repr 1)).
Definition machine_repetitions(c:chunk):Int.int :=if multi c
 then Int.add(Int.sign_ext 16(machine_k c))(Int.add(Int.mul(Int.repr 3)(Int.repr 3))(Int.repr 1))
 else Int.add(Int.divs(Int.repr(first c))(Int.repr 5))(Int.repr 1).
Definition machine_delta(c:chunk):Int.int :=if multi c then Int.and(Int.repr(third c))(Int.repr 7)
 else Int.mods(Int.repr(first c))(Int.repr 5).
Definition chunk_machine_ok(c:chunk):bool :=
 Int.eq(machine_repetitions c)(Int.repr(repetitions c)) &&
 Int.eq(machine_delta c)(Int.repr(delta c)) &&
 Int.eq(Int.sign_ext 16(machine_k c))(Int.repr(k_value c)).
Lemma literal_chunk_machine_certificate : forallb chunk_machine_ok literal_chunks=true.
Proof. vm_compute;reflexivity. Qed.
Lemma literal_chunk_machine : forall c,In c literal_chunks ->
 machine_repetitions c=Int.repr(repetitions c) /\machine_delta c=Int.repr(delta c) /\
 Int.sign_ext 16(machine_k c)=Int.repr(k_value c).
Proof.
 intros c IN. pose proof literal_chunk_machine_certificate as H.
 apply forallb_forall with(x:=c)in H;auto. unfold chunk_machine_ok in H.
 repeat rewrite andb_true_iff in H. destruct H as[[A B]C].
 apply Int.same_if_eq in A;apply Int.same_if_eq in B;apply Int.same_if_eq in C;auto.
Qed.
