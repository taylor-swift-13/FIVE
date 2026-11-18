From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions Straightline LowpassMemory.
From FiveLowpassUpdateCase Require Import Contract UpdateBody UpdateCall.
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
Lemma field_guards:forall m b p delta,writable12 m b p->In delta[0;4;8]->forall k,(k<6)%nat->Guard k m b p delta.
Proof.
 intros m b p delta W D k K;pose proof(field_access m b p delta W D)as VA.
 assert(VB:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor]).
 assert(RG:Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty).
 { intros z Z;eapply Mem.perm_implies;[apply(proj1 VA);cbn[size_chunk];lia|constructor]. }
 destruct k as[|[|[|[|[|[|k]]]]]];cbn[Guard];try lia;try exact VA;try exact RG;try exact VB;intros;split;discriminate.
Qed.
Definition SiteProperty(site k:nat):Prop:=forall m b p tc li lo value,Initialized m b p tc li lo->
 exists e bound local written final bp,
 Csem.step Execution.ge(Execution.entry(Args b p value)m)E0
 (State Source.f_update_first_order_low_pass(fn_body Source.f_update_first_order_low_pass)Kstop e bound) /\
 stmt_eval Execution.ge e tfloat(fn_body Source.f_update_first_order_low_pass)bound=Some(Nreturn(Vsingle(output tc li lo value)),final) /\
 atomic_eval Execution.ge e bound(Eassign(Evar Source._out tfloat)formula tfloat)=Some(Vsingle(output tc li lo value),local) /\
 atomic_eval Execution.ge e local(Eassign(field Source._last_in)(input_var Source._value)tfloat)=Some(Vsingle value,written) /\
 atomic_eval Execution.ge e written(Eassign(field Source._last_out)(input_var Source._out)tfloat)=Some(Vsingle(output tc li lo value),final) /\
 e!Source._filter=Some(bp,filter_type) /\
 match site with
 |0%nat=>pure_lval Execution.ge e bound(field Source._last_in)=Some(b,Ptrofs.add p(Ptrofs.repr 4),Full) /\
 pure_lval Execution.ge e local(field Source._last_in)=Some(b,Ptrofs.add p(Ptrofs.repr 4),Full) /\Guard k bound b p 4 /\Guard k local b p 4
 |1%nat=>pure_lval Execution.ge e bound(field Source._time_const)=Some(b,Ptrofs.add p(Ptrofs.repr 0),Full) /\Guard k bound b p 0
 |2%nat=>pure_lval Execution.ge e bound(field Source._last_out)=Some(b,Ptrofs.add p(Ptrofs.repr 8),Full) /\Guard k bound b p 8
 |3%nat=>pure_lval Execution.ge e written(field Source._last_out)=Some(b,Ptrofs.add p(Ptrofs.repr 8),Full) /\Guard k written b p 8
 |_=>False end.
Theorem site_properties:forall site k,(site<4)%nat->(k<6)%nat->SiteProperty site k.
Proof. intros site k SITE K;unfold SiteProperty.
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
 { exact(update_body_eval e mc bp bv bo b p tc li lo value mc0 md me INITC LP LV LO LOADP LOADV PB VB OB PO VO S0 S4 S8). }

 assert(W0:writable12 mc0 b p)by(eapply store_preserves_writable12;[exact PMC|exact S0]).
 assert(WD:writable12 md b p)by(eapply store_preserves_writable12;[exact W0|exact S4]).
 assert(PF0:Mem.load Mptr mc0 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S0||(left;exact PO));exact LOADP).
 assert(PF1:Mem.load Mptr md bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S4||(left;exact PB));exact PF0).
 assert(VF0:Mem.load Mfloat32 mc0 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S0||(left;exact VO));exact LOADV).
 assert(OF0:Mem.load Mfloat32 mc0 bo 0=Some(Vsingle(output tc li lo value)))by(erewrite Mem.load_store_same by exact S0;reflexivity).
 assert(OF1:Mem.load Mfloat32 md bo 0=Some(Vsingle(output tc li lo value)))by(erewrite Mem.load_store_other by(exact S4||(left;exact OB));exact OF0).
 exists e,mc,mc0,md,me,bp;split.
 - right;eapply step_internal_function;[vm_compute;repeat constructor;simpl;intuition discriminate|exact AV|exact BIND].
 - split;[exact BODY|].
 split.
 { eapply assign_float;try reflexivity.
 - cbn[pure_lval];rewrite LO,dec_eq_true;reflexivity.
 - exact(formula_value e mc bp bv b p tc li lo value INITC LP LV LOADP LOADV).
 - rewrite Ptrofs.unsigned_zero;change(4<=18446744073709551616);lia.
 - rewrite Ptrofs.unsigned_zero;exact S0. }
 split.
 { eapply assign_float;try reflexivity.
 - eapply field_location;[exact LP|exact PF0|right;left;auto].
 - unfold input_var;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 4 P ltac:(simpl;auto));destruct P as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+4+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 4 P ltac:(simpl;auto));exact S4. }
 split.
 { eapply assign_float;try reflexivity.
 - eapply field_location;[exact LP|exact PF1|right;right;auto].
 - unfold input_var;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 8 P ltac:(simpl;auto));destruct P as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 8 P ltac:(simpl;auto));exact S8. }
 split;[exact LP|].

 destruct site as[|[|[|[|site]]]];try lia.
 + split;[exact(field_location e mc bp b p Source._last_in 4 LP LOADP ltac:(right;left;auto))|].
 split;[exact(field_location e mc0 bp b p Source._last_in 4 LP PF0 ltac:(right;left;auto))|].
 split;[exact(field_guards mc b p 4 PMC ltac:(simpl;auto) k K)|exact(field_guards mc0 b p 4 W0 ltac:(simpl;auto) k K)].
 + split;[exact(field_location e mc bp b p Source._time_const 0 LP LOADP ltac:(left;auto))|].
 exact(field_guards mc b p 0 PMC ltac:(simpl;auto) k K).
 + split;[exact(field_location e mc bp b p Source._last_out 8 LP LOADP ltac:(right;right;auto))|].
 exact(field_guards mc b p 8 PMC ltac:(simpl;auto) k K).
 + split;[exact(field_location e md bp b p Source._last_out 8 LP PF1 ltac:(right;right;auto))|].
 exact(field_guards md b p 8 WD ltac:(simpl;auto) k K).
Qed.
Print Assumptions site_properties.
