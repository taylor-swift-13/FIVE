From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp.
Import ListNotations.
Open Scope Z_scope.
Definition flight_statement:=top_statement 5(fn_body S.f_guidance_pid_h_run).
Definition next_integral(flight:bool)(i ki pd maximum:int):int:=
 if flight then clip_bits(Int.add i(Int.mul ki pd))(Int.shl maximum(Int.repr 16))else Int.zero.
Definition next_command(flight:bool)(c ni:int):int:=if flight then Int.add c(Int.shr ni(Int.repr 16))else c.
Definition flight_updates(f:bool)(bi bp:block)(pdx pdy ki ix iy cx cy maximum:int):list scalar_update:=
 if f then [(Mint32,bi,0,Vint(Int.add ix(Int.mul ki pdx)));
 (Mint32,bi,4,Vint(Int.add iy(Int.mul ki pdy)));
 (Mint32,bi,0,Vint(next_integral true ix ki pdx maximum));
 (Mint32,bi,4,Vint(next_integral true iy ki pdy maximum));
 (Mint32,bp,32,Vint(next_command true cx(next_integral true ix ki pdx maximum)));
 (Mint32,bp,36,Vint(next_command true cy(next_integral true iy ki pdy maximum)))]
 else [(Mint32,bi,0,Vint Int.zero);(Mint32,bi,4,Vint Int.zero)].
Ltac raw_scalar_load := lazymatch goal with|-Mem.loadv ?c ?mm(Vptr ?bb ?oo)=Some ?vv=>
 let ox:=eval vm_compute in(Ptrofs.unsigned oo)in change(Mem.load c mm bb ox=Some vv);scalar_frame;first[eassumption|reflexivity]end.
Ltac flight_add EX EY NP SP NI SI NM SM STORE:=
 eapply atomic_assignop;
 [core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|
  core_rv EX EY I NP I I SP I I NI SI NM SM|reflexivity|
  eapply deref_loc_value;[reflexivity|reflexivity|raw_scalar_load]|
  reflexivity|reflexivity|
  eapply assign_loc_value;[reflexivity|reflexivity|exact STORE]|reflexivity].
Ltac flight_clamp EX EY NP SP NI SI NM SM STORE:=
 eapply atomic_assign_expression;
 [core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|
  eapply int32_clamp_expression;[reflexivity|reflexivity|reflexivity|reflexivity|
    core_rv EX EY I NP I I SP I I NI SI NM SM|core_rv EX EY I NP I I SP I I NI SI NM SM]|
  reflexivity|eapply assign_loc_value;[reflexivity|reflexivity|exact STORE]|reflexivity].
Theorem original_flight_integrator_normal:forall e m bx bpy bp bi bm bf(flight:bool)pdx pdy ki ix iy cx cy maximum,
 e!S._pd_x=Some(bx,tint) ->e!S._pd_y=Some(bpy,tint) ->e!S._in_flight=Some(bf,tbool) ->
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._guidance_pid_trim_att_integrator=None ->Genv.find_symbol ge S._guidance_pid_trim_att_integrator=Some bi ->
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bm ->
 NoDup[bx;bpy;bp;bi;bm;bf] ->
 Mem.load Mint8unsigned m bf 0=Some(Vint(if flight then Int.one else Int.zero)) ->
 Mem.load Mint32 m bx 0=Some(Vint pdx) ->Mem.load Mint32 m bpy 0=Some(Vint pdy) ->
 Mem.load Mint32 m bp 8=Some(Vint ki) ->
 Mem.load Mint32 m bi 0=Some(Vint ix) ->Mem.load Mint32 m bi 4=Some(Vint iy) ->
 Mem.load Mint32 m bp 32=Some(Vint cx) ->Mem.load Mint32 m bp 36=Some(Vint cy) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Mem.valid_access m Mint32 bi 0 Writable ->Mem.valid_access m Mint32 bi 4 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,exec_stmt ge e m flight_statement E0 mf Out_normal /\
 Mem.load Mint32 mf bi 0=Some(Vint(next_integral flight ix ki pdx maximum)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(next_integral flight iy ki pdy maximum)) /\
 Mem.load Mint32 mf bp 32=Some(Vint(next_command flight cx(next_integral flight ix ki pdx maximum))) /\
 Mem.load Mint32 mf bp 36=Some(Vint(next_command flight cy(next_integral flight iy ki pdy maximum))) /\
 raw_writes(fun b=>b=bi\/b=bp)m mf /\replay_stores m(flight_updates flight bi bp pdx pdy ki ix iy cx cy maximum)=Some mf.
Proof.
 intros e m bx bpy bp bi bm bf flight pdx pdy ki ix iy cx cy maximum EX EY EF NP SP NI SI NM SM SEP LF LPX LPY LKI LIX LIY LCX LCY LM AIX AIY ACX ACY.
 assert(DIST:bx<>bpy /\ bx<>bp /\ bx<>bi /\ bx<>bm /\ bx<>bf /\ bpy<>bp /\ bpy<>bi /\ bpy<>bm /\ bpy<>bf /\ bp<>bi /\ bp<>bm /\ bp<>bf /\ bi<>bm /\ bi<>bf /\ bm<>bf).
 {repeat rewrite NoDup_cons_iff in SEP;simpl in SEP;intuition congruence. }
 destruct DIST as(D0&D1&D2&D3&D4&D5&D6&D7&D8&D9&D10&D11&D12&D13&D14).
 assert(FL:eval_simple_rvalue ge e m(Evalof(Evar S._in_flight tbool)tbool)(Vint(if flight then Int.one else Int.zero))).
 { eapply read_scalar with(chunk:=Mbool)(b:=bf)(ofs:=Ptrofs.zero);
   [apply esl_var_local;exact EF|reflexivity|reflexivity|reflexivity|change(Mem.load Mbool m bf 0=Some(Vint(if flight then Int.one else Int.zero)));rewrite Mem.load_bool_int8_unsigned,LF;destruct flight;reflexivity]. }
 destruct flight.
 - cbn[next_integral next_command]in*.
   destruct(Mem.valid_access_store m Mint32 bi 0(Vint(Int.add ix(Int.mul ki pdx)))AIX)as[m1 ST1].
   assert(A2:Mem.valid_access m1 Mint32 bi 4 Writable).
   {eapply Mem.store_valid_access_1;[exact ST1|]. exact AIY. }
   destruct(Mem.valid_access_store m1 Mint32 bi 4(Vint(Int.add iy(Int.mul ki pdy)))A2)as[m2 ST2].
   assert(A3:Mem.valid_access m2 Mint32 bi 0 Writable).
   {eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact AIX. }
   destruct(Mem.valid_access_store m2 Mint32 bi 0(Vint(clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl maximum(Int.repr 16))))A3)as[m3 ST3].
   assert(A4:Mem.valid_access m3 Mint32 bi 4 Writable).
   {eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact AIY. }
   destruct(Mem.valid_access_store m3 Mint32 bi 4(Vint(clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl maximum(Int.repr 16))))A4)as[m4 ST4].
   assert(A5:Mem.valid_access m4 Mint32 bp 32 Writable).
   {eapply Mem.store_valid_access_1;[exact ST4|]. eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACX. }
   destruct(Mem.valid_access_store m4 Mint32 bp 32(Vint(Int.add cx(Int.shr(clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl maximum(Int.repr 16)))(Int.repr 16))))A5)as[m5 ST5].
   assert(A6:Mem.valid_access m5 Mint32 bp 36 Writable).
   {eapply Mem.store_valid_access_1;[exact ST5|]. eapply Mem.store_valid_access_1;[exact ST4|]. eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACY. }
   destruct(Mem.valid_access_store m5 Mint32 bp 36(Vint(Int.add cy(Int.shr(clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl maximum(Int.repr 16)))(Int.repr 16))))A6)as[mf ST6].
   exists mf;split.
   + unfold flight_statement;cbn[top_statement S.f_guidance_pid_h_run fn_body].
     eapply exec_Sifthenelse with(v1:=Vint Int.one)(b:=true)(m1:=m)(t1:=E0)(t2:=E0).
     * apply simple_expression;[exact FL|reflexivity].
     * reflexivity.
     * cbn.
       eapply sequence_normal;[flight_add EX EY NP SP NI SI NM SM ST1|].
       eapply sequence_normal;[flight_add EX EY NP SP NI SI NM SM ST2|].
       eapply sequence_normal.
       -- eapply sequence_normal;[flight_clamp EX EY NP SP NI SI NM SM ST3|flight_clamp EX EY NP SP NI SI NM SM ST4].
       -- eapply sequence_normal;[flight_add EX EY NP SP NI SI NM SM ST5|flight_add EX EY NP SP NI SI NM SM ST6].
   + repeat split;try(scalar_frame;reflexivity).
     eapply raw_writes_store;[left;reflexivity|exact ST1|].
     eapply raw_writes_store;[left;reflexivity|exact ST2|].
     eapply raw_writes_store;[left;reflexivity|exact ST3|].
     eapply raw_writes_store;[left;reflexivity|exact ST4|].
     eapply raw_writes_store;[right;reflexivity|exact ST5|].
     eapply raw_writes_store;[right;reflexivity|exact ST6|constructor].
     cbv beta iota zeta delta[flight_updates next_integral next_command replay_stores];rewrite ST1,ST2,ST3,ST4,ST5,ST6;reflexivity.
 - cbn[next_integral next_command]in*.
   destruct(Mem.valid_access_store m Mint32 bi 0(Vint Int.zero)AIX)as[m1 ST1].
   assert(A2:Mem.valid_access m1 Mint32 bi 4 Writable)by(eapply Mem.store_valid_access_1;eauto).
   destruct(Mem.valid_access_store m1 Mint32 bi 4(Vint Int.zero)A2)as[mf ST2].
   exists mf;split.
   + unfold flight_statement;cbn[top_statement S.f_guidance_pid_h_run fn_body].
     eapply exec_Sifthenelse with(v1:=Vint Int.zero)(b:=false)(m1:=m)(t1:=E0)(t2:=E0).
     * apply simple_expression;[exact FL|reflexivity].
     * reflexivity.
     * cbn;eapply sequence_normal;
       [eapply atomic_assign;[core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|constructor|reflexivity|reflexivity|eapply assign_loc_value;[reflexivity|reflexivity|exact ST1]|reflexivity]|
        eapply atomic_assign;[core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|constructor|reflexivity|reflexivity|eapply assign_loc_value;[reflexivity|reflexivity|exact ST2]|reflexivity]].
   + repeat split;try(scalar_frame;first[reflexivity|assumption]).
     eapply raw_writes_store;[left;reflexivity|exact ST1|].
     eapply raw_writes_store;[left;reflexivity|exact ST2|constructor].
     cbv beta iota zeta delta[flight_updates replay_stores];rewrite ST1,ST2;reflexivity.
Qed.
Print Assumptions original_flight_integrator_normal.
