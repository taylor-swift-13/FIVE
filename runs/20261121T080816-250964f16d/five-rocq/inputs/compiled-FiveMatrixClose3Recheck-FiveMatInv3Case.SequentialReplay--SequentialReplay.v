From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Csem Smallstep.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import MatrixMemory Scalar Contract PairExtend GuardWitness TraceInputs.
From FiveMatrixInverseSupport Require Import Kernels.
Require FiveMatInv3Functional.Spec FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Definition Ready(m:mem)(bo bi:block)(po:ptrofs)(f old:Z->float32):Prop:=bo<>bi /\WriteRegion m bo po 9 /\Reads m bi Ptrofs.zero 9 f /\Reads m bo po 9 old.
Definition OldFixed(i:Z):float32:=Diag3(Float32.of_bits(Int.repr 1099431936))i.
Lemma region_preserved:forall m mf b p n,AccessPreserved m mf->Mem.valid_block m b->WriteRegion m b p n->WriteRegion mf b p n.
Proof. intros m mf b p n AC VB[AL[NW RP]];split;[exact AL|];split;[exact NW|];intros z B.
 assert(VA:Mem.valid_access m Mint8unsigned b z Writable)by(split;[intros x X;apply RP;cbn[size_chunk]in X;lia|change(1|z);exists z;lia]).
 pose proof(AC Mint8unsigned b z Writable VA)as[PF ALIGN];apply PF;cbn[size_chunk];lia. Qed.
Lemma reads_preserved:forall m mf b p n f,LoadPreserved m mf->0<n->Reads m b p n f->Reads mf b p n f.
Proof. intros m mf b p n f LOAD N RD;pose proof(reads_valid m b p n f N RD)as VB;destruct RD as[AL[NW R]];split;[exact AL|];split;[exact NW|];intros i I;rewrite LOAD by exact VB;apply R;exact I. Qed.
Lemma ready_preserved:forall m mf bo bi po f old,LoadPreserved m mf->AccessPreserved m mf->Ready m bo bi po f old->Ready mf bo bi po f old.
Proof. intros m mf bo bi po f old LP AP[NE[W[RI RO]]];split;[exact NE|];split.
 - eapply region_preserved;[exact AP|exact(writable_valid m bo po 9 ltac:(lia)W)|exact W].
 - split;[eapply reads_preserved;[exact LP|lia|exact RI]|eapply reads_preserved;[exact LP|lia|exact RO]]. Qed.
Lemma guarded_preserved:forall m mf bo bi f,LoadPreserved m mf->AccessPreserved m mf->Guarded 9 m bo bi f->Guarded 9 mf bo bi f.
Proof. intros m mf bo bi f LP AP[NE[W[RI[RO[G0 GN]]]]];pose proof(writable_valid m bo(Ptrofs.repr 4)9 ltac:(lia)W)as VO.
 split;[exact NE|];split;[eapply region_preserved;eauto|];split;[eapply reads_preserved;[exact LP|lia|exact RI]|];split;[eapply reads_preserved;[exact LP|lia|exact RO]|].
 split;rewrite LP by exact VO;assumption. Qed.
Record Separate(og ob ib os is0 ol il:block):Prop:={
 sep_bg:ob<>og;sep_big:ib<>og;sep_sg:os<>og;sep_sig:is0<>og;sep_lg:ol<>og;sep_lig:il<>og;
 sep_sb:os<>ob;sep_sib:is0<>ob;sep_lb:ol<>ob;sep_lib:il<>ob;sep_ls:ol<>os;sep_lis:il<>os
}.
Definition Layout(f:Z->float32)(m:mem)(og ig ob ib os is0 ol il:block):Prop:=
 Guarded 9 m og ig f /\Ready m ob ib Ptrofs.zero base3 OldFixed /\Ready m os is0 Ptrofs.zero small3 OldFixed /\Ready m ol il Ptrofs.zero large3 OldFixed /\Separate og ob ib os is0 ol il.
Theorem layout_inhabited:forall f:Z->float32,exists m og ig ob ib os is0 ol il,Layout f m og ig ob ib os is0 ol il.
Proof.
 intro f;destruct(matrix9_guarded f)as[mg[og[ig G]]].
 destruct(pair9_extend mg base3 OldFixed)as[mb[ob[ib[NEB[WB[RIB[ROB[FOB[FIB[BB[LB[AB VB]]]]]]]]]]]].
 assert(GB:Guarded 9 mb og ig f)by(eapply guarded_preserved;eauto).
 assert(B:Ready mb ob ib Ptrofs.zero base3 OldFixed)by(split;[exact NEB|];split;[exact WB|];split;assumption).
 destruct(pair9_extend mb small3 OldFixed)as[ms[os[is0[NES[WS[RIS[ROS[FOS[FIS[BS[LS[AS VS]]]]]]]]]]]].
 assert(GS:Guarded 9 ms og ig f)by(eapply guarded_preserved;eauto).
 assert(BS0:Ready ms ob ib Ptrofs.zero base3 OldFixed)by(eapply ready_preserved;eauto).
 assert(S:Ready ms os is0 Ptrofs.zero small3 OldFixed)by(split;[exact NES|];split;[exact WS|];split;assumption).
 destruct(pair9_extend ms large3 OldFixed)as[ml[ol[il[NEL[WL[RIL[ROL[FOL[FIL[BL[LL[AL VL]]]]]]]]]]]].
 assert(GL:Guarded 9 ml og ig f)by(eapply guarded_preserved;eauto).
 assert(BL0:Ready ml ob ib Ptrofs.zero base3 OldFixed)by(eapply ready_preserved;eauto).
 assert(SL:Ready ml os is0 Ptrofs.zero small3 OldFixed)by(eapply ready_preserved;eauto).
 assert(L:Ready ml ol il Ptrofs.zero large3 OldFixed)by(split;[exact NEL|];split;[exact WL|];split;assumption).
 assert(VG:Mem.valid_block mg og)by(destruct G as[_[W _]];exact(writable_valid mg og(Ptrofs.repr 4)9 ltac:(lia)W)).
 assert(VGB:Mem.valid_block mb og)by(apply VB;exact VG).
 assert(VGS:Mem.valid_block ms og)by(apply VS;exact VGB).
 assert(VOB:Mem.valid_block mb ob)by exact(writable_valid mb ob Ptrofs.zero 9 ltac:(lia)WB).
 assert(VOBS:Mem.valid_block ms ob)by(apply VS;exact VOB).
 assert(VOS:Mem.valid_block ms os)by exact(writable_valid ms os Ptrofs.zero 9 ltac:(lia)WS).
 exists ml,og,ig,ob,ib,os,is0,ol,il;split;[exact GL|];split;[exact BL0|];split;[exact SL|];split;[exact L|];constructor;
 intro EQ;subst;first[exact(FOB VG)|exact(FIB VG)|exact(FOS VGB)|exact(FIS VGB)|exact(FOL VGS)|exact(FIL VGS)|exact(FOS VOB)|exact(FIS VOB)|exact(FOL VOBS)|exact(FIL VOBS)|exact(FOL VOS)|exact(FIL VOS)].
Qed.
Lemma frame_load_kept:forall m mf bo po b ofs ch v,Frame m mf bo po->Mem.valid_block m b->
 (b<>bo\/ofs+size_chunk ch<=Ptrofs.unsigned po\/Ptrofs.unsigned po+36<=ofs)->Mem.load ch m b ofs=Some v->Mem.load ch mf b ofs=Some v.
Proof. intros m mf bo po b ofs ch v FR VB OUT LD;destruct(Mem.load_loadbytes ch m b ofs v LD)as[bytes[LB DE]].
 assert(LBF:Mem.loadbytes mf b ofs(size_chunk ch)=Some bytes)by(rewrite FR by assumption;exact LB).
 pose proof(Mem.load_valid_access _ _ _ _ _ LD)as[RP ALIGN];pose proof(Mem.loadbytes_load ch mf b ofs bytes LBF ALIGN)as LF;rewrite <-DE in LF;exact LF. Qed.
Lemma post_preserves_ready:forall m mf bo bi po pi f out input outp g old,
 FiveMatInv3Functional.Spec.Post m mf bo bi po pi f->Ready m out input outp g old->out<>bo->input<>bo->Ready mf out input outp g old.
Proof.
 intros m mf bo bi po pi f out input outp g old[BY[FR[WF[VB[AC INPUT]]]]][NE[WO[RI RO]]]OO IO.
 pose proof(writable_valid m out outp 9 ltac:(lia)WO)as VO.
 pose proof(reads_valid m input Ptrofs.zero 9 g ltac:(lia)RI)as VI.
 split;[exact NE|];split.
 - eapply region_preserved;[|exact VO|exact WO];intros ch b z p VA;apply AC;[eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|destruct p;constructor]|exact VA].
 - split.
   + destruct RI as[AL[NW RD]];split;[exact AL|];split;[exact NW|];intros i I;eapply frame_load_kept;[exact FR|exact VI|left;exact IO|apply RD;exact I].
   + destruct RO as[AL[NW RD]];split;[exact AL|];split;[exact NW|];intros i I;eapply frame_load_kept;[exact FR|exact VO|left;exact OO|apply RD;exact I].
Qed.
Definition NormalCall(m:mem)(bo bi:block)(po:ptrofs)(f:Z->float32)(mf:mem):Prop:=exists t,star Csem.step Execution.ge(Execution.entry(Args bo bi po Ptrofs.zero)m)t(Returnstate(Status f)Kstop mf).
Definition Chain(f:Z->float32)(m:mem)(og ig ob ib os is0 ol il:block):Prop:=exists ma mb ms ml,
 NormalCall m og ig(Ptrofs.repr 4)f ma /\FiveMatInv3Functional.Spec.Post m ma og ig(Ptrofs.repr 4)Ptrofs.zero f /\
 NormalCall ma ob ib Ptrofs.zero base3 mb /\FiveMatInv3Functional.Spec.Post ma mb ob ib Ptrofs.zero Ptrofs.zero base3 /\
 NormalCall mb os is0 Ptrofs.zero small3 ms /\FiveMatInv3Functional.Spec.Post mb ms os is0 Ptrofs.zero Ptrofs.zero small3 /\
 NormalCall ms ol il Ptrofs.zero large3 ml /\FiveMatInv3Functional.Spec.Post ms ml ol il Ptrofs.zero Ptrofs.zero large3.
Theorem original_sequential_calls:forall f m og ig ob ib os is0 ol il,Layout f m og ig ob ib os is0 ol il->Chain f m og ig ob ib os is0 ol il.
Proof.
 intros f m og ig ob ib os is0 ol il[G[B[S[L SEP]]]];destruct SEP;destruct G as[NEG[WG[RIG RESTG]]].
 destruct(FiveMatInv3Functional.Proof.normal_call m og ig(Ptrofs.repr 4)Ptrofs.zero f NEG WG RIG)as[ma[PG QG]].
 assert(BA:Ready ma ob ib Ptrofs.zero base3 OldFixed)by(eapply post_preserves_ready;eauto).
 assert(SA:Ready ma os is0 Ptrofs.zero small3 OldFixed)by(eapply post_preserves_ready;eauto).
 assert(LA:Ready ma ol il Ptrofs.zero large3 OldFixed)by(eapply post_preserves_ready;eauto).
 destruct BA as[NEB[WB[RIB ROB]]];destruct(FiveMatInv3Functional.Proof.normal_call ma ob ib Ptrofs.zero Ptrofs.zero base3 NEB WB RIB)as[mb[PB QB]].
 assert(SB:Ready mb os is0 Ptrofs.zero small3 OldFixed)by(eapply post_preserves_ready;eauto).
 assert(LB:Ready mb ol il Ptrofs.zero large3 OldFixed)by(eapply post_preserves_ready;eauto).
 destruct SB as[NES[WS[RIS ROS]]];destruct(FiveMatInv3Functional.Proof.normal_call mb os is0 Ptrofs.zero Ptrofs.zero small3 NES WS RIS)as[ms[PS QS]].
 assert(LS:Ready ms ol il Ptrofs.zero large3 OldFixed)by(eapply post_preserves_ready;eauto).
 destruct LS as[NEL[WL[RIL ROL]]];destruct(FiveMatInv3Functional.Proof.normal_call ms ol il Ptrofs.zero Ptrofs.zero large3 NEL WL RIL)as[ml[PL QL]].
 exists ma,mb,ms,ml;split;[exact PG|];split;[exact QG|];split;[exact PB|];split;[exact QB|];split;[exact PS|];split;[exact QS|];split;[exact PL|exact QL].
Qed.
Definition NonvacuousReplay(f:Z->float32):Prop:=exists m og ig ob ib os is0 ol il,Layout f m og ig ob ib os is0 ol il /\Chain f m og ig ob ib os is0 ol il.
Theorem nonvacuous_replay:forall f:Z->float32,NonvacuousReplay f.
Proof. intro f;destruct(layout_inhabited f)as[m[og[ig[ob[ib[os[is0[ol[il L]]]]]]]]];exists m,og,ig,ob,ib,os,is0,ol,il;split;[exact L|apply original_sequential_calls;exact L]. Qed.
Theorem both_original_traces_replayed:NonvacuousReplay arbitrary_0 /\NonvacuousReplay arbitrary_1.
Proof. split;apply nonvacuous_replay. Qed.
Print Assumptions original_sequential_calls.
Print Assumptions both_original_traces_replayed.
