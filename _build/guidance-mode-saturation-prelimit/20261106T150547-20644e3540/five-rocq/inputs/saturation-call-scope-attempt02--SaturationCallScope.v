From Stdlib Require Import List Bool ZArith Lia Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport EffectfulSupport StackCleanup FunctionAllocation.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition ConcretePhases PhaseWiring FactorShell LeafInstances BlockExecution PureIfShell.
From FiveGuidanceCbmcAdapters Require Import CallScope.
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

End Accel.
