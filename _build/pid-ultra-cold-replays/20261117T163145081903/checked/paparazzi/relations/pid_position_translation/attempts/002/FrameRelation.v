From Stdlib Require Import List ZArith Lia Classical.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory.
From PidPositionTranslationAttempt002 Require Import ByteAgreement CoreInputs DataAgreement NormalReturn.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.

From PidPositionTranslationAttempt002 Require Import ComputedRelation FramedNormalReturn StackAgreement ByteSubrange MainGoals.
From PidPositionTranslationCore Require Import MemoryShape.
Theorem constructed_original_framed_translation : forall gh ret a b dx dy flight,
 InputPair gh ret a b dx dy ->
 exists af bf,NormalCall gh ret flight a af /\NormalCall gh ret flight b bf /\same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret a b dx dy flight INPUT;pose proof INPUT as[A[B[FRAME[TX TY]]]].
 destruct(inputgood_core_initial_data a gh ret A)as[DA _].
 destruct(inputgood_core_initial_data b gh ret B)as[DB _].
 pose proof(canonical_pair_core_parameters_agree a b gh ret dx dy DA DB INPUT)as EQ.
 unfold core_parameters_agree in EQ;destruct EQ as(EPID&EIBLOCK&EKP&EKD&EKI&EKV&EKA&EAX&EAY&EIX&EIY&EHEAD).
 destruct(original_entry_framed_normal_result a gh ret flight DA A)
 as(af&rax&ray&pax&pay&sax&say&vax&vay&sa&pea&sea&
 CALLA&STA&RAX&RAY&PAX&PAY&SAX&SAY&VAX&VAY&ACTA&IAX&IAY&CAX&CAY&PEA0&PEA4&SEA0&SEA4&FRAX&FRAY&SPEA&SSEA&SHAPEA&FA&AW0&AW4&AW32&AW36&AWE0&AWE4&AWS0&AWS4).
 destruct(original_entry_framed_normal_result b gh ret flight DB B)
 as(bf&rbx&rby&pbx&pby&sbx&sby&vbx&vby&sb&peb&seb&
 CALLB&STB&RBX&RBY&PBX&PBY&SBX&SBY&VBX&VBY&ACTB&IBX&IBY&CBX&CBY&PEB0&PEB4&SEB0&SEB4&FRBX&FRBY&SPEB&SSEB&SHAPEB&FB&BW0&BW4&BW32&BW36&BWE0&BWE4&BWS0&BWS4).
 assert(SAMESTATE:sb=sa)by(congruence);subst sb.
 assert(DX:Int.sub rax pax=Int.sub rbx pbx).
 { eapply axis_translation_sub_equal;[exact TX|exact RAX| |exact RBX|].
   - unfold load_global;rewrite STA;exact PAX.
   - unfold load_global;rewrite STA;exact PBX. }
 assert(DY:Int.sub ray pay=Int.sub rby pby).
 { eapply axis_translation_sub_equal;[exact TY|exact RAY| |exact RBY|].
   - unfold load_global;rewrite STA;exact PAY.
   - unfold load_global;rewrite STA;exact PBY. }
 assert(GRET:gh<>ret)by(destruct A as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(RET:forall id,Genv.find_symbol E.ge id<>Some ret)
 by(destruct A as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(SRET:sa<>ret)by(intro EQUAL;subst sa;apply(RET S._state);exact STA).
 change(Mem.load Mint32 a gh 52=Some(Vint sax))in SAX.
 change(Mem.load Mint32 a gh 56=Some(Vint say))in SAY.
 change(Mem.load Mint32 b gh 52=Some(Vint sbx))in SBX.
 change(Mem.load Mint32 b gh 56=Some(Vint sby))in SBY.
 let agree LA LB OUT :=
 lazymatch type of LA with Mem.load ?ch a ?blk ?ofs=Some ?v=>
 let TRANS:=fresh "TRANSFER" in
 assert(TRANS:Mem.load ch b blk ofs=Some v)by(
 eapply canonical_frame_load_transfer;[exact FRAME|exact OUT| |exact LA];
 intros i R T;pose proof(translated_byte_offset _ _ _ T)as RANGE;cbn[size_chunk]in R;lia);
 rewrite LB in TRANS;congruence end in
 assert(ESX:sax=sbx)by(agree SAX SBX GRET);
 assert(ESY:say=sby)by(agree SAY SBY GRET);
 assert(EVX:vax=vbx)by(agree VAX VBX SRET);
 assert(EVY:vay=vby)by(agree VAY VBY SRET).
 assert(CMDX:entry_axis_command a gh DA flight rax pax sax vax(cid_ax _ _ DA)(cid_ix _ _ DA)=
 entry_axis_command b gh DB flight rbx pbx sbx vbx(cid_ax _ _ DB)(cid_ix _ _ DB)).
 { unfold entry_axis_command;rewrite<-EKP,<-EKD,<-EKI,<-EKV,<-EKA,<-EAX,<-EIX,<-ESX,<-EVX,<-DX;reflexivity. }
 assert(CMDY:entry_axis_command a gh DA flight ray pay say vay(cid_ay _ _ DA)(cid_iy _ _ DA)=
 entry_axis_command b gh DB flight rby pby sby vby(cid_ay _ _ DB)(cid_iy _ _ DB)).
 { unfold entry_axis_command;rewrite<-EKP,<-EKD,<-EKI,<-EKV,<-EKA,<-EAY,<-EIY,<-ESY,<-EVY,<-DY;reflexivity. }
 assert(INTX:entry_axis_integral a gh DA flight rax pax sax vax(cid_ix _ _ DA)=
 entry_axis_integral b gh DB flight rbx pbx sbx vbx(cid_ix _ _ DB)).
 { unfold entry_axis_integral;rewrite<-EKP,<-EKD,<-EKI,<-EIX,<-ESX,<-EVX,<-DX;reflexivity. }
 assert(INTY:entry_axis_integral a gh DA flight ray pay say vay(cid_iy _ _ DA)=
 entry_axis_integral b gh DB flight rby pby sby vby(cid_iy _ _ DB)).
 { unfold entry_axis_integral;rewrite<-EKP,<-EKD,<-EKI,<-EIY,<-ESY,<-EVY,<-DY;reflexivity. }
 rewrite<-CMDX,<-CMDY,<-EHEAD in ACTB.
 rewrite<-EIBLOCK,<-INTX in IBX;rewrite<-EIBLOCK,<-INTY in IBY.
 rewrite<-EPID,<-CMDX in CBX;rewrite<-EPID,<-CMDY in CBY.
 assert(SAMEPE:peb=pea)by(congruence);subst peb.
 assert(SAMESE:seb=sea)by(congruence);subst seb.
 rewrite<-EPID,<-EIBLOCK in FB.
 rewrite<-EIBLOCK,<-INTX in BW0;rewrite<-EIBLOCK,<-INTY in BW4.
 rewrite<-EPID,<-CMDX in BW32;rewrite<-EPID,<-CMDY in BW36.
 rewrite<-DX in BWE0;rewrite<-DY in BWE4.
 rewrite<-ESX,<-EVX in BWS0;rewrite<-ESY,<-EVY in BWS4.
 assert(FINAL:same_except_positions_and_return gh ret af bf).
 { destruct FRAME as[NB0[PERM0 BYTES0]].
   destruct SHAPEA as[NBA PA];destruct SHAPEB as[NBB PB].
   split;[rewrite NBA,NBB,NB0;reflexivity|].
   split.
   - intros blk ofs k p;rewrite(PA blk ofs k p),(PB blk ofs k p);apply PERM0.
   - intros blk ofs NT NR.
     destruct(plt blk(Mem.nextblock a))as[VB|NV].
     2:{ assert(NA:~Mem.perm af blk ofs Cur Readable).
         { intro PM;apply NV;eapply Mem.perm_valid_block;apply(PA blk ofs Cur Readable);exact PM. }
         assert(NB:~Mem.perm bf blk ofs Cur Readable).
         { intro PM;apply NV;eapply Mem.perm_valid_block;apply(PERM0 blk ofs Cur Readable);apply(PB blk ofs Cur Readable);exact PM. }
         rewrite(unit_loadbytes_absent _ _ _ NA),(unit_loadbytes_absent _ _ _ NB);reflexivity. }
     assert(VB2:Mem.valid_block b blk)by(unfold Mem.valid_block;rewrite<-NB0;exact VB).
     destruct(classic(blk=pea /\0<=ofs<8))as[[EQ RANGE]|NPE].
     { subst blk;destruct(zlt ofs 4).
       - eapply equal_int32_words_all_units with(base:=0);[exact AWE0|exact BWE0|lia].
       - eapply equal_int32_words_all_units with(base:=4);[exact AWE4|exact BWE4|lia]. }
     destruct(classic(blk=sea /\0<=ofs<8))as[[EQ RANGE]|NSE].
     { subst blk;destruct(zlt ofs 4).
       - eapply equal_int32_words_all_units with(base:=0);[exact AWS0|exact BWS0|lia].
       - eapply equal_int32_words_all_units with(base:=4);[exact AWS4|exact BWS4|lia]. }
     destruct(classic(blk=cid_pid _ _ DA /\32<=ofs<40))as[[EQ RANGE]|NCP].
     { subst blk;destruct(zlt ofs 36).
       - eapply equal_int32_words_all_units with(base:=32);[exact AW32|exact BW32|lia].
       - eapply equal_int32_words_all_units with(base:=36);[exact AW36|exact BW36|lia]. }
     destruct(classic(blk=cid_i _ _ DA /\0<=ofs<8))as[[EQ RANGE]|NCI].
     { subst blk;destruct(zlt ofs 4).
       - eapply equal_int32_words_all_units with(base:=0);[exact AW0|exact BW0|lia].
       - eapply equal_int32_words_all_units with(base:=4);[exact AW4|exact BW4|lia]. }
     assert(DPE:blk<>pea \/ofs+1<=0 \/8<=ofs).
     { destruct(peq blk(pea))as[EQ|NE];[right;subst blk;clear -NPE;lia|left;exact NE]. }
     assert(DSE:blk<>sea \/ofs+1<=0 \/8<=ofs).
     { destruct(peq blk(sea))as[EQ|NE];[right;subst blk;clear -NSE;lia|left;exact NE]. }
     assert(DCP:blk<>cid_pid _ _ DA \/ofs+1<=32 \/40<=ofs).
     { destruct(peq blk(cid_pid _ _ DA))as[EQ|NE];[right;subst blk;clear -NCP;lia|left;exact NE]. }
     assert(DCI:blk<>cid_i _ _ DA \/ofs+1<=0 \/8<=ofs).
     { destruct(peq blk(cid_i _ _ DA))as[EQ|NE];[right;subst blk;clear -NCI;lia|left;exact NE]. }
     rewrite(FA blk ofs 1 VB NR DPE DSE DCP DCI ltac:(lia)).
     rewrite(FB blk ofs 1 VB2 NR DPE DSE DCP DCI ltac:(lia)).
     apply BYTES0;assumption. }
 exists af,bf;exact(conj CALLA(conj CALLB FINAL)).
Qed.

Theorem proved_relational_frame : RelationalFrameGoal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR CA CB.
 destruct(constructed_original_framed_translation gh ret a b dx dy flight PAIR)
 as[nfa[nfb[NA[NB FRAME]]]].
 assert(EA:af=nfa)by(eapply original_entry_all_normal_memories_unique;[exact(proj1 PAIR)|exact CA|exact NA]).
 assert(EB:bf=nfb)by(eapply original_entry_all_normal_memories_unique;[exact(proj1(proj2 PAIR))|exact CB|exact NB]).
 subst af bf;exact FRAME.
Qed.
Print Assumptions proved_relational_frame.
