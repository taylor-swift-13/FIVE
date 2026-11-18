From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
Import ListNotations.
Open Scope Z_scope.
Module F:=FactorySemantics.
Module S:=PidPositionRunPos.Source.
Local Notation ge:=F.ge.
Lemma loaded_block:forall ch m b o v,Mem.load ch m b o=Some v -> Mem.valid_block m b.
Proof.
 intros;apply Mem.valid_access_valid_block with(chunk:=ch)(ofs:=o).
 eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;eassumption|constructor].
Qed.
Lemma range_block:forall m b lo hi p,lo<hi ->
 Mem.range_perm m b lo hi Cur p ->Mem.valid_block m b.
Proof. intros m b lo hi p LT RP;apply(Mem.perm_valid_block m b lo Cur p);apply RP;lia. Qed.
Lemma environment_distinct:forall e id1 id2 b1 b2 t1 t2,
 env_separated e ->id1<>id2 ->e!id1=Some(b1,t1) ->e!id2=Some(b2,t2) ->b1<>b2.
Proof. intros e id1 id2 b1 b2 t1 t2 SEP D L1 L2 EQ;subst b2;apply D;eapply SEP;eauto. Qed.
Lemma zero_freeable_access:forall m ch b,
 Mem.range_perm m b 0(size_chunk ch)Cur Freeable ->Mem.valid_access m ch b 0 Writable.
Proof.
 intros;apply Mem.valid_access_freeable_any;split;[exact H|exists 0;lia].
Qed.
Lemma raw_writes_access:forall P m mf,raw_writes P m mf ->access_preserved m mf.
Proof.
 intros P m mf W ch b o p[RP AL];split;[|exact AL].
 intros x X;apply(proj1(raw_writes_perm P m mf W b x Cur p));apply RP;exact X.
Qed.

Theorem original_factory_funcall:forall m src ret o h x y,
 Mem.load Mint32 m src(Ptrofs.unsigned o)=Some(Vint x) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o+4)=Some(Vint y) ->
 (4|Ptrofs.unsigned o) ->
 Mem.range_perm m src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,
 Cstrategy.eval_funcall ge m(Internal S.f_stab_sp_from_ltp_i)
 [Vptr ret Ptrofs.zero;Vptr src o;Vint h]E0 mf Vundef /\
 active_fields mf ret x y h /\ access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>ret ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->b<>ret ->0<=n ->
 Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros m src ret o h x y LX LY OA RVS WR.
 set(decl:=fn_params S.f_stab_sp_from_ltp_i++fn_vars S.f_stab_sp_from_ltp_i).
 assert(ND:NoDup(map fst decl))by(unfold decl;repeat constructor;simpl;intuition discriminate).
 destruct(Cexec.do_alloc_variables ge empty_env m decl)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m decl e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge decl empty_env m)as A;rewrite ALLOC in A;exact A. }
 assert(ALL:forall id ty,In(id,ty)decl ->exists b,
 e!id=Some(b,ty) /\~Mem.valid_block m b /\Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable ge decl empty_env m id ty ND IN)as A.
   rewrite ALLOC in A;destruct A as(b&L&FR&VB&RP);exists b;auto. }
 destruct(ALL S.__res(tptr F.spty)ltac:(unfold decl;simpl;intuition congruence))as(br&LR&FR&PR).
 destruct(ALL S._vect(tptr F.vty)ltac:(unfold decl;simpl;intuition congruence))as(bv&LV&FV&PV).
 destruct(ALL S._heading tint ltac:(unfold decl;simpl;intuition congruence))as(bh&LH&FH&PH).
 destruct(ALL S._sp F.spty ltac:(unfold decl;simpl;intuition congruence))as(bs&LS&FS&PS).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated ge decl empty_env m
 ltac:(intros id b ty BAD;discriminate BAD)
 ltac:(intros id1 id2 b t1 t2 BAD;discriminate BAD))as A;rewrite ALLOC in A;exact A. }
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&L&FB&RP);rewrite LOOK in L;injection L as EQ;subst bx;exact FB. }
 assert(FREEA:forall id b ty,e!id=Some(b,ty)->Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&L&FB&RP);rewrite LOOK in L;injection L as EQ;subst bx;exact RP. }
 assert(VSRC:Mem.valid_block m src)by(eapply loaded_block;exact LX).
 assert(VRET:Mem.valid_block m ret)by(exact(range_block m ret 0 36 Writable ltac:(lia) WR)).
 assert(DRV:br<>bv)by(eapply environment_distinct;[exact SEP| |exact LR|exact LV];discriminate).
 assert(DRH:br<>bh)by(eapply environment_distinct;[exact SEP| |exact LR|exact LH];discriminate).
 assert(DVH:bv<>bh)by(eapply environment_distinct;[exact SEP| |exact LV|exact LH];discriminate).
 assert(DRS:br<>bs)by(eapply environment_distinct;[exact SEP| |exact LR|exact LS];discriminate).
 assert(DVS:bv<>bs)by(eapply environment_distinct;[exact SEP| |exact LV|exact LS];discriminate).
 assert(DHS:bh<>bs)by(eapply environment_distinct;[exact SEP| |exact LH|exact LS];discriminate).
 assert(SRCBS:src<>bs)by(intro EQ;subst;apply FS;exact VSRC).
 assert(RETBS:ret<>bs)by(intro EQ;subst;apply FS;exact VRET).
 assert(AR:Mem.valid_access ma Mint64 br 0 Writable)by(apply zero_freeable_access;exact PR).
 destruct(Mem.valid_access_store ma Mint64 br 0(Vptr ret Ptrofs.zero)AR)as[mr SR].
 assert(AVV:Mem.valid_access mr Mint64 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SR|apply zero_freeable_access;exact PV]. }
 destruct(Mem.valid_access_store mr Mint64 bv 0(Vptr src o)AVV)as[mv SV].
 assert(AH:Mem.valid_access mv Mint32 bh 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SR|apply zero_freeable_access;exact PH]. }
 destruct(Mem.valid_access_store mv Mint32 bh 0(Vint h)AH)as[mb SH].
 assert(BW:raw_writes(fun b=>b=br\/b=bv\/b=bh)ma mb).
 { eapply raw_writes_store;[left;reflexivity|exact SR|].
 eapply raw_writes_store;[right;left;reflexivity|exact SV|].
 eapply raw_writes_store;[right;right;reflexivity|exact SH|constructor]. }
 assert(BIND:bind_parameters ge e ma(fn_params S.f_stab_sp_from_ltp_i)
 [Vptr ret Ptrofs.zero;Vptr src o;Vint h]mb).
 { cbn[S.f_stab_sp_from_ltp_i fn_params].
 eapply bind_parameters_cons;[exact LR| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SR|change(0+8<=18446744073709551616);lia].
 - eapply bind_parameters_cons;[exact LV| |].
   + eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SV|change(0+8<=18446744073709551616);lia].
   + eapply bind_parameters_cons;[exact LH| |constructor].
     eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SH|change(0+4<=18446744073709551616);lia]. }
 assert(LPR:Mem.load Mint64 mb br 0=Some(Vptr ret Ptrofs.zero)).
 { erewrite Mem.load_store_other by(exact SH||(left;congruence)).
 erewrite Mem.load_store_other by(exact SV||(left;congruence)).
 erewrite Mem.load_store_same by exact SR;reflexivity. }
 assert(LPV:Mem.load Mint64 mb bv 0=Some(Vptr src o)).
 { erewrite Mem.load_store_other by(exact SH||(left;congruence)).
 erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(LPH:Mem.load Mint32 mb bh 0=Some(Vint h)).
 { erewrite Mem.load_store_same by exact SH;reflexivity. }
 assert(OLDOUT:forall b,Mem.valid_block m b ->~(b=br\/b=bv\/b=bh)).
 { intros b VB[EQ|[EQ|EQ]];subst;contradiction. }
 assert(LXB:Mem.load Mint32 mb src(Ptrofs.unsigned o)=Some(Vint x)).
 { rewrite(raw_writes_load_frame _ _ _ BW)by(apply OLDOUT;exact VSRC).
 pose proof(allocation_load ge decl empty_env m _ _ _ _ LX)as A;rewrite ALLOC in A;exact A. }
 assert(LYB:Mem.load Mint32 mb src(Ptrofs.unsigned o+4)=Some(Vint y)).
 { rewrite(raw_writes_load_frame _ _ _ BW)by(apply OLDOUT;exact VSRC).
 pose proof(allocation_load ge decl empty_env m _ _ _ _ LY)as A;rewrite ALLOC in A;exact A. }
 assert(FREEB:forall id b ty,e!id=Some(b,ty)->Mem.range_perm mb b 0(sizeof ge ty)Cur Freeable).
 { intros;apply(raw_writes_range _ _ _ BW);eapply FREEA;eauto. }
 assert(WSP:Mem.range_perm mb bs 0 36 Cur Writable).
 { assert(RP:Mem.range_perm mb bs 0(sizeof ge F.spty)Cur Freeable)by(eapply FREEB;exact LS).
 rewrite F.ge_ce in RP;change(Mem.range_perm mb bs 0 36 Cur Freeable)in RP.
 intros z ZR;apply Mem.perm_implies with(p1:=Freeable);[apply RP;exact ZR|constructor]. }
 assert(RVB:Mem.range_perm mb src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable).
 { apply(raw_writes_range _ _ _ BW);intros z ZR.
 pose proof(allocation_perm ge decl empty_env m src z Cur Readable(RVS z ZR))as A;rewrite ALLOC in A;exact A. }
 assert(WRB:Mem.range_perm mb ret 0 36 Cur Writable).
 { apply(raw_writes_range _ _ _ BW);intros z ZR.
 pose proof(allocation_perm ge decl empty_env m ret z Cur Writable(WR z ZR))as A;rewrite ALLOC in A;exact A. }
 destruct(F.original_factory_body_normal e mb br bv bh bs src ret o h x y
 LR LV LH LS DRS DVS DHS SRCBS RETBS LPV LPH LPR LXB LYB OA WSP RVB WRB)
 as[bodym[BODY[TRACE[ACTIVE BODYWRITE]]]].
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof ge ty)Cur Freeable).
 { intros;apply(raw_writes_range _ _ _ BODYWRITE);eapply FREEB;eauto. }
 destruct(free_environment ge e bodym SEP FREEBODY)as[mf[FREE[FRAMEFREE ACCESSFREE]]].
 assert(OUT:forall b,Mem.valid_block m b ->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;exact(FRESH id b ty LOOK VB). }
 exists mf;split.
 - eapply Cstrategy.eval_funcall_internal with(e:=e)(m1:=ma)(m2:=mb)(m3:=bodym)(out:=Out_return None).
   + repeat constructor;simpl;intuition discriminate.
   + exact AV.
   + exact BIND.
   + exact BODY.
   + reflexivity.
   + exact FREE.
 - split.
   + unfold active_fields in *;repeat match goal with H:_/\_ |- _=>destruct H end.
     repeat split;rewrite FRAMEFREE by(apply OUT;exact VRET);assumption.
   + split.
     * intros ch b ofs p VA;apply ACCESSFREE.
       -- apply OUT;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor].
       -- apply(raw_writes_access _ _ _ BODYWRITE);apply(raw_writes_access _ _ _ BW).
          pose proof(allocation_access ge decl empty_env m ch b ofs p VA)as A;rewrite ALLOC in A;exact A.
     * split.
       -- intros ch b ofs VB DR;rewrite FRAMEFREE by(apply OUT;exact VB).
          rewrite(raw_writes_load_frame _ _ _ BODYWRITE)by(intros[EQ|EQ];[subst;contradiction|contradiction]).
          rewrite(raw_writes_load_frame _ _ _ BW)by(apply OLDOUT;exact VB).
          pose proof(allocation_load_frame ge decl empty_env m ch b ofs VB)as A;rewrite ALLOC in A;exact A.
       -- intros b ofs n VB DR NN.
          rewrite(free_environment_bytes_frame ge e bodym mf FREE b ofs n)by(apply OUT;exact VB).
          rewrite(raw_writes_bytes_frame _ _ _ BODYWRITE)by(first[assumption|intros[EQ|EQ];[subst;contradiction|contradiction]]).
          rewrite(raw_writes_bytes_frame _ _ _ BW)by(first[assumption|apply OLDOUT;exact VB]).
          pose proof(allocation_bytes_frame ge decl empty_env m b ofs n VB)as A;rewrite ALLOC in A;exact A.
Qed.
Corollary original_factory_csem_normal:forall m src ret o h x y,
 Mem.load Mint32 m src(Ptrofs.unsigned o)=Some(Vint x) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o+4)=Some(Vint y) ->
 (4|Ptrofs.unsigned o) ->
 Mem.range_perm m src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,star Csem.step ge
 (Callstate(Internal S.f_stab_sp_from_ltp_i)[Vptr ret Ptrofs.zero;Vptr src o;Vint h]Kstop m)
 E0(Returnstate Vundef Kstop mf) /\ active_fields mf ret x y h.
Proof.
 intros;destruct(original_factory_funcall m src ret o h x y H H0 H1 H2 H3)as[mf[CALL[ACT REST]]].
 exists mf;split;auto;apply funcall_original_normal;exact CALL.
Qed.
Print Assumptions original_factory_funcall.
Print Assumptions original_factory_csem_normal.
