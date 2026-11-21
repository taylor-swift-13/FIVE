From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Memdata.
Import ListNotations.
Open Scope Z_scope.
Definition is_byte(mv:memval):Prop:=exists b,mv=Byte b.
Definition defined_range(m:mem)(b:block)(lo hi:Z):Prop:=
 forall i,lo<=i<hi ->exists octet,Mem.loadbytes m b i 1=Some[Byte octet].
Lemma inj_bytes_defined:forall bytes,Forall is_byte(inj_bytes bytes).
Proof. intros;unfold inj_bytes;apply Forall_forall;intros mv IN;apply in_map_iff in IN;destruct IN as[b[EQ IN]];exists b;congruence. Qed.
Local Transparent Mem.loadbytes.
Lemma loadbytes_defined:forall m b ofs n bytes,
 Mem.loadbytes m b ofs n=Some bytes ->Forall is_byte bytes ->defined_range m b ofs(ofs+n).
Proof.
 intros m b ofs n bytes LOAD DEFINED i R.
 unfold Mem.loadbytes in LOAD;destruct(Mem.range_perm_dec m b ofs(ofs+n)Cur Readable)as[RP|NP];try discriminate.
 injection LOAD as EQ;subst bytes.
 rewrite Forall_forall in DEFINED.
 assert(IN:In(ZMap.get i(PMap.get b(Mem.mem_contents m)))(Mem.getN(Z.to_nat n)ofs(PMap.get b(Mem.mem_contents m)))).
 { apply Mem.getN_in;rewrite Z2Nat.id by lia;exact R. }
 destruct(DEFINED _ IN)as[octet BYTE];exists octet.
 unfold Mem.loadbytes;rewrite pred_dec_true.
 - change(Some[ZMap.get i(PMap.get b(Mem.mem_contents m))]=Some[Byte octet]);rewrite BYTE;reflexivity.
 - intros j J;apply RP;lia.
Qed.
Lemma defined_storebytes:forall m mf db ofs bytes sb lo hi,
 Mem.storebytes m db ofs bytes=Some mf ->Forall is_byte bytes ->
 defined_range m sb lo hi ->defined_range mf sb lo hi.
Proof.
 intros m mf db ofs bytes sb lo hi STORE BDEF OLD i R.
 destruct(peq sb db)as[EQ|NE].
 - subst sb;destruct(Z_le_dec ofs i)as[LEFT|LEFT];destruct(Z_lt_dec i(ofs+Z.of_nat(length bytes)))as[RIGHT|RIGHT].
   + eapply loadbytes_defined;[exact(Mem.loadbytes_storebytes_same _ _ _ _ _ STORE)|exact BDEF|lia].
   + destruct(OLD i R)as[octet BYTE];exists octet;erewrite Mem.loadbytes_storebytes_other;[exact BYTE|exact STORE|lia|right;right;lia].
   + destruct(OLD i R)as[octet BYTE];exists octet;erewrite Mem.loadbytes_storebytes_other;[exact BYTE|exact STORE|lia|right;left;lia].
   + destruct(OLD i R)as[octet BYTE];exists octet;erewrite Mem.loadbytes_storebytes_other;[exact BYTE|exact STORE|lia|right;left;lia].
 - destruct(OLD i R)as[octet BYTE];exists octet;erewrite Mem.loadbytes_storebytes_other;[exact BYTE|exact STORE|lia|left;exact NE].
Qed.
Lemma defined_int16_store:forall m mf b ofs v sb lo hi,
 Mem.store Mint16unsigned m b ofs(Vint v)=Some mf ->defined_range m sb lo hi ->defined_range mf sb lo hi.
Proof.
 intros;eapply defined_storebytes;[eapply Mem.store_storebytes;exact H|apply inj_bytes_defined|exact H0].
Qed.
Lemma defined_range_loadint:forall m b lo hi i,
 defined_range m b lo hi ->lo<=i<hi ->exists v,Mem.load Mint8unsigned m b i=Some(Vint v).
Proof.
 intros m b lo hi i DEFINED R;destruct(DEFINED i R)as[octet BYTE].
 exists(Int.zero_ext 8(Int.repr(decode_int[octet]))).
 exact(Mem.loadbytes_load Mint8unsigned m b i[Byte octet]BYTE(Z.divide_1_l i)).
Qed.
Lemma defined_range_from_int16:forall m b ofs v,
 Mem.load Mint16unsigned m b ofs=Some(Vint v) ->defined_range m b ofs(ofs+2).
Proof.
 intros m b ofs v LOAD;destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[bytes[READ DECODE]].
 eapply loadbytes_defined;[exact READ|].
 unfold decode_val in DECODE;destruct(proj_bytes bytes)as[bl|]eqn:PROJ;try discriminate.
 rewrite(inj_proj_bytes _ _ PROJ);apply inj_bytes_defined.
Qed.
Lemma equal_byte_comparison:forall m b1 b2 i,
 Mem.loadbytes m b1 i 1=Mem.loadbytes m b2 i 1 ->
 (exists octet,Mem.loadbytes m b1 i 1=Some[Byte octet]) ->
 exists v,Mem.load Mint8unsigned m b1 i=Some(Vint v) /\
 Mem.load Mint8unsigned m b2 i=Some(Vint v) /\
 Val.cmpu_bool(Mem.valid_pointer m)Ceq(Vint v)(Vint v)=Some true.
Proof.
 intros m b1 b2 i EQ[octet BYTE].
 exists(Int.zero_ext 8(Int.repr(decode_int[octet])));split.
 - exact(Mem.loadbytes_load Mint8unsigned m b1 i[Byte octet]BYTE(Z.divide_1_l i)).
 - split.
   + apply(Mem.loadbytes_load Mint8unsigned m b2 i[Byte octet]);[change(Mem.loadbytes m b2 i 1=Some[Byte octet]);rewrite<-EQ;exact BYTE|apply Z.divide_1_l].
   + cbn;rewrite Int.eq_true;reflexivity.
Qed.
