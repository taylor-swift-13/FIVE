From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassRetune Require Import Source Execution.
From FiveLowpassSupport Require Import RetuneBody LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition retune_declarations:=fn_params Source.f_update_first_order_low_pass_tau.
Lemma retune_alloc_nodup:NoDup(map fst retune_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem retune_call_eval:forall m b p tau h,
 writable12 m b p ->
 exists mf,
 state_eval Execution.ge(Execution.entry[Vptr b p;Vsingle tau;Vsingle h]m)=Some(Vundef,mf) /\
 writable12 mf b p /\
 Mem.loadbytes mf b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle(retune_coefficient tau h))) /\
 (forall q z n,Mem.valid_block m q ->
 q<>b \/ z+n<=Ptrofs.unsigned p \/ Ptrofs.unsigned p+4<=z ->
 Mem.loadbytes mf q z n=Mem.loadbytes m q z n).
Proof.
 intros m b p tau h P.
 pose proof(field_access m b p 0 P ltac:(simpl;auto))as W0.
 rewrite Z.add_0_r in W0.
 assert(OBJ:Mem.valid_block m b).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W0|constructor]. }
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m retune_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m retune_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge retune_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)retune_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge retune_declarations empty_env m id ty retune_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&Q);exists bx;auto. }
 destruct(ALL Source._filter retune_filter_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 destruct(ALL Source._tau tfloat ltac:(right;left;reflexivity))as(bt&LT&FT&RT).
 destruct(ALL Source._sample_time tfloat ltac:(right;right;left;reflexivity))as(bh&LH&FH&RH).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge retune_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PT:bp<>bt)by(intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LT);discriminate).
 assert(PH:bp<>bh)by(intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LH);discriminate).
 assert(TH:bt<>bh)by(intro EQ;subst bt;pose proof(SEP _ _ _ _ _ LT LH);discriminate).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK.
   destruct(ALL id ty(allocated_environment_origin Execution.ge retune_declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q).
   rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split.
 - intros ofs Q;apply RP;change(0<=ofs<8);change(0<=ofs<8)in Q;exact Q.
 - exists 0;lia. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(WT:Mem.valid_access mb Mfloat32 bt 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|];apply Mem.valid_access_freeable_any;split.
 - intros ofs Q;apply RT;change(0<=ofs<4);exact Q.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mb Mfloat32 bt 0(Vsingle tau)WT)as[mc ST].
 assert(WH:Mem.valid_access mc Mfloat32 bh 0 Writable).
 { eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|];apply Mem.valid_access_freeable_any;split.
 - intros ofs Q;apply RH;change(0<=ofs<4);exact Q.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mc Mfloat32 bh 0(Vsingle h)WH)as[md SH].
 assert(BIND:bind_parameters Execution.ge e ma retune_declarations[Vptr b p;Vsingle tau;Vsingle h]md).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LT| |].
   + eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact ST.
   + eapply bind_parameters_cons;[exact LH| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SH. }
 assert(LOADP:Mem.load Mptr md bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact SH||(left;exact PH));erewrite Mem.load_store_other by(exact ST||(left;exact PT));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADT:Mem.load Mfloat32 md bt 0=Some(Vsingle tau)).
 { erewrite Mem.load_store_other by(exact SH||(left;exact TH));erewrite Mem.load_store_same by exact ST;reflexivity. }
 assert(LOADH:Mem.load Mfloat32 md bh 0=Some(Vsingle h)).
 { erewrite Mem.load_store_same by exact SH;reflexivity. }
 assert(PMA:writable12 ma b p).
 { destruct P as[AL[NW R]];repeat split;auto.
   intros z Q;pose proof(allocation_perm Execution.ge retune_declarations empty_env m b z Cur Writable(R z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PMD:writable12 md b p).
 { eapply store_preserves_writable12;[|exact SH];eapply store_preserves_writable12;[|exact ST];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 destruct(field_store md b p 0(retune_coefficient tau h)PMD ltac:(simpl;auto))as[me S0].
 rewrite Z.add_0_r in S0.
 assert(BODY:stmt_eval Execution.ge e tvoid(fn_body Source.f_update_first_order_low_pass_tau)md=Some(Nnormal,me)).
 { eapply retune_body_eval;eauto. destruct P as[AL[NW RP0]];unfold Ptrofs.max_unsigned in NW;lia. }
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm me bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge retune_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
   intros ofs RANGE;eapply Mem.perm_store_1;[exact S0|];eapply Mem.perm_store_1;[exact SH|];eapply Mem.perm_store_1;[exact ST|];eapply Mem.perm_store_1;[exact SP|];apply Q;exact RANGE. }
 destruct(free_environment Execution.ge e me SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m retune_declarations with (le,mm)=>
   match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm retune_declarations[Vptr b p;Vsingle tau;Vsingle h]with
   |Some bound=>match stmt_eval Execution.ge le tvoid(fn_body Source.f_update_first_order_low_pass_tau)bound with
   |Some(out,body)=>cont_eval Execution.ge le tvoid Kstop out body|None=>None end
   |None=>None end end)=Some(Vundef,mf)).
   change(Cexec.do_alloc_variables Execution.ge empty_env m retune_declarations=(e,ma))in ALLOC.
   rewrite ALLOC.
   rewrite(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma retune_declarations[Vptr b p;Vsingle tau;Vsingle h]md BIND).
   rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
   + pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ PMD S0)as PME.
     destruct PME as[AL[NW Q]];split;[exact AL|];split;[exact NW|].
     eapply range_perm_access_preserved_block;[|exact Q].
     intros ch ofs perm VA;apply(ACCESS ch b ofs perm(OUTENV b OBJ));exact VA.
   + split.
     * erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)).
       exact(Mem.loadbytes_store_same _ _ _ _ _ _ S0).
     * intros q z n VB OUT.
       erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VB)).
       erewrite Mem.loadbytes_store_other by(exact S0||(cbn[size_chunk];tauto)).
       erewrite Mem.loadbytes_store_other by(exact SH||(left;intro EQ;subst q;exact(FH VB))).
       erewrite Mem.loadbytes_store_other by(exact ST||(left;intro EQ;subst q;exact(FT VB))).
       erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VB))).
       pose proof(allocation_bytes_frame Execution.ge retune_declarations empty_env m q z n VB)as H;rewrite ALLOC in H;exact H.
Qed.
Print Assumptions retune_call_eval.
