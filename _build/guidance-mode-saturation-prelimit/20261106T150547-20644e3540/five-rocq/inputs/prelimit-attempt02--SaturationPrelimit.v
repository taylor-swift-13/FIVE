From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import Entry BigstepSupport StackCleanup FunctionAllocation SaturationEntry.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Require FiveGuidanceEntry.SymbolicPrefix FiveGuidanceEntry.AccelPrefix FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Local Open Scope Z_scope.

Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Import P B.
Definition local_point(e:env)(m:mem)(bp bn bf ba bc:block)(a:vector)(maximum:float32):Prop:=
 e!S._five_sqrtf=None /\e!S._gh_max_accel=None /\
 e!S._accel_sp=Some(bp,tptr vt) /\e!S._a_norm2=Some(bn,tfloat) /\e!S._factor=Some(bf,tfloat) /\
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) /\
 Mem.load Mfloat32 m bn 0=Some(Vsingle(norm2 a)) /\
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) /\
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) /\Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) /\
 env_separated e /\
 (forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof ge ty)Cur Freeable).
Theorem saturation_to_branch:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4.

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


 destruct(Mem.valid_access_store mb Mfloat32 bn 0(Vsingle(norm2 a))AN)as[m1 SN].
 assert(NORM:Cstrategy.exec_stmt ge e mb norm_statement E0 m1 Out_normal).
 { unfold norm_statement;eapply write_at_single with(b:=bn)(ofs:=0)(x:=norm2 a).
   - apply Cstrategy.esl_var_local;exact LN.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - unfold norm2;eapply Cstrategy.esr_binop.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LXB].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LXB].
       * reflexivity.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LYB].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LYB].
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
 assert(CMP:Cstrategy.eval_simple_rvalue ge e m1 condition_expr(Val.of_bool(saturation_branch maximum a))).
 { unfold condition_expr,saturation_branch;eapply Cstrategy.esr_binop.
   - eapply read_named;[exact LN|exact LN1].
   - eapply Cstrategy.esr_binop;
     [eapply read_maximum;[exact ENV_M|exact SYM|exact LC1]|
      eapply read_maximum;[exact ENV_M|exact SYM|exact LC1]|reflexivity].
   - reflexivity. }

 assert(FREE1:forall id b ty,e!id=Some(b,ty)->Mem.range_perm m1 b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[intros ch bx ofs p A;eapply Mem.store_valid_access_1;[exact SN|exact A]|eapply FREEB;exact LOOK]. }
 assert(BRANCHPATH:star Csem.step ge
 (State S.f_gh_saturate_accel(Sifthenelse condition_expr sat_branch_statement Sskip)k e m1)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e m1)).
 { eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_ifthenelse_1| |reflexivity].
   eapply star_trans with(t1:=E0)(t2:=E0).
   - apply plus_star;apply Cstrategy.step_simulation;left;eapply Cstrategy.step_expr with(v:=Val.of_bool(saturation_branch maximum a))(ty:=tint).
     + exact CMP.
     + exact I.
     + reflexivity.
   - apply star_one;right;eapply Csem.step_ifthenelse_2;destruct(saturation_branch maximum a);reflexivity.
   - reflexivity. }
 exists e,m1,bp,bn,bf;split.
 - unfold local_point;repeat split;assumption.
 - eapply star_step with(t1:=E0)(t2:=E0);[right;eapply Csem.step_internal_function| |reflexivity].
   + repeat constructor;simpl;intuition discriminate.
   + exact AV.
   + exact BIND.
   + rewrite saturation_body_shape;eapply star_trans with(t1:=E0)(t2:=E0).
     * eapply statement_prefix_path;exact NORM.
     * exact BRANCHPATH.
     * reflexivity.
Qed.

Definition factor_context(hole:expr):expr:=Eassign(Evar S._factor tfloat)(Ebinop Odiv(named_read S._gh_max_accel)hole tfloat)tfloat.
Definition factor_state(e:env)(m:mem)(k:cont):Csem.state:=
 ExprState S.f_gh_saturate_accel(factor_context sqrt_call)(Kdo(Kseq scale_pair k))e m.
Lemma branch_to_factor_state:forall e m k,
 star Csem.step ge(State S.f_gh_saturate_accel sat_branch_statement k e m)E0(factor_state e m k).
Proof.
 intros e m k;unfold sat_branch_statement,factor_statement,factor_state,factor_context.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_seq| |reflexivity].
 apply star_one;right;apply Csem.step_do_1.
Qed.
Lemma factor_state_to_sqrt:forall e m bp bn bf ba bc a maximum k,
 local_point e m bp bn bf ba bc a maximum->
 exists kc,star Csem.step ge(factor_state e m k)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc m).
Proof.
 intros e m bp bn bf ba bc a maximum k POINT.
 destruct POINT as[ES[EM[LP[LN[LF[PTR[NORM[LC[LX[LY REST]]]]]]]]]].
 exists(Kcall S.f_gh_saturate_accel e factor_context tfloat(Kdo(Kseq scale_pair k))).
 apply plus_star;apply Cstrategy.step_simulation;left.
 unfold factor_state,sqrt_call.
 change(Cstrategy.estep ge
 (ExprState S.f_gh_saturate_accel(factor_context(Ecall sqrt_rf(Econs(named_read S._a_norm2)Enil)tfloat))(Kdo(Kseq scale_pair k))e m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)](Kcall S.f_gh_saturate_accel e factor_context tfloat(Kdo(Kseq scale_pair k)))m)).
 eapply Cstrategy.step_call with(vf:=Vptr sqrt_block Ptrofs.zero).
 - unfold factor_context;apply Cstrategy.lctx_assign_right;[reflexivity|].
   apply Cstrategy.lctx_binop_right;[reflexivity|constructor].
 - reflexivity.
 - apply read_sqrt_function;exact ES.
 - econstructor;[eapply read_named;[exact LN|exact NORM]|reflexivity|constructor].
 - exact sqrt_funct.
 - reflexivity.
Qed.
Theorem saturation_to_factor:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(factor_state e mnorm k).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_branch m ba bc a maximum k SYM LC LX LY A0 A4)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 rewrite BR in PATH;exists e,mn,bp,bn,bf;split;[exact POINT|].
 eapply star_trans;[exact PATH|apply branch_to_factor_state|reflexivity].
Qed.
Theorem saturation_to_sqrt:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf kc,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_factor m ba bc a maximum k SYM LC LX LY A0 A4 BR)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 destruct(factor_state_to_sqrt e mn bp bn bf ba bc a maximum k POINT)as[kc CALL].
 exists e,mn,bp,bn,bf,kc;split;[exact POINT|].
 eapply star_trans;[exact PATH|exact CALL|reflexivity].
Qed.
Theorem unsaturated_to_skip:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel Sskip k e mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_branch m ba bc a maximum k SYM LC LX LY A0 A4)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 rewrite BR in PATH;exists e,mn,bp,bn,bf;auto.
Qed.
Theorem unsaturated_returns:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->is_call_cont k->
 exists mf,star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(Returnstate Vundef k mf).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR KC.
 destruct(unsaturated_to_skip m ba bc a maximum k SYM LC LX LY A0 A4 BR)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 destruct POINT as[ES[EM[LP[LN[LF[PTR[NORM[LMC[LAX[LAY[SEP FREE]]]]]]]]]]].
 destruct(free_environment ge e mn SEP FREE)as[mf[F REST]];exists mf.
 eapply star_trans;[exact PATH|apply star_one;right;apply Csem.step_skip_call;assumption|reflexivity].
Qed.
Print Assumptions saturation_to_factor.
Print Assumptions saturation_to_sqrt.
Print Assumptions unsaturated_returns.

End Speed.

Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Import P B.
Definition local_point(e:env)(m:mem)(bp bn bf ba bc:block)(a:vector)(maximum:float32):Prop:=
 e!S._five_sqrtf=None /\e!S._gh_max_accel=None /\
 e!S._accel_sp=Some(bp,tptr vt) /\e!S._a_norm2=Some(bn,tfloat) /\e!S._factor=Some(bf,tfloat) /\
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) /\
 Mem.load Mfloat32 m bn 0=Some(Vsingle(norm2 a)) /\
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) /\
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) /\Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) /\
 env_separated e /\
 (forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof ge ty)Cur Freeable).
Theorem saturation_to_branch:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4.

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


 destruct(Mem.valid_access_store mb Mfloat32 bn 0(Vsingle(norm2 a))AN)as[m1 SN].
 assert(NORM:Cstrategy.exec_stmt ge e mb norm_statement E0 m1 Out_normal).
 { unfold norm_statement;eapply write_at_single with(b:=bn)(ofs:=0)(x:=norm2 a).
   - apply Cstrategy.esl_var_local;exact LN.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - unfold norm2;eapply Cstrategy.esr_binop.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LXB].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LXB].
       * reflexivity.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LYB].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LYB].
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
 assert(CMP:Cstrategy.eval_simple_rvalue ge e m1 condition_expr(Val.of_bool(saturation_branch maximum a))).
 { unfold condition_expr,saturation_branch;eapply Cstrategy.esr_binop.
   - eapply read_named;[exact LN|exact LN1].
   - eapply Cstrategy.esr_binop;
     [eapply read_maximum;[exact ENV_M|exact SYM|exact LC1]|
      eapply read_maximum;[exact ENV_M|exact SYM|exact LC1]|reflexivity].
   - reflexivity. }

 assert(FREE1:forall id b ty,e!id=Some(b,ty)->Mem.range_perm m1 b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[intros ch bx ofs p A;eapply Mem.store_valid_access_1;[exact SN|exact A]|eapply FREEB;exact LOOK]. }
 assert(BRANCHPATH:star Csem.step ge
 (State S.f_gh_saturate_accel(Sifthenelse condition_expr sat_branch_statement Sskip)k e m1)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e m1)).
 { eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_ifthenelse_1| |reflexivity].
   eapply star_trans with(t1:=E0)(t2:=E0).
   - apply plus_star;apply Cstrategy.step_simulation;left;eapply Cstrategy.step_expr with(v:=Val.of_bool(saturation_branch maximum a))(ty:=tint).
     + exact CMP.
     + exact I.
     + reflexivity.
   - apply star_one;right;eapply Csem.step_ifthenelse_2;destruct(saturation_branch maximum a);reflexivity.
   - reflexivity. }
 exists e,m1,bp,bn,bf;split.
 - unfold local_point;repeat split;assumption.
 - eapply star_step with(t1:=E0)(t2:=E0);[right;eapply Csem.step_internal_function| |reflexivity].
   + repeat constructor;simpl;intuition discriminate.
   + exact AV.
   + exact BIND.
   + rewrite saturation_body_shape;eapply star_trans with(t1:=E0)(t2:=E0).
     * eapply statement_prefix_path;exact NORM.
     * exact BRANCHPATH.
     * reflexivity.
Qed.

Definition factor_context(hole:expr):expr:=Eassign(Evar S._factor tfloat)(Ebinop Odiv(named_read S._gh_max_accel)hole tfloat)tfloat.
Definition factor_state(e:env)(m:mem)(k:cont):Csem.state:=
 ExprState S.f_gh_saturate_accel(factor_context sqrt_call)(Kdo(Kseq scale_pair k))e m.
Lemma branch_to_factor_state:forall e m k,
 star Csem.step ge(State S.f_gh_saturate_accel sat_branch_statement k e m)E0(factor_state e m k).
Proof.
 intros e m k;unfold sat_branch_statement,factor_statement,factor_state,factor_context.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_seq| |reflexivity].
 apply star_one;right;apply Csem.step_do_1.
Qed.
Lemma factor_state_to_sqrt:forall e m bp bn bf ba bc a maximum k,
 local_point e m bp bn bf ba bc a maximum->
 exists kc,star Csem.step ge(factor_state e m k)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc m).
Proof.
 intros e m bp bn bf ba bc a maximum k POINT.
 destruct POINT as[ES[EM[LP[LN[LF[PTR[NORM[LC[LX[LY REST]]]]]]]]]].
 exists(Kcall S.f_gh_saturate_accel e factor_context tfloat(Kdo(Kseq scale_pair k))).
 apply plus_star;apply Cstrategy.step_simulation;left.
 unfold factor_state,sqrt_call.
 change(Cstrategy.estep ge
 (ExprState S.f_gh_saturate_accel(factor_context(Ecall sqrt_rf(Econs(named_read S._a_norm2)Enil)tfloat))(Kdo(Kseq scale_pair k))e m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)](Kcall S.f_gh_saturate_accel e factor_context tfloat(Kdo(Kseq scale_pair k)))m)).
 eapply Cstrategy.step_call with(vf:=Vptr sqrt_block Ptrofs.zero).
 - unfold factor_context;apply Cstrategy.lctx_assign_right;[reflexivity|].
   apply Cstrategy.lctx_binop_right;[reflexivity|constructor].
 - reflexivity.
 - apply read_sqrt_function;exact ES.
 - econstructor;[eapply read_named;[exact LN|exact NORM]|reflexivity|constructor].
 - exact sqrt_funct.
 - reflexivity.
Qed.
Theorem saturation_to_factor:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(factor_state e mnorm k).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_branch m ba bc a maximum k SYM LC LX LY A0 A4)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 rewrite BR in PATH;exists e,mn,bp,bn,bf;split;[exact POINT|].
 eapply star_trans;[exact PATH|apply branch_to_factor_state|reflexivity].
Qed.
Theorem saturation_to_sqrt:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf kc,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_factor m ba bc a maximum k SYM LC LX LY A0 A4 BR)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 destruct(factor_state_to_sqrt e mn bp bn bf ba bc a maximum k POINT)as[kc CALL].
 exists e,mn,bp,bn,bf,kc;split;[exact POINT|].
 eapply star_trans;[exact PATH|exact CALL|reflexivity].
Qed.
Theorem unsaturated_to_skip:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel Sskip k e mnorm).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR.
 destruct(saturation_to_branch m ba bc a maximum k SYM LC LX LY A0 A4)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 rewrite BR in PATH;exists e,mn,bp,bn,bf;auto.
Qed.
Theorem unsaturated_returns:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->is_call_cont k->
 exists mf,star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(Returnstate Vundef k mf).
Proof.
 intros m ba bc a maximum k SYM LC LX LY A0 A4 BR KC.
 destruct(unsaturated_to_skip m ba bc a maximum k SYM LC LX LY A0 A4 BR)as[e[mn[bp[bn[bf[POINT PATH]]]]]].
 destruct POINT as[ES[EM[LP[LN[LF[PTR[NORM[LMC[LAX[LAY[SEP FREE]]]]]]]]]]].
 destruct(free_environment ge e mn SEP FREE)as[mf[F REST]];exists mf.
 eapply star_trans;[exact PATH|apply star_one;right;apply Csem.step_skip_call;assumption|reflexivity].
Qed.
Print Assumptions saturation_to_factor.
Print Assumptions saturation_to_sqrt.
Print Assumptions unsaturated_returns.

End Accel.
