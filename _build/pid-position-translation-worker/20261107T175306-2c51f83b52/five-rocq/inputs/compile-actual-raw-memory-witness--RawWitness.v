From Stdlib Require Import List ZArith Bool.
From compcert Require Import AST Integers Values Memory Events Globalenvs Ctypes Csyntax Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout QuietWalk WitnessSetup.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.
(* An arbitrary valid raw input memory, not a substitute execution model and
   not a claim of equality with Genv.init_mem. Block slots follow the exact
   generated global-definition count; only actual source-read fields are set. *)
Fixpoint blank_blocks (n:nat) (m:mem) {struct n} : mem :=
 match n with O=>m | S k=>blank_blocks k (fst(Mem.alloc m 0 4096)) end.
Fixpoint gh_updates (m:mem) (b:block) (xs:list(list ident*Z)) {struct xs} : option mem :=
 match xs with []=>Some m | (path,v)::tail=>
 match store_path Mint32 m b gh_type path (i32 v) with None=>None | Some m1=>gh_updates m1 b tail end end.
Definition raw_prepare (shift:Z) (saturating:bool) : option prepared_witness :=
 let m0:=blank_blocks (List.length Source.global_definitions) Mem.empty in
 let(m1,bgh):=Mem.alloc m0 0 (sizeof ce gh_type) in
 let(m2,bret):=Mem.alloc m1 0 (sizeof ce sp_type) in
 match updates m2 [
 U Mint16unsigned Source._state state_type [Source._pos_status] (i32 2);
 U Mint16unsigned Source._state state_type [Source._speed_status] (i32 2);
 U Mint32 Source._state state_type [Source._ned_pos_i;Source._x] (i32(2048+shift));
 U Mint32 Source._state state_type [Source._ned_pos_i;Source._y] (i32 0);
 U Mint32 Source._state state_type [Source._ned_speed_i;Source._x] (i32 0);
 U Mint32 Source._state state_type [Source._ned_speed_i;Source._y] (i32 0);
 U Mint32 Source._guidance_pid pid_type [Source._kp] (i32 100);
 U Mint32 Source._guidance_pid pid_type [Source._kd] (i32 0);
 U Mint32 Source._guidance_pid pid_type [Source._ki] (i32 1);
 U Mint32 Source._guidance_pid pid_type [Source._kv] (i32 0);
 U Mint32 Source._guidance_pid pid_type [Source._ka] (i32 0);
 U Mint8unsigned Source._guidance_pid pid_type [Source._approx_force_by_thrust] (i32 0);
 U Mint32 Source._guidance_pid_trim_att_integrator vec_type [Source._x] (i32(if saturating then 93650940 else 0));
 U Mint32 Source._guidance_pid_trim_att_integrator vec_type [Source._y] (i32 0);
 U Mint32 Source._traj_max_bank tint [] (i32 1429);
 U Mint32 Source._total_max_bank tint [] (i32 3216);
 U Mfloat32 Source._guidance_h gh_type [Source._sp;Source._heading] (Vsingle Float32.zero)] with
 | None=>None | Some m3=>
 match gh_updates m3 bgh [([Source._ref;Source._pos;Source._x],2560+shift);([Source._ref;Source._pos;Source._y],0);([Source._ref;Source._speed;Source._x],0);([Source._ref;Source._speed;Source._y],0);([Source._ref;Source._accel;Source._x],0);([Source._ref;Source._accel;Source._y],0)] with
 | None=>None | Some m4=>Some{|wm:=m4;wgh:=bgh;wret:=bret|} end end.
Definition raw_witness_check fuel shift flight saturating : bool :=
 match raw_prepare shift saturating with None=>false | Some p=>
 match run_witness fuel flight p with Returnstate _ Kstop mf=>matches_expected flight saturating p mf | _=>false end end.
