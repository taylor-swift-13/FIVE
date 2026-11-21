From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions Straightline.
From FivePprzFloatMatInv3d Require Import Source Execution.
From FiveMatInv3Case Require Import MatrixMemory MatrixAccess Scalar LocalMemory Expression Output Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition declarations:=fn_params Source.f_float_mat_inv_3d++fn_vars Source.f_float_mat_inv_3d.
Lemma declarations_nodup:NoDup(map fst declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma prefix_declarations:forall id rhs,In(id,rhs)Prefix->In(id,tfloat)declarations.
Proof. intros id rhs IN;unfold Prefix in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;subst;vm_compute;tauto. Qed.
Lemma reads_alloc:forall vars e m b p n f,Reads m b p n f->Reads(snd(Cexec.do_alloc_variables Execution.ge e m vars))b p n f.
Proof. intros vars e m b p n f[AL[NW RD]];repeat split;auto;intros i B;eapply allocation_load;apply RD;exact B. Qed.
Lemma write_alloc:forall vars e m b p n,WriteRegion m b p n->WriteRegion(snd(Cexec.do_alloc_variables Execution.ge e m vars))b p n.
Proof. intros vars e m b p n[AL[NW RP]];repeat split;auto;intros z B;eapply allocation_perm;apply RP;exact B. Qed.
Lemma allocation_blocks:forall vars e m b,Mem.valid_block m b->Mem.valid_block(snd(Cexec.do_alloc_variables Execution.ge e m vars))b.
Proof. induction vars as[|[id ty]vars IH];intros e m b VB;cbn[Cexec.do_alloc_variables];[exact VB|].
 destruct(Mem.alloc m 0(sizeof Execution.ge ty))as[ma fresh]eqn:A;apply IH;eapply Mem.valid_block_alloc;eauto. Qed.
Lemma writes_nextblock:forall xs m b z mf,Writes m b z xs mf->Mem.nextblock mf=Mem.nextblock m.
Proof. induction xs as[|[i x]xs IH];intros m b z mf W;cbn[Writes]in W;[subst mf;reflexivity|].
 destruct W as[m1[ST REST]];rewrite(IH m1 b z mf REST);eapply Mem.nextblock_store;exact ST. Qed.
Lemma free_list_nextblock:forall regions m mf,Mem.free_list m regions=Some mf->Mem.nextblock mf=Mem.nextblock m.
Proof. induction regions as[|[[b lo]hi]regions IH];intros m mf F;cbn[Mem.free_list]in F;[injection F as<-;reflexivity|].
 destruct(Mem.free m b lo hi)as[m1|]eqn:ONE;try discriminate;rewrite(IH m1 mf F);eapply Mem.nextblock_free;exact ONE. Qed.
Lemma outputs_range:forall f i x,In(i,x)(Outputs f)->0<=i<9.
Proof. intros f i x IN;unfold Outputs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia. Qed.
Lemma outputs_nodup:forall f,NoDup(map fst(Outputs f)).
Proof. intros f;cbn[Outputs];repeat constructor;simpl;intuition discriminate. Qed.
Lemma outputs_member:forall f i,0<=i<9->In(i,Output f i)(Outputs f).
Proof. intros f i B;assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;repeat destruct H as[H|H];subst i;unfold Outputs;repeat(first[left;reflexivity|right]). Qed.
Theorem call_summary:forall m bo bi po pi f,
 bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 exists mf,state_eval Execution.ge(Execution.entry(Args bo bi po pi)m)=Some(Status f,mf) /\
 OutputBytes m mf bo po f /\ Frame m mf bo po /\ WriteRegion mf bo po 9 /\ OldBlocks m mf /\ OldAccess m mf.
Proof.
 intros m bo bi po pi f NE W RD.
 pose proof(writable_valid m bo po 9 ltac:(lia) W)as VO.
 pose proof(reads_valid m bi pi 9 f ltac:(lia) RD)as VI.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)declarations->exists bx,e!id=Some(bx,ty) /\ ~Mem.valid_block m bx /\ Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge declarations empty_env m id ty declarations_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&Q);exists bx;auto. }
 destruct(ALL Source._inv_out(tptr(tarray tfloat 3))ltac:(left;reflexivity))as(bpo&EO&FO&PO).
 destruct(ALL Source._mat_in(tptr(tarray tfloat 3))ltac:(right;left;reflexivity))as(bpi&EI&FI&PI).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(NPP:bpo<>bpi)by(intro EQ;subst bpo;pose proof(SEP _ _ _ _ _ EO EI);discriminate).
 assert(OUTENV:forall b,Mem.valid_block m b->Outside e b).
 { intros b V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declarations m e ma AV id b ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(WP:Mem.valid_access ma Mptr bpo 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros z B;apply PO;change(0<=z<8);exact B|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr bpo 0(Vptr bo po)WP)as[mb SO].
 assert(WI:Mem.valid_access mb Mptr bpi 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros z B;apply PI;change(0<=z<8);exact B|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mptr bpi 0(Vptr bi pi)WI)as[md SI].
 assert(BIND:bind_parameters Execution.ge e ma(fn_params Source.f_float_mat_inv_3d)(Args bo bi po pi)md).
 { eapply bind_parameters_cons;[exact EO| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SO.
 - eapply bind_parameters_cons;[exact EI| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SI. }
 assert(C:Core e bpo bpi bo bi po pi f(PTree.empty float32)md).
 { constructor.
 - intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx';intros z B;eapply Mem.perm_store_1;[exact SI|];eapply Mem.perm_store_1;[exact SO|apply Q;exact B].
 - erewrite Mem.load_store_other by(exact SI||(left;congruence));erewrite Mem.load_store_same by exact SO;reflexivity.
 - erewrite Mem.load_store_same by exact SI;reflexivity.
 - pose proof(reads_alloc declarations empty_env m bi pi 9 f RD)as RA;rewrite ALLOC in RA.
   eapply(reads_store_preserved mb bi pi 9 f Mptr bpi 0(Vptr bi pi)md);[|congruence|exact SI].
   eapply(reads_store_preserved ma bi pi 9 f Mptr bpo 0(Vptr bo po)mb);[exact RA|congruence|exact SO].
 - pose proof(write_alloc declarations empty_env m bo po 9 W)as WA;rewrite ALLOC in WA;eapply writable_store_preserved;[|exact SI];eapply writable_store_preserved;[exact WA|exact SO].
 - apply known_empty. }
 assert(FF:FullFrame m md).
 { intros b z n VB;erewrite Mem.loadbytes_store_other by(exact SI||(left;intro EQ;subst b;exact(FI VB))).
   erewrite Mem.loadbytes_store_other by(exact SO||(left;intro EQ;subst b;exact(FO VB))).
   pose proof(allocation_bytes_frame Execution.ge declarations empty_env m b z n VB)as H;rewrite ALLOC in H;exact H. }
 assert(ACC:Access m md).
 { intros ch b z p VA;eapply Mem.store_valid_access_1;[exact SI|];eapply Mem.store_valid_access_1;[exact SO|].
   pose proof(allocation_access Execution.ge declarations empty_env m ch b z p VA)as H;rewrite ALLOC in H;exact H. }
 destruct(prefix_execute Prefix(LocalResults f)e bpo bpi bo bi po pi f(PTree.empty float32)md m SEP(OUTENV bi VI)EO EI
  ltac:(intros id rhs IN;destruct(ALL id tfloat(prefix_declarations id rhs IN))as(bx&E&F&Q);exists bx;exact E)
  OUTENV C FF ACC(prefix_valid _ _ _ _ _ _ _ _ EI))as[me[PE[CE[FE[AE NBE]]]]].
 destruct(suffix_execute e bpo bpi bo bi po pi f me(OUTENV bo VO)NE EO EI CE)as[ms[SE[WR[CS AS]]]].
 destruct(free_environment Execution.ge e ms SEP(core_free _ _ _ _ _ _ _ _ _ _ CS))as[mf[FREE[KEEP FACCESS]]].
 assert(NBS:Mem.nextblock ms=Mem.nextblock me).
 { unfold BodyWrites in WR;destruct(Accept f);[eapply writes_nextblock;exact WR|subst ms;reflexivity]. }
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m declarations with(le,mm)=>match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm(fn_params Source.f_float_mat_inv_3d)(Args bo bi po pi)with
 |Some bound=>match stmt_eval Execution.ge le tbool(fn_body Source.f_float_mat_inv_3d)bound with Some(out,body)=>cont_eval Execution.ge le tbool Kstop out body|None=>None end|None=>None end end)=Some(Status f,mf)).
   rewrite ALLOC,(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma(fn_params Source.f_float_mat_inv_3d)(Args bo bi po pi)md BIND),body_syntax,PE,SE;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
   + unfold OutputBytes;unfold BodyWrites in WR;destruct(Accept f)eqn:AC.
     * intros i B;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV bo VO)).
       eapply writes_bytes;[exact WR|apply outputs_nodup|apply outputs_member;exact B].
     * subst ms;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV bo VO));apply FE;exact VO.
   + split.
     * intros b z n VB OUT;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b VB)).
       unfold BodyWrites in WR;destruct(Accept f).
       -- rewrite(writes_frame(Outputs f)me bo po 9 ms WR(outputs_range f)b z n OUT);apply FE;exact VB.
       -- subst ms;apply FE;exact VB.
     * split.
       -- destruct(core_write _ _ _ _ _ _ _ _ _ _ CS)as[AL[NW RP]];split;[exact AL|];split;[exact NW|].
          eapply range_perm_access_preserved_block;[|exact RP];intros ch z p VA;apply(FACCESS ch bo z p(OUTENV bo VO));exact VA.
       -- split.
          ++ intros b VB;unfold Mem.valid_block;rewrite(free_list_nextblock _ _ _ FREE),NBS,NBE.
             apply(Mem.store_valid_block_1 _ _ _ _ _ _ SI);apply(Mem.store_valid_block_1 _ _ _ _ _ _ SO).
             pose proof(allocation_blocks declarations empty_env m b VB)as H;rewrite ALLOC in H;exact H.
          ++ intros ch b z p VB VA;apply(FACCESS ch b z p(OUTENV b VB));apply AS;apply AE;exact VA.
Qed.
Print Assumptions call_summary.
