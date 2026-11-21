From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix ReturnSemantics.
From PidPositionSafety Require Import FactoryCall CoreFactoryTail CoreFront ConditionalBlock TaggedCallee.
From PidPositionTranslationAttempt002 Require Import CoreTailArithmetic.
From CoreCBMC Require Import NumericBounds ArithmeticPhases ArithmeticPrefix ArithmeticObservation ObservedController.
From FiveGuidanceAllOrder Require Import PhaseComposition.
Import ListNotations.
Open Scope Z_scope.
Ltac each_block_update := lazymatch goal with|-Forall _ []=>constructor| |-Forall _ (_::_)=>constructor;[cbn;first[assumption|apply not_eq_sym;assumption]|each_block_update]end.
Ltac controller_block_misses :=
 cbv beta iota zeta delta[controller_updates first_four_updates clamp_updates flight_updates app];
 repeat match goal with|-context[if ?f then _ else _]=>destruct f end;each_block_update.
Ltac controller_misses :=
 cbv beta iota zeta delta[controller_updates first_four_updates clamp_updates flight_updates app];
 repeat match goal with|-context[if ?f then _ else _]=>destruct f end;each_update.
Theorem original_h_run_body_arithmetic_certificate:forall e m bp be bs gh bg bx bpy bi bt bu bf
 (flight:bool)kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total br temp bh bfun ret(h:float32)(heading:int),
 e!S._pd_x=Some(bx,tint) ->e!S._pd_y=Some(bpy,tint) ->e!S._gh=Some(bg,tptr gh_type) ->e!S._in_flight=Some(bf,tbool) ->
 e!S._guidance_pid=None ->e!S._guidance_pid_pos_err=None ->e!S._guidance_pid_speed_err=None ->
 e!S._guidance_pid_trim_att_integrator=None ->e!S._traj_max_bank=None ->e!S._total_max_bank=None ->
 Genv.find_symbol ge S._guidance_pid=Some bp ->
 Genv.find_symbol ge S._guidance_pid_pos_err=Some be ->
 Genv.find_symbol ge S._guidance_pid_speed_err=Some bs ->
 Genv.find_symbol ge S._guidance_pid_trim_att_integrator=Some bi ->
 Genv.find_symbol ge S._traj_max_bank=Some bt ->Genv.find_symbol ge S._total_max_bank=Some bu ->
 NoDup[bx;bpy;bg;bf;bp;be;bs;gh;bi;bt;bu] ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint8unsigned m bf 0=Some(Vint(if flight then Int.one else Int.zero)) ->
 Mem.load Mint8unsigned m bp 44=Some(Vint Int.zero) ->
 Mem.load Mint32 m bp 0=Some(Vint kp) ->
 Mem.load Mint32 m bp 4=Some(Vint kd) ->
 Mem.load Mint32 m bp 8=Some(Vint ki) ->
 Mem.load Mint32 m bp 12=Some(Vint kv) ->
 Mem.load Mint32 m bp 16=Some(Vint ka) ->
 Mem.load Mint32 m be 0=Some(Vint pex) ->
 Mem.load Mint32 m be 4=Some(Vint pey) ->
 Mem.load Mint32 m bs 0=Some(Vint sex) ->
 Mem.load Mint32 m bs 4=Some(Vint sey) ->
 Mem.load Mint32 m gh 52=Some(Vint rsx) ->
 Mem.load Mint32 m gh 56=Some(Vint rsy) ->
 Mem.load Mint32 m gh 60=Some(Vint rax) ->
 Mem.load Mint32 m gh 64=Some(Vint ray) ->
 Mem.load Mint32 m bi 0=Some(Vint ix) ->
 Mem.load Mint32 m bi 4=Some(Vint iy) ->
 Mem.load Mint32 m bt 0=Some(Vint traj) ->
 Mem.load Mint32 m bu 0=Some(Vint total) ->
 axis_bounds kp kd ki kv ka pex sex rsx rax ix ->
 axis_bounds kp kd ki kv ka pey sey rsy ray iy ->
 traj=Int.repr 1429 ->total=Int.repr 3216 ->
 Mem.valid_access m Mint32 bx 0 Writable ->
 Mem.valid_access m Mint32 bpy 0 Writable ->
 Mem.valid_access m Mint32 bi 0 Writable ->
 Mem.valid_access m Mint32 bi 4 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->
 Mem.valid_access m Mint32 bp 36 Writable ->
 e!S.__res=Some(br,tptr spty) ->e!S.__res__1=Some(temp,spty) ->
 e!S._guidance_h=None ->Genv.find_symbol ge S._guidance_h=Some bh ->
 e!S._stab_sp_from_ltp_i=None ->Genv.find_symbol ge S._stab_sp_from_ltp_i=Some bfun ->
 Genv.find_funct ge(Vptr bfun Ptrofs.zero)=Some(Internal S.f_stab_sp_from_ltp_i) ->
 br<>bx ->br<>bpy ->br<>bp ->br<>bi ->br<>temp ->
 temp<>bp ->temp<>bi ->temp<>ret ->ret<>bp ->ret<>bi ->
 bh<>bx ->bh<>bpy ->bh<>bp ->bh<>bi ->
 Mem.load Mint64 m br 0=Some(Vptr ret Ptrofs.zero) ->
 Mem.load Mfloat32 m bh 28=Some(Vsingle h) ->
 sem_cast(Vsingle(Float32.mul h(Float32.of_int(Int.repr 4096))))tfloat tint m=Some(Vint heading) ->
 Mem.range_perm m bp 32 40 Cur Readable ->
 Mem.range_perm m temp 0 36 Cur Writable ->Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,
 (forall k,observed_certificate ge(arithmetic_observation ge S.f_guidance_pid_h_run)
 (State S.f_guidance_pid_h_run(fn_body S.f_guidance_pid_h_run)k e m)
 (State S.f_guidance_pid_h_run(Sreturn None)k e mf)) /\
 active_fields mf ret
 (controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)
 (controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)heading /\
 Mem.load Mint32 mf bi 0=Some(Vint(next_integral flight ix ki(pd_bits kp kd pex sex)traj)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(next_integral flight iy ki(pd_bits kp kd pey sey)traj)) /\
 Mem.load Mint32 mf bp 32=Some(Vint(controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bx ->b<>bpy ->b<>bp ->b<>bi ->b<>temp ->b<>ret ->
 Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->b<>bx ->b<>bpy ->b<>bp ->b<>bi ->b<>temp ->b<>ret ->0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros e m bp be bs gh bg bx bpy bi bt bu bf flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total br temp bh bfun ret h heading
 EX EY EG EF NP NE NS NI NT NU SP SE SS SI ST SU SEP GP LF APPROX
 LKP LKD LKI LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY LIX LIY LT LU BDX BDY TRAJ TOTAL AX AY AIX AIY ACX ACY
 LR LC NH SH NF SF FF BRX BRY BRP BRI BRT TP TI TR RP RI HHX HHY HHP HHI RES HEAD CAST RVS WT WR.
 destruct(original_controller_front_observed e m bp be bs gh bg bx bpy bi bt bu bf flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total
 EX EY EG EF NP NE NS NI NT NU SP SE SS SI ST SU SEP GP LF APPROX
 LKP LKD LKI LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY LIX LIY LT LU BDX BDY TRAJ TOTAL AX AY AIX AIY ACX ACY)
 as[c[CTRL[IX[IY[CX[CY RUN]]]]]].
 assert(KEEP:access_preserved m c).
 { intros ch b ofs p ACCESS;eapply replay_stores_access;[exact RUN|exact ACCESS]. }
 assert(RESC:Mem.load Mint64 c br 0=Some(Vptr ret Ptrofs.zero)).
 { rewrite(replay_stores_load_frame _ _ _ _ _ _ RUN)by(controller_misses);exact RES. }
 assert(HEADC:Mem.load Mfloat32 c bh 28=Some(Vsingle h)).
 { rewrite(replay_stores_load_frame _ _ _ _ _ _ RUN)by(controller_misses);exact HEAD. }
 assert(RVC:Mem.range_perm c bp 32 40 Cur Readable)by(eapply access_preserved_byte_range;eauto).
 assert(WTC:Mem.range_perm c temp 0 36 Cur Writable)by(eapply access_preserved_byte_range;eauto).
 assert(WRC:Mem.range_perm c ret 0 36 Cur Writable)by(eapply access_preserved_byte_range;eauto).
 destruct(CoreTailArithmetic.original_factory_tail_arithmetic_certificate e c br temp bp bh bfun ret h heading
 (controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)
 (controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)
 LR LC NP SP NH SH NF SF FF BRT TR RESC HEADC CAST CX CY RVC WTC WRC)
 as[mf[TAIL[ACTIVE[TAILKEEP[FRAME BFRAME]]]]].
 assert(VBP:Mem.valid_block c bp)by(eapply loaded_block;exact CX).
 assert(VBI:Mem.valid_block c bi)by(eapply loaded_block;exact IX).
 exists mf;split.
 - intros k.
   assert(TAILCERT:observed_certificate ge(arithmetic_observation ge S.f_guidance_pid_h_run)
    (State S.f_guidance_pid_h_run CoreTailArithmetic.core_return_tail k e c)
    (State S.f_guidance_pid_h_run(Sreturn None)k e mf)).
   { eapply observed_sequence.
     - exact I.
     - exact I.
     - exact(TAIL(Kseq(Sreturn None)k)).
     - apply observed_singleton;exact I. }
   eapply observed_join.
   + eapply observed_weaken;[|exact(CTRL k)].
     intros s[SC TREE];apply tree_state_observation;exact TREE.
   + exact TAILCERT.
 - split;[exact ACTIVE|].
   split;[rewrite FRAME by(assumption||congruence);exact IX|].
   split;[rewrite FRAME by(assumption||congruence);exact IY|].
   split;[rewrite FRAME by(assumption||congruence);exact CX|].
   split;[rewrite FRAME by(assumption||congruence);exact CY|].
   split.
   + intros ch b ofs p ACCESS;apply TAILKEEP;apply KEEP;exact ACCESS.
   + split.
     * intros ch b ofs VB BX BY BP BI BT BR.
       rewrite FRAME by(first[assumption|eapply replay_stores_valid_block;[exact RUN|exact VB]]).
       apply(replay_stores_load_frame _ _ _ _ _ _ RUN);controller_misses.
     * intros b ofs n VB BX BY BP BI BT BR N.
       rewrite BFRAME by(first[assumption|eapply replay_stores_valid_block;[exact RUN|exact VB]]).
       eapply replay_stores_bytes_frame_block;[exact RUN|controller_block_misses|exact N].
Qed.

Print Assumptions original_h_run_body_arithmetic_certificate.
