From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix.
Import ListNotations.
Open Scope Z_scope.
From PidPositionSafety Require Import ConditionalBlock CoreForce.
From FiveGuidanceAllOrder Require Import PhaseComposition.
Theorem original_controller_front_certificate:forall e m bp be bs gh bg bx bpy bi bt bu bf
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
 (forall k,exists P,certificate ge P(State S.f_guidance_pid_h_run(drop_statements 8(fn_body S.f_guidance_pid_h_run))k e mf)/\
 P(State S.f_guidance_pid_h_run(fn_body S.f_guidance_pid_h_run)k e m)) /\
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
 - intros k.
   set(tail0:=drop_statements 8(fn_body S.f_guidance_pid_h_run)).
   set(tail1:=Ssequence total_clamp tail0).
   set(tail2:=Ssequence force_statement tail1).
   set(tail3:=Ssequence flight_statement tail2).
   set(tail4:=Ssequence trajectory_clamp tail3).
   assert(C0:certificate ge(fun s=>s=State S.f_guidance_pid_h_run tail0 k e mf)
     (State S.f_guidance_pid_h_run tail0 k e mf))by apply singleton_certificate.
   destruct(conditional_block_from_normal ge S.f_guidance_pid_h_run e total_clamp mi mf
     ltac:(reflexivity)EU(Kseq tail0 k))as[P1[C1 I1]].
   destruct(sequence_certificate ge S.f_guidance_pid_h_run e k mi mf total_clamp tail0
     P1(fun s=>s=State S.f_guidance_pid_h_run tail0 k e mf)_
     C1 I1 C0 eq_refl)as[Q1[DC1 J1]].
   destruct(original_force_false_certificate e mi bp(Kseq tail1 k)NP SP APPROXI)as[P2[C2 I2]].
   destruct(sequence_certificate ge S.f_guidance_pid_h_run e k mi mi force_statement tail1
     P2 Q1 _ C2 I2 DC1 J1)as[Q2[DC2 J2]].
   destruct(conditional_block_from_normal ge S.f_guidance_pid_h_run e flight_statement mt mi
     ltac:(reflexivity)EI(Kseq tail2 k))as[P3[C3 I3]].
   destruct(sequence_certificate ge S.f_guidance_pid_h_run e k mt mi flight_statement tail2
     P3 Q2 _ C3 I3 DC2 J2)as[Q3[DC3 J3]].
   destruct(conditional_block_from_normal ge S.f_guidance_pid_h_run e trajectory_clamp m4 mt
     ltac:(reflexivity)ET(Kseq tail3 k))as[P4[C4 I4]].
   destruct(sequence_certificate ge S.f_guidance_pid_h_run e k m4 mt trajectory_clamp tail3
     P4 Q3 _ C4 I4 DC3 J3)as[Q4[DC4 J4]].
   eapply conditional_prefix_certificate with(n:=4%nat)(mid:=m4)(Q:=Q4).
   + reflexivity.
   + exact E4.
   + exact DC4.
   + exact J4.
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

Print Assumptions original_controller_front_certificate.
