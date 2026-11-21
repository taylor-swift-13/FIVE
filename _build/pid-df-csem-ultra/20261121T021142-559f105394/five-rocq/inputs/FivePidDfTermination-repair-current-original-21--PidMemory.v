From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
Import ListNotations.
Local Open Scope Z_scope.
Definition writable32(m:mem)(b:block)(p:ptrofs):Prop :=
 (4 | Ptrofs.unsigned p) /\ Ptrofs.unsigned p+32<=Ptrofs.modulus /\
 Mem.range_perm m b (Ptrofs.unsigned p)(Ptrofs.unsigned p+32) Cur Writable.
Definition field_offsets:list Z:=[0;4;8;12;16;20;24;28].
Lemma field_pointer:forall m b p delta,writable32 m b p -> In delta field_offsets ->
 Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr delta))=Ptrofs.unsigned p+delta.
Proof.
 intros m b p delta[AL[NW RP]]D;rewrite Ptrofs.add_unsigned.
 assert(DR:0<=delta<=Ptrofs.max_unsigned).
 { change(0<=delta<=18446744073709551615);unfold field_offsets in D;repeat destruct D as[<-|D];try contradiction;lia. }
 rewrite(Ptrofs.unsigned_repr delta DR);apply Ptrofs.unsigned_repr;pose proof(Ptrofs.unsigned_range p).
 unfold Ptrofs.max_unsigned;unfold field_offsets in D;repeat destruct D as[<-|D];try contradiction;lia.
Qed.
Lemma field_access:forall m b p delta,writable32 m b p -> In delta field_offsets ->
 Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+delta)Writable.
Proof.
 intros m b p delta[AL[NW RP]]D;split.
 - intros ofs RANGE;apply RP;cbn[size_chunk]in RANGE;unfold field_offsets in D;repeat destruct D as[<-|D];try contradiction;lia.
 - change(4|Ptrofs.unsigned p+delta);destruct AL as[k K];unfold field_offsets in D;repeat destruct D as[<-|D];try contradiction;
   [exists k|exists(k+1)|exists(k+2)|exists(k+3)|exists(k+4)|exists(k+5)|exists(k+6)|exists(k+7)];lia.
Qed.
Lemma field_store:forall m b p delta v,writable32 m b p -> In delta field_offsets ->
 exists mf,Mem.store Mfloat32 m b(Ptrofs.unsigned p+delta)(Vsingle v)=Some mf.
Proof. intros m b p delta v W D;destruct(Mem.valid_access_store m Mfloat32 b(Ptrofs.unsigned p+delta)(Vsingle v)(field_access m b p delta W D))as[mf ST];exists mf;exact ST. Qed.
Lemma store_preserves_writable32:forall m b p ch blk ofs v mf,
 writable32 m b p -> Mem.store ch m blk ofs v=Some mf -> writable32 mf b p.
Proof.
 intros m b p ch blk ofs v mf[AL[NW RP]]ST;repeat split;auto.
 intros z H;eapply Mem.perm_store_1;[exact ST|apply RP;exact H].
Qed.
Lemma free_list_valid_block:forall regions m mf,Mem.free_list m regions=Some mf ->
 forall b,Mem.valid_block m b->Mem.valid_block mf b.
Proof.
 induction regions as[|[[q lo]hi]regions IH];intros m mf FREE b VB.
 - cbn[Mem.free_list]in FREE;injection FREE as<-;exact VB.
 - cbn[Mem.free_list]in FREE;destruct(Mem.free m q lo hi)as[ma|]eqn:F;try discriminate.
   eapply IH;[exact FREE|eapply Mem.valid_block_free_1;[exact F|exact VB]].
Qed.
Print Assumptions field_pointer.
Print Assumptions free_list_valid_block.
