From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceAllocation Require Import StackAllocation StackWrapper.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport StackCleanup FunctionAllocation EntryPrelimit AccelPrefix SaturationBodyAccel SaturationEntryAccel FinalCopyAccel.
From FiveGuidanceMode Require Import Spec.
Require FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhAccel.Source.
Theorem accel_prelimit_exists:forall s sp m bg src o,
 accel_initial s sp m bg src o ->exists si t k mr local,
 integrate s=Some si /\
 star Csem.step ge(FiveGhAccel.Execution.entry[Vptr src o]m)t
  (Callstate(Internal S.f_gh_saturate_accel)[Vptr local Ptrofs.zero]k mr) /\
 argument_repr sp mr local Ptrofs.zero /\repr si mr bg /\
 Mem.valid_access mr Mfloat32 local 0 Writable /\Mem.valid_access mr Mfloat32 local 4 Writable /\
 Mem.range_perm mr local 0 8 Cur Writable /\
 exists bc,Genv.find_symbol ge S._gh_max_accel=Some bc /\Mem.load Mfloat32 mr bc 0=Some(Vsingle fixed_maximum).
Proof.
 intros s sp m bg src o INIT.
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
 assert(PRE:star Csem.step ge(State S.f_gh_update_ref_from_accel_sp(fn_body S.f_gh_update_ref_from_accel_sp)Kstop e mb)E0
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]
 (Kcall S.f_gh_update_ref_from_accel_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop)))mr)).
 { rewrite integration_context_shape.
   eapply star_trans with(t1:=E0)(t2:=E0);[apply PATHI| |reflexivity].
   rewrite saturation_tail_shape;apply saturation_call_original_exact_path;[exact EH|exact LA]. }
 assert(LOCALBYTES:exists bytes,Mem.loadbytes mr ba 0 8=Some bytes).
 { apply Mem.range_perm_loadbytes;intros ofs RNG.
   assert(R:Mem.range_perm mr ba 0 8 Cur Freeable).
   { eapply range_perm_access_preserved;[exact KR|exact PA]. }
   eapply Mem.perm_implies;[apply R;exact RNG|constructor]. }
 exists(integrated s dx dy),E0,
  (Kcall S.f_gh_update_ref_from_accel_sp e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop))),mr,ba.
 split;[unfold integrate;rewrite CX,CY;reflexivity|]. split.
 - eapply star_step with(t1:=E0)(t2:=E0);[|exact PRE|reflexivity].
   unfold FiveGhAccel.Execution.entry;right;eapply Csem.step_internal_function;
   [repeat constructor;simpl;intuition discriminate|exact AV|exact BIND].
 - split.
   2:{ split;[exact RR|]. split.
       - apply KR;exact(freeable_vector_access _ _ _ PA(or_introl eq_refl)).
       - split.
         + apply KR;exact(freeable_vector_access _ _ _ PA(or_intror eq_refl)).
         + split.
           * eapply Mem.range_perm_implies;[eapply range_perm_access_preserved;[exact KR|exact PA]|constructor].
           * exists bc;auto. }
   unfold argument_repr;rewrite Ptrofs.unsigned_zero;cbn.
   split;[exact RX|]. split;[exact RY|]. split;[lia|]. split;[change(8<=18446744073709551615);lia|exact LOCALBYTES].
Qed.
Print Assumptions accel_prelimit_exists.
