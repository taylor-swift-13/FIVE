From Stdlib Require Import List ZArith Bool.
From compcert Require Import AST Integers Values Memory Memdata Events Globalenvs Ctypes Csyntax Csem Cexec Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout QuietWalk.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.
Record global_update := { uc:memory_chunk; ui:ident; ut:type; up:list ident; uv:val }.
Definition U c i t p v := {|uc:=c;ui:=i;ut:=t;up:=p;uv:=v|}.
Fixpoint updates (m:mem) (us:list global_update) : option mem :=
 match us with []=>Some m | u::tail=>
 match store_global (uc u) m (ui u) (ut u) (up u) (uv u) with
 None=>None | Some m1=>updates m1 tail end end.
Record prepared_witness := { wm:mem; wgh:block; wret:block }.
Definition i32 (z:Z) := Vint(Int.repr z).
Definition prepare_witness (shift:Z) (saturating:bool) : option prepared_witness :=
 match Genv.init_mem Source.prog with
 | None=>None | Some m0=>
 let (m1,bgh):=Mem.alloc m0 0 (sizeof ce gh_type) in
 let (m2,bret):=Mem.alloc m1 0 (sizeof ce sp_type) in
 match Mem.storebytes m2 bgh 0 (List.repeat (Memdata.Byte Byte.zero) (Z.to_nat(sizeof ce gh_type))) with
 | None=>None | Some m3=>
 match store_path Mint32 m3 bgh gh_type [Source._ref;Source._pos;Source._x] (i32(2560+shift)) with
 | None=>None | Some m4=>
 match updates m4 [
 U Mint16unsigned Source._state state_type [Source._pos_status] (i32 2);
 U Mint16unsigned Source._state state_type [Source._speed_status] (i32 2);
 U Mint32 Source._state state_type [Source._ned_pos_i;Source._x] (i32(2048+shift));
 U Mint32 Source._guidance_pid pid_type [Source._kp] (i32 100);
 U Mint32 Source._guidance_pid pid_type [Source._ki] (i32 1);
 U Mint32 Source._guidance_pid_trim_att_integrator vec_type [Source._x] (i32(if saturating then 93650940 else 0))] with
 | None=>None | Some m5=>Some{|wm:=m5;wgh:=bgh;wret:=bret|}
 end end end end.
Definition witness_args (flight:bool) (p:prepared_witness) : list val :=
 [Vptr(wret p) Ptrofs.zero; Vint(if flight then Int.one else Int.zero); Vptr(wgh p) Ptrofs.zero].
Definition run_witness (fuel:nat) (flight:bool) (p:prepared_witness) : Csem.state :=
 quiet_walk Execution.ge Execution.no_external Execution.no_external Execution.quiet_world fuel
 (Execution.entry(witness_args flight p)(wm p)).
Definition equal_i32 (v:option val) (expected:Z) : bool :=
 match v with Some(Vint actual)=>Int.eq actual (Int.repr expected) | _=>false end.
Definition matches_expected (flight saturating:bool) (p:prepared_witness) (m:mem) : bool :=
 let extra:=if andb flight saturating then 1429 else 0 in
 let integral:=if flight then (if saturating then 93650944 else 800) else 0 in
 equal_i32(load_path Mint32 m (wret p) sp_type [Source._type]) 2 &&
 equal_i32(load_path Mint32 m (wret p) sp_type [Source._format]) 0 &&
 equal_i32(load_path Mint32 m (wret p) sp_type [Source._sp;Source._ltp_i;Source._vect;Source._x]) (800+extra) &&
 equal_i32(load_path Mint32 m (wret p) sp_type [Source._sp;Source._ltp_i;Source._vect;Source._y]) 0 &&
 equal_i32(load_path Mint32 m (wret p) sp_type [Source._sp;Source._ltp_i;Source._heading]) 0 &&
 equal_i32(load_global Mint32 m Source._guidance_pid pid_type [Source._cmd_earth;Source._x]) (800+extra) &&
 equal_i32(load_global Mint32 m Source._guidance_pid_trim_att_integrator vec_type [Source._x]) integral.
Definition witness_check (fuel:nat) (shift:Z) (flight saturating:bool) : bool :=
 match prepare_witness shift saturating with None=>false | Some p=>
 match run_witness fuel flight p with
 | Returnstate _ Kstop m=>matches_expected flight saturating p m
 | _=>false end end.
Theorem every_run_witness_is_actual_Csem_path : forall fuel flight p,
 star Csem.step Execution.ge (Execution.entry(witness_args flight p)(wm p)) E0 (run_witness fuel flight p).
Proof. intros;apply quiet_walk_actual_Csem_path. Qed.
