From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassSupport Require Import ResetBody Straightline.
Import ListNotations.
Local Open Scope Z_scope.
Definition reset_declarations:=fn_params Source.f_reset_first_order_low_pass.
Lemma reset_alloc_nodup:NoDup(map fst reset_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem reset_call_eval_zero:forall m b value,
 Mem.valid_access m Mfloat32 b 4 Writable ->
 Mem.valid_access m Mfloat32 b 8 Writable ->
 exists mf,state_eval Execution.ge(Execution.entry[Vptr b Ptrofs.zero;Vsingle value]m)=Some(Vsingle value,mf).
Proof.
 intros m b value W4 W8.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m reset_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m reset_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge reset_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)reset_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge reset_declarations empty_env m id ty reset_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&P);exists bx;auto. }
 destruct(ALL Source._filter filter_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 destruct(ALL Source._value tfloat ltac:(right;left;reflexivity))as(bv&LV&FV&RV).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge reset_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PB:bp<>b).
 { intro EQ;subst bp;apply FP;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(VB:bv<>b).
 { intro EQ;subst bv;apply FV;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(PV:bp<>bv).
 { intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LV);discriminate. }
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RP;change(0<=ofs<8);change(0<=ofs<8)in R;exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b Ptrofs.zero)WP)as[mb SP].
 assert(WV:Mem.valid_access mb Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RV;change(0<=ofs<4);exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mb Mfloat32 bv 0(Vsingle value)WV)as[mc SV].
 assert(BIND:bind_parameters Execution.ge e ma reset_declarations[Vptr b Ptrofs.zero;Vsingle value]mc).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SV. }
 assert(LOADP:Mem.load Mptr mc bp 0=Some(Vptr b Ptrofs.zero)).
 { erewrite Mem.load_store_other by(exact SV||(left;exact PV));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADV:Mem.load Mfloat32 mc bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(W4C:Mem.valid_access mc Mfloat32 b 4 Writable).
 { eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge reset_declarations empty_env m _ _ _ _ W4)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store mc Mfloat32 b 4(Vsingle value)W4C)as[md S4].
 assert(W8D:Mem.valid_access md Mfloat32 b 8 Writable).
 { eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge reset_declarations empty_env m _ _ _ _ W8)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store md Mfloat32 b 8(Vsingle value)W8D)as[me S8].
 assert(BODY:stmt_eval Execution.ge e tfloat(fn_body Source.f_reset_first_order_low_pass)mc=Some(Nreturn(Vsingle value),me)).
 { eapply reset_body_eval;eauto. }
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm me bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge reset_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&R);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply Mem.perm_store_1;[exact S8|];eapply Mem.perm_store_1;[exact S4|];eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SP|];apply R;exact RANGE. }
 destruct(free_environment Execution.ge e me SEP FREER)as[mf[FREE REST]].
 exists mf.
 change((match Cexec.do_alloc_variables Execution.ge empty_env m reset_declarations with (le,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm reset_declarations[Vptr b Ptrofs.zero;Vsingle value]with
 |Some bound=>match stmt_eval Execution.ge le tfloat(fn_body Source.f_reset_first_order_low_pass)bound with
 |Some(out,body)=>cont_eval Execution.ge le tfloat Kstop out body|None=>None end
 |None=>None end end)=Some(Vsingle value,mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m reset_declarations=(e,ma))in ALLOC.
 rewrite ALLOC.
 rewrite(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma reset_declarations[Vptr b Ptrofs.zero;Vsingle value]mc BIND).
 rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
Qed.
Print Assumptions reset_call_eval_zero.
