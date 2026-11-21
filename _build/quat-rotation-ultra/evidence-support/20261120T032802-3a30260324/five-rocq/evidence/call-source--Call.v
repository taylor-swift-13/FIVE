From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions LowpassMemory Straightline.
From FiveRmatVmult Require Import Source Execution.
From FiveRmatVmultCase Require Import Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition declarations:=fn_params Source.f_float_rmat_vmult.
Lemma declarations_nodup:NoDup(map fst declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem call_summary:forall m bo br bv po pr pv f v,
 bo<>br->bo<>bv->br<>bv->writable12 m bo po->Reads m br pr 9 f->Reads m bv pv 3 v->
 exists mf,state_eval Execution.ge(Execution.entry(Args bo br bv po pr pv)m)=Some(Vundef,mf) /\
 Mem.loadbytes mf bo(Ptrofs.unsigned po)12=Some(encode_val Mfloat32(Vsingle(Row f v 0))++encode_val Mfloat32(Vsingle(Row f v 3))++encode_val Mfloat32(Vsingle(Row f v 6))) /\
 Frame m mf bo po /\writable12 mf bo po.
Proof.
 intros m bo br bv po pr pv f v OR OV RV W RM RI.
 assert(OBJ:Mem.valid_block m bo).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply field_access;[exact W|simpl;auto]|constructor]. }
 pose proof(read_valid m br pr 9 f ltac:(lia) RM)as MR.
 pose proof(read_valid m bv pv 3 v ltac:(lia) RI)as VI.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge declarations empty_env m id ty declarations_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&Q);exists bx;auto. }
 destruct(ALL Source._vb(tptr vt)ltac:(left;reflexivity))as(bpo&EO&FO&PO).
 destruct(ALL Source._m_a2b(tptr rt)ltac:(right;left;reflexivity))as(bpr&ER&FR&PR).
 destruct(ALL Source._va(tptr vt)ltac:(right;right;left;reflexivity))as(bpv&EV&FV&PV).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(ORP:bpo<>bpr)by(intro EQ;subst bpo;pose proof(SEP _ _ _ _ _ EO ER);discriminate).
 assert(OVP:bpo<>bpv)by(intro EQ;subst bpo;pose proof(SEP _ _ _ _ _ EO EV);discriminate).
 assert(RVP:bpr<>bpv)by(intro EQ;subst bpr;pose proof(SEP _ _ _ _ _ ER EV);discriminate).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(WO:Mem.valid_access ma Mptr bpo 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PO;change(0<=ofs<8);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr bpo 0(Vptr bo po)WO)as[mb SO].
 assert(WR:Mem.valid_access mb Mptr bpr 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PR;change(0<=ofs<8);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mptr bpr 0(Vptr br pr)WR)as[mc SR].
 assert(WV:Mem.valid_access mc Mptr bpv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SR|];eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PV;change(0<=ofs<8);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store mc Mptr bpv 0(Vptr bv pv)WV)as[md SV].
 assert(BIND:bind_parameters Execution.ge e ma declarations(Args bo br bv po pr pv)md).
 { eapply bind_parameters_cons;[exact EO| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SO.
 - eapply bind_parameters_cons;[exact ER| |].
   + eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SR.
   + eapply bind_parameters_cons;[exact EV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SV. }
 assert(LO:Mem.load Mptr md bpo 0=Some(Vptr bo po)).
 { erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_other by(exact SR||(left;congruence));erewrite Mem.load_store_same by exact SO;reflexivity. }
 assert(LR:Mem.load Mptr md bpr 0=Some(Vptr br pr)).
 { erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_same by exact SR;reflexivity. }
 assert(LV:Mem.load Mptr md bpv 0=Some(Vptr bv pv)).
 { erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(WA:writable12 ma bo po)by(pose proof(writable_alloc declarations empty_env m bo po W)as H;rewrite ALLOC in H;exact H).
 assert(WD:writable12 md bo po)by(eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[|exact SR];eapply store_preserves_writable12;[exact WA|exact SO]).
 assert(RMA:Reads ma br pr 9 f)by(pose proof(reads_alloc declarations empty_env m br pr 9 f RM)as H;rewrite ALLOC in H;exact H).
 assert(RIA:Reads ma bv pv 3 v)by(pose proof(reads_alloc declarations empty_env m bv pv 3 v RI)as H;rewrite ALLOC in H;exact H).
 assert(RMD:Reads md br pr 9 f).
 { eapply reads_store;[| |exact SV];[|congruence]. eapply reads_store;[| |exact SR];[|congruence]. eapply reads_store;[exact RMA| |exact SO];congruence. }
 assert(RID:Reads md bv pv 3 v).
 { eapply reads_store;[| |exact SV];[|congruence]. eapply reads_store;[| |exact SR];[|congruence]. eapply reads_store;[exact RIA| |exact SO];congruence. }
 destruct(three_stores_exist md bo po(Row f v 0)(Row f v 3)(Row f v 6)WD)as[me STORES].
 assert(BODY:stmt_eval Execution.ge e tvoid(fn_body Source.f_float_rmat_vmult)md=Some(Nnormal,me)).
 { eapply body_eval;eauto;congruence. }
 destruct STORES as[m1[m2[S0[S1 S2]]]].
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm me bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply Mem.perm_store_1;[exact S2|];eapply Mem.perm_store_1;[exact S1|];eapply Mem.perm_store_1;[exact S0|];eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SR|];eapply Mem.perm_store_1;[exact SO|];apply Q;exact RANGE. }
 destruct(free_environment Execution.ge e me SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 assert(STORES:three_stores md bo po(Row f v 0)(Row f v 3)(Row f v 6)me)by(exists m1,m2;auto).
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m declarations with(le,mm)=>match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm declarations(Args bo br bv po pr pv)with
 |Some bound=>match stmt_eval Execution.ge le tvoid(fn_body Source.f_float_rmat_vmult)bound with Some(out,body)=>cont_eval Execution.ge le tvoid Kstop out body|None=>None end|None=>None end end)=Some(Vundef,mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m declarations=(e,ma))in ALLOC;rewrite ALLOC,(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma declarations(Args bo br bv po pr pv)md BIND),BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
   + erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV bo OBJ));apply(three_stores_bytes _ _ _ _ _ _ _ STORES).
   + split.
     * intros q z n VB OUT;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VB)).
       rewrite(three_stores_frame _ _ _ _ _ _ _ STORES q z n OUT).
       erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst q;exact(FV VB))).
       erewrite Mem.loadbytes_store_other by(exact SR||(left;intro EQ;subst q;exact(FR VB))).
       erewrite Mem.loadbytes_store_other by(exact SO||(left;intro EQ;subst q;exact(FO VB))).
       pose proof(allocation_bytes_frame Execution.ge declarations empty_env m q z n VB)as H;rewrite ALLOC in H;exact H.
     * pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ WD S0)as W1.
       pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ W1 S1)as W2.
       pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ W2 S2)as WE.
       destruct WE as[AL[NW Q]];split;[exact AL|];split;[exact NW|]. eapply range_perm_access_preserved_block;[|exact Q].
       intros ch ofs perm VA;apply(ACCESS ch bo ofs perm(OUTENV bo OBJ));exact VA.
Qed.
Print Assumptions call_summary.
