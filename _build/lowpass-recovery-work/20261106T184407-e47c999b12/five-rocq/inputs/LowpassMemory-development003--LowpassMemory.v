From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
Import ListNotations.
Local Open Scope Z_scope.
Definition writable12(m:mem)(b:block)(p:ptrofs):Prop :=
 (4 | Ptrofs.unsigned p) /\ Ptrofs.unsigned p+12<=Ptrofs.max_unsigned /\
 Mem.range_perm m b (Ptrofs.unsigned p)(Ptrofs.unsigned p+12) Cur Writable.
Lemma field_pointer:forall m b p delta,writable12 m b p -> In delta[0;4;8] ->
 Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr delta))=Ptrofs.unsigned p+delta.
Proof.
 intros m b p delta[AL[NW RP]]D;rewrite Ptrofs.add_unsigned.
 assert(DR:0<=delta<=Ptrofs.max_unsigned)by(change(0<=delta<=18446744073709551615);destruct D as[<-|[<-|[<-|[]]]];lia).
 rewrite (Ptrofs.unsigned_repr delta DR).
 apply Ptrofs.unsigned_repr;pose proof(Ptrofs.unsigned_range p).
 destruct D as[<-|[<-|[<-|[]]]];lia.
Qed.
Lemma field_access:forall m b p delta,writable12 m b p -> In delta[0;4;8] ->
 Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+delta)Writable.
Proof.
 intros m b p delta[AL[NW RP]]D;split.
 - intros ofs RANGE;apply RP;cbn[size_chunk]in RANGE;destruct D as[<-|[<-|[<-|[]]]];lia.
 - change(4|Ptrofs.unsigned p+delta);destruct AL as[k K];destruct D as[<-|[<-|[<-|[]]]];
   [exists k|exists(k+1)|exists(k+2)];lia.
Qed.
Lemma field_store:forall m b p delta v,writable12 m b p -> In delta[0;4;8] ->
 exists mf,Mem.store Mfloat32 m b(Ptrofs.unsigned p+delta)(Vsingle v)=Some mf.
Proof. intros;eapply Mem.valid_access_store;eapply field_access;eauto. Qed.
Lemma store_preserves_writable12:forall m b p ch block ofs v mf,
 writable12 m b p -> Mem.store ch m block ofs v=Some mf -> writable12 mf b p.
Proof.
 intros m b p ch blk ofs v mf[AL[NW RP]]ST;repeat split;auto.
 intros z H;eapply Mem.perm_store_1;[exact ST|apply RP;exact H].
Qed.
Definition byte_frame(m mf:mem)(b:block)(p:ptrofs):Prop :=
 forall block ofs n,block<>b \/ ofs+n<=Ptrofs.unsigned p \/ Ptrofs.unsigned p+12<=ofs ->
 Mem.loadbytes mf block ofs n=Mem.loadbytes m block ofs n.
Lemma field_store_frame:forall m b p delta v mf,
 In delta[0;4;8] -> Mem.store Mfloat32 m b(Ptrofs.unsigned p+delta)(Vsingle v)=Some mf ->
 byte_frame m mf b p.
Proof.
 intros m b p delta v mf D ST block ofs n OUT.
 eapply Mem.loadbytes_store_other;[exact ST|].
 cbn[size_chunk];destruct D as[<-|[<-|[<-|[]]]];destruct OUT as[B|[L|R]];auto 8 with lia.
Qed.
Lemma byte_frame_trans:forall m m1 mf b p,byte_frame m m1 b p->byte_frame m1 mf b p->byte_frame m mf b p.
Proof. intros m m1 mf b p A B block ofs n OUT;rewrite B by exact OUT;apply A;exact OUT. Qed.
Lemma field_store_load:forall m b base delta v mf,
 Mem.store Mfloat32 m b(base+delta)(Vsingle v)=Some mf ->
 Mem.load Mfloat32 mf b(base+delta)=Some(Vsingle v).
Proof. intros;erewrite Mem.load_store_same;[reflexivity|exact H]. Qed.
Definition three_stores(m:mem)(b:block)(p:ptrofs)(tc vi vo:float32)(mf:mem):Prop :=
 exists m1 m2,Mem.store Mfloat32 m b(Ptrofs.unsigned p+0)(Vsingle tc)=Some m1 /\
 Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+4)(Vsingle vi)=Some m2 /\
 Mem.store Mfloat32 m2 b(Ptrofs.unsigned p+8)(Vsingle vo)=Some mf.
Lemma three_stores_exist:forall m b p tc vi vo,writable12 m b p->exists mf,three_stores m b p tc vi vo mf.
Proof.
 intros m b p tc vi vo P.
 destruct(field_store m b p 0 tc P ltac:(simpl;auto))as[m1 S1].
 pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ P S1)as P1.
 destruct(field_store m1 b p 4 vi P1 ltac:(simpl;auto))as[m2 S2].
 pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ P1 S2)as P2.
 destruct(field_store m2 b p 8 vo P2 ltac:(simpl;auto))as[mf S3].
 exists mf,m1,m2;auto.
Qed.
Lemma three_stores_bytes:forall m b p tc vi vo mf,three_stores m b p tc vi vo mf ->
 Mem.loadbytes mf b(Ptrofs.unsigned p)12=
 Some(encode_val Mfloat32(Vsingle tc)++encode_val Mfloat32(Vsingle vi)++encode_val Mfloat32(Vsingle vo)).
Proof.
 intros m b p tc vi vo mf[m1[m2[S1[S2 S3]]]].
 assert(L0:Mem.loadbytes mf b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle tc))).
 { erewrite Mem.loadbytes_store_other by(exact S3||(cbn[size_chunk];lia)).
   erewrite Mem.loadbytes_store_other by(exact S2||(cbn[size_chunk];lia)).
   replace(Ptrofs.unsigned p)with(Ptrofs.unsigned p+0)by lia.
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ S1). }
 assert(L4:Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle vi))).
 { erewrite Mem.loadbytes_store_other by(exact S3||(cbn[size_chunk];lia)).
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ S2). }
 assert(L8:Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle vo)))by exact(Mem.loadbytes_store_same _ _ _ _ _ _ S3).
 assert(L48:Mem.loadbytes mf b(Ptrofs.unsigned p+4)8=Some(encode_val Mfloat32(Vsingle vi)++encode_val Mfloat32(Vsingle vo))).
 { replace 8 with(4+4)by lia;eapply Mem.loadbytes_concat;try exact L4;try lia.
   replace(Ptrofs.unsigned p+4+4)with(Ptrofs.unsigned p+8)by lia;exact L8. }
 replace 12 with(4+8)by lia;eapply Mem.loadbytes_concat;eauto;lia.
Qed.
Lemma three_stores_frame:forall m b p tc vi vo mf,three_stores m b p tc vi vo mf ->byte_frame m mf b p.
Proof.
 intros m b p tc vi vo mf[m1[m2[S1[S2 S3]]]].
 eapply byte_frame_trans;[eapply field_store_frame;[simpl;auto|exact S1]|].
 eapply byte_frame_trans;[eapply field_store_frame;[simpl;auto|exact S2]|].
 eapply field_store_frame;[simpl;auto|exact S3].
Qed.
Print Assumptions field_pointer.
Print Assumptions three_stores_bytes.
Print Assumptions three_stores_frame.
