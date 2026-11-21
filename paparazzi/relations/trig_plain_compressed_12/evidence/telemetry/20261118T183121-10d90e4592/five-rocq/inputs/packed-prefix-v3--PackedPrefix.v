From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import AST Integers Values Memory.
From PprzTrigRelationSupport Require Import TrigData.
Import ListNotations.
Open Scope Z_scope.
Definition table_at (i:Z) : Z := nth (Z.to_nat i) ordinary_values 0.
Definition high_address (cnt:Z) : Z := 6434+cnt/2.
Definition buffer_view (cnt i:Z):Z :=
 if i <?6434 then (if i <?cnt then low_byte(table_at i) else 0)
 else let q:=2*(i-6434) in
 if q+1 <?cnt then nth(Z.to_nat i)expected_bytes 0
 else if q <?cnt then middle_nibble(table_at q) else 0.
Definition low_written (cnt:Z) : Z := low_byte(table_at cnt).
Definition high_written (cnt:Z) : Z :=
 if Z.eqb(cnt mod 2)0 then middle_nibble(table_at cnt)
 else Z.lor (buffer_view cnt (high_address cnt)) (Z.shiftr(Z.land(table_at cnt)3840)4).
Definition advance_ok (cnt:Z):bool :=
 Z.eqb (low_written cnt) (buffer_view(cnt+1)cnt) &&
 Z.eqb (high_written cnt) (buffer_view(cnt+1)(high_address cnt)) &&
 (0<=?high_written cnt) && (high_written cnt<=?255).
Lemma literal_advance_certificate : forallb (fun n=>advance_ok(Z.of_nat n))(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma view_advance_at : forall cnt,0<=cnt<6434 ->
 low_written cnt=buffer_view(cnt+1)cnt /\
 high_written cnt=buffer_view(cnt+1)(high_address cnt) /\ 0<=high_written cnt<=255.
Proof.
 intros cnt C. pose proof literal_advance_certificate as H.
 apply forallb_forall with(x:=Z.to_nat cnt)in H.
 - rewrite Z2Nat.id in H by lia. unfold advance_ok in H.
   repeat rewrite andb_true_iff in H. destruct H as [[[L U] LO] HI].
   apply Z.eqb_eq in L;apply Z.eqb_eq in U;apply Z.leb_le in LO;apply Z.leb_le in HI;auto.
 - apply in_seq. split;[lia|]. apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;cbn;lia.
Qed.
Lemma high_address_bounds : forall cnt,0<=cnt<6434 -> 6434<=high_address cnt<9651 /\ cnt<>high_address cnt.
Proof.
 intros cnt C. unfold high_address.
 pose proof(Z.div_pos cnt 2 ltac:(lia)ltac:(lia)).
 pose proof(Z.div_lt_upper_bound cnt 2 3217 ltac:(lia)ltac:(lia)). lia.
Qed.
Lemma buffer_view_other : forall cnt i,0<=cnt<6434 ->0<=i<9651 ->
 i<>cnt ->i<>high_address cnt ->buffer_view(cnt+1)i=buffer_view cnt i.
Proof.
 intros cnt i C I LC HC. unfold buffer_view.
 destruct(Z.ltb_spec i 6434)as[L|U].
 - destruct(Z.ltb_spec i(cnt+1));destruct(Z.ltb_spec i cnt);try lia;reflexivity.
 - assert (D:cnt=2*(cnt/2)+cnt mod 2)by(pose proof(Z.div_mod cnt 2 ltac:(lia));lia).
   assert(R:0<=cnt mod 2<2)by(apply Z.mod_pos_bound;lia).
   assert(A:2*(i-6434)<>cnt)by(unfold high_address in HC;lia).
   assert(B:2*(i-6434)+1<>cnt)by(unfold high_address in HC;lia).
   destruct(Z.ltb_spec (2*(i-6434)+1)(cnt+1));destruct(Z.ltb_spec (2*(i-6434)+1)cnt);try lia;try reflexivity.
   destruct(Z.ltb_spec (2*(i-6434))(cnt+1));destruct(Z.ltb_spec (2*(i-6434))cnt);try lia;reflexivity.
Qed.
Lemma buffer_view_zero : forall i,0<=i<9651 ->buffer_view 0 i=0.
Proof.
 intros i I. unfold buffer_view. destruct(Z.ltb_spec i 6434);destruct(Z.ltb_spec i 0);try lia;try reflexivity.
 destruct(Z.ltb_spec (2*(i-6434)+1)0);try lia.
 destruct(Z.ltb_spec (2*(i-6434))0);try lia;reflexivity.
Qed.
Lemma buffer_view_complete : forall i,0<=i<9651 ->buffer_view 6434 i=nth(Z.to_nat i)expected_bytes 0.
Proof.
 intros i I. unfold buffer_view. destruct(Z.ltb_spec i 6434)as[L|U].
 - destruct(Z.ltb_spec i 6434);try lia. unfold expected_bytes.
   rewrite app_nth1 by(rewrite map_length,(proj1 original_data_lengths);apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;cbn;lia).
   unfold table_at,low_byte. rewrite map_nth with(d:=0);reflexivity.
 - destruct(Z.ltb_spec (2*(i-6434)+1)6434);[reflexivity|lia].
Qed.
Definition byte_view (cnt:Z)(m:mem)(b:block):Prop := forall i,0<=i<9651 ->
 Mem.load Mint8unsigned m b i=Some(Vint(Int.repr(buffer_view cnt i))).
Definition packed_prefix (cnt:Z)(m:mem)(b:block):Prop :=
 Mem.range_perm m b 0 9651 Cur Writable /\ byte_view cnt m b.
Lemma byte_extension : forall z,0<=z<256 ->Int.zero_ext 8(Int.repr z)=Int.repr z.
Proof.
 intros z R. rewrite <-(Int.repr_unsigned(Int.zero_ext 8(Int.repr z)))at 1.
 rewrite Int.zero_ext_mod by(change(0<=8<32);lia).
 rewrite Int.unsigned_repr by(change(0<=z<=4294967295);lia).
 change(Int.repr(z mod 256)=Int.repr z). rewrite Z.mod_small by exact R;reflexivity.
Qed.

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
 destruct(byte_store_exists m1 b(high_address cnt)(high_written cnt)R1 HB)as[m2 S2].
 exists m1,m2;split;[exact S1|]. split;[exact S2|]. split.
 - eapply byte_store_range;[exact S2|exact R1].
 - intros i I. pose proof(view_advance_at cnt C)as[LOW[HIGH HR]].
   destruct(Z.eq_dec i(high_address cnt))as[E|E].
   + subst i. rewrite<-HIGH. apply byte_store_same;[lia|exact S2].
   + rewrite(byte_store_other _ _ _ _ _ _ S2 E).
     destruct(Z.eq_dec i cnt)as[F|F].
     * subst i. rewrite<-LOW. apply byte_store_same;[unfold low_written,low_byte;apply Z.mod_pos_bound;lia|exact S1].
     * rewrite(byte_store_other _ _ _ _ _ _ S1 F).
       rewrite buffer_view_other by assumption. apply V;exact I.
Qed.
