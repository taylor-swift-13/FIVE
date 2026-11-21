From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions Straightline.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory Contract Expressions UpdateBody.
Import ListNotations.
Local Open Scope Z_scope.
Definition update_parameters:=fn_params Source.f_update_pid_df.
Definition update_declarations:=fn_params Source.f_update_pid_df++fn_vars Source.f_update_pid_df.
Lemma update_alloc_nodup:NoDup(map fst update_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem update_call_summary:forall m b p a bc c u0 u1 e0 e1 e2 x,
 Initialized m b p a bc c u0 u1 e0 e1 e2->
 exists mf,state_eval Execution.ge(Execution.entry(Args b p x)m)=Some(Vsingle(fp_step a bc c u0 e0 e1 x),mf) /\Post m mf b p a bc c u0 e0 e1 x.
Proof.
 intros m b p a bc c u0 u1 e0 e1 e2 x INIT;pose proof(proj1 INIT)as W.
 assert(OBJ:Mem.valid_block m b)by(eapply initialized_valid;exact INIT).
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m update_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m update_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge update_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)update_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge update_declarations empty_env m id ty update_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&PR);exists bx;auto. }
 destruct(ALL Source._pid pid_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 destruct(ALL Source._value tfloat ltac:(right;left;reflexivity))as(bv&LV&FV&RV).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge update_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PB:bp<>b)by(intro EQ;subst bp;exact(FP OBJ)).
 assert(VB:bv<>b)by(intro EQ;subst bv;exact(FV OBJ)).
 assert(PV:bp<>bv)by(intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LV);discriminate).
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RP;change(0<=ofs<8);change(0<=ofs<8)in R;exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(WV:Mem.valid_access mb Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RV;change(0<=ofs<4);exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mb Mfloat32 bv 0(Vsingle x)WV)as[mc SV].
 assert(BIND:bind_parameters Execution.ge e ma update_parameters[Vptr b p;Vsingle x]mc).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SV. }
 assert(LOADP:Mem.load Mptr mc bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact SV||(left;exact PV));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADV:Mem.load Mfloat32 mc bv 0=Some(Vsingle x))by(erewrite Mem.load_store_same by exact SV;reflexivity).
 assert(WMA:writable32 ma b p).
 { destruct W as[AL[NW R]];repeat split;auto.
 intros z Q;pose proof(allocation_perm Execution.ge update_declarations empty_env m b z Cur Writable(R z Q))as H;rewrite ALLOC in H;exact H. }
 assert(WMC:writable32 mc b p)by(eapply store_preserves_writable32;[|exact SV];eapply store_preserves_writable32;[exact WMA|exact SP]).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge update_declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(INITC:Initialized mc b p a bc c u0 u1 e0 e1 e2).
 { split;[exact WMC|].
 destruct INIT as[IW[L0[L4[L8[L12[L16[L20[L24 L28]]]]]]]].
 assert(LOAD:forall delta y,Mem.load Mfloat32 m b(Ptrofs.unsigned p+delta)=Some(Vsingle y)->Mem.load Mfloat32 mc b(Ptrofs.unsigned p+delta)=Some(Vsingle y)).
 { intros delta y LD;erewrite Mem.load_store_other by(exact SV||(left;congruence));erewrite Mem.load_store_other by(exact SP||(left;congruence)).
 pose proof(allocation_load_frame Execution.ge update_declarations empty_env m Mfloat32 b(Ptrofs.unsigned p+delta)OBJ)as H;rewrite ALLOC in H;cbn in H;rewrite H;exact LD. }
 repeat split;eapply LOAD;eauto. }
 destruct(field_store mc b p 16 e1 WMC ltac:(unfold field_offsets;simpl;tauto))as[md1 S1].
 assert(WD1:writable32 md1 b p)by(eapply store_preserves_writable32;[exact WMC|exact S1]).
 destruct(field_store md1 b p 12 e0 WD1 ltac:(unfold field_offsets;simpl;tauto))as[md2 S2].
 assert(WD2:writable32 md2 b p)by(eapply store_preserves_writable32;[exact WD1|exact S2]).
 destruct(field_store md2 b p 8 x WD2 ltac:(unfold field_offsets;simpl;tauto))as[md3 S3].
 assert(WD3:writable32 md3 b p)by(eapply store_preserves_writable32;[exact WD2|exact S3]).
 destruct(field_store md3 b p 4 u0 WD3 ltac:(unfold field_offsets;simpl;tauto))as[md4 S4].
 assert(WD4:writable32 md4 b p)by(eapply store_preserves_writable32;[exact WD3|exact S4]).
 destruct(field_store md4 b p 0 (fp_step a bc c u0 e0 e1 x) WD4 ltac:(unfold field_offsets;simpl;tauto))as[md5 S5].
 assert(WD5:writable32 md5 b p)by(eapply store_preserves_writable32;[exact WD4|exact S5]).
 assert(BODY:stmt_eval Execution.ge e tfloat(fn_body Source.f_update_pid_df)mc=Some(Nreturn(Vsingle(fp_step a bc c u0 e0 e1 x)),md5)).
 { eapply update_body_eval;eauto. }
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm md5 bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge update_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&R);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply Mem.perm_store_1;[exact S5|];eapply Mem.perm_store_1;[exact S4|];eapply Mem.perm_store_1;[exact S3|];eapply Mem.perm_store_1;[exact S2|];eapply Mem.perm_store_1;[exact S1|];eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SP|];apply R;exact RANGE. }
 destruct(free_environment Execution.ge e md5 SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m update_declarations with (le,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm update_parameters[Vptr b p;Vsingle x]with
 |Some bound=>match stmt_eval Execution.ge le tfloat(fn_body Source.f_update_pid_df)bound with
 |Some(out,body)=>cont_eval Execution.ge le tfloat Kstop out body|None=>None end
 |None=>None end end)=Some(Vsingle(fp_step a bc c u0 e0 e1 x),mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m update_declarations=(e,ma))in ALLOC.
 rewrite ALLOC.
 rewrite(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma update_parameters[Vptr b p;Vsingle x]mc BIND).
 rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - assert(WF:writable32 mf b p).
 { destruct WD5 as[AL[NW Q]];split;[exact AL|];split;[exact NW|].
 eapply range_perm_access_preserved_block;[|exact Q].
 intros ch ofs perm VA;apply(ACCESS ch b ofs perm(OUTENV b OBJ));exact VA. }
 assert(FRAME:Frame m mf b p).
 { intros q z n VQ OUT.
 erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VQ)).
 erewrite Mem.loadbytes_store_other by(exact S5||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S3||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S2||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact S1||(cbn[size_chunk];intuition lia)).
 erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst q;exact(FV VQ))).
 erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VQ))).
 pose proof(allocation_bytes_frame Execution.ge update_declarations empty_env m q z n VQ)as H;rewrite ALLOC in H;exact H. }
 assert(VALID:PreservesValid m mf).
 { intros q VQ;eapply free_list_valid_block;[exact FREE|].
 eapply Mem.store_valid_block_1;[exact S5|]; eapply Mem.store_valid_block_1;[exact S4|]; eapply Mem.store_valid_block_1;[exact S3|]; eapply Mem.store_valid_block_1;[exact S2|]; eapply Mem.store_valid_block_1;[exact S1|];eapply Mem.store_valid_block_1;[exact SV|];eapply Mem.store_valid_block_1;[exact SP|].
 pose proof(allocation_valid_block Execution.ge update_declarations empty_env m q VQ)as H;rewrite ALLOC in H;exact H. }
 destruct INITC as[ICW[C0[C4[C8[C12[C16[C20[C24 C28]]]]]]]].
 assert(F0:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+0)=Some(Vsingle (fp_step a bc c u0 e0 e1 x))).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+0)(OUTENV b OBJ)). erewrite Mem.load_store_same by exact S5;reflexivity. }
 assert(F4:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+4)=Some(Vsingle u0)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+4)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S4;reflexivity. }
 assert(F8:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+8)=Some(Vsingle x)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+8)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S3;reflexivity. }
 assert(F12:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+12)=Some(Vsingle e0)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+12)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S2;reflexivity. }
 assert(F16:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+16)=Some(Vsingle e1)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+16)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S1;reflexivity. }
 assert(F20:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+20)=Some(Vsingle a)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+20)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact C20. }
 assert(F24:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+24)=Some(Vsingle bc)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+24)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact C24. }
 assert(F28:Mem.load Mfloat32 mf b(Ptrofs.unsigned p+28)=Some(Vsingle c)).
 { rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+28)(OUTENV b OBJ)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact C28. }
 assert(B16:Mem.loadbytes mf b(Ptrofs.unsigned p+16)4=Some(encode_val Mfloat32(Vsingle e1))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)). erewrite Mem.loadbytes_store_other by(exact S5||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S3||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S2||(cbn[size_chunk];lia)). exact(Mem.loadbytes_store_same _ _ _ _ _ _ S1). }
 assert(B12:Mem.loadbytes mf b(Ptrofs.unsigned p+12)4=Some(encode_val Mfloat32(Vsingle e0))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)). erewrite Mem.loadbytes_store_other by(exact S5||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S3||(cbn[size_chunk];lia)). exact(Mem.loadbytes_store_same _ _ _ _ _ _ S2). }
 assert(B8:Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle x))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)). erewrite Mem.loadbytes_store_other by(exact S5||(cbn[size_chunk];lia)). erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];lia)). exact(Mem.loadbytes_store_same _ _ _ _ _ _ S3). }
 assert(B4:Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle u0))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)). erewrite Mem.loadbytes_store_other by(exact S5||(cbn[size_chunk];lia)). exact(Mem.loadbytes_store_same _ _ _ _ _ _ S4). }
 assert(B0:Mem.loadbytes mf b(Ptrofs.unsigned p+0)4=Some(encode_val Mfloat32(Vsingle (fp_step a bc c u0 e0 e1 x)))).
 { erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)). exact(Mem.loadbytes_store_same _ _ _ _ _ _ S5). }
 unfold Post;split;[split;[exact WF|repeat split;assumption]|].
 split.
 + intros delta y IN;cbn in IN;repeat destruct IN as[EQ|IN];try contradiction;injection EQ as<- <-;assumption.
 + split;assumption.
Qed.
Print Assumptions update_call_summary.
Theorem update_call_execution:forall m b p a bc c u0 u1 e0 e1 e2 x,
 Initialized m b p a bc c u0 u1 e0 e1 e2->
 exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p x)m)t(Returnstate(Vsingle(fp_step a bc c u0 e0 e1 x))Kstop mf) /\Post m mf b p a bc c u0 e0 e1 x.
Proof.
 intros m b p a bc c u0 u1 e0 e1 e2 x P.
 destruct(update_call_summary m b p a bc c u0 u1 e0 e1 e2 x P)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args b p x)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args b p x)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 destruct(defined_evaluator_return_exists Execution.ge _ _ _ N CN EV)as[t PATH];exists t,mf;auto.
Qed.
Print Assumptions update_call_execution.

Theorem update_call_observed:forall m b p a bc c u0 u1 e0 e1 e2 x,
 Initialized m b p a bc c u0 u1 e0 e1 e2->
 forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p x)m)t(Returnstate result Kstop mf)->
 result=Vsingle(fp_step a bc c u0 e0 e1 x) /\Post m mf b p a bc c u0 e0 e1 x.
Proof.
 intros m b p a bc c u0 u1 e0 e1 e2 x P t result after PATH.
 destruct(update_call_summary m b p a bc c u0 u1 e0 e1 e2 x P)as[mf[EV POST]].
 assert(N:normal_state(Execution.entry(Args b p x)m)=true)by(vm_compute;reflexivity).
 destruct(defined_evaluator_exact_return Execution.ge _ _ _ _ _ _ N EV PATH)as[VR MR];subst result after;auto.
Qed.
Print Assumptions update_call_observed.
