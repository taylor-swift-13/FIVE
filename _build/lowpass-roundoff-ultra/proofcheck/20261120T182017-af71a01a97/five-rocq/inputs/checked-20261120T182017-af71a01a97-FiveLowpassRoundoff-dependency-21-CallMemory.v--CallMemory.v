From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions Straightline LowpassMemory.
From FiveLowpassUpdateCase Require Import Contract UpdateBody.
Import ListNotations.
Local Open Scope Z_scope.
Definition update_parameters:=fn_params Source.f_update_first_order_low_pass.
Definition update_declarations:=fn_params Source.f_update_first_order_low_pass++fn_vars Source.f_update_first_order_low_pass.
Lemma update_alloc_nodup:NoDup(map fst update_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma free_list_preserves_valid:forall regions m mf,
 Mem.free_list m regions=Some mf->forall q,Mem.valid_block m q->Mem.valid_block mf q.
Proof.
 induction regions as[|[[b lo]hi] regions IH];intros m mf FREE q VALID.
 - cbn[Mem.free_list]in FREE;injection FREE as<-;exact VALID.
 - cbn[Mem.free_list]in FREE;destruct(Mem.free m b lo hi)as[ma|]eqn:F;try discriminate.
   eapply IH;[exact FREE|];eapply Mem.valid_block_free_1;eauto.
Qed.
Theorem update_call_summary_valid:forall m b p tc li lo value,
 Initialized m b p tc li lo ->
 exists mf,state_eval Execution.ge(Execution.entry(Args b p value)m)=Some(Vsingle(output tc li lo value),mf) /\Post m mf b p tc li lo value /\ (forall q,Mem.valid_block m q->Mem.valid_block mf q).
Proof.
 intros m b p tc li lo value INIT;pose proof(proj1 INIT)as P.
 pose proof(field_access m b p 4 P ltac:(simpl;auto))as W4.
 pose proof(field_access m b p 8 P ltac:(simpl;auto))as W8.
 assert(OBJ:Mem.valid_block m b).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m update_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m update_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge update_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)update_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge update_declarations empty_env m id ty update_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&PR);exists bx;auto. }
 destruct(ALL Source._filter filter_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 destruct(ALL Source._value tfloat ltac:(right;left;reflexivity))as(bv&LV&FV&RV).
 destruct(ALL Source._out tfloat ltac:(right;right;left;reflexivity))as(bo&LO&FO&RO).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge update_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PB:bp<>b).
 { intro EQ;subst bp;apply FP;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(VB:bv<>b).
 { intro EQ;subst bv;apply FV;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(PV:bp<>bv).
 { intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LV);discriminate. }
 assert(OB:bo<>b)by(intro EQ;subst bo;exact(FO OBJ)).
 assert(PO:bp<>bo)by(intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LO);discriminate).
 assert(VO:bv<>bo)by(intro EQ;subst bv;pose proof(SEP _ _ _ _ _ LV LO);discriminate).
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RP;change(0<=ofs<8);change(0<=ofs<8)in R;exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(WV:Mem.valid_access mb Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RV;change(0<=ofs<4);exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mb Mfloat32 bv 0(Vsingle value)WV)as[mc SV].
 assert(BIND:bind_parameters Execution.ge e ma update_parameters[Vptr b p;Vsingle value]mc).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SV. }
 assert(LOADP:Mem.load Mptr mc bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact SV||(left;exact PV));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADV:Mem.load Mfloat32 mc bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(WO:Mem.valid_access mc Mfloat32 bo 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SP|].
 apply Mem.valid_access_freeable_any;split;[intros ofs RANGE;apply RO;exact RANGE|exists 0;lia]. }
 destruct(Mem.valid_access_store mc Mfloat32 bo 0(Vsingle(output tc li lo value))WO)as[mc0 S0].
 assert(W4C:Mem.valid_access mc0 Mfloat32 b(Ptrofs.unsigned p+4)Writable).
 { eapply Mem.store_valid_access_1;[exact S0|];eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge update_declarations empty_env m _ _ _ _ W4)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store mc0 Mfloat32 b(Ptrofs.unsigned p+4)(Vsingle value)W4C)as[md S4].
 assert(W8D:Mem.valid_access md Mfloat32 b(Ptrofs.unsigned p+8)Writable).
 { eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact S0|];eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge update_declarations empty_env m _ _ _ _ W8)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store md Mfloat32 b(Ptrofs.unsigned p+8)(Vsingle(output tc li lo value))W8D)as[me S8].
 assert(PMA:writable12 ma b p).
 { destruct P as[AL[NW R]];repeat split;auto.
   intros z Q;pose proof(allocation_perm Execution.ge update_declarations empty_env m b z Cur Writable(R z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PMC:writable12 mc b p).
 { eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge update_declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(INITC:Initialized mc b p tc li lo).
 { split;[exact PMC|].
 destruct INIT as[W[L0[L4 L8]]].
 assert(LOAD:forall delta x,Mem.load Mfloat32 m b(Ptrofs.unsigned p+delta)=Some(Vsingle x)->Mem.load Mfloat32 mc b(Ptrofs.unsigned p+delta)=Some(Vsingle x)).
 { intros delta x LD;erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_other by(exact SP||(left;congruence)).
 pose proof(allocation_load_frame Execution.ge update_declarations empty_env m Mfloat32 b(Ptrofs.unsigned p+delta)OBJ)as H;rewrite ALLOC in H;cbn in H;rewrite H;exact LD. }
 repeat split;eapply LOAD;eauto. }
 assert(BODY:stmt_eval Execution.ge e tfloat(fn_body Source.f_update_first_order_low_pass)mc=Some(Nreturn(Vsingle(output tc li lo value)),me)).
 { eapply update_body_eval;eauto. }
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm me bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge update_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&R);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply Mem.perm_store_1;[exact S8|];eapply Mem.perm_store_1;[exact S4|];eapply Mem.perm_store_1;[exact S0|];eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SP|];apply R;exact RANGE. }
 destruct(free_environment Execution.ge e me SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 -
 change((match Cexec.do_alloc_variables Execution.ge empty_env m update_declarations with (le,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm update_parameters[Vptr b p;Vsingle value]with
 |Some bound=>match stmt_eval Execution.ge le tfloat(fn_body Source.f_update_first_order_low_pass)bound with
 |Some(out,body)=>cont_eval Execution.ge le tfloat Kstop out body|None=>None end
 |None=>None end end)=Some(Vsingle(output tc li lo value),mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m update_declarations=(e,ma))in ALLOC.
 rewrite ALLOC.
 rewrite(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma update_parameters[Vptr b p;Vsingle value]mc BIND).
 rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 -
 assert(W0:writable12 mc0 b p)by(eapply store_preserves_writable12;[exact PMC|exact S0]).
 assert(WD:writable12 md b p)by(eapply store_preserves_writable12;[exact W0|exact S4]).
 assert(WE:writable12 me b p)by(eapply store_preserves_writable12;[exact WD|exact S8]).
 assert(WF:writable12 mf b p).
 { destruct WE as[AL[NW Q]];split;[exact AL|];split;[exact NW|].
 eapply range_perm_access_preserved_block;[|exact Q].
 intros ch ofs perm VA;apply(ACCESS ch b ofs perm(OUTENV b OBJ));exact VA. }
 assert(FRAME:Frame m mf b p).
 { intros q z n VB0 OUT.
 erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VB0)).
 erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S0||(left;intro EQ;subst q;exact(FO VB0))).
 erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst q;exact(FV VB0))).
 erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VB0))).
 pose proof(allocation_bytes_frame Execution.ge update_declarations empty_env m q z n VB0)as H;rewrite ALLOC in H;exact H. }
 assert(LTC:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+0)=Some(Vsingle tc)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+0)(OUTENV b OBJ)).
 erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)).
 erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)).
 erewrite Mem.load_store_other by(exact S0||(left;congruence));exact(proj1(proj2 INITC)). }
 assert(LIN:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+4)=Some(Vsingle value)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+4)(OUTENV b OBJ)).
 erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia));erewrite Mem.load_store_same by exact S4;reflexivity. }
 assert(LOUT:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+8)=Some(Vsingle(output tc li lo value))).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+8)(OUTENV b OBJ));erewrite Mem.load_store_same by exact S8;reflexivity. }
 assert(BIN:Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle value))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)).
 erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];lia));exact(Mem.loadbytes_store_same _ _ _ _ _ _ S4). }
 assert(BOUT:Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle(output tc li lo value)))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ));exact(Mem.loadbytes_store_same _ _ _ _ _ _ S8). }
 split.
 + split;[split;[exact WF|repeat split;assumption]|repeat split;assumption].
 + intros q VALID;eapply free_list_preserves_valid;[exact FREE|].
   eapply Mem.store_valid_block_1;[exact S8|];eapply Mem.store_valid_block_1;[exact S4|].
   eapply Mem.store_valid_block_1;[exact S0|];eapply Mem.store_valid_block_1;[exact SV|].
   eapply Mem.store_valid_block_1;[exact SP|].
   pose proof(allocation_valid_block Execution.ge update_declarations empty_env m q VALID)as H.
   rewrite ALLOC in H;exact H.
Qed.
Print Assumptions update_call_summary_valid.
