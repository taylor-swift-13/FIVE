From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs.
From FiveMatInv3Case Require Import MatrixMemory Memcpy36.
Import ListNotations.
Local Open Scope Z_scope.
Lemma append_cut:forall(A:Type)(a b c d:list A),length a=length c->a++b=c++d->a=c /\b=d.
Proof. intros A a;induction a as[|x a IH];intros b c d LEN EQ;destruct c as[|y c];simpl in LEN;try discriminate.
 - simpl in EQ;auto.
 - simpl in EQ;injection EQ as XY EQ;subst y;destruct(IH b c d ltac:(lia)EQ)as[-> ->];auto. Qed.
Lemma same_bytes_cell:forall m1 b1 m2 b2 bytes z,
 Mem.loadbytes m1 b1 0 36=Some bytes->Mem.loadbytes m2 b2 0 36=Some bytes->0<=z->z+4<=36->
 Mem.loadbytes m1 b1 z 4=Mem.loadbytes m2 b2 z 4.
Proof.
 intros m1 b1 m2 b2 bytes z A B Z LIMIT.
 replace 36 with(z+(36-z))in A,B by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ A ltac:(lia)ltac:(lia))as[a[rest[RA[RR EA]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ B ltac:(lia)ltac:(lia))as[c[tail[RC[RT EC]]]].
 assert(L:length a=length c)by(erewrite(Mem.loadbytes_length _ _ _ _ _ RA),(Mem.loadbytes_length _ _ _ _ _ RC);reflexivity).
 destruct(append_cut _ a rest c tail L ltac:(congruence))as[_ EQ];subst tail.
 replace(0+z)with z in RR,RT by lia.
 replace(36-z)with(4+(32-z))in RR,RT by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ RR ltac:(lia)ltac:(lia))as[d[ds[RD[RDS ED]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ RT ltac:(lia)ltac:(lia))as[f[fs[RF[RFS EF]]]].
 assert(L':length d=length f)by(erewrite(Mem.loadbytes_length _ _ _ _ _ RD),(Mem.loadbytes_length _ _ _ _ _ RF);reflexivity).
 destruct(append_cut _ d ds f fs L' ltac:(congruence))as[EQ _];subst f;congruence.
Qed.
Lemma memcpy_word_observation:forall m src dst mf bytes f,
 Mem.loadbytes m src 0 36=Some bytes->Mem.storebytes m dst 0 bytes=Some mf->
 (forall i,0<=i<9->Mem.loadbytes m src(4*i)4=Some(encode_val Mfloat32(Vsingle(f i))))->
 forall i,0<=i<9->Mem.load Mint32 mf dst(4*i)=Some(Vint(Float32.to_bits(f i))).
Proof.
 intros m src dst mf bytes f RD ST CELLS i I.
 pose proof(Mem.loadbytes_length _ _ _ _ _ RD)as LEN;change(length bytes=36%nat)in LEN.
 pose proof(Mem.loadbytes_storebytes_same _ _ _ _ _ ST)as ALL;rewrite LEN in ALL;change(Mem.loadbytes mf dst 0 36=Some bytes)in ALL.
 pose proof(same_bytes_cell m src mf dst bytes(4*i)RD ALL ltac:(lia)ltac:(lia))as EQ.
 assert(C:Mem.loadbytes mf dst(4*i)4=Some(encode_val Mfloat32(Vsingle(f i))))by(rewrite <-EQ;apply CELLS;exact I).
 pose proof(Mem.loadbytes_load Mint32 mf dst(4*i)_ C ltac:(change(4|4*i);exists i;lia))as LOAD.
 pose proof(decode_encode_val_general(Vsingle(f i))Mfloat32 Mint32)as DE.
 change(decode_val Mint32(encode_val Mfloat32(Vsingle(f i)))=Vint(Float32.to_bits(f i)))in DE;rewrite DE in LOAD;exact LOAD.
Qed.
Print Assumptions memcpy_word_observation.
