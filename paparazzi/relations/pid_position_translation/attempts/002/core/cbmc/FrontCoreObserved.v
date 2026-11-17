From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceAllOrder Require Import PhaseComposition BlockExecution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory.
From PidPositionSafety Require Import EntryClampObserved.
From CoreCBMC Require Import GetterCoreInstances ArithmeticObservation CoreObservationWiring EntryClampCoreObserved.
From CoreCBMC Require Import NumericBounds.
From PidPositionTranslationAttempt002 Require Import EntryPrefix SpeedEntryPrefix PrefixFields SpeedPrefixFields ClampSemantics ClampCombination FrontSemantics.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.

Lemma sequence_transition:forall ge f st tail k e m,
 unique_transition ge(State f(Ssequence st tail)k e m)(State f st(Kseq tail k)e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;auto].
 all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
Qed.
Lemma skip_sequence_transition:forall ge f tail k e m,
 unique_transition ge(State f Sskip(Kseq tail k)e m)(State f tail k e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;cbn in *;try contradiction;auto].
Qed.
Lemma singleton_certificate:forall ge target,certificate ge(fun s=>s=target)target.
Proof. intros;split;[intros;auto|intros s t next EQ NE;contradiction]. Qed.

Lemma prepend_transition:forall ge initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 exists Q,certificate ge Q target /\Q initial.
Proof.
 intros ge initial middle P target TRANS CERT PI.
 exists(fun s=>s=initial \/P s);split;[|auto].
 eapply chain_certificate with(P:=fun s=>s=initial)(middle:=initial)(initial:=middle);
 [apply singleton_certificate|exact CERT|exact TRANS|exact PI].
Qed.
Lemma normal_statement_path:forall ge e m st mf,
 Cstrategy.exec_stmt ge e m st E0 mf Out_normal ->forall f,
 star Csem.step ge(State f st Kstop e m)E0(State f Sskip Kstop e mf).
Proof.
 intros ge e m st mf EV f.
 destruct(Cstrategy.exec_stmt_to_steps ge e m st E0 mf Out_normal EV f Kstop)as[reached[PATH END]].
 inversion END;subst;apply strategy_star_csem;exact PATH.
Qed.

Lemma normal_block_certificate:forall ge f e k m st mf,
 block_stmt st=true ->Cstrategy.exec_stmt ge e m st E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f st k e m).
Proof.
 intros ge f e k m st mf SYN EXEC.
 exists(block_context_invariant ge k f e mf);split.
 - split;[apply block_context_progress|apply block_context_all_successors].
 - eapply block_context_entry;[exact SYN|eapply normal_statement_path;exact EXEC].
Qed.
Lemma sequence_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 exists R,certificate ge R target /\R(State f(Ssequence first second)k e m).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI.
 pose proof(chain_certificate ge P Q _ _ target CP CQ
 (skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_transition;[apply sequence_transition|exact JOIN|left;exact PI].
Qed.

Lemma target_certificate:forall ge target,
 certificate ge(fun s=>s=target)target.
Proof. intros;split;[intros s EQ;left;exact EQ|intros s t next EQ NE STEP;contradiction]. Qed.
Theorem original_position_pair_core_observed : forall e m bg gh pb sb rx ry px py flags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_pos_err=None ->e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 bg<>pb ->gh<>pb ->sb<>pb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) ->
 Mem.load Mint32 m sb 100=Some(Vint px) ->Mem.load Mint32 m sb 104=Some(Vint py) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 NumericBounds.signed32(Int.signed rx-Int.signed px) ->NumericBounds.signed32(Int.signed ry-Int.signed py) ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 exists mf,
 (forall k,exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos position_assign_pair k e m)/\
 (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s)) /\
 Mem.load Mint32 mf pb 0=Some(Vint(Int.sub rx px)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(Int.sub ry py)) /\
 raw_writes(fun b=>b=pb)m mf.
Proof.
 intros e m bg gh pb sb rx ry px py flags ENV LOCAL GET SYM STATE DBG DGH DS PTR RX RY PX PY CACHE VALID SAFEX SAFEY WRITE.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m Mint32 pb 0(Vint(Int.sub rx px))A0)as[m1 ST0].
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m1 Mint32 pb 4(Vint(Int.sub ry py))A4)as[mf ST4].
 assert(PTR1:Mem.load Mint64 m1 bg 0=Some(Vptr gh Ptrofs.zero)).
 { erewrite Mem.load_store_other;[exact PTR|exact ST0|left;exact DBG]. }
 assert(RY1:Mem.load Mint32 m1 gh 48=Some(Vint ry)).
 { erewrite Mem.load_store_other;[exact RY|exact ST0|left;exact DGH]. }
 assert(PY1:Mem.load Mint32 m1 sb 104=Some(Vint py)).
 { erewrite Mem.load_store_other;[exact PY|exact ST0|left;exact DS]. }
 assert(CACHE1:Mem.load Mint16unsigned m1 sb 2=Some(Vint flags)).
 { erewrite Mem.load_store_other;[exact CACHE|exact ST0|left;exact DS]. }
 exists mf;split.
 - intro k.
   destruct(original_position_x_store_core_observed_certificate e m m1 bg gh pb sb rx px flags
    (Kseq(original_position_assignment S._y)k) ENV LOCAL GET SYM STATE PTR RX PX CACHE VALID SAFEX ST0)
    as[P[CP[PI OP]]].
   destruct(original_position_y_store_core_observed_certificate e m1 mf bg gh pb sb ry py flags k
    ENV LOCAL GET SYM STATE PTR1 RY1 PY1 CACHE1 VALID SAFEY ST4)as[Q[CQ[QI OQ]]].
   unfold position_assign_pair;eapply sequence_core_observed_certificate;[exact CP|exact PI|exact CQ|exact QI|exact OP|exact OQ].
 - split.
   + rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia).
     rewrite(Mem.load_store_same Mint32 m pb 0(Vint(Int.sub rx px))m1 ST0);reflexivity.
   + split.
     * rewrite(Mem.load_store_same Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4);reflexivity.
     * eapply raw_writes_store;[reflexivity|exact ST0|].
       eapply raw_writes_store;[reflexivity|exact ST4|constructor].
Qed.

Theorem original_speed_pair_core_observed : forall e m bg gh pb sb rx ry px py flags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_speed_err=None ->e!S._stateGetSpeedNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some pb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 bg<>pb ->gh<>pb ->sb<>pb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint ry) ->
 Mem.load Mint32 m sb 296=Some(Vint px) ->Mem.load Mint32 m sb 300=Some(Vint py) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 NumericBounds.signed32(Int.signed rx-Int.signed px) ->NumericBounds.signed32(Int.signed ry-Int.signed py) ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 exists mf,
 (forall k,exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos speed_assign_pair k e m)/\
 (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s)) /\
 Mem.load Mint32 mf pb 0=Some(Vint(Int.sub rx px)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(Int.sub ry py)) /\
 raw_writes(fun b=>b=pb)m mf.
Proof.
 intros e m bg gh pb sb rx ry px py flags ENV LOCAL GET SYM STATE DBG DGH DS PTR RX RY PX PY CACHE VALID SAFEX SAFEY WRITE.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m Mint32 pb 0(Vint(Int.sub rx px))A0)as[m1 ST0].
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m1 Mint32 pb 4(Vint(Int.sub ry py))A4)as[mf ST4].
 assert(PTR1:Mem.load Mint64 m1 bg 0=Some(Vptr gh Ptrofs.zero)).
 { erewrite Mem.load_store_other;[exact PTR|exact ST0|left;exact DBG]. }
 assert(RY1:Mem.load Mint32 m1 gh 56=Some(Vint ry)).
 { erewrite Mem.load_store_other;[exact RY|exact ST0|left;exact DGH]. }
 assert(PY1:Mem.load Mint32 m1 sb 300=Some(Vint py)).
 { erewrite Mem.load_store_other;[exact PY|exact ST0|left;exact DS]. }
 assert(CACHE1:Mem.load Mint16unsigned m1 sb 280=Some(Vint flags)).
 { erewrite Mem.load_store_other;[exact CACHE|exact ST0|left;exact DS]. }
 exists mf;split.
 - intro k.
   destruct(original_speed_x_store_core_observed_certificate e m m1 bg gh pb sb rx px flags
    (Kseq(original_speed_assignment S._y)k) ENV LOCAL GET SYM STATE PTR RX PX CACHE VALID SAFEX ST0)
    as[P[CP[PI OP]]].
   destruct(original_speed_y_store_core_observed_certificate e m1 mf bg gh pb sb ry py flags k
    ENV LOCAL GET SYM STATE PTR1 RY1 PY1 CACHE1 VALID SAFEY ST4)as[Q[CQ[QI OQ]]].
   unfold speed_assign_pair;eapply sequence_core_observed_certificate;[exact CP|exact PI|exact CQ|exact QI|exact OP|exact OQ].
 - split.
   + rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia).
     rewrite(Mem.load_store_same Mint32 m pb 0(Vint(Int.sub rx px))m1 ST0);reflexivity.
   + split.
     * rewrite(Mem.load_store_same Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4);reflexivity.
     * eapply raw_writes_store;[reflexivity|exact ST0|].
       eapply raw_writes_store;[reflexivity|exact ST4|constructor].
Qed.
Theorem original_front_core_observed : forall e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags,
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
 NumericBounds.signed32(Int.signed rx-Int.signed px) ->NumericBounds.signed32(Int.signed ry-Int.signed py) ->
 NumericBounds.signed32(Int.signed sx-Int.signed vx) ->NumericBounds.signed32(Int.signed sy-Int.signed vy) ->
 Mem.range_perm m pb 0 8 Cur Writable ->Mem.range_perm m vb 0 8 Cur Writable ->
 exists mf,
 (forall k,exists P,
 certificate E.ge P(State S.f_guidance_pid_h_run_pos after_front k e mf) /\
 P(State S.f_guidance_pid_h_run_pos(fn_body S.f_guidance_pid_h_run_pos)k e m)/\
 (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s)) /\
 Mem.load Mint32 mf pb 0=Some(Vint(clamp_bits(Int.sub rx px)(Int.repr 4096))) /\
 Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits(Int.sub ry py)(Int.repr 4096))) /\
 Mem.load Mint32 mf vb 0=Some(Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608))) /\
 Mem.load Mint32 mf vb 4=Some(Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608))) /\
 raw_writes(fun b=>b=pb\/b=vb)m mf.
Proof.
 intros e m bg gh pb vb sb rx ry px py sx sy vx vy flags sflags
 ENV LP LV GP GV SP SV STATE ND PTR RX RY SX SY PX PY VX VY CACHE SCACHE VALID SVALID SAFEPX SAFEPY SAFESX SAFESY WP WV.
 assert(DIST:bg<>pb /\ gh<>pb /\ sb<>pb /\ bg<>vb /\ gh<>vb /\ sb<>vb /\ pb<>vb).
 { repeat rewrite NoDup_cons_iff in ND;cbn in ND;intuition congruence. }
 destruct DIST as[DBG[DGH[DS[DVBG[DVGH[DVS DPV]]]]]].
 destruct(original_position_pair_core_observed e m bg gh pb sb rx ry px py flags
 ENV LP GP SP STATE DBG DGH DS PTR RX RY PX PY CACHE VALID SAFEPX SAFEPY WP)as[m1[POS[X1[Y1 W1]]]].
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
 destruct(original_speed_pair_core_observed e m2 bg gh vb sb sx sy vx vy sflags
 ENV LV GV SV STATE DVBG DVGH DVS PTR2 SX2 SY2 VX2 VY2 SC2 SVALID SAFESX SAFESY
 ltac:(eapply raw_writes_range;[exact WPOS|exact WV]))as[m3[SPD[VX3[VY3 W3]]]].
 destruct(original_two_global_clamps e m3 S._guidance_pid_speed_err vb(Int.sub sx vx)(Int.sub sy vy)19(Int.repr 8388608)
 LV SV VX3 VY3 ltac:(eapply raw_writes_range;[exact W3|];eapply raw_writes_range;[exact WPOS|exact WV])
 source_bound_19 speed_bound_neg)as[mf[SCL[VX4[VY4 W4]]]].
 assert(WSPD:raw_writes(fun b=>b=vb)m2 mf)by(eapply raw_writes_trans;eauto).
 exists mf;split.
 - intro k;rewrite original_front_ast.
   set(tD:=Ssequence speed_clamp_pair after_front).
   set(tC:=Ssequence speed_assign_pair tD).
   set(tB:=Ssequence position_clamp_pair tC).
   destruct(entry_clamp_pair_core_observed_from_normal E.ge S.f_guidance_pid_h_run_pos e(Kseq after_front k)
     m3 mf S._guidance_pid_speed_err 19 ltac:(right;reflexivity)SCL)as[PD[CD[ID OD]]].
   destruct(sequence_core_observed_certificate E.ge S.f_guidance_pid_h_run_pos e k m3 mf
     speed_clamp_pair after_front PD(fun s=>s=State S.f_guidance_pid_h_run_pos after_front k e mf)
     (State S.f_guidance_pid_h_run_pos after_front k e mf)
     CD ID(target_certificate _ _)eq_refl OD ltac:(intros s EQ;cbn in EQ;subst s;exact I))as[QD[CQD[IQD OQD]]].
   destruct(SPD(Kseq tD k))as[PC[CC[IC OC]]].
   destruct(sequence_core_observed_certificate E.ge S.f_guidance_pid_h_run_pos e k m2 m3 speed_assign_pair tD
    PC QD _ CC IC CQD IQD OC OQD)as[QC[CQC[IQC OQC]]].
   destruct(entry_clamp_pair_core_observed_from_normal E.ge S.f_guidance_pid_h_run_pos e(Kseq tC k)
     m1 m2 S._guidance_pid_pos_err 8 ltac:(left;reflexivity)PCL)as[PB[CB[IB OB]]].
   destruct(sequence_core_observed_certificate E.ge S.f_guidance_pid_h_run_pos e k m1 m2 position_clamp_pair tC
    PB QC _ CB IB CQC IQC OB OQC)as[QB[CQB[IQB OQB]]].
   destruct(POS(Kseq tB k))as[PA[CA[IA OA]]].
   eapply sequence_core_observed_certificate;[exact CA|exact IA|exact CQB|exact IQB|exact OA|exact OQB].
 - split.
   + rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 0)by(congruence);exact X2.
   + split.
     * rewrite(raw_writes_load_frame _ _ _ WSPD Mint32 pb 4)by(congruence);exact Y2.
     * split;[exact VX4|]. split;[exact VY4|].
       eapply raw_writes_trans.
       -- eapply front_writes_weaken with(P:=fun b=>b=pb);[intros;left;assumption|exact WPOS].
       -- eapply front_writes_weaken with(P:=fun b=>b=vb);[intros;right;assumption|exact WSPD].
Qed.

Print Assumptions original_position_pair_core_observed.
Print Assumptions original_speed_pair_core_observed.
Print Assumptions original_front_core_observed.
