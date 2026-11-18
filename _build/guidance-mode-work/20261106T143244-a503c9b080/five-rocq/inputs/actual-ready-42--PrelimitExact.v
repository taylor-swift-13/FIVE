From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport SymbolicPrefix.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Lemma saturation_call_original_exact_path:forall e m ba f k tail,
 e!S._gh_saturate_accel=None ->e!S._accel_sp=Some(ba,vt) ->
 star Csem.step ge(State f(Ssequence saturation_call tail)k e m)E0
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall f e(fun x=>x)tvoid(Kdo(Kseq tail k)))m).
Proof.
 intros e m ba f k tail EH LA.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_seq| |reflexivity].
 unfold saturation_call.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_do_1| |reflexivity].
 apply plus_star;apply Cstrategy.step_simulation;left.
 change(Cstrategy.estep ge
 (ExprState f((fun x=>x)(Ecall
 (Evalof(Evar S._gh_saturate_accel saturation_function_type)saturation_function_type)
 (Econs(Eaddrof(Evar S._accel_sp vt)(tptr vt))Enil)tvoid))(Kdo(Kseq tail k))e m)
 E0(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]
 (Kcall f e(fun x=>x)tvoid(Kdo(Kseq tail k)))m)).
 eapply Cstrategy.step_call with(vf:=Vptr saturation_block Ptrofs.zero).
 - constructor.
 - reflexivity.
 - eapply Cstrategy.esr_rvalof.
   + eapply Cstrategy.esl_var_global;[exact EH|exact saturation_symbol].
   + reflexivity.
   + reflexivity.
   + apply deref_loc_reference;reflexivity.
 - econstructor.
   + eapply Cstrategy.esr_addrof;apply Cstrategy.esl_var_local;exact LA.
   + reflexivity.
   + constructor.
 - exact saturation_funct.
 - reflexivity.
Qed.
Lemma body_prelimit_exact :forall s sp e m bg param bp bs bu be ba dx dy,
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
 exists mf,
 star Csem.step ge(State S.f_gh_update_ref_from_speed_sp(fn_body S.f_gh_update_ref_from_speed_sp)Kstop e m)E0
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall S.f_gh_update_ref_from_speed_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop)))mf) /\
 repr(integrated s dx dy)mf bg /\writable mf bg /\access_preserved m mf /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(raw_speed_accel(integrated s dx dy)sp))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(raw_speed_accel(integrated s dx dy)sp))) /\
 (exists bytes,Mem.loadbytes mf ba 0 8=Some bytes) /\
 stores_to(fun b=>b=bg \/b=bp \/b=bs \/b=bu \/b=be \/b=ba)m mf /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(Int64.add(pos_x s)dx))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(Int64.add(pos_y s)dy))).
Proof.
 intros s sp e m bg param bp bs bu be ba dx dy ENV SYM EH LP LPS LSS LPU LE LA
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
 pose proof(saturation_call_original_exact_path e mf ba S.f_gh_update_ref_from_speed_sp Kstop after_saturation EH LA)as CALL.
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
 exists mf;split.
 - rewrite integration_context_shape.
   eapply star_trans with(t1:=E0)(t2:=E0);[apply PATHI| |reflexivity].
   rewrite raw_context_shape.
   eapply star_trans with(t1:=E0)(t2:=E0);[apply PATHR| |reflexivity].
   rewrite saturation_tail_shape;exact CALL.
 - split;[exact RF|]. split;[exact WF|]. split.
   + unfold access_preserved in *;intros;eauto.
   + repeat split;assumption.
Qed.
Print Assumptions body_prelimit_exact.
