From Stdlib Require Import List Bool ZArith Lia Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport EffectfulSupport StackCleanup FunctionAllocation SaturationEntry.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition ConcretePhases PhaseWiring FactorShell LeafInstances BlockExecution PureIfShell.
From FiveGuidanceCbmcAdapters Require Import CallScope.
From FiveGuidanceSoftwareProof Require Import FunctionEntry.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Require FiveGuidanceEntry.SymbolicPrefix FiveGuidanceEntry.AccelPrefix FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Local Open Scope Z_scope.

Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Import P B.
Theorem factor_guard_certificate:forall e m bn bf bc n maximum f k,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 Mem.load Mfloat32 m bn 0=Some(Vsingle n) ->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bf 0 Writable ->
 exists mf mc P,
 certificate ge P(State f Sskip k e mf) /\P(State f factor_statement k e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf n true s) /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt n)))=Some mf /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bf ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bf ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bn bf bc n maximum f k CONTRACT ES EM SYM LN LF LOADN LOADC ACCESS.
 destruct(CONTRACT m n)as[mc[CALL[KEEP[FRAME BFRAME]]]].
 assert(CVALID:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LOADC).
 assert(LOADMC:Mem.load Mfloat32 mc bc 0=Some(Vsingle maximum))by(rewrite FRAME by exact CVALID;exact LOADC).
 destruct(Mem.valid_access_store mc Mfloat32 bf 0(Vsingle(Float32.div maximum(software_sqrt n)))(KEEP _ _ _ _ ACCESS))as[mf STORE].
 pose proof(funcall_original_normal _ _ _ _ _ _ _ CALL)as WIT.
 set(FI:=factor_invariant ge e f k S._factor S._gh_max_accel S._five_sqrtf S._a_norm2 bf bc sqrt_block bn m maximum n(software_sqrt n)mc mf).
 assert(BASE:certificate ge FI(State f Sskip k e mf)).
 { split.
   - eapply factor_progress with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,speed_leaf_syntax,speed_leaf_names;reflexivity.
   - eapply factor_all_successors with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,speed_leaf_syntax,speed_leaf_names;reflexivity. }
 exists mf,mc,(fun s=>FI s /\helper_call_ok S.f_five_sqrtf n true s);split.
 - eapply factor_guarded_certificate with(leaf:=S.f_five_sqrtf);
   eauto using single_deref,sqrt_symbol,sqrt_funct;reflexivity.
 - split;[split;[left;reflexivity|apply state_call_ok]|].
   split;[intros s H;exact(proj2 H)|]. split;[exact STORE|]. split.
   + unfold access_preserved in *;intros;eapply Mem.store_valid_access_1;[exact STORE|apply KEEP;assumption].
   + split.
     * intros ch b ofs VB D;erewrite Mem.load_store_other by(exact STORE||(left;exact D));apply FRAME;exact VB.
     * intros b ofs nbytes VB D;erewrite Mem.loadbytes_store_other by(exact STORE||(left;exact D));apply BFRAME;exact VB.
Qed.

Theorem saturation_body_guard_certificate:forall e m bp bn bf ba bc a maximum f k,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._accel_sp=Some(bp,tptr vt) ->e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 ba<>bp ->bn<>bp ->bn<>ba ->bn<>bc ->bf<>bp ->bf<>ba ->
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bn 0 Writable ->Mem.valid_access m Mfloat32 bf 0 Writable ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(State f Sskip k e mf) /\
 P(State f(fn_body S.f_gh_saturate_accel)k e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bp bn bf ba bc a maximum f k CONTRACT ES EM SYM LP LN LF DAP DNP DNA DNC DFP DFA PTR LX LY LC AN AF AA0 AA4.
 destruct(Mem.valid_access_store m Mfloat32 bn 0(Vsingle(norm2 a))AN)as[m1 SN].
 assert(NORM:Cstrategy.exec_stmt ge e m norm_statement E0 m1 Out_normal).
 { unfold norm_statement;eapply write_at_single with(b:=bn)(ofs:=0)(x:=norm2 a).
   - apply Cstrategy.esl_var_local;exact LN.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - unfold norm2;eapply Cstrategy.esr_binop.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * reflexivity.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * reflexivity.
     + reflexivity.
   - vm_compute;intuition discriminate.
   - exact SN. }
 assert(PTR1:Mem.load Mint64 m1 bp 0=Some(Vptr ba Ptrofs.zero))by prior_store_load.
 assert(LX1:Mem.load Mfloat32 m1 ba 0=Some(Vsingle(vx a)))by prior_store_load.
 assert(LY1:Mem.load Mfloat32 m1 ba 4=Some(Vsingle(vy a)))by prior_store_load.
 assert(LC1:Mem.load Mfloat32 m1 bc 0=Some(Vsingle maximum))by prior_store_load.
 assert(LN1:Mem.load Mfloat32 m1 bn 0=Some(Vsingle(norm2 a)))by prior_store_load.
 assert(AF1:Mem.valid_access m1 Mfloat32 bf 0 Writable)by prior_store_access.
 assert(AA01:Mem.valid_access m1 Mfloat32 ba 0 Writable)by prior_store_access.
 assert(AA41:Mem.valid_access m1 Mfloat32 ba 4 Writable)by prior_store_access.
 assert(CMP:pure_rval ge e m1 condition_expr=Some(Val.of_bool(saturation_branch maximum a))).
 { unfold condition_expr,named_read.
   cbn [pure_rval pure_lval typeof];rewrite LN,EM,SYM;rewrite !dec_eq_true.
   rewrite(single_deref ge m1 bn(norm2 a)LN1),(single_deref ge m1 bc maximum LC1).
   reflexivity. }
 assert(NCERT:exists P,certificate ge P(State f Sskip(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e m1) /\
 P(State f norm_statement(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s)).
 { eapply guarded_normal_block_certificate;[reflexivity|exact NORM]. }
 destruct NCERT as[PN[CN[IN SNORM]]].
 destruct(saturation_branch maximum a)eqn:BR.
 - destruct(factor_guard_certificate e m1 bn bf bc(norm2 a)maximum f(Kseq scale_pair k) CONTRACT ES EM SYM LN LF LN1 LC1 AF1)
   as(m2 & mc & PF & CF & IFACT & SFACTOR & SF & APF & FRAME & BFRAME).
   assert(PTR2:Mem.load Mint64 m2 bp 0=Some(Vptr ba Ptrofs.zero)).
   { rewrite FRAME;[exact PTR1|eapply loaded_valid_block;exact PTR1|congruence]. }
   assert(LX2:Mem.load Mfloat32 m2 ba 0=Some(Vsingle(vx a))).
   { rewrite FRAME;[exact LX1|eapply loaded_valid_block;exact LX1|congruence]. }
   assert(LY2:Mem.load Mfloat32 m2 ba 4=Some(Vsingle(vy a))).
   { rewrite FRAME;[exact LY1|eapply loaded_valid_block;exact LY1|congruence]. }
   assert(LF2:Mem.load Mfloat32 m2 bf 0=Some(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))).
   { erewrite Mem.load_store_same by exact SF;reflexivity. }
   destruct(scale_pair_exec e m2 bp ba bf a(Float32.div maximum(software_sqrt(norm2 a)))
   LP LF DAP ltac:(congruence) PTR2 LX2 LY2 LF2(APF _ _ _ _ AA01)(APF _ _ _ _ AA41))
   as[mf[ms[SCALE[AX[AY[APS[SX SY]]]]]]].
   destruct(guarded_normal_block_certificate ge f e k m2 scale_pair mf S.f_five_sqrtf(norm2 a)true ltac:(reflexivity)SCALE)as[PS[CS[IS SSCALE]]].
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)true)f e k m1 m2 factor_statement scale_pair PF PS _ CF IFACT CS IS SFACTOR SSCALE ltac:(apply state_call_ok))as[PB[CB[IB SBODY]]].
   assert(CIF:exists PI,certificate ge PI(State f Sskip k e mf) /\
    PI(State f(Sifthenelse condition_expr sat_branch_statement Sskip)k e m1) /\
 (forall s,PI s->helper_call_ok S.f_five_sqrtf(norm2 a)true s)).
   { pose proof(PureIfShell.if_certificate ge f e k m1 condition_expr sat_branch_statement Sskip
      (Val.of_bool true)true ltac:(reflexivity)ltac:(exact CMP)eq_refl)as CI.
     exists(fun s=>PureIfShell.invariant ge f e k m1 condition_expr sat_branch_statement Sskip(Val.of_bool true)true s \/PB s).
     split;[eapply join_certificate;[exact CI|exact CB|exact IB]|].
     split;[left;apply PureIfShell.initial|].
     intros s[IF|BODY];[eapply pure_if_call_ok;exact IF|apply SBODY;exact BODY]. }
   destruct CIF as[PI[CI[II SIF]]].
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)true)f e k m m1 norm_statement(Sifthenelse condition_expr sat_branch_statement Sskip)PN PI _ CN IN CI II SNORM SIF ltac:(apply state_call_ok))as[P[CP[IP SAFE]]].
   exists mf,P;split;[exact CP|]. split;[rewrite saturation_body_shape;exact IP|]. split;[exact SAFE|].
   unfold saturate,saturate_using;rewrite BR;cbn;split;[exact AX|]. split;[exact AY|]. split.
     * unfold access_preserved in *;intros;apply APS;apply APF;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA.
         erewrite Mem.load_store_other by(exact SY||(left;exact DBA)).
         erewrite Mem.load_store_other by(exact SX||(left;exact DBA)).
         rewrite FRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
         erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA.
       erewrite Mem.loadbytes_store_other by(exact SY||(left;exact DBA)).
       erewrite Mem.loadbytes_store_other by(exact SX||(left;exact DBA)).
       rewrite BFRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
       erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
 - pose proof(PureIfShell.if_certificate ge f e k m1 condition_expr sat_branch_statement Sskip
     (Val.of_bool false)false ltac:(reflexivity)ltac:(exact CMP)eq_refl)as CI.
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)false)f e k m m1 norm_statement(Sifthenelse condition_expr sat_branch_statement Sskip)
    PN (PureIfShell.invariant ge f e k m1 condition_expr sat_branch_statement Sskip(Val.of_bool false)false)
    _ CN IN CI ltac:(apply PureIfShell.initial)SNORM ltac:(intros s H;eapply pure_if_call_ok;exact H)ltac:(apply state_call_ok))as[P[CP[IP SAFE]]].
   exists m1,P;split;[exact CP|]. split;[rewrite saturation_body_shape;exact IP|]. split;[exact SAFE|].
   unfold saturate,saturate_using;rewrite BR;cbn;split;[exact LX1|]. split;[exact LY1|]. split.
     * unfold access_preserved;intros;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA;erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA;erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
Qed.

Theorem saturation_funcall_guard_certificate:forall m ba bc a maximum k,
 is_call_cont k ->
 sqrt_call_contract ->Genv.find_symbol ge S._gh_max_accel=Some bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(Returnstate Vundef k mf) /\
 P(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros m ba bc a maximum k CALLCONT CONTRACT SYM LC LX LY A0 A4.
 set(decl:=fn_params S.f_gh_saturate_accel++fn_vars S.f_gh_saturate_accel).
 assert(ND:NoDup(map fst decl))by(unfold decl;repeat constructor;simpl;intuition discriminate).
 destruct(Cexec.do_alloc_variables ge empty_env m decl)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m decl e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge decl empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)decl ->exists b,e!id=Some(b,ty) /\~Mem.valid_block m b /\Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable ge decl empty_env m id ty ND IN)as H;rewrite ALLOC in H;destruct H as(b&L&F&V&P);exists b;auto. }
 destruct(ALL S._accel_sp(tptr vt)ltac:(unfold decl;simpl;intuition congruence))as(bp&LP&FP&PP).
 destruct(ALL S._a_norm2 tfloat ltac:(unfold decl;simpl;intuition congruence))as(bn&LN&FN&PN).
 destruct(ALL S._factor tfloat ltac:(unfold decl;simpl;intuition congruence))as(bf&LF&FF&PF).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated ge decl empty_env m ltac:(intros id b ty H;discriminate H)ltac:(intros id1 id2 b t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact FX. }
 assert(FREEA:forall id b ty,e!id=Some(b,ty)->Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact PERM. }
 assert(ENV_S:e!S._five_sqrtf=None).
 { pose proof(allocation_keeps_binding ge decl empty_env m S._five_sqrtf ltac:(unfold decl;simpl;intuition discriminate))as H;rewrite ALLOC in H;exact H. }
 assert(ENV_M:e!S._gh_max_accel=None).
 { pose proof(allocation_keeps_binding ge decl empty_env m S._gh_max_accel ltac:(unfold decl;simpl;intuition discriminate))as H;rewrite ALLOC in H;exact H. }
 assert(VA:Mem.valid_block m ba)by(eapply loaded_valid_block;exact LX).
 assert(VC:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LC).
 assert(DAP:ba<>bp)by(intro EQ;subst bp;apply FP;exact VA).
 assert(DNA:bn<>ba)by(intro EQ;subst bn;apply FN;exact VA).
 assert(DNC:bn<>bc)by(intro EQ;subst bn;apply FN;exact VC).
 assert(DFA:bf<>ba)by(intro EQ;subst bf;apply FF;exact VA).
 assert(DNP:bn<>bp)by(eapply environment_distinct;[exact SEP| |exact LN|exact LP];discriminate).
 assert(DFP:bf<>bp)by(eapply environment_distinct;[exact SEP| |exact LF|exact LP];discriminate).
 assert(PACCESS:Mem.valid_access ma Mint64 bp 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact PP. }
 destruct(Mem.valid_access_store ma Mint64 bp 0(Vptr ba Ptrofs.zero)PACCESS)as[mb SP].
 assert(COPYKEEP:access_preserved ma mb).
 { unfold access_preserved;intros;eapply Mem.store_valid_access_1;eauto. }
 assert(FREEB:forall id b ty,e!id=Some(b,ty)->Mem.range_perm mb b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact COPYKEEP|eapply FREEA;exact LOOK]. }
 assert(BIND:bind_parameters ge e ma(fn_params S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]mb).
 { eapply bind_parameters_cons;[exact LP| |constructor].
   eapply assign_loc_value;[reflexivity|reflexivity|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact SP|change(0+8<=18446744073709551616);lia]. }
 assert(PTR:Mem.load Mint64 mb bp 0=Some(Vptr ba Ptrofs.zero)).
 { erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LXB:Mem.load Mfloat32 mb ba 0=Some(Vsingle(vx a))).
 { erewrite Mem.load_store_other by(exact SP||(left;exact DAP)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 ba 0(Vsingle(vx a))LX)as H;rewrite ALLOC in H;exact H. }
 assert(LYB:Mem.load Mfloat32 mb ba 4=Some(Vsingle(vy a))).
 { erewrite Mem.load_store_other by(exact SP||(left;exact DAP)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 ba 4(Vsingle(vy a))LY)as H;rewrite ALLOC in H;exact H. }
 assert(LCB:Mem.load Mfloat32 mb bc 0=Some(Vsingle maximum)).
 { erewrite Mem.load_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VC)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 bc 0(Vsingle maximum)LC)as H;rewrite ALLOC in H;exact H. }
 assert(AA0:Mem.valid_access mb Mfloat32 ba 0 Writable).
 { apply COPYKEEP;pose proof(allocation_access ge decl empty_env m Mfloat32 ba 0 Writable A0)as H;rewrite ALLOC in H;exact H. }
 assert(AA4:Mem.valid_access mb Mfloat32 ba 4 Writable).
 { apply COPYKEEP;pose proof(allocation_access ge decl empty_env m Mfloat32 ba 4 Writable A4)as H;rewrite ALLOC in H;exact H. }
 assert(AN:Mem.valid_access mb Mfloat32 bn 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact(FREEB _ _ _ LN). }
 assert(AF:Mem.valid_access mb Mfloat32 bf 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact(FREEB _ _ _ LF). }
 destruct(saturation_body_guard_certificate e mb bp bn bf ba bc a maximum S.f_gh_saturate_accel k CONTRACT ENV_S ENV_M SYM LP LN LF
 DAP DNP DNA DNC DFP DFA PTR LXB LYB LCB AN AF AA0 AA4)as(bodym & PB & CB & IB & SAFE_BODY & AX & AY & KEEP & FRAME & BFRAME).
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact KEEP|eapply FREEB;exact LOOK]. }
 destruct(free_environment ge e bodym SEP FREEBODY)as[mf[FREE[FRAMEFREE ACCESSFREE]]].
 assert(OUT:forall b,Mem.valid_block m b->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;exact(FRESH id b ty LOOK VB). }
 pose proof(cleanup_transition ge S.f_gh_saturate_accel k e bodym mf CALLCONT FREE)as CLEAN.
 pose proof(singleton_bridge_certificate ge _ _ CLEAN)as CCLEAN.
 pose proof(join_certificate ge PB _ _ _ CB CCLEAN ltac:(left;reflexivity))as CJOIN.
 assert(DISPATCH:unique_transition ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)
  (State S.f_gh_saturate_accel(fn_body S.f_gh_saturate_accel)k e mb)).
 { eapply internal_dispatch_transition;[repeat constructor;simpl;intuition discriminate|exact AV|exact BIND]. }
 assert(ROOTSAFE:helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)).
 { intros args kk mm EQ;assert(EF:S.f_gh_saturate_accel=S.f_five_sqrtf)by congruence.
   assert(ET:tvoid=tfloat)by exact(f_equal fn_return EF);discriminate. }
 assert(SAFEJOIN:forall s,PB s\/(s=State S.f_gh_saturate_accel Sskip k e bodym\/s=Returnstate Vundef k mf)->
 helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s).
 { intros s[PS|[->|->]];[apply SAFE_BODY;exact PS|apply state_call_ok|apply return_call_ok]. }
 destruct(guarded_prepend ge(helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a))
 _ _ _ _ DISPATCH CJOIN ltac:(left;exact IB)ROOTSAFE SAFEJOIN)as[P[CP[IP SAFE]]].
 exists mf,P;split;[exact CP|]. split;[exact IP|]. split;[exact SAFE|].
 split;[rewrite FRAMEFREE by(apply OUT;exact VA);exact AX|].
   split;[rewrite FRAMEFREE by(apply OUT;exact VA);exact AY|]. split.
   + unfold access_preserved;intros ch b ofs p ACCESS.
     assert(VB:Mem.valid_block m b).
     { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact ACCESS|constructor]. }
     apply ACCESSFREE;[apply OUT;exact VB|]. apply KEEP;apply COPYKEEP.
     pose proof(allocation_access ge decl empty_env m ch b ofs p ACCESS)as H;rewrite ALLOC in H;exact H.
   + split.
     { intros ch b ofs VB DBA;rewrite FRAMEFREE by(apply OUT;exact VB).
     rewrite FRAME.
     * erewrite Mem.load_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VB)).
       pose proof(allocation_load_frame ge decl empty_env m ch b ofs VB)as H;rewrite ALLOC in H;exact H.
     * eapply Mem.store_valid_block_1;[exact SP|].
       pose proof(allocation_valid_block ge decl empty_env m b VB)as H;rewrite ALLOC in H;exact H.
     * intro EQ;subst bn;apply FN;exact VB.
     * intro EQ;subst bf;apply FF;exact VB.
     * exact DBA. }
     intros b ofs nbytes VB DBA.
     rewrite(free_environment_bytes_frame ge e bodym mf FREE b ofs nbytes)by(apply OUT;exact VB).
     rewrite BFRAME.
     * erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VB)).
       pose proof(allocation_bytes_frame ge decl empty_env m b ofs nbytes VB)as H;rewrite ALLOC in H;exact H.
     * eapply Mem.store_valid_block_1;[exact SP|].
       pose proof(allocation_valid_block ge decl empty_env m b VB)as H;rewrite ALLOC in H;exact H.
     * intro EQ;subst bn;apply FN;exact VB.
     * intro EQ;subst bf;apply FF;exact VB.
     * exact DBA.
Qed.

Definition actual_sqrt_contract:sqrt_call_contract:=speed_helper_funcall.
Theorem helper_argument_scope:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 forall t args kc mc,
 bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch maximum a=true /\args=[Vsingle(norm2 a)].
Proof.
 intros m ba bc a maximum k KC SYM LC LX LY A0 A4 t args kc mc PATH.
 destruct(saturation_funcall_guard_certificate m ba bc a maximum k KC actual_sqrt_contract SYM LC LX LY A0 A4)
 as[mf[P[CERT[INIT[SAFE REST]]]]].
 pose proof(bounded_invariant ge k P(Returnstate Vundef k mf)_ CERT ltac:(exists Vundef,mf;reflexivity)INIT t _ PATH)as INV.
 exact(SAFE _ INV args kc mc eq_refl).
Qed.
Theorem unsaturated_no_helper_call:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->forall t args kc mc,
 ~bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc).
Proof.
 intros m ba bc a maximum k KC SYM LC LX LY A0 A4 BR t args kc mc PATH.
 destruct(helper_argument_scope m ba bc a maximum k KC SYM LC LX LY A0 A4 t args kc mc PATH)as[YES ARGS];congruence.
Qed.
Print Assumptions helper_argument_scope.
Print Assumptions unsaturated_no_helper_call.

End Speed.

Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Import P B.
Theorem factor_guard_certificate:forall e m bn bf bc n maximum f k,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 Mem.load Mfloat32 m bn 0=Some(Vsingle n) ->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bf 0 Writable ->
 exists mf mc P,
 certificate ge P(State f Sskip k e mf) /\P(State f factor_statement k e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf n true s) /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt n)))=Some mf /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bf ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bf ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bn bf bc n maximum f k CONTRACT ES EM SYM LN LF LOADN LOADC ACCESS.
 destruct(CONTRACT m n)as[mc[CALL[KEEP[FRAME BFRAME]]]].
 assert(CVALID:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LOADC).
 assert(LOADMC:Mem.load Mfloat32 mc bc 0=Some(Vsingle maximum))by(rewrite FRAME by exact CVALID;exact LOADC).
 destruct(Mem.valid_access_store mc Mfloat32 bf 0(Vsingle(Float32.div maximum(software_sqrt n)))(KEEP _ _ _ _ ACCESS))as[mf STORE].
 pose proof(funcall_original_normal _ _ _ _ _ _ _ CALL)as WIT.
 set(FI:=factor_invariant ge e f k S._factor S._gh_max_accel S._five_sqrtf S._a_norm2 bf bc sqrt_block bn m maximum n(software_sqrt n)mc mf).
 assert(BASE:certificate ge FI(State f Sskip k e mf)).
 { split.
   - eapply factor_progress with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,accel_leaf_syntax,accel_leaf_names;reflexivity.
   - eapply factor_all_successors with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,accel_leaf_syntax,accel_leaf_names;reflexivity. }
 exists mf,mc,(fun s=>FI s /\helper_call_ok S.f_five_sqrtf n true s);split.
 - eapply factor_guarded_certificate with(leaf:=S.f_five_sqrtf);
   eauto using single_deref,sqrt_symbol,sqrt_funct;reflexivity.
 - split;[split;[left;reflexivity|apply state_call_ok]|].
   split;[intros s H;exact(proj2 H)|]. split;[exact STORE|]. split.
   + unfold access_preserved in *;intros;eapply Mem.store_valid_access_1;[exact STORE|apply KEEP;assumption].
   + split.
     * intros ch b ofs VB D;erewrite Mem.load_store_other by(exact STORE||(left;exact D));apply FRAME;exact VB.
     * intros b ofs nbytes VB D;erewrite Mem.loadbytes_store_other by(exact STORE||(left;exact D));apply BFRAME;exact VB.
Qed.

Theorem saturation_body_guard_certificate:forall e m bp bn bf ba bc a maximum f k,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._accel_sp=Some(bp,tptr vt) ->e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 ba<>bp ->bn<>bp ->bn<>ba ->bn<>bc ->bf<>bp ->bf<>ba ->
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bn 0 Writable ->Mem.valid_access m Mfloat32 bf 0 Writable ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(State f Sskip k e mf) /\
 P(State f(fn_body S.f_gh_saturate_accel)k e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bp bn bf ba bc a maximum f k CONTRACT ES EM SYM LP LN LF DAP DNP DNA DNC DFP DFA PTR LX LY LC AN AF AA0 AA4.
 destruct(Mem.valid_access_store m Mfloat32 bn 0(Vsingle(norm2 a))AN)as[m1 SN].
 assert(NORM:Cstrategy.exec_stmt ge e m norm_statement E0 m1 Out_normal).
 { unfold norm_statement;eapply write_at_single with(b:=bn)(ofs:=0)(x:=norm2 a).
   - apply Cstrategy.esl_var_local;exact LN.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - unfold norm2;eapply Cstrategy.esr_binop.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * reflexivity.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * reflexivity.
     + reflexivity.
   - vm_compute;intuition discriminate.
   - exact SN. }
 assert(PTR1:Mem.load Mint64 m1 bp 0=Some(Vptr ba Ptrofs.zero))by prior_store_load.
 assert(LX1:Mem.load Mfloat32 m1 ba 0=Some(Vsingle(vx a)))by prior_store_load.
 assert(LY1:Mem.load Mfloat32 m1 ba 4=Some(Vsingle(vy a)))by prior_store_load.
 assert(LC1:Mem.load Mfloat32 m1 bc 0=Some(Vsingle maximum))by prior_store_load.
 assert(LN1:Mem.load Mfloat32 m1 bn 0=Some(Vsingle(norm2 a)))by prior_store_load.
 assert(AF1:Mem.valid_access m1 Mfloat32 bf 0 Writable)by prior_store_access.
 assert(AA01:Mem.valid_access m1 Mfloat32 ba 0 Writable)by prior_store_access.
 assert(AA41:Mem.valid_access m1 Mfloat32 ba 4 Writable)by prior_store_access.
 assert(CMP:pure_rval ge e m1 condition_expr=Some(Val.of_bool(saturation_branch maximum a))).
 { unfold condition_expr,named_read.
   cbn [pure_rval pure_lval typeof];rewrite LN,EM,SYM;rewrite !dec_eq_true.
   rewrite(single_deref ge m1 bn(norm2 a)LN1),(single_deref ge m1 bc maximum LC1).
   reflexivity. }
 assert(NCERT:exists P,certificate ge P(State f Sskip(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e m1) /\
 P(State f norm_statement(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s)).
 { eapply guarded_normal_block_certificate;[reflexivity|exact NORM]. }
 destruct NCERT as[PN[CN[IN SNORM]]].
 destruct(saturation_branch maximum a)eqn:BR.
 - destruct(factor_guard_certificate e m1 bn bf bc(norm2 a)maximum f(Kseq scale_pair k) CONTRACT ES EM SYM LN LF LN1 LC1 AF1)
   as(m2 & mc & PF & CF & IFACT & SFACTOR & SF & APF & FRAME & BFRAME).
   assert(PTR2:Mem.load Mint64 m2 bp 0=Some(Vptr ba Ptrofs.zero)).
   { rewrite FRAME;[exact PTR1|eapply loaded_valid_block;exact PTR1|congruence]. }
   assert(LX2:Mem.load Mfloat32 m2 ba 0=Some(Vsingle(vx a))).
   { rewrite FRAME;[exact LX1|eapply loaded_valid_block;exact LX1|congruence]. }
   assert(LY2:Mem.load Mfloat32 m2 ba 4=Some(Vsingle(vy a))).
   { rewrite FRAME;[exact LY1|eapply loaded_valid_block;exact LY1|congruence]. }
   assert(LF2:Mem.load Mfloat32 m2 bf 0=Some(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))).
   { erewrite Mem.load_store_same by exact SF;reflexivity. }
   destruct(scale_pair_exec e m2 bp ba bf a(Float32.div maximum(software_sqrt(norm2 a)))
   LP LF DAP ltac:(congruence) PTR2 LX2 LY2 LF2(APF _ _ _ _ AA01)(APF _ _ _ _ AA41))
   as[mf[ms[SCALE[AX[AY[APS[SX SY]]]]]]].
   destruct(guarded_normal_block_certificate ge f e k m2 scale_pair mf S.f_five_sqrtf(norm2 a)true ltac:(reflexivity)SCALE)as[PS[CS[IS SSCALE]]].
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)true)f e k m1 m2 factor_statement scale_pair PF PS _ CF IFACT CS IS SFACTOR SSCALE ltac:(apply state_call_ok))as[PB[CB[IB SBODY]]].
   assert(CIF:exists PI,certificate ge PI(State f Sskip k e mf) /\
    PI(State f(Sifthenelse condition_expr sat_branch_statement Sskip)k e m1) /\
 (forall s,PI s->helper_call_ok S.f_five_sqrtf(norm2 a)true s)).
   { pose proof(PureIfShell.if_certificate ge f e k m1 condition_expr sat_branch_statement Sskip
      (Val.of_bool true)true ltac:(reflexivity)ltac:(exact CMP)eq_refl)as CI.
     exists(fun s=>PureIfShell.invariant ge f e k m1 condition_expr sat_branch_statement Sskip(Val.of_bool true)true s \/PB s).
     split;[eapply join_certificate;[exact CI|exact CB|exact IB]|].
     split;[left;apply PureIfShell.initial|].
     intros s[IF|BODY];[eapply pure_if_call_ok;exact IF|apply SBODY;exact BODY]. }
   destruct CIF as[PI[CI[II SIF]]].
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)true)f e k m m1 norm_statement(Sifthenelse condition_expr sat_branch_statement Sskip)PN PI _ CN IN CI II SNORM SIF ltac:(apply state_call_ok))as[P[CP[IP SAFE]]].
   exists mf,P;split;[exact CP|]. split;[rewrite saturation_body_shape;exact IP|]. split;[exact SAFE|].
   unfold saturate,saturate_using;rewrite BR;cbn;split;[exact AX|]. split;[exact AY|]. split.
     * unfold access_preserved in *;intros;apply APS;apply APF;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA.
         erewrite Mem.load_store_other by(exact SY||(left;exact DBA)).
         erewrite Mem.load_store_other by(exact SX||(left;exact DBA)).
         rewrite FRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
         erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA.
       erewrite Mem.loadbytes_store_other by(exact SY||(left;exact DBA)).
       erewrite Mem.loadbytes_store_other by(exact SX||(left;exact DBA)).
       rewrite BFRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
       erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
 - pose proof(PureIfShell.if_certificate ge f e k m1 condition_expr sat_branch_statement Sskip
     (Val.of_bool false)false ltac:(reflexivity)ltac:(exact CMP)eq_refl)as CI.
   destruct(guarded_sequence ge(helper_call_ok S.f_five_sqrtf(norm2 a)false)f e k m m1 norm_statement(Sifthenelse condition_expr sat_branch_statement Sskip)
    PN (PureIfShell.invariant ge f e k m1 condition_expr sat_branch_statement Sskip(Val.of_bool false)false)
    _ CN IN CI ltac:(apply PureIfShell.initial)SNORM ltac:(intros s H;eapply pure_if_call_ok;exact H)ltac:(apply state_call_ok))as[P[CP[IP SAFE]]].
   exists m1,P;split;[exact CP|]. split;[rewrite saturation_body_shape;exact IP|]. split;[exact SAFE|].
   unfold saturate,saturate_using;rewrite BR;cbn;split;[exact LX1|]. split;[exact LY1|]. split.
     * unfold access_preserved;intros;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA;erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA;erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
Qed.

Theorem saturation_funcall_guard_certificate:forall m ba bc a maximum k,
 is_call_cont k ->
 sqrt_call_contract ->Genv.find_symbol ge S._gh_max_accel=Some bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(Returnstate Vundef k mf) /\
 P(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros m ba bc a maximum k CALLCONT CONTRACT SYM LC LX LY A0 A4.
 set(decl:=fn_params S.f_gh_saturate_accel++fn_vars S.f_gh_saturate_accel).
 assert(ND:NoDup(map fst decl))by(unfold decl;repeat constructor;simpl;intuition discriminate).
 destruct(Cexec.do_alloc_variables ge empty_env m decl)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m decl e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge decl empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)decl ->exists b,e!id=Some(b,ty) /\~Mem.valid_block m b /\Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable ge decl empty_env m id ty ND IN)as H;rewrite ALLOC in H;destruct H as(b&L&F&V&P);exists b;auto. }
 destruct(ALL S._accel_sp(tptr vt)ltac:(unfold decl;simpl;intuition congruence))as(bp&LP&FP&PP).
 destruct(ALL S._a_norm2 tfloat ltac:(unfold decl;simpl;intuition congruence))as(bn&LN&FN&PN).
 destruct(ALL S._factor tfloat ltac:(unfold decl;simpl;intuition congruence))as(bf&LF&FF&PF).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated ge decl empty_env m ltac:(intros id b ty H;discriminate H)ltac:(intros id1 id2 b t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact FX. }
 assert(FREEA:forall id b ty,e!id=Some(b,ty)->Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
   destruct(ALL id ty IN)as(bx&LOOKX&FX&PERM);rewrite LOOK in LOOKX;injection LOOKX as EQ;subst bx;exact PERM. }
 assert(ENV_S:e!S._five_sqrtf=None).
 { pose proof(allocation_keeps_binding ge decl empty_env m S._five_sqrtf ltac:(unfold decl;simpl;intuition discriminate))as H;rewrite ALLOC in H;exact H. }
 assert(ENV_M:e!S._gh_max_accel=None).
 { pose proof(allocation_keeps_binding ge decl empty_env m S._gh_max_accel ltac:(unfold decl;simpl;intuition discriminate))as H;rewrite ALLOC in H;exact H. }
 assert(VA:Mem.valid_block m ba)by(eapply loaded_valid_block;exact LX).
 assert(VC:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LC).
 assert(DAP:ba<>bp)by(intro EQ;subst bp;apply FP;exact VA).
 assert(DNA:bn<>ba)by(intro EQ;subst bn;apply FN;exact VA).
 assert(DNC:bn<>bc)by(intro EQ;subst bn;apply FN;exact VC).
 assert(DFA:bf<>ba)by(intro EQ;subst bf;apply FF;exact VA).
 assert(DNP:bn<>bp)by(eapply environment_distinct;[exact SEP| |exact LN|exact LP];discriminate).
 assert(DFP:bf<>bp)by(eapply environment_distinct;[exact SEP| |exact LF|exact LP];discriminate).
 assert(PACCESS:Mem.valid_access ma Mint64 bp 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact PP. }
 destruct(Mem.valid_access_store ma Mint64 bp 0(Vptr ba Ptrofs.zero)PACCESS)as[mb SP].
 assert(COPYKEEP:access_preserved ma mb).
 { unfold access_preserved;intros;eapply Mem.store_valid_access_1;eauto. }
 assert(FREEB:forall id b ty,e!id=Some(b,ty)->Mem.range_perm mb b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact COPYKEEP|eapply FREEA;exact LOOK]. }
 assert(BIND:bind_parameters ge e ma(fn_params S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]mb).
 { eapply bind_parameters_cons;[exact LP| |constructor].
   eapply assign_loc_value;[reflexivity|reflexivity|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact SP|change(0+8<=18446744073709551616);lia]. }
 assert(PTR:Mem.load Mint64 mb bp 0=Some(Vptr ba Ptrofs.zero)).
 { erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LXB:Mem.load Mfloat32 mb ba 0=Some(Vsingle(vx a))).
 { erewrite Mem.load_store_other by(exact SP||(left;exact DAP)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 ba 0(Vsingle(vx a))LX)as H;rewrite ALLOC in H;exact H. }
 assert(LYB:Mem.load Mfloat32 mb ba 4=Some(Vsingle(vy a))).
 { erewrite Mem.load_store_other by(exact SP||(left;exact DAP)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 ba 4(Vsingle(vy a))LY)as H;rewrite ALLOC in H;exact H. }
 assert(LCB:Mem.load Mfloat32 mb bc 0=Some(Vsingle maximum)).
 { erewrite Mem.load_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VC)).
   pose proof(allocation_load ge decl empty_env m Mfloat32 bc 0(Vsingle maximum)LC)as H;rewrite ALLOC in H;exact H. }
 assert(AA0:Mem.valid_access mb Mfloat32 ba 0 Writable).
 { apply COPYKEEP;pose proof(allocation_access ge decl empty_env m Mfloat32 ba 0 Writable A0)as H;rewrite ALLOC in H;exact H. }
 assert(AA4:Mem.valid_access mb Mfloat32 ba 4 Writable).
 { apply COPYKEEP;pose proof(allocation_access ge decl empty_env m Mfloat32 ba 4 Writable A4)as H;rewrite ALLOC in H;exact H. }
 assert(AN:Mem.valid_access mb Mfloat32 bn 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact(FREEB _ _ _ LN). }
 assert(AF:Mem.valid_access mb Mfloat32 bf 0 Writable).
 { apply Mem.valid_access_freeable_any;apply freeable_at_zero;exact(FREEB _ _ _ LF). }
 destruct(saturation_body_guard_certificate e mb bp bn bf ba bc a maximum S.f_gh_saturate_accel k CONTRACT ENV_S ENV_M SYM LP LN LF
 DAP DNP DNA DNC DFP DFA PTR LXB LYB LCB AN AF AA0 AA4)as(bodym & PB & CB & IB & SAFE_BODY & AX & AY & KEEP & FRAME & BFRAME).
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact KEEP|eapply FREEB;exact LOOK]. }
 destruct(free_environment ge e bodym SEP FREEBODY)as[mf[FREE[FRAMEFREE ACCESSFREE]]].
 assert(OUT:forall b,Mem.valid_block m b->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;exact(FRESH id b ty LOOK VB). }
 pose proof(cleanup_transition ge S.f_gh_saturate_accel k e bodym mf CALLCONT FREE)as CLEAN.
 pose proof(singleton_bridge_certificate ge _ _ CLEAN)as CCLEAN.
 pose proof(join_certificate ge PB _ _ _ CB CCLEAN ltac:(left;reflexivity))as CJOIN.
 assert(DISPATCH:unique_transition ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)
  (State S.f_gh_saturate_accel(fn_body S.f_gh_saturate_accel)k e mb)).
 { eapply internal_dispatch_transition;[repeat constructor;simpl;intuition discriminate|exact AV|exact BIND]. }
 assert(ROOTSAFE:helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)).
 { intros args kk mm EQ;assert(EF:S.f_gh_saturate_accel=S.f_five_sqrtf)by congruence.
   assert(ET:tvoid=tfloat)by exact(f_equal fn_return EF);discriminate. }
 assert(SAFEJOIN:forall s,PB s\/(s=State S.f_gh_saturate_accel Sskip k e bodym\/s=Returnstate Vundef k mf)->
 helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s).
 { intros s[PS|[->|->]];[apply SAFE_BODY;exact PS|apply state_call_ok|apply return_call_ok]. }
 destruct(guarded_prepend ge(helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a))
 _ _ _ _ DISPATCH CJOIN ltac:(left;exact IB)ROOTSAFE SAFEJOIN)as[P[CP[IP SAFE]]].
 exists mf,P;split;[exact CP|]. split;[exact IP|]. split;[exact SAFE|].
 split;[rewrite FRAMEFREE by(apply OUT;exact VA);exact AX|].
   split;[rewrite FRAMEFREE by(apply OUT;exact VA);exact AY|]. split.
   + unfold access_preserved;intros ch b ofs p ACCESS.
     assert(VB:Mem.valid_block m b).
     { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact ACCESS|constructor]. }
     apply ACCESSFREE;[apply OUT;exact VB|]. apply KEEP;apply COPYKEEP.
     pose proof(allocation_access ge decl empty_env m ch b ofs p ACCESS)as H;rewrite ALLOC in H;exact H.
   + split.
     { intros ch b ofs VB DBA;rewrite FRAMEFREE by(apply OUT;exact VB).
     rewrite FRAME.
     * erewrite Mem.load_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VB)).
       pose proof(allocation_load_frame ge decl empty_env m ch b ofs VB)as H;rewrite ALLOC in H;exact H.
     * eapply Mem.store_valid_block_1;[exact SP|].
       pose proof(allocation_valid_block ge decl empty_env m b VB)as H;rewrite ALLOC in H;exact H.
     * intro EQ;subst bn;apply FN;exact VB.
     * intro EQ;subst bf;apply FF;exact VB.
     * exact DBA. }
     intros b ofs nbytes VB DBA.
     rewrite(free_environment_bytes_frame ge e bodym mf FREE b ofs nbytes)by(apply OUT;exact VB).
     rewrite BFRAME.
     * erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst bp;apply FP;exact VB)).
       pose proof(allocation_bytes_frame ge decl empty_env m b ofs nbytes VB)as H;rewrite ALLOC in H;exact H.
     * eapply Mem.store_valid_block_1;[exact SP|].
       pose proof(allocation_valid_block ge decl empty_env m b VB)as H;rewrite ALLOC in H;exact H.
     * intro EQ;subst bn;apply FN;exact VB.
     * intro EQ;subst bf;apply FF;exact VB.
     * exact DBA.
Qed.

Definition actual_sqrt_contract:sqrt_call_contract:=accel_helper_funcall.
Theorem helper_argument_scope:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 forall t args kc mc,
 bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch maximum a=true /\args=[Vsingle(norm2 a)].
Proof.
 intros m ba bc a maximum k KC SYM LC LX LY A0 A4 t args kc mc PATH.
 destruct(saturation_funcall_guard_certificate m ba bc a maximum k KC actual_sqrt_contract SYM LC LX LY A0 A4)
 as[mf[P[CERT[INIT[SAFE REST]]]]].
 pose proof(bounded_invariant ge k P(Returnstate Vundef k mf)_ CERT ltac:(exists Vundef,mf;reflexivity)INIT t _ PATH)as INV.
 exact(SAFE _ INV args kc mc eq_refl).
Qed.
Theorem unsaturated_no_helper_call:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->forall t args kc mc,
 ~bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc).
Proof.
 intros m ba bc a maximum k KC SYM LC LX LY A0 A4 BR t args kc mc PATH.
 destruct(helper_argument_scope m ba bc a maximum k KC SYM LC LX LY A0 A4 t args kc mc PATH)as[YES ARGS];congruence.
Qed.
Print Assumptions helper_argument_scope.
Print Assumptions unsaturated_no_helper_call.

End Accel.
