From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Cexec Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
Import ListNotations.
Open Scope Z_scope.
Inductive raw_writes (allowed:block->Prop):mem->mem->Prop:=
| raw_writes_refl:forall m,raw_writes allowed m m
| raw_writes_store:forall m ma mf ch b ofs v,allowed b ->Mem.store ch m b ofs v=Some ma ->raw_writes allowed ma mf ->raw_writes allowed m mf
| raw_writes_bytes:forall m ma mf b ofs bytes,allowed b ->Mem.storebytes m b ofs bytes=Some ma ->raw_writes allowed ma mf ->raw_writes allowed m mf.
Lemma raw_writes_perm:forall P m mf,raw_writes P m mf ->forall b o k p,Mem.perm m b o k p<->Mem.perm mf b o k p.
Proof. intros P m mf H;induction H;intros;[tauto| |];rewrite<-IHraw_writes;split;intros.
 - eapply Mem.perm_store_1;eauto.
 - eapply Mem.perm_store_2;eauto.
 - eapply Mem.perm_storebytes_1;eauto.
 - eapply Mem.perm_storebytes_2;eauto.
Qed.
Lemma raw_writes_load_frame:forall P m mf,raw_writes P m mf ->forall ch b ofs,~P b ->Mem.load ch mf b ofs=Mem.load ch m b ofs.
Proof. intros P m mf H;induction H;intros;[reflexivity| |];rewrite IHraw_writes by assumption.
 - eapply Mem.load_store_other;[exact H0|left;intro;subst;contradiction].
 - eapply Mem.load_storebytes_other;[exact H0|left;intro;subst;contradiction].
Qed.
Lemma raw_writes_bytes_frame:forall P m mf,raw_writes P m mf ->forall b ofs n,~P b ->0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof. intros P m mf H;induction H;intros;[reflexivity| |];rewrite IHraw_writes by assumption.
 - eapply Mem.loadbytes_store_other;[exact H0|left;intro;subst;contradiction].
 - eapply Mem.loadbytes_storebytes_other;[exact H0|lia|left;intro;subst;contradiction].
Qed.
Lemma raw_writes_range:forall P m mf,raw_writes P m mf ->forall b lo hi k p,Mem.range_perm m b lo hi k p ->Mem.range_perm mf b lo hi k p.
Proof. intros P m mf H b lo hi k p RP ofs R;apply(proj1(raw_writes_perm P m mf H b ofs k p));apply RP;exact R. Qed.
Lemma scalar_access_inside:forall m ch b n ofs p,Mem.range_perm m b 0 n Cur p ->0<=ofs ->ofs+size_chunk ch<=n ->(align_chunk ch|ofs) ->Mem.valid_access m ch b ofs p.
Proof. intros;split;[red;intros;apply H;lia|assumption]. Qed.
Lemma same_prefix_length:forall(A:Type)(p q r s:list A),length p=length r ->p++q=r++s ->p=r /\ q=s.
Proof. intros A p;induction p;intros q r s L E;destruct r;simpl in *;try discriminate.
 - auto.
 - injection E as X Y;subst;injection L as L;destruct(IHp _ _ _ L Y);subst;auto.
Qed.
Lemma loadbytes_equal_subrange:forall a b ba bb oa ob n bytes delta len,
 Mem.loadbytes a ba oa n=Some bytes ->Mem.loadbytes b bb ob n=Some bytes ->
 0<=delta ->0<=len ->delta+len<=n ->
 Mem.loadbytes a ba(oa+delta)len=Mem.loadbytes b bb(ob+delta)len.
Proof.
 intros a b ba bb oa ob n bytes d len LA LB D L B.
 replace n with(d+(n-d))in LA,LB by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ LA ltac:(lia) ltac:(lia))as[ap[aq[AP[AQ AE]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ LB ltac:(lia) ltac:(lia))as[bp[bq[BP[BQ BE]]]].
 assert(LP:length ap=length bp).
 { erewrite Mem.loadbytes_length by exact AP;erewrite Mem.loadbytes_length by exact BP;reflexivity. }
 destruct(same_prefix_length _ ap aq bp bq LP ltac:(congruence))as[_ QE];subst bq.
 replace(n-d)with(len+(n-d-len))in AQ,BQ by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ AQ ltac:(lia) ltac:(lia))as[ar[asuf[AR[AS ABE]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ BQ ltac:(lia) ltac:(lia))as[br[bsuf[BR[BS BBE]]]].
 assert(LR:length ar=length br).
 { erewrite Mem.loadbytes_length by exact AR;erewrite Mem.loadbytes_length by exact BR;reflexivity. }
 destruct(same_prefix_length _ ar asuf br bsuf LR ltac:(congruence));subst br;congruence.
Qed.
Lemma copy_typed_load:forall m mf src dst so dofs n bytes ch delta v,
 Mem.loadbytes m src so n=Some bytes ->Mem.storebytes m dst dofs bytes=Some mf ->
 Mem.load ch m src(so+delta)=Some v ->
 0<=delta ->delta+size_chunk ch<=n ->(align_chunk ch|dofs+delta) ->
 Mem.load ch mf dst(dofs+delta)=Some v.
Proof.
 intros m mf src dst so dofs n bytes ch d v LB ST LOAD D B A.
 assert(LEN:Z.of_nat(length bytes)=n).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ LB)as H;rewrite H,Z2Nat.id;[reflexivity|pose proof(size_chunk_pos ch);lia]. }
 assert(POST:Mem.loadbytes mf dst dofs n=Some bytes).
 { rewrite<-LEN;eapply Mem.loadbytes_storebytes_same;exact ST. }
 destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[active[AL DEC]].
 assert(SUB:Mem.loadbytes mf dst(dofs+d)(size_chunk ch)=Some active).
 { rewrite<-(loadbytes_equal_subrange m mf src dst so dofs n bytes d(size_chunk ch)LB POST D ltac:(pose proof(size_chunk_pos ch);lia)B);exact AL. }
 rewrite DEC;eapply Mem.loadbytes_load;eauto.
Qed.
Print Assumptions copy_typed_load.

Lemma raw_writes_trans:forall P m ma mf,raw_writes P m ma ->raw_writes P ma mf ->raw_writes P m mf.
Proof. intros P m ma mf H;induction H;intros;[assumption|eapply raw_writes_store;eauto|eapply raw_writes_bytes;eauto]. Qed.
Definition factory_trace (m:mem)(bs src ret:block)(o:ptrofs)(h:int)(mf:mem):Prop:=
 exists m1 m2 m3 m4 m5 m6 m7 vecbytes spbytes,
 Mem.store Mint32 m bs 0(Vint(Int.repr 2))=Some m1 /\
 Mem.store Mint32 m1 bs 4(Vint Int.zero)=Some m2 /\
 Mem.loadbytes m2 src(Ptrofs.unsigned o)8=Some vecbytes /\
 Mem.storebytes m2 bs 8 vecbytes=Some m3 /\
 Mem.store Mint32 m3 bs 16(Vint h)=Some m4 /\
 Mem.store Mint32 m4 bs 24(Vint Int.zero)=Some m5 /\
 Mem.store Mint32 m5 bs 28(Vint Int.zero)=Some m6 /\
 Mem.store Mint32 m6 bs 32(Vint Int.zero)=Some m7 /\
 Mem.loadbytes m7 bs 0 36=Some spbytes /\
 Mem.storebytes m7 ret 0 spbytes=Some mf.
Theorem factory_trace_exists:forall m bs src ret o h,
 Mem.range_perm m bs 0 36 Cur Writable ->
 Mem.range_perm m src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,factory_trace m bs src ret o h mf.
Proof.
 intros m bs src ret o h WSP RV WR.
 assert(A1:Mem.valid_access m Mint32 bs 0 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(0+4<=36);lia|change(4|0);exists 0;reflexivity].
   eapply raw_writes_range;[exact(raw_writes_refl(fun b=>b=bs)m)|exact WSP]. }
 destruct(Mem.valid_access_store m Mint32 bs 0(Vint(Int.repr 2))A1)as[m1 ST1].
 assert(RW1:raw_writes(fun b=>b=bs)m m1).
 { eapply raw_writes_trans;[constructor|eapply raw_writes_store;[reflexivity|exact ST1|constructor]]. }
 assert(A2:Mem.valid_access m1 Mint32 bs 4 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(4+4<=36);lia|change(4|4);exists 1;reflexivity].
   eapply raw_writes_range;[exact RW1|exact WSP]. }
 destruct(Mem.valid_access_store m1 Mint32 bs 4(Vint(Int.zero))A2)as[m2 ST2].
 assert(RW2:raw_writes(fun b=>b=bs)m m2).
 { eapply raw_writes_trans;[exact RW1|eapply raw_writes_store;[reflexivity|exact ST2|constructor]]. }
 destruct(Mem.range_perm_loadbytes m2 src(Ptrofs.unsigned o)8 ltac:(eapply raw_writes_range;[exact RW2|exact RV]))as[vecbytes VB].
 assert(VLEN:Z.of_nat(length vecbytes)=8).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ VB)as L;rewrite L;reflexivity. }
 destruct(Mem.range_perm_storebytes m2 bs 8 vecbytes ltac:(rewrite VLEN;intros x X;eapply(proj1(raw_writes_perm _ _ _ RW2 _ _ _ _));apply WSP;lia))as[m3 VST].
 assert(RW3:raw_writes(fun b=>b=bs)m m3).
 { eapply raw_writes_trans;[exact RW2|eapply raw_writes_bytes;[reflexivity|exact VST|constructor]]. }
 assert(A4:Mem.valid_access m3 Mint32 bs 16 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(16+4<=36);lia|change(4|16);exists 4;reflexivity].
   eapply raw_writes_range;[exact RW3|exact WSP]. }
 destruct(Mem.valid_access_store m3 Mint32 bs 16(Vint(h))A4)as[m4 ST4].
 assert(RW4:raw_writes(fun b=>b=bs)m m4).
 { eapply raw_writes_trans;[exact RW3|eapply raw_writes_store;[reflexivity|exact ST4|constructor]]. }
 assert(A5:Mem.valid_access m4 Mint32 bs 24 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(24+4<=36);lia|change(4|24);exists 6;reflexivity].
   eapply raw_writes_range;[exact RW4|exact WSP]. }
 destruct(Mem.valid_access_store m4 Mint32 bs 24(Vint(Int.zero))A5)as[m5 ST5].
 assert(RW5:raw_writes(fun b=>b=bs)m m5).
 { eapply raw_writes_trans;[exact RW4|eapply raw_writes_store;[reflexivity|exact ST5|constructor]]. }
 assert(A6:Mem.valid_access m5 Mint32 bs 28 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(28+4<=36);lia|change(4|28);exists 7;reflexivity].
   eapply raw_writes_range;[exact RW5|exact WSP]. }
 destruct(Mem.valid_access_store m5 Mint32 bs 28(Vint(Int.zero))A6)as[m6 ST6].
 assert(RW6:raw_writes(fun b=>b=bs)m m6).
 { eapply raw_writes_trans;[exact RW5|eapply raw_writes_store;[reflexivity|exact ST6|constructor]]. }
 assert(A7:Mem.valid_access m6 Mint32 bs 32 Writable).
 { eapply scalar_access_inside with(n:=36);[|lia|change(32+4<=36);lia|change(4|32);exists 8;reflexivity].
   eapply raw_writes_range;[exact RW6|exact WSP]. }
 destruct(Mem.valid_access_store m6 Mint32 bs 32(Vint(Int.zero))A7)as[m7 ST7].
 assert(RW7:raw_writes(fun b=>b=bs)m m7).
 { eapply raw_writes_trans;[exact RW6|eapply raw_writes_store;[reflexivity|exact ST7|constructor]]. }
 assert(RSP:Mem.range_perm m7 bs 0 36 Cur Readable).
 { intros x X;eapply Mem.perm_implies;[eapply(raw_writes_range _ _ _ RW7 _ _ _ _ _ WSP);exact X|constructor]. }
 destruct(Mem.range_perm_loadbytes m7 bs 0 36 RSP)as[spbytes SP].
 assert(SLEN:Z.of_nat(length spbytes)=36).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ SP)as L;rewrite L;reflexivity. }
 destruct(Mem.range_perm_storebytes m7 ret 0 spbytes ltac:(rewrite SLEN;exact(raw_writes_range _ _ _ RW7 _ _ _ _ _ WR)))as[mf COPY].
 exists mf;unfold factory_trace;exists m1,m2,m3,m4,m5,m6,m7,vecbytes,spbytes;repeat split;assumption.
Qed.
Print Assumptions factory_trace_exists.

Ltac scalar_frame :=
 repeat match goal with
 | ST:Mem.store ?ch ?before ?dst ?pos ?value=Some ?after |- context[Mem.load ?c ?after ?b ?o] =>
   first [rewrite(Mem.load_store_same _ _ _ _ _ _ ST);cbn[Val.load_result]|
          rewrite(Mem.load_store_other _ _ _ _ _ _ ST) by (first[left;congruence|right;cbn[size_chunk];lia])]
 | ST:Mem.storebytes ?before ?dst ?pos ?value=Some ?after |- context[Mem.load ?c ?after ?b ?o] =>
   rewrite(Mem.load_storebytes_other _ _ _ _ _ ST) by (first[left;congruence|right;cbn[size_chunk];lia])
 end.
Definition active_fields(m:mem)(ret:block)(x y h:int):Prop:=
 Mem.load Mint32 m ret 0=Some(Vint(Int.repr 2)) /\
 Mem.load Mint32 m ret 4=Some(Vint Int.zero) /\
 Mem.load Mint32 m ret 8=Some(Vint x) /\
 Mem.load Mint32 m ret 12=Some(Vint y) /\
 Mem.load Mint32 m ret 16=Some(Vint h) /\
 Mem.load Mint32 m ret 24=Some(Vint Int.zero) /\
 Mem.load Mint32 m ret 28=Some(Vint Int.zero) /\
 Mem.load Mint32 m ret 32=Some(Vint Int.zero).
Theorem factory_trace_active:forall m bs src ret o h mf x y,
 factory_trace m bs src ret o h mf ->src<>bs ->
 Mem.load Mint32 m src(Ptrofs.unsigned o)=Some(Vint x) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o+4)=Some(Vint y) ->
 active_fields mf ret x y h.
Proof.
 intros m bs src ret o h mf x y TRACE DS LX LY.
 destruct TRACE as(m1&m2&m3&m4&m5&m6&m7&vb&sb&T&F&V&VC&H&P&Q&R&BY&COPY).
 assert(X2:Mem.load Mint32 m2 src(Ptrofs.unsigned o+0)=Some(Vint x)).
 { replace(Ptrofs.unsigned o+0)with(Ptrofs.unsigned o)by lia;scalar_frame;exact LX. }
 assert(Y2:Mem.load Mint32 m2 src(Ptrofs.unsigned o+4)=Some(Vint y)).
 { scalar_frame;exact LY. }
 assert(X3:Mem.load Mint32 m3 bs 8=Some(Vint x)).
 { replace 8 with(8+0)by lia;eapply copy_typed_load;[exact V|exact VC|exact X2|lia|change(0+4<=8);lia|change(4|8+0);exists 2;reflexivity]. }
 assert(Y3:Mem.load Mint32 m3 bs 12=Some(Vint y)).
 { replace 12 with(8+4)by lia;eapply copy_typed_load;[exact V|exact VC|exact Y2|lia|change(4+4<=8);lia|change(4|8+4);exists 3;reflexivity]. }
 assert(LOCAL:active_fields m7 bs x y h).
 { unfold active_fields;repeat split;scalar_frame;try assumption;try reflexivity. }
 unfold active_fields in LOCAL|-*;destruct LOCAL as[L0[L4[L8[L12[L16[L24[L28 L32]]]]]]].
 repeat split.
 - replace 0 with(0+0)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L0|lia|change(0+4<=36);lia|change(4|0+0);exists 0;reflexivity].
 - replace 4 with(0+4)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L4|lia|change(4+4<=36);lia|change(4|0+4);exists 1;reflexivity].
 - replace 8 with(0+8)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L8|lia|change(8+4<=36);lia|change(4|0+8);exists 2;reflexivity].
 - replace 12 with(0+12)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L12|lia|change(12+4<=36);lia|change(4|0+12);exists 3;reflexivity].
 - replace 16 with(0+16)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L16|lia|change(16+4<=36);lia|change(4|0+16);exists 4;reflexivity].
 - replace 24 with(0+24)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L24|lia|change(24+4<=36);lia|change(4|0+24);exists 6;reflexivity].
 - replace 28 with(0+28)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L28|lia|change(28+4<=36);lia|change(4|0+28);exists 7;reflexivity].
 - replace 32 with(0+32)by lia;eapply copy_typed_load;[exact BY|exact COPY|exact L32|lia|change(32+4<=36);lia|change(4|0+32);exists 8;reflexivity].
Qed.
Theorem factory_trace_writes:forall m bs src ret o h mf,factory_trace m bs src ret o h mf ->raw_writes(fun b=>b=bs\/b=ret)m mf.
Proof.
 intros m bs src ret o h mf TRACE;destruct TRACE as(m1&m2&m3&m4&m5&m6&m7&vb&sb&T&F&V&VC&H&P&Q&R&BY&COPY).
 eapply raw_writes_store;[left;reflexivity|exact T|].
 eapply raw_writes_store;[left;reflexivity|exact F|].
 eapply raw_writes_bytes;[left;reflexivity|exact VC|].
 eapply raw_writes_store;[left;reflexivity|exact H|].
 eapply raw_writes_store;[left;reflexivity|exact P|].
 eapply raw_writes_store;[left;reflexivity|exact Q|].
 eapply raw_writes_store;[left;reflexivity|exact R|].
 eapply raw_writes_bytes;[right;reflexivity|exact COPY|constructor].
Qed.
Print Assumptions factory_trace_active.
Print Assumptions factory_trace_writes.
