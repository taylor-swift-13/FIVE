From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From FiveGuidanceSoftwareProof Require Import NumericOps ValueEvaluator ValueChecker LocalMemory FlatStatements ValueSound AssignmentSound ValueStatementSound SourceCertificate FunctionEntry GuardTrace GuardMemorySound.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Definition helper_instrumented_call(ge:Csem.genv)(m:mem)(x:float32):Prop:=
 exists e ma mb bodym mf rho events,
 alloc_variables ge empty_env m helper_declarations e ma /\
 bind_parameters ge e ma(fn_params S.f_five_sqrtf)[Vsingle x]mb /\
 statement_trace S._FiveSqrtBits S._f S._u helper_types 0(PTree.set S._x(Vsingle x)(PTree.empty val))(fn_body S.f_five_sqrtf)=
 Some(ValueReturn(Vsingle(source_derived_sqrt x))tfloat rho,events) /\
 instrumented_execution S._FiveSqrtBits S._f S._u helper_types ge e 0
 (PTree.set S._x(Vsingle x)(PTree.empty val))mb(fn_body S.f_five_sqrtf)
 (ValueReturn(Vsingle(source_derived_sqrt x))tfloat rho)bodym events /\
 Mem.free_list bodym(blocks_of_env ge e)=Some mf /\
 Cstrategy.eval_funcall ge m(Internal S.f_five_sqrtf)[Vsingle x]E0 mf(Vsingle(source_derived_sqrt x)).
Theorem helper_instrumented_funcall:forall ge,
 union_layout S._FiveSqrtBits S._f S._u ge->sizeof ge(Tunion S._FiveSqrtBits noattr)=4->
 forall m x,helper_instrumented_call ge m x.
Proof.
 intros ge LAYOUT SIZE m x.
 destruct(Cexec.do_alloc_variables ge empty_env m helper_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m helper_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge helper_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)helper_declarations->exists b,e!id=Some(b,ty) /\~Mem.valid_block m b /\Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable ge helper_declarations empty_env m id ty helper_nodup IN)as H;rewrite ALLOC in H;destruct H as(b&L&F&V&P);exists b;auto. }
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated ge helper_declarations empty_env m ltac:(intros id b ty H;discriminate H)ltac:(intros id1 id2 b t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge helper_declarations m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&LX&F&P);rewrite LOOK in LX;injection LX as E;subst bx;exact F. }
 assert(FREEA:forall id b ty,e!id=Some(b,ty)->Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge helper_declarations m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&LX&F&P);rewrite LOOK in LX;injection LX as E;subst bx;exact P. }
 assert(ENV:env_matches helper_types e).
 { intros id ty LOOK;destruct(ALL id ty(declaration_types_origin helper_declarations id ty LOOK))as(b&L&F&P);exists b;exact L. }
 assert(WA:locals_writable e ma).
 { intros id b ty LOOK;apply Mem.valid_access_freeable_any;split.
 - intros ofs RANGE;apply(FREEA id b ty LOOK);split;[cbn in RANGE;lia|].
   pose proof(helper_slot_size ge SIZE id ty(allocated_environment_origin ge helper_declarations m e ma AV id b ty LOOK));lia.
 - exists 0;lia. }
 destruct(ALL S._x tfloat ltac:(left;reflexivity))as(bx&LX&FX&PX).
 destruct(Mem.valid_access_store ma Mfloat32 bx 0(Vsingle x)(WA S._x bx tfloat LX))as[mb ST].
 assert(BIND:bind_parameters ge e ma(fn_params S.f_five_sqrtf)[Vsingle x]mb).
 { eapply bind_parameters_cons;[exact LX| |constructor].
 eapply assign_loc_value;[reflexivity|reflexivity|].
 unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact ST|change(0+4<=18446744073709551616);lia]. }
 assert(STA:access_preserved ma mb).
 { intros ch b ofs p A;eapply Mem.store_valid_access_1;eauto. }
 assert(WB:locals_writable e mb)by(eapply locals_writable_after_store;eauto).
 assert(REP:locals_repr(PTree.set S._x(Vsingle x)(PTree.empty val))e mb).
 { intros id b ty v LOOK RHO;rewrite PTree.gsspec in RHO;destruct(peq id S._x);[|discriminate].
 subst id;rewrite LX in LOOK;injection LOOK as B T;subst b ty;injection RHO as V;subst v.
 erewrite Mem.load_store_same by exact ST;reflexivity. }
 assert(INIT:initialized_values S._FiveSqrtBits helper_types[S._x](PTree.set S._x(Vsingle x)(PTree.empty val))).
 { intros id IN;destruct IN as[EQ|IN];[subst id|contradiction].
 exists tfloat,(Vsingle x);split;[exact helper_x|];split;[apply PTree.gss|].
 unfold slot_typed;rewrite dec_eq_false by discriminate;exact I. }

 destruct(checked_instrumented S._FiveSqrtBits S._f S._u helper_types(fn_body S.f_five_sqrtf)tfloat[S._x]StaticReturn 0
 (PTree.set S._x(Vsingle x)(PTree.empty val))ge e mb helper_source actual_helper_certificate ENV LAYOUT SEP REP WB INIT)
 as[o[bodym[t[VALUE[TRACE[EVAL[GOOD[HRES TREE]]]]]]]].
 destruct HRES as[RB[WBODY[KEEP HISTORY]]].
 destruct o as[rr|v ty rr];[contradiction GOOD|].
 destruct GOOD as[TY TV];subst ty.
 destruct v as[|i|l|d|y|b ofs];cbn[typed_value numeric_kind has_kind]in TV;try contradiction.
 assert(RESULT:source_derived_sqrt x=y)by(unfold source_derived_sqrt;rewrite VALUE;reflexivity).
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact KEEP|].
 eapply range_perm_access_preserved;[exact STA|eapply FREEA;exact LOOK]. }
 destruct(free_environment ge e bodym SEP FREEBODY)as[mf[FREE[FRAMEFREE ACCESSFREE]]].
 unfold helper_instrumented_call;exists e,ma,mb,bodym,mf,rr,t;rewrite RESULT.
 split;[exact AV|];split;[exact BIND|];split;[exact TRACE|];split;[exact TREE|];split;[exact FREE|].
 eapply Cstrategy.eval_funcall_internal with(e:=e)(m1:=ma)(m2:=mb)(m3:=bodym)(out:=Out_return(Some(Vsingle y,tfloat))).
 - exact helper_norepet.
 - exact AV.
 - exact BIND.
 - eapply instrumented_erases;exact TREE.
 - econstructor;[discriminate|reflexivity].
 - exact FREE.
Qed.
Definition indexed_helper_execution(ge:Csem.genv)(index:nat)(m:mem):Prop:=
 exists e ma mb bodym mf rho,
 alloc_variables ge empty_env m helper_declarations e ma /\
 bind_parameters ge e ma(fn_params S.f_five_sqrtf)[Vsingle canonical_sat_norm]mb /\
 instrumented_execution S._FiveSqrtBits S._f S._u helper_types ge e 0
 (PTree.set S._x(Vsingle canonical_sat_norm)(PTree.empty val))mb(fn_body S.f_five_sqrtf)
 (ValueReturn(Vsingle(source_derived_sqrt canonical_sat_norm))tfloat rho)bodym canonical_guard_trace /\
 Mem.free_list bodym(blocks_of_env ge e)=Some mf /\
 Cstrategy.eval_funcall ge m(Internal S.f_five_sqrtf)[Vsingle canonical_sat_norm]E0 mf(Vsingle(source_derived_sqrt canonical_sat_norm)) /\
 forall ev,In ev canonical_guard_trace->event_id ev=(index-1)%nat->exists at_memory,
 event_at S._FiveSqrtBits S._f S._u helper_types ge e at_memory ev /\
 nth_error helper_guard_sites(index-1)=Some(event_guard ev) /\
 event_safe S._FiveSqrtBits S._f S._u helper_types ev.
Definition ExecutedHelperGuard(ge:Csem.genv)(index:nat):Prop:=
 HelperGuard index /\forall m,indexed_helper_execution ge index m.
Theorem executed_helper_guard:forall ge,
 union_layout S._FiveSqrtBits S._f S._u ge->sizeof ge(Tunion S._FiveSqrtBits noattr)=4->
 forall index,(1<=index<=53)%nat->ExecutedHelperGuard ge index.
Proof.
 intros ge LAYOUT SIZE index RANGE;split;[apply helper_guard_proved;exact RANGE|];intro m.
 destruct(helper_instrumented_funcall ge LAYOUT SIZE m canonical_sat_norm)
 as[e[ma[mb[bodym[mf[rho[events[AV[BIND[TRACE[TREE[FREE CALL]]]]]]]]]]]].
 assert(T:events=canonical_guard_trace).
 { unfold canonical_guard_trace,helper_trace;rewrite TRACE;reflexivity. }
 subst events;exists e,ma,mb,bodym,mf,rho;split;[exact AV|];split;[exact BIND|];split;[exact TREE|];split;[exact FREE|];split;[exact CALL|].
 intros ev IN ID;destruct(instrumented_events _ _ _ _ _ _ _ _ _ _ _ _ TREE ev IN)as[at_memory AT].
 exists at_memory;split;[exact AT|];split.
 - pose proof canonical_trace_source_linked as LINK;apply Forall_forall with(x:=ev)in LINK;[|exact IN].
   unfold event_source_linked in LINK;rewrite ID in LINK;exact LINK.
 - apply canonical_guards_safe;exact IN.
Qed.
Definition SpeedExecutedHelperGuard:=ExecutedHelperGuard FiveGhSpeed.Execution.ge.
Definition AccelExecutedHelperGuard:=ExecutedHelperGuard FiveGhAccel.Execution.ge.
Theorem speed_executed_helper_guard:forall index,(1<=index<=53)%nat->SpeedExecutedHelperGuard index.
Proof. apply executed_helper_guard;[exact speed_helper_layout|exact speed_helper_size]. Qed.
Theorem accel_executed_helper_guard:forall index,(1<=index<=53)%nat->AccelExecutedHelperGuard index.
Proof. apply executed_helper_guard;[exact accel_helper_layout|exact accel_helper_size]. Qed.
Print Assumptions speed_executed_helper_guard.
Print Assumptions accel_executed_helper_guard.
