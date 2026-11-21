From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata.
From StateSpeedSetterSupport Require Import MemoryFacts.
Import ListNotations.
Open Scope Z_scope.

Definition vector_read(m:mem)(b:block)(x y z:float32):Prop:=
 Mem.load Mfloat32 m b 0=Some(Vsingle x) /\Mem.load Mfloat32 m b 4=Some(Vsingle y) /\Mem.load Mfloat32 m b 8=Some(Vsingle z).
Definition vector_bytes(x y z:float32):list memval:=
 encode_val Mfloat32(Vsingle x)++encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z).
Definition write_byte(sb:block)(d:Z)(b:block)(ofs:Z):Prop:=
 b=sb /\(280<=ofs<282 \/d<=ofs<d+12).
Definition FourStores(d:Z)(status:int)(m mb:mem)(sb:block)(x y z:float32):Prop:=
 exists m1 m2 m3,
 Mem.store Mfloat32 m sb d(Vsingle x)=Some m1 /\
 Mem.store Mfloat32 m1 sb(d+4)(Vsingle y)=Some m2 /\
 Mem.store Mfloat32 m2 sb(d+8)(Vsingle z)=Some m3 /\
 Mem.store Mint16unsigned m3 sb 280(Vint status)=Some mb.
Lemma four_stores_exist:forall d status m sb x y z,
 284<=d ->d+12<=656 ->(4|d) ->Mem.range_perm m sb 0 656 Cur Writable ->
 exists mb,FourStores d status m mb sb x y z.
Proof.
 intros d status m sb x y z D END ALIGN W.
 assert(AX:Mem.valid_access m Mfloat32 sb d Writable)by(eapply range_access;[exact W|lia|cbn;lia|exact ALIGN]).
 destruct(Mem.valid_access_store _ _ _ _ (Vsingle x)AX)as[m1 X].
 assert(AY:Mem.valid_access m1 Mfloat32 sb(d+4)Writable).
 { eapply Mem.store_valid_access_1;[exact X|].
   eapply range_access;[exact W|lia|cbn;lia|].
   change(4|d+4);destruct ALIGN as[k K];exists(k+1);lia. }
 destruct(Mem.valid_access_store _ _ _ _ (Vsingle y)AY)as[m2 Y].
 assert(AZ:Mem.valid_access m2 Mfloat32 sb(d+8)Writable).
 { eapply Mem.store_valid_access_1;[exact Y|].
   eapply Mem.store_valid_access_1;[exact X|].
   eapply range_access;[exact W|lia|cbn;lia|].
   change(4|d+8);destruct ALIGN as[k K];exists(k+2);lia. }
 destruct(Mem.valid_access_store _ _ _ _ (Vsingle z)AZ)as[m3 ZS].
 assert(AS:Mem.valid_access m3 Mint16unsigned sb 280 Writable).
 { eapply Mem.store_valid_access_1;[exact ZS|].
   eapply Mem.store_valid_access_1;[exact Y|].
   eapply Mem.store_valid_access_1;[exact X|].
   eapply range_access;[exact W|lia|cbn;lia|exists 140;reflexivity]. }
 destruct(Mem.valid_access_store _ _ _ _ (Vint status)AS)as[mb SS].
 exists mb,m1,m2,m3;auto.
Qed.

Section EFFECTS.
Variables d:Z.
Variables status:int.
Variables m m1 m2 m3 mb:mem.
Variables sb:block.
Variables x y z:float32.
Hypothesis D:284<=d.
Hypothesis X:Mem.store Mfloat32 m sb d(Vsingle x)=Some m1.
Hypothesis Y:Mem.store Mfloat32 m1 sb(d+4)(Vsingle y)=Some m2.
Hypothesis ZS:Mem.store Mfloat32 m2 sb(d+8)(Vsingle z)=Some m3.
Hypothesis ST:Mem.store Mint16unsigned m3 sb 280(Vint status)=Some mb.

Lemma four_store_words:
 Mem.load Mfloat32 mb sb d=Some(Vsingle x) /\
 Mem.load Mfloat32 mb sb(d+4)=Some(Vsingle y) /\
 Mem.load Mfloat32 mb sb(d+8)=Some(Vsingle z) /\
 Mem.load Mint16unsigned mb sb 280=Some(Val.load_result Mint16unsigned(Vint status)).
Proof.
 split;[|split;[|split]].
 - erewrite Mem.load_store_other;[|exact ST|right;right;cbn;lia].
   erewrite Mem.load_store_other;[|exact ZS|right;left;cbn;lia].
   erewrite Mem.load_store_other;[|exact Y|right;left;cbn;lia].
   exact(Mem.load_store_same _ _ _ _ _ _ X).
 - erewrite Mem.load_store_other;[|exact ST|right;right;cbn;lia].
   erewrite Mem.load_store_other;[|exact ZS|right;left;cbn;lia].
   exact(Mem.load_store_same _ _ _ _ _ _ Y).
 - erewrite Mem.load_store_other;[|exact ST|right;right;cbn;lia].
   exact(Mem.load_store_same _ _ _ _ _ _ ZS).
 - exact(Mem.load_store_same _ _ _ _ _ _ ST).
Qed.

Lemma four_store_bytes:Mem.loadbytes mb sb d 12=Some(vector_bytes x y z).
Proof.
 assert(BX:Mem.loadbytes mb sb d 4=Some(encode_val Mfloat32(Vsingle x))).
 { erewrite Mem.loadbytes_store_other;[|exact ST|right;right;right;cbn;lia].
   erewrite Mem.loadbytes_store_other;[|exact ZS|right;right;left;cbn;lia].
   erewrite Mem.loadbytes_store_other;[|exact Y|right;right;left;cbn;lia].
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ X). }
 assert(BY:Mem.loadbytes mb sb(d+4)4=Some(encode_val Mfloat32(Vsingle y))).
 { erewrite Mem.loadbytes_store_other;[|exact ST|right;right;right;cbn;lia].
   erewrite Mem.loadbytes_store_other;[|exact ZS|right;right;left;cbn;lia].
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ Y). }
 assert(BZ:Mem.loadbytes mb sb(d+8)4=Some(encode_val Mfloat32(Vsingle z))).
 { erewrite Mem.loadbytes_store_other;[|exact ST|right;right;right;cbn;lia].
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ ZS). }
 unfold vector_bytes.
 change(Mem.loadbytes mb sb d(4+8)=Some(encode_val Mfloat32(Vsingle x)++
 (encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z)))).
 apply Mem.loadbytes_concat;try lia;[exact BX|].
 replace 8 with(4+4)by lia;apply Mem.loadbytes_concat;try lia;[exact BY|].
 replace(d+4+4)with(d+8)by lia;exact BZ.
Qed.
Lemma four_store_input:forall src,src<>sb ->vector_read m src x y z ->vector_read mb src x y z.
Proof.
 intros src NE[A[B C]];unfold vector_read;repeat split.
 all:erewrite Mem.load_store_other;[|exact ST|left;exact NE].
 all:erewrite Mem.load_store_other;[|exact ZS|left;exact NE].
 all:erewrite Mem.load_store_other;[|exact Y|left;exact NE].
 all:erewrite Mem.load_store_other;[|exact X|left;exact NE].
 all:assumption.
Qed.
Lemma four_store_permissions:forall b ofs k p,Mem.perm m b ofs k p<->Mem.perm mb b ofs k p.
Proof.
 intros;rewrite<-(store_perm_iff _ _ _ _ _ _ ST),<-(store_perm_iff _ _ _ _ _ _ ZS),
 <-(store_perm_iff _ _ _ _ _ _ Y),<-(store_perm_iff _ _ _ _ _ _ X);reflexivity.
Qed.
Lemma four_store_frame:forall b ofs n,0<=n ->
 (forall i,ofs<=i<ofs+n ->~write_byte sb d b i) ->
 Mem.loadbytes mb b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros b ofs n N MISS.
 assert(MS:forall w k,280<=w /\w+k<=282 \/d<=w /\w+k<=d+12 ->
 b<>sb \/forall i,ofs<=i<ofs+n ->~(w<=i<w+k)).
 { intros w k R;destruct(peq b sb)as[EQ|NE];[right|auto].
   subst b;intros i I W;apply(MISS i I);split;[reflexivity|destruct R;lia]. }
 erewrite store_bytes_frame;[|exact ST|exact N|apply MS;left;cbn;lia].
 erewrite store_bytes_frame;[|exact ZS|exact N|apply MS;right;cbn;lia].
 erewrite store_bytes_frame;[|exact Y|exact N|apply MS;right;cbn;lia].
 erewrite store_bytes_frame;[|exact X|exact N|apply MS;right;cbn;lia].
 reflexivity.
Qed.
End EFFECTS.
Print Assumptions four_store_words.
Print Assumptions four_store_bytes.
Print Assumptions four_store_frame.
