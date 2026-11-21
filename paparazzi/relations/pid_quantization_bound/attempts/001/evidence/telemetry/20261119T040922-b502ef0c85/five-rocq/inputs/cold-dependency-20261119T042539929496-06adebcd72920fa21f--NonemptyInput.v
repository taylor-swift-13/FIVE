From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
From PidPositionTranslationAttempt002 Require Import WitnessBase WitnessMemory WitnessUpdates ComputedRelation.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent Float32.of_int Float32.cmp Float32.compare.
Ltac witness_zero_path ZERO :=
 lazymatch goal with |-load_path ?ch ?mm ?bb ?ty ?path=Some ?v=>
 let info:=eval vm_compute in(path_info ty path)in
 lazymatch info with Some(_,?ofs)=>
 change(Mem.load ch mm bb ofs=Some v);apply(ZERO ch ofs);[lia|cbn;lia|witness_align]
 end end.
Theorem canonical_input_nonvacuity : InputNonvacuityGoal.
Proof.
 destruct symbolic_witness_base as(base&gh&ret&bp&be&bv&bi&bh&sb&
 CONTRACT&GHR&GSYM&RSYM&GVAR&WG&WR&SP&VP&SE&VE&SV&VV&SI&VI&SH&SS&VS&
 WP&WE&WV&WI&WS&ZP&ZI&ZH&ZS).
 assert(GS:gh<>sb)by(intro EQ;subst gh;apply(GSYM S._state);exact SS).
 assert(PG:bp<>gh)by(intro EQ;subst bp;apply(GSYM S._guidance_pid);exact SP).
 assert(IG:bi<>gh)by(intro EQ;subst bi;apply(GSYM S._guidance_pid_trim_att_integrator);exact SI).
 assert(HG:bh<>gh)by(intro EQ;subst bh;apply(GSYM S._guidance_h);exact SH).
 assert(PS:bp<>sb)by(eapply Genv.global_addresses_distinct;[|exact SP|exact SS];discriminate).
 assert(IS:bi<>sb)by(eapply Genv.global_addresses_distinct;[|exact SI|exact SS];discriminate).
 assert(HS:bh<>sb)by(eapply Genv.global_addresses_distinct;[|exact SH|exact SS];discriminate).
 assert(ROS:forall b gv,Genv.find_var_info E.ge b=Some gv ->gvar_readonly gv=true ->b<>sb).
 { intros b gv VAR RO EQ;subst b;rewrite VS in VAR;injection VAR as<-;discriminate. }
 assert(GOOD:forall shift mf,0<=shift<=25600 ->
 replay_stores base(witness_updates gh sb shift)=Some mf ->InputGood mf gh ret).
 { intros shift mf RANGE RUN.
   destruct(witness_updated_loads base mf gh sb shift GS ZS RUN)
   as(CP&CS&RX&RY&SX&SY&AX&AY&PX&PY&VX&VY).
   assert(RAW:raw_writes(fun _=>True)base mf).
   { eapply replay_stores_raw;[exact RUN|];unfold witness_updates;witness_forall ltac:(exact I). }
   assert(PZERO:Genv.read_as_zero mf bp 0 48).
   { eapply zero_preserved_by_disjoint_replay;[exact ZP| |exact RUN].
     unfold witness_updates;witness_forall ltac:(cbn;congruence). }
   assert(IZERO:Genv.read_as_zero mf bi 0 8).
   { eapply zero_preserved_by_disjoint_replay;[exact ZI| |exact RUN].
     unfold witness_updates;witness_forall ltac:(cbn;congruence). }
   assert(HZERO:Genv.read_as_zero mf bh 0 84).
   { eapply zero_preserved_by_disjoint_replay;[exact ZH| |exact RUN].
     unfold witness_updates;witness_forall ltac:(cbn;congruence). }
   assert(GLOBAL:global_bytes_initialized mf).
   { eapply global_contract_after_replay;[exact CONTRACT| |exact RUN].
     unfold witness_updates;witness_forall ltac:(
       cbn;first[exact ROS|intros b gv VAR RO;eapply GVAR;exact VAR]). }
   assert(UNIQUE:forall id,Genv.find_symbol E.ge id=Some gh->id=S._guidance_h).
   { intros id BAD;exfalso;apply(GSYM id);exact BAD. }
   assert(GHREAD:Mem.range_perm mf gh 0(sizeof ce gh_type)Cur Readable).
   { change(Mem.range_perm mf gh 0 84 Cur Readable);intros ofs R.
     eapply Mem.perm_implies with(p1:=Writable);[apply(proj1(raw_writes_perm _ _ _ RAW gh ofs Cur Writable));apply WG;exact R|constructor]. }
   assert(RETWRITE:Mem.range_perm mf ret 0(sizeof ce sp_type)Cur Writable).
   { eapply raw_writes_range;[exact RAW|exact WR]. }
   assert(CTRL:writable_controller_globals mf).
   { intros id IN;destruct IN as[<-|[<-|[<-|[<-|[]]]]].
     - exists bp,S.v_guidance_pid;split;[exact SP|];split;[exact VP|];apply(raw_writes_range _ _ _ RAW);exact WP.
     - exists be,S.v_guidance_pid_pos_err;split;[exact SE|];split;[exact VE|];apply(raw_writes_range _ _ _ RAW);exact WE.
     - exists bv,S.v_guidance_pid_speed_err;split;[exact SV|];split;[exact VV|];apply(raw_writes_range _ _ _ RAW);exact WV.
     - exists bi,S.v_guidance_pid_trim_att_integrator;split;[exact SI|];split;[exact VI|];apply(raw_writes_range _ _ _ RAW);exact WI. }
   assert(CACHE:caches_valid mf).
   { exists(Int.repr 2),(Int.repr 2);unfold load_global;rewrite SS;repeat split;assumption||reflexivity. }
   assert(APP:load_global Mint8unsigned mf S._guidance_pid pid_type[S._approx_force_by_thrust]=Some(Vint Int.zero)).
   { unfold load_global;rewrite SP;witness_zero_path PZERO. }
   assert(HEAD:heading_safe mf).
   { exists Float32.zero;split.
     - unfold load_global;rewrite SH;witness_zero_path HZERO.
     - split;reflexivity. }
   assert(GAINS:forall gain,In gain[S._kp;S._kd;S._ki;S._kv;S._ka]->
     bounded_global mf S._guidance_pid pid_type[gain]0 100).
   { intros gain IN;destruct IN as[<-|[<-|[<-|[<-|[<-|[]]]]]];
     (exists Int.zero;split;
     [unfold load_global;rewrite SP;witness_zero_path PZERO
     |rewrite Int.signed_zero;lia]). }
   assert(AXES:forall axis,In axis[S._x;S._y]->
     bounded_global mf S._guidance_pid_trim_att_integrator vec_type[axis](-100000000)100000000 /\
     bounded_path mf gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
     bounded_path mf gh gh_type[S._ref;S._accel;axis](-10000)10000 /\
     bounded_global mf S._state state_type[S._ned_speed_i;axis](-10000)10000).
   { intros axis IN;destruct IN as[<-|[<-|[]]].
     - split.
       + exists Int.zero;split;[unfold load_global;rewrite SI;witness_zero_path IZERO|rewrite Int.signed_zero;lia].
       + split.
         * exists Int.zero;split;[exact SX|rewrite Int.signed_zero;lia].
         * split.
           -- exists Int.zero;split;[exact AX|rewrite Int.signed_zero;lia].
           -- exists Int.zero;split;[unfold load_global;rewrite SS;exact VX|rewrite Int.signed_zero;lia].
     - split.
       + exists Int.zero;split;[unfold load_global;rewrite SI;witness_zero_path IZERO|rewrite Int.signed_zero;lia].
       + split.
         * exists Int.zero;split;[exact SY|rewrite Int.signed_zero;lia].
         * split.
           -- exists Int.zero;split;[exact AY|rewrite Int.signed_zero;lia].
           -- exists Int.zero;split;[unfold load_global;rewrite SS;exact VY|rewrite Int.signed_zero;lia]. }
   assert(SAFE:position_subtractions_safe mf gh).
   { intros axis IN;destruct IN as[<-|[<-|[]]].
     - exists(Int.repr(512+shift)),(Int.repr shift);split;[exact RX|];split.
       + unfold load_global;rewrite SS;exact PX.
       + unfold signed32.
         rewrite(Int.signed_repr(512+shift))by(change(-2147483648<=512+shift<=2147483647);lia).
         rewrite(Int.signed_repr shift)by(change(-2147483648<=shift<=2147483647);lia);lia.
     - exists Int.zero,Int.zero;split;[exact RY|];split.
       + unfold load_global;rewrite SS;exact PY.
       + unfold signed32;rewrite Int.signed_zero;lia. }
   assert(INITPOS:initialized_positions mf gh).
   { intros axis IN;destruct(SAFE axis IN)as(r&p&R&P&N);exists r,p;auto. }
   unfold InputGood;split;[unfold InputGoodLegacy;tauto|tauto]. }
 destruct(witness_updates_exist base gh sb 0 WG WS)as[a RA].
 destruct(witness_updates_exist base gh sb 25600 WG WS)as[b RB].
 pose proof(GOOD 0 a ltac:(lia)RA)as GA.
 pose proof(GOOD 25600 b ltac:(lia)RB)as GB.
 destruct(witness_updated_loads base a gh sb 0 GS ZS RA)as(CPA&CSA&RXA&RYA&SXA&SYA&AXA&AYA&PXA&PYA&VXA&VYA).
 destruct(witness_updated_loads base b gh sb 25600 GS ZS RB)as(CPB&CSB&RXB&RYB&SXB&SYB&AXB&AYB&PXB&PYB&VXB&VYB).
 assert(FRAME:same_except_positions_and_return gh ret a b)by(eapply witness_replays_related;eauto).
 assert(TX:AxisTranslation gh a b S._x 25600).
 { exists(Int.repr 512),Int.zero,(Int.repr 26112),(Int.repr 25600).
   split;[exact RXA|];split;[unfold load_global;rewrite SS;exact PXA|].
   split;[exact RXB|];split;[unfold load_global;rewrite SS;exact PXB|].
   rewrite(Int.signed_repr 512)by(change(-2147483648<=512<=2147483647);lia).
   rewrite Int.signed_zero.
   rewrite(Int.signed_repr 26112)by(change(-2147483648<=26112<=2147483647);lia).
   rewrite(Int.signed_repr 25600)by(change(-2147483648<=25600<=2147483647);lia).
   unfold physical_translation,signed32;repeat split;lia. }
 assert(TY:AxisTranslation gh a b S._y 0).
 { exists Int.zero,Int.zero,Int.zero,Int.zero.
   split;[exact RYA|];split;[unfold load_global;rewrite SS;exact PYA|].
   split;[exact RYB|];split;[unfold load_global;rewrite SS;exact PYB|].
   rewrite Int.signed_zero;unfold physical_translation,signed32;repeat split;lia. }
 exists gh,ret,a,b,25600,0;split.
 - exact(conj GA(conj GB(conj FRAME(conj TX TY)))).
 - split;[lia|]. exists(Int.repr 512),Int.zero;split;[exact RXA|];split.
   + unfold load_global;rewrite SS;exact PXA.
   + rewrite(Int.signed_repr 512)by(change(-2147483648<=512<=2147483647);lia);rewrite Int.signed_zero;lia.
Qed.
Theorem canonical_nonzero_execution_nonvacuity : NonzeroNonvacuityGoal.
Proof.
 destruct canonical_input_nonvacuity as(gh&ret&a&b&dx&dy&NONZERO).
 exists gh,ret,a,b,dx,dy;split;[exact NONZERO|].
 intro flight;exact(constructed_original_position_translation gh ret a b dx dy flight(proj1 NONZERO)).
Qed.
Print Assumptions canonical_input_nonvacuity.
Print Assumptions canonical_nonzero_execution_nonvacuity.
