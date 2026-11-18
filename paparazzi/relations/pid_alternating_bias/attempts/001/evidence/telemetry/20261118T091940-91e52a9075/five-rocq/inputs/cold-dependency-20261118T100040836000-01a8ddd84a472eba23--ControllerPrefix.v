From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail.
Import ListNotations.
Open Scope Z_scope.
Definition after_feedforward(kp kd kv ka pe se rs ra traj:int):int:=
 clip_bits(feedforward_bits(pd_bits kp kd pe se)kv rs ka ra)traj.
Definition controller_command(f:bool)(kp kd ki kv ka pe se rs ra i traj total:int):int:=
 clip_bits(next_command f(after_feedforward kp kd kv ka pe se rs ra traj)(next_integral f i ki(pd_bits kp kd pe se)traj))total.
Definition controller_updates(f:bool)(bx bpy bp bi:block)(kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total:int):list scalar_update:=
 first_four_updates bx bpy bp kp kd kv ka pex pey sex sey rsx rsy rax ray++
 clamp_updates bp(feedforward_bits(pd_bits kp kd pex sex)kv rsx ka rax)(feedforward_bits(pd_bits kp kd pey sey)kv rsy ka ray)traj++
 flight_updates f bi bp(pd_bits kp kd pex sex)(pd_bits kp kd pey sey)ki ix iy
 (after_feedforward kp kd kv ka pex sex rsx rax traj)(after_feedforward kp kd kv ka pey sey rsy ray traj)traj++
 clamp_updates bp
 (next_command f(after_feedforward kp kd kv ka pex sex rsx rax traj)(next_integral f ix ki(pd_bits kp kd pex sex)traj))
 (next_command f(after_feedforward kp kd kv ka pey sey rsy ray traj)(next_integral f iy ki(pd_bits kp kd pey sey)traj))total.
Ltac miss_update :=
 cbn[misses_chunk size_chunk];
 lazymatch goal with |- (?b <> ?bu) \/ (?a <= ?c) \/ (?d <= ?f) =>
 tryif constr_eq b bu then
 (let ok:=eval vm_compute in(orb(Z.leb a c)(Z.leb d f))in
  lazymatch ok with true=>right;lia|false=>fail 1 "overlapping field"end)
 else(left;first[assumption|apply not_eq_sym;assumption])end.
Ltac each_update := lazymatch goal with|-Forall _ []=>constructor| |-Forall _ (_::_)=>constructor;[miss_update|each_update]end.

Ltac trace_frame :=
 repeat match goal with
 | RUN:replay_stores ?before ?updates=Some ?after |- context[Mem.load ?ch ?after ?b ?ofs]=>
   rewrite(replay_stores_load_frame updates before after ch b ofs RUN)by(
    cbv beta iota zeta delta[first_four_updates clamp_updates flight_updates];
    repeat match goal with|-context[if ?f then _ else _]=>destruct f end;
    each_update)
 end.
Ltac trace_access :=
 lazymatch goal with|-Mem.valid_access ?after ?ch ?b ?ofs ?perm=>
 first[assumption|
 match goal with RUN:replay_stores ?before ?updates=Some after |- _=>
 eapply(replay_stores_access updates before after ch b ofs perm RUN);trace_access end]end.
Theorem original_controller_prefix_normal:forall e m bp be bs gh bg bx bpy bi bt bu bf
 (flight:bool)kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total,
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
 Mem.valid_access m Mint32 bx 0 Writable ->
 Mem.valid_access m Mint32 bpy 0 Writable ->
 Mem.valid_access m Mint32 bi 0 Writable ->
 Mem.valid_access m Mint32 bi 4 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->
 Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,
 exec_stmt ge e m(first_statements 8(fn_body S.f_guidance_pid_h_run))E0 mf Out_normal /\
 Mem.load Mint32 mf bi 0=Some(Vint(next_integral flight ix ki(pd_bits kp kd pex sex)traj)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(next_integral flight iy ki(pd_bits kp kd pey sey)traj)) /\
 Mem.load Mint32 mf bp 32=Some(Vint(controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)) /\
 replay_stores m(controller_updates flight bx bpy bp bi kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total)=Some mf.
Proof.
 intros e m bp be bs gh bg bx bpy bi bt bu bf flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total
 EX EY EG EF NP NE NS NI NT NU SP SE SS SI ST SU SEP GP LF APPROX
 LKP LKD LKI LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY LIX LIY LT LU AX AY AIX AIY ACX ACY.
 assert(DIST:bx<>bpy /\ bx<>bg /\ bx<>bf /\ bx<>bp /\ bx<>be /\ bx<>bs /\ bx<>gh /\ bx<>bi /\ bx<>bt /\ bx<>bu /\ bpy<>bg /\ bpy<>bf /\ bpy<>bp /\ bpy<>be /\ bpy<>bs /\ bpy<>gh /\ bpy<>bi /\ bpy<>bt /\ bpy<>bu /\ bg<>bf /\ bg<>bp /\ bg<>be /\ bg<>bs /\ bg<>gh /\ bg<>bi /\ bg<>bt /\ bg<>bu /\ bf<>bp /\ bf<>be /\ bf<>bs /\ bf<>gh /\ bf<>bi /\ bf<>bt /\ bf<>bu /\ bp<>be /\ bp<>bs /\ bp<>gh /\ bp<>bi /\ bp<>bt /\ bp<>bu /\ be<>bs /\ be<>gh /\ be<>bi /\ be<>bt /\ be<>bu /\ bs<>gh /\ bs<>bi /\ bs<>bt /\ bs<>bu /\ gh<>bi /\ gh<>bt /\ gh<>bu /\ bi<>bt /\ bi<>bu /\ bt<>bu).
 {repeat rewrite NoDup_cons_iff in SEP;simpl in SEP;intuition congruence. }
 destruct DIST as(D0&D1&D2&D3&D4&D5&D6&D7&D8&D9&D10&D11&D12&D13&D14&D15&D16&D17&D18&D19&D20&D21&D22&D23&D24&D25&D26&D27&D28&D29&D30&D31&D32&D33&D34&D35&D36&D37&D38&D39&D40&D41&D42&D43&D44&D45&D46&D47&D48&D49&D50&D51&D52&D53&D54).
 destruct(original_core_first_four e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray
 EX EY EG NP NE NS SP SE SS ltac:(repeat constructor;simpl;intuition congruence)
 GP LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY AX AY ACX ACY)
 as[m4[E4[PDX[PDY[CMDX[CMDY[RW4 RUN4]]]]]]].
 assert(LT4:Mem.load Mint32 m4 bt 0=Some(Vint traj))by(trace_frame;exact LT).
 destruct(original_trajectory_clamp_normal e m4 bp bt
 (feedforward_bits(pd_bits kp kd pex sex)kv rsx ka rax)
 (feedforward_bits(pd_bits kp kd pey sey)kv rsy ka ray)traj NP SP NT ST ltac:(congruence)
 CMDX CMDY LT4 ltac:(trace_access)ltac:(trace_access))
 as[mt[ET[CTX[CTY[RWT RUNT]]]]].
 assert(FLIGHT:Mem.load Mint8unsigned mt bf 0=Some(Vint(if flight then Int.one else Int.zero)))by(trace_frame;exact LF).
 assert(PDXT:Mem.load Mint32 mt bx 0=Some(Vint(pd_bits kp kd pex sex)))by(trace_frame;exact PDX).
 assert(PDYT:Mem.load Mint32 mt bpy 0=Some(Vint(pd_bits kp kd pey sey)))by(trace_frame;exact PDY).
 assert(KIT:Mem.load Mint32 mt bp 8=Some(Vint ki))by(trace_frame;exact LKI).
 assert(IXT:Mem.load Mint32 mt bi 0=Some(Vint ix))by(trace_frame;exact LIX).
 assert(IYT:Mem.load Mint32 mt bi 4=Some(Vint iy))by(trace_frame;exact LIY).
 assert(LTT:Mem.load Mint32 mt bt 0=Some(Vint traj))by(trace_frame;exact LT).
 destruct(original_flight_integrator_normal e mt bx bpy bp bi bt bf flight(pd_bits kp kd pex sex)(pd_bits kp kd pey sey)ki ix iy
 (after_feedforward kp kd kv ka pex sex rsx rax traj)(after_feedforward kp kd kv ka pey sey rsy ray traj)traj
 EX EY EF NP SP NI SI NT ST ltac:(repeat constructor;simpl;intuition congruence)
 FLIGHT PDXT PDYT KIT IXT IYT CTX CTY LTT ltac:(trace_access)ltac:(trace_access)ltac:(trace_access)ltac:(trace_access))
 as[mi[EI[IXF[IYF[CXF[CYF[RWI RUNI]]]]]]].
 assert(APPROXI:Mem.load Mint8unsigned mi bp 44=Some(Vint Int.zero))by(trace_frame;exact APPROX).
 pose proof(original_force_false_skips e mi bp NP SP APPROXI)as EFALSE.
 assert(LUI:Mem.load Mint32 mi bu 0=Some(Vint total))by(trace_frame;exact LU).
 destruct(original_total_clamp_normal e mi bp bu
 (next_command flight(after_feedforward kp kd kv ka pex sex rsx rax traj)(next_integral flight ix ki(pd_bits kp kd pex sex)traj))
 (next_command flight(after_feedforward kp kd kv ka pey sey rsy ray traj)(next_integral flight iy ki(pd_bits kp kd pey sey)traj))
 total NP SP NU SU ltac:(congruence)CXF CYF LUI ltac:(trace_access)ltac:(trace_access))
 as[mf[EU[CUX[CUY[RWU RUNU]]]]].
 exists mf;split.
 - eapply execution_splice_prefix with(n:=4%nat)(ma:=m4).
   + change(exec_stmt ge e m core_first_four E0 m4 Out_normal);exact E4.
   + change(exec_stmt ge e m4(Ssequence trajectory_clamp(Ssequence flight_statement(Ssequence force_statement(Ssequence total_clamp Sskip))))E0 mf Out_normal).
     eapply sequence_normal;[exact ET|]. eapply sequence_normal;[exact EI|].
     eapply sequence_normal;[exact EFALSE|]. eapply sequence_normal;[exact EU|constructor].
 - repeat split.
   + trace_frame;exact IXF.
   + trace_frame;exact IYF.
   + exact CUX.
   + exact CUY.
   + unfold controller_updates.
     apply replay_stores_app;exists m4;split;[exact RUN4|].
     apply replay_stores_app;exists mt;split;[exact RUNT|].
     apply replay_stores_app;exists mi;auto.
Qed.
Print Assumptions original_controller_prefix_normal.
