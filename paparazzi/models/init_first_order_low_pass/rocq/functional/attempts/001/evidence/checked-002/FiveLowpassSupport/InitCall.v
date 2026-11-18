From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassInit Require Import Source Execution.
From FiveLowpassSupport Require Import InitBody Straightline LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition init_declarations:=fn_params Source.f_init_first_order_low_pass.
Lemma init_alloc_nodup:NoDup(map fst init_declarations).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem init_call_summary:forall m b p value tau h,
 writable12 m b p ->
 exists mf,state_eval Execution.ge(Execution.entry[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]m)=Some(Vundef,mf) /\
 writable12 mf b p /\
 Mem.loadbytes mf b(Ptrofs.unsigned p)12=Some(encode_val Mfloat32(Vsingle(coefficient tau h))++encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value)) /\
 (forall q z n,Mem.valid_block m q->q<>b \/ z+n<=Ptrofs.unsigned p \/ Ptrofs.unsigned p+12<=z->Mem.loadbytes mf q z n=Mem.loadbytes m q z n).
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
 assert(W4C:Mem.valid_access mc Mfloat32 b(Ptrofs.unsigned p+4) Writable).
 { eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SH|];eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge init_declarations empty_env m _ _ _ _ W4)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store mc Mfloat32 b(Ptrofs.unsigned p+4)(Vsingle value)W4C)as[md S4].
 assert(W8D:Mem.valid_access md Mfloat32 b(Ptrofs.unsigned p+8) Writable).
 { eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SH|];eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge init_declarations empty_env m _ _ _ _ W8)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store md Mfloat32 b(Ptrofs.unsigned p+8)(Vsingle value)W8D)as[me S8].
 assert(W0E:Mem.valid_access me Mfloat32 b(Ptrofs.unsigned p+0) Writable).
 { eapply Mem.store_valid_access_1;[exact S8|];eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact SV|];eapply Mem.store_valid_access_1;[exact SH|];eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact SP|]. pose proof(allocation_access Execution.ge init_declarations empty_env m _ _ _ _ W0)as H;rewrite ALLOC in H;exact H. }
 destruct(Mem.valid_access_store me Mfloat32 b(Ptrofs.unsigned p+0)(Vsingle(coefficient tau h))W0E)as[mg S0].
 assert(BODY:stmt_eval Execution.ge e tvoid(fn_body Source.f_init_first_order_low_pass)mc=Some(Nnormal,mg)).
 { eapply init_body_eval;eauto.
 assert(WA:writable12 ma b p).
 { destruct W as[AL[NW ROrig]];repeat split;auto.
 intros z R;pose proof(allocation_perm Execution.ge init_declarations empty_env m b z Cur Writable(ROrig z R))as H;rewrite ALLOC in H;exact H. }
 eapply store_preserves_writable12;[|exact SV].
 eapply store_preserves_writable12;[|exact SH].
 eapply store_preserves_writable12;[|exact ST].
 eapply store_preserves_writable12;[exact WA|exact SP]. }
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm mg bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge init_declarations m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&R);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply Mem.perm_store_1;[exact S0|];eapply Mem.perm_store_1;[exact S8|];eapply Mem.perm_store_1;[exact S4|];eapply Mem.perm_store_1;[exact SV|];eapply Mem.perm_store_1;[exact SH|];eapply Mem.perm_store_1;[exact ST|];eapply Mem.perm_store_1;[exact SP|];apply R;exact RANGE. }
 destruct(free_environment Execution.ge e mg SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 exists mf;split.
 - change((match Cexec.do_alloc_variables Execution.ge empty_env m init_declarations with (le,mm)=>
 match Cexec.sem_bind_parameters Execution.ge PureDenotation.quiet_world le mm init_declarations[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]with
 |Some bound=>match stmt_eval Execution.ge le tvoid(fn_body Source.f_init_first_order_low_pass)bound with
 |Some(out,body)=>cont_eval Execution.ge le tvoid Kstop out body|None=>None end
 |None=>None end end)=Some(Vundef,mf)).
 change(Cexec.do_alloc_variables Execution.ge empty_env m init_declarations=(e,ma))in ALLOC.
 rewrite ALLOC.
 rewrite(Cexec.sem_bind_parameters_complete Execution.ge PureDenotation.quiet_world e ma init_declarations[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]mc BIND).
 rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
 - split.
 + assert(PMA:writable12 ma b p).
   { destruct W as[AL[NW ROrig]];repeat split;auto;intros z R;pose proof(allocation_perm Execution.ge init_declarations empty_env m b z Cur Writable(ROrig z R))as H;rewrite ALLOC in H;exact H. }
   assert(PMG:writable12 mg b p).
   { eapply store_preserves_writable12;[|exact S0];eapply store_preserves_writable12;[|exact S8];eapply store_preserves_writable12;[|exact S4];eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[|exact SH];eapply store_preserves_writable12;[|exact ST];eapply store_preserves_writable12;[exact PMA|exact SP]. }
   destruct PMG as[AL[NW Q]];split;[exact AL|];split;[exact NW|].
   eapply range_perm_access_preserved_block;[|exact Q].
   intros ch ofs perm VA;apply(ACCESS ch b ofs perm(OUTENV b OBJ));exact VA.
 + split.
 * erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)).
   assert(L0:Mem.loadbytes mg b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle(coefficient tau h)))).
   { replace(Ptrofs.unsigned p)with(Ptrofs.unsigned p+0)by lia;exact(Mem.loadbytes_store_same _ _ _ _ _ _ S0). }
   assert(L4:Mem.loadbytes mg b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle value))).
   { erewrite Mem.loadbytes_store_other by(exact S0||(cbn[size_chunk];lia));erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];lia));exact(Mem.loadbytes_store_same _ _ _ _ _ _ S4). }
   assert(L8:Mem.loadbytes mg b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle value))).
   { erewrite Mem.loadbytes_store_other by(exact S0||(cbn[size_chunk];lia));exact(Mem.loadbytes_store_same _ _ _ _ _ _ S8). }
   assert(L48:Mem.loadbytes mg b(Ptrofs.unsigned p+4)8=Some(encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value))).
   { replace 8 with(4+4)by lia;eapply Mem.loadbytes_concat;try exact L4;try lia;replace(Ptrofs.unsigned p+4+4)with(Ptrofs.unsigned p+8)by lia;exact L8. }
   replace 12 with(4+8)by lia;eapply Mem.loadbytes_concat;eauto;lia.
 * intros q z n VQ OUT.
   erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VQ)).
   erewrite Mem.loadbytes_store_other by(exact S0||(cbn[size_chunk];destruct OUT as[B|[L|R]];auto;lia)).
   erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];destruct OUT as[B|[L|R]];auto;lia)).
   erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];destruct OUT as[B|[L|R]];auto;lia)).
   erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst q;exact(FV VQ))).
   erewrite Mem.loadbytes_store_other by(exact SH||(left;intro EQ;subst q;exact(FH VQ))).
   erewrite Mem.loadbytes_store_other by(exact ST||(left;intro EQ;subst q;exact(FT VQ))).
   erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VQ))).
   pose proof(allocation_bytes_frame Execution.ge init_declarations empty_env m q z n VQ)as H;rewrite ALLOC in H;exact H.
Qed.
Print Assumptions init_call_summary.
Corollary init_call_eval:forall m b p value tau h,writable12 m b p ->
 exists mf,state_eval Execution.ge(Execution.entry[Vptr b p;Vsingle tau;Vsingle h;Vsingle value]m)=Some(Vundef,mf).
Proof. intros;destruct(init_call_summary m b p value tau h H)as[mf[EV POST]];exists mf;exact EV. Qed.
Print Assumptions init_call_eval.
