From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory.
From PidPositionTranslationAttempt002 Require Import EntryPrefix SpeedEntryPrefix ClampSemantics PrefixFields SpeedPrefixFields ClampCombination FrontSemantics.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.
Theorem original_two_position_assignments_trace : forall e m bg gh pb sb rx ry px py flags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_pos_err=None ->
 e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 bg<>pb -> gh<>pb ->sb<>pb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) ->
 Mem.load Mint32 m sb 100=Some(Vint px) ->
 Mem.load Mint32 m sb 104=Some(Vint py) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 exists mf,
 Cstrategy.exec_stmt E.ge e m
 (Ssequence(original_position_assignment S._x)(original_position_assignment S._y))E0 mf Out_normal /\
 Mem.load Mint32 mf pb 0=Some(Vint(Int.sub rx px)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(Int.sub ry py)) /\
 raw_writes(fun b=>b=pb)m mf /\
 replay_stores m[(Mint32,pb,0,Vint(Int.sub rx px));(Mint32,pb,4,Vint(Int.sub ry py))]=Some mf.
Proof.
 intros e m bg gh pb sb rx ry px py flags ENV LOCAL GET SYM STATE DBG DGH DS PTR RX RY PX PY CACHE VALID WRITE.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m Mint32 pb 0(Vint(Int.sub rx px))A0)as[m1 ST0].
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m1 Mint32 pb 4(Vint(Int.sub ry py))A4)as[mf ST4].
 exists mf;split.
 - eapply sequence_normal with(ma:=m1).
   + eapply original_position_assignment_exec with(ra:=rx)(pa:=px)(sb:=sb)(delta:=100).
     * apply position_error_x_lvalue;[exact LOCAL|exact SYM].
     * eapply reference_x_read;eassumption.
     * eapply actual_cached_position_call;eassumption.
     * apply cached_measured_x_read;exact PX.
     * change(Mem.store Mint32 m pb 0(Vint(Int.sub rx px))=Some m1);exact ST0.
   + eapply original_position_assignment_exec with(ra:=ry)(pa:=py)(sb:=sb)(delta:=100).
     * apply position_error_y_lvalue;[exact LOCAL|exact SYM].
     * eapply reference_y_read;[exact ENV| |].
       -- erewrite Mem.load_store_other;[exact PTR|exact ST0|left;exact DBG].
       -- change(Mem.load Mint32 m1 gh 48=Some(Vint ry)).
          erewrite Mem.load_store_other;[exact RY|exact ST0|left;exact DGH].
     * eapply actual_cached_position_call;try eassumption.
       erewrite Mem.load_store_other;[exact CACHE|exact ST0|left;exact DS].
     * apply cached_measured_y_read.
       erewrite Mem.load_store_other;[exact PY|exact ST0|left;exact DS].
     * change(Mem.store Mint32 m1 pb 4(Vint(Int.sub ry py))=Some mf);exact ST4.
 - split.
   + rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia).
     rewrite(Mem.load_store_same Mint32 m pb 0(Vint(Int.sub rx px))m1 ST0);reflexivity.
   + split.
     * rewrite(Mem.load_store_same Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4);reflexivity.
     * split.
       -- eapply raw_writes_store;[reflexivity|exact ST0|].
          eapply raw_writes_store;[reflexivity|exact ST4|constructor].
       -- cbn[replay_stores];rewrite ST0,ST4;reflexivity.
Qed.
Theorem original_two_speed_assignments_trace : forall e m bg gh pb sb rx ry px py flags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_speed_err=None ->
 e!S._stateGetSpeedNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some pb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 bg<>pb -> gh<>pb ->sb<>pb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint ry) ->
 Mem.load Mint32 m sb 296=Some(Vint px) ->
 Mem.load Mint32 m sb 300=Some(Vint py) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 exists mf,
 Cstrategy.exec_stmt E.ge e m
 (Ssequence(original_speed_assignment S._x)(original_speed_assignment S._y))E0 mf Out_normal /\
 Mem.load Mint32 mf pb 0=Some(Vint(Int.sub rx px)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(Int.sub ry py)) /\
 raw_writes(fun b=>b=pb)m mf /\
 replay_stores m[(Mint32,pb,0,Vint(Int.sub rx px));(Mint32,pb,4,Vint(Int.sub ry py))]=Some mf.
Proof.
 intros e m bg gh pb sb rx ry px py flags ENV LOCAL GET SYM STATE DBG DGH DS PTR RX RY PX PY CACHE VALID WRITE.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m Mint32 pb 0(Vint(Int.sub rx px))A0)as[m1 ST0].
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m1 Mint32 pb 4(Vint(Int.sub ry py))A4)as[mf ST4].
 exists mf;split.
 - eapply sequence_normal with(ma:=m1).
   + eapply original_speed_assignment_exec with(ra:=rx)(pa:=px)(sb:=sb)(delta:=296).
     * apply speed_error_x_lvalue;[exact LOCAL|exact SYM].
     * eapply speed_reference_x_read;eassumption.
     * eapply actual_cached_speed_call;eassumption.
     * apply speed_cached_measured_x_read;exact PX.
     * change(Mem.store Mint32 m pb 0(Vint(Int.sub rx px))=Some m1);exact ST0.
   + eapply original_speed_assignment_exec with(ra:=ry)(pa:=py)(sb:=sb)(delta:=296).
     * apply speed_error_y_lvalue;[exact LOCAL|exact SYM].
     * eapply speed_reference_y_read;[exact ENV| |].
       -- erewrite Mem.load_store_other;[exact PTR|exact ST0|left;exact DBG].
       -- change(Mem.load Mint32 m1 gh 56=Some(Vint ry)).
          erewrite Mem.load_store_other;[exact RY|exact ST0|left;exact DGH].
     * eapply actual_cached_speed_call;try eassumption.
       erewrite Mem.load_store_other;[exact CACHE|exact ST0|left;exact DS].
     * apply speed_cached_measured_y_read.
       erewrite Mem.load_store_other;[exact PY|exact ST0|left;exact DS].
     * change(Mem.store Mint32 m1 pb 4(Vint(Int.sub ry py))=Some mf);exact ST4.
 - split.
   + rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia).
     rewrite(Mem.load_store_same Mint32 m pb 0(Vint(Int.sub rx px))m1 ST0);reflexivity.
   + split.
     * rewrite(Mem.load_store_same Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4);reflexivity.
     * split.
       -- eapply raw_writes_store;[reflexivity|exact ST0|].
          eapply raw_writes_store;[reflexivity|exact ST4|constructor].
       -- cbn[replay_stores];rewrite ST0,ST4;reflexivity.
Qed.
Theorem original_two_global_clamps_trace : forall e m id pb x y shift bound,
 e!id=None ->Genv.find_symbol E.ge id=Some pb ->
 Mem.load Mint32 m pb 0=Some(Vint x) ->
 Mem.load Mint32 m pb 4=Some(Vint y) ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 (forall e' m',eval_simple_rvalue E.ge e' m'(source_bound shift)(Vfloat(Float.of_int bound))) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 exists mf,
 Cstrategy.exec_stmt E.ge e m
 (Ssequence(global_clamp_assignment id S._x shift)(global_clamp_assignment id S._y shift))E0 mf Out_normal /\
 Mem.load Mint32 mf pb 0=Some(Vint(clamp_bits x bound)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits y bound)) /\
 raw_writes(fun b=>b=pb)m mf /\
 replay_stores m[(Mint32,pb,0,Vint(clamp_bits x bound));(Mint32,pb,4,Vint(clamp_bits y bound))]=Some mf.
Proof.
 intros e m id pb x y shift bound LOCAL SYM X Y WRITE BOUND NEG.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(source_clamp_assignment_exact_exists e m(pid_axis_lvalue id S._x)x shift bound pb Ptrofs.zero
 eq_refl eq_refl ltac:(apply global_axis_x_lvalue;assumption)ltac:(change(Mem.load Mint32 m pb 0=Some(Vint x));exact X)
 ltac:(exact A0)(BOUND e m)NEG)as[m1[EX[STX POSTX]]].
 pose proof(Mem.storev_store _ _ _ _ _ _ STX)as ST0.
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 assert(Y1:Mem.loadv Mint32 m1(Vptr pb(Ptrofs.repr 4))=Some(Vint y)).
 { change(Mem.load Mint32 m1 pb 4=Some(Vint y)).
   rewrite(Mem.load_store_other Mint32 m pb 0(Vint(clamp_bits x bound))m1 ST0 Mint32 pb 4)
   by(right;right;cbn;lia);exact Y. }
 destruct(source_clamp_assignment_exact_exists e m1(pid_axis_lvalue id S._y)y shift bound pb(Ptrofs.repr 4)
 eq_refl eq_refl ltac:(apply global_axis_y_lvalue;assumption)Y1
 ltac:(change(Mem.valid_access m1 Mint32 pb 4 Writable);exact A4)(BOUND e m1)NEG)as[mf[EY[STY POSTY]]].
 pose proof(Mem.storev_store _ _ _ _ _ _ STY)as ST4.
 exists mf;split.
 - apply sequence_normal with(ma:=m1);assumption.
 - split.
   + change(Mem.load Mint32 m1 pb 0=Some(Vint(clamp_bits x bound)))in POSTX.
     rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(clamp_bits y bound))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia);exact POSTX.
   + split.
     * change(Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits y bound)))in POSTY;exact POSTY.
     * split.
       -- eapply raw_writes_store;[reflexivity|exact ST0|].
          eapply raw_writes_store;[reflexivity|exact ST4|constructor].
       -- change(Mem.store Mint32 m pb 0(Vint(clamp_bits x bound))=Some m1)in ST0.
          change(Mem.store Mint32 m1 pb 4(Vint(clamp_bits y bound))=Some mf)in ST4.
          cbn[replay_stores];rewrite ST0,ST4;reflexivity.
Qed.
Definition front_updates(pb vb:block)(rx ry px py sx sy vx vy:int):list scalar_update:=
 [(Mint32,pb,0,Vint(Int.sub rx px));(Mint32,pb,4,Vint(Int.sub ry py))]++
 [(Mint32,pb,0,Vint(clamp_bits(Int.sub rx px)(Int.repr 4096)));(Mint32,pb,4,Vint(clamp_bits(Int.sub ry py)(Int.repr 4096)))]++
 [(Mint32,vb,0,Vint(Int.sub sx vx));(Mint32,vb,4,Vint(Int.sub sy vy))]++
 [(Mint32,vb,0,Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608)));(Mint32,vb,4,Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608)))].
Theorem original_front_constructive_trace : forall e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_pos_err=None ->e!S._guidance_pid_speed_err=None ->
 e!S._stateGetPositionNed_i=None ->e!S._stateGetSpeedNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some vb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 NoDup[bg;gh;pb;vb;sb] ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy) ->
 Mem.load Mint32 m sb 100=Some(Vint px) ->Mem.load Mint32 m sb 104=Some(Vint py) ->
 Mem.load Mint32 m sb 296=Some(Vint vx) ->Mem.load Mint32 m sb 300=Some(Vint vy) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint sflags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->Int.and sflags(Int.repr 2)=Int.repr 2 ->
 Mem.range_perm m pb 0 8 Cur Writable ->Mem.range_perm m vb 0 8 Cur Writable ->
 exists mf,
 (forall k,star Csem.step E.ge(State S.f_guidance_pid_h_run_pos(fn_body S.f_guidance_pid_h_run_pos)k e m)E0
 (State S.f_guidance_pid_h_run_pos after_front k e mf)) /\
 Mem.load Mint32 mf pb 0=Some(Vint(clamp_bits(Int.sub rx px)(Int.repr 4096))) /\
 Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits(Int.sub ry py)(Int.repr 4096))) /\
 Mem.load Mint32 mf vb 0=Some(Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608))) /\
 Mem.load Mint32 mf vb 4=Some(Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608))) /\
 raw_writes(fun b=>b=pb\/b=vb)m mf /\
 replay_stores m(front_updates pb vb rx ry px py sx sy vx vy)=Some mf.
Proof.
 intros e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags
 ENV LP LV GP GV SP SV STATE ND PTR RX RY SX SY PX PY VX VY CACHE SCACHE VALID SVALID WP WV.
 assert(DIST:bg<>pb /\ gh<>pb /\ sb<>pb /\ bg<>vb /\ gh<>vb /\ sb<>vb /\ pb<>vb).
 { repeat rewrite NoDup_cons_iff in ND;cbn in ND;intuition congruence. }
 destruct DIST as[DBG[DGH[DS[DVBG[DVGH[DVS DPV]]]]]].
 destruct(original_two_position_assignments_trace e m bg gh pb sb rx ry px py flags
 ENV LP GP SP STATE DBG DGH DS PTR RX RY PX PY CACHE VALID WP)as[m1[POS[X1[Y1[W1 R1]]]]].
 destruct(original_two_global_clamps_trace e m1 S._guidance_pid_pos_err pb (Int.sub rx px)(Int.sub ry py)8(Int.repr 4096)
 LP SP X1 Y1 ltac:(eapply raw_writes_range;[exact W1|exact WP])source_bound_8 position_bound_neg)
 as[m2[PCL[X2[Y2[W2 R2]]]]].
 assert(WPOS:raw_writes(fun b=>b=pb)m m2)by(eapply raw_writes_trans;eauto).
 assert(PTR2:Mem.load Mint64 m2 bg 0=Some(Vptr gh Ptrofs.zero)).
 { rewrite(raw_writes_load_frame _ _ _ WPOS Mint64 bg 0)by(congruence);exact PTR. }
 assert(SX2:load_path Mint32 m2 gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx)).
 { change(Mem.load Mint32 m2 gh 52=Some(Vint sx)).
   rewrite(raw_writes_load_frame _ _ _ WPOS Mint32 gh 52)by(congruence);exact SX. }
 assert(SY2:load_path Mint32 m2 gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy)).
 { change(Mem.load Mint32 m2 gh 56=Some(Vint sy)).
   rewrite(raw_writes_load_frame _ _ _ WPOS Mint32 gh 56)by(congruence);exact SY. }
 assert(VX2:Mem.load Mint32 m2 sb 296=Some(Vint vx)).
 { rewrite(raw_writes_load_frame _ _ _ WPOS Mint32 sb 296)by(congruence);exact VX. }
 assert(VY2:Mem.load Mint32 m2 sb 300=Some(Vint vy)).
 { rewrite(raw_writes_load_frame _ _ _ WPOS Mint32 sb 300)by(congruence);exact VY. }
 assert(SC2:Mem.load Mint16unsigned m2 sb 280=Some(Vint sflags)).
 { rewrite(raw_writes_load_frame _ _ _ WPOS Mint16unsigned sb 280)by(congruence);exact SCACHE. }
 destruct(original_two_speed_assignments_trace e m2 bg gh vb sb sx sy vx vy sflags
 ENV LV GV SV STATE DVBG DVGH DVS PTR2 SX2 SY2 VX2 VY2 SC2 SVALID
 ltac:(eapply raw_writes_range;[exact WPOS|exact WV]))as[m3[SPD[VX3[VY3[W3 R3]]]]].
 destruct(original_two_global_clamps_trace e m3 S._guidance_pid_speed_err vb(Int.sub sx vx)(Int.sub sy vy)19(Int.repr 8388608)
 LV SV VX3 VY3 ltac:(eapply raw_writes_range;[exact W3|];eapply raw_writes_range;[exact WPOS|exact WV])
 source_bound_19 speed_bound_neg)as[mf[SCL[VX4[VY4[W4 R4]]]]].
 assert(WSPD:raw_writes(fun b=>b=vb)m2 mf)by(eapply raw_writes_trans;eauto).
 exists mf;split.
 - intro k;eapply original_front_path;[exact POS|exact PCL|exact SPD|exact SCL].
 - split.
   + rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 0)by(congruence);exact X2.
   + split.
     * rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 4)by(congruence);exact Y2.
     * split;[exact VX4|]. split;[exact VY4|]. split.
       { eapply raw_writes_trans.
         - eapply front_writes_weaken with(P:=fun b=>b=pb);[intros;left;assumption|exact WPOS].
         - eapply front_writes_weaken with(P:=fun b=>b=vb);[intros;right;assumption|exact WSPD]. }
       { unfold front_updates.
         apply replay_stores_app;exists m1;split;[exact R1|].
         apply replay_stores_app;exists m2;split;[exact R2|].
         apply replay_stores_app;exists m3;split;assumption. }
Qed.

Print Assumptions original_front_constructive_trace.
