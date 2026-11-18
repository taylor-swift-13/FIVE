From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From FiveGuidanceSoftwareProof Require Import NumericOps ValueEvaluator ValueChecker LocalMemory FlatStatements ValueSound AssignmentSound ValueStatementSound SourceCertificate.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S := FiveGhSpeed.Source.
Lemma declaration_types_origin:forall ds id ty,
 (declaration_types ds)!id=Some ty ->In(id,ty)ds.
Proof.
 induction ds as[|[head ht]ds IH];intros id ty LOOK;cbn[declaration_types]in LOOK;[discriminate|].
 rewrite PTree.gsspec in LOOK;destruct(peq id head).
 - subst id;injection LOOK as E;subst ht;left;reflexivity.
 - right;apply IH;exact LOOK.
Qed.
Lemma helper_nodup:NoDup(map fst helper_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma helper_norepet:list_norepet(map fst helper_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma helper_x:helper_types!S._x=Some tfloat.
Proof. reflexivity. Qed.
Lemma helper_source:source_statement(fn_body S.f_five_sqrtf)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma helper_slot_size:forall(ge:Csem.genv),sizeof ge(Tunion S._FiveSqrtBits noattr)=4 ->
 forall id ty,In(id,ty)helper_declarations ->size_chunk(slot_chunk ty)<=sizeof ge ty.
Proof.
 intros ge SIZE id ty IN.
 change(In(id,ty)[(S._x,tfloat);(S._view,Tunion S._FiveSqrtBits noattr);(S._magnitude,tuint);(S._exponent_bits,tuint);(S._mantissa,tuint);(S._exponent,tint);(S._result_exponent,tint);(S._radicand,tulong);(S._pair,tuint);(S._remainder,tuint);(S._trial,tuint);(S._root,tuint)])in IN.
 repeat destruct IN as[EQ|IN];try contradiction;injection EQ as E T;subst id ty;try(change(4<=4);lia);try(change(8<=8);lia).
 change(4<=sizeof ge(Tunion S._FiveSqrtBits noattr));rewrite SIZE;lia.
Qed.
Lemma stores_to_bytes_frame:forall P m mf,stores_to P m mf ->
 forall b ofs n,~P b->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros P m mf H;induction H;intros bx ox n NP;[reflexivity|].
 rewrite IHstores_to by exact NP.
 erewrite Mem.loadbytes_store_other by(exact H0||(left;intro EQ;subst;contradiction));reflexivity.
Qed.

Theorem helper_funcall:forall(ge:Csem.genv),
 union_layout S._FiveSqrtBits S._f S._u ge ->sizeof ge(Tunion S._FiveSqrtBits noattr)=4 ->
 forall m x,exists mf,
 Cstrategy.eval_funcall ge m(Internal S.f_five_sqrtf)[Vsingle x]E0 mf(Vsingle(source_derived_sqrt x)) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
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
 destruct(checked_statement_exec S._FiveSqrtBits S._f S._u helper_types(fn_body S.f_five_sqrtf)tfloat[S._x]StaticReturn
 (PTree.set S._x(Vsingle x)(PTree.empty val))ge e mb helper_source actual_helper_certificate ENV LAYOUT SEP REP WB INIT)
 as[o[bodym[VALUE[BODY[GOOD[RB[WBODY[KEEP HISTORY]]]]]]]].
 destruct o as[rho|v ty rho];[contradiction GOOD|].
 destruct GOOD as[TY TV];subst ty.
 destruct v as[|i|l|d|y|b ofs];cbn[typed_value numeric_kind has_kind]in TV;try contradiction.
 assert(RESULT:source_derived_sqrt x=y).
 { unfold source_derived_sqrt;rewrite VALUE;reflexivity. }
 assert(FREEBODY:forall id b ty,e!id=Some(b,ty)->Mem.range_perm bodym b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;eapply range_perm_access_preserved;[exact KEEP|].
 eapply range_perm_access_preserved;[exact STA|eapply FREEA;exact LOOK]. }
 destruct(free_environment ge e bodym SEP FREEBODY)as[mf[FREE[FRAMEFREE ACCESSFREE]]].
 assert(OUT:forall b,Mem.valid_block m b->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;exact(FRESH id b ty LOOK VB). }
 assert(NOTLOCAL:forall b,Mem.valid_block m b->~local_blocks e b).
 { intros b VB[id[ty LOOK]];exact(OUT b VB id ty LOOK). }
 exists mf;split.
 - rewrite RESULT;eapply Cstrategy.eval_funcall_internal with(e:=e)(m1:=ma)(m2:=mb)(m3:=bodym)(out:=Out_return(Some(Vsingle y,tfloat))).
 + exact helper_norepet.
 + exact AV.
 + exact BIND.
 + exact BODY.
 + econstructor;[discriminate|reflexivity].
 + exact FREE.
 - split.
 + intros ch b ofs p A.
   assert(VB:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact A|constructor]).
   apply ACCESSFREE;[apply OUT;exact VB|].apply KEEP;apply STA.
   pose proof(allocation_access ge helper_declarations empty_env m ch b ofs p A)as H;rewrite ALLOC in H;exact H.
 + split.
 * intros ch b ofs VB;rewrite FRAMEFREE by(apply OUT;exact VB).
   rewrite(stores_to_load_frame _ _ _ HISTORY ch b ofs(NOTLOCAL b VB)).
   erewrite Mem.load_store_other by(exact ST||(left;intro EQ;subst bx;apply FX;exact VB)).
   pose proof(allocation_load_frame ge helper_declarations empty_env m ch b ofs VB)as H;rewrite ALLOC in H;exact H.
 * intros b ofs n VB.
   rewrite(free_environment_bytes_frame ge e bodym mf FREE b ofs n)by(apply OUT;exact VB).
   rewrite(stores_to_bytes_frame _ _ _ HISTORY b ofs n(NOTLOCAL b VB)).
   erewrite Mem.loadbytes_store_other by(exact ST||(left;intro EQ;subst bx;apply FX;exact VB)).
   pose proof(allocation_bytes_frame ge helper_declarations empty_env m b ofs n VB)as H;rewrite ALLOC in H;exact H.
Qed.
Print Assumptions helper_funcall.
