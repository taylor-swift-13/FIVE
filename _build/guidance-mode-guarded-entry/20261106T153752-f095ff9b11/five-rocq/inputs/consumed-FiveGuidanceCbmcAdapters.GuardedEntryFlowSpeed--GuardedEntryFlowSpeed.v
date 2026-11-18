From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceAllocation Require Import StackAllocation StackWrapper.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport SymbolicPrefix SaturationBody SaturationEntry StackCleanup FunctionAllocation EntryPrelimit PrelimitExact FinalCopy.
From FiveGuidanceMode Require Import Spec.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
From FiveGuidanceAllOrder Require Import PhaseComposition ConcretePhases PhaseWiring SaturationFunction CallInstances SpeedPrefixPhases.
From FiveGuidanceCbmcAdapters Require Import CallScope SaturationCallScope GuardedPhases GuardedSpeedPrefix.
From FiveGuidanceSoftwareProof Require Import FunctionEntry.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Definition raw_for_speed(s:state)(sp:vector):vector:=match integrate s with Some si=>raw_speed_accel si sp|None=>vec fzero fzero end.
Theorem guarded_speed_entry_certificate:sqrt_call_contract ->forall s sp m bg src o,
 speed_initial s sp m bg src o ->
 exists sf mf P,
 speed_update fixed_maximum s sp=Some sf /\
 certificate ge P(Returnstate Vundef Kstop mf) /\
 P(FiveGhSpeed.Execution.entry[Vptr src o]m) /\
 repr sf mf bg /\writable mf bg /\
 Mem.loadbytes mf bg 0 4=Some(encode_val Mfloat32(Vsingle(accel_x sf))) /\
 Mem.loadbytes mf bg 4 4=Some(encode_val Mfloat32(Vsingle(accel_y sf))) /\
 Mem.loadbytes mf bg 16 8=Some(encode_val Mint64(Vlong(pos_x sf))) /\
 Mem.loadbytes mf bg 24 8=Some(encode_val Mint64(Vlong(pos_y sf))) /\
 (forall reached,P reached->helper_call_ok S.f_five_sqrtf(norm2(raw_for_speed s sp))
 (saturation_branch fixed_maximum(raw_for_speed s sp))reached).
Proof.
 intros CONTRACT s sp m bg src o INIT.
 destruct INIT as(REP&W&ARG&SAFE&SYM&bc&CSYM&CONST).
 destruct ARG as(LXS&LYS&RANGE&HI&BYTES).
 destruct SAFE as(dx&dy&CX&CY&NX&NY).
 set(si:=integrated s dx dy).
 set(raw:=raw_speed_accel si sp).
 set(saturated:=saturate fixed_maximum raw).
 assert(RAW_MATCH:raw_for_speed s sp=raw)by(unfold raw_for_speed,integrate;rewrite CX,CY;reflexivity).
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
 destruct(body_prelimit_guard_certificate S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw)s sp e mb bg param bp bs bu be ba dx dy ENV SYM EH LP LPS LSS LPU LE LA
 DGP DGS DGU DPS DPU DSU DPG DPP DPSP DPUA DGE DGA DPE DPA DEA REP1 W1 LX LY
 (freeable_vector_access _ _ _ PP(or_introl eq_refl))(freeable_vector_access _ _ _ PP(or_intror eq_refl))
 (freeable_vector_access _ _ _ PS(or_introl eq_refl))(freeable_vector_access _ _ _ PS(or_intror eq_refl))
 (freeable_longvector_access _ _ _ PU(or_introl eq_refl))(freeable_longvector_access _ _ _ PU(or_intror eq_refl))
 (freeable_vector_access _ _ _ PE(or_introl eq_refl))(freeable_vector_access _ _ _ PE(or_intror eq_refl))
 (freeable_vector_access _ _ _ PA(or_introl eq_refl))(freeable_vector_access _ _ _ PA(or_intror eq_refl))CX CY)
 as(mr&PPREFIX&CPREFIX&IPREFIX&RR&WR&KR&RX&RY&RB&HISTORY&PXBY&PYBY&SAFE_PREFIX).
 assert(VC:Mem.valid_block m bc)by(eapply loaded_valid_block;exact CONST).
 assert(BGBC:bg<>bc)by(vm_compute in SYM,CSYM;congruence).
 assert(MAXR:Mem.load Mfloat32 mr bc 0=Some(Vsingle fixed_maximum)).
 { rewrite(stores_to_load_frame _ _ _ HISTORY Mfloat32 bc 0)by(intuition congruence);exact C1. }
 destruct(SaturationCallScope.Speed.saturation_funcall_guard_certificate mr ba bc raw fixed_maximum (Kcall S.f_gh_update_ref_from_speed_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop))) I CONTRACT CSYM MAXR RX RY
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_introl eq_refl)))
 (KR _ _ _ _(freeable_vector_access _ _ _ PA(or_intror eq_refl))))
 as(msat&PSAT&CSAT&ISAT&SAFE_SAT&SX&SY&KRS&SATFRAME&SATBYTES).
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
 destruct(guarded_speed_saturation_call_certificate e mr ba S.f_gh_update_ref_from_speed_sp(Kseq after_saturation Kstop)msat PSAT(norm2 raw)(saturation_branch fixed_maximum raw)EH LA CSAT ISAT SAFE_SAT)
  as[PCALL[CCALL[ICALL SAFE_CALL]]].
 destruct(guarded_normal_block_certificate ge S.f_gh_update_ref_from_speed_sp e Kstop msat after_saturation mcopy S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw)ltac:(reflexivity)COPY)
  as[PCOPY[CCOPY[ICOPY SAFE_COPY]]].
 destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw))S.f_gh_update_ref_from_speed_sp e Kstop mr msat saturation_call after_saturation PCALL PCOPY _ CCALL ICALL CCOPY ICOPY SAFE_CALL SAFE_COPY ltac:(apply state_call_ok))
  as[PTAIL[CTAIL[ITAIL SAFE_TAIL]]].
 pose proof(join_certificate ge PPREFIX PTAIL _ _ CPREFIX CTAIL ITAIL)as CBODY.
 pose proof(cleanup_transition ge S.f_gh_update_ref_from_speed_sp Kstop e mcopy mf I FREE)as CLEAN.
 pose proof(singleton_bridge_certificate ge _ _ CLEAN)as CCLEAN.
 pose proof(join_certificate ge _ _ _ _ CBODY CCLEAN ltac:(left;reflexivity))as CFULLBODY.
 assert(DISPATCH:unique_transition ge(FiveGhSpeed.Execution.entry[Vptr src o]m)
  (State S.f_gh_update_ref_from_speed_sp(fn_body S.f_gh_update_ref_from_speed_sp)Kstop e mb)).
 { unfold FiveGhSpeed.Execution.entry;eapply internal_dispatch_transition;
   [repeat constructor;simpl;intuition discriminate|exact AV|exact BIND]. }
 assert(ROOTSAFE:helper_call_ok S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw)(FiveGhSpeed.Execution.entry[Vptr src o]m)).
 { intros args kk mm EQ;unfold FiveGhSpeed.Execution.entry in EQ;assert(EF:S.f_gh_update_ref_from_speed_sp=S.f_five_sqrtf)by congruence.
   assert(ET:tvoid=tfloat)by exact(f_equal fn_return EF);discriminate. }
 assert(SAFEFULL:forall reached,((PPREFIX reached\/PTAIL reached)\/
 (reached=State S.f_gh_update_ref_from_speed_sp Sskip Kstop e mcopy\/reached=Returnstate Vundef Kstop mf))->
 helper_call_ok S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw)reached).
 { intros reached[[PRE|TAIL]|[EQ|EQ]];[apply SAFE_PREFIX;exact PRE|apply SAFE_TAIL;exact TAIL|subst reached;apply state_call_ok|subst reached;apply return_call_ok]. }
 destruct(guarded_prepend ge(helper_call_ok S.f_five_sqrtf(norm2 raw)(saturation_branch fixed_maximum raw))
 _ _ _ _ DISPATCH CFULLBODY ltac:(left;left;exact IPREFIX)ROOTSAFE SAFEFULL)as[P[CP[IP SAFE_FINAL]]].
 assert(GUARDS:forall reached,P reached->helper_call_ok S.f_five_sqrtf(norm2(raw_for_speed s sp))(saturation_branch fixed_maximum(raw_for_speed s sp))reached).
 { rewrite RAW_MATCH;exact SAFE_FINAL. }
 exists(with_accel si saturated),mf,P;split.
 - unfold speed_update,integrate;rewrite CX,CY;reflexivity.
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
          ++ split.
             ** rewrite(free_environment_bytes_frame ge e mcopy mf FREE bg 24 8)by exact OUTG.
                erewrite Mem.loadbytes_store_other by(exact SCOPYY||(right;right;right;cbn;lia)).
                erewrite Mem.loadbytes_store_other by(exact SCOPYX||(right;right;right;cbn;lia)).
                rewrite SATBYTES by(exact VGR||exact DGA);exact PYBY.
             ** exact GUARDS.
Qed.
Print Assumptions guarded_speed_entry_certificate.

Definition actual_sqrt_contract:sqrt_call_contract:=speed_helper_funcall.
Theorem speed_all_helper_calls:forall s sp m bg src o,
 speed_initial s sp m bg src o->forall t args kc mc,
 star Csem.step ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t(Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch fixed_maximum(raw_for_speed s sp)=true /\args=[Vsingle(norm2(raw_for_speed s sp))].
Proof.
 intros s sp m bg src o INIT t args kc mc PATH.
 destruct(guarded_speed_entry_certificate actual_sqrt_contract s sp m bg src o INIT)
 as(sf&mf&P&UP&CERT&PI&REP&W&BY0&BY4&BY16&BY24&SAFE).
 assert(STOP:nostep Csem.step ge(Returnstate Vundef Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 pose proof(certificate_reachable ge P(Returnstate Vundef Kstop mf)_ CERT PI STOP t _ PATH)as INV.
 exact(SAFE _ INV args kc mc eq_refl).
Qed.
Print Assumptions speed_all_helper_calls.
