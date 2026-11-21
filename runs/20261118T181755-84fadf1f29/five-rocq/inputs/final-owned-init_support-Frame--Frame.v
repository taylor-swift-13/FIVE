From Stdlib Require Import ZArith.
From compcert Require Import Coqlib AST Values Memory.
Local Open Scope Z_scope.

Definition protected (initial:mem) (buffer:block) (b:block) (_ofs:Z) : Prop :=
  Mem.valid_block initial b /\ b <> buffer.

Lemma protected_store : forall initial buffer chunk m b ofs v m',
  Mem.store chunk m b ofs v = Some m' ->
  (b = buffer \/ ~ Mem.valid_block initial b) ->
  Mem.unchanged_on (protected initial buffer) m m'.
Proof.
  intros initial buffer chunk m b ofs v m' STORE DEST.
  eapply Mem.store_unchanged_on; eauto.
  intros i RANGE [OLD NE]; destruct DEST; congruence.
Qed.

Lemma protected_storebytes : forall initial buffer m b ofs bytes m',
  Mem.storebytes m b ofs bytes = Some m' ->
  (b = buffer \/ ~ Mem.valid_block initial b) ->
  Mem.unchanged_on (protected initial buffer) m m'.
Proof.
  intros initial buffer m b ofs bytes m' STORE DEST.
  eapply Mem.storebytes_unchanged_on; eauto.
  intros i RANGE [OLD NE]; destruct DEST; congruence.
Qed.

Lemma protected_alloc : forall initial buffer m lo hi m' b,
  Mem.alloc m lo hi = (m',b) ->
  Mem.unchanged_on (protected initial buffer) m m'.
Proof. intros; eapply Mem.alloc_unchanged_on; eauto. Qed.

Lemma protected_free : forall initial buffer m b lo hi m',
  Mem.free m b lo hi = Some m' ->
  ~ Mem.valid_block initial b ->
  Mem.unchanged_on (protected initial buffer) m m'.
Proof.
  intros initial buffer m b lo hi m' FREE FRESH.
  eapply Mem.free_unchanged_on; eauto.
  intros i RANGE [OLD NE]; contradiction.
Qed.

Lemma protected_trans : forall initial buffer m1 m2 m3,
  Mem.unchanged_on (protected initial buffer) m1 m2 ->
  Mem.unchanged_on (protected initial buffer) m2 m3 ->
  Mem.unchanged_on (protected initial buffer) m1 m3.
Proof. intros; eapply Mem.unchanged_on_trans; eauto. Qed.
