From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import LowpassMemory.
From FiveQuatVmult Require Import Source Execution.
From FiveQuatVmultCase Require Import Contract Body.
Import ListNotations.
Local Open Scope Z_scope.
Lemma declares_nodup:NoDup(map fst declares).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma stores_frame:forall e out m mf,stores e out m mf->forall b z n,
 (b<>out\/z+n<=0\/12<=z)->(forall id ty,e!id=Some(b,ty)->False)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n.
Proof. intros e out m mf ST;induction ST as[m0|m0 mm mf ch bx ofs value PATH IH TARGET STORE];intros b z n BO ENV.
 - reflexivity.
 - erewrite Mem.loadbytes_store_other;[apply IH;assumption|exact STORE|].
 destruct TARGET as[[EQ[LO HI]]|[id[ty LOOK]]].
 + subst bx;destruct BO as[NE|[LEFT|RIGHT]];[left;exact NE|right;right;left;lia|right;right;right;lia].
 + left;intro EQ;subst bx;exact(ENV id ty LOOK). Qed.
Lemma stores_access:forall e out m mf,stores e out m mf->access_kept m mf.
Proof. intros e out m mf H;induction H;intros chunk bx z p A;[exact A|eapply Mem.store_valid_access_1;eauto]. Qed.
Lemma stores_load:forall e out m mf,stores e out m mf->forall ch b z,
 b<>out->(forall id ty,e!id=Some(b,ty)->False)->Mem.load ch mf b z=Mem.load ch m b z.
Proof. intros e out m mf H;induction H;intros chunk bx z BO ENV;[reflexivity|].
 erewrite Mem.load_store_other;[apply IHstores;assumption|exact H1|left].
 destruct H0 as[[EQ L]|[id[ty LOOK]]];[congruence|intro EQ;subst;exact(ENV id ty LOOK)]. Qed.
Theorem call_summary:forall m q v out qi qx qy qz vx vy vz,
 Inputs m q v out qi qx qy qz vx vy vz->
 exists mf,state_eval Execution.ge(Execution.entry(Args out q v)m)=Some(Vundef,mf) /\
 (forall b z n,Mem.valid_block m b->(b<>out\/z+n<=0\/12<=z)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n) /\
 Mem.loadbytes mf out 0 12=Some(encode_val Mfloat32(Vsingle(output_x qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(output_y qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(output_z qi qx qy qz vx vy vz))) /\
 access_kept m mf /\(forall ch b z,Mem.valid_block m b->b<>out->Mem.load ch mf b z=Mem.load ch m b z).
Proof.
 intros m q v out qi qx qy qz vx vy vz IN.
 assert(VQ:Mem.valid_block m q)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(lqi _ _ _ _ _ _ _ _ _ _ _ IN)|constructor]).
 assert(VV:Mem.valid_block m v)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(lvx _ _ _ _ _ _ _ _ _ _ _ IN)|constructor]).
 assert(VO:Mem.valid_block m out)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(wout _ _ _ _ _ _ _ _ _ _ _ IN 0 ltac:(simpl;tauto))|constructor]).
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m declares)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m declares e ma)by(pose proof(Cexec.do_alloc_variables_sound Execution.ge declares empty_env m)as H;rewrite ALLOC in H;exact H).
 assert(ALL:forall id ty,In(id,ty)declares->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IX;pose proof(allocated_variable Execution.ge declares empty_env m id ty declares_nodup IX)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&P);exists bx;auto. }
 destruct(ALL Source._v_out vtype ltac:(left;reflexivity))as[bo[LO[FO RO]]].
 destruct(ALL Source._q qtype ltac:(right;left;reflexivity))as[bq[LQ[FQ RQ]]].
 destruct(ALL Source._v_in vtype ltac:(right;right;left;reflexivity))as[bv[LV[FV RV]]].
 assert(SEP:env_separated e)by(pose proof(allocation_env_separated Execution.ge declares empty_env m ltac:(intros id bx ty H;discriminate)ltac:(intros id1 id2 bx t1 t2 H;discriminate))as H;rewrite ALLOC in H;exact H).
 assert(OQ:bo<>bq)by(intro EQ;subst;pose proof(SEP _ _ _ _ _ LO LQ);discriminate).
 assert(OV:bo<>bv)by(intro EQ;subst;pose proof(SEP _ _ _ _ _ LO LV);discriminate).
 assert(QV:bq<>bv)by(intro EQ;subst;pose proof(SEP _ _ _ _ _ LQ LV);discriminate).
 assert(OUTENV:forall b,Mem.valid_block m b->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declares m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;auto. }
 assert(NL:Nonlocal e q v out).
 { intros id b ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declares m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;repeat split;intro EQ;subst b;auto. }
 assert(DEFS:env_matches e)by(intros id ty IX;destruct(ALL id ty IX)as(b&L&F&P);exists b;exact L).
 assert(WO:Mem.valid_access ma Mptr bo 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros z Z;apply RO;change(0<=z<8);exact Z|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr bo 0(Vptr out Ptrofs.zero)WO)as[mb SO].
 assert(WQ:Mem.valid_access mb Mptr bq 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros z Z;apply RQ;change(0<=z<8);exact Z|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mptr bq 0(Vptr q Ptrofs.zero)WQ)as[mc SQ].
 assert(WV:Mem.valid_access mc Mptr bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SQ|];eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros z Z;apply RV;change(0<=z<8);exact Z|exists 0;lia]. }
 destruct(Mem.valid_access_store mc Mptr bv 0(Vptr v Ptrofs.zero)WV)as[md SV].
 assert(BIND:bind_parameters Execution.ge e ma(fn_params Source.f_float_quat_vmult)(Args out q v)md).
 { eapply bind_parameters_cons;[exact LO| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|];unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SO.
 - eapply bind_parameters_cons;[exact LQ| |].
 + eapply assign_loc_value;[reflexivity|reflexivity|];unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SQ.
 + eapply bind_parameters_cons;[exact LV| |constructor];eapply assign_loc_value;[reflexivity|reflexivity|];unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SV. }
 assert(REP:local_repr(qparam q v out)e md).
 { intros id b ty value LOOK VAL;unfold qparam in VAL;rewrite PTree.gsspec in VAL;destruct(peq id Source._v_out)as[EQ|NE].
 - subst id;rewrite LO in LOOK;injection LOOK as B T;subst b ty;injection VAL as V;subst value;erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_other by(exact SQ||(left;congruence));erewrite Mem.load_store_same by exact SO;reflexivity.
 - rewrite PTree.gsspec in VAL;destruct(peq id Source._q)as[EQ|NE2].
 + subst id;rewrite LQ in LOOK;injection LOOK as B T;subst b ty;injection VAL as V;subst value;erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_same by exact SQ;reflexivity.
 + rewrite PTree.gsspec in VAL;destruct(peq id Source._v_in)as[EQ|NE3];[|discriminate]. subst id;rewrite LV in LOOK;injection LOOK as B T;subst b ty;injection VAL as V;subst value;erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(INA:Inputs ma q v out qi qx qy qz vx vy vz).
 { constructor.
 - exact(qv _ _ _ _ _ _ _ _ _ _ _ IN).
 - exact(qo _ _ _ _ _ _ _ _ _ _ _ IN).
 - exact(vo _ _ _ _ _ _ _ _ _ _ _ IN).
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 q 0(Vsingle qi)(lqi _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 q 4(Vsingle qx)(lqx _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 q 8(Vsingle qy)(lqy _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 q 12(Vsingle qz)(lqz _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 v 0(Vsingle vx)(lvx _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 v 4(Vsingle vy)(lvy _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 v 8(Vsingle vz)(lvz _ _ _ _ _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - intros ofs IX;pose proof(allocation_access Execution.ge declares empty_env m _ _ _ _(wout _ _ _ _ _ _ _ _ _ _ _ IN ofs IX))as H;rewrite ALLOC in H;exact H. }
 assert(IND:Inputs md q v out qi qx qy qz vx vy vz).
 { eapply inputs_store_local with(b:=bv);[|intro EQ;subst bv;auto|intro EQ;subst bv;auto|exact SV].
 eapply inputs_store_local with(b:=bq);[|intro EQ;subst bq;auto|intro EQ;subst bq;auto|exact SQ].
 eapply inputs_store_local with(b:=bo);[exact INA|intro EQ;subst bo;auto|intro EQ;subst bo;auto|exact SO]. }
 assert(FREED:freeable e md).
 { intros id b ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declares m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;intros z Z;eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SQ|];eapply Mem.perm_store_1;[exact SO|];apply P;exact Z. }
 assert(WRITE:local_write e md).
 { intros id b ty LOOK;pose proof(allocated_environment_origin Execution.ge declares m e ma AV id b ty LOOK)as IX.
 assert(TY:ty=vtype\/ty=qtype\/ty=tfloat).
 { unfold declares in IX;cbn[fn_params fn_vars Source.f_float_quat_vmult]in IX;repeat destruct IX as[IX|IX];try contradiction;injection IX as E T;subst;tauto. }
 destruct TY as[T|[T|T]];subst ty;apply Mem.valid_access_freeable_any;split;try(exists 0;lia);intros z Z;apply(FREED id b _ LOOK);exact Z. }
 assert(CT:Context e q v out qi qx qy qz vx vy vz(qparam q v out)md)by(constructor;assumption).
 destruct(body_summary e md q v out qi qx qy qz vx vy vz DEFS SEP NL CT)as[me[BODY[CTE[HIST[m1[m2[S1[S2[ml S0]]]]]]]]].
 destruct(free_environment Execution.ge e me SEP(context_free _ _ _ _ _ _ _ _ _ _ _ _ _ CTE))as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m declares with(ea,mm)=>match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world ea mm(fn_params Source.f_float_quat_vmult)(Args out q v)with Some bound=>match stmt_eval Execution.ge ea tvoid(fn_body Source.f_float_quat_vmult)bound with Some(oo,body)=>cont_eval Execution.ge ea tvoid Kstop oo body|None=>None end|None=>None end end)=Some(Vundef,mf)).
 rewrite ALLOC,(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma(fn_params Source.f_float_quat_vmult)(Args out q v)md BIND),BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
 + intros b z n VB BO;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b VB));rewrite(stores_frame e out md me HIST b z n BO(OUTENV b VB)).
 erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst bv;auto));erewrite Mem.loadbytes_store_other by(exact SQ||(left;intro EQ;subst bq;auto));erewrite Mem.loadbytes_store_other by(exact SO||(left;intro EQ;subst bo;auto)).
 pose proof(allocation_bytes_frame Execution.ge declares empty_env m b z n VB)as H;rewrite ALLOC in H;exact H.
 + split.
 * erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV out VO)).
 apply(three_stores_bytes ml out Ptrofs.zero _ _ _ me);exists m1,m2;rewrite ?Ptrofs.unsigned_zero;repeat split;auto.
 * split.
 -- intros ch b z p A;assert(VB:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact A|constructor]).
 apply(ACCESS ch b z p(OUTENV b VB));apply(stores_access _ _ _ _ HIST);eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SQ|];eapply Mem.store_valid_access_1;[exact SO|].
 pose proof(allocation_access Execution.ge declares empty_env m ch b z p A)as H;rewrite ALLOC in H;exact H.
 -- intros ch b z VB BO;rewrite(KEEP ch b z(OUTENV b VB)),(stores_load e out md me HIST ch b z BO(OUTENV b VB)).
 erewrite Mem.load_store_other by(exact SV||(left;intro EQ;subst bv;auto));erewrite Mem.load_store_other by(exact SQ||(left;intro EQ;subst bq;auto));erewrite Mem.load_store_other by(exact SO||(left;intro EQ;subst bo;auto)).
 pose proof(allocation_load_frame Execution.ge declares empty_env m ch b z VB)as H;rewrite ALLOC in H;exact H.
Qed.
Print Assumptions call_summary.
