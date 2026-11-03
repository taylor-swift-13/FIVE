From Stdlib Require Import ZArith Lia List.
From compcert Require Import AST Integers Floats Values Memory Memdata.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
Open Scope Z_scope.
Module HarnessMemory.
Definition single_word (w:int) := Vsingle (Float32.of_bits w).
Definition word_bytes (w:int) := encode_val Mfloat32 (single_word w).
Definition initialized_state (m:mem) (b:block) (s:filter_state) : Prop :=
 Mem.load Mfloat32 m b 0=Some(single_word(a0 s)) /\
 Mem.load Mfloat32 m b 4=Some(single_word(a1 s)) /\
 Mem.load Mfloat32 m b 8=Some(single_word(b0 s)) /\
 Mem.load Mfloat32 m b 12=Some(single_word(b1 s)) /\
 Mem.load Mfloat32 m b 16=Some(single_word(i0 s)) /\
 Mem.load Mfloat32 m b 20=Some(single_word(i1 s)) /\
 Mem.load Mfloat32 m b 24=Some(single_word(o0 s)) /\
 Mem.load Mfloat32 m b 28=Some(single_word(o1 s)).
Definition four_stores (m:mem) (b:block) (old_i0 value old_o0 out:int) (mf:mem) : Prop :=
 exists m1 m2 m3,
 Mem.store Mfloat32 m b 20 (single_word old_i0)=Some m1 /\
 Mem.store Mfloat32 m1 b 16 (single_word value)=Some m2 /\
 Mem.store Mfloat32 m2 b 28 (single_word old_o0)=Some m3 /\
 Mem.store Mfloat32 m3 b 24 (single_word out)=Some mf.
Definition updated_state (s:filter_state) (value out:int) : filter_state :=
 mkState (a0 s)(a1 s)(b0 s)(b1 s) value(i0 s)out(o0 s).
Definition outside_updates (b:block) (b':block) (ofs:Z) :=
 b'<>b \/ ofs<16 \/ 32<=ofs.
Lemma load_float_other : forall m m' b storeofs w ofs,
 Mem.store Mfloat32 m b storeofs(single_word w)=Some m' ->
 ofs+4<=storeofs \/ storeofs+4<=ofs ->
 Mem.load Mfloat32 m' b ofs=Mem.load Mfloat32 m b ofs.
Proof. intros; eapply Mem.load_store_other; eauto; simpl; tauto. Qed.
Lemma load_float_same : forall m m' b ofs w,
 Mem.store Mfloat32 m b ofs(single_word w)=Some m' ->
 Mem.load Mfloat32 m' b ofs=Some(single_word w).
Proof. intros; erewrite Mem.load_store_same by eauto. reflexivity. Qed.
Lemma loadbytes_float_other : forall m m' b storeofs w b' ofs n,
 Mem.store Mfloat32 m b storeofs(single_word w)=Some m' ->
 b'<>b \/ n<=0 \/ ofs+n<=storeofs \/ storeofs+4<=ofs ->
 Mem.loadbytes m' b' ofs n=Mem.loadbytes m b' ofs n.
Proof. intros; eapply Mem.loadbytes_store_other; eauto. Qed.
Lemma loadbytes_float_same : forall m m' b ofs w,
 Mem.store Mfloat32 m b ofs(single_word w)=Some m' ->
 Mem.loadbytes m' b ofs 4=Some(word_bytes w).
Proof. intros; change 4 with (size_chunk Mfloat32); eapply Mem.loadbytes_store_same; eauto. Qed.
Theorem four_stores_final_words : forall m mf b s value out,
 initialized_state m b s ->
 four_stores m b(i0 s)value(o0 s)out mf ->
 initialized_state mf b(updated_state s value out).
Proof.
 intros m mf b s value out INIT [m1[m2[m3[S1[S2[S3 S4]]]]]].
 unfold initialized_state in *; unfold updated_state; cbn.
 destruct INIT as[A0[A1[B0[B1[I0[I1[O0 O1]]]]]]].
 repeat split.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   erewrite load_float_other by (exact S2 || lia).
   erewrite load_float_other by (exact S1 || lia). exact A0.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   erewrite load_float_other by (exact S2 || lia).
   erewrite load_float_other by (exact S1 || lia). exact A1.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   erewrite load_float_other by (exact S2 || lia).
   erewrite load_float_other by (exact S1 || lia). exact B0.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   erewrite load_float_other by (exact S2 || lia).
   erewrite load_float_other by (exact S1 || lia). exact B1.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   eapply load_float_same; exact S2.
 - erewrite load_float_other by (exact S4 || lia).
   erewrite load_float_other by (exact S3 || lia).
   erewrite load_float_other by (exact S2 || lia).
   eapply load_float_same; exact S1.
 - eapply load_float_same; exact S4.
 - erewrite load_float_other by (exact S4 || lia).
   eapply load_float_same; exact S3.
Qed.
Theorem four_stores_next_words : forall m mf b s value,
 initialized_state m b s ->
 four_stores m b(i0 s)value(o0 s)(calc_out s value)mf ->
 initialized_state mf b(next s value).
Proof. intros; eapply four_stores_final_words; eauto. Qed.
Theorem four_stores_loadbytes_frame : forall m mf b old_i0 value old_o0 out b' ofs n,
 four_stores m b old_i0 value old_o0 out mf ->
 b'<>b \/ n<=0 \/ ofs+n<=16 \/ 32<=ofs ->
 Mem.loadbytes mf b' ofs n=Mem.loadbytes m b' ofs n.
Proof.
 intros m mf b old_i0 value old_o0 out b' ofs n
 [m1[m2[m3[S1[S2[S3 S4]]]]]] DISJ.
 erewrite loadbytes_float_other by (exact S4 || intuition lia).
 erewrite loadbytes_float_other by (exact S3 || intuition lia).
 erewrite loadbytes_float_other by (exact S2 || intuition lia).
 erewrite loadbytes_float_other by (exact S1 || intuition lia). reflexivity.
Qed.
Theorem four_stores_exact_slot_bytes : forall m mf b old_i0 value old_o0 out,
 four_stores m b old_i0 value old_o0 out mf ->
 Mem.loadbytes mf b 20 4=Some(word_bytes old_i0) /\
 Mem.loadbytes mf b 16 4=Some(word_bytes value) /\
 Mem.loadbytes mf b 28 4=Some(word_bytes old_o0) /\
 Mem.loadbytes mf b 24 4=Some(word_bytes out).
Proof.
 intros m mf b old_i0 value old_o0 out [m1[m2[m3[S1[S2[S3 S4]]]]]].
 repeat split.
 - erewrite loadbytes_float_other by (exact S4 || intuition lia).
   erewrite loadbytes_float_other by (exact S3 || intuition lia).
   erewrite loadbytes_float_other by (exact S2 || intuition lia).
   eapply loadbytes_float_same; exact S1.
 - erewrite loadbytes_float_other by (exact S4 || intuition lia).
   erewrite loadbytes_float_other by (exact S3 || intuition lia).
   eapply loadbytes_float_same; exact S2.
 - erewrite loadbytes_float_other by (exact S4 || intuition lia).
   eapply loadbytes_float_same; exact S3.
 - eapply loadbytes_float_same; exact S4.
Qed.
Lemma single_word_exact_bytes : forall w,
 word_bytes w=encode_val Mint32(Vint w).
Proof. intros; unfold word_bytes,single_word; simpl; rewrite Float32.to_of_bits; reflexivity. Qed.
Lemma one_store_frame : forall m mf b ofs w,
 Mem.store Mfloat32 m b ofs(single_word w)=Some mf ->
 (16<=ofs /\ ofs+4<=32) ->
 Mem.unchanged_on(outside_updates b)m mf.
Proof.
 intros m mf b ofs w ST RANGE. eapply Mem.store_unchanged_on;[exact ST|].
 intros i HI OUT. unfold outside_updates in OUT. simpl in HI.
 destruct OUT as[NE|[LO|HI']];[apply NE;reflexivity|lia|lia].
Qed.
Theorem four_stores_full_frame : forall m mf b old_i0 value old_o0 out,
 four_stores m b old_i0 value old_o0 out mf ->
 Mem.unchanged_on(outside_updates b)m mf.
Proof.
 intros m mf b old_i0 value old_o0 out [m1[m2[m3[S1[S2[S3 S4]]]]]].
 assert(F1:Mem.unchanged_on(outside_updates b)m m1) by(eapply one_store_frame;eauto;lia).
 assert(F2:Mem.unchanged_on(outside_updates b)m1 m2) by(eapply one_store_frame;eauto;lia).
 assert(F3:Mem.unchanged_on(outside_updates b)m2 m3) by(eapply one_store_frame;eauto;lia).
 assert(F4:Mem.unchanged_on(outside_updates b)m3 mf) by(eapply one_store_frame;eauto;lia).
 eapply Mem.unchanged_on_trans;[exact F1|].
 eapply Mem.unchanged_on_trans;[exact F2|].
 eapply Mem.unchanged_on_trans;[exact F3|exact F4].
Qed.

Definition private_block_ids (l:list(block*Z*Z)) : list block :=
 map (fun x=>fst(fst x)) l.
Theorem free_list_load_other : forall l m mf b chunk ofs,
 Mem.free_list m l=Some mf -> ~In b(private_block_ids l) ->
 Mem.load chunk mf b ofs=Mem.load chunk m b ofs.
Proof.
 intros l; induction l as[|[[bf lo]hi]l IH];intros m mf b chunk ofs FREE NOT.
 - simpl in FREE;inversion FREE;reflexivity.
 - simpl in FREE;unfold private_block_ids in NOT;simpl in NOT.
   destruct(Mem.free m bf lo hi)as[m1|]eqn:F;try discriminate.
   erewrite IH;[|exact FREE|].
   + eapply Mem.load_free;[exact F|]. left;intro EQ;apply NOT;left;symmetry;exact EQ.
   + unfold private_block_ids;intro IN;apply NOT;right;exact IN.
Qed.
Theorem free_list_loadbytes_other : forall l m mf b ofs n,
 Mem.free_list m l=Some mf -> ~In b(private_block_ids l) ->
 Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros l;induction l as[|[[bf lo]hi]l IH];intros m mf b ofs n FREE NOT.
 - simpl in FREE;inversion FREE;reflexivity.
 - simpl in FREE;unfold private_block_ids in NOT;simpl in NOT.
   destruct(Mem.free m bf lo hi)as[m1|]eqn:F;try discriminate.
   erewrite IH;[|exact FREE|].
   + eapply Mem.loadbytes_free;[exact F|]. left;intro EQ;apply NOT;left;symmetry;exact EQ.
   + unfold private_block_ids;intro IN;apply NOT;right;exact IN.
Qed.
Theorem initialized_state_after_private_free : forall l m mf b s,
 initialized_state m b s -> Mem.free_list m l=Some mf ->
 ~In b(private_block_ids l) -> initialized_state mf b s.
Proof.
 intros l m mf b s INIT FREE NOT;unfold initialized_state in *.
 repeat erewrite (free_list_load_other l m mf b) by eauto. exact INIT.
Qed.
Theorem four_stores_then_private_free_next : forall l m m5 mf b s value,
 initialized_state m b s ->
 four_stores m b(i0 s)value(o0 s)(calc_out s value)m5 ->
 Mem.free_list m5 l=Some mf -> ~In b(private_block_ids l) ->
 initialized_state mf b(next s value).
Proof.
 intros;eapply initialized_state_after_private_free;eauto.
 eapply four_stores_next_words;eauto.
Qed.
Theorem four_stores_then_private_free_bytes : forall l m m5 mf b old_i0 value old_o0 out b' ofs n,
 four_stores m b old_i0 value old_o0 out m5 ->
 Mem.free_list m5 l=Some mf -> ~In b'(private_block_ids l) ->
 b'<>b \/ n<=0 \/ ofs+n<=16 \/ 32<=ofs ->
 Mem.loadbytes mf b' ofs n=Mem.loadbytes m b' ofs n.
Proof.
 intros l m m5 mf b old_i0 value old_o0 out b' ofs n STORES FREE NOT DISJ.
 rewrite(free_list_loadbytes_other l m5 mf b' ofs n FREE NOT).
 eapply four_stores_loadbytes_frame;eauto.
Qed.
End HarnessMemory.
