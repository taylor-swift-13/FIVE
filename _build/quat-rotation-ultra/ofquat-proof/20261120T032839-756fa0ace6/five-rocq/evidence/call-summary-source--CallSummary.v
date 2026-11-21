From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Base Contract Body Output Call.
Import ListNotations.
Local Open Scope Z_scope.
Lemma stores_frame_other:forall e out m mf,stores e out m mf->forall b z n,
 (b<>out\/z+n<=0\/36<=z)->(forall id ty,e!id=Some(b,ty)->False)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n.
Proof. intros e out m mf ST;induction ST as[m0|m0 mm mf ch bx ofs value PATH IH TARGET STORE];intros b z n BO ENV.
 - reflexivity.
 - erewrite Mem.loadbytes_store_other;[apply IH;assumption|exact STORE|].
 destruct TARGET as[[EQ[LO HI]]|[id[ty LOOK]]].
 + subst bx;destruct BO as[NE|[LEFT|RIGHT]];[left;exact NE|right;right;lia|right;left;lia].
 + left;intro EQ;subst bx;exact(ENV id ty LOOK). Qed.
Theorem call_summary:forall m q out qi qx qy qz,
 Inputs m q out qi qx qy qz->
 exists mf,state_eval Execution.ge(Execution.entry(Args out q)m)=Some(Vundef,mf) /\
 (forall b z n,Mem.valid_block m b->(b<>out\/z+n<=0\/36<=z)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n) /\
 Mem.loadbytes mf out 0 36=Some(matrix_bytes(matrix_values qi qx qy qz)).
Proof.
 intros m q out qi qx qy qz IN.
 assert(VQ:Mem.valid_block m q).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(lqi _ _ _ _ _ _ _ IN)|constructor]. }
 assert(VO:Mem.valid_block m out).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(wout _ _ _ _ _ _ _ IN 0 ltac:(simpl;tauto))|constructor]. }
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m decls)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m decls e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge decls empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)decls->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IX;pose proof(allocated_variable Execution.ge decls empty_env m id ty decls_nodup IX)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&P);exists bx;auto. }
 destruct(ALL Source._rm rmtype ltac:(left;reflexivity))as[br[LR[FR RR]]].
 destruct(ALL Source._q qtype ltac:(right;left;reflexivity))as[bq[LQ[FQ RQ]]].
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge decls empty_env m ltac:(intros id bx ty H;discriminate)ltac:(intros id1 id2 bx t1 t2 H;discriminate))as H;rewrite ALLOC in H;exact H. }
 assert(QR:bq<>br).
 { intro EQ;subst bq;pose proof(SEP _ _ _ _ _ LQ LR);discriminate. }
 assert(NL:Nonlocal e q out).
 { intros id b ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge decls m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;split;intro EQ;subst b;auto. }
 assert(DEFS:locals_defined e).
 { intros id IX;destruct(ALL id tfloat)as(b&L&F&P);[|exists b;exact L].
   cbn in IX;repeat(destruct IX as[<-|IX];[unfold decls;cbn[fn_params fn_vars Source.f_float_rmat_of_quat app];simpl;tauto|]);contradiction. }
 assert(OUTENV:forall b,Mem.valid_block m b->forall id ty,e!id=Some(b,ty)->False).
 { intros b VB id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge decls m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;auto. }
 assert(WR:Mem.valid_access ma Mptr br 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros z Z;apply RR;change(0<=z<8);exact Z|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr br 0(Vptr out Ptrofs.zero)WR)as[mb SR].
 assert(WQ:Mem.valid_access mb Mptr bq 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SR|]. apply Mem.valid_access_freeable_any;split;[intros z Z;apply RQ;change(0<=z<8);exact Z|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mptr bq 0(Vptr q Ptrofs.zero)WQ)as[mc SQ].
 assert(BIND:bind_parameters Execution.ge e ma(fn_params Source.f_float_rmat_of_quat)(Args out q)mc).
 { eapply bind_parameters_cons;[exact LR| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SR.
 - eapply bind_parameters_cons;[exact LQ| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SQ. }
 assert(REP:local_repr(rho0 q out)e mc).
 { intros id b ty value LOOK VAL;unfold rho0 in VAL;rewrite PTree.gsspec in VAL;destruct(peq id Source._q)as[EQ|NE].
 - subst id;rewrite LQ in LOOK;injection LOOK as B T;subst b ty;injection VAL as V;subst value;erewrite Mem.load_store_same by exact SQ;reflexivity.
 - rewrite PTree.gsspec in VAL;destruct(peq id Source._rm)as[EQ|NE2].
 + subst id;rewrite LR in LOOK;injection LOOK as B T;subst b ty;injection VAL as V;subst value;erewrite Mem.load_store_other by(exact SQ||(left;congruence));erewrite Mem.load_store_same by exact SR;reflexivity.
 + discriminate. }
 assert(INA:Inputs ma q out qi qx qy qz).
 { constructor.
 - exact(qo _ _ _ _ _ _ _ IN).
 - pose proof(allocation_load Execution.ge decls empty_env m Mfloat32 q 0(Vsingle qi)(lqi _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge decls empty_env m Mfloat32 q 4(Vsingle qx)(lqx _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge decls empty_env m Mfloat32 q 8(Vsingle qy)(lqy _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - pose proof(allocation_load Execution.ge decls empty_env m Mfloat32 q 12(Vsingle qz)(lqz _ _ _ _ _ _ _ IN))as H;rewrite ALLOC in H;exact H.
 - intros ofs IX;pose proof(allocation_access Execution.ge decls empty_env m _ _ _ _ (wout _ _ _ _ _ _ _ IN ofs IX))as H;rewrite ALLOC in H;exact H. }
 assert(INC:Inputs mc q out qi qx qy qz).
 { eapply inputs_store_local with(b:=bq);[|intro EQ;subst bq;auto|exact SQ].
   eapply inputs_store_local with(b:=br);[exact INA|intro EQ;subst br;auto|exact SR]. }
 assert(FREEC:freeable e mc).
 { intros id b ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge decls m e ma AV id b ty LOOK))as(bx&L&F&P);rewrite LOOK in L;injection L as B;subst bx;intros z Z;eapply Mem.perm_store_1;[exact SQ|];eapply Mem.perm_store_1;[exact SR|];apply P;exact Z. }
 assert(WRITE:local_write e mc).
 { intros id b ty LOOK;pose proof(allocated_environment_origin Execution.ge decls m e ma AV id b ty LOOK)as IX.
 assert(TY:ty=rmtype\/ty=qtype\/ty=tfloat).
 { unfold decls in IX;cbn[fn_params fn_vars Source.f_float_rmat_of_quat]in IX;repeat destruct IX as[IX|IX];try contradiction;injection IX as E T;subst;tauto. }
 destruct TY as [T|[T|T]];subst ty;apply Mem.valid_access_freeable_any;split;
 try(exists 0;lia);intros z Z;apply(FREEC id b _ LOOK);exact Z. }
 assert(CT:Context e q out qi qx qy qz(rho0 q out)mc)by(constructor;assumption).
 destruct(full_body e q out qi qx qy qz bq br mc SEP NL DEFS LQ LR CT)as[md[BODY[CTD[STORES[ml OUTPUT]]]]].
 destruct(free_environment Execution.ge e md SEP(context_free _ _ _ _ _ _ _ _ _ CTD))as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m decls with(ea,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world ea mm(fn_params Source.f_float_rmat_of_quat)(Args out q)with
 |Some bound=>match stmt_eval Execution.ge ea tvoid(fn_body Source.f_float_rmat_of_quat)bound with
 |Some(oo,mbody)=>cont_eval Execution.ge ea tvoid Kstop oo mbody|None=>None end|None=>None end end)=Some(Vundef,mf)).
 rewrite ALLOC,(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma(fn_params Source.f_float_rmat_of_quat)(Args out q)mc BIND),BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
 + intros b z n VB BO;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b VB)).
 assert(FRAMED:Mem.loadbytes md b z n=Mem.loadbytes mc b z n)by(exact(stores_frame_other e out mc md STORES b z n BO(OUTENV b VB))).
 rewrite FRAMED.
 erewrite Mem.loadbytes_store_other by(exact SQ||(left;intro EQ;subst bq;auto)).
 erewrite Mem.loadbytes_store_other by(exact SR||(left;intro EQ;subst br;auto)).
 pose proof(allocation_bytes_frame Execution.ge decls empty_env m b z n VB)as H;rewrite ALLOC in H;exact H.
 + erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV out VO));exact(nine_stores_bytes ml out(matrix_values qi qx qy qz)md OUTPUT).
Qed.
Print Assumptions call_summary.
