From Stdlib Require Import List ZArith Lia String.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution BlockExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import LowpassMemory Expressions Straightline.
Require FiveLowpassInit.Source FiveLowpassInit.Execution FiveLowpassRetune.Source FiveLowpassRetune.Execution FiveLowpassReset.Source FiveLowpassReset.Execution.
Require FiveLowpassSupport.InitBody FiveLowpassSupport.InitCall FiveLowpassSupport.RetuneBody FiveLowpassSupport.RetuneCall FiveLowpassSupport.ResetBody FiveLowpassSupport.ResetCall.
Import ListNotations.
Local Open Scope Z_scope.
Fixpoint assignments(s:statement):list expr:=
 match s with Sdo(Eassign l r ty)=>[Eassign l r ty]|Ssequence a b=>assignments a++assignments b|_=>[]end.
Definition nonnull(v:val):Prop:=forall i,v<>Vint i /\ v<>Vlong(Int64.zero).
(** Pointer tags, live permissions and checked subobject bounds are the CompCert
 adapters for the six emitted CBMC object guards; no CBMC result is assumed. *)
Definition mapped_guard(k:nat)(m:mem)(b:block)(p:ptrofs)(delta:Z):Prop:=
 match k with
 |0%nat=>nonnull(Vptr b p)
 |1%nat=>Mem.valid_block m b
 |2%nat=>Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty
 |3%nat=>Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty
 |4%nat=>Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+delta)Writable
 |5%nat=>nonnull(Vptr b(Ptrofs.add p(Ptrofs.repr delta)))
 |_=>False end.
Lemma all_six_guards:forall m b p delta,writable12 m b p->In delta[0;4;8]->
 forall k,(k<6)%nat->mapped_guard k m b p delta.
Proof.
 intros m b p delta P D k K;pose proof(field_access m b p delta P D)as VA.
 assert(R:Mem.range_perm m b(Ptrofs.unsigned p+delta)(Ptrofs.unsigned p+delta+4)Cur Nonempty).
 { intros z H;eapply Mem.perm_implies;[apply(proj1 VA);exact H|constructor]. }
 destruct k as[|[|[|[|[|[|k]]]]]];cbn[mapped_guard];try lia;try exact R;try exact VA.
 - intros i;split;discriminate.
 - eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor].
 - intros i;split;discriminate.
Qed.
Definition site_packet(ge:genv)(f:function)(e:env)(m mf:mem)(b:block)(p:ptrofs)(site:nat)(delta:Z)(v:float32):Prop:=
 exists l r,
 nth_error(assignments(fn_body f))site=Some(Eassign l r tfloat) /\
 pure_lval ge e m l=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full) /\
 pure_rval ge e m r=Some(Vsingle v) /\
 atomic_eval ge e m(Eassign l r tfloat)=Some(Vsingle v,mf) /\
 (forall k,(k<6)%nat->mapped_guard k m b p delta).
Lemma make_site_packet:forall ge f e m mf b p site delta v l r,
 writable12 m b p->In delta[0;4;8]->
 nth_error(assignments(fn_body f))site=Some(Eassign l r tfloat)->typeof l=tfloat->typeof r=tfloat->
 pure_lval ge e m l=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full)->pure_rval ge e m r=Some(Vsingle v)->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p+delta)(Vsingle v)=Some mf->
 site_packet ge f e m mf b p site delta v.
Proof.
 intros ge f e m mf b p site delta v l r P D AST TL TR LL RR ST.
 exists l,r;split;[exact AST|];split;[exact LL|];split;[exact RR|];split.
 - eapply assign_float;[exact TL|exact TR|exact LL|exact RR| |].
 + rewrite(field_pointer m b p delta P D);destruct P as[_[NW _]].
   destruct D as[<-|[<-|[<-|[]]]];lia.
 + rewrite(field_pointer m b p delta P D);exact ST.
 - exact(all_six_guards m b p delta P D).
Qed.

Module InitSites.
Module Source:=FiveLowpassInit.Source.
Module Execution:=FiveLowpassInit.Execution.
Import FiveLowpassSupport.InitBody FiveLowpassSupport.InitCall.
Definition ready(m:mem)(b:block)(p:ptrofs)(value tau h:float32)(e:env)(bound:mem):Prop:=
 exists ma bp bv bt bh,
 Cexec.do_alloc_variables Execution.ge empty_env m init_declarations=(e,ma) /\
 bind_parameters Execution.ge e ma init_declarations[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]bound /\
 writable12 bound b p /\
 e!Source._filter=Some(bp,filter_type) /\
 Mem.load Mptr bound bp 0=Some(Vptr b p) /\
 bp<>b /\
 e!Source._value=Some(bv,tfloat) /\
 Mem.load Mfloat32 bound bv 0=Some(Vsingle value) /\
 bv<>b /\
 e!Source._tau=Some(bt,tfloat) /\
 Mem.load Mfloat32 bound bt 0=Some(Vsingle tau) /\
 bt<>b /\
 e!Source._sample_time=Some(bh,tfloat) /\
 Mem.load Mfloat32 bound bh 0=Some(Vsingle h) /\
 bh<>b.
Theorem ready_exists:forall m b p value tau h,writable12 m b p->exists e bound,ready m b p value tau h e bound.
Proof.
 intros m b p value tau h W.
 pose proof(field_access m b p 0 W ltac:(simpl;auto))as W0.
 pose proof(field_access m b p 4 W ltac:(simpl;auto))as W4.
 pose proof(field_access m b p 8 W ltac:(simpl;auto))as W8.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m init_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m init_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge init_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)init_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge init_declarations empty_env m id ty init_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&P);exists bx;auto. }
 destruct(ALL Source._filter filter_type ltac:(left;reflexivity))as(bp&LP&FP&RP).
 destruct(ALL Source._value tfloat ltac:(right;right;right;left;reflexivity))as(bv&LV&FV&RV).
 destruct(ALL Source._tau tfloat ltac:(right;left;reflexivity))as(bt&LT&FT&RT).
 destruct(ALL Source._sample_time tfloat ltac:(right;right;left;reflexivity))as(bh&LH&FH&RH).
 assert(OBJ:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge init_declarations m e ma AV id q ty LOOK))as(bx&LOOK2&F&Q);rewrite LOOK in LOOK2;injection LOOK2 as EQ;subst bx;exact(F V). }
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated Execution.ge init_declarations empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H. }
 assert(PB:bp<>b).
 { intro EQ;subst bp;apply FP;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(VB:bv<>b).
 { intro EQ;subst bv;apply FV;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 assert(PV:bp<>bv).
 { intro EQ;subst bp;pose proof(SEP _ _ _ _ _ LP LV);discriminate. }
 assert(TB:bt<>b)by(intro EQ;subst bt;apply FT;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]).
 assert(HB:bh<>b)by(intro EQ;subst bh;apply FH;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]).
 assert(DISTINCT:forall x y bx by0 tx ty,e!x=Some(bx,tx)->e!y=Some(by0,ty)->x<>y->bx<>by0).
 { intros x y bx by0 tx ty LX LY NE EQ;subst by0;apply NE;eapply SEP;eauto. }
 assert(WP:Mem.valid_access ma Mptr bp 0 Writable).
 { apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RP;change(0<=ofs<8);change(0<=ofs<8)in R;exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(WT:Mem.valid_access mb Mfloat32 bt 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split;[intros ofs R;apply RT;change(0<=ofs<4);exact R|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mfloat32 bt 0(Vsingle tau)WT)as[mt ST].
 assert(WH:Mem.valid_access mt Mfloat32 bh 0 Writable).
 { eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split;[intros ofs R;apply RH;change(0<=ofs<4);exact R|exists 0;lia]. }
 destruct(Mem.valid_access_store mt Mfloat32 bh 0(Vsingle h)WH)as[mh SH].
 assert(WV:Mem.valid_access mh Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SH|];eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split;[intros ofs R;apply RV;change(0<=ofs<4);exact R|exists 0;lia]. }
 destruct(Mem.valid_access_store mh Mfloat32 bv 0(Vsingle value)WV)as[mc SV].
 assert(BIND:bind_parameters Execution.ge e ma init_declarations[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]mc).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LT| |].
 + eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact ST.
 + eapply bind_parameters_cons;[exact LH| |].
 * eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SH.
 * eapply bind_parameters_cons;[exact LV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SV. }
 assert(LOADP:Mem.load Mptr mc bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact SV||(left;exact PV));erewrite Mem.load_store_other by(exact SH||(left;eapply DISTINCT;[exact LP|exact LH|discriminate]));erewrite Mem.load_store_other by(exact ST||(left;eapply DISTINCT;[exact LP|exact LT|discriminate]));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADV:Mem.load Mfloat32 mc bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(LOADT:Mem.load Mfloat32 mc bt 0=Some(Vsingle tau)).
 { erewrite Mem.load_store_other by(exact SV||(left;eapply DISTINCT;[exact LT|exact LV|discriminate]));erewrite Mem.load_store_other by(exact SH||(left;eapply DISTINCT;[exact LT|exact LH|discriminate]));erewrite Mem.load_store_same by exact ST;reflexivity. }
 assert(LOADH:Mem.load Mfloat32 mc bh 0=Some(Vsingle h)).
 { erewrite Mem.load_store_other by(exact SV||(left;eapply DISTINCT;[exact LH|exact LV|discriminate]));erewrite Mem.load_store_same by exact SH;reflexivity. }
 assert(PMA:writable12 ma b p).
 { destruct W as[AL[NW ROrig]];repeat split;auto;intros z Q;pose proof(allocation_perm Execution.ge init_declarations empty_env m b z Cur Writable(ROrig z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PBOUND:writable12 mc b p).
 { eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[|exact SH];eapply store_preserves_writable12;[|exact ST];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 exists e,mc,ma,bp,bv,bt,bh.
 repeat first[solve[assumption]|split].
Qed.
Theorem ready_actual_entry_step:forall m b p value tau h e bound,
 ready m b p value tau h e bound->
 Csem.step Execution.ge(Execution.entry[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]m)E0(State Source.f_init_first_order_low_pass(fn_body Source.f_init_first_order_low_pass)Kstop e bound).
Proof.
 intros m b p value tau h e bound READY.
 destruct READY as(ma&bp&bv&bt&bh&ALLOC&BIND&REST).
 right;eapply step_internal_function.
 - vm_compute;repeat constructor;simpl;intuition discriminate.
 - pose proof(Cexec.do_alloc_variables_sound Execution.ge init_declarations empty_env m)as H;rewrite ALLOC in H;exact H.
 - exact BIND.
Qed.
End InitSites.

Module RetuneSites.
Module Source:=FiveLowpassRetune.Source.
Module Execution:=FiveLowpassRetune.Execution.
Import FiveLowpassSupport.RetuneBody FiveLowpassSupport.RetuneCall.
Definition ready(m:mem)(b:block)(p:ptrofs)(tau h:float32)(e:env)(bound:mem):Prop:=
 exists ma bp bt bh,
 Cexec.do_alloc_variables Execution.ge empty_env m retune_declarations=(e,ma) /\
 bind_parameters Execution.ge e ma retune_declarations[Vptr b p;Vsingle tau;Vsingle h]bound /\
 writable12 bound b p /\
 e!Source._filter=Some(bp,retune_filter_type) /\
 Mem.load Mptr bound bp 0=Some(Vptr b p) /\
 bp<>b /\
 e!Source._tau=Some(bt,tfloat) /\
 Mem.load Mfloat32 bound bt 0=Some(Vsingle tau) /\
 bt<>b /\
 e!Source._sample_time=Some(bh,tfloat) /\
 Mem.load Mfloat32 bound bh 0=Some(Vsingle h) /\
 bh<>b.
Theorem ready_exists:forall m b p tau h,writable12 m b p->exists e bound,ready m b p tau h e bound.
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
 assert(PB:bp<>b)by(intro EQ;subst bp;exact(FP OBJ)).
 assert(TB:bt<>b)by(intro EQ;subst bt;exact(FT OBJ)).
 assert(HB:bh<>b)by(intro EQ;subst bh;exact(FH OBJ)).
 assert(PMA:writable12 ma b p).
 { destruct P as[AL[NW ROrig]];repeat split;auto;intros z Q;pose proof(allocation_perm Execution.ge retune_declarations empty_env m b z Cur Writable(ROrig z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PBOUND:writable12 md b p).
 { eapply store_preserves_writable12;[|exact SH];eapply store_preserves_writable12;[|exact ST];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 exists e,md,ma,bp,bt,bh.
 repeat first[solve[assumption]|split].
Qed.
Theorem ready_actual_entry_step:forall m b p tau h e bound,
 ready m b p tau h e bound->
 Csem.step Execution.ge(Execution.entry[Vptr b p;Vsingle tau;Vsingle h]m)E0(State Source.f_update_first_order_low_pass_tau(fn_body Source.f_update_first_order_low_pass_tau)Kstop e bound).
Proof.
 intros m b p tau h e bound READY.
 destruct READY as(ma&bp&bt&bh&ALLOC&BIND&REST).
 right;eapply step_internal_function.
 - vm_compute;repeat constructor;simpl;intuition discriminate.
 - pose proof(Cexec.do_alloc_variables_sound Execution.ge retune_declarations empty_env m)as H;rewrite ALLOC in H;exact H.
 - exact BIND.
Qed.
End RetuneSites.

Module ResetSites.
Module Source:=FiveLowpassReset.Source.
Module Execution:=FiveLowpassReset.Execution.
Import FiveLowpassSupport.ResetBody FiveLowpassSupport.ResetCall.
Definition ready(m:mem)(b:block)(p:ptrofs)(value:float32)(e:env)(bound:mem):Prop:=
 exists ma bp bv,
 Cexec.do_alloc_variables Execution.ge empty_env m reset_declarations=(e,ma) /\
 bind_parameters Execution.ge e ma reset_declarations[Vptr b p;Vsingle value]bound /\
 writable12 bound b p /\
 e!Source._filter=Some(bp,filter_type) /\
 Mem.load Mptr bound bp 0=Some(Vptr b p) /\
 bp<>b /\
 e!Source._value=Some(bv,tfloat) /\
 Mem.load Mfloat32 bound bv 0=Some(Vsingle value) /\
 bv<>b.
Theorem ready_exists:forall m b p value,writable12 m b p->exists e bound,ready m b p value e bound.
Proof.
 intros m b p value P.
 pose proof(field_access m b p 4 P ltac:(simpl;auto))as W4.
 pose proof(field_access m b p 8 P ltac:(simpl;auto))as W8.
 assert(OBJ:Mem.valid_block m b).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m reset_declarations)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m reset_declarations e ma).
 { pose proof(Cexec.do_alloc_variables_sound Execution.ge reset_declarations empty_env m)as H;rewrite ALLOC in H;exact H. }
 assert(ALL:forall id ty,In(id,ty)reset_declarations->exists bx,e!id=Some(bx,ty) /\~Mem.valid_block m bx /\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable Execution.ge reset_declarations empty_env m id ty reset_alloc_nodup IN)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&PR);exists bx;auto. }
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
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b p)WP)as[mb SP].
 assert(WV:Mem.valid_access mb Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|]. apply Mem.valid_access_freeable_any;split.
 - intros ofs R;apply RV;change(0<=ofs<4);exact R.
 - exists 0;lia. }
 destruct(Mem.valid_access_store mb Mfloat32 bv 0(Vsingle value)WV)as[mc SV].
 assert(BIND:bind_parameters Execution.ge e ma reset_declarations[Vptr b p;Vsingle value]mc).
 { eapply bind_parameters_cons;[exact LP| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SP.
 - eapply bind_parameters_cons;[exact LV| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|]. unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);exact SV. }
 assert(LOADP:Mem.load Mptr mc bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact SV||(left;exact PV));erewrite Mem.load_store_same by exact SP;reflexivity. }
 assert(LOADV:Mem.load Mfloat32 mc bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_same by exact SV;reflexivity. }
 assert(PMA:writable12 ma b p).
 { destruct P as[AL[NW ROrig]];repeat split;auto;intros z Q;pose proof(allocation_perm Execution.ge reset_declarations empty_env m b z Cur Writable(ROrig z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PBOUND:writable12 mc b p).
 { eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 exists e,mc,ma,bp,bv.
 repeat first[solve[assumption]|split].
Qed.
Theorem ready_actual_entry_step:forall m b p value e bound,
 ready m b p value e bound->
 Csem.step Execution.ge(Execution.entry[Vptr b p;Vsingle value]m)E0(State Source.f_reset_first_order_low_pass(fn_body Source.f_reset_first_order_low_pass)Kstop e bound).
Proof.
 intros m b p value e bound READY.
 destruct READY as(ma&bp&bv&ALLOC&BIND&REST).
 right;eapply step_internal_function.
 - vm_compute;repeat constructor;simpl;intuition discriminate.
 - pose proof(Cexec.do_alloc_variables_sound Execution.ge reset_declarations empty_env m)as H;rewrite ALLOC in H;exact H.
 - exact BIND.
Qed.
End ResetSites.

Module InitPackets.
Module Source:=FiveLowpassInit.Source.
Module Execution:=FiveLowpassInit.Execution.
Import FiveLowpassSupport.InitBody.
Definition prefixes(e:env)(m m1 m2 m3:mem)(b:block)(p:ptrofs)(value tau h:float32):Prop:=
 site_packet Execution.ge Source.f_init_first_order_low_pass e m m1 b p 0 4 value /\
 site_packet Execution.ge Source.f_init_first_order_low_pass e m1 m2 b p 1 8 value /\
 site_packet Execution.ge Source.f_init_first_order_low_pass e m2 m3 b p 2 0(coefficient tau h).
Theorem from_ready:forall original b p value tau h e m,
 InitSites.ready original b p value tau h e m->exists m1 m2 m3,prefixes e m m1 m2 m3 b p value tau h.
Proof.
 intros original b p value tau h e m READY.
 destruct READY as(ma&bp&bv&bt&bh&ALLOC&BIND&P&LP&PF&PB&LV&VF&VB&LT&TF&TB&LH&HF&HB).
 destruct(field_store m b p 4 value P ltac:(simpl;auto))as[m1 S1].
 pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ P S1)as P1.
 destruct(field_store m1 b p 8 value P1 ltac:(simpl;auto))as[m2 S2].
 pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ P1 S2)as P2.
 destruct(field_store m2 b p 0(coefficient tau h)P2 ltac:(simpl;auto))as[m3 S3].
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S1||(left;exact PB));exact PF).
 assert(PF2:Mem.load Mptr m2 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S2||(left;exact PB));exact PF1).
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S1||(left;exact VB));exact VF).
 assert(TF2:Mem.load Mfloat32 m2 bt 0=Some(Vsingle tau)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact TB));erewrite Mem.load_store_other by(exact S1||(left;exact TB));exact TF. }
 assert(HF2:Mem.load Mfloat32 m2 bh 0=Some(Vsingle h)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact HB));erewrite Mem.load_store_other by(exact S1||(left;exact HB));exact HF. }
 exists m1,m2,m3;split.
 - eapply make_site_packet with(l:=output_field Source._last_in)(r:=input_var Source._value);try reflexivity.
 + exact P.
 + simpl;auto.
 + eapply output_location;[exact LP|exact PF|right;left;auto].
 + eapply float_variable;eauto.
 + exact S1.
 - split.
 + eapply make_site_packet with(l:=output_field Source._last_out)(r:=input_var Source._value);try reflexivity.
 * exact P1.
 * simpl;auto.
 * eapply output_location;[exact LP|exact PF1|right;right;auto].
 * eapply float_variable;eauto.
 * exact S2.
 + eapply make_site_packet with(l:=output_field Source._time_const)(r:=ratio);try reflexivity.
 * exact P2.
 * simpl;auto.
 * eapply output_location;[exact LP|exact PF2|left;auto].
 * eapply ratio_value;eauto.
 * exact S3.
Qed.
End InitPackets.
Module ResetPackets.
Module Source:=FiveLowpassReset.Source.
Module Execution:=FiveLowpassReset.Execution.
Import FiveLowpassSupport.ResetBody.
Definition prefixes(e:env)(m m1 m2:mem)(b:block)(p:ptrofs)(value:float32):Prop:=
 site_packet Execution.ge Source.f_reset_first_order_low_pass e m m1 b p 0 4 value /\
 site_packet Execution.ge Source.f_reset_first_order_low_pass e m1 m2 b p 1 8 value.
Theorem from_ready:forall original b p value e m,
 ResetSites.ready original b p value e m->exists m1 m2,prefixes e m m1 m2 b p value.
Proof.
 intros original b p value e m READY.
 destruct READY as(ma&bp&bv&ALLOC&BIND&P&LP&PF&PB&LV&VF&VB).
 destruct(field_store m b p 4 value P ltac:(simpl;auto))as[m1 S1].
 pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ P S1)as P1.
 destruct(field_store m1 b p 8 value P1 ltac:(simpl;auto))as[m2 S2].
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S1||(left;exact PB));exact PF).
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S1||(left;exact VB));exact VF).
 exists m1,m2;split.
 - eapply make_site_packet with(l:=reset_field Source._last_in)(r:=reset_input);try reflexivity.
 + exact P.
 + simpl;auto.
 + eapply reset_location;[exact LP|exact PF|left;auto].
 + eapply float_variable;eauto.
 + exact S1.
 - eapply make_site_packet with(l:=reset_field Source._last_out)(r:=reset_input);try reflexivity.
 + exact P1.
 + simpl;auto.
 + eapply reset_location;[exact LP|exact PF1|right;auto].
 + eapply float_variable;eauto.
 + exact S2.
Qed.
End ResetPackets.
Module RetunePackets.
Module Source:=FiveLowpassRetune.Source.
Module Execution:=FiveLowpassRetune.Execution.
Import FiveLowpassSupport.RetuneBody.
Definition input_var(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Definition filter_var:expr:=Evalof(Evar Source._filter retune_filter_type)retune_filter_type.
Definition output_field:expr:=Efield(Evalof(Ederef filter_var(Tstruct Source._FirstOrderLowPass noattr))(Tstruct Source._FirstOrderLowPass noattr))Source._time_const tfloat.
Definition ratio:expr:=Ebinop Odiv(Ebinop Omul(Eval(Vsingle(Float32.of_bits(Int.repr 1073741824)))tfloat)(input_var Source._tau)tfloat)(input_var Source._sample_time)tfloat.
Definition prefixes(e:env)(m m1:mem)(b:block)(p:ptrofs)(tau h:float32):Prop:=
 site_packet Execution.ge Source.f_update_first_order_low_pass_tau e m m1 b p 0 0(retune_coefficient tau h).
Theorem from_ready:forall original b p tau h e m,
 RetuneSites.ready original b p tau h e m->exists m1,prefixes e m m1 b p tau h.
Proof.
 intros original b p tau h e m READY.
 destruct READY as(ma&bp&bt&bh&ALLOC&BIND&P&LP&PF&PB&LT&TF&TB&LH&HF&HB).
 destruct(field_store m b p 0(retune_coefficient tau h)P ltac:(simpl;auto))as[m1 S1].
 exists m1;eapply make_site_packet with(l:=output_field)(r:=ratio);try reflexivity.
 - exact P.
 - simpl;auto.
 - unfold output_field;eapply struct_field.
 + unfold filter_var,retune_filter_type;eapply pointer_variable;eauto.
 + reflexivity.
 + reflexivity.
 - unfold ratio;cbn[pure_rval];fold(pure_rval Execution.ge e m(input_var Source._tau));fold(pure_rval Execution.ge e m(input_var Source._sample_time)).
 rewrite(float_variable _ _ _ _ _ _ LT TF),(float_variable _ _ _ _ _ _ LH HF);reflexivity.
 - exact S1.
Qed.
End RetunePackets.

Definition reach(ge:genv)(s sf:Csem.state):Prop:=exists t,star Csem.step ge s t sf.
Lemma reach_refl:forall ge s,reach ge s s.
Proof. intros;exists E0;constructor. Qed.
Lemma reach_step:forall ge s t sf,Csem.step ge s t sf->reach ge s sf.
Proof. intros;exists t;apply star_one;exact H. Qed.
Lemma reach_trans:forall ge s sm sf,reach ge s sm->reach ge sm sf->reach ge s sf.
Proof. intros ge s sm sf[t P][u Q];exists(t**u);eapply star_trans;eauto. Qed.
Lemma atomic_source_path:forall ge f a k e m v mf,
 atomic_expr a=true->normal_cont k=true->atomic_eval ge e m a=Some(v,mf)->
 reach ge(State f(Sdo a)k e m)(State f Sskip k e mf).
Proof.
 intros ge f a k e m v mf A K EV.
 assert(INV:block_context_invariant ge k f e mf(State f(Sdo a)k e m)).
 { exists(State f(Sdo a)Kstop e m);split;[reflexivity|];split.
 - split.
 + cbn[block_state block_stmt block_cont];rewrite A;reflexivity.
 + cbn[block_denotation block_eval];rewrite EV;reflexivity.
 - split;reflexivity. }
 assert(AC:Acc(FiveShared.verification.Obligations.successor ge)(State f(Sdo a)k e m)).
 { apply normal_all_successors_terminate;cbn[normal_state normal_stmt];rewrite A,K;reflexivity. }
 revert INV;induction AC as[s AC IH];intros INV.
 destruct(block_context_progress ge k f e mf s INV)as[EQ|[tr[next[STEP NX]]]].
 - subst s;apply reach_refl.
 - eapply reach_trans;[eapply reach_step;exact STEP|].
 apply(IH next ltac:(exists tr;exact STEP)NX).
Qed.
Lemma packet_atomic:forall ge f e m mf b p site delta v a,
 site_packet ge f e m mf b p site delta v->nth_error(assignments(fn_body f))site=Some a->
 atomic_eval ge e m a=Some(Vsingle v,mf).
Proof.
 intros ge f e m mf b p site delta v a(l&r&AST&LL&RR&EV&G)AS.
 rewrite AST in AS;inversion AS;subst a;exact EV.
Qed.
Definition reachable_site(ge:genv)(f:function)(e:env)(initial current:mem)(site:nat):Prop:=
 exists l r k,nth_error(assignments(fn_body f))site=Some(Eassign l r tfloat) /\
 reach ge(State f(fn_body f)Kstop e initial)(State f(Sdo(Eassign l r tfloat))k e current).
Module InitReach.
Module Source:=FiveLowpassInit.Source.
Module Execution:=FiveLowpassInit.Execution.
Import FiveLowpassSupport.InitBody.
Definition a0:=Eassign(output_field Source._last_in)(input_var Source._value)tfloat.
Definition a1:=Eassign(output_field Source._last_out)(input_var Source._value)tfloat.
Definition a2:=Eassign(output_field Source._time_const)ratio tfloat.
Definition tail:=Ssequence(Sdo a1)(Sdo a2).
Theorem prefix_reachable:forall e m m1 m2 m3 b p value tau h,
 InitPackets.prefixes e m m1 m2 m3 b p value tau h->
 reachable_site Execution.ge Source.f_init_first_order_low_pass e m m 0 /\
 reachable_site Execution.ge Source.f_init_first_order_low_pass e m m1 1 /\
 reachable_site Execution.ge Source.f_init_first_order_low_pass e m m2 2.
Proof.
 intros e m m1 m2 m3 b p value tau h[P0[P1 P2]].
 pose proof(packet_atomic _ _ _ _ _ _ _ _ _ _ a0 P0 eq_refl)as E0.
 pose proof(packet_atomic _ _ _ _ _ _ _ _ _ _ a1 P1 eq_refl)as E1.
 assert(R0:reach Execution.ge(State Source.f_init_first_order_low_pass(fn_body Source.f_init_first_order_low_pass)Kstop e m)(State Source.f_init_first_order_low_pass(Sdo a0)(Kseq tail Kstop)e m)).
 { apply reach_step with(t:=Events.E0);right;apply step_seq. }
 assert(R1:reach Execution.ge(State Source.f_init_first_order_low_pass(fn_body Source.f_init_first_order_low_pass)Kstop e m)(State Source.f_init_first_order_low_pass(Sdo a1)(Kseq(Sdo a2)Kstop)e m1)).
 { eapply reach_trans;[exact R0|].
 eapply reach_trans;[eapply atomic_source_path;[reflexivity|reflexivity|exact E0]|].
 eapply reach_trans;[eapply reach_step;right;apply step_skip_seq|].
 eapply reach_step;right;apply step_seq. }
 assert(R2:reach Execution.ge(State Source.f_init_first_order_low_pass(fn_body Source.f_init_first_order_low_pass)Kstop e m)(State Source.f_init_first_order_low_pass(Sdo a2)Kstop e m2)).
 { eapply reach_trans;[exact R1|].
 eapply reach_trans;[eapply atomic_source_path;[reflexivity|reflexivity|exact E1]|].
 eapply reach_step;right;apply step_skip_seq. }
 split.
 - exists(output_field Source._last_in),(input_var Source._value),(Kseq tail Kstop);split;[reflexivity|exact R0].
 - split.
 + exists(output_field Source._last_out),(input_var Source._value),(Kseq(Sdo a2)Kstop);split;[reflexivity|exact R1].
 + exists(output_field Source._time_const),ratio,Kstop;split;[reflexivity|exact R2].
Qed.
End InitReach.
Module ResetReach.
Module Source:=FiveLowpassReset.Source.
Module Execution:=FiveLowpassReset.Execution.
Import FiveLowpassSupport.ResetBody.
Definition a0:=Eassign(reset_field Source._last_in)reset_input tfloat.
Definition a1:=Eassign(reset_field Source._last_out)reset_input tfloat.
Definition tail:=Ssequence(Sdo a1)(Sreturn(Some reset_input)).
Theorem prefix_reachable:forall e m m1 m2 b p value,
 ResetPackets.prefixes e m m1 m2 b p value->
 reachable_site Execution.ge Source.f_reset_first_order_low_pass e m m 0 /\
 reachable_site Execution.ge Source.f_reset_first_order_low_pass e m m1 1.
Proof.
 intros e m m1 m2 b p value[P0 P1].
 pose proof(packet_atomic _ _ _ _ _ _ _ _ _ _ a0 P0 eq_refl)as E0.
 assert(R0:reach Execution.ge(State Source.f_reset_first_order_low_pass(fn_body Source.f_reset_first_order_low_pass)Kstop e m)(State Source.f_reset_first_order_low_pass(Sdo a0)(Kseq tail Kstop)e m)).
 { apply reach_step with(t:=Events.E0);right;apply step_seq. }
 assert(R1:reach Execution.ge(State Source.f_reset_first_order_low_pass(fn_body Source.f_reset_first_order_low_pass)Kstop e m)(State Source.f_reset_first_order_low_pass(Sdo a1)(Kseq(Sreturn(Some reset_input))Kstop)e m1)).
 { eapply reach_trans;[exact R0|].
 eapply reach_trans;[eapply atomic_source_path;[reflexivity|reflexivity|exact E0]|].
 eapply reach_trans;[eapply reach_step;right;apply step_skip_seq|].
 eapply reach_step;right;apply step_seq. }
 split.
 - exists(reset_field Source._last_in),reset_input,(Kseq tail Kstop);split;[reflexivity|exact R0].
 - exists(reset_field Source._last_out),reset_input,(Kseq(Sreturn(Some reset_input))Kstop);split;[reflexivity|exact R1].
Qed.
End ResetReach.
Module RetuneReach.
Module Source:=FiveLowpassRetune.Source.
Module Execution:=FiveLowpassRetune.Execution.
Theorem prefix_reachable:forall e m,
 reachable_site Execution.ge Source.f_update_first_order_low_pass_tau e m m 0.
Proof.
 intros;exists RetunePackets.output_field,RetunePackets.ratio,Kstop;split;[reflexivity|apply reach_refl].
Qed.
End RetuneReach.
Print Assumptions atomic_source_path.
Print Assumptions InitReach.prefix_reachable.

Lemma packet_guards:forall ge f e m mf b p site delta v,
 site_packet ge f e m mf b p site delta v->forall k,(k<6)%nat->mapped_guard k m b p delta.
Proof. intros ge f e m mf b p site delta v(l&r&A&L&R&E&G);exact G. Qed.

Definition InitSelected(id:nat)(e:env)(m0 m1 m2 m3:mem)(b:block)(p:ptrofs):Prop:=
 match ((id-1)/6)%nat with
 |0%nat=>reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard ((id-1)mod 6)%nat m0 b p 4
 |1%nat=>reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard ((id-1)mod 6)%nat m1 b p 8
 |2%nat=>reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard ((id-1)mod 6)%nat m2 b p 0
 |_=>False end.
Definition InitProperty(id:nat):Prop:=forall original b p value tau h,writable12 original b p->
 exists e m0 m1 m2 m3,
 InitSites.ready original b p value tau h e m0 /\
 Csem.step FiveLowpassInit.Execution.ge(FiveLowpassInit.Execution.entry[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]original)E0(State FiveLowpassInit.Source.f_init_first_order_low_pass(fn_body FiveLowpassInit.Source.f_init_first_order_low_pass)Kstop e m0) /\
 InitPackets.prefixes e m0 m1 m2 m3 b p value tau h /\
 InitSelected id e m0 m1 m2 m3 b p.
Theorem init_source_properties:forall (id:nat),In id[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18]%nat->InitProperty id.
Proof.
 intros id ID original b p value tau h P.
 destruct(InitSites.ready_exists original b p value tau h P)as[e[m0 READY]].
 destruct(InitPackets.from_ready original b p value tau h e m0 READY)as(m1&m2&m3&PREF).
 pose proof(InitReach.prefix_reachable e m0 m1 m2 m3 b p value tau h PREF)as REACH.
 destruct REACH as[R0[R1 R2]].
 pose proof PREF as PACKS.
 destruct PACKS as[P0[P1 P2]].
 pose proof(packet_guards FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 b p 0 4 (value) P0)as G0.
 pose proof(packet_guards FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m1 m2 b p 1 8 (value) P1)as G1.
 pose proof(packet_guards FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m2 m3 b p 2 0 (FiveLowpassSupport.InitBody.coefficient tau h) P2)as G2.
 exists e,m0,m1,m2,m3;split;[exact READY|];split.
 - eapply InitSites.ready_actual_entry_step;exact READY.
 - split;[exact PREF|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 0%nat m0 b p 4);split;[exact R0|exact(G0 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 1%nat m0 b p 4);split;[exact R0|exact(G0 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 2%nat m0 b p 4);split;[exact R0|exact(G0 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 3%nat m0 b p 4);split;[exact R0|exact(G0 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 4%nat m0 b p 4);split;[exact R0|exact(G0 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 5%nat m0 b p 4);split;[exact R0|exact(G0 5%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 0%nat m1 b p 8);split;[exact R1|exact(G1 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 1%nat m1 b p 8);split;[exact R1|exact(G1 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 2%nat m1 b p 8);split;[exact R1|exact(G1 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 3%nat m1 b p 8);split;[exact R1|exact(G1 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 4%nat m1 b p 8);split;[exact R1|exact(G1 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 5%nat m1 b p 8);split;[exact R1|exact(G1 5%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 0%nat m2 b p 0);split;[exact R2|exact(G2 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 1%nat m2 b p 0);split;[exact R2|exact(G2 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 2%nat m2 b p 0);split;[exact R2|exact(G2 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 3%nat m2 b p 0);split;[exact R2|exact(G2 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 4%nat m2 b p 0);split;[exact R2|exact(G2 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassInit.Execution.ge FiveLowpassInit.Source.f_init_first_order_low_pass e m0 m2 2%nat /\ mapped_guard 5%nat m2 b p 0);split;[exact R2|exact(G2 5%nat ltac:(lia))]|].
 contradiction.
Qed.
Theorem init_source_property_01:InitProperty 1.
Proof. apply init_source_properties;left;reflexivity. Qed.
Theorem init_source_property_02:InitProperty 2.
Proof. apply init_source_properties;do 1 right;left;reflexivity. Qed.
Theorem init_source_property_03:InitProperty 3.
Proof. apply init_source_properties;do 2 right;left;reflexivity. Qed.
Theorem init_source_property_04:InitProperty 4.
Proof. apply init_source_properties;do 3 right;left;reflexivity. Qed.
Theorem init_source_property_05:InitProperty 5.
Proof. apply init_source_properties;do 4 right;left;reflexivity. Qed.
Theorem init_source_property_06:InitProperty 6.
Proof. apply init_source_properties;do 5 right;left;reflexivity. Qed.
Theorem init_source_property_07:InitProperty 7.
Proof. apply init_source_properties;do 6 right;left;reflexivity. Qed.
Theorem init_source_property_08:InitProperty 8.
Proof. apply init_source_properties;do 7 right;left;reflexivity. Qed.
Theorem init_source_property_09:InitProperty 9.
Proof. apply init_source_properties;do 8 right;left;reflexivity. Qed.
Theorem init_source_property_10:InitProperty 10.
Proof. apply init_source_properties;do 9 right;left;reflexivity. Qed.
Theorem init_source_property_11:InitProperty 11.
Proof. apply init_source_properties;do 10 right;left;reflexivity. Qed.
Theorem init_source_property_12:InitProperty 12.
Proof. apply init_source_properties;do 11 right;left;reflexivity. Qed.
Theorem init_source_property_13:InitProperty 13.
Proof. apply init_source_properties;do 12 right;left;reflexivity. Qed.
Theorem init_source_property_14:InitProperty 14.
Proof. apply init_source_properties;do 13 right;left;reflexivity. Qed.
Theorem init_source_property_15:InitProperty 15.
Proof. apply init_source_properties;do 14 right;left;reflexivity. Qed.
Theorem init_source_property_16:InitProperty 16.
Proof. apply init_source_properties;do 15 right;left;reflexivity. Qed.
Theorem init_source_property_17:InitProperty 17.
Proof. apply init_source_properties;do 16 right;left;reflexivity. Qed.
Theorem init_source_property_18:InitProperty 18.
Proof. apply init_source_properties;do 17 right;left;reflexivity. Qed.
Print Assumptions init_source_properties.

Definition RetuneSelected(id:nat)(e:env)(m0 m1:mem)(b:block)(p:ptrofs):Prop:=
 match ((id-1)/6)%nat with
 |0%nat=>reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard ((id-1)mod 6)%nat m0 b p 0
 |_=>False end.
Definition RetuneProperty(id:nat):Prop:=forall original b p tau h,writable12 original b p->
 exists e m0 m1,
 RetuneSites.ready original b p tau h e m0 /\
 Csem.step FiveLowpassRetune.Execution.ge(FiveLowpassRetune.Execution.entry[Vptr b p;Vsingle tau;Vsingle h]original)E0(State FiveLowpassRetune.Source.f_update_first_order_low_pass_tau(fn_body FiveLowpassRetune.Source.f_update_first_order_low_pass_tau)Kstop e m0) /\
 RetunePackets.prefixes e m0 m1 b p tau h /\
 RetuneSelected id e m0 m1 b p.
Theorem retune_source_properties:forall (id:nat),In id[1;2;3;4;5;6]%nat->RetuneProperty id.
Proof.
 intros id ID original b p tau h P.
 destruct(RetuneSites.ready_exists original b p tau h P)as[e[m0 READY]].
 destruct(RetunePackets.from_ready original b p tau h e m0 READY)as(m1&PREF).
 pose proof(RetuneReach.prefix_reachable e m0)as R0.
 pose proof PREF as PACKS.
 rename PACKS into P0.
 pose proof(packet_guards FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m1 b p 0 0 (FiveLowpassSupport.RetuneBody.retune_coefficient tau h) P0)as G0.
 exists e,m0,m1;split;[exact READY|];split.
 - eapply RetuneSites.ready_actual_entry_step;exact READY.
 - split;[exact PREF|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 0%nat m0 b p 0);split;[exact R0|exact(G0 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 1%nat m0 b p 0);split;[exact R0|exact(G0 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 2%nat m0 b p 0);split;[exact R0|exact(G0 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 3%nat m0 b p 0);split;[exact R0|exact(G0 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 4%nat m0 b p 0);split;[exact R0|exact(G0 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassRetune.Execution.ge FiveLowpassRetune.Source.f_update_first_order_low_pass_tau e m0 m0 0%nat /\ mapped_guard 5%nat m0 b p 0);split;[exact R0|exact(G0 5%nat ltac:(lia))]|].
 contradiction.
Qed.
Theorem retune_source_property_01:RetuneProperty 1.
Proof. apply retune_source_properties;left;reflexivity. Qed.
Theorem retune_source_property_02:RetuneProperty 2.
Proof. apply retune_source_properties;do 1 right;left;reflexivity. Qed.
Theorem retune_source_property_03:RetuneProperty 3.
Proof. apply retune_source_properties;do 2 right;left;reflexivity. Qed.
Theorem retune_source_property_04:RetuneProperty 4.
Proof. apply retune_source_properties;do 3 right;left;reflexivity. Qed.
Theorem retune_source_property_05:RetuneProperty 5.
Proof. apply retune_source_properties;do 4 right;left;reflexivity. Qed.
Theorem retune_source_property_06:RetuneProperty 6.
Proof. apply retune_source_properties;do 5 right;left;reflexivity. Qed.
Print Assumptions retune_source_properties.

Definition ResetSelected(id:nat)(e:env)(m0 m1 m2:mem)(b:block)(p:ptrofs):Prop:=
 match ((id-1)/6)%nat with
 |0%nat=>reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard ((id-1)mod 6)%nat m0 b p 4
 |1%nat=>reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard ((id-1)mod 6)%nat m1 b p 8
 |_=>False end.
Definition ResetProperty(id:nat):Prop:=forall original b p value,writable12 original b p->
 exists e m0 m1 m2,
 ResetSites.ready original b p value e m0 /\
 Csem.step FiveLowpassReset.Execution.ge(FiveLowpassReset.Execution.entry[Vptr b p;Vsingle value]original)E0(State FiveLowpassReset.Source.f_reset_first_order_low_pass(fn_body FiveLowpassReset.Source.f_reset_first_order_low_pass)Kstop e m0) /\
 ResetPackets.prefixes e m0 m1 m2 b p value /\
 ResetSelected id e m0 m1 m2 b p.
Theorem reset_source_properties:forall (id:nat),In id[1;2;3;4;5;6;7;8;9;10;11;12]%nat->ResetProperty id.
Proof.
 intros id ID original b p value P.
 destruct(ResetSites.ready_exists original b p value P)as[e[m0 READY]].
 destruct(ResetPackets.from_ready original b p value e m0 READY)as(m1&m2&PREF).
 pose proof(ResetReach.prefix_reachable e m0 m1 m2 b p value PREF)as REACH.
 destruct REACH as[R0 R1].
 pose proof PREF as PACKS.
 destruct PACKS as[P0 P1].
 pose proof(packet_guards FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 b p 0 4 (value) P0)as G0.
 pose proof(packet_guards FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m1 m2 b p 1 8 (value) P1)as G1.
 exists e,m0,m1,m2;split;[exact READY|];split.
 - eapply ResetSites.ready_actual_entry_step;exact READY.
 - split;[exact PREF|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 0%nat m0 b p 4);split;[exact R0|exact(G0 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 1%nat m0 b p 4);split;[exact R0|exact(G0 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 2%nat m0 b p 4);split;[exact R0|exact(G0 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 3%nat m0 b p 4);split;[exact R0|exact(G0 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 4%nat m0 b p 4);split;[exact R0|exact(G0 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m0 0%nat /\ mapped_guard 5%nat m0 b p 4);split;[exact R0|exact(G0 5%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 0%nat m1 b p 8);split;[exact R1|exact(G1 0%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 1%nat m1 b p 8);split;[exact R1|exact(G1 1%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 2%nat m1 b p 8);split;[exact R1|exact(G1 2%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 3%nat m1 b p 8);split;[exact R1|exact(G1 3%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 4%nat m1 b p 8);split;[exact R1|exact(G1 4%nat ltac:(lia))]|].
 destruct ID as[EQ|ID];[subst id;change(reachable_site FiveLowpassReset.Execution.ge FiveLowpassReset.Source.f_reset_first_order_low_pass e m0 m1 1%nat /\ mapped_guard 5%nat m1 b p 8);split;[exact R1|exact(G1 5%nat ltac:(lia))]|].
 contradiction.
Qed.
Theorem reset_source_property_01:ResetProperty 1.
Proof. apply reset_source_properties;left;reflexivity. Qed.
Theorem reset_source_property_02:ResetProperty 2.
Proof. apply reset_source_properties;do 1 right;left;reflexivity. Qed.
Theorem reset_source_property_03:ResetProperty 3.
Proof. apply reset_source_properties;do 2 right;left;reflexivity. Qed.
Theorem reset_source_property_04:ResetProperty 4.
Proof. apply reset_source_properties;do 3 right;left;reflexivity. Qed.
Theorem reset_source_property_05:ResetProperty 5.
Proof. apply reset_source_properties;do 4 right;left;reflexivity. Qed.
Theorem reset_source_property_06:ResetProperty 6.
Proof. apply reset_source_properties;do 5 right;left;reflexivity. Qed.
Theorem reset_source_property_07:ResetProperty 7.
Proof. apply reset_source_properties;do 6 right;left;reflexivity. Qed.
Theorem reset_source_property_08:ResetProperty 8.
Proof. apply reset_source_properties;do 7 right;left;reflexivity. Qed.
Theorem reset_source_property_09:ResetProperty 9.
Proof. apply reset_source_properties;do 8 right;left;reflexivity. Qed.
Theorem reset_source_property_10:ResetProperty 10.
Proof. apply reset_source_properties;do 9 right;left;reflexivity. Qed.
Theorem reset_source_property_11:ResetProperty 11.
Proof. apply reset_source_properties;do 10 right;left;reflexivity. Qed.
Theorem reset_source_property_12:ResetProperty 12.
Proof. apply reset_source_properties;do 11 right;left;reflexivity. Qed.
Print Assumptions reset_source_properties.
