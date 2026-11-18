From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceAllocation Require Import StackAllocation StackWrapper.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport SymbolicPrefix SaturationBody SaturationEntry StackCleanup FunctionAllocation EntryPrelimit PrelimitExact FinalCopy.
From FiveGuidanceMode Require Import Spec.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Theorem speed_entry_normal:sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->
 exists sf mf,
 speed_update fixed_maximum s sp=Some sf /\
 star Csem.step ge(FiveGhSpeed.Execution.entry[Vptr src o]m)E0(Returnstate Vundef Kstop mf) /\
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
 destruct(prepare_vector_entry ge(fn_vars S.f_gh_update_ref_from_speed_sp)S._speed_sp vt
 m s bg bc src o(vx sp)(vy sp)eq_refl eq_refl eq_refl
 ltac:(repeat constructor;simpl;intuition discriminate)REP W CONST LXS LYS)
 as(e&ma&mb&param&AV&BIND&LP&LX&LY&REP1&W1&C1&SEP&NONE&ALL).
 destruct(ALL S._pos_step vt ltac:(simpl;intuition congruence))as(bp&LPS&FP&PP).
 destruct(ALL S._speed_step vt ltac:(simpl;intuition congruence))as(bs&LSS&FS&PS).
 destruct(ALL S._pos_update it ltac:(simpl;intuition congruence))as(bu&LPU&FU&PU).
 destruct(ALL S._speed_err vt ltac:(simpl;intuition congruence))as(be&LE&FE&PE).
 destruct(ALL S._accel_sp vt ltac:(simpl;intuition congruence))as(ba&LA&FA&PA).
 destruct(ALL S._speed_sp vt ltac:(simpl;intuition congruence))as(p2&LP2&FPARAM&PPARAM).
 rewrite LP in LP2;injection LP2 as EQ;subst p2.
 assert(VG:Mem.valid_block m bg).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable);apply W;lia. }
 assert(DGP:bg<>bp)by(intro EQ;subst bp;apply FP;exact VG).
 assert(DGS:bg<>bs)by(intro EQ;subst bs;apply FS;exact VG).
 assert(DGU:bg<>bu)by(intro EQ;subst bu;apply FU;exact VG).
 assert(DGE:bg<>be)by(intro EQ;subst be;apply FE;exact VG).
 assert(DGA:bg<>ba)by(intro EQ;subst ba;apply FA;exact VG).
 assert(DPG:param<>bg)by(intro EQ;subst param;apply FPARAM;exact VG).
 assert(DPS:bp<>bs)by(eapply separated_blocks;[exact SEP| |exact LPS|exact LSS];discriminate).
 assert(DPU:bp<>bu)by(eapply separated_blocks;[exact SEP| |exact LPS|exact LPU];discriminate).
 assert(DSU:bs<>bu)by(eapply separated_blocks;[exact SEP| |exact LSS|exact LPU];discriminate).
 assert(DPP:param<>bp)by(eapply separated_blocks;[exact SEP| |exact LP|exact LPS];discriminate).
 assert(DPSP:param<>bs)by(eapply separated_blocks;[exact SEP| |exact LP|exact LSS];discriminate).
 assert(DPUA:param<>bu)by(eapply separated_blocks;[exact SEP| |exact LP|exact LPU];discriminate).
 assert(DPE:param<>be)by(eapply separated_blocks;[exact SEP| |exact LP|exact LE];discriminate).
 assert(DPA:param<>ba)by(eapply separated_blocks;[exact SEP| |exact LP|exact LA];discriminate).
 assert(DEA:be<>ba)by(eapply separated_blocks;[exact SEP| |exact LE|exact LA];discriminate).
 assert(ENV:e!S._gh_ref=None)by(apply NONE;vm_compute;intuition discriminate).
 assert(EH:e!S._gh_saturate_accel=None)by(apply NONE;vm_compute;intuition discriminate).
 change(Mem.range_perm mb bp 0 8 Cur Freeable)in PP.
 change(Mem.range_perm mb bs 0 8 Cur Freeable)in PS.
 change(Mem.range_perm mb bu 0 16 Cur Freeable)in PU.
 change(Mem.range_perm mb be 0 8 Cur Freeable)in PE.
 change(Mem.range_perm mb ba 0 8 Cur Freeable)in PA.
 destruct(body_prelimit_exact s sp e mb bg param bp bs bu be ba dx dy ENV SYM EH LP LPS LSS LPU LE LA
 DGP DGS DGU DPS DPU DSU DPG DPP DPSP DPUA DGE DGA DPE DPA DEA REP1 W1 LX LY
 (freeable_vector_access _ _ _ PP(or_introl eq_refl))(freeable_vector_access _ _ _ PP(or_intror eq_refl))
 (freeable_vector_access _ _ _ PS(or_introl eq_refl))(freeable_vector_access _ _ _ PS(or_intror eq_refl))
 (freeable_longvector_access _ _ _ PU(or_introl eq_refl))(freeable_longvector_access _ _ _ PU(or_intror eq_refl))
 (freeable_vector_access _ _ _ PE(or_introl eq_refl))(freeable_vector_access _ _ _ PE(or_intror eq_refl))
 (freeable_vector_access _ _ _ PA(or_introl eq_refl))(freeable_vector_access _ _ _ PA(or_intror eq_refl))CX CY)
 as(mr&PRE&RR&WR&KR&RX&RY&RB&HISTORY&PXBY&PYBY).
 assert(VC:Mem.valid_block m bc)by(eapply loaded_valid_block;exact CONST).
 assert(BGBC:bg<>bc)by(vm_compute in SYM,CSYM;congruence).
 assert(MAXR:Mem.load Mfloat32 mr bc 0=Some(Vsingle fixed_maximum)).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 bc 0)by(intuition congruence);exact C1. }
 set(si:=integrated s dx dy).
 set(raw:=raw_speed_accel si sp).
 set(saturated:=saturate fixed_maximum raw).
 destruct(saturation_funcall_normal mr ba bc raw fixed_maximum CONTRACT CSYM MAXR RX RY
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_introl eq_refl)))
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_intror eq_refl))))
 as(msat&SAT&SX&SY&KRS&SATFRAME&SATBYTES).
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
 assert(SATPATH:star Csem.step ge
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]
 (Kcall S.f_gh_update_ref_from_speed_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop)))mr)E0
 (Returnstate Vundef(Kcall S.f_gh_update_ref_from_speed_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop)))msat)).
 { apply strategy_star_csem;eapply Cstrategy.eval_funcall_to_steps;[exact SAT|exact I]. }
 exists(with_accel si saturated),mf;split.
 - unfold speed_update,integrate;rewrite CX,CY;reflexivity.
 - split.
   + eapply star_step with(t1:=E0)(t2:=E0);[| |reflexivity].
     * unfold FiveGhSpeed.Execution.entry;right;eapply Csem.step_internal_function;
       [repeat constructor;simpl;intuition discriminate|exact AV|exact BIND].
     * eapply star_trans with(t1:=E0)(t2:=E0);[exact PRE| |reflexivity].
       eapply star_trans with(t1:=E0)(t2:=E0);[exact SATPATH| |reflexivity].
       eapply star_trans with(t1:=E0)(t2:=E0);[apply saturation_return_to_copy| |reflexivity].
       eapply star_trans with(t1:=E0)(t2:=E0);[eapply copy_path;exact COPY| |reflexivity].
       apply star_one;right;eapply Csem.step_skip_call;[exact I|exact FREE].
   + split;[exact RFINAL|]. split;[exact WFINAL|]. split.
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
Print Assumptions speed_entry_normal.
