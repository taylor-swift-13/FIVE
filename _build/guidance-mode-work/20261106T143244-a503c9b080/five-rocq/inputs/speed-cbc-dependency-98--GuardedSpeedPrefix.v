From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport SymbolicPrefix.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
From FiveGuidanceAllOrder Require Import PhaseComposition ConcretePhases.
From FiveGuidanceCbmcAdapters Require Import CallScope GuardedPhases.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Theorem body_prelimit_guard_certificate :forall (leaf:function)(norm:float32)(branch:bool) s sp e m bg param bp bs bu be ba dx dy,
 e!S._gh_ref=None ->Genv.find_symbol ge S._gh_ref=Some bg ->e!S._gh_saturate_accel=None ->
 e!S._speed_sp=Some(param,vt) ->e!S._pos_step=Some(bp,vt) ->e!S._speed_step=Some(bs,vt) ->
 e!S._pos_update=Some(bu,it) ->e!S._speed_err=Some(be,vt) ->e!S._accel_sp=Some(ba,vt) ->
 bg<>bp ->bg<>bs ->bg<>bu ->bp<>bs ->bp<>bu ->bs<>bu ->
 param<>bg ->param<>bp ->param<>bs ->param<>bu ->
 bg<>be ->bg<>ba ->param<>be ->param<>ba ->be<>ba ->
 repr s m bg ->writable m bg ->
 Mem.load Mfloat32 m param 0=Some(Vsingle(vx sp)) ->Mem.load Mfloat32 m param 4=Some(Vsingle(vy sp)) ->
 Mem.valid_access m Mfloat32 bp 0 Writable ->Mem.valid_access m Mfloat32 bp 4 Writable ->
 Mem.valid_access m Mfloat32 bs 0 Writable ->Mem.valid_access m Mfloat32 bs 4 Writable ->
 Mem.valid_access m Mint64 bu 0 Writable ->Mem.valid_access m Mint64 bu 8 Writable ->
 Mem.valid_access m Mfloat32 be 0 Writable ->Mem.valid_access m Mfloat32 be 4 Writable ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 pos_increment(speed_x s)(dt s)=Some dx ->pos_increment(speed_y s)(dt s)=Some dy ->
 exists mf P,
 certificate ge P(State S.f_gh_update_ref_from_speed_sp(Ssequence saturation_call after_saturation)Kstop e mf) /\
 P(State S.f_gh_update_ref_from_speed_sp(fn_body S.f_gh_update_ref_from_speed_sp)Kstop e m) /\
 repr(integrated s dx dy)mf bg /\writable mf bg /\access_preserved m mf /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(raw_speed_accel(integrated s dx dy)sp))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(raw_speed_accel(integrated s dx dy)sp))) /\
 (exists bytes,Mem.loadbytes mf ba 0 8=Some bytes) /\
 stores_to(fun b=>b=bg \/b=bp \/b=bs \/b=bu \/b=be \/b=ba)m mf /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(Int64.add(pos_x s)dx))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(Int64.add(pos_y s)dy))) /\
 (forall reached,P reached->helper_call_ok leaf norm branch reached).
Proof.
 intros leaf norm branch s sp e m bg param bp bs bu be ba dx dy ENV SYM EH LP LPS LSS LPU LE LA
 DGP DGS DGU DPS DPU DSU DPG DPP DPSP DPUA DGE DGA DPE DPA DEA
 REP W LX LY AP0 AP4 AS0 AS4 AU0 AU8 AE0 AE4 AA0 AA4 CX CY.
 destruct(source_integration_exec s e m bg bp bs bu dx dy ENV SYM LPS LSS LPU
 DGP DGS DGU DPS DPU DSU REP W AP0 AP4 AS0 AS4 AU0 AU8 CX CY)
 as[mi[before[mx[my[ms[CE[PATHI[RI[WI[AI[LOCAL[SX[SY[SSX SSY]]]]]]]]]]]]]].
 assert(HISTORY:stores_to(fun b=>b=bg \/b=bp \/b=bs \/b=bu)m mi).
 { eapply stores_to_trans.
   - eapply stores_to_weaken;[|exact LOCAL];intros b H;cbn in H |- *;tauto.
   - eapply stores_to_step;[left;reflexivity|exact SX|].
     eapply stores_to_step;[left;reflexivity|exact SY|].
     eapply stores_to_step;[left;reflexivity|exact SSX|].
     eapply stores_to_step;[left;reflexivity|exact SSY|constructor]. }
 assert(LXI:Mem.load Mfloat32 mi param 0=Some(Vsingle(vx sp))).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 param 0)by(intuition congruence);exact LX. }
 assert(LYI:Mem.load Mfloat32 mi param 4=Some(Vsingle(vy sp))).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 param 4)by(intuition congruence);exact LY. }
 destruct(source_raw_accel_exec (integrated s dx dy)sp e mi bg param be ba ENV SYM LP LE LA
 DGE DGA DPE DPA DEA RI WI LXI LYI (AI _ _ _ _ AE0)(AI _ _ _ _ AE4)(AI _ _ _ _ AA0)(AI _ _ _ _ AA4))
 as[mf[CR[PATHR[RF[WF[AR[RAW[AX[AY BYTES]]]]]]]]].
 assert(ALLHISTORY:stores_to(fun b=>b=bg \/b=bp \/b=bs \/b=bu \/b=be \/b=ba)m mf).
 { eapply stores_to_trans.
   - eapply stores_to_weaken;[|exact HISTORY];intros b H;cbn in H |- *;tauto.
   - eapply stores_to_weaken;[|exact RAW];intros b H;cbn in H |- *;tauto. }
 assert(POSXBYTES:Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(Int64.add(pos_x s)dx)))).
 { rewrite(stores_to_bytes_frame _ _ _ RAW bg 16 8)by(intuition congruence).
   erewrite Mem.loadbytes_store_other by(exact SSY||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact SSX||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact SY||(right;right;left;cbn;lia)).
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ SX). }
 assert(POSYBYTES:Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(Int64.add(pos_y s)dy)))).
 { rewrite(stores_to_bytes_frame _ _ _ RAW bg 24 8)by(intuition congruence).
   erewrite Mem.loadbytes_store_other by(exact SSY||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact SSX||(right;right;right;cbn;lia)).
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ SY). }
 destruct(guarded_speed_prefix_certificate e S.f_gh_update_ref_from_speed_sp m mi mf CE CR leaf norm branch Kstop
  (Ssequence saturation_call after_saturation))as[P[CP[IP GP]]].
 exists mf,P;split;[exact CP|]. split;[rewrite speed_phase_shape;exact IP|].
 split;[exact RF|]. split;[exact WF|]. split.
   + unfold access_preserved in *;intros;eauto.
   + split;[exact AX|]. split;[exact AY|]. split;[exact BYTES|].
     split;[exact ALLHISTORY|]. split;[exact POSXBYTES|]. split;[exact POSYBYTES|]. exact GP.
Qed.
Print Assumptions body_prelimit_guard_certificate.
