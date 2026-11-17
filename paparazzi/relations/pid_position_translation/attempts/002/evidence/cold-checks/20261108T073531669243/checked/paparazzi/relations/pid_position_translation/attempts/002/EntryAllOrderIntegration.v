From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionSafety Require Import FactoryCall.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From PidPositionTranslationCore Require Import FrontAllOrder.
From PidPositionTranslationAttempt002 Require Import EntryAllocation InputSemantics FrontSemantics ClampSemantics EntryIntegration.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Local Opaque E.ge.

Lemma entry_allocation_deterministic:forall ge env m vars e1 ma1 e2 ma2,
 alloc_variables ge env m vars e1 ma1 ->alloc_variables ge env m vars e2 ma2 ->
 e1=e2 /\ ma1=ma2.
Proof.
 intros ge env m vars e1 ma1 e2 ma2 A1 A2.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A1)as D1.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma entry_parameters_deterministic:forall ge e m params args mf1 mf2,
 bind_parameters ge e m params args mf1 ->bind_parameters ge e m params args mf2 ->mf1=mf2.
Proof.
 intros ge e m params args mf1 mf2 B1 B2.
 pose proof(Cexec.sem_bind_parameters_complete ge Execution.quiet_world e m params args mf1 B1)as D1.
 pose proof(Cexec.sem_bind_parameters_complete ge Execution.quiet_world e m params args mf2 B2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma entry_internal_dispatch_transition:forall ge f args m e ma mb k,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma ->
 bind_parameters ge e ma(fn_params f)args mb ->
 unique_transition ge(Callstate(Internal f)args k m)(State f(fn_body f)k e mb).
Proof.
 intros ge f args m e ma mb k NAMES ALLOC BIND;split.
 - right;eapply step_internal_function;[exact NAMES|exact ALLOC|exact BIND].
 - intros t next[ES|SS];[inversion ES|].
   inversion SS;subst;split;[reflexivity|].
   match goal with A:alloc_variables ge empty_env m(fn_params f++fn_vars f)?ee ?mx
    |-State _ _ _ ?ee _=_ =>
     destruct(entry_allocation_deterministic ge empty_env m _ e ma ee mx ALLOC A)as[EE MM];subst ee mx end.
   match goal with B:bind_parameters ge e ma(fn_params f)args ?mx |-State _ _ _ _ ?mx=_=>
    pose proof(entry_parameters_deterministic ge e ma(fn_params f)args mb mx BIND B)as EQ;subst mx;reflexivity end.
Qed.

Theorem inputgood_entry_front_all_orders : forall m gh ret flight,
 InputGood m gh ret ->
 exists e mf pb vb sb rx ry px py sx sy vx vy br bf bg bs,
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb /\
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some vb /\
 Genv.find_symbol E.ge S._state=Some sb /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) /\
 Mem.load Mint32 m sb 100=Some(Vint px) /\Mem.load Mint32 m sb 104=Some(Vint py) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy) /\
 Mem.load Mint32 m sb 296=Some(Vint vx) /\Mem.load Mint32 m sb 300=Some(Vint vy) /\
 (exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos after_front Kstop e mf) /\
 P(E.entry(call_args gh ret flight)m)) /\
 Mem.load Mint32 mf pb 0=Some(Vint(clamp_bits(Int.sub rx px)(Int.repr 4096))) /\
 Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits(Int.sub ry py)(Int.repr 4096))) /\
 Mem.load Mint32 mf vb 0=Some(Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608))) /\
 Mem.load Mint32 mf vb 4=Some(Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608))) /\
 e!S.__res=Some(br,tptr sp_type) /\e!S._in_flight=Some(bf,tbool) /\
 e!S._gh=Some(bg,tptr gh_type) /\e!S.__res__1=Some(bs,sp_type) /\
 Mem.load Mint64 mf br 0=Some(Vptr ret Ptrofs.zero) /\
 Mem.load Mint64 mf bg 0=Some(Vptr gh Ptrofs.zero) /\
 Mem.load Mbool mf bf 0=Some(Vint(if flight then Int.one else Int.zero)) /\
 env_separated e /\
 (forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b) /\
 (forall id b ty,e!id=Some(b,ty)->Mem.range_perm mf b 0(sizeof E.ge ty)Cur Freeable) /\
 (forall ch b ofs v,Mem.load ch m b ofs=Some v ->b<>pb ->b<>vb ->Mem.load ch mf b ofs=Some v) /\
 (forall b ofs k p,Mem.perm m b ofs k p ->Mem.perm mf b ofs k p) /\
 (forall id,~In id(map fst entry_declarations)->e!id=None).
Proof.
 intros m gh ret flight GOOD.
 destruct(original_entry_setup m gh ret flight)as[SETUP _].
 destruct SETUP as[e ma mb br bf bg bs AL BIND LR LF LG LS SEP FRESH FREE RPTR GPTR FVAL OLDLOAD OLDPERM OLDBYTES].
 assert(WR:writable_controller_globals m).
 { destruct GOOD as[G _];unfold InputGoodLegacy in G;tauto. }
 destruct(WR S._guidance_pid_pos_err ltac:(cbn;auto))as[pb[pgv[SP[PV PWRITE]]]].
 destruct(WR S._guidance_pid_speed_err ltac:(cbn;auto))as[vb[vgv[SV[VV VWRITE]]]].
 destruct actual_state_symbol as[sb STATE].
 destruct(inputgood_cached_flags m gh ret sb GOOD STATE)as[flags[sflags[POSC[SPDC[VALID SVALID]]]]].
 destruct(inputgood_position_values m gh ret sb GOOD STATE)as[rx[ry[px[py[RX[RY[PX PY]]]]]]].
 destruct(inputgood_speed_values m gh ret sb GOOD STATE)as[sx[sy[vx[vy[SX[SY[VX VY]]]]]]].
 assert(WP:Mem.range_perm m pb 0 8 Cur Writable)
 by(exact(inputgood_error_global_writable m gh ret S._guidance_pid_pos_err pb GOOD ltac:(cbn;auto)SP)).
 assert(WV:Mem.range_perm m vb 0 8 Cur Writable)
 by(exact(inputgood_error_global_writable m gh ret S._guidance_pid_speed_err vb GOOD ltac:(cbn;auto)SV)).
 assert(VPB:Mem.valid_block m pb)by(exact(range_block m pb 0 8 Writable ltac:(lia)WP)).
 assert(VVB:Mem.valid_block m vb)by(exact(range_block m vb 0 8 Writable ltac:(lia)WV)).
 assert(VSB:Mem.valid_block m sb)by(eapply loaded_block;exact POSC).
 assert(VGH:Mem.valid_block m gh).
 { eapply loaded_block with(ch:=Mint32)(o:=44)(v:=Vint rx);exact RX. }
 assert(NBG:~Mem.valid_block m bg)by(eapply FRESH;exact LG).
 assert(DPGH:gh<>pb)by(eapply inputgood_guidance_separate;[exact GOOD|exact SP|discriminate]).
 assert(DVGH:gh<>vb)by(eapply inputgood_guidance_separate;[exact GOOD|exact SV|discriminate]).
 assert(DSGH:gh<>sb)by(eapply inputgood_guidance_separate;[exact GOOD|exact STATE|discriminate]).
 assert(DPV:pb<>vb)by(eapply Genv.global_addresses_distinct with(id1:=S._guidance_pid_pos_err)(id2:=S._guidance_pid_speed_err);[|exact SP|exact SV];discriminate).
 assert(DPS:pb<>sb)by(eapply Genv.global_addresses_distinct with(id1:=S._guidance_pid_pos_err)(id2:=S._state);[|exact SP|exact STATE];discriminate).
 assert(DVS:vb<>sb)by(eapply Genv.global_addresses_distinct with(id1:=S._guidance_pid_speed_err)(id2:=S._state);[|exact SV|exact STATE];discriminate).
 assert(ND:NoDup[bg;gh;pb;vb;sb]).
 { repeat constructor;cbn in *;intuition congruence. }
 assert(UNSH:forall id,~In id(map fst entry_declarations)->e!id=None)
 by(intros;eapply entry_environment_unshadowed;eauto).
 assert(LP:e!S._guidance_pid_pos_err=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 assert(LV:e!S._guidance_pid_speed_err=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 assert(GP:e!S._stateGetPositionNed_i=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 assert(GV:e!S._stateGetSpeedNed_i=None)by(apply UNSH;unfold entry_declarations;cbn;intuition discriminate).
 assert(RXB:load_path Mint32 mb gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx)).
 { change(Mem.load Mint32 mb gh 44=Some(Vint rx));apply OLDLOAD;exact RX. }
 assert(RYB:load_path Mint32 mb gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry)).
 { change(Mem.load Mint32 mb gh 48=Some(Vint ry));apply OLDLOAD;exact RY. }
 assert(SXB:load_path Mint32 mb gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx)).
 { change(Mem.load Mint32 mb gh 52=Some(Vint sx));apply OLDLOAD;exact SX. }
 assert(SYB:load_path Mint32 mb gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy)).
 { change(Mem.load Mint32 mb gh 56=Some(Vint sy));apply OLDLOAD;exact SY. }
 destruct(FrontAllOrder.original_front_all_orders e mb bg gh pb vb sb rx ry px py sx sy vx vy flags sflags
 LG LP LV GP GV SP SV STATE ND GPTR RXB RYB SXB SYB
 ltac:(apply OLDLOAD;exact PX)ltac:(apply OLDLOAD;exact PY)
 ltac:(apply OLDLOAD;exact VX)ltac:(apply OLDLOAD;exact VY)
 ltac:(apply OLDLOAD;exact POSC)ltac:(apply OLDLOAD;exact SPDC)
 VALID SVALID ltac:(unfold Mem.range_perm;intros ofs R;apply OLDPERM;apply WP;exact R)ltac:(unfold Mem.range_perm;intros ofs R;apply OLDPERM;apply WV;exact R))
 as[mf[PATH[EX[EY[EVX[EVY WRITE]]]]]].
 assert(LOCALOUT:forall id b ty,e!id=Some(b,ty)->~(b=pb\/b=vb)).
 { intros id b ty LOOK[EQ|EQ];subst b;apply(FRESH id _ ty LOOK);assumption. }
 exists e,mf,pb,vb,sb,rx,ry,px,py,sx,sy,vx,vy,br,bf,bg,bs.
 repeat split;try assumption.
 - destruct(PATH Kstop)as[P[CP PI]].
   eapply FrontAllOrder.prepend_transition;[|exact CP|exact PI].
   eapply entry_internal_dispatch_transition;[repeat constructor;cbn;intuition discriminate|exact AL|exact BIND].
 - rewrite(raw_writes_load_frame _ _ _ WRITE Mint64 br 0)by(eapply LOCALOUT;exact LR);exact RPTR.
 - rewrite(raw_writes_load_frame _ _ _ WRITE Mint64 bg 0)by(eapply LOCALOUT;exact LG);exact GPTR.
 - rewrite(raw_writes_load_frame _ _ _ WRITE Mbool bf 0)by(eapply LOCALOUT;exact LF);exact FVAL.
 - intros;apply(raw_writes_range _ _ _ WRITE);eapply FREE;eauto.
 - intros ch b ofs v LOAD DP DV.
   rewrite(raw_writes_load_frame _ _ _ WRITE ch b ofs)by(tauto);apply OLDLOAD;exact LOAD.
 - intros b ofs k p PERM;apply(proj1(raw_writes_perm _ _ _ WRITE b ofs k p));apply OLDPERM;exact PERM.
Qed.
Print Assumptions inputgood_entry_front_all_orders.
