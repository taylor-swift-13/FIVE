From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
From PidPositionTranslationAttempt002 Require Import WitnessBase WitnessMemory WitnessUpdates ByteAgreement.
From PidSignSymmetryProblem Require Import Spec.
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
Definition sign_updates(gh sb bp bi:block)(r:Z):list scalar_update:=[
 (Mint16unsigned,sb,2,Vint(Int.repr 2));
 (Mint16unsigned,sb,280,Vint(Int.repr 2));
 (Mint32,gh,44,Vint(Int.repr r));
 (Mint32,gh,48,Vint(Int.zero));
 (Mint32,gh,52,Vint(Int.zero));
 (Mint32,gh,56,Vint(Int.zero));
 (Mint32,gh,60,Vint(Int.zero));
 (Mint32,gh,64,Vint(Int.zero));
 (Mint32,sb,100,Vint(Int.zero));
 (Mint32,sb,104,Vint(Int.zero));
 (Mint32,sb,296,Vint(Int.zero));
 (Mint32,sb,300,Vint(Int.zero));
 (Mint32,bp,0,Vint(Int.one));
 (Mint32,bp,4,Vint(Int.zero));
 (Mint32,bp,8,Vint(Int.one));
 (Mint32,bp,12,Vint(Int.zero));
 (Mint32,bp,16,Vint(Int.zero));
 (Mint8unsigned,bp,44,Vint(Int.zero));
 (Mint32,bi,0,Vint(Int.zero));
 (Mint32,bi,4,Vint(Int.zero))].
Lemma sign_updates_exist : forall base gh sb bp bi r,
 Mem.range_perm base gh 0 84 Cur Writable ->
 Mem.range_perm base sb 0 656 Cur Writable ->
 Mem.range_perm base bp 0 48 Cur Writable ->
 Mem.range_perm base bi 0 8 Cur Writable ->
 exists mf,replay_stores base(sign_updates gh sb bp bi r)=Some mf.
Proof.
 intros base gh sb bp bi r WG WS WP WI;apply replay_stores_exists.
 unfold sign_updates;witness_forall ltac:(
 cbn;first[
 eapply scalar_access_inside with(n:=84);[exact WG|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=656);[exact WS|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=48);[exact WP|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=8);[exact WI|lia|cbn;lia|witness_align]]).
Qed.
Lemma sign_updated_loads : forall base mf gh sb bp bi r,
 gh<>sb ->gh<>bp ->gh<>bi ->sb<>bp ->sb<>bi ->bp<>bi ->
 replay_stores base(sign_updates gh sb bp bi r)=Some mf ->
 Mem.load Mint16unsigned mf sb 2=Some(Vint(Int.repr 2)) /\
 Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 2)) /\
 Mem.load Mint32 mf gh 44=Some(Vint(Int.repr r)) /\
 Mem.load Mint32 mf gh 48=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf gh 52=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf gh 56=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf gh 60=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf gh 64=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf sb 100=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf sb 104=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf sb 296=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf sb 300=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bp 0=Some(Vint(Int.one)) /\
 Mem.load Mint32 mf bp 4=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bp 8=Some(Vint(Int.one)) /\
 Mem.load Mint32 mf bp 12=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bp 16=Some(Vint(Int.zero)) /\
 Mem.load Mint8unsigned mf bp 44=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bi 0=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(Int.zero)).
Proof.
 intros base mf gh sb bp bi r GS GP GI SP SI PI RUN.
 assert(CP:Mem.load Mint16unsigned mf sb 2=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=0%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.repr 2));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(CS:Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=1%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.repr 2));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(RX:Mem.load Mint32 mf gh 44=Some(Vint(Int.repr r))).
 { eapply replay_stores_value_at with(i:=2%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.repr r));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(RY:Mem.load Mint32 mf gh 48=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=3%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(SX:Mem.load Mint32 mf gh 52=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=4%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(SY:Mem.load Mint32 mf gh 56=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=5%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AX:Mem.load Mint32 mf gh 60=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=6%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AY:Mem.load Mint32 mf gh 64=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=7%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(PX:Mem.load Mint32 mf sb 100=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=8%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(PY:Mem.load Mint32 mf sb 104=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=9%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VX:Mem.load Mint32 mf sb 296=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=10%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VY:Mem.load Mint32 mf sb 300=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=11%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KP:Mem.load Mint32 mf bp 0=Some(Vint(Int.one))).
 { eapply replay_stores_value_at with(i:=12%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.one));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KD:Mem.load Mint32 mf bp 4=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=13%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KI:Mem.load Mint32 mf bp 8=Some(Vint(Int.one))).
 { eapply replay_stores_value_at with(i:=14%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.one));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KV:Mem.load Mint32 mf bp 12=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=15%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KA:Mem.load Mint32 mf bp 16=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=16%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(APP:Mem.load Mint8unsigned mf bp 44=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=17%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(IX:Mem.load Mint32 mf bi 0=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=18%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(IY:Mem.load Mint32 mf bi 4=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=19%nat)(us:=sign_updates gh sb bp bi r)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[sign_updates skipn];witness_forall ltac:(witness_miss)]. }
 repeat(first[assumption|split]).
Qed.
Theorem mirrored_inputs_exist :
 exists gh ret a b,MirroredPair gh ret a b 64.
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
 assert(PI:bp<>bi)by(eapply Genv.global_addresses_distinct;[|exact SP|exact SI];discriminate).
 assert(HP:bh<>bp)by(eapply Genv.global_addresses_distinct;[|exact SH|exact SP];discriminate).
 assert(HI:bh<>bi)by(eapply Genv.global_addresses_distinct;[|exact SH|exact SI];discriminate).
 assert(ROP:forall b gv,Genv.find_var_info E.ge b=Some gv ->gvar_readonly gv=true ->b<>bp).
 { intros b gv VAR RO EQ;subst b;rewrite VP in VAR;injection VAR as<-;discriminate. }
 assert(ROI:forall b gv,Genv.find_var_info E.ge b=Some gv ->gvar_readonly gv=true ->b<>bi).
 { intros b gv VAR RO EQ;subst b;rewrite VI in VAR;injection VAR as<-;discriminate. }
 assert(ROS:forall b gv,Genv.find_var_info E.ge b=Some gv ->gvar_readonly gv=true ->b<>sb).
 { intros b gv VAR RO EQ;subst b;rewrite VS in VAR;injection VAR as<-;discriminate. }
 assert(GOOD:forall r mf,-64<=r<=64 ->
 replay_stores base(sign_updates gh sb bp bi r)=Some mf ->MirrorInput mf gh ret r).
 { intros r mf RANGE RUN.
   destruct(sign_updated_loads base mf gh sb bp bi r GS ltac:(congruence) ltac:(congruence) ltac:(congruence) ltac:(congruence) ltac:(congruence) RUN)
   as(CP&CS&RX&RY&SX&SY&AX&AY&PX&PY&VX&VY&KP&KD&KI&KV&KA&APP&IX&IY).
   assert(RAW:raw_writes(fun _=>True)base mf).
   { eapply replay_stores_raw;[exact RUN|];unfold sign_updates;witness_forall ltac:(exact I). }
   assert(HZERO:Genv.read_as_zero mf bh 0 84).
   { eapply zero_preserved_by_disjoint_replay;[exact ZH| |exact RUN].
     unfold sign_updates;witness_forall ltac:(cbn;congruence). }
   assert(GLOBAL:global_bytes_initialized mf).
   { eapply global_contract_after_replay;[exact CONTRACT| |exact RUN].
     unfold sign_updates;witness_forall ltac:(
       cbn;first[exact ROS|exact ROP|exact ROI|intros b gv VAR RO;eapply GVAR;exact VAR]). }
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
   assert(APR:load_global Mint8unsigned mf S._guidance_pid pid_type[S._approx_force_by_thrust]=Some(Vint Int.zero)).
   { unfold load_global;rewrite SP;exact APP. }
   assert(HEAD:heading_safe mf).
   { exists Float32.zero;split.
     - unfold load_global;rewrite SH;witness_zero_path HZERO.
     - split;reflexivity. }
   assert(GAINS:forall gain,In gain[S._kp;S._kd;S._ki;S._kv;S._ka]->
     bounded_global mf S._guidance_pid pid_type[gain]0 100).
   { intros gain IN;destruct IN as[<-|[<-|[<-|[<-|[<-|[]]]]]].
     - exists Int.one;split;[unfold load_global;rewrite SP;exact KP|change(0<=1<=100);lia].
     - exists Int.zero;split;[unfold load_global;rewrite SP;exact KD|change(0<=0<=100);lia].
     - exists Int.one;split;[unfold load_global;rewrite SP;exact KI|change(0<=1<=100);lia].
     - exists Int.zero;split;[unfold load_global;rewrite SP;exact KV|change(0<=0<=100);lia].
     - exists Int.zero;split;[unfold load_global;rewrite SP;exact KA|change(0<=0<=100);lia]. }
   assert(AXES:forall axis,In axis[S._x;S._y]->
     bounded_global mf S._guidance_pid_trim_att_integrator vec_type[axis](-100000000)100000000 /\
     bounded_path mf gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
     bounded_path mf gh gh_type[S._ref;S._accel;axis](-10000)10000 /\
     bounded_global mf S._state state_type[S._ned_speed_i;axis](-10000)10000).
   { intros axis IN;destruct IN as[<-|[<-|[]]].
     - split.
       + exists Int.zero;split;[unfold load_global;rewrite SI;assumption|rewrite Int.signed_zero;lia].
       + split.
         * exists Int.zero;split;[exact SX|rewrite Int.signed_zero;lia].
         * split.
           -- exists Int.zero;split;[exact AX|rewrite Int.signed_zero;lia].
           -- exists Int.zero;split;[unfold load_global;rewrite SS;exact VX|rewrite Int.signed_zero;lia].
     - split.
       + exists Int.zero;split;[unfold load_global;rewrite SI;assumption|rewrite Int.signed_zero;lia].
       + split.
         * exists Int.zero;split;[exact SY|rewrite Int.signed_zero;lia].
         * split.
           -- exists Int.zero;split;[exact AY|rewrite Int.signed_zero;lia].
           -- exists Int.zero;split;[unfold load_global;rewrite SS;exact VY|rewrite Int.signed_zero;lia]. }
   assert(SAFE:position_subtractions_safe mf gh).
   { intros axis IN;destruct IN as[<-|[<-|[]]].
     - exists(Int.repr r),Int.zero;split;[exact RX|];split.
       + unfold load_global;rewrite SS;exact PX.
       + unfold signed32.
         rewrite(Int.signed_repr r)by(change(-2147483648<=r<=2147483647);lia).
         rewrite Int.signed_zero;lia.
     - exists Int.zero,Int.zero;split;[exact RY|];split.
       + unfold load_global;rewrite SS;exact PY.
       + unfold signed32;rewrite Int.signed_zero;lia. }
   assert(INITPOS:initialized_positions mf gh).
   { intros axis IN;destruct(SAFE axis IN)as(rv&pv&R&P&N);exists rv,pv;auto. }
   assert(GOODMEM:InputGood mf gh ret).
   { unfold InputGood;split;[unfold InputGoodLegacy;tauto|tauto]. }
   unfold MirrorInput;split;[exact GOODMEM|];split;[exact RX|];split;[exact RY|].
   split;[unfold load_global;rewrite SS;exact PX|].
   split;[unfold load_global;rewrite SS;exact PY|].
   split.
   - intros axis IN;destruct IN as[<-|[<-|[]]];repeat split;try assumption;
     unfold load_global;first[rewrite SS;assumption|rewrite SI;assumption].
   - split;[unfold load_global;rewrite SP;exact KP|].
     split;[unfold load_global;rewrite SP;exact KD|].
     split;[unfold load_global;rewrite SP;exact KI|].
     split;[unfold load_global;rewrite SP;exact KV|].
     split;[unfold load_global;rewrite SP;exact KA|].
     unfold load_global;rewrite SH;witness_zero_path HZERO. }

 destruct(sign_updates_exist base gh sb bp bi 64 WG WS WP WI)as[a RA].
 destruct(sign_updates_exist base gh sb bp bi (-64) WG WS WP WI)as[b RB].
 exists gh,ret,a,b;split;[apply GOOD;[lia|exact RA]|].
 split;[apply GOOD;[lia|exact RB]|].
 eapply compatible_replay_preserves_canonical_frame;[| |exact RA|exact RB].
 - unfold sign_updates.
   repeat(apply Forall2_cons;[apply compatible_update_same|]).
   apply Forall2_cons.
   + apply compatible_update_translated;intros i R;apply reference_position_written_bytes;exact R.
   + repeat(apply Forall2_cons;[apply compatible_update_same|]);constructor.
 - split;[reflexivity|];split;[intros;tauto|intros;reflexivity].
Qed.
Print Assumptions mirrored_inputs_exist.
