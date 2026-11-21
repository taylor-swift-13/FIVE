From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Ctypes Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract Call MemoryEffects Body Memcpy16 Observer TraceInputs.
Import ListNotations.
Local Open Scope Z_scope.
Record AddressFacts(m:mem)(b:block)(p:ptrofs)(i:Z)(perm:permission):Prop:={
 address_nonnull:Vptr b(Ptrofs.add p(Ptrofs.repr(4*i)))<>Vnullptr;
 address_live:Mem.valid_block m b;
 address_typed:Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+4*i)perm;
 address_nowrap:Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr(4*i)))=Ptrofs.unsigned p+4*i;
 address_bounds:0<=i<4
}.
Definition SourceGuards(i:Z)(output:bool):Prop :=forall m bo bi po pi f,Inputs m bo bi po pi f->0<=i<4->
 no_error Execution.ge(Execution.entry(Args bo bi po pi)m)/\
 if output then AddressFacts m bo po i Writable else AddressFacts m bi pi i Readable.
Theorem source_guards:forall i output,SourceGuards i output.
Proof. intros i output m bo bi po pi f IN B;destruct(call_summary m bo bi po pi f IN)as[mf[PATH[POST[SAFE ALL]]]];split;[exact SAFE|].
 destruct IN as[NE[W RD]];destruct output;constructor;try discriminate;try exact B.
 - exact(writable_valid m bo po 4 ltac:(lia)W).
 - eapply writable_access;eauto.
 - eapply index_pointer;[exact(proj1(proj2 W))|exact B].
 - exact(reads_valid m bi pi 4 f ltac:(lia)RD).
 - eapply Mem.load_valid_access;exact(proj2(proj2 RD)i B).
 - eapply index_pointer;[exact(proj1(proj2 RD))|exact B]. Qed.
Lemma same_bytes_cell_at:forall m1 b1 base1 m2 b2 base2 bytes z,
 Mem.loadbytes m1 b1 base1 16=Some bytes->Mem.loadbytes m2 b2 base2 16=Some bytes->0<=z->z+4<=16->
 Mem.loadbytes m1 b1(base1+z)4=Mem.loadbytes m2 b2(base2+z)4.
Proof. intros m1 b1 base1 m2 b2 base2 bytes z A B Z LIMIT.
 replace 16 with(z+(16-z))in A,B by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ A ltac:(lia)ltac:(lia))as[a[rest[RA[RR EA]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ B ltac:(lia)ltac:(lia))as[c[tail[RC[RT EC]]]].
 assert(L:length a=length c)by(erewrite(Mem.loadbytes_length _ _ _ _ _ RA),(Mem.loadbytes_length _ _ _ _ _ RC);reflexivity).
 destruct(append_cut _ a rest c tail L ltac:(congruence))as[_ EQ];subst tail.
 replace(16-z)with(4+(12-z))in RR,RT by lia.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ RR ltac:(lia)ltac:(lia))as[d[ds[RD[RDS ED]]]].
 destruct(Mem.loadbytes_split _ _ _ _ _ _ RT ltac:(lia)ltac:(lia))as[f[fs[RF[RFS EF]]]].
 assert(L':length d=length f)by(erewrite(Mem.loadbytes_length _ _ _ _ _ RD),(Mem.loadbytes_length _ _ _ _ _ RF);reflexivity).
 destruct(append_cut _ d ds f fs L' ltac:(congruence))as[EQ _];subst f;congruence. Qed.
Lemma successful_post_cells:forall m mf bo bi po pi f,Post m mf bo bi po pi f->Reject f=false->forall i,0<=i<4->
 Mem.loadbytes mf bo(Ptrofs.unsigned po+4*i)4=Some(encode_val Mfloat32(Vsingle(Output f i))).
Proof. intros m mf bo bi po pi f POST REJ i B.
 destruct POST as[W[RD[FR[VB[BY AC]]]]];rewrite REJ in BY.
 destruct(Mem.alloc Mem.empty 0 16)as[ma br]eqn:AL.
 assert(WR:WriteRegion ma br Ptrofs.zero 4).
 { unfold WriteRegion;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[change(16<=18446744073709551616);lia|intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AL|lia]|constructor]]. }
 destruct(writes_exist(Outputs f)ma br Ptrofs.zero 4 WR(output_bounds f))as[mr WS].
 assert(BR:Branch ma br Ptrofs.zero f mr)by(unfold Branch;rewrite REJ;exact WS).
 pose proof(branch_bytes ma br Ptrofs.zero f mr BR)as REF;rewrite REJ,Ptrofs.unsigned_zero in REF.
 pose proof(same_bytes_cell_at mf bo(Ptrofs.unsigned po)mr br 0(Encoded f)(4*i)BY REF ltac:(lia)ltac:(lia))as EQ.
 rewrite EQ;replace(0+4*i)with(Ptrofs.unsigned Ptrofs.zero+4*i)by(rewrite Ptrofs.unsigned_zero;lia).
 eapply writes_bytes;[exact WS|apply output_nodup|].
 assert(C:i=0\/i=1\/i=2\/i=3)by lia;destruct C as [-> | [-> | [-> | ->]]];unfold Outputs;repeat first[left;reflexivity|right]. Qed.
Theorem successful_copy_words:forall m mf bo bi pi f dst bytes obs,
 Post m mf bo bi Ptrofs.zero pi f->Reject f=false->Mem.loadbytes mf bo 0 16=Some bytes->Mem.storebytes mf dst 0 bytes=Some obs->
 forall i,0<=i<4->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(Output f i))).
Proof. intros m mf bo bi pi f dst bytes obs POST REJ READ STORE i B;eapply memcpy_word_observation;[exact READ|exact STORE| |exact B].
 intros j J;replace(4*j)with(Ptrofs.unsigned Ptrofs.zero+4*j)by(rewrite Ptrofs.unsigned_zero;lia);eapply successful_post_cells;eauto. Qed.
Theorem post_preserves_other_inputs:forall m mf bo bi po pi f out input outp inp g,
 Post m mf bo bi po pi f->Inputs m out input outp inp g->out<>bo->input<>bo->Inputs mf out input outp inp g.
Proof. intros m mf bo bi po pi f out input outp inp g[W[RD[FR[VB[BY AC]]]]][NE[WO RI]]OO IO;split;[exact NE|];split.
 - destruct WO as[AL[NW RP]];repeat split;auto;intros z B.
   assert(V:Mem.valid_block m out)by(eapply(writable_valid m out outp 4 ltac:(lia));repeat split;eauto).
   assert(VA:Mem.valid_access m Mint8unsigned out z Writable)by(split;[intros off R;apply RP;cbn[size_chunk]in R;lia|change(1|z);exists z;lia]).
   pose proof(AC Mint8unsigned out z Writable V VA)as[PF ALIGN];apply PF;cbn[size_chunk];lia.
 - destruct RI as[AL[NW L]];repeat split;auto;intros i B.
   destruct(Mem.load_loadbytes Mfloat32 m input(Ptrofs.unsigned inp+4*i)(Vsingle(g i))(L i B))as[bytes[LB DE]].
   assert(VI:Mem.valid_block m input)by(eapply(reads_valid m input inp 4 g ltac:(lia));repeat split;eauto).
   assert(LBF:Mem.loadbytes mf input(Ptrofs.unsigned inp+4*i)4=Some bytes)by(rewrite FR by(auto);exact LB).
   pose proof(Mem.loadbytes_load Mfloat32 mf input(Ptrofs.unsigned inp+4*i)bytes LBF ltac:(change(4|Ptrofs.unsigned inp+4*i);destruct AL as[k K];exists(k+i);lia))as LF;rewrite <-DE in LF;exact LF.
Qed.
Print Assumptions source_guards.
Print Assumptions successful_copy_words.

Theorem frame_load_kept:forall m mf bo po b ofs ch v,Frame m mf bo po->Mem.valid_block m b->
 (b<>bo\/ofs+size_chunk ch<=Ptrofs.unsigned po\/Ptrofs.unsigned po+16<=ofs)->Mem.load ch m b ofs=Some v->Mem.load ch mf b ofs=Some v.
Proof. intros m mf bo po b ofs ch v FR VB OUT LD.
 destruct(Mem.load_loadbytes ch m b ofs v LD)as[bytes[LB DE]].
 assert(LBF:Mem.loadbytes mf b ofs(size_chunk ch)=Some bytes)by(rewrite FR by assumption;exact LB).
 pose proof(Mem.load_valid_access _ _ _ _ _ LD)as[RP AL].
 pose proof(Mem.loadbytes_load ch mf b ofs bytes LBF AL)as LF;rewrite <-DE in LF;exact LF. Qed.
