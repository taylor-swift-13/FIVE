From FiveLowpassGetCase Require Import Contract GetCall.
From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassGetCase Require Import Contract GetCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
From compcert Require Import Errors Maps Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
Definition Guard(k:nat)(m:mem)(b:block)(p:ptrofs):Prop:=
 match k with
 |0%nat=>forall i,Vptr b p<>Vint i /\Vptr b p<>Vlong Int64.zero
 |1%nat=>Mem.valid_block m b
 |2%nat|3%nat=>Mem.range_perm m b(Ptrofs.unsigned p+8)(Ptrofs.unsigned p+12)Cur Nonempty
 |4%nat=>Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+8)Readable
 |5%nat=>forall i,Vptr b(Ptrofs.add p(Ptrofs.repr 8))<>Vint i /\Vptr b(Ptrofs.add p(Ptrofs.repr 8))<>Vlong Int64.zero
 |_=>False end.
Lemma read_guards:forall m b p value,ReadableOut m b p value->forall k,(k<6)%nat->Guard k m b p.
Proof.
 intros m b p value R k K.
 pose proof(Mem.load_valid_access _ _ _ _ _ (proj2(proj2 R)))as VA.
 assert(RG:Mem.range_perm m b(Ptrofs.unsigned p+8)(Ptrofs.unsigned p+12)Cur Nonempty).
 { intros z Z;eapply Mem.perm_implies;[apply(proj1 VA);cbn[size_chunk];lia|constructor]. }
 destruct k as[|[|[|[|[|[|k]]]]]];cbn[Guard];try lia;try exact VA;try exact RG.
 - intros;split;discriminate.
 - exact(read_out_valid _ _ _ _ R).
 - intros;split;discriminate.
Qed.
Definition SiteProperty(k:nat):Prop:=forall m b p value,ReadableOut m b p value->
 exists e bound bp,
 Csem.step Execution.ge(Execution.entry(Args b p)m)Events.E0
 (State Source.f_get_first_order_low_pass(fn_body Source.f_get_first_order_low_pass)Kstop e bound) /\
 pure_lval Execution.ge e bound get_field=Some(b,Ptrofs.add p(Ptrofs.repr 8),Full) /\
 stmt_eval Execution.ge e tfloat(fn_body Source.f_get_first_order_low_pass)bound=Some(Nreturn(Vsingle value),bound) /\
 e!Source._filter=Some(bp,filter_type) /\Guard k bound b p.
Theorem site_properties:forall k,(k<6)%nat->SiteProperty k.
Proof. intros k K;unfold SiteProperty.
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
 exists e,mb,bp;split.
 - right;eapply step_internal_function.
 + vm_compute;repeat constructor;simpl;intuition discriminate.
 + exact AV.
 + exact BIND.
 - split;[eapply get_location;eauto|]. split;[exact BODY|]. split;[exact LP|]. eapply read_guards;[exact PMB|exact K].
Qed.
Print Assumptions site_properties.
