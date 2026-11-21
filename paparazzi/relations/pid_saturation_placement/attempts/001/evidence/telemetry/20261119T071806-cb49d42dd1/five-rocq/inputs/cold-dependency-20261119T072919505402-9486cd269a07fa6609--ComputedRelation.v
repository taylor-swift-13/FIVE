From Stdlib Require Import List ZArith Lia.
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

Lemma axis_translation_sub_equal : forall gh a b axis d ra pa rb pb,
 AxisTranslation gh a b axis d ->
 load_path Mint32 a gh gh_type(ref_pos axis)=Some(Vint ra) ->
 load_global Mint32 a S._state state_type(measured_pos axis)=Some(Vint pa) ->
 load_path Mint32 b gh gh_type(ref_pos axis)=Some(Vint rb) ->
 load_global Mint32 b S._state state_type(measured_pos axis)=Some(Vint pb) ->
 Int.sub ra pa=Int.sub rb pb.
Proof.
 intros gh a b axis d ra pa rb pb
 (ra0&pa0&rb0&pb0&RA&PA&RB&PB&PHY&RBE&PBE)RA' PA' RB' PB'.
 rewrite RA in RA';inversion RA';subst ra0.
 rewrite PA in PA';inversion PA';subst pa0.
 rewrite RB in RB';inversion RB';subst rb0.
 rewrite PB in PB';inversion PB';subst pb0.
 rewrite!Int.sub_signed;rewrite RBE,PBE,common_translation_difference;reflexivity.
Qed.
Lemma active_fields_pair_observation : forall ret a b x y heading,
 active_fields a ret x y heading ->active_fields b ret x y heading ->ActiveReturnEqual ret a b.
Proof.
 intros ret a b x y heading(A0&A4&A8&A12&A16&AR)(B0&B4&B8&B12&B16&BR).
 unfold ActiveReturnEqual;split;[exact A0|];split;[exact B0|];split;[exact A4|];split;[exact B4|].
 intros path IN;destruct IN as[<-|[<-|[<-|[]]]];unfold same_loaded_int32;
 [exists x|exists y|exists heading];split;assumption.
Qed.
Lemma equal_raw_controller_observation : forall a b bp bi cx cy ix iy,
 Genv.find_symbol E.ge S._guidance_pid=Some bp ->
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some bi ->
 Mem.load Mint32 a bp 32=Some(Vint cx) ->Mem.load Mint32 b bp 32=Some(Vint cx) ->
 Mem.load Mint32 a bp 36=Some(Vint cy) ->Mem.load Mint32 b bp 36=Some(Vint cy) ->
 Mem.load Mint32 a bi 0=Some(Vint ix) ->Mem.load Mint32 b bi 0=Some(Vint ix) ->
 Mem.load Mint32 a bi 4=Some(Vint iy) ->Mem.load Mint32 b bi 4=Some(Vint iy) ->
 ControllerEqual a b.
Proof.
 intros a b bp bi cx cy ix iy SP SI AX BX AY BY AIX BIX AIY BIY axis IN.
 destruct IN as[<-|[<-|[]]];split;unfold same_loaded_int32.
 - exists cx;unfold load_global;rewrite SP;split;assumption.
 - exists ix;unfold load_global;rewrite SI;split;assumption.
 - exists cy;unfold load_global;rewrite SP;split;assumption.
 - exists iy;unfold load_global;rewrite SI;split;assumption.
Qed.

Theorem constructed_original_position_translation : forall gh ret a b dx dy flight,
 InputPair gh ret a b dx dy ->
 exists af bf,NormalCall gh ret flight a af /\NormalCall gh ret flight b bf /\FinalRelation gh ret af bf.
Proof.
 intros gh ret a b dx dy flight INPUT;pose proof INPUT as[A[B[FRAME[TX TY]]]].
 destruct(inputgood_core_initial_data a gh ret A)as[DA _].
 destruct(inputgood_core_initial_data b gh ret B)as[DB _].
 pose proof(canonical_pair_core_parameters_agree a b gh ret dx dy DA DB INPUT)as EQ.
 unfold core_parameters_agree in EQ;destruct EQ as(EPID&EIBLOCK&EKP&EKD&EKI&EKV&EKA&EAX&EAY&EIX&EIY&EHEAD).
 destruct(original_entry_normal_result a gh ret flight DA A)
 as(af&rax&ray&pax&pay&sax&say&vax&vay&sa&
 CALLA&STA&RAX&RAY&PAX&PAY&SAX&SAY&VAX&VAY&ACTA&IAX&IAY&CAX&CAY).
 destruct(original_entry_normal_result b gh ret flight DB B)
 as(bf&rbx&rby&pbx&pby&sbx&sby&vbx&vby&sb&
 CALLB&STB&RBX&RBY&PBX&PBY&SBX&SBY&VBX&VBY&ACTB&IBX&IBY&CBX&CBY).
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
 exists af,bf;split;[exact CALLA|];split;[exact CALLB|];split.
 - eapply equal_raw_controller_observation;
   [exact(cid_pid_symbol _ _ DA)|exact(cid_i_symbol _ _ DA)|exact CAX|exact CBX|exact CAY|exact CBY|exact IAX|exact IBX|exact IAY|exact IBY].
 - eapply active_fields_pair_observation;[exact ACTA|exact ACTB].
Qed.
Print Assumptions constructed_original_position_translation.
