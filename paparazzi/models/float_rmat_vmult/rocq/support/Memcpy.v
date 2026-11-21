From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs.
Import ListNotations.
Local Open Scope Z_scope.
Record CopyPre(m:mem)(src dst:block):Prop := {
 copy_separated:src<>dst;
 copy_readable:Mem.range_perm m src 0 12 Cur Readable;
 copy_writable:Mem.range_perm m dst 0 12 Cur Writable
}.
Record MemcpySafety(m:mem)(src dst:block):Prop := {
 pointer_1:src<>dst;
 pointer_arithmetic_1:Mem.valid_pointer m src 0=true;
 pointer_arithmetic_2:Mem.weak_valid_pointer m dst 12=true;
 pointer_2:dst<>src;
 pointer_arithmetic_3:Mem.valid_pointer m dst 0=true;
 pointer_arithmetic_4:Mem.weak_valid_pointer m src 12=true;
 precondition_1:src<>dst \/ 0+12<=0 \/0+12<=0;
 precondition_2:Mem.range_perm m src 0 12 Cur Readable;
 precondition_3:Mem.range_perm m dst 0 12 Cur Writable
}.
Definition CopyFrame(m mf:mem)(dst:block):Prop :=forall b ofs n,
 b<>dst \/ofs+n<=0 \/12<=ofs ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Lemma copy_pre_safety:forall m src dst,CopyPre m src dst->MemcpySafety m src dst.
Proof.
 intros m src dst[NE RD WR];constructor;auto.
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply RD;lia|constructor].
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply WR;change(0<=12-1<12);lia|constructor].
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply WR;lia|constructor].
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply RD;change(0<=12-1<12);lia|constructor].
Qed.
Theorem copy12_exact:forall se m src dst,CopyPre m src dst->
 exists mf bytes,MemcpySafety m src dst /\Mem.loadbytes m src 0 12=Some bytes /\length bytes=12%nat /\
 Mem.storebytes m dst 0 bytes=Some mf /\
 extcall_memcpy_sem 12 1 se[Vptr dst Ptrofs.zero;Vptr src Ptrofs.zero]m E0 Vundef mf /\
 Mem.loadbytes mf dst 0 12=Some bytes /\CopyFrame m mf dst.
Proof.
 intros se m src dst P;destruct(Mem.range_perm_loadbytes m src 0 12(copy_readable _ _ _ P))as[bytes READ].
 pose proof(Mem.loadbytes_length _ _ _ _ _ READ)as LEN;change(length bytes=12%nat)in LEN.
 assert(W:Mem.range_perm m dst 0(0+Z.of_nat(length bytes))Cur Writable)by(rewrite LEN;exact(copy_writable _ _ _ P)).
 destruct(Mem.range_perm_storebytes _ _ _ _ W)as[mf STORE].
 exists mf,bytes;split;[apply copy_pre_safety;exact P|];split;[exact READ|];split;[exact LEN|];split;[exact STORE|];split.
 - econstructor;try rewrite Ptrofs.unsigned_zero;try exact READ;try exact STORE;try(left;reflexivity);try lia;try(exists 12;reflexivity);try(intros;exists 0;reflexivity);left;exact(copy_separated _ _ _ P).
 - split.
   + pose proof(Mem.loadbytes_storebytes_same _ _ _ _ _ STORE)as H;rewrite LEN in H;exact H.
   + intros b ofs n OUT;destruct(zle n 0).
     * repeat rewrite Mem.loadbytes_empty by assumption;reflexivity.
     * eapply Mem.loadbytes_storebytes_other;[exact STORE|lia|];rewrite LEN;exact OUT.
Qed.
Lemma copy12_preserves_pre:forall m mf changed src dst bytes,
 Mem.storebytes m changed 0 bytes=Some mf->src<>changed->dst<>changed->CopyPre m src dst->CopyPre mf src dst.
Proof. intros m mf changed src dst bytes ST SC DC[NE RD WR];constructor;auto.
 - intros z B;eapply Mem.perm_storebytes_1;[exact ST|apply RD;exact B].
 - intros z B;eapply Mem.perm_storebytes_1;[exact ST|apply WR;exact B]. Qed.
Theorem two_copy12_exact:forall se m sa da sb db,
 CopyPre m sa da->CopyPre m sb db->sb<>da->db<>da->
 exists ma mb ba bb,MemcpySafety m sa da /\MemcpySafety ma sb db /\
 Mem.loadbytes m sa 0 12=Some ba /\Mem.loadbytes ma sb 0 12=Some bb /\
 Mem.storebytes m da 0 ba=Some ma /\Mem.storebytes ma db 0 bb=Some mb /\
 extcall_memcpy_sem 12 1 se[Vptr da Ptrofs.zero;Vptr sa Ptrofs.zero]m E0 Vundef ma /\
 extcall_memcpy_sem 12 1 se[Vptr db Ptrofs.zero;Vptr sb Ptrofs.zero]ma E0 Vundef mb /\
 Mem.loadbytes mb da 0 12=Some ba /\Mem.loadbytes mb db 0 12=Some bb /\
 CopyFrame m ma da /\CopyFrame ma mb db.
Proof.
 intros se m sa da sb db PA PB SD DD.
 destruct(copy12_exact se m sa da PA)as[ma[ba[SAFEA[RA[LA[SA[CA[BA FA]]]]]]]].
 assert(PB':CopyPre ma sb db)by(eapply copy12_preserves_pre;eauto).
 destruct(copy12_exact se ma sb db PB')as[mb[bb[SAFEB[RB[LB[SB[CB[BB FB]]]]]]]].
 exists ma,mb,ba,bb;split;[exact SAFEA|];split;[exact SAFEB|];split;[exact RA|];split;[exact RB|];split;[exact SA|];split;[exact SB|];split;[exact CA|];split;[exact CB|];split.
 - rewrite(FB da 0 12 ltac:(left;congruence));exact BA.
 - split;[exact BB|];split;assumption.
Qed.
Lemma append_cut:forall(A:Type)(a b c d:list A),length a=length c->a++b=c++d->a=c /\b=d.
Proof.
 intros A a;induction a as[|x a IH];intros b c d LEN EQ;destruct c as[|y c];simpl in LEN;try discriminate.
 - simpl in EQ;auto.
 - simpl in EQ;injection EQ as XY EQ;subst y;destruct(IH b c d ltac:(lia)EQ)as[-> ->];auto.
Qed.
Theorem vector_bytes_loads:forall m b x y z,
 Mem.loadbytes m b 0 12=Some(encode_val Mfloat32(Vsingle x)++encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z))->
 Mem.load Mint32 m b 0=Some(Vint(Float32.to_bits x)) /\
 Mem.load Mint32 m b 4=Some(Vint(Float32.to_bits y)) /\
 Mem.load Mint32 m b 8=Some(Vint(Float32.to_bits z)).
Proof.
 intros m b x y z BYTES.
 destruct(Mem.loadbytes_split m b 0 4 8 _ BYTES ltac:(lia)ltac:(lia))as[a[rest[A[REST EQ]]]].
 pose proof(Mem.loadbytes_length _ _ _ _ _ A)as LA.
 assert(LX:length(encode_val Mfloat32(Vsingle x))=4%nat)by(rewrite encode_val_length;reflexivity).
 destruct(append_cut _ a rest(encode_val Mfloat32(Vsingle x))(encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z))ltac:(change(length a=4%nat)in LA;lia)(eq_sym EQ))as[-> EREST].
 change(Mem.loadbytes m b 4(4+4)=Some rest)in REST.
 destruct(Mem.loadbytes_split m b 4 4 4 _ REST ltac:(lia)ltac:(lia))as[c[d[C[D EQ2]]]].
 assert(ED:encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z)=c++d)by(congruence).
 pose proof(Mem.loadbytes_length _ _ _ _ _ C)as LC.
 assert(LY:length(encode_val Mfloat32(Vsingle y))=4%nat)by(rewrite encode_val_length;reflexivity).
 destruct(append_cut _ c d(encode_val Mfloat32(Vsingle y))(encode_val Mfloat32(Vsingle z))ltac:(change(length c=4%nat)in LC;lia)(eq_sym ED))as[-> ->].
 pose proof(Mem.loadbytes_load Mint32 m b 0 _ A(ex_intro _ 0 eq_refl))as AX.
 pose proof(Mem.loadbytes_load Mint32 m b 4 _ C(ex_intro _ 1 eq_refl))as AY.
 pose proof(Mem.loadbytes_load Mint32 m b 8 _ D(ex_intro _ 2 eq_refl))as AZ.
 pose proof(decode_encode_val_general(Vsingle x)Mfloat32 Mint32)as EX.
 pose proof(decode_encode_val_general(Vsingle y)Mfloat32 Mint32)as EY.
 pose proof(decode_encode_val_general(Vsingle z)Mfloat32 Mint32)as EZ.
 change(decode_val Mint32(encode_val Mfloat32(Vsingle x))=Vint(Float32.to_bits x))in EX.
 change(decode_val Mint32(encode_val Mfloat32(Vsingle y))=Vint(Float32.to_bits y))in EY.
 change(decode_val Mint32(encode_val Mfloat32(Vsingle z))=Vint(Float32.to_bits z))in EZ.
 rewrite EX in AX;rewrite EY in AY;rewrite EZ in AZ;auto.
Qed.
Print Assumptions copy12_exact.
Print Assumptions two_copy12_exact.
Print Assumptions vector_bytes_loads.
