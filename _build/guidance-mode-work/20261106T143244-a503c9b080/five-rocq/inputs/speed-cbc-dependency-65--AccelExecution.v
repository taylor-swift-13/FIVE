From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceAllocation Require Import StackAllocation StackWrapper.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport StackCleanup FunctionAllocation EntryPrelimit AccelPrefix SaturationBodyAccel SaturationEntryAccel FinalCopyAccel.
From FiveGuidanceMode Require Import Spec.
Require FiveGhAccel.Source FiveGhAccel.Execution.
From FiveGuidanceAllOrder Require Import PhaseComposition ConcretePhases PhaseWiring SaturationFunctionAccel CallInstancesAccel.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhAccel.Source.
Theorem accel_entry_certificate:sqrt_call_contract ->forall s sp m bg src o,
 accel_initial s sp m bg src o ->
 exists sf mf P,
 accel_update fixed_maximum s sp=Some sf /\
 certificate ge P(Returnstate Vundef Kstop mf) /\
 P(FiveGhAccel.Execution.entry[Vptr src o]m) /\
 repr sf mf bg /\writable mf bg /\
 Mem.loadbytes mf bg 0 4=Some(encode_val Mfloat32(Vsingle(accel_x sf))) /\
 Mem.loadbytes mf bg 4 4=Some(encode_val Mfloat32(Vsingle(accel_y sf))) /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(pos_x sf))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(pos_y sf))).
Proof.
 intros CONTRACT s sp m bg src o INIT.
 destruct INIT as(REP&W&ARG&SAFE&SYM&bc&CSYM&CONST).
 destruct ARG as(LXS&LYS&RANGE&HI&BYTES).
 destruct SAFE as(dx&dy&CX&CY&NX&NY).
 destruct(prepare_vector_entry ge(fn_vars S.f_gh_update_ref_from_accel_sp)S._accel_sp vt
 m s bg bc src o(vx sp)(vy sp)eq_refl eq_refl eq_refl
 ltac:(repeat constructor;simpl;intuition discriminate)REP W CONST LXS LYS)
 as(e&ma&mb&ba&AV&BIND&LP&LX&LY&REP1&W1&C1&SEP&NONE&ALL).
 destruct(ALL S._pos_step vt ltac:(simpl;intuition congruence))as(bp&LPS&FP&PP).
 destruct(ALL S._speed_step vt ltac:(simpl;intuition congruence))as(bs&LSS&FS&PS).
 destruct(ALL S._pos_update it ltac:(simpl;intuition congruence))as(bu&LPU&FU&PU).
 destruct(ALL S._accel_sp vt ltac:(simpl;intuition congruence))as(p2&LP2&FA&PA).
 rewrite LP in LP2;injection LP2 as EQ;subst p2.
 assert(VG:Mem.valid_block m bg).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable);apply W;lia. }
 assert(VC:Mem.valid_block m bc)by(eapply loaded_valid_block;exact CONST).
 assert(DGP:bg<>bp)by(intro EQ;subst bp;apply FP;exact VG).
 assert(DGS:bg<>bs)by(intro EQ;subst bs;apply FS;exact VG).
 assert(DGU:bg<>bu)by(intro EQ;subst bu;apply FU;exact VG).
 assert(DGA:bg<>ba)by(intro EQ;subst ba;apply FA;exact VG).
 assert(DPS:bp<>bs)by(eapply environment_distinct;[exact SEP| |exact LPS|exact LSS];discriminate).
 assert(DPU:bp<>bu)by(eapply environment_distinct;[exact SEP| |exact LPS|exact LPU];discriminate).
 assert(DSU:bs<>bu)by(eapply environment_distinct;[exact SEP| |exact LSS|exact LPU];discriminate).
 assert(DAP:ba<>bp)by(eapply environment_distinct;[exact SEP| |exact LP|exact LPS];discriminate).
 assert(DAS:ba<>bs)by(eapply environment_distinct;[exact SEP| |exact LP|exact LSS];discriminate).
 assert(DAU:ba<>bu)by(eapply environment_distinct;[exact SEP| |exact LP|exact LPU];discriminate).
 assert(ENV:e!S._gh_ref=None)by(apply NONE;vm_compute;intuition discriminate).
 assert(EH:e!S._gh_saturate_accel=None)by(apply NONE;vm_compute;intuition discriminate).
 assert(LA:e!S._accel_sp=Some(ba,vt))by exact LP.
 change(Mem.range_perm mb bp 0 8 Cur Freeable)in PP.
 change(Mem.range_perm mb bs 0 8 Cur Freeable)in PS.
 change(Mem.range_perm mb bu 0 16 Cur Freeable)in PU.
 change(Mem.range_perm mb ba 0 8 Cur Freeable)in PA.
 destruct(source_integration_exec s e mb bg bp bs bu dx dy ENV SYM LPS LSS LPU
 DGP DGS DGU DPS DPU DSU REP1 W1
 (freeable_vector_access _ _ _ PP(or_introl eq_refl))(freeable_vector_access _ _ _ PP(or_intror eq_refl))
 (freeable_vector_access _ _ _ PS(or_introl eq_refl))(freeable_vector_access _ _ _ PS(or_intror eq_refl))
 (freeable_longvector_access _ _ _ PU(or_introl eq_refl))(freeable_longvector_access _ _ _ PU(or_intror eq_refl))CX CY)
 as(mr&before&mx&my&ms&CE&PATHI&RR&WR&KR&LOCAL&POSX&POSY&SPEEDX&SPEEDY).
 assert(HISTORY:stores_to(fun b=>b=bg \/b=bp \/b=bs \/b=bu)mb mr).
 { eapply stores_to_trans.
   - eapply stores_to_weaken;[|exact LOCAL];intros b H;cbn in H|-*;tauto.
   - eapply stores_to_step;[left;reflexivity|exact POSX|].
     eapply stores_to_step;[left;reflexivity|exact POSY|].
     eapply stores_to_step;[left;reflexivity|exact SPEEDX|].
     eapply stores_to_step;[left;reflexivity|exact SPEEDY|constructor]. }
 assert(RX:Mem.load Mfloat32 mr ba 0=Some(Vsingle(vx sp))).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 ba 0)by(intuition congruence);exact LX. }
 assert(RY:Mem.load Mfloat32 mr ba 4=Some(Vsingle(vy sp))).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 ba 4)by(intuition congruence);exact LY. }
 assert(BGBC:bg<>bc)by(vm_compute in SYM,CSYM;congruence).
 assert(MAXR:Mem.load Mfloat32 mr bc 0=Some(Vsingle fixed_maximum)).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 bc 0)by(intuition congruence);exact C1. }
 assert(PXBY:Mem.loadbytes mr bg 16 8=Some(encode_val Mint64(Vlong(Int64.add(pos_x s)dx)))).
 { erewrite Mem.loadbytes_store_other by(exact SPEEDY||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact SPEEDX||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact POSY||(right;right;left;cbn;lia)).
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ POSX). }
 assert(PYBY:Mem.loadbytes mr bg 24 8=Some(encode_val Mint64(Vlong(Int64.add(pos_y s)dy)))).
 { erewrite Mem.loadbytes_store_other by(exact SPEEDY||(right;right;right;cbn;lia)).
   erewrite Mem.loadbytes_store_other by(exact SPEEDX||(right;right;right;cbn;lia)).
   exact(Mem.loadbytes_store_same _ _ _ _ _ _ POSY). }
 destruct(accel_prefix_certificate e S.f_gh_update_ref_from_accel_sp mb mr CE Kstop
   (Ssequence saturation_call after_saturation))as[PPREFIX[CPREFIX IPREFIX]].
 assert(IPREFIXBODY:PPREFIX(State S.f_gh_update_ref_from_accel_sp(fn_body S.f_gh_update_ref_from_accel_sp)Kstop e mb)).
 { rewrite accel_phase_shape;exact IPREFIX. }
 clear IPREFIX;rename IPREFIXBODY into IPREFIX.
 set(si:=integrated s dx dy).
 set(raw:=sp).
 set(saturated:=saturate fixed_maximum raw).
 destruct(saturation_funcall_certificate mr ba bc raw fixed_maximum (Kcall S.f_gh_update_ref_from_accel_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop))) I CONTRACT CSYM MAXR RX RY
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_introl eq_refl)))
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_intror eq_refl))))
 as(msat&PSAT&CSAT&ISAT&SX&SY&KRS&SATFRAME&SATBYTES).
 assert(VGR:Mem.valid_block mr bg).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable);apply WR;lia. }
 assert(RS:repr si msat bg).
 { unfold repr in *;repeat match goal with H:_ /\ _|-_=>destruct H end;
   repeat split;rewrite SATFRAME by(exact VGR||exact DGA);assumption. }
 assert(WS:writable msat bg).
 { unfold writable in *;eapply range_perm_access_preserved;[exact KRS|exact WR]. }
 destruct(final_copy_exec si saturated e msat bg ba ENV SYM LA DGA RS WS SX SY)
 as(mcopy&mcopyx&COPY&RCOPY&WCOPY&KCOPY&SCOPYX&SCOPYY&AXB&AYB).
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge _ _ _ _ AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact FX. }
 assert(FREEB:forall id b ty,e!id=Some(b,ty)->Mem.range_perm mb b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge _ _ _ _ AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact PERM. }
 assert(KBODY:access_preserved mb mcopy).
 { unfold access_preserved in *;intros;apply KCOPY;apply KRS;apply KR;assumption. }
 assert(FREECOPY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm mcopy b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact KBODY|eapply FREEB;exact LOOK]. }
 destruct(free_environment ge e mcopy SEP FREECOPY)as[mf[FREE[FREEFRAME FREEACCESS]]].
 assert(OUTG:forall id ty,e!id=Some(bg,ty)->False)by(intros id ty LOOK;exact(FRESH id bg ty LOOK VG)).
 assert(RFINAL:repr(with_accel si saturated)mf bg).
 { unfold repr in *;repeat match goal with H:_ /\ _|-_=>destruct H end;
   repeat split;rewrite FREEFRAME by exact OUTG;assumption. }
 assert(WFINAL:writable mf bg).
 { unfold writable in *;eapply range_perm_access_preserved_block;[|exact W1].
   intros ch ofs p VA;apply FREEACCESS;[exact OUTG|apply KBODY;exact VA]. }
 destruct(saturation_call_certificate e mr ba S.f_gh_update_ref_from_accel_sp(Kseq after_saturation Kstop)msat PSAT EH LA CSAT ISAT)
  as[PCALL[CCALL ICALL]].
 destruct(normal_block_certificate ge S.f_gh_update_ref_from_accel_sp e Kstop msat after_saturation mcopy ltac:(reflexivity)COPY)
  as[PCOPY[CCOPY ICOPY]].
 destruct(sequence_certificate ge S.f_gh_update_ref_from_accel_sp e Kstop mr msat saturation_call after_saturation PCALL PCOPY _ CCALL ICALL CCOPY ICOPY)
  as[PTAIL[CTAIL ITAIL]].
 pose proof(join_certificate ge PPREFIX PTAIL _ _ CPREFIX CTAIL ITAIL)as CBODY.
 pose proof(cleanup_transition ge S.f_gh_update_ref_from_accel_sp Kstop e mcopy mf I FREE)as CLEAN.
 pose proof(singleton_bridge_certificate ge _ _ CLEAN)as CCLEAN.
 pose proof(join_certificate ge _ _ _ _ CBODY CCLEAN ltac:(left;reflexivity))as CFULLBODY.
 assert(DISPATCH:unique_transition ge(FiveGhAccel.Execution.entry[Vptr src o]m)
  (State S.f_gh_update_ref_from_accel_sp(fn_body S.f_gh_update_ref_from_accel_sp)Kstop e mb)).
 { unfold FiveGhAccel.Execution.entry;eapply internal_dispatch_transition;
   [repeat constructor;simpl;intuition discriminate|exact AV|exact BIND]. }
 destruct(prepend_transition ge _ _ _ _ DISPATCH CFULLBODY ltac:(left;left;exact IPREFIX))as[P[CP IP]].
 exists(with_accel si saturated),mf,P;split.
 - unfold accel_update,integrate;rewrite CX,CY;reflexivity.
 - split.
   + exact CP.
   + split;[exact IP|].
     split;[exact RFINAL|]. split;[exact WFINAL|]. split.
     * rewrite(free_environment_bytes_frame ge e mcopy mf FREE bg 0 4)by exact OUTG;exact AXB.
     * split.
       -- rewrite(free_environment_bytes_frame ge e mcopy mf FREE bg 4 4)by exact OUTG;exact AYB.
       -- split.
          ++ rewrite(free_environment_bytes_frame ge e mcopy mf FREE bg 16 8)by exact OUTG.
             erewrite Mem.loadbytes_store_other by(exact SCOPYY||(right;right;right;cbn;lia)).
             erewrite Mem.loadbytes_store_other by(exact SCOPYX||(right;right;right;cbn;lia)).
             rewrite SATBYTES by(exact VGR||exact DGA);exact PXBY.
          ++ rewrite(free_environment_bytes_frame ge e mcopy mf FREE bg 24 8)by exact OUTG.
             erewrite Mem.loadbytes_store_other by(exact SCOPYY||(right;right;right;cbn;lia)).
             erewrite Mem.loadbytes_store_other by(exact SCOPYX||(right;right;right;cbn;lia)).
             rewrite SATBYTES by(exact VGR||exact DGA);exact PYBY.
Qed.
Print Assumptions accel_entry_certificate.
