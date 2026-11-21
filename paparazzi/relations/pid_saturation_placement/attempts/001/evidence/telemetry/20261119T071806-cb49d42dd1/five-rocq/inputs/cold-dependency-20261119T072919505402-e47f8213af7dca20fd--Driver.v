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

Lemma prepare_input : forall m gh ret r r' kp ki ix,
 -4096<=r'<=4096 ->AlternatingInput m gh ret r kp ki ix ->
 Mem.range_perm m gh 0 84 Cur Writable ->PrivateBlocks gh ret ->
 exists q,EnvironmentStep gh m q /\AlternatingInput q gh ret r' kp ki ix /\
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
 exists q;split.
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
Lemma mutable_global_not_readonly : forall id b gv,
 In id[S._guidance_pid;S._guidance_pid_pos_err;S._guidance_pid_speed_err;S._guidance_pid_trim_att_integrator] ->
 Genv.find_symbol E.ge id=Some b ->Genv.find_var_info E.ge b=Some gv ->gvar_readonly gv=false.
Proof.
 intros id b gv IN SY VAR;destruct IN as[<-|[<-|[<-|[<-|[]]]]].
 all:match goal with
 |SY:Genv.find_symbol _ S._guidance_pid=Some _ |- _=>destruct(actual_global_variable_binding S._guidance_pid S.v_guidance_pid ltac:(vm_compute;reflexivity))as[b0[S0 V0]]
 |SY:Genv.find_symbol _ S._guidance_pid_pos_err=Some _ |- _=>destruct(actual_global_variable_binding S._guidance_pid_pos_err S.v_guidance_pid_pos_err ltac:(vm_compute;reflexivity))as[b0[S0 V0]]
 |SY:Genv.find_symbol _ S._guidance_pid_speed_err=Some _ |- _=>destruct(actual_global_variable_binding S._guidance_pid_speed_err S.v_guidance_pid_speed_err ltac:(vm_compute;reflexivity))as[b0[S0 V0]]
 |SY:Genv.find_symbol _ S._guidance_pid_trim_att_integrator=Some _ |- _=>destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[b0[S0 V0]]
 end.
 all:rewrite SY in S0;injection S0 as<-;rewrite V0 in VAR;injection VAR as<-;reflexivity.
Qed.

Lemma returned_input : forall m mf gh ret r kp ki ix,
 -4096<=r<=4096 ->0<=kp<=100 ->0<=ki<=100 ->
 AlternatingInput m gh ret r kp ki ix ->Mem.range_perm m gh 0 84 Cur Writable ->
 PrivateBlocks gh ret ->NormalCall gh ret true m mf ->
 exists iy,AlternatingInput mf gh ret r kp ki iy /\Mem.range_perm mf gh 0 84 Cur Writable.
Proof.
 intros m mf gh ret r kp ki ix RR KPR KIR INPUT WG PRIVATE CALL.
 pose proof INPUT as INPUT0.
 destruct INPUT as(GOOD&RX0&RY0&PX0&PY0&AXES0&KP0&KD0&KI0&KV0&KA0&HEAD0&IX0&IY0).
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 destruct(original_entry_framed_normal_result m gh ret true D GOOD)
 as(out&rx&ry&px&py&sx&sy&vx&vy&sb&be&bs&NC&STATE&RX&RY&PX&PY&SX&SY&VX&VY&
 ACTIVE&IX&IY&CX&CY&PEX&PEY&SEX&SEY&RXF&RYF&ES&VS&SHAPE&FRAME&BYTES).
 assert(EQ:mf=out)by(eapply original_entry_all_normal_memories_unique;[exact GOOD|exact CALL|exact NC]);subst out.
 pose proof GOOD as(GLEG&GINIT&GSAFE).
 destruct GLEG as(GR&UNIQ&RET&GHREAD&RETWRITE&GLOBAL&CTRL&CACHE&APP&HS&GAINS&BOUNDS).
 destruct SHAPE as[NB PERM].
 assert(KEEP:forall ch b ofs v,Mem.load ch m b ofs=Some v ->b<>ret ->
 (b<>be \/ofs+size_chunk ch<=0 \/8<=ofs) ->(b<>bs \/ofs+size_chunk ch<=0 \/8<=ofs) ->
 (b<>cid_pid _ _ D \/ofs+size_chunk ch<=32 \/40<=ofs) ->
 (b<>cid_i _ _ D \/ofs+size_chunk ch<=0 \/8<=ofs) ->Mem.load ch mf b ofs=Some v).
 { intros ch b ofs v LOAD BR BE BS BP BI.
   destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[bytes[LB DEC]].
   rewrite DEC;apply Mem.loadbytes_load;[|exact(proj2(Mem.load_valid_access _ _ _ _ _ LOAD))].
   rewrite(FRAME b ofs(size_chunk ch)).
   - exact LB.
   - eapply loaded_block;exact LOAD.
   - exact BR.
   - exact BE.
   - exact BS.
   - exact BP.
   - exact BI.
   - pose proof(size_chunk_pos ch);lia. }
 assert(GHKEEP:forall ch ofs v,Mem.load ch m gh ofs=Some v ->Mem.load ch mf gh ofs=Some v).
 { intros ch ofs v LOAD;apply KEEP;[exact LOAD|exact GR| | | |].
   - left;eapply inputgood_guidance_separate;[exact GOOD|exact ES|discriminate].
   - left;eapply inputgood_guidance_separate;[exact GOOD|exact VS|discriminate].
   - left;eapply inputgood_guidance_separate;[exact GOOD|exact(cid_pid_symbol _ _ D)|discriminate].
   - left;eapply inputgood_guidance_separate;[exact GOOD|exact(cid_i_symbol _ _ D)|discriminate]. }
 assert(GHPATH:forall ch ty path v,load_path ch m gh ty path=Some v ->load_path ch mf gh ty path=Some v).
 { intros ch ty path v LOAD;unfold load_path in LOAD|-*.
   destruct(path_info ty path)as[[ft ofs]|]eqn:PI in LOAD|-*;try discriminate LOAD.
   apply GHKEEP;exact LOAD. }
 assert(STATIC:forall id ty path ch v,
 id<>S._guidance_pid_pos_err ->id<>S._guidance_pid_speed_err ->
 id<>S._guidance_pid ->id<>S._guidance_pid_trim_att_integrator ->
 load_global ch m id ty path=Some v ->load_global ch mf id ty path=Some v).
 { intros id ty path ch v NE NS NP NI LOAD;unfold load_global,load_path in LOAD|-*.
   destruct(Genv.find_symbol E.ge id)as[b|]eqn:SYMBOL in LOAD|-*;try discriminate LOAD.
   destruct(path_info ty path)as[[ft ofs]|]eqn:PI in LOAD|-*;try discriminate LOAD.
   apply KEEP;[exact LOAD| | | | |].
   - intro EQ;subst b;exact(RET id SYMBOL).
   - left;eapply Genv.global_addresses_distinct;[exact NE|exact SYMBOL|exact ES].
   - left;eapply Genv.global_addresses_distinct;[exact NS|exact SYMBOL|exact VS].
   - left;eapply Genv.global_addresses_distinct;[exact NP|exact SYMBOL|exact(cid_pid_symbol _ _ D)].
   - left;eapply Genv.global_addresses_distinct;[exact NI|exact SYMBOL|exact(cid_i_symbol _ _ D)]. }
 assert(PIDKEEP:forall ch ofs v,Mem.load ch m(cid_pid _ _ D)ofs=Some v ->
 ofs+size_chunk ch<=32 \/40<=ofs ->Mem.load ch mf(cid_pid _ _ D)ofs=Some v).
 { intros ch ofs v LOAD RANGE;apply KEEP;[exact LOAD| | | |right;exact RANGE|].
   - intro EQ;apply(RET S._guidance_pid);rewrite<-EQ;exact(cid_pid_symbol _ _ D).
   - left;eapply Genv.global_addresses_distinct;[|exact(cid_pid_symbol _ _ D)|exact ES];discriminate.
   - left;eapply Genv.global_addresses_distinct;[|exact(cid_pid_symbol _ _ D)|exact VS];discriminate.
   - left;eapply Genv.global_addresses_distinct;[|exact(cid_pid_symbol _ _ D)|exact(cid_i_symbol _ _ D)];discriminate. }
 assert(KPF:load_global Mint32 mf S._guidance_pid pid_type[S._kp]=Some(Vint(Int.repr kp))).
 { unfold load_global in KP0|-*;rewrite(cid_pid_symbol _ _ D)in KP0|-*;expose_path;apply PIDKEEP;[exact KP0|cbn;lia]. }
 assert(KDF:load_global Mint32 mf S._guidance_pid pid_type[S._kd]=Some(Vint Int.zero)).
 { unfold load_global in KD0|-*;rewrite(cid_pid_symbol _ _ D)in KD0|-*;expose_path;apply PIDKEEP;[exact KD0|cbn;lia]. }
 assert(KIF:load_global Mint32 mf S._guidance_pid pid_type[S._ki]=Some(Vint(Int.repr ki))).
 { unfold load_global in KI0|-*;rewrite(cid_pid_symbol _ _ D)in KI0|-*;expose_path;apply PIDKEEP;[exact KI0|cbn;lia]. }
 assert(KVF:load_global Mint32 mf S._guidance_pid pid_type[S._kv]=Some(Vint Int.zero)).
 { unfold load_global in KV0|-*;rewrite(cid_pid_symbol _ _ D)in KV0|-*;expose_path;apply PIDKEEP;[exact KV0|cbn;lia]. }
 assert(KAF:load_global Mint32 mf S._guidance_pid pid_type[S._ka]=Some(Vint Int.zero)).
 { unfold load_global in KA0|-*;rewrite(cid_pid_symbol _ _ D)in KA0|-*;expose_path;apply PIDKEEP;[exact KA0|cbn;lia]. }
 assert(APPF:load_global Mint8unsigned mf S._guidance_pid pid_type[S._approx_force_by_thrust]=Some(Vint Int.zero)).
 { unfold load_global in APP|-*;rewrite(cid_pid_symbol _ _ D)in APP|-*;expose_path;apply PIDKEEP;[exact APP|cbn;lia]. }
 assert(RXF0:load_path Mint32 mf gh gh_type[S._ref;S._pos;S._x]=Some(Vint(Int.repr r))).
 { apply GHPATH;exact RX0. }
 assert(RYF0:load_path Mint32 mf gh gh_type[S._ref;S._pos;S._y]=Some(Vint Int.zero)).
 { apply GHPATH;exact RY0. }
 assert(PXF:load_global Mint32 mf S._state state_type[S._ned_pos_i;S._x]=Some(Vint Int.zero)).
 { eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact PX0]. }
 assert(PYF:load_global Mint32 mf S._state state_type[S._ned_pos_i;S._y]=Some(Vint Int.zero)).
 { eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact PY0]. }
 assert(AXESF:forall axis,In axis[S._x;S._y]->
 load_path Mint32 mf gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
 load_path Mint32 mf gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
 load_global Mint32 mf S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero)).
 { intros axis IN;destruct(AXES0 axis IN)as(SPEED&ACCEL&VEL);split;[apply GHPATH;exact SPEED|];split.
   - apply GHPATH;exact ACCEL.
   - eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact VEL]. }
 assert(HEADF:load_global Mfloat32 mf S._guidance_h gh_type[S._sp;S._heading]=Some(Vsingle Float32.zero)).
 { eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact HEAD0]. }
 destruct(original_call_integral_exact m mf gh ret r kp ki ix RR KPR KIR INPUT0 CALL)as[iy[IYLOAD IYSIGNED]].
 assert(IBOUND:-100000000<=Int.signed iy<=100000000).
 { rewrite IYSIGNED;pose proof(zclamp_bounds integral_limit(Int.signed ix+ki*(kp*r/64))ltac:(unfold integral_limit;lia));unfold integral_limit in *;lia. }
 pose proof(original_call_y_zero m mf gh ret r kp ki ix INPUT0 CALL)as YZERO.
 assert(GLOBALF:global_bytes_initialized mf).
 { destruct GLOBAL as[init[INIT VARS]];exists init;split;[exact INIT|].
   intros b gv VAR;destruct(VARS b gv VAR)as[RP BY];split.
   - intros z R;apply(proj2(PERM b z Cur Readable));apply RP;exact R.
   - intros RO z R;rewrite(FRAME b z 1);[apply BY;assumption| |exact(proj2(PRIVATE b gv VAR))| | | | |lia].
     + eapply Mem.perm_valid_block;apply RP;exact R.
     + left;intro EQ;subst b;pose proof(mutable_global_not_readonly S._guidance_pid_pos_err _ _ ltac:(cbn;auto) ES VAR);congruence.
     + left;intro EQ;subst b;pose proof(mutable_global_not_readonly S._guidance_pid_speed_err _ _ ltac:(cbn;auto) VS VAR);congruence.
     + left;intro EQ;subst b;pose proof(mutable_global_not_readonly S._guidance_pid _ _ ltac:(cbn;auto) (cid_pid_symbol _ _ D) VAR);congruence.
     + left;intro EQ;subst b;pose proof(mutable_global_not_readonly S._guidance_pid_trim_att_integrator _ _ ltac:(cbn;auto) (cid_i_symbol _ _ D) VAR);congruence. }
 assert(SAFEF:position_subtractions_safe mf gh).
 { intros axis IN;destruct IN as[<-|[<-|[]]].
   - exists(Int.repr r),Int.zero;repeat(first[assumption|split]);unfold signed32;rewrite Int.signed_repr by(change(-2147483648<=r<=2147483647);lia);rewrite Int.signed_zero;lia.
   - exists Int.zero,Int.zero;repeat(first[assumption|split]);unfold signed32;rewrite Int.signed_zero;lia. }
 assert(INITF:initialized_positions mf gh).
 { intros axis IN;destruct(SAFEF axis IN)as(a&b&L&M&N);eauto. }
 assert(LEGF:InputGoodLegacy mf gh ret).
 { unfold InputGoodLegacy;refine (conj GR (conj UNIQ (conj RET (conj _ (conj _ (conj GLOBALF (conj _ (conj _ (conj APPF (conj _ (conj _ (_)))))))))))).
   - intros z R;apply(proj2(PERM gh z Cur Readable));apply GHREAD;exact R.
   - intros z R;apply(proj2(PERM ret z Cur Writable));apply RETWRITE;exact R.
   - intros id IN;destruct(CTRL id IN)as(b&gv&CSYM&VA&RP);exists b,gv;split;[exact CSYM|];split;[exact VA|];intros z R;apply(proj2(PERM b z Cur Writable));apply RP;exact R.
   - destruct CACHE as(ps&ss&PS&SS&BP&BS);exists ps,ss;split;[eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact PS]|];split;[eapply STATIC;[discriminate|discriminate|discriminate|discriminate|exact SS]|];split;assumption.
   - exists Float32.zero;split;[exact HEADF|];split;reflexivity.
   - intros gain IN;destruct IN as[<-|[<-|[<-|[<-|[<-|[]]]]]].
     + exists(Int.repr kp);split;[exact KPF|rewrite Int.signed_repr;[exact KPR|change(-2147483648<=kp<=2147483647);lia]].
     + exists Int.zero;split;[exact KDF|rewrite Int.signed_zero;lia].
     + exists(Int.repr ki);split;[exact KIF|rewrite Int.signed_repr;[exact KIR|change(-2147483648<=ki<=2147483647);lia]].
     + exists Int.zero;split;[exact KVF|rewrite Int.signed_zero;lia].
     + exists Int.zero;split;[exact KAF|rewrite Int.signed_zero;lia].
   - intros axis IN;destruct(AXESF axis IN)as(SPEED&ACCEL&VEL);split.
     + destruct IN as[<-|[<-|[]]].
       * exists iy;split;[exact IYLOAD|exact IBOUND].
       * exists Int.zero;split;[exact YZERO|rewrite Int.signed_zero;lia].
     + split.
       * exists Int.zero;split;[exact SPEED|rewrite Int.signed_zero;lia].
       * split.
         -- exists Int.zero;split;[exact ACCEL|rewrite Int.signed_zero;lia].
         -- exists Int.zero;split;[exact VEL|rewrite Int.signed_zero;lia]. }
 exists iy;split.
 - unfold AlternatingInput;exact (conj (conj LEGF (conj INITF SAFEF)) (conj (RXF0) (conj (RYF0) (conj (PXF) (conj (PYF) (conj (AXESF) (conj (KPF) (conj (KDF) (conj (KIF) (conj (KVF) (conj (KAF) (conj (HEADF) (conj (IYLOAD) (YZERO)))))))))))))).
 - intros z R;apply(proj2(PERM gh z Cur Writable));apply WG;exact R.
Qed.
Print Assumptions prepare_input.
Print Assumptions returned_input.
