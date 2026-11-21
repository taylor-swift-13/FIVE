From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
From StateSpeedSetterSupport Require Import MemoryFacts.
Import ListNotations.
Open Scope Z_scope.

Definition zeros:list memval:=repeat(Byte Byte.zero)656.
Record Preparation(m mf:mem)(sb before:block):Prop:={
 zero_memory:mem;
 filter_memory:mem;
 snapshot:list memval;
 zero_store:Mem.storebytes m sb 0 zeros=Some zero_memory;
 filter_store:Mem.store Mint16unsigned zero_memory sb 282(Vint(Int.repr 65535))=Some filter_memory;
 snapshot_read:Mem.loadbytes filter_memory sb 0 656=Some snapshot;
 snapshot_store:Mem.storebytes filter_memory before 0 snapshot=Some mf
}.
Lemma zeros_length:Z.of_nat(length zeros)=656.
Proof. reflexivity. Qed.
Lemma prepare_exists:forall m sb before,
 Mem.range_perm m sb 0 656 Cur Writable ->
 Mem.range_perm m before 0 656 Cur Writable ->
 exists mf,Preparation m mf sb before.
Proof.
 intros m sb before SW BW.
 destruct(Mem.range_perm_storebytes m sb 0 zeros)as[mz ZERO].
 { rewrite zeros_length;exact SW. }
 assert(ZPERM:forall b ofs k p,Mem.perm m b ofs k p ->Mem.perm mz b ofs k p).
 { intros;eapply Mem.perm_storebytes_1;eauto. }
 destruct(Mem.valid_access_store mz Mint16unsigned sb 282(Vint(Int.repr 65535)))as[ma FILTER].
 { eapply range_access with(n:=656);try lia.
   - intros i R;apply ZPERM;apply SW;exact R.
   - exists 141;reflexivity. }
 assert(APER:forall b ofs k p,Mem.perm m b ofs k p ->Mem.perm ma b ofs k p).
 { intros;eapply Mem.perm_store_1;[exact FILTER|];apply ZPERM;assumption. }
 destruct(Mem.range_perm_loadbytes ma sb 0 656)as[bytes READ].
 { intros i R;eapply Mem.perm_implies;[apply APER;apply SW;exact R|constructor]. }
 destruct(Mem.range_perm_storebytes ma before 0 bytes)as[mf COPY].
 { pose proof(Mem.loadbytes_length _ _ _ _ _ READ)as LEN.
   rewrite LEN;change(0+Z.of_nat(Z.to_nat 656))with 656.
   intros i R;apply APER;apply BW;exact R. }
 exists mf;exact(Build_Preparation m mf sb before mz ma bytes ZERO FILTER READ COPY).
Qed.

Section PREPARED.
Variables(m mf:mem)(sb before:block)(P:Preparation m mf sb before).
Lemma prepare_permissions:forall b ofs k p,
 Mem.perm m b ofs k p <->Mem.perm mf b ofs k p.
Proof.
 destruct P as[mz ma bytes ZERO FILTER READ COPY];intros;split;intro H.
 - eapply Mem.perm_storebytes_1;[exact COPY|];eapply Mem.perm_store_1;[exact FILTER|].
   eapply Mem.perm_storebytes_1;eauto.
 - eapply Mem.perm_storebytes_2;[exact ZERO|];eapply Mem.perm_store_2;[exact FILTER|].
   eapply Mem.perm_storebytes_2;eauto.
Qed.
Lemma prepare_source:forall chunk b ofs,b<>sb ->b<>before ->
 Mem.load chunk mf b ofs=Mem.load chunk m b ofs.
Proof.
 destruct P as[mz ma bytes ZERO FILTER READ COPY];intros chunk b ofs NS NB.
 rewrite(Mem.load_storebytes_other _ _ _ _ _ COPY chunk b ofs)by auto.
 rewrite(Mem.load_store_other _ _ _ _ _ _ FILTER chunk b ofs)by auto.
 apply Mem.load_storebytes_other with(bytes:=zeros);auto.
Qed.
Lemma prepare_filter:sb<>before ->
 Mem.load Mint16unsigned mf sb 282=Some(Vint(Int.repr 65535)).
Proof.
 destruct P as[mz ma bytes ZERO FILTER READ COPY];intro NE.
 rewrite(Mem.load_storebytes_other _ _ _ _ _ COPY Mint16unsigned sb 282)by auto.
 rewrite(Mem.load_store_same _ _ _ _ _ _ FILTER);reflexivity.
Qed.
Lemma prepare_snapshot:sb<>before ->
 Mem.loadbytes mf before 0 656=Mem.loadbytes mf sb 0 656.
Proof.
 destruct P as[mz ma bytes ZERO FILTER READ COPY];intro NE.
 pose proof(Mem.loadbytes_length _ _ _ _ _ READ)as LEN.
 assert(LZ:Z.of_nat(length bytes)=656)by(rewrite LEN;reflexivity).
 rewrite<-(LZ)at 1;rewrite(Mem.loadbytes_storebytes_same _ _ _ _ _ COPY).
 rewrite(Mem.loadbytes_storebytes_other _ _ _ _ _ COPY sb 0 656)by(auto;lia).
 exact(eq_sym READ).
Qed.
End PREPARED.
Print Assumptions prepare_exists.
