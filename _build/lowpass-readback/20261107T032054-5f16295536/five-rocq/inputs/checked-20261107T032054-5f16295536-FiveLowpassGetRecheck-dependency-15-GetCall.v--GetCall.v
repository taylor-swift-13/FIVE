From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassGetCase Require Import Contract.
Definition filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Definition get_filter:=Evalof(Evar Source._filter filter_type)filter_type.
Definition get_field:=Efield(Evalof(Ederef get_filter(Tstruct Source._FirstOrderLowPass noattr))(Tstruct Source._FirstOrderLowPass noattr))Source._last_out tfloat.
Definition get_declarations:=fn_params Source.f_get_first_order_low_pass.
Lemma get_alloc_nodup:NoDup(map fst get_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma get_location:forall e m bp b p,
 e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 pure_lval Execution.ge e m get_field=Some(b,Ptrofs.add p(Ptrofs.repr 8),Full).
Proof. intros;unfold get_field;eapply struct_field;[unfold get_filter,filter_type;eapply pointer_variable;eauto|reflexivity|reflexivity]. Qed.
Lemma get_body_eval:forall e m bp b p value,
 ReadableOut m b p value ->
 e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 stmt_eval Execution.ge e tfloat(fn_body Source.f_get_first_order_low_pass)m=Some(Nreturn(Vsingle value),m).
Proof.
 intros e m bp b p value R LP LD.
 assert(RV:pure_rval Execution.ge e m(Evalof get_field tfloat)=Some(Vsingle value)).
 { change(match pure_lval Execution.ge e m get_field with
 |Some(bx,ofs,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m bx ofs bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle value)).
 rewrite(get_location e m bp b p LP LD).
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite zle_true by(rewrite(out_pointer _ _ _ _ R);pose proof(proj1(proj2 R))as NW;change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia).
 rewrite(out_pointer _ _ _ _ R),(proj2(proj2 R));reflexivity. }
 change(match pure_rval Execution.ge e m(Evalof get_field tfloat)with
 |Some v=>match sem_cast v tfloat tfloat m with Some v'=>Some(Nreturn v',m)|None=>None end|None=>None end=Some(Nreturn(Vsingle value),m)).
 rewrite RV;reflexivity.
Qed.
Theorem get_call_summary:forall m b p value,ReadableOut m b p value ->
 exists mf,state_eval Execution.ge(Execution.entry(Args b p)m)=Some(Vsingle value,mf) /\Post m mf b p value.
Proof.
 intros m b p value P;pose proof(read_out_valid m b p value P)as OBJ.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m get_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m get_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge get_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)get_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge get_declarations empty_env m id ty get_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&PR);exists bx;auto. }
 destruct(ALL Source._filter filter_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge get_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PB:bp<>b)by(intro EQ;subst bp;exact(FP OBJ)).
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros ofs R;apply RP;change(0<=ofs<8);change(0<=ofs<8)in R;exact R|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(BIND:bind_parameters Execution.ge e ma get_declarations(Args b p)mb).
 { eapply bind_parameters_cons;[exact LP| |constructor].
 eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP. }
 assert(LOADP:Mem.load Mptr mb bp 0=Some(Vptr b p))by(erewrite Mem.load_store_same by exact SP;reflexivity).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge get_declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(LOAD:Mem.load Mfloat32 mb b(Ptrofs.unsigned p+8)=Some(Vsingle value)).
 { erewrite Mem.load_store_other by(exact SP||(left;congruence)).
 pose proof(allocation_load_frame Execution.ge get_declarations empty_env m Mfloat32 b(Ptrofs.unsigned p+8)OBJ)as H;rewrite ALLOC in H;cbn in H;rewrite H;exact(proj2(proj2 P)). }
 assert(PMB:ReadableOut mb b p value)by(destruct P as[A[B C]];repeat split;auto).
 assert(BODY:stmt_eval Execution.ge e tfloat(fn_body Source.f_get_first_order_low_pass)mb=Some(Nreturn(Vsingle value),mb))by(eapply get_body_eval;eauto).
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm mb bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge get_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&R);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'. intros ofs RANGE;eapply Mem.perm_store_1;[exact SP|apply R;exact RANGE]. }
 destruct(free_environment Execution.ge e mb SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 assert(FRAME:Frame m mf).
 { intros q z n VB0;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VB0)).
 erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VB0))).
 pose proof(allocation_bytes_frame Execution.ge get_declarations empty_env m q z n VB0)as H;rewrite ALLOC in H;exact H. }
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m get_declarations with (le,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm get_declarations(Args b p)with
 |Some bound=>match stmt_eval Execution.ge le tfloat(fn_body Source.f_get_first_order_low_pass)bound with
 |Some(out,body)=>cont_eval Execution.ge le tfloat Kstop out body|None=>None end
 |None=>None end end)=Some(Vsingle value,mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m get_declarations=(e,ma))in ALLOC.
 rewrite ALLOC,(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma get_declarations(Args b p)mb BIND),BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split;[|exact FRAME]. destruct P as[AL[NW L]];repeat split;auto.
 rewrite(KEEP Mfloat32 b(Ptrofs.unsigned p+8)(OUTENV b OBJ));exact LOAD.
Qed.
Print Assumptions get_call_summary.
