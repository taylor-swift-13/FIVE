From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Memdata.
From StateSpeedSetterSupport Require Import MemoryFacts DefinedBytes.
Import ListNotations.
Open Scope Z_scope.

Definition zeros:list memval:=repeat(Byte Byte.zero)656.
Inductive Preparation(m mf:mem)(sb before:block):Prop:=
 Build_Preparation:forall zero_memory filter_memory snapshot,
 Mem.storebytes m sb 0 zeros=Some zero_memory ->
 Mem.store Mint16unsigned zero_memory sb 282(Vint(Int.repr 65535))=Some filter_memory ->
 Mem.loadbytes filter_memory sb 0 656=Some snapshot ->
 Mem.storebytes filter_memory before 0 snapshot=Some mf ->Preparation m mf sb before.
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
 { eapply range_access with(n:=656).
   - intros i R;apply ZPERM;apply SW;exact R.
   - lia.
   - change(282+2<=656);lia.
   - change(2|282);exists 141;reflexivity. }
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
 exact(Mem.load_storebytes_other m sb 0 zeros mz ZERO chunk b ofs(or_introl NS)).
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
Lemma getN_equal_inside:forall n start c1 c2,
 Mem.getN n start c1=Mem.getN n start c2 ->forall ofs,
 start<=ofs<start+Z.of_nat n ->ZMap.get ofs c1=ZMap.get ofs c2.
Proof.
 induction n;intros start c1 c2 SAME ofs R;[cbn in R;lia|].
 cbn in SAME;injection SAME as HEAD TAIL.
 destruct(Z.eq_dec ofs start)as[EQ|NE];[subst ofs;exact HEAD|].
 apply(IHn _ _ _ TAIL ofs);rewrite Nat2Z.inj_succ in R;lia.
Qed.
Local Transparent Mem.loadbytes.
Lemma equal_snapshot_slice:forall m b1 b2 n,
 Mem.range_perm m b1 0 n Cur Readable ->
 Mem.range_perm m b2 0 n Cur Readable ->
 Mem.loadbytes m b1 0 n=Mem.loadbytes m b2 0 n ->
 forall ofs len,0<=ofs ->0<=len ->ofs+len<=n ->
 Mem.loadbytes m b1 ofs len=Mem.loadbytes m b2 ofs len.
Proof.
 intros m b1 b2 n R1 R2 EQ ofs len O L END.
 unfold Mem.loadbytes in EQ|-*.
 rewrite!pred_dec_true in EQ by assumption;injection EQ as CONTENT.
 rewrite!pred_dec_true by(intros i R;first[apply R1|apply R2];lia).
 f_equal;apply Mem.getN_exten;intros i R.
 apply(getN_equal_inside _ _ _ _ CONTENT i).
 rewrite!Z2Nat.id in * by lia;lia.
Qed.
Print Assumptions prepare_exists.

Lemma prepare_defined:forall m mf sb before,
 Preparation m mf sb before ->sb<>before ->
 Mem.range_perm m sb 0 656 Cur Writable ->Mem.range_perm m before 0 656 Cur Writable ->
 defined_range mf sb 0 656 /\defined_range mf before 0 656.
Proof.
 intros m mf sb before PREP NE SW BW.
 pose proof(prepare_permissions m mf sb before PREP)as PERMS.
 pose proof(prepare_snapshot m mf sb before PREP NE)as SNAP.
 destruct PREP as[mz ma bytes ZERO FILTER READ COPY].
 assert(ZDEF:defined_range mz sb 0 656).
 { replace 656 with(0+Z.of_nat(length zeros))by(rewrite zeros_length;lia).
   eapply loadbytes_defined;[exact(Mem.loadbytes_storebytes_same _ _ _ _ _ ZERO)|].
   apply Forall_forall;intros mv IN;unfold zeros in IN;apply repeat_spec in IN;exists Byte.zero;exact IN. }
 assert(ADEF:defined_range ma sb 0 656)by(eapply defined_int16_store;[exact FILTER|exact ZDEF]).
 assert(FDEF:defined_range mf sb 0 656).
 { intros i R;destruct(ADEF i R)as[octet BYTE];exists octet.
   rewrite(Mem.loadbytes_storebytes_other _ _ _ _ _ COPY sb i 1)by(auto;lia);exact BYTE. }
 split;[exact FDEF|];intros i R;destruct(FDEF i R)as[octet BYTE];exists octet.
 rewrite(equal_snapshot_slice mf before sb 656 ltac:(intros j J;eapply Mem.perm_implies;[apply(proj1(PERMS before j Cur Writable));apply BW;exact J|constructor])
 ltac:(intros j J;eapply Mem.perm_implies;[apply(proj1(PERMS sb j Cur Writable));apply SW;exact J|constructor])SNAP i 1 ltac:(lia)ltac:(lia)ltac:(lia));exact BYTE.
Qed.
Print Assumptions prepare_defined.
