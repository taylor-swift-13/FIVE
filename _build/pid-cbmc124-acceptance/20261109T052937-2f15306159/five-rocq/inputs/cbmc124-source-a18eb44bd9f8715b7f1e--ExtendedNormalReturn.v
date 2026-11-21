From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreSemantics FlightSemantics ControllerPrefix CoreCall ReturnSemantics.
From PidPositionSafety Require Import FactoryCall.
From PidPositionTranslationAttempt002 Require Import ClampSemantics PrefixFields EntryAllocation EntryIntegration EntryReturn CoreInputs.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Local Opaque E.ge.
From PidPositionTranslationAttempt002 Require Import InputSemantics NormalReturn.
Theorem original_entry_extended_normal_result : forall m gh ret flight(D:core_initial_data m gh),
 InputGood m gh ret ->
 exists mf rx ry px py sx sy vx vy sb,
 NormalCall gh ret flight m mf /\
 Genv.find_symbol E.ge S._state=Some sb /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) /\
 Mem.load Mint32 m sb 100=Some(Vint px) /\Mem.load Mint32 m sb 104=Some(Vint py) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy) /\
 Mem.load Mint32 m sb 296=Some(Vint vx) /\Mem.load Mint32 m sb 300=Some(Vint vy) /\
 active_fields mf ret
 (entry_axis_command m gh D flight rx px sx vx(cid_ax _ _ D)(cid_ix _ _ D))
 (entry_axis_command m gh D flight ry py sy vy(cid_ay _ _ D)(cid_iy _ _ D))(cid_hbits _ _ D) /\
 Mem.load Mint32 mf(cid_i _ _ D)0=Some(Vint(entry_axis_integral m gh D flight rx px sx vx(cid_ix _ _ D))) /\
 Mem.load Mint32 mf(cid_i _ _ D)4=Some(Vint(entry_axis_integral m gh D flight ry py sy vy(cid_iy _ _ D))) /\
 Mem.load Mint32 mf(cid_pid _ _ D)32=Some(Vint(entry_axis_command m gh D flight rx px sx vx(cid_ax _ _ D)(cid_ix _ _ D))) /\
 Mem.load Mint32 mf(cid_pid _ _ D)36=Some(Vint(entry_axis_command m gh D flight ry py sy vy(cid_ay _ _ D)(cid_iy _ _ D))) /\
 load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._x]=Some(Vint(ClampSemantics.clamp_bits(Int.sub rx px)(Int.repr 4096))) /\
 load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._y]=Some(Vint(ClampSemantics.clamp_bits(Int.sub ry py)(Int.repr 4096))) /\
 load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._x]=Some(Vint(ClampSemantics.clamp_bits(Int.sub sx vx)(Int.repr 8388608))) /\
 load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._y]=Some(Vint(ClampSemantics.clamp_bits(Int.sub sy vy)(Int.repr 8388608))) /\
 load_path Mint32 mf gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 mf gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry).
Proof.
 intros m gh ret flight D GOOD.
 destruct D as[bp bi bt bu bh bfun kp kd ki kv ka ax ay ix iy h heading
 SP SI ST SU SH SF FF APP KP KD KI KV KA AX AY IX IY LT LU HEAD CAST HB WP WI].
 cbn[entry_axis_command entry_axis_integral].
 destruct(inputgood_entry_reaches_core_call m gh ret flight GOOD)
 as(e&front&be&bs&sb&rx&ry&px&py&sx&sy&vx&vy&br&bf&bg&temp&
 SE&SS&STATE&RX&RY&PX&PY&SX&SY&VX&VY&PATH&PEX&PEY&SEX&SEY&
 LR&LF&LG&LC&RES&GH&FLIGHT&SEP&FRESH&FREE&FRAME&PERM&UNSH).
 pose proof(Genv.find_invert_symbol E.ge S._guidance_pid SP)as IP.
 pose proof(Genv.find_invert_symbol E.ge S._guidance_pid_pos_err SE)as IE.
 pose proof(Genv.find_invert_symbol E.ge S._guidance_pid_speed_err SS)as IS.
 pose proof(Genv.find_invert_symbol E.ge S._guidance_pid_trim_att_integrator SI)as II.
 pose proof(Genv.find_invert_symbol E.ge S._traj_max_bank ST)as IT.
 pose proof(Genv.find_invert_symbol E.ge S._total_max_bank SU)as IU.
 pose proof(Genv.find_invert_symbol E.ge S._guidance_h SH)as IH.
 cbv[S._guidance_pid S._guidance_pid_pos_err S._guidance_pid_speed_err S._guidance_pid_trim_att_integrator S._traj_max_bank S._total_max_bank S._guidance_h]in IP,IE,IS,II,IT,IU,IH.
 assert(GP:gh<>bp)by(exact(inputgood_guidance_separate m gh ret S._guidance_pid bp GOOD SP ltac:(discriminate))).
 assert(GE:gh<>be)by(exact(inputgood_guidance_separate m gh ret S._guidance_pid_pos_err be GOOD SE ltac:(discriminate))).
 assert(GS:gh<>bs)by(exact(inputgood_guidance_separate m gh ret S._guidance_pid_speed_err bs GOOD SS ltac:(discriminate))).
 assert(GI:gh<>bi)by(exact(inputgood_guidance_separate m gh ret S._guidance_pid_trim_att_integrator bi GOOD SI ltac:(discriminate))).
 assert(GT:gh<>bt)by(exact(inputgood_guidance_separate m gh ret S._traj_max_bank bt GOOD ST ltac:(discriminate))).
 assert(GU:gh<>bu)by(exact(inputgood_guidance_separate m gh ret S._total_max_bank bu GOOD SU ltac:(discriminate))).
 assert(ND:NoDup[bp;be;bs;gh;bi;bt;bu]).
 { let rec distinct := lazymatch goal with
   | |-NoDup []=>apply NoDup_nil
   | |-NoDup(_::_)=>apply NoDup_cons;[cbn;intuition congruence|distinct]
   end in distinct. }
 assert(VP:Mem.valid_block m bp)by(eapply loaded_block;exact KP).
 assert(VI:Mem.valid_block m bi)by(eapply loaded_block;exact IX).
 assert(TP:temp<>bp)by(intro EQ;subst temp;exact(FRESH S.__res__1 bp sp_type LC VP)).
 assert(TI:temp<>bi)by(intro EQ;subst temp;exact(FRESH S.__res__1 bi sp_type LC VI)).
 assert(BRP:br<>bp)by(intro EQ;subst br;exact(FRESH S.__res bp(tptr sp_type)LR VP)).
 assert(BRI:br<>bi)by(intro EQ;subst br;exact(FRESH S.__res bi(tptr sp_type)LR VI)).
 assert(BRT:br<>temp)by(eapply environment_distinct;[exact SEP| |exact LR|exact LC];discriminate).
 assert(WPF:Mem.range_perm front bp 0 48 Cur Writable)by(intros ofs R;apply PERM;apply WP;exact R).
 assert(WIF:Mem.range_perm front bi 0 8 Cur Writable)by(intros ofs R;apply PERM;apply WI;exact R).
 assert(WTEMP:Mem.range_perm front temp 0 36 Cur Writable).
 { pose proof(FREE S.__res__1 temp sp_type LC)as W.
   rewrite PrefixFields.prefix_ge_ce in W;change(Mem.range_perm front temp 0 36 Cur Freeable)in W.
   intros ofs R;eapply Mem.perm_implies;[apply W;exact R|constructor]. }
 assert(WRET0:Mem.range_perm m ret 0 36 Cur Writable).
 { destruct GOOD as[LEG _];assert(W:Mem.range_perm m ret 0(sizeof ce sp_type)Cur Writable)by(unfold InputGoodLegacy in LEG;tauto);exact W. }
 assert(WRET:Mem.range_perm front ret 0 36 Cur Writable)by(intros ofs R;apply PERM;apply WRET0;exact R).
 assert(VRET:Mem.valid_block m ret)by(exact(range_block m ret 0 36 Writable ltac:(lia)WRET0)).
 assert(TR:temp<>ret)by(intro EQ;subst temp;exact(FRESH S.__res__1 ret sp_type LC VRET)).
 assert(RETGLOBAL:forall id,Genv.find_symbol E.ge id<>Some ret)
 by(destruct GOOD as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(PR:bp<>ret)by(intro EQ;subst bp;apply(RETGLOBAL S._guidance_pid);exact SP).
 assert(IR:bi<>ret)by(intro EQ;subst bi;apply(RETGLOBAL S._guidance_pid_trim_att_integrator);exact SI).
 assert(FRAMED:forall id b ch ofs v,Genv.find_symbol E.ge id=Some b ->
 id<>S._guidance_pid_pos_err ->id<>S._guidance_pid_speed_err ->
 Mem.load ch m b ofs=Some v ->Mem.load ch front b ofs=Some v).
 { intros id b ch ofs v SYMBOL NE NS LOAD;apply FRAME;[exact LOAD| |].
   - eapply Genv.global_addresses_distinct;[exact NE|exact SYMBOL|exact SE].
   - eapply Genv.global_addresses_distinct;[exact NS|exact SYMBOL|exact SS]. }
 assert(AIX:Mem.valid_access front Mint32 bi 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WIF;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 assert(AIY:Mem.valid_access front Mint32 bi 4 Writable).
 { apply scalar_access_inside with(n:=8);try exact WIF;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 assert(ACX:Mem.valid_access front Mint32 bp 32 Writable).
 { apply scalar_access_inside with(n:=48);try exact WPF;try change(4|32);try(exists 8;reflexivity);cbn;lia. }
 assert(ACY:Mem.valid_access front Mint32 bp 36 Writable).
 { apply scalar_access_inside with(n:=48);try exact WPF;try change(4|36);try(exists 9;reflexivity);cbn;lia. }
 assert(RVEC:Mem.range_perm front bp 32 40 Cur Readable).
 { intros ofs R;eapply Mem.perm_implies;[apply WPF;lia|constructor]. }
 destruct(CoreCall.original_h_run_funcall front bp be bs gh bi bt bu bh bfun temp flight
 kp kd ki kv ka
 (ClampSemantics.clamp_bits(Int.sub rx px)(Int.repr 4096))(ClampSemantics.clamp_bits(Int.sub ry py)(Int.repr 4096))
 (ClampSemantics.clamp_bits(Int.sub sx vx)(Int.repr 8388608))(ClampSemantics.clamp_bits(Int.sub sy vy)(Int.repr 8388608))
 sx sy ax ay ix iy(Int.repr 1429)(Int.repr 3216)h heading
 SP SE SS SI ST SU SH SF FF ND TP TI ltac:(congruence)ltac:(congruence)
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact APP])
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact KP])
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact KD])
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact KI])
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact KV])
 ltac:(eapply FRAMED;[exact SP|discriminate|discriminate|exact KA])
 PEX PEY SEX SEY
 ltac:(apply FRAME;[exact SX|exact GE|exact GS])ltac:(apply FRAME;[exact SY|exact GE|exact GS])
 ltac:(apply FRAME;[exact AX|exact GE|exact GS])ltac:(apply FRAME;[exact AY|exact GE|exact GS])
 ltac:(eapply FRAMED;[exact SI|discriminate|discriminate|exact IX])
 ltac:(eapply FRAMED;[exact SI|discriminate|discriminate|exact IY])
 ltac:(eapply FRAMED;[exact ST|discriminate|discriminate|exact LT])
 ltac:(eapply FRAMED;[exact SU|discriminate|discriminate|exact LU])
 ltac:(eapply FRAMED;[exact SH|discriminate|discriminate|exact HEAD])
 (CAST front)RVEC WTEMP AIX AIY ACX ACY)
 as(coreout&CALL&ACTIVE&IXC&IYC&CMDX&CMDY&KEEP&CFRAME&CBFRAME).
 assert(VBR:Mem.valid_block front br)by(eapply loaded_block;exact RES).
 assert(RESC:Mem.load Mint64 coreout br 0=Some(Vptr ret Ptrofs.zero)).
 { rewrite CFRAME;try assumption;exact RES. }
 destruct actual_core_target as[funb[SFUN FFUN]].
 assert(NCORE:e!S._guidance_pid_h_run=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 destruct(original_entry_return_tail e front coreout br bf bg temp funb gh ret flight _ _ heading
 LR LF LG LC NCORE SFUN FFUN TR RES RESC FLIGHT GH CALL ACTIVE KEEP WTEMP WRET)
 as(bodym&bytes&TAIL&ACTRET&TAILKEEP&BYTES&COPY).
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof E.ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply access_preserved_byte_range;[exact TAILKEEP|exact(FREE id b ty LOOK)]. }
 destruct(free_environment E.ge e bodym SEP FREEBODY)as[mf[FREEFINAL[FREEFRAME FREEACCESS]]].
 assert(OUT:forall b,Mem.valid_block m b ->forall id ty,e!id=Some(b,ty)->False)
 by(intros b VB id ty LOOK;exact(FRESH id b ty LOOK VB)).
 lazymatch type of ACTRET with active_fields _ _ ?cx ?cy _=>assert(FINALRET:active_fields mf ret cx cy heading)end.
 { unfold active_fields in *;repeat match goal with H:_/\_ |- _=>destruct H end.
   repeat split;rewrite FREEFRAME by(apply OUT;exact VRET);assumption. }
 assert(FIX:Mem.load Mint32 mf bi 0=Mem.load Mint32 coreout bi 0).
 { rewrite FREEFRAME by(apply OUT;exact VI).
   eapply Mem.load_storebytes_other;[exact COPY|left;exact IR]. }
 assert(FIY:Mem.load Mint32 mf bi 4=Mem.load Mint32 coreout bi 4).
 { rewrite FREEFRAME by(apply OUT;exact VI).
   eapply Mem.load_storebytes_other;[exact COPY|left;exact IR]. }
 assert(FCX:Mem.load Mint32 mf bp 32=Mem.load Mint32 coreout bp 32).
 { rewrite FREEFRAME by(apply OUT;exact VP).
   eapply Mem.load_storebytes_other;[exact COPY|left;exact PR]. }
 assert(FCY:Mem.load Mint32 mf bp 36=Mem.load Mint32 coreout bp 36).
 { rewrite FREEFRAME by(apply OUT;exact VP).
   eapply Mem.load_storebytes_other;[exact COPY|left;exact PR]. }
 assert(ENDLOAD:forall ch b ofs v,Mem.valid_block m b ->b<>ret ->b<>bp ->b<>bi ->
 Mem.load ch front b ofs=Some v ->Mem.load ch mf b ofs=Some v).
 { intros ch b ofs v VB DR DBP DBI LOAD.
   rewrite FREEFRAME by(apply OUT;exact VB).
   erewrite Mem.load_storebytes_other by(exact COPY||(left;exact DR)).
   rewrite CFRAME.
   - exact LOAD.
   - eapply loaded_block;exact LOAD.
   - exact DBP.
   - exact DBI.
   - intro EQ;subst b;exact(FRESH S.__res__1 temp sp_type LC VB). }
 assert(VBE:Mem.valid_block m be).
 { eapply range_block with(lo:=0)(hi:=8)(p:=Writable);[lia|].
   exact(inputgood_error_global_writable m gh ret S._guidance_pid_pos_err be GOOD ltac:(cbn;auto)SE). }
 assert(VBS:Mem.valid_block m bs).
 { eapply range_block with(lo:=0)(hi:=8)(p:=Writable);[lia|].
   exact(inputgood_error_global_writable m gh ret S._guidance_pid_speed_err bs GOOD ltac:(cbn;auto)SS). }
 assert(VGH:Mem.valid_block m gh)by(eapply loaded_block;exact RX).
 assert(ER:be<>ret)by(intro EQ;subst be;apply(RETGLOBAL S._guidance_pid_pos_err);exact SE).
 assert(SR:bs<>ret)by(intro EQ;subst bs;apply(RETGLOBAL S._guidance_pid_speed_err);exact SS).
 assert(GR:gh<>ret)by(destruct GOOD as[LEG _];unfold InputGoodLegacy in LEG;tauto).
 assert(EEX:load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._x]=Some(Vint(ClampSemantics.clamp_bits(Int.sub rx px)(Int.repr 4096)))).
 { unfold load_global;rewrite SE;change(Mem.load Mint32 mf be 0=Some(Vint(ClampSemantics.clamp_bits(Int.sub rx px)(Int.repr 4096))));eapply ENDLOAD;try eassumption;congruence. }
 assert(EEY:load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._y]=Some(Vint(ClampSemantics.clamp_bits(Int.sub ry py)(Int.repr 4096)))).
 { unfold load_global;rewrite SE;change(Mem.load Mint32 mf be 4=Some(Vint(ClampSemantics.clamp_bits(Int.sub ry py)(Int.repr 4096))));eapply ENDLOAD;try eassumption;congruence. }
 assert(ESX:load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._x]=Some(Vint(ClampSemantics.clamp_bits(Int.sub sx vx)(Int.repr 8388608)))).
 { unfold load_global;rewrite SS;change(Mem.load Mint32 mf bs 0=Some(Vint(ClampSemantics.clamp_bits(Int.sub sx vx)(Int.repr 8388608))));eapply ENDLOAD;try eassumption;congruence. }
 assert(ESY:load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._y]=Some(Vint(ClampSemantics.clamp_bits(Int.sub sy vy)(Int.repr 8388608)))).
 { unfold load_global;rewrite SS;change(Mem.load Mint32 mf bs 4=Some(Vint(ClampSemantics.clamp_bits(Int.sub sy vy)(Int.repr 8388608))));eapply ENDLOAD;try eassumption;congruence. }
 assert(RXFINAL:load_path Mint32 mf gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx)).
 { change(Mem.load Mint32 mf gh 44=Some(Vint rx));eapply ENDLOAD;try eassumption.
   apply FRAME;[exact RX|exact GE|exact GS]. }
 assert(RYFINAL:load_path Mint32 mf gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry)).
 { change(Mem.load Mint32 mf gh 48=Some(Vint ry));eapply ENDLOAD;try eassumption.
   apply FRAME;[exact RY|exact GE|exact GS]. }
 cbv beta iota zeta delta[entry_axis_command entry_axis_integral cid_i cid_pid cid_ax cid_ay cid_ix cid_iy cid_hbits cid_kp cid_kd cid_ki cid_kv cid_ka].
 exists mf,rx,ry,px,py,sx,sy,vx,vy,sb;split.
 - exists E0,Vundef;eapply star_trans with(t1:=E0)(t2:=E0);[exact PATH| |reflexivity].
   eapply returning_statement_original_path;[exact TAIL|exact FREEFINAL].
 - repeat(first[assumption|split]).
   + rewrite FIX;exact IXC.
   + rewrite FIY;exact IYC.
   + rewrite FCX;exact CMDX.
   + rewrite FCY;exact CMDY.
Qed.

Print Assumptions original_entry_extended_normal_result.
