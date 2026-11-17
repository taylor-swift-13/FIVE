From Stdlib Require Import List ZArith Lia Classical.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory FlightSemantics ControllerPrefix MemoryShape.
From PidPositionTranslationAttempt002 Require Import ByteAgreement CoreInputs DataAgreement NormalReturn ComputedRelation FramedNormalReturn StackAgreement ByteSubrange MainGoals NonemptyInput WitnessMemory InputSemantics ReadOnlySemantics.
From PidGroundIntegralProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Lemma ground_frame_load_transfer : forall ret a b ch blk ofs v,
 same_except_integrals_and_return ret a b ->blk<>ret ->
 (forall i,0<=i<size_chunk ch ->~integral_byte blk(ofs+i)) ->
 Mem.load ch a blk ofs=Some v ->Mem.load ch b blk ofs=Some v.
Proof.
 intros ret a b ch blk ofs v[_[_ BY]]RET NOT LOAD.
 eapply scalar_load_from_equal_units;[exact LOAD|].
 intros i R;apply BY;[apply NOT;exact R|exact RET].
Qed.
Definition ground_parameters_agree m1 m2 gh(D1:core_initial_data m1 gh)(D2:core_initial_data m2 gh):Prop:=
 cid_pid _ _ D1=cid_pid _ _ D2 /\cid_i _ _ D1=cid_i _ _ D2 /\
 cid_kp _ _ D1=cid_kp _ _ D2 /\cid_kd _ _ D1=cid_kd _ _ D2 /\
 cid_ki _ _ D1=cid_ki _ _ D2 /\cid_kv _ _ D1=cid_kv _ _ D2 /\cid_ka _ _ D1=cid_ka _ _ D2 /\
 cid_ax _ _ D1=cid_ax _ _ D2 /\cid_ay _ _ D1=cid_ay _ _ D2 /\
 cid_hbits _ _ D1=cid_hbits _ _ D2.

Theorem ground_pair_parameters_agree : forall m1 m2 gh ret
 (D1:core_initial_data m1 gh)(D2:core_initial_data m2 gh),
 GroundBasePair gh ret m1 m2 ->ground_parameters_agree m1 m2 gh D1 D2.
Proof.
 intros m1 m2 gh ret D1 D2[GOOD1[GOOD2 FRAME]].
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
 assert(PNI:bp<>bi)by(eapply Genv.global_addresses_distinct;[|exact SP|exact SI];discriminate).
 let agree LA LB OUT :=
 lazymatch type of LA with Mem.load ?ch m1 ?blk ?ofs=Some ?v=>
 let TRANS:=fresh "TRANSFER" in
 assert(TRANS:Mem.load ch m2 blk ofs=Some v)by(
 eapply ground_frame_load_transfer;[exact FRAME|exact OUT| |exact LA];
 intros i R [SYM RANGE];
 first[rewrite SI in SYM;injection SYM as EQ;subst blk;contradiction|cbn[size_chunk]in R;lia]);
 rewrite LB in TRANS;congruence end in
 assert(EKP:kp=kp2)by(agree KP KP2 PRET);
 assert(EKD:kd=kd2)by(agree KD KD2 PRET);
 assert(EKI:ki=ki2)by(agree KI KI2 PRET);
 assert(EKV:kv=kv2)by(agree KV KV2 PRET);
 assert(EKA:ka=ka2)by(agree KA KA2 PRET);
 assert(EAX:ax=ax2)by(agree AX AX2 GRET);
 assert(EAY:ay=ay2)by(agree AY AY2 GRET);
 assert(EH:h=h2)by(agree HEAD HEAD2 HRET).
 subst h2.
 pose proof(CAST m1)as HC1;pose proof(CAST2 m1)as HC2.
 assert(EHEAD:heading=heading2)by(congruence).
 cbv beta iota zeta delta[ground_parameters_agree cid_pid cid_i cid_kp cid_kd cid_ki cid_kv cid_ka cid_ax cid_ay cid_ix cid_iy cid_hbits].
 repeat split;assumption||reflexivity.
Qed.
Print Assumptions ground_pair_parameters_agree.

Theorem constructed_ground : forall gh ret a b,
 GroundBasePair gh ret a b ->
 exists af bf,NormalCall gh ret false a af /\NormalCall gh ret false b bf /\GroundFinal ret af bf /\same_outside_return ret af bf.
Proof.
 intros gh ret a b INPUT;pose proof INPUT as[A[B FRAME]].
 destruct(inputgood_core_initial_data a gh ret A)as[DA _].
 destruct(inputgood_core_initial_data b gh ret B)as[DB _].
 pose proof(ground_pair_parameters_agree a b gh ret DA DB INPUT)as EQ.
 unfold ground_parameters_agree in EQ;destruct EQ as(EPID&EIBLOCK&EKP&EKD&EKI&EKV&EKA&EAX&EAY&EHEAD).
 destruct(original_entry_framed_normal_result a gh ret false DA A)
 as(af&rax&ray&pax&pay&sax&say&vax&vay&sa&pea&sea&
 CALLA&STA&RAX&RAY&PAX&PAY&SAX&SAY&VAX&VAY&ACTA&IAX&IAY&CAX&CAY&PEA0&PEA4&SEA0&SEA4&FRAX&FRAY&SPEA&SSEA&SHAPEA&FA&AW0&AW4&AW32&AW36&AWE0&AWE4&AWS0&AWS4).
 destruct(original_entry_framed_normal_result b gh ret false DB B)
 as(bf&rbx&rby&pbx&pby&sbx&sby&vbx&vby&sb&peb&seb&
 CALLB&STB&RBX&RBY&PBX&PBY&SBX&SBY&VBX&VBY&ACTB&IBX&IBY&CBX&CBY&PEB0&PEB4&SEB0&SEB4&FRBX&FRBY&SPEB&SSEB&SHAPEB&FB&BW0&BW4&BW32&BW36&BWE0&BWE4&BWS0&BWS4).
 assert(SAMESTATE:sb=sa)by(congruence);subst sb.
 assert(GRET:gh<>ret)by(destruct A as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(RET:forall id,Genv.find_symbol E.ge id<>Some ret)
 by(destruct A as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(SRET:sa<>ret)by(intro EQUAL;subst sa;apply(RET S._state);exact STA).
 change(Mem.load Mint32 a gh 52=Some(Vint sax))in SAX.
 change(Mem.load Mint32 a gh 56=Some(Vint say))in SAY.
 change(Mem.load Mint32 b gh 52=Some(Vint sbx))in SBX.
 change(Mem.load Mint32 b gh 56=Some(Vint sby))in SBY.
 change(Mem.load Mint32 a gh 44=Some(Vint rax))in RAX.
 change(Mem.load Mint32 a gh 48=Some(Vint ray))in RAY.
 change(Mem.load Mint32 b gh 44=Some(Vint rbx))in RBX.
 change(Mem.load Mint32 b gh 48=Some(Vint rby))in RBY.
 let agree LA LB OUT :=
 lazymatch type of LA with Mem.load ?ch a ?blk ?ofs=Some ?v=>
 let TRANS:=fresh "TRANSFER" in
 assert(TRANS:Mem.load ch b blk ofs=Some v)by(
 eapply ground_frame_load_transfer;[exact FRAME|exact OUT| |exact LA];
 intros i R [SYM RANGE];cbn[size_chunk]in R;lia);
 rewrite LB in TRANS;congruence end in
 assert(ERX:rax=rbx)by(agree RAX RBX GRET);
 assert(ERY:ray=rby)by(agree RAY RBY GRET);
 assert(EPX:pax=pbx)by(agree PAX PBX SRET);
 assert(EPY:pay=pby)by(agree PAY PBY SRET);
 assert(ESX:sax=sbx)by(agree SAX SBX GRET);
 assert(ESY:say=sby)by(agree SAY SBY GRET);
 assert(EVX:vax=vbx)by(agree VAX VBX SRET);
 assert(EVY:vay=vby)by(agree VAY VBY SRET).
 assert(DX:Int.sub rax pax=Int.sub rbx pbx)by(congruence).
 assert(DY:Int.sub ray pay=Int.sub rby pby)by(congruence).
 assert(CMDX:entry_axis_command a gh DA false rax pax sax vax(cid_ax _ _ DA)(cid_ix _ _ DA)=
 entry_axis_command b gh DB false rbx pbx sbx vbx(cid_ax _ _ DB)(cid_ix _ _ DB)).
 { unfold entry_axis_command,controller_command,next_command,next_integral;rewrite<-EKP,<-EKD,<-EKV,<-EKA,<-EAX,<-ESX,<-EVX,<-DX;reflexivity. }
 assert(CMDY:entry_axis_command a gh DA false ray pay say vay(cid_ay _ _ DA)(cid_iy _ _ DA)=
 entry_axis_command b gh DB false rby pby sby vby(cid_ay _ _ DB)(cid_iy _ _ DB)).
 { unfold entry_axis_command,controller_command,next_command,next_integral;rewrite<-EKP,<-EKD,<-EKV,<-EKA,<-EAY,<-ESY,<-EVY,<-DY;reflexivity. }
 assert(INTX:entry_axis_integral a gh DA false rax pax sax vax(cid_ix _ _ DA)=
 entry_axis_integral b gh DB false rbx pbx sbx vbx(cid_ix _ _ DB)).
 { reflexivity. }
 assert(INTY:entry_axis_integral a gh DA false ray pay say vay(cid_iy _ _ DA)=
 entry_axis_integral b gh DB false rby pby sby vby(cid_iy _ _ DB)).
 { reflexivity. }
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
 assert(FINAL:same_outside_return ret af bf).
 { destruct FRAME as[NB0[PERM0 BYTES0]].
   destruct SHAPEA as[NBA PA];destruct SHAPEB as[NBB PB].
   split;[rewrite NBA,NBB,NB0;reflexivity|].
   split.
   - intros blk ofs k p;rewrite(PA blk ofs k p),(PB blk ofs k p);apply PERM0.
   - intros blk ofs NR.
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
     apply BYTES0;[intros[SY R];rewrite(cid_i_symbol _ _ DA)in SY;injection SY as EQ;subst blk;apply NCI;split;[reflexivity|exact R]|exact NR]. }
 exists af,bf;split;[exact CALLA|];split;[exact CALLB|];split;[|exact FINAL].
 split.
 - eapply equal_raw_controller_observation;
   [exact(cid_pid_symbol _ _ DA)|exact(cid_i_symbol _ _ DA)|exact CAX|exact CBX|exact CAY|exact CBY|exact IAX|exact IBX|exact IAY|exact IBY].
 - split;[eapply active_fields_pair_observation;[exact ACTA|exact ACTB]|].
   split;unfold IntegralZero,old_integrals,load_global;rewrite(cid_i_symbol _ _ DA);split;assumption.

Qed.


Theorem ground_integral_independence : GroundIndependenceGoal.
Proof.
 intros gh ret a b iax iay ibx iby[PAIR REST].
 destruct(constructed_ground gh ret a b PAIR)as[af[bf[CA[CB[REL FRAME]]]]].
 split;[exists af,bf;auto|].
 intros af' bf' CA' CB'.
 assert(A:af'=af)by(eapply original_entry_all_normal_memories_unique;[exact(proj1 PAIR)|exact CA'|exact CA]).
 assert(B:bf'=bf)by(eapply original_entry_all_normal_memories_unique;[exact(proj1(proj2 PAIR))|exact CB'|exact CB]).
 subst af' bf';exact REL.
Qed.
Theorem ground_relational_frame : GroundFrameGoal.
Proof.
 intros gh ret a b iax iay ibx iby af bf[PAIR REST]CA CB.
 destruct(constructed_ground gh ret a b PAIR)as[nfa[nfb[NA[NB[REL FRAME]]]]].
 assert(A:af=nfa)by(eapply original_entry_all_normal_memories_unique;[exact(proj1 PAIR)|exact CA|exact NA]).
 assert(B:bf=nfb)by(eapply original_entry_all_normal_memories_unique;[exact(proj1(proj2 PAIR))|exact CB|exact NB]).
 subst af bf;exact FRAME.
Qed.
Theorem ground_no_error : GroundNoErrorGoal.
Proof. intros gh ret m GOOD;exact(proved_no_error gh ret m false GOOD). Qed.
Theorem ground_all_successor_termination : GroundTerminationGoal.
Proof. intros gh ret m GOOD;exact(proved_all_successor_termination gh ret m false GOOD). Qed.
Print Assumptions ground_integral_independence.
Print Assumptions ground_relational_frame.
Print Assumptions ground_no_error.
Print Assumptions ground_all_successor_termination.

(** Updating either historical value does not alter the original input domain. *)
Lemma inputgood_store_integral_x : forall m gh ret bi mf fresh,
 InputGood m gh ret ->
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some bi ->
 Genv.find_var_info E.ge bi=Some S.v_guidance_pid_trim_att_integrator ->
 -100000000<=Int.signed fresh<=100000000 ->
 Mem.store Mint32 m bi 0(Vint fresh)=Some mf ->InputGood mf gh ret.
Proof.
 intros m gh ret bi mf fresh GOOD SI VI BOUND STORE.
 destruct GOOD as[LEG[IP SAFE]].
 destruct LEG as(GR&UNIQUE&RETS&GH&RET&GLOBALS&WR&CACHE&APP&HEAD&GAINS&AXES).
 assert(GI:gh<>bi).
 { intro EQ;subst gh;pose proof(UNIQUE _ SI)as BAD;discriminate. }
 assert(PATH:forall ch b ty path,b<>bi ->load_path ch mf b ty path=load_path ch m b ty path).
 { intros ch b ty path NE;unfold load_path;destruct(path_info ty path)as[[ft ofs]|];[|reflexivity].
   eapply Mem.load_store_other;[exact STORE|left;exact NE]. }
 assert(GLOBAL:forall ch id ty path,id<>S._guidance_pid_trim_att_integrator ->
 load_global ch mf id ty path=load_global ch m id ty path).
 { intros ch id ty path NE;unfold load_global;destruct(Genv.find_symbol E.ge id)as[b|]eqn:SB;[|reflexivity].
   apply PATH;eapply Genv.global_addresses_distinct;[exact NE|exact SB|exact SI]. }
 assert(PERM:forall b ofs k pm,Mem.perm mf b ofs k pm <->Mem.perm m b ofs k pm).
 { intros;split;intro H;[eapply Mem.perm_store_2|eapply Mem.perm_store_1];eauto. }
 assert(GLOBALS':global_bytes_initialized mf).
 { eapply global_contract_after_store;[exact GLOBALS| |exact STORE].
   intros b gv VAR RO EQ;subst b;rewrite VI in VAR;injection VAR as <-;discriminate. }
 assert(WR':writable_controller_globals mf).
 { intros id IN;destruct(WR id IN)as[b[gv[SB[VB RP]]]];exists b,gv;repeat split;try assumption.
   intros ofs R;apply PERM;apply RP;exact R. }
 assert(CACHE':caches_valid mf).
 { destruct CACHE as[ps[ss[P[S0[PP SS]]]]];exists ps,ss.
   rewrite!GLOBAL by discriminate;auto. }
 assert(APP':load_global Mint8unsigned mf S._guidance_pid pid_type[S._approx_force_by_thrust]=Some(Vint Int.zero)).
 { rewrite GLOBAL by discriminate;exact APP. }
 assert(HEAD':heading_safe mf).
 { destruct HEAD as[h[H RANGE]];exists h;rewrite GLOBAL by discriminate;auto. }
 assert(GAINS':forall gain,In gain[S._kp;S._kd;S._ki;S._kv;S._ka] ->bounded_global mf S._guidance_pid pid_type[gain]0 100).
 { intros gain IN;destruct(GAINS gain IN)as[v[L R]];exists v;split;[rewrite GLOBAL by discriminate;exact L|exact R]. }
 assert(AXES':forall axis,In axis[S._x;S._y]->
 bounded_global mf S._guidance_pid_trim_att_integrator vec_type[axis](-100000000)100000000 /\
 bounded_path mf gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
 bounded_path mf gh gh_type[S._ref;S._accel;axis](-10000)10000 /\
 bounded_global mf S._state state_type[S._ned_speed_i;axis](-10000)10000).
 { intros axis IN;destruct(AXES axis IN)as[II[RS[RA VS]]];split.
   - destruct IN as[<-|[<-|[]]].
     + exists fresh;split;[unfold load_global;rewrite SI;change(Mem.load Mint32 mf bi 0=Some(Vint fresh));exact(Mem.load_store_same _ _ _ _ _ _ STORE)|exact BOUND].
     + destruct II as[i[IL IR]];exists i;split;[|exact IR].
       unfold load_global in *;rewrite SI in *;change(Mem.load Mint32 mf bi 4=Some(Vint i)).
       rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint32 bi 4)by(right;right;cbn;lia);exact IL.
   - destruct RS as[s[SL SR]];destruct RA as[a[AL AR]];destruct VS as[v[VL VR]].
     split;[exists s;split;[rewrite PATH by exact GI;exact SL|exact SR]|].
     split;[exists a;split;[rewrite PATH by exact GI;exact AL|exact AR]|].
     exists v;split;[rewrite GLOBAL by discriminate;exact VL|exact VR]. }
 assert(SAFE':position_subtractions_safe mf gh).
 { intros axis IN;destruct(SAFE axis IN)as[r[p[R[P B]]]];exists r,p.
   rewrite PATH by exact GI;rewrite GLOBAL by discriminate;auto. }
 assert(IP':initialized_positions mf gh).
 { intros axis IN;destruct(IP axis IN)as[r[p[R P]]];exists r,p.
   rewrite PATH by exact GI;rewrite GLOBAL by discriminate;auto. }
 assert(GH':Mem.range_perm mf gh 0(sizeof ce gh_type)Cur Readable).
 { intros ofs R;apply PERM;apply GH;exact R. }
 assert(RET':Mem.range_perm mf ret 0(sizeof ce sp_type)Cur Writable).
 { intros ofs R;apply PERM;apply RET;exact R. }
 unfold InputGood;split;[unfold InputGoodLegacy;tauto|exact(conj IP' SAFE')].
Qed.
Theorem ground_different_integrals_nonvacuity : GroundNonvacuityGoal.
Proof.
 destruct canonical_input_nonvacuity as(gh&ret&a&unused&dx&dy&PAIR&REST).
 pose proof(proj1 PAIR)as GOOD.
 destruct(inputgood_core_initial_data a gh ret GOOD)as[D _].
 destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
 assert(EI:bi=cid_i _ _ D)by(pose proof(cid_i_symbol _ _ D);congruence);subst bi.
 set(ix:=cid_ix _ _ D);set(iy:=cid_iy _ _ D).
 assert(OLD:old_integrals a ix iy).
 { unfold old_integrals,load_global;rewrite(cid_i_symbol _ _ D);split;[exact(cid_integral_x _ _ D)|exact(cid_integral_y _ _ D)]. }
 assert(FRESH:exists fresh,-100000000<=Int.signed fresh<=100000000 /\ix<>fresh).
 { destruct(Int.eq_dec ix Int.zero)as[EQ|NE].
   - exists Int.one;split;[change(-100000000<=1<=100000000);lia|subst ix;rewrite EQ;discriminate].
   - exists Int.zero;split;[rewrite Int.signed_zero;lia|exact NE]. }
 destruct FRESH as[fresh[BOUND DIFF]].
 assert(VA:Mem.valid_access a Mint32(cid_i _ _ D)0 Writable).
 { apply scalar_access_inside with(n:=8);[exact(cid_i_writable _ _ D)|lia|cbn;lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store a Mint32(cid_i _ _ D)0(Vint fresh)VA)as[b STORE].
 assert(GOODB:InputGood b gh ret)by(eapply inputgood_store_integral_x;[exact GOOD|exact(cid_i_symbol _ _ D)|exact VI|exact BOUND|exact STORE]).
 assert(NEW:old_integrals b fresh iy).
 { unfold old_integrals,load_global;rewrite(cid_i_symbol _ _ D);split.
   - exact(Mem.load_store_same _ _ _ _ _ _ STORE).
   - change(Mem.load Mint32 b(cid_i _ _ D)4=Some(Vint iy)).
     rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint32(cid_i _ _ D)4)by(right;right;cbn;lia);exact(cid_integral_y _ _ D). }
 assert(FRAME:same_except_integrals_and_return ret a b).
 { split;[rewrite(Mem.nextblock_store _ _ _ _ _ _ STORE);reflexivity|];split.
   - intros blk ofs k pm;split;intro P;[eapply Mem.perm_store_1|eapply Mem.perm_store_2];eauto.
   - intros blk ofs NT NR;rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ STORE blk ofs 1);[reflexivity|].
     destruct(peq blk(cid_i _ _ D))as[EQ|NE];[subst blk;right;right|left;exact NE].
     assert(NRANGE:~0<=ofs<8)by(intro R;apply NT;split;[exact(cid_i_symbol _ _ D)|exact R]).
     cbn;lia. }
 assert(BASE:GroundBasePair gh ret a b)by(exact(conj GOOD(conj GOODB FRAME))).
 exists gh,ret,a,b,ix,iy,fresh,iy;split;[exact(conj BASE(conj OLD NEW))|];split;[exact DIFF|].
 exact(constructed_ground gh ret a b BASE).
Qed.
Print Assumptions ground_different_integrals_nonvacuity.
