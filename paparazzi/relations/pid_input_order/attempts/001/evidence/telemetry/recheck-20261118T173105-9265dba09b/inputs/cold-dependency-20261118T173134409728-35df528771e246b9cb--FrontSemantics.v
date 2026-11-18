From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory.
From PidPositionTranslationAttempt002 Require Import EntryPrefix SpeedEntryPrefix ClampSemantics PrefixFields SpeedPrefixFields ClampCombination.
Import ListNotations.
Open Scope Z_scope.
Module S := PidPositionRunPos.Source.
Module E := PidPositionRunPos.Execution.
Definition position_assign_pair:=Ssequence(original_position_assignment S._x)(original_position_assignment S._y).
Definition position_clamp_pair:=Ssequence(original_position_clamp S._x)(original_position_clamp S._y).
Definition speed_assign_pair:=Ssequence(original_speed_assignment S._x)(original_speed_assignment S._y).
Definition speed_clamp_pair:=Ssequence(original_speed_clamp S._x)(original_speed_clamp S._y).
Definition after_front:statement:=
 match fn_body S.f_guidance_pid_h_run_pos with
 | Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ tail)))=>tail|_=>Sskip end.
Lemma original_front_ast :
 fn_body S.f_guidance_pid_h_run_pos=
 Ssequence position_assign_pair(Ssequence position_clamp_pair(Ssequence speed_assign_pair(Ssequence speed_clamp_pair after_front))).
Proof. reflexivity. Qed.
Lemma original_front_path : forall e k m m1 m2 m3 mf,
 Cstrategy.exec_stmt E.ge e m position_assign_pair E0 m1 Out_normal ->
 Cstrategy.exec_stmt E.ge e m1 position_clamp_pair E0 m2 Out_normal ->
 Cstrategy.exec_stmt E.ge e m2 speed_assign_pair E0 m3 Out_normal ->
 Cstrategy.exec_stmt E.ge e m3 speed_clamp_pair E0 mf Out_normal ->
 star Csem.step E.ge(State S.f_guidance_pid_h_run_pos(fn_body S.f_guidance_pid_h_run_pos)k e m)E0
 (State S.f_guidance_pid_h_run_pos after_front k e mf).
Proof.
 intros e k m m1 m2 m3 mf A B C D;rewrite original_front_ast.
 eapply star_trans with(t1:=E0)(t2:=E0);[apply statement_prefix_path;exact A| |reflexivity].
 eapply star_trans with(t1:=E0)(t2:=E0);[apply statement_prefix_path;exact B| |reflexivity].
 eapply star_trans with(t1:=E0)(t2:=E0);[apply statement_prefix_path;exact C| |reflexivity].
 apply statement_prefix_path;exact D.
Qed.
Lemma front_writes_weaken : forall P Q m mf,
 (forall b,P b->Q b)->raw_writes P m mf->raw_writes Q m mf.
Proof.
 intros P Q m mf INC W;induction W;[constructor|eapply raw_writes_store;eauto|eapply raw_writes_bytes;eauto].
Qed.

Theorem original_front_constructive : forall e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags,
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
 raw_writes(fun b=>b=pb\/b=vb)m mf.
Proof.
 intros e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags
 ENV LP LV GP GV SP SV STATE ND PTR RX RY SX SY PX PY VX VY CACHE SCACHE VALID SVALID WP WV.
 assert(DIST:bg<>pb /\ gh<>pb /\ sb<>pb /\ bg<>vb /\ gh<>vb /\ sb<>vb /\ pb<>vb).
 { repeat rewrite NoDup_cons_iff in ND;cbn in ND;intuition congruence. }
 destruct DIST as[DBG[DGH[DS[DVBG[DVGH[DVS DPV]]]]]].
 destruct(original_two_position_assignments e m bg gh pb sb rx ry px py flags
 ENV LP GP SP STATE DBG DGH DS PTR RX RY PX PY CACHE VALID WP)as[m1[POS[X1[Y1 W1]]]].
 destruct(original_two_global_clamps e m1 S._guidance_pid_pos_err pb (Int.sub rx px)(Int.sub ry py)8(Int.repr 4096)
 LP SP X1 Y1 ltac:(eapply raw_writes_range;[exact W1|exact WP])source_bound_8 position_bound_neg)
 as[m2[PCL[X2[Y2 W2]]]].
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
 destruct(original_two_speed_assignments e m2 bg gh vb sb sx sy vx vy sflags
 ENV LV GV SV STATE DVBG DVGH DVS PTR2 SX2 SY2 VX2 VY2 SC2 SVALID
 ltac:(eapply raw_writes_range;[exact WPOS|exact WV]))as[m3[SPD[VX3[VY3 W3]]]].
 destruct(original_two_global_clamps e m3 S._guidance_pid_speed_err vb(Int.sub sx vx)(Int.sub sy vy)19(Int.repr 8388608)
 LV SV VX3 VY3 ltac:(eapply raw_writes_range;[exact W3|];eapply raw_writes_range;[exact WPOS|exact WV])
 source_bound_19 speed_bound_neg)as[mf[SCL[VX4[VY4 W4]]]].
 assert(WSPD:raw_writes(fun b=>b=vb)m2 mf)by(eapply raw_writes_trans;eauto).
 exists mf;split.
 - intro k;eapply original_front_path;[exact POS|exact PCL|exact SPD|exact SCL].
 - split.
   + rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 0)by(congruence);exact X2.
   + split.
     * rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 4)by(congruence);exact Y2.
     * split;[exact VX4|]. split;[exact VY4|].
       eapply raw_writes_trans.
       -- eapply front_writes_weaken with(P:=fun b=>b=pb);[intros;left;assumption|exact WPOS].
       -- eapply front_writes_weaken with(P:=fun b=>b=vb);[intros;right;assumption|exact WSPD].
Qed.
Print Assumptions original_front_constructive.
