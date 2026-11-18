From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import ByteAgreement CoreInputs.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Lemma translated_byte_offset : forall gh blk ofs,
 translated_byte gh blk ofs ->44<=ofs<52\/100<=ofs<108.
Proof.
 intros gh blk ofs;unfold translated_byte,field_byte.
 intros[(axis&AX&EQ&ft&start&OFF&R)|(sb&axis&SYM&AX&EQ&ft&start&OFF&R)].
 - destruct AX as[<-|[<-|[]]].
   + change(Some(tint,44)=Some(ft,start))in OFF;inversion OFF;subst;left;lia.
   + change(Some(tint,48)=Some(ft,start))in OFF;inversion OFF;subst;left;lia.
 - destruct AX as[<-|[<-|[]]].
   + change(Some(tint,100)=Some(ft,start))in OFF;inversion OFF;subst;right;lia.
   + change(Some(tint,104)=Some(ft,start))in OFF;inversion OFF;subst;right;lia.
Qed.
Definition core_parameters_agree m1 m2 gh(D1:core_initial_data m1 gh)(D2:core_initial_data m2 gh):Prop:=
 cid_pid _ _ D1=cid_pid _ _ D2 /\cid_i _ _ D1=cid_i _ _ D2 /\
 cid_kp _ _ D1=cid_kp _ _ D2 /\cid_kd _ _ D1=cid_kd _ _ D2 /\
 cid_ki _ _ D1=cid_ki _ _ D2 /\cid_kv _ _ D1=cid_kv _ _ D2 /\cid_ka _ _ D1=cid_ka _ _ D2 /\
 cid_ax _ _ D1=cid_ax _ _ D2 /\cid_ay _ _ D1=cid_ay _ _ D2 /\
 cid_ix _ _ D1=cid_ix _ _ D2 /\cid_iy _ _ D1=cid_iy _ _ D2 /\cid_hbits _ _ D1=cid_hbits _ _ D2.

Theorem canonical_pair_core_parameters_agree : forall m1 m2 gh ret dx dy
 (D1:core_initial_data m1 gh)(D2:core_initial_data m2 gh),
 InputPair gh ret m1 m2 dx dy ->core_parameters_agree m1 m2 gh D1 D2.
Proof.
 intros m1 m2 gh ret dx dy D1 D2[GOOD1[GOOD2[FRAME REST]]].
 destruct D1 as[bp bi bt bu bh bf kp kd ki kv ka ax ay ix iy h heading
 SP SI ST SU SH SF FF APP KP KD KI KV KA AX AY IX IY LT LU HEAD CAST HB WP WI].
 destruct D2 as[bp2 bi2 bt2 bu2 bh2 bf2 kp2 kd2 ki2 kv2 ka2 ax2 ay2 ix2 iy2 h2 heading2
 SP2 SI2 ST2 SU2 SH2 SF2 FF2 APP2 KP2 KD2 KI2 KV2 KA2 AX2 AY2 IX2 IY2 LT2 LU2 HEAD2 CAST2 HB2 WP2 WI2].
 assert(BP:bp2=bp)by(congruence);subst bp2.
 assert(BI:bi2=bi)by(congruence);subst bi2.
 assert(BH:bh2=bh)by(congruence);subst bh2.
 assert(RET:forall id,Genv.find_symbol E.ge id<>Some ret)
 by(destruct GOOD1 as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(PRET:bp<>ret)by(intro EQ;subst bp;apply(RET S._guidance_pid);exact SP).
 assert(IRET:bi<>ret)by(intro EQ;subst bi;apply(RET S._guidance_pid_trim_att_integrator);exact SI).
 assert(HRET:bh<>ret)by(intro EQ;subst bh;apply(RET S._guidance_h);exact SH).
 assert(GRET:gh<>ret)by(destruct GOOD1 as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 let agree LA LB OUT :=
 lazymatch type of LA with Mem.load ?ch m1 ?blk ?ofs=Some ?v=>
 let TRANS:=fresh "TRANSFER" in
 assert(TRANS:Mem.load ch m2 blk ofs=Some v)by(
 eapply canonical_frame_load_transfer;[exact FRAME|exact OUT| |exact LA];
 intros i R T;pose proof(translated_byte_offset _ _ _ T)as RANGE;cbn[size_chunk]in R;lia);
 rewrite LB in TRANS;congruence end in
 assert(EKP:kp=kp2)by(agree KP KP2 PRET);
 assert(EKD:kd=kd2)by(agree KD KD2 PRET);
 assert(EKI:ki=ki2)by(agree KI KI2 PRET);
 assert(EKV:kv=kv2)by(agree KV KV2 PRET);
 assert(EKA:ka=ka2)by(agree KA KA2 PRET);
 assert(EAX:ax=ax2)by(agree AX AX2 GRET);
 assert(EAY:ay=ay2)by(agree AY AY2 GRET);
 assert(EIX:ix=ix2)by(agree IX IX2 IRET);
 assert(EIY:iy=iy2)by(agree IY IY2 IRET);
 assert(EH:h=h2)by(agree HEAD HEAD2 HRET).
 subst h2.
 pose proof(CAST m1)as HC1;pose proof(CAST2 m1)as HC2.
 assert(EHEAD:heading=heading2)by(congruence).
 cbv beta iota zeta delta[core_parameters_agree cid_pid cid_i cid_kp cid_kd cid_ki cid_kv cid_ka cid_ax cid_ay cid_ix cid_iy cid_hbits].
 repeat split;assumption||reflexivity.
Qed.
Print Assumptions canonical_pair_core_parameters_agree.
