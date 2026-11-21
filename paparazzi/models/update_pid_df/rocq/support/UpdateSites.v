From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions Straightline.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory Contract Expressions UpdateBody UpdateCall.
Import ListNotations.
Local Open Scope Z_scope.
Definition Guard(k:nat)(m:mem)(b:block)(p:ptrofs)(delta:Z):Prop:=
 match k with
 |0%nat=>forall i,Vptr b p<>Vint i /\Vptr b p<>Vlong Int64.zero
 |1%nat=>Mem.valid_block m b
 |2%nat|3%nat=>Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty
 |4%nat=>Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+delta)Writable
 |5%nat=>forall i,Vptr b(Ptrofs.add p(Ptrofs.repr delta))<>Vint i /\Vptr b(Ptrofs.add p(Ptrofs.repr delta))<>Vlong Int64.zero
 |_=>False end.
Lemma field_guards:forall m b p delta,writable32 m b p->In delta field_offsets->forall k,(k<6)%nat->Guard k m b p delta.
Proof.
 intros m b p delta W D k K;pose proof(field_access m b p delta W D)as VA.
 assert(VB:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor]).
 assert(RG:Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty).
 { intros z Z;eapply Mem.perm_implies;[apply(proj1 VA);cbn[size_chunk];lia|constructor]. }
 destruct k as[|[|[|[|[|[|k]]]]]];cbn[Guard];try lia;try exact VA;try exact RG;try exact VB;intros;split;discriminate.
Qed.
Definition site_data(s:nat):nat*ident*Z*Z*Z:=match s with
 |0%nat=>(0%nat,Source._e,3,2,16)
 |1%nat=>(0%nat,Source._e,3,1,12)
 |2%nat=>(1%nat,Source._e,3,1,12)
 |3%nat=>(1%nat,Source._e,3,0,8)
 |4%nat=>(2%nat,Source._e,3,0,8)
 |5%nat=>(3%nat,Source._u,2,1,4)
 |6%nat=>(3%nat,Source._u,2,0,0)
 |7%nat=>(4%nat,Source._u,2,0,0)
 |8%nat=>(4%nat,Source._u,2,1,4)
 |9%nat=>(4%nat,Source._g,3,0,20)
 |10%nat=>(4%nat,Source._e,3,0,8)
 |11%nat=>(4%nat,Source._g,3,1,24)
 |12%nat=>(4%nat,Source._e,3,1,12)
 |13%nat=>(4%nat,Source._g,3,2,28)
 |14%nat=>(4%nat,Source._e,3,2,16)
 |15%nat=>(5%nat,Source._u,2,0,0)
 |_=>(0%nat,Source._e,0,0,0)end.
Definition OperationProperty(site kind:nat):Prop:=forall m b p a bc c u0 u1 e0 e1 e2 x,Initialized m b p a bc c u0 u1 e0 e1 e2->
 exists e bound m1 m2 m3 m4 final bp,
 Csem.step Execution.ge(Execution.entry(Args b p x)m)E0
 (State Source.f_update_pid_df(fn_body Source.f_update_pid_df)Kstop e bound) /\
 stmt_eval Execution.ge e tfloat(fn_body Source.f_update_pid_df)bound=Some(Nreturn(Vsingle(fp_step a bc c u0 e0 e1 x)),final) /\
 BodyTrace e bound m1 m2 m3 m4 final bp b p a bc c u0 e0 e1 x /\
 let '(j,id,n,k,delta):=site_data site in
 let mm:=nth j[bound;m1;m2;m3;m4;final]bound in
 pure_lval Execution.ge e mm(slot id n k)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full) /\Guard kind mm b p delta.
Theorem operation_properties:forall site kind,(site<16)%nat->(kind<6)%nat->OperationProperty site kind.
Proof.
 intros site kind SITE KIND;unfold OperationProperty.
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
 pose proof(update_body_trace e mc bp bv b p a bc c u0 u1 e0 e1 e2 x md1 md2 md3 md4 md5 INITC LP LV LOADP LOADV PB VB S1 S2 S3 S4 S5)as TRACE.
 destruct TRACE as[T1[T2[T3[T4[T5[WS RET]]]]]].
 assert(OPS:forall mm id n k delta,In mm[mc;md1;md2;md3;md4;md5]->Slot id n k delta->
 pure_lval Execution.ge e mm(slot id n k)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full) /\Guard kind mm b p delta).
 { intros mm id n k delta IN SL;destruct(WS mm IN)as[WW PF];split.
 - eapply slot_location;eauto.
 - apply field_guards;[exact WW| |exact KIND].
 unfold Slot in SL;unfold field_offsets;destruct SL as[[_[_ K]]|[[_[_ K]]|[_[_ K]]]];
 repeat destruct K as[[_ ->]|K];try destruct K as[_ ->];simpl;tauto. }
 exists e,mc,md1,md2,md3,md4,md5,bp;split.
 - right;eapply step_internal_function;[vm_compute;repeat constructor;simpl;intuition discriminate|exact AV|exact BIND].
 - split;[exact BODY|]. split.
 + unfold BodyTrace;split;[exact T1|];split;[exact T2|];split;[exact T3|];split;[exact T4|];split;[exact T5|];split;assumption.
 + destruct site as[|[|[|[|[|[|[|[|[|[|[|[|[|[|[|[|site ]]]]]]]]]]]]]]]];try lia.
 all: cbn[site_data nth];apply OPS;[simpl;auto 8|unfold Slot;auto 8].
Qed.
Print Assumptions operation_properties.
Definition pointer_group(g:nat):list nat:=match g with
 |0%nat=>[0%nat;1%nat]
 |1%nat=>[2%nat;3%nat]
 |2%nat=>[4%nat]
 |3%nat=>[5%nat;6%nat]
 |4%nat=>[7%nat;8%nat]
 |5%nat=>[9%nat;11%nat;13%nat]
 |6%nat=>[10%nat;12%nat;14%nat]
 |7%nat=>[15%nat]
|_=>[]end.
Definition PointerProperty(group kind:nat):Prop:=forall site,In site(pointer_group group)->OperationProperty site kind.
Theorem pointer_properties:forall group kind,(group<8)%nat->(kind<6)%nat->PointerProperty group kind.
Proof.
 intros group kind G K site IN;apply operation_properties;[|exact K].
 destruct group as[|[|[|[|[|[|[|[|group]]]]]]]];try lia;
 cbn[pointer_group]in IN;repeat destruct IN as[<-|IN];try contradiction;lia.
Qed.
Definition ArrayProperty(site:nat):Prop:=OperationProperty site 4%nat /\let '(_,_,n,k,_):=site_data site in 0<=k<n.
Theorem array_properties:forall site,(site<16)%nat->ArrayProperty site.
Proof.
 intros site S;split;[apply operation_properties;lia|].
 destruct site as[|[|[|[|[|[|[|[|[|[|[|[|[|[|[|[|site]]]]]]]]]]]]]]]];cbn[site_data];lia.
Qed.
Print Assumptions pointer_properties.
Print Assumptions array_properties.
