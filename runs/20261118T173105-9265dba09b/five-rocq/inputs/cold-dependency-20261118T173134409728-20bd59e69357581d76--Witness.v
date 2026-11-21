From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
From PidPositionSafety Require Import PidTermination FactoryCall.
From PidPositionTranslationAttempt002 Require Import Nonvacuity InputSemantics ReadOnlySemantics WitnessBase WitnessMemory WitnessUpdates ByteAgreement.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.
Local Transparent Float32.of_int Float32.cmp Float32.compare.
Ltac witness_zero_path ZERO :=
 lazymatch goal with |-load_path ?ch ?mm ?bb ?ty ?path=Some ?v=>
 let info:=eval vm_compute in(path_info ty path)in
 lazymatch info with Some(_,?ofs)=>
 change(Mem.load ch mm bb ofs=Some v);apply(ZERO ch ofs);[lia|cbn;lia|witness_align]
 end end.

Definition PrivateBlocks(gh ret:block):Prop:=
 forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>gh /\b<>ret.
Local Transparent PidTermination.ge PidTermination.ast_prog.
Theorem private_witness_base :
 exists base gh ret bp be bv bi bh sb,
 global_bytes_initialized base /\gh<>ret /\
 (forall id,Genv.find_symbol E.ge id<>Some gh) /\
 (forall id,Genv.find_symbol E.ge id<>Some ret) /\
 (forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>gh) /\
 (forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>ret) /\
 Mem.range_perm base gh 0 84 Cur Writable /\Mem.range_perm base ret 0 36 Cur Writable /\
 Genv.find_symbol E.ge S._guidance_pid=Some bp /\Genv.find_var_info E.ge bp=Some S.v_guidance_pid /\
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some be /\Genv.find_var_info E.ge be=Some S.v_guidance_pid_pos_err /\
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some bv /\Genv.find_var_info E.ge bv=Some S.v_guidance_pid_speed_err /\
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some bi /\Genv.find_var_info E.ge bi=Some S.v_guidance_pid_trim_att_integrator /\
 Genv.find_symbol E.ge S._guidance_h=Some bh /\
 Genv.find_symbol E.ge S._state=Some sb /\Genv.find_var_info E.ge sb=Some S.v_state /\
 Mem.range_perm base bp 0 48 Cur Writable /\Mem.range_perm base be 0 8 Cur Writable /\
 Mem.range_perm base bv 0 8 Cur Writable /\Mem.range_perm base bi 0 8 Cur Writable /\
 Mem.range_perm base sb 0 656 Cur Writable /\
 Genv.read_as_zero base bp 0 48 /\Genv.read_as_zero base bi 0 8 /\
 Genv.read_as_zero base bh 0 84 /\Genv.read_as_zero base sb 0 656.
Proof.
 destruct original_initial_memory_exists as[init INIT].
 destruct(actual_global_variable_binding S._guidance_pid S.v_guidance_pid ltac:(vm_compute;reflexivity))as[bp[SP VP]].
 destruct(actual_global_variable_binding S._guidance_pid_pos_err S.v_guidance_pid_pos_err ltac:(vm_compute;reflexivity))as[be[SE VE]].
 destruct(actual_global_variable_binding S._guidance_pid_speed_err S.v_guidance_pid_speed_err ltac:(vm_compute;reflexivity))as[bv[SV VV]].
 destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
 destruct(actual_global_variable_binding S._guidance_h S.v_guidance_h ltac:(vm_compute;reflexivity))as[bh[SH VH]].
 destruct(actual_global_variable_binding S._state S.v_state ltac:(vm_compute;reflexivity))as[sb[SS VS]].
 assert(VALIDV:forall b gv,Genv.find_var_info E.ge b=Some gv ->Mem.valid_block init b).
 { intros b gv VAR;rewrite ReadOnlySemantics.original_global_environment in VAR.
   eapply Genv.find_var_info_not_fresh;[exact INIT|exact VAR]. }
 assert(VALIDS:forall id b,Genv.find_symbol E.ge id=Some b ->Mem.valid_block init b).
 { intros id b SYM;rewrite ReadOnlySemantics.original_global_environment in SYM.
   eapply Genv.find_symbol_not_fresh;[exact INIT|exact SYM]. }
 destruct(Mem.alloc init 0 84)as[m1 gh]eqn:AG.
 destruct(Mem.alloc m1 0 36)as[base ret]eqn:AR.
 assert(FGH:~Mem.valid_block init gh)by(eapply Mem.fresh_block_alloc;exact AG).
 assert(FRET:~Mem.valid_block m1 ret)by(eapply Mem.fresh_block_alloc;exact AR).
 assert(GHR:gh<>ret).
 { intro EQ;subst ret;apply FRET;eapply Mem.valid_new_block;exact AG. }
 assert(GSYM:forall id,Genv.find_symbol E.ge id<>Some gh).
 { intros id SYM;apply FGH;apply VALIDS with(id:=id);exact SYM. }
 assert(RSYM:forall id,Genv.find_symbol E.ge id<>Some ret).
 { intros id SYM;apply FRET;eapply Mem.valid_block_alloc;[exact AG|apply VALIDS with(id:=id);exact SYM]. }
 assert(GVAR:forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>gh).
 { intros b gv VAR EQ;subst b;apply FGH;apply VALIDV with(gv:=gv);exact VAR. }
 assert(GVARRET:forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>ret).
 { intros b gv VAR EQ;subst b;apply FRET;eapply Mem.valid_block_alloc;[exact AG|apply VALIDV with(gv:=gv);exact VAR]. }
 assert(CONTRACT:global_bytes_initialized base).
 { eapply global_contract_after_allocation;[| |exact AR].
   - eapply global_contract_after_allocation;[apply original_initial_memory_has_global_contract;exact INIT|exact VALIDV|exact AG].
   - intros b gv VAR;eapply Mem.valid_block_alloc;[exact AG|apply VALIDV with(gv:=gv);exact VAR]. }
 assert(WGH:Mem.range_perm base gh 0 84 Cur Writable).
 { intros ofs R;eapply Mem.perm_alloc_1;[exact AR|].
   eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AG|exact R]|constructor]. }
 assert(WRET:Mem.range_perm base ret 0 36 Cur Writable).
 { intros ofs R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AR|exact R]|constructor]. }
 assert(OLDPERM:forall b ofs k p,Mem.perm init b ofs k p ->Mem.perm base b ofs k p).
 { intros;eapply Mem.perm_alloc_1;[exact AR|];eapply Mem.perm_alloc_1;[exact AG|exact H]. }
 assert(OLDLOAD:forall ch b ofs,Mem.valid_block init b ->Mem.load ch base b ofs=Mem.load ch init b ofs).
 { intros ch b ofs VB;transitivity(Mem.load ch m1 b ofs).
   - eapply Mem.load_alloc_unchanged;[exact AR|eapply Mem.valid_block_alloc;[exact AG|exact VB]].
   - eapply Mem.load_alloc_unchanged;[exact AG|exact VB]. }
 assert(ZP:Genv.read_as_zero base bp 0 48).
 { pose proof(initialized_space_global_zero init bp S.v_guidance_pid 48 INIT VP eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_pid);exact VP);apply Z;assumption. }
 assert(ZI:Genv.read_as_zero base bi 0 8).
 { pose proof(initialized_space_global_zero init bi S.v_guidance_pid_trim_att_integrator 8 INIT VI eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_pid_trim_att_integrator);exact VI);apply Z;assumption. }
 assert(ZH:Genv.read_as_zero base bh 0 84).
 { pose proof(initialized_space_global_zero init bh S.v_guidance_h 84 INIT VH eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_h);exact VH);apply Z;assumption. }
 assert(ZS:Genv.read_as_zero base sb 0 656).
 { pose proof(initialized_space_global_zero init sb S.v_state 656 INIT VS eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_state);exact VS);apply Z;assumption. }
 exists base,gh,ret,bp,be,bv,bi,bh,sb.
 repeat(first[assumption|split]).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bp S.v_guidance_pid 48 INIT VP eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init be S.v_guidance_pid_pos_err 8 INIT VE eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bv S.v_guidance_pid_speed_err 8 INIT VV eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bi S.v_guidance_pid_trim_att_integrator 8 INIT VI eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init sb S.v_state 656 INIT VS eq_refl eq_refl eq_refl ltac:(lia)ofs R).
Qed.
Definition SymbolicInitial (m:mem)(gh ret:block)(r kp ki:Z):Prop:=
 InputGood m gh ret /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint(Int.repr r)) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_pos_i;S._x]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_pos_i;S._y]=Some(Vint Int.zero) /\
 (forall axis,In axis[S._x;S._y]->
  load_path Mint32 m gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
  load_path Mint32 m gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
  load_global Mint32 m S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero) /\
  load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint Int.zero)) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kp]=Some(Vint(Int.repr kp)) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kd]=Some(Vint Int.zero) /\
 load_global Mint32 m S._guidance_pid pid_type[S._ki]=Some(Vint(Int.repr ki)) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kv]=Some(Vint Int.zero) /\
 load_global Mint32 m S._guidance_pid pid_type[S._ka]=Some(Vint Int.zero) /\
 load_global Mfloat32 m S._guidance_h gh_type[S._sp;S._heading]=Some(Vsingle Float32.zero).

Definition symbolic_updates(gh sb bp bi:block)(r kp ki:Z):list scalar_update:=[
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
 (Mint32,bp,0,Vint(Int.repr kp));
 (Mint32,bp,4,Vint(Int.zero));
 (Mint32,bp,8,Vint(Int.repr ki));
 (Mint32,bp,12,Vint(Int.zero));
 (Mint32,bp,16,Vint(Int.zero));
 (Mint8unsigned,bp,44,Vint(Int.zero));
 (Mint32,bi,0,Vint(Int.zero));
 (Mint32,bi,4,Vint(Int.zero))].
Lemma symbolic_updates_exist : forall base gh sb bp bi r kp ki,
 Mem.range_perm base gh 0 84 Cur Writable ->
 Mem.range_perm base sb 0 656 Cur Writable ->
 Mem.range_perm base bp 0 48 Cur Writable ->
 Mem.range_perm base bi 0 8 Cur Writable ->
 exists mf,replay_stores base(symbolic_updates gh sb bp bi r kp ki)=Some mf.
Proof.
 intros base gh sb bp bi r kp ki WG WS WP WI;apply replay_stores_exists.
 unfold symbolic_updates;witness_forall ltac:(
 cbn;first[
 eapply scalar_access_inside with(n:=84);[exact WG|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=656);[exact WS|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=48);[exact WP|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=8);[exact WI|lia|cbn;lia|witness_align]]).
Qed.
Lemma symbolic_updated_loads : forall base mf gh sb bp bi r kp ki,
 gh<>sb ->gh<>bp ->gh<>bi ->sb<>bp ->sb<>bi ->bp<>bi ->
 replay_stores base(symbolic_updates gh sb bp bi r kp ki)=Some mf ->
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
 Mem.load Mint32 mf bp 0=Some(Vint(Int.repr kp)) /\
 Mem.load Mint32 mf bp 4=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bp 8=Some(Vint(Int.repr ki)) /\
 Mem.load Mint32 mf bp 12=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bp 16=Some(Vint(Int.zero)) /\
 Mem.load Mint8unsigned mf bp 44=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bi 0=Some(Vint(Int.zero)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(Int.zero)).
Proof.
 intros base mf gh sb bp bi r kp ki GS GP GI SP SI PI RUN.
 assert(CP:Mem.load Mint16unsigned mf sb 2=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=0%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.repr 2));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(CS:Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=1%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.repr 2));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(RX:Mem.load Mint32 mf gh 44=Some(Vint(Int.repr r))).
 { eapply replay_stores_value_at with(i:=2%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.repr r));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(RY:Mem.load Mint32 mf gh 48=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=3%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(SX:Mem.load Mint32 mf gh 52=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=4%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(SY:Mem.load Mint32 mf gh 56=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=5%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AX:Mem.load Mint32 mf gh 60=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=6%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AY:Mem.load Mint32 mf gh 64=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=7%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(PX:Mem.load Mint32 mf sb 100=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=8%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(PY:Mem.load Mint32 mf sb 104=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=9%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VX:Mem.load Mint32 mf sb 296=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=10%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VY:Mem.load Mint32 mf sb 300=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=11%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KP:Mem.load Mint32 mf bp 0=Some(Vint(Int.repr kp))).
 { eapply replay_stores_value_at with(i:=12%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.repr kp));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KD:Mem.load Mint32 mf bp 4=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=13%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KI:Mem.load Mint32 mf bp 8=Some(Vint(Int.repr ki))).
 { eapply replay_stores_value_at with(i:=14%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.repr ki));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KV:Mem.load Mint32 mf bp 12=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=15%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(KA:Mem.load Mint32 mf bp 16=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=16%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(APP:Mem.load Mint8unsigned mf bp 44=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=17%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(IX:Mem.load Mint32 mf bi 0=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=18%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(IY:Mem.load Mint32 mf bi 4=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=19%nat)(us:=symbolic_updates gh sb bp bi r kp ki)(m:=base)(v:=Vint(Int.zero));
 [reflexivity|exact RUN|cbn[symbolic_updates skipn];witness_forall ltac:(witness_miss)]. }
 repeat(first[assumption|split]).
Qed.
Theorem symbolic_initial_private_writable_exists : forall A kp ki,
 0<=A<=4096 ->0<=kp<=100 ->0<=ki<=100 ->
 exists gh ret m,SymbolicInitial m gh ret A kp ki /\Mem.range_perm m gh 0 84 Cur Writable /\PrivateBlocks gh ret.
Proof.
 intros A kp ki AR KPR KIR.
 destruct private_witness_base as(base&gh&ret&bp&be&bv&bi&bh&sb&
 CONTRACT&GHR&GSYM&RSYM&GVAR&GVARRET&WG&WR&SP&VP&SE&VE&SV&VV&SI&VI&SH&SS&VS&
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
 assert(GOOD:forall r mf,-4096<=r<=4096 ->
 replay_stores base(symbolic_updates gh sb bp bi r kp ki)=Some mf ->SymbolicInitial mf gh ret r kp ki).
 { intros r mf RANGE RUN.
   destruct(symbolic_updated_loads base mf gh sb bp bi r kp ki GS ltac:(congruence) ltac:(congruence) ltac:(congruence) ltac:(congruence) ltac:(congruence) RUN)
   as(CP&CS&RX&RY&SX&SY&AX&AY&PX&PY&VX&VY&KP&KD&KI&KV&KA&APP&IX&IY).
   assert(RAW:raw_writes(fun _=>True)base mf).
   { eapply replay_stores_raw;[exact RUN|];unfold symbolic_updates;witness_forall ltac:(exact I). }
   assert(HZERO:Genv.read_as_zero mf bh 0 84).
   { eapply zero_preserved_by_disjoint_replay;[exact ZH| |exact RUN].
     unfold symbolic_updates;witness_forall ltac:(cbn;congruence). }
   assert(GLOBAL:global_bytes_initialized mf).
   { eapply global_contract_after_replay;[exact CONTRACT| |exact RUN].
     unfold symbolic_updates;witness_forall ltac:(
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
     - exists(Int.repr kp);split;[unfold load_global;rewrite SP;exact KP|rewrite Int.signed_repr;[exact KPR|change(-2147483648<=kp<=2147483647);lia]].
     - exists Int.zero;split;[unfold load_global;rewrite SP;exact KD|change(0<=0<=100);lia].
     - exists(Int.repr ki);split;[unfold load_global;rewrite SP;exact KI|rewrite Int.signed_repr;[exact KIR|change(-2147483648<=ki<=2147483647);lia]].
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
   unfold SymbolicInitial;split;[exact GOODMEM|];split;[exact RX|];split;[exact RY|].
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

 destruct(symbolic_updates_exist base gh sb bp bi A kp ki WG WS WP WI)as[m RUN].
 exists gh,ret,m;split;[apply GOOD;[lia|exact RUN]|].
 split.
 - assert(RAW:raw_writes(fun _=>True)base m).
   { eapply replay_stores_raw;[exact RUN|];unfold symbolic_updates;witness_forall ltac:(exact I). }
   intros z R;apply(proj1(raw_writes_perm _ _ _ RAW gh z Cur Writable));apply WG;exact R.
 - intros b gv VAR;split;[exact(GVAR b gv VAR)|].
   exact(GVARRET b gv VAR).
Qed.
Print Assumptions symbolic_initial_private_writable_exists.

From PidAlternatingProblem Require Import Spec.
Lemma symbolic_to_alternating : forall m gh ret A kp ki,
 SymbolicInitial m gh ret A kp ki ->AlternatingInput m gh ret A kp ki Int.zero.
Proof.
 intros m gh ret A kp ki(GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD).
 assert(AXES0:forall axis,In axis[S._x;S._y] ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
 load_path Mint32 m gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero)).
 { intros axis IN;destruct(AXES axis IN)as(SPEED&ACCEL&VEL&INT);auto. }
 pose proof(proj2(proj2(proj2(AXES S._x ltac:(cbn;auto)))))as IX.
 pose proof(proj2(proj2(proj2(AXES S._y ltac:(cbn;auto)))))as IY.
 unfold AlternatingInput,integral_load;repeat(first[assumption|split]).
Qed.
Theorem initial_private_writable_input_exists : forall A kp ki,Parameters A kp ki ->
 exists gh ret m,AlternatingInput m gh ret A kp ki Int.zero /\
 Mem.range_perm m gh 0 84 Cur Writable /\PrivateBlocks gh ret.
Proof.
 intros A kp ki(AR&KPR&KIR).
 destruct(symbolic_initial_private_writable_exists A kp ki AR KPR KIR)as(gh&ret&m&INPUT&WG&PRIVATE).
 exists gh,ret,m;split;[apply symbolic_to_alternating;exact INPUT|split;assumption].
Qed.
Theorem initial_input_exists : InitialExistenceGoal.
Proof.
 intros A kp ki PARAM;destruct(initial_private_writable_input_exists A kp ki PARAM)as(gh&ret&m&INPUT&WG&PRIVATE);eauto.
Qed.
Print Assumptions initial_private_writable_input_exists.
Print Assumptions initial_input_exists.
