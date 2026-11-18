From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory MemoryShape FlightSemantics ControllerPrefix.
From PidPositionSafety Require Import FactoryCall.
From PidPositionTranslationAttempt002 Require Import EntryIntegration WitnessMemory WitnessUpdates ByteAgreement CoreInputs FramedNormalReturn MainGoals InputSemantics.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic SemanticBridge.
From PidMeasurementProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
From PidAlternatingAttempt001 Require Import Witness Semantic.
From PidInputOrderProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.
Ltac expose_path :=
 lazymatch goal with |-load_path ?ch ?mm ?bb ?ty ?path=Some ?v=>
 let info:=eval vm_compute in(path_info ty path)in
 lazymatch info with Some(_,?ofs)=>change(Mem.load ch mm bb ofs=Some v)end
 end.

Lemma prepare_reference_store : forall m gh ret r r' kp ki ix,
 -4096<=r'<=4096 ->AlternatingInput m gh ret r kp ki ix ->
 Mem.range_perm m gh 0 84 Cur Writable ->PrivateBlocks gh ret ->
 exists q,ReferenceStore gh m r' q /\EnvironmentStep gh m q /\AlternatingInput q gh ret r' kp ki ix /\
 Mem.range_perm q gh 0 84 Cur Writable.
Proof.
 intros m gh ret r r' kp ki ix RANGE INPUT WG PRIVATE.
 pose proof INPUT as INPUT0.
 destruct INPUT as(GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 pose proof GOOD as GOOD0.
 destruct GOOD as(LEG&INIT&SAFE).
 destruct LEG as(GR&UNIQ&RET&GHREAD&RETWRITE&GLOBAL&CTRL&CACHE&APP&HS&GAINS&BOUNDS).
 assert(ACCESS:Mem.valid_access m Mint32 gh 44 Writable).
 { eapply scalar_access_inside with(n:=84);[exact WG|lia|cbn;lia|witness_align]. }
 destruct(Mem.valid_access_store m Mint32 gh 44(Vint(Int.repr r'))ACCESS)as[q STORE].
 assert(KEEP:forall ch b ofs v,Mem.load ch m b ofs=Some v ->
 (b<>gh \/ofs+size_chunk ch<=44 \/48<=ofs) ->Mem.load ch q b ofs=Some v).
 { intros ch b ofs v LOAD MISS;erewrite Mem.load_store_other;[exact LOAD|exact STORE|cbn;exact MISS]. }
 assert(GKEEP:forall id ty path ch v,load_global ch m id ty path=Some v ->
 load_global ch q id ty path=Some v).
 { intros id ty path ch v LOAD;unfold load_global,load_path in LOAD|-*.
   destruct(Genv.find_symbol E.ge id)as[b|]eqn:SY in LOAD|-*;try discriminate LOAD.
   destruct(path_info ty path)as[[ft ofs]|]eqn:PATH in LOAD|-*;try discriminate LOAD.
   apply KEEP;[exact LOAD|left].
   intro EQ;subst b;specialize(UNIQ id SY);subst id.
   destruct(actual_global_variable_binding S._guidance_h S.v_guidance_h ltac:(vm_compute;reflexivity))as[hb[SH VH]].
   rewrite SY in SH;injection SH as<-;exact(proj1(PRIVATE gh _ VH)eq_refl). }
 assert(RXF:load_path Mint32 q gh gh_type[S._ref;S._pos;S._x]=Some(Vint(Int.repr r'))).
 { change(Mem.load Mint32 q gh 44=Some(Vint(Int.repr r')));exact(Mem.load_store_same _ _ _ _ _ _ STORE). }
 assert(RYF:load_path Mint32 q gh gh_type[S._ref;S._pos;S._y]=Some(Vint Int.zero)).
 { expose_path;apply KEEP;[exact RY|right;right;cbn;lia]. }
 assert(AXESF:forall axis,In axis[S._x;S._y]->
 load_path Mint32 q gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
 load_path Mint32 q gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
 load_global Mint32 q S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero)).
 { intros axis IN;destruct(AXES axis IN)as(SPEED&ACCEL&VEL).
   split;[|split].
   - destruct IN as[<-|[<-|[]]];(expose_path;apply KEEP;[exact SPEED|right;right;cbn;lia]).
   - destruct IN as[<-|[<-|[]]];(expose_path;apply KEEP;[exact ACCEL|right;right;cbn;lia]).
   - apply GKEEP;exact VEL. }
 assert(SAFEF:position_subtractions_safe q gh).
 { intros axis IN;destruct IN as[<-|[<-|[]]].
   - exists(Int.repr r'),Int.zero;split;[exact RXF|];split;[apply GKEEP;exact PX|].
     unfold signed32;rewrite Int.signed_repr by(change(-2147483648<=r'<=2147483647);lia);rewrite Int.signed_zero;lia.
   - exists Int.zero,Int.zero;split;[exact RYF|];split;[apply GKEEP;exact PY|].
     unfold signed32;rewrite Int.signed_zero;lia. }
 assert(INITF:initialized_positions q gh).
 { intros axis IN;destruct(SAFEF axis IN)as(a&b&L&M&N);eauto. }
 assert(LEGF:InputGoodLegacy q gh ret).
 { unfold InputGoodLegacy;refine (conj GR (conj UNIQ (conj RET (conj _ (conj _ (conj _ (conj _ (conj _ (conj _ (conj _ (conj _ (_)))))))))))).
   - intros z R;eapply Mem.perm_store_1;[exact STORE|apply GHREAD;exact R].
   - intros z R;eapply Mem.perm_store_1;[exact STORE|apply RETWRITE;exact R].
   - eapply global_contract_after_store;[exact GLOBAL| |exact STORE].
     intros b gv VAR RO;exact(proj1(PRIVATE b gv VAR)).
   - intros id IN;destruct(CTRL id IN)as(b&gv&CSYM&VA&RP);exists b,gv;split;[exact CSYM|];split;[exact VA|].
     intros z R;eapply Mem.perm_store_1;[exact STORE|apply RP;exact R].
   - destruct CACHE as(ps&ss&PS&SS&BP&BS);exists ps,ss;split;[apply GKEEP;exact PS|];split;[apply GKEEP;exact SS|];split;assumption.
   - apply GKEEP;exact APP.
   - destruct HS as(h&LOAD&LO&HI);exists h;split;[apply GKEEP;exact LOAD|];split;assumption.
   - intros gain IN;destruct(GAINS gain IN)as(v&LOAD&BOUND);exists v;split;[apply GKEEP;exact LOAD|exact BOUND].
   - intros axis IN;destruct(BOUNDS axis IN)as(INT&SPD&ACC&VEL).
     split.
     + destruct INT as(v&LOAD&BOUND);exists v;split;[apply GKEEP;exact LOAD|exact BOUND].
     + destruct(AXESF axis IN)as(SPEED&ACCEL&MEASURED);split.
       * exists Int.zero;split;[exact SPEED|rewrite Int.signed_zero;lia].
       * split.
         -- exists Int.zero;split;[exact ACCEL|rewrite Int.signed_zero;lia].
         -- exists Int.zero;split;[exact MEASURED|rewrite Int.signed_zero;lia]. }
 exists q;split;[exact STORE|];split.
 - split.
   + eapply Mem.store_unchanged_on;[exact STORE|].
     intros z R NOT;apply NOT;left;split;[reflexivity|cbn in R;lia].
   + intros axis IN;unfold load_global,load_path.
     destruct(Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator)as[b|]eqn:SY;[|reflexivity].
     destruct(path_info vec_type[axis])as[[ty ofs]|]eqn:PI;[|reflexivity].
     erewrite Mem.load_store_other;[reflexivity|exact STORE|left].
     destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
     rewrite SY in SI;injection SI as<-;exact(proj1(PRIVATE b _ VI)).
 - split.
   + unfold AlternatingInput;exact (conj (conj LEGF (conj INITF SAFEF)) (conj (RXF) (conj (RYF) (conj (GKEEP _ _ _ _ _ PX) (conj (GKEEP _ _ _ _ _ PY) (conj (AXESF) (conj (GKEEP _ _ _ _ _ KP) (conj (GKEEP _ _ _ _ _ KD) (conj (GKEEP _ _ _ _ _ KI) (conj (GKEEP _ _ _ _ _ KV) (conj (GKEEP _ _ _ _ _ KA) (conj (GKEEP _ _ _ _ _ HEAD) (conj (GKEEP _ _ _ _ _ IX) (GKEEP _ _ _ _ _ IY)))))))))))))).
   + intros z R;eapply Mem.perm_store_1;[exact STORE|apply WG;exact R].
Qed.

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

Lemma common_initial_exists:
 exists gh ret m,OrderInitial m gh ret /\
 Mem.range_perm m gh 0 84 Cur Writable /\PrivateBlocks gh ret.
Proof.
 destruct(initial_private_writable_input_exists 0 1 1 ltac:(unfold Parameters;lia))
 as(gh&ret&base&INPUT&WG&PRIVATE).
 pose proof INPUT as(GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 destruct(inputgood_core_initial_data base gh ret GOOD)as[D _].
 destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator
   S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
 assert(EI:bi=cid_i _ _ D)by(pose proof(cid_i_symbol _ _ D);congruence).
 assert(VA:Mem.valid_access base Mint32 bi 0 Writable).
 { rewrite EI;eapply scalar_access_inside with(n:=8);[exact(cid_i_writable _ _ D)|lia|cbn;lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store base Mint32 bi 0(Vint(Int.repr limit))VA)as[m STORE].
 assert(BOUND:-100000000<=Int.signed(Int.repr limit)<=100000000).
 { change(-100000000<=93650944<=100000000);lia. }
 assert(GOOD':InputGood m gh ret).
 { eapply inputgood_store_integral_x;eassumption. }
 assert(GI:gh<>bi).
 { eapply inputgood_guidance_separate;[exact GOOD|exact SI|discriminate]. }
 assert(PATH:forall ch b ty path,b<>bi ->load_path ch m b ty path=load_path ch base b ty path).
 { intros ch b ty path NE;unfold load_path;destruct(path_info ty path)as[[ft ofs]|];[|reflexivity].
   eapply Mem.load_store_other;[exact STORE|left;exact NE]. }
 assert(GLOBAL:forall ch id ty path,id<>S._guidance_pid_trim_att_integrator ->
 load_global ch m id ty path=load_global ch base id ty path).
 { intros ch id ty path NE;unfold load_global;destruct(Genv.find_symbol E.ge id)as[b|]eqn:SB;[|reflexivity].
   apply PATH;eapply Genv.global_addresses_distinct;[exact NE|exact SB|exact SI]. }
 assert(AXES':forall axis,In axis[S._x;S._y]->
 load_path Mint32 m gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
 load_path Mint32 m gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero)).
 { intros axis IN;destruct(AXES axis IN)as[SPEED[ACCEL VEL]];
   rewrite !PATH by exact GI;rewrite GLOBAL by discriminate;auto. }
 exists gh,ret,m;split.
 - unfold OrderInitial,AlternatingInput;split;[exact GOOD'|].
   split;[rewrite PATH by exact GI;exact RX|].
   split;[rewrite PATH by exact GI;exact RY|].
   split;[rewrite GLOBAL by discriminate;exact PX|].
   split;[rewrite GLOBAL by discriminate;exact PY|].
   split;[exact AXES'|].
   split;[rewrite GLOBAL by discriminate;exact KP|].
   split;[rewrite GLOBAL by discriminate;exact KD|].
   split;[rewrite GLOBAL by discriminate;exact KI|].
   split;[rewrite GLOBAL by discriminate;exact KV|].
   split;[rewrite GLOBAL by discriminate;exact KA|].
   split;[rewrite GLOBAL by discriminate;exact HEAD|];split.
   + unfold integral_load,load_global;rewrite SI;exact(Mem.load_store_same _ _ _ _ _ _ STORE).
   + unfold load_global in IY|-*;rewrite SI in IY|-*.
     change(Mem.load Mint32 m bi 4=Some(Vint Int.zero)).
     rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint32 bi 4)by(right;right;cbn;lia);exact IY.
 - split;[intros z R;eapply Mem.perm_store_1;[exact STORE|apply WG;exact R]|exact PRIVATE].
Qed.
From PidAlternatingAttempt001 Require Import Proof.
Lemma execute_reference:forall m gh ret r iz r' jz,
 AlternatingInput m gh ret r 1 1(Int.repr iz) ->
 Mem.range_perm m gh 0 84 Cur Writable ->PrivateBlocks gh ret ->
 -4096<=r'<=4096 ->
 zclamp integral_limit(Int.signed(Int.repr iz)+1*(1*r'/64))=jz ->
 exists q mf,
 ReferenceStore gh m r' q /\
 AlternatingInput q gh ret r' 1 1(Int.repr iz) /\
 NormalCall gh ret true q mf /\
 AlternatingInput mf gh ret r' 1 1(Int.repr jz) /\
 Mem.range_perm mf gh 0 84 Cur Writable.
Proof.
 intros m gh ret r iz r' jz INPUT WRITE PRIVATE RR CALC.
 destruct(prepare_reference_store m gh ret r r' 1 1(Int.repr iz)RR INPUT WRITE PRIVATE)
 as(q&STORE&ENV&IQ&WQ).
 destruct(normal_call_exists q gh ret(input_good _ _ _ _ _ _ _ IQ))as[mf CALL].
 destruct(returned_input q mf gh ret r' 1 1(Int.repr iz)RR ltac:(lia)ltac:(lia)IQ WQ PRIVATE CALL)
 as[iy[IF WF]].
 destruct(original_call_integral_exact q mf gh ret r' 1 1(Int.repr iz)RR ltac:(lia)ltac:(lia)IQ CALL)
 as[j[LOAD SIGN]].
 assert(EQ:iy=j)by(eapply integral_unique;[exact(input_integral _ _ _ _ _ _ _ IF)|exact LOAD]).
 assert(EQJ:j=Int.repr jz)by(rewrite<-(Int.repr_signed j),SIGN,CALC;reflexivity).
 rewrite EQ,EQJ in IF;exists q,mf;exact(conj STORE(conj IQ(conj CALL(conj IF WF)))).
Qed.

Lemma zero_reference_observed : forall m gh ret mf iz cmd,
 AlternatingInput m gh ret 0 1 1(Int.repr iz) ->
 ((iz=limit-1 /\cmd=1428)\/(iz=limit /\cmd=1429)) ->
 NormalCall gh ret true m mf ->ObservedX ret mf cmd iz.
Proof.
 intros m gh ret mf iz cmd INPUT CASE CALL0.
 destruct INPUT as(GOOD&RX0&RY0&PX0&PY0&AXES&KP0&KD0&KI0&KV0&KA0&HEAD&IX0&IY0).
 destruct(AXES S._x ltac:(cbn;auto))as(SX0&AX0&VX0).
 destruct(AXES S._y ltac:(cbn;auto))as(SY0&AY0&VY0).
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 assert(KP:cid_kp _ _ D=Int.one).
 { pose proof(cid_gain_p _ _ D)as L;unfold load_global in KP0;
   rewrite(cid_pid_symbol _ _ D)in KP0;change(Mem.load Mint32 m(cid_pid _ _ D)0=Some(Vint Int.one))in KP0;congruence. }
 assert(KD:cid_kd _ _ D=Int.zero).
 { pose proof(cid_gain_d _ _ D)as L;unfold load_global in KD0;
   rewrite(cid_pid_symbol _ _ D)in KD0;change(Mem.load Mint32 m(cid_pid _ _ D)4=Some(Vint Int.zero))in KD0;congruence. }
 assert(KI:cid_ki _ _ D=Int.one).
 { pose proof(cid_gain_i _ _ D)as L;unfold load_global in KI0;
   rewrite(cid_pid_symbol _ _ D)in KI0;change(Mem.load Mint32 m(cid_pid _ _ D)8=Some(Vint Int.one))in KI0;congruence. }
 assert(KV:cid_kv _ _ D=Int.zero).
 { pose proof(cid_gain_v _ _ D)as L;unfold load_global in KV0;
   rewrite(cid_pid_symbol _ _ D)in KV0;change(Mem.load Mint32 m(cid_pid _ _ D)12=Some(Vint Int.zero))in KV0;congruence. }
 assert(KA:cid_ka _ _ D=Int.zero).
 { pose proof(cid_gain_a _ _ D)as L;unfold load_global in KA0;
   rewrite(cid_pid_symbol _ _ D)in KA0;change(Mem.load Mint32 m(cid_pid _ _ D)16=Some(Vint Int.zero))in KA0;congruence. }
 assert(AX:cid_ax _ _ D=Int.zero)by(pose proof(cid_accel_x _ _ D);change(Mem.load Mint32 m gh 60=Some(Vint Int.zero))in AX0;congruence).
 assert(IX:cid_ix _ _ D=Int.repr iz).
 { pose proof(cid_integral_x _ _ D)as L;unfold integral_load,load_global in IX0;
   rewrite(cid_i_symbol _ _ D)in IX0;change(Mem.load Mint32 m(cid_i _ _ D)0=Some(Vint(Int.repr iz)))in IX0;congruence. }
 destruct(original_entry_normal_result m gh ret true D GOOD)
 as(out&rx&ry&px&py&sx&sy&vx&vy&sb&CALL&SS&RX&RY&PX&PY&SX&SY&VX&VY&ACTIVE&IFX&IFY&CMDX&CMDY).
 assert(EQ:mf=out)by(eapply original_entry_all_normal_memories_unique;[exact GOOD|exact CALL0|exact CALL]);subst out.
 assert(RXE:rx=Int.repr 0)by(congruence).
 assert(SXE:sx=Int.zero)by(congruence).
 assert(PXE:px=Int.zero).
 { unfold load_global in PX0;rewrite SS in PX0;change(Mem.load Mint32 m sb 100=Some(Vint Int.zero))in PX0;congruence. }
 assert(VXE:vx=Int.zero).
 { unfold load_global in VX0;rewrite SS in VX0;change(Mem.load Mint32 m sb 296=Some(Vint Int.zero))in VX0;congruence. }
 unfold entry_axis_command in ACTIVE,CMDX.
 unfold entry_axis_integral in IFX.
 rewrite KP,KD,KI,KV,KA,AX,IX,RXE,SXE,PXE,VXE in ACTIVE,CMDX.
 rewrite KP,KD,KI,IX,RXE,SXE,PXE,VXE in IFX.
 assert(CALC:
 controller_command true Int.one Int.zero Int.one Int.zero Int.zero
 (ClampSemantics.clamp_bits(Int.sub(Int.repr 0)Int.zero)(Int.repr 4096))
 (ClampSemantics.clamp_bits(Int.sub Int.zero Int.zero)(Int.repr 8388608))
 Int.zero Int.zero(Int.repr iz)(Int.repr 1429)(Int.repr 3216)=Int.repr cmd).
 { destruct CASE as[[I C]|[I C]];subst iz cmd;apply Int.same_if_eq;vm_compute;reflexivity. }
 assert(ICALC:
 next_integral true(Int.repr iz)Int.one
 (pd_bits Int.one Int.zero
 (ClampSemantics.clamp_bits(Int.sub(Int.repr 0)Int.zero)(Int.repr 4096))
 (ClampSemantics.clamp_bits(Int.sub Int.zero Int.zero)(Int.repr 8388608)))
 (Int.repr 1429)=Int.repr iz).
 { destruct CASE as[[I C]|[I C]];subst iz cmd;apply Int.same_if_eq;vm_compute;reflexivity. }
 rewrite CALC in ACTIVE,CMDX;rewrite ICALC in IFX.

 destruct ACTIVE as(TY&FMT&X&REST).
 unfold ObservedX;split;[exact TY|];split;[exact FMT|];split;[exact X|];split.
 - unfold load_global;rewrite(cid_pid_symbol _ _ D);exact CMDX.
 - unfold integral_load,load_global;rewrite(cid_i_symbol _ _ D);exact IFX.
Qed.

Lemma different_outputs:forall ret af bf,
 ObservedX ret af 1428(limit-1) ->ObservedX ret bf 1429 limit ->
 ~SameFinalX ret af bf.
Proof.
 intros ret af bf(_&_&A&_) (_&_&B&_) (_&_&RET&_).
 rewrite A,B in RET;vm_compute in RET;discriminate.
Qed.
Theorem proved_actual_order_counterexample:ActualOrderCounterexampleGoal.
Proof.
 destruct common_initial_exists as(gh&ret&m&INITIAL&W&PRIVATE).
 pose proof INITIAL as INPUT.
 unfold OrderInitial in INPUT.
 destruct(execute_reference m gh ret 0 limit 64 limit INPUT W PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qa1&a1&SA1&IA1&CA1&FA1&WA1).
 destruct(execute_reference a1 gh ret 64 limit (-64)(limit-1)FA1 WA1 PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qa2&a2&SA2&IA2&CA2&FA2&WA2).
 destruct(execute_reference a2 gh ret (-64)(limit-1)0(limit-1)FA2 WA2 PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qa3&af&SA3&IA3&CA3&FA3&WAF).
 destruct(execute_reference m gh ret 0 limit (-64)(limit-1)INPUT W PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qb1&b1&SB1&IB1&CB1&FB1&WB1).
 destruct(execute_reference b1 gh ret (-64)(limit-1)64 limit FB1 WB1 PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qb2&b2&SB2&IB2&CB2&FB2&WB2).
 destruct(execute_reference b2 gh ret 64 limit 0 limit FB2 WB2 PRIVATE ltac:(lia)ltac:(vm_compute;reflexivity))
 as(qb3&bf&SB3&IB3&CB3&FB3&WBF).
 assert(RUNA:OrderRun gh ret[64;-64;0]m af).
 { eapply order_cons with(q:=qa1)(after:=a1)(ix:=Int.repr limit);try eassumption;try lia.
   eapply order_cons with(q:=qa2)(after:=a2)(ix:=Int.repr limit);try eassumption;try lia.
   eapply order_cons with(q:=qa3)(after:=af)(ix:=Int.repr(limit-1));try eassumption;try lia.
   constructor. }
 assert(RUNB:OrderRun gh ret[-64;64;0]m bf).
 { eapply order_cons with(q:=qb1)(after:=b1)(ix:=Int.repr limit);try eassumption;try lia.
   eapply order_cons with(q:=qb2)(after:=b2)(ix:=Int.repr(limit-1));try eassumption;try lia.
   eapply order_cons with(q:=qb3)(after:=bf)(ix:=Int.repr limit);try eassumption;try lia.
   constructor. }
 assert(OA:ObservedX ret af 1428(limit-1)).
 { eapply zero_reference_observed;[exact IA3|left;auto|exact CA3]. }
 assert(OB:ObservedX ret bf 1429 limit).
 { eapply zero_reference_observed;[exact IB3|right;auto|exact CB3]. }
 exists gh,ret,m,af,bf;refine(conj INITIAL(conj RUNA(conj RUNB(conj OA(conj OB _))))).
 eapply different_outputs;[exact OA|exact OB].
Qed.
Theorem proved_order_invariance_refuted:OrderInvarianceRefutedGoal.
Proof.
 intros ALL.
 destruct proved_actual_order_counterexample as(gh&ret&m&af&bf&INITIAL&RA&RB&OA&OB&DIFF).
 apply DIFF.
 apply(ALL gh ret m[64;-64;0][-64;64;0]af bf INITIAL).
 - discriminate.
 - discriminate.
 - apply perm_swap.
 - reflexivity.
 - exact RA.
 - exact RB.
Qed.
Print Assumptions common_initial_exists.
Print Assumptions proved_actual_order_counterexample.
Print Assumptions proved_order_invariance_refuted.
