From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreSemantics FlightSemantics ControllerPrefix CoreCall ReturnSemantics.
From PidPositionSafety Require Import FactoryCall FunctionPhases ConditionalBlock.
From FiveGuidanceAllOrder Require Import PhaseComposition BlockExecution.
From PidPositionTranslationCore Require Import FrontAllOrder.
From PidPositionTranslationAttempt002 Require Import FrontSemantics EntryAllOrderIntegration EntryTailAllOrder CoreJointCall.
From PidPositionTranslationAttempt002 Require Import ClampSemantics PrefixFields EntryAllocation EntryIntegration EntryReturn CoreInputs.
From CoreCBMC Require Import ArithmeticObservation CoreArithmeticEventBridge.
From PidPositionTranslationAttempt002 Require Import EntryFrontCoreArithmetic.
From CoreCBMC Require Import ArithmeticPhases.
From PidPositionTranslationAttempt002 Require Import EntryTailArithmetic CoreArithmeticJointCall EntryArithmeticBounds.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Local Opaque E.ge.
Theorem original_entry_core_arithmetic_observed : forall m gh ret flight,
 InputGood m gh ret ->
 exists mf P,certificate E.ge P(Returnstate Vundef Kstop mf) /\
 P(E.entry(call_args gh ret flight)m) /\
 (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s).
Proof.
 intros m gh ret flight GOOD.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 set(D0:=D).
 destruct D as[bp bi bt bu bh bfun kp kd ki kv ka ax ay ix iy h heading
 SP SI ST SU SH SF FF APP KP KD KI KV KA AX AY IX IY LT LU HEAD CAST HB WP WI].
 destruct(inputgood_entry_front_core_observed m gh ret flight GOOD)
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
 pose proof(initial_x_axis_bounds m gh ret D0 rx px sx vx GOOD SX)as BDX.
 pose proof(initial_y_axis_bounds m gh ret D0 ry py sy vy GOOD SY)as BDY.
 cbv beta iota zeta delta[D0 cid_kp cid_kd cid_ki cid_kv cid_ka cid_ax cid_ay cid_ix cid_iy]in BDX,BDY.
 destruct(CoreArithmeticJointCall.original_h_run_arithmetic_observed_funcall front bp be bs gh bi bt bu bh bfun temp flight
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
 (CAST front)RVEC WTEMP AIX AIY ACX ACY BDX BDY eq_refl eq_refl)
 as(coreout&CALL&CAL&ACTIVE&IXC&IYC&CMDX&CMDY&KEEP&CFRAME&CBFRAME).
 assert(VBR:Mem.valid_block front br)by(eapply loaded_block;exact RES).
 assert(RESC:Mem.load Mint64 coreout br 0=Some(Vptr ret Ptrofs.zero)).
 { rewrite CFRAME;try assumption;exact RES. }
 destruct actual_core_target as[funb[SFUN FFUN]].
 assert(NCORE:e!S._guidance_pid_h_run=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 destruct(original_entry_tail_core_arithmetic_certificate e front coreout br bf bg temp funb gh ret flight _ _ heading(Kseq(Sreturn None)Kstop)
 LR LF LG LC NCORE SFUN FFUN TR RES RESC FLIGHT GH CALL ACTIVE KEEP WTEMP WRET CAL)
 as(bodym&PTAIL&bytes&CTAIL&ITAIL&OTAIL&TAIL&ACTRET&TAILKEEP&BYTES&COPY).
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof E.ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply access_preserved_byte_range;[exact TAILKEEP|exact(FREE id b ty LOOK)]. }
 destruct(free_environment E.ge e bodym SEP FREEBODY)as[mf[FREEFINAL[FREEFRAME FREEACCESS]]].
 pose proof(FunctionPhases.return_void_transition E.ge S.f_guidance_pid_h_run_pos Kstop e bodym mf I FREEFINAL)as CLEAN.
 assert(RETURNOBS:observed_certificate E.ge(arithmetic_observation E.ge S.f_guidance_pid_h_run)
 (State S.f_guidance_pid_h_run_pos(Sreturn None)Kstop e bodym)(Returnstate Vundef Kstop mf)).
 { eapply observed_prepend;[exact CLEAN|exact I|];apply observed_singleton;exact I. }
 assert(TAILOBS:observed_certificate E.ge(arithmetic_observation E.ge S.f_guidance_pid_h_run)
 (State S.f_guidance_pid_h_run_pos after_front Kstop e front)(Returnstate Vundef Kstop mf)).
 { change(observed_certificate E.ge(arithmetic_observation E.ge S.f_guidance_pid_h_run)
   (State S.f_guidance_pid_h_run_pos(Ssequence entry_return_assignment(Sreturn None))Kstop e front)
   (Returnstate Vundef Kstop mf)).
   eapply observed_sequence with(mid:=bodym);[exact I|exact I| |exact RETURNOBS].
   exists PTAIL;exact(conj CTAIL(conj ITAIL OTAIL)). }
 exists mf;change(observed_certificate E.ge(arithmetic_observation E.ge S.f_guidance_pid_h_run)
 (E.entry(call_args gh ret flight)m)(Returnstate Vundef Kstop mf)).
 eapply observed_join;[exact PATH|exact TAILOBS].
Qed.
Print Assumptions original_entry_core_arithmetic_observed.

Theorem bound_original_core_arithmetic_observation : CoreArithmeticObservationGoal.
Proof.
 intros m gh ret flight GOOD t s PATH.
 destruct(original_entry_core_arithmetic_observed m gh ret flight GOOD)as[mf[P[CERT[INITIAL OBS]]]].
 apply OBS.
 eapply certificate_reachable;[exact CERT|exact INITIAL|apply return_stop_nostep|exact PATH].
Qed.
Print Assumptions bound_original_core_arithmetic_observation.
