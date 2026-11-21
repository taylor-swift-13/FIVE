From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix.
Open Scope Z_scope.
Lemma byte_store_same : forall m m' b ofs z,
 0<=z<256 -> Mem.store Mint8unsigned m b ofs (Vint(Int.repr z))=Some m' ->
 Mem.load Mint8unsigned m' b ofs=Some(Vint(Int.repr z)).
Proof.
 intros m m' b ofs z R S. pose proof(@Mem.load_store_same Mint8unsigned m b ofs (Vint(Int.repr z)) m' S)as H.
 cbn [Val.load_result] in H. rewrite byte_extension in H by exact R. exact H.
Qed.
Lemma byte_store_other : forall m m' b ofs z i,
 Mem.store Mint8unsigned m b ofs (Vint(Int.repr z))=Some m' -> i<>ofs ->
 Mem.load Mint8unsigned m' b i=Mem.load Mint8unsigned m b i.
Proof.
 intros m m' b ofs z i S NE. apply(@Mem.load_store_other Mint8unsigned m b ofs (Vint(Int.repr z))m' S Mint8unsigned b i).
 right;cbn [size_chunk];lia.
Qed.
Lemma byte_store_range : forall m m' b ofs z,
 Mem.store Mint8unsigned m b ofs (Vint(Int.repr z))=Some m' ->
 Mem.range_perm m b 0 9651 Cur Writable ->Mem.range_perm m' b 0 9651 Cur Writable.
Proof.
 intros m m' b ofs z S R i I. eapply Mem.perm_store_1;[exact S|]. apply R;exact I.
Qed.
Lemma byte_store_exists : forall m b ofs z,
 Mem.range_perm m b 0 9651 Cur Writable ->0<=ofs<9651 ->
 exists m',Mem.store Mint8unsigned m b ofs(Vint(Int.repr z))=Some m'.
Proof.
 intros m b ofs z R I. destruct(Mem.valid_access_store m Mint8unsigned b ofs(Vint(Int.repr z)))as[m' S].
 - split.
   + intros j J. apply R. cbn [size_chunk] in J;lia.
   + change(1|ofs);exists ofs;lia.
 - exists m';exact S.
Qed.
Theorem packed_prefix_advance : forall cnt m b,
 0<=cnt<6434 ->packed_prefix cnt m b ->
 exists m1 m2,
 Mem.store Mint8unsigned m b cnt(Vint(Int.repr(low_written cnt)))=Some m1 /\
 Mem.store Mint8unsigned m1 b(high_address cnt)(Vint(Int.repr(high_written cnt)))=Some m2 /\
 packed_prefix(cnt+1)m2 b.
Proof.
 intros cnt m b C [R V].
 destruct(byte_store_exists m b cnt(low_written cnt)R ltac:(lia))as[m1 S1].
 pose proof(byte_store_range m m1 b cnt(low_written cnt)S1 R)as R1.
 pose proof(high_address_bounds cnt C)as[HB NE].
 destruct(byte_store_exists m1 b(high_address cnt)(high_written cnt)R1 ltac:(lia))as[m2 S2].
 exists m1,m2;split;[exact S1|]. split;[exact S2|]. split.
 - eapply byte_store_range;[exact S2|exact R1].
 - intros i I. pose proof(view_advance_at cnt C)as[LOW[HIGH HR]].
   destruct(Z.eq_dec i(high_address cnt))as[E|E].
   + subst i. rewrite<-HIGH. eapply byte_store_same;[lia|exact S2].
   + rewrite(byte_store_other _ _ _ _ _ _ S2 E).
     destruct(Z.eq_dec i cnt)as[F|F].
     * subst i. rewrite<-LOW. eapply byte_store_same;[unfold low_written,low_byte;apply Z.mod_pos_bound;lia|exact S1].
     * rewrite(byte_store_other _ _ _ _ _ _ S1 F).
       rewrite buffer_view_other by assumption. apply V;exact I.
Qed.
