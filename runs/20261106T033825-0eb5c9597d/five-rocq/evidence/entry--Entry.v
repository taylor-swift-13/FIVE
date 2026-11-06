From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGhSetOmega Require Import Source Execution.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveGhSetOmegaProof Require Import SourceInvariant NormalCorrespondence Invariant Termination.
From FivePaparazziState Require Import State MemorySupport.
From FiveGhSetOmegaProof Require Import FieldSupport.
Import ListNotations.
Local Open Scope Z_scope.
Definition fld (id:ident) := global_field Source._gh_ref Source._GuidanceHRef id.
Definition rd (id:ident) := Evalof (fld id) tfloat.
Definition cn (x:float32) := Csyntax.Eval(Vsingle x)tfloat.
Definition wr (id:ident)(r:expr) := Sdo(Eassign(fld id)r tfloat).
Definition bound_stmt :=
 Sifthenelse(Eunop Onotbool(Ebinop Ogt(rd Source._omega)(cn omega_min)tint)tint)
  (wr Source._omega(cn omega_min))
  (Sifthenelse(Eunop Onotbool(Ebinop Olt(rd Source._omega)(cn omega_max)tint)tint)
    (wr Source._omega(cn omega_max)) Sskip).
Definition square_stmt := wr Source._omega_2(Ebinop Omul(rd Source._omega)(rd Source._omega)tfloat).
Definition product_stmt := wr Source._zeta_omega(Ebinop Omul(rd Source._zeta)(rd Source._omega)tfloat).
Lemma body_shape : fn_body omega_function = Ssequence
 (wr Source._omega(Evalof(Evar Source._omega tfloat)tfloat))
 (Ssequence bound_stmt(Ssequence square_stmt(Ssequence product_stmt(Sreturn(Some(rd Source._omega)))))).
Proof. reflexivity. Qed.
Lemma field_location : forall e m b id ofs,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 (id=Source._omega /\ ofs=36 \/ id=Source._zeta /\ ofs=40 \/ id=Source._zeta_omega /\ ofs=48 \/ id=Source._omega_2 /\ ofs=52) ->
 pure_lval omega_ge e m(fld id)=Some(b,Ptrofs.repr ofs,Full).
Proof.
 intros e m b id ofs ENV SYM [[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]]. 
 all: (unfold fld; eapply global_field_location; [exact ENV|exact SYM|reflexivity|reflexivity]).
Qed.
Lemma read_field : forall e m b id ofs x,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 (id=Source._omega /\ ofs=36 \/ id=Source._zeta /\ ofs=40 \/ id=Source._zeta_omega /\ ofs=48 \/ id=Source._omega_2 /\ ofs=52) ->
 Mem.load Mfloat32 m b ofs=Some(Vsingle x) ->
 pure_rval omega_ge e m(rd id)=Some(Vsingle x).
Proof.
 intros e m b id ofs x ENV SYM OFF LD; unfold rd.
 eapply read_single_location with (b:=b)(offset:=ofs); [reflexivity|exact(field_location e m b id ofs ENV SYM OFF)| | |exact LD];
 destruct OFF as [[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]]; vm_compute; congruence.
Qed.
Lemma write_field : forall e m b id ofs r x mf,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 (id=Source._omega /\ ofs=36 \/ id=Source._zeta /\ ofs=40 \/ id=Source._zeta_omega /\ ofs=48 \/ id=Source._omega_2 /\ ofs=52) ->
 typeof r=tfloat -> pure_rval omega_ge e m r=Some(Vsingle x) ->
 Mem.store Mfloat32 m b ofs(Vsingle x)=Some mf ->
 stmt_eval omega_ge e tfloat(wr id r)m=Some(Nnormal,mf).
Proof.
 intros e m b id ofs r x mf ENV SYM OFF TY RV ST; unfold wr.
 eapply assign_single_location with (b:=b)(offset:=ofs); [reflexivity|exact TY|exact(field_location e m b id ofs ENV SYM OFF)|exact RV| | |exact ST];
 destruct OFF as [[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]]; vm_compute;congruence.
Qed.
Lemma read_parameter : forall ge e m id bx f,
 PTree.get id e=Some(bx,tfloat) -> Mem.load Mfloat32 m bx 0=Some(Vsingle f) ->
 pure_rval ge e m (Evalof(Evar id tfloat)tfloat)=Some(Vsingle f).
Proof.
 intros ge e m id bx f LOOK LOAD. cbn [pure_rval pure_lval].  rewrite LOOK.
 repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world tfloat m bx Ptrofs.zero Full=Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
 - eapply deref_loc_value;[reflexivity|reflexivity|].  unfold Mem.loadv.
   rewrite Ptrofs.unsigned_zero. rewrite zle_true;[exact LOAD|change(4<=18446744073709551616)%Z;lia]. 
 - constructor. }
 rewrite D;reflexivity.
Qed.
Lemma sequence_normal : forall ge e ret a b m ma out mf,
 stmt_eval ge e ret a m=Some(Nnormal,ma) ->
 stmt_eval ge e ret b ma=Some(out,mf) ->
 stmt_eval ge e ret(Ssequence a b)m=Some(out,mf).
Proof. intros;cbn [stmt_eval];rewrite H;exact H0. Qed.

Definition preserves_access(m mf:mem):Prop := forall ch bx ofs p, Mem.valid_access m ch bx ofs p -> Mem.valid_access mf ch bx ofs p.
Lemma write_exists : forall s m b e id ofs r x,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 (id=Source._omega /\ ofs=36 \/ id=Source._zeta /\ ofs=40 \/ id=Source._zeta_omega /\ ofs=48 \/ id=Source._omega_2 /\ ofs=52) ->
 repr s m b -> writable m b -> typeof r=tfloat ->
 pure_rval omega_ge e m r=Some(Vsingle x) ->
 exists mf, stmt_eval omega_ge e tfloat(wr id r)m=Some(Nnormal,mf) /\
 repr(replace_float s ofs x)mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e id ofs r x ENV SYM OFF REP W TY RV.
 assert(IN:In ofs float_offsets).
 { destruct OFF as [[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]];unfold float_offsets;simpl;tauto. }
 destruct(Mem.valid_access_store m Mfloat32 b ofs(Vsingle x)(writable_float_access _ _ _ W IN))as[mf ST]. 
 exists mf;split;[eapply write_field;eauto|]. split;[eapply repr_store_float;eauto|]. split;[eapply writable_store;eauto|].
 unfold preserves_access;intros;eapply Mem.store_valid_access_1;eauto. 
Qed.
Lemma if_boolean : forall ge e ret a yes no m flag,
 typeof a=tint -> pure_rval ge e m a=Some(Val.of_bool flag) ->
 stmt_eval ge e ret(Sifthenelse a yes no)m=stmt_eval ge e ret(if flag then yes else no)m.
Proof.
 intros ge e ret a yes no m flag TY RV.
 cbn [stmt_eval]; rewrite RV,TY;destruct flag;reflexivity.
Qed.
Lemma not_compare : forall e m a x c op cmp,
 (op=Ogt /\ cmp=Cgt \/ op=Olt /\ cmp=Clt) -> typeof a=tfloat ->
 pure_rval omega_ge e m a=Some(Vsingle x) ->
 pure_rval omega_ge e m(Eunop Onotbool(Ebinop op a(cn c)tint)tint)=
 Some(Val.of_bool(negb(Float32.cmp cmp x c))).
Proof.
 intros e m a x c op cmp OP TY RV.
 assert(C: pure_rval omega_ge e m(Ebinop op a(cn c)tint)=Some(Val.of_bool(Float32.cmp cmp x c))).
 { eapply pure_single_comparison;[exact OP|exact TY|reflexivity|exact RV|reflexivity].  }
 change((match pure_rval omega_ge e m(Ebinop op a(cn c)tint)with Some v=>sem_unary_operation Onotbool v tint m|None=>None end)=Some(Val.of_bool(negb(Float32.cmp cmp x c)))).
 rewrite C;destruct(Float32.cmp cmp x c);reflexivity.
Qed.
Lemma replace_omega_identity : forall s,replace_float s 36(omega s)=s.
Proof. intros [];reflexivity. Qed.
Lemma bound_eval : forall s m b e,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval omega_ge e tfloat bound_stmt m=Some(Nnormal,mf) /\
 repr(replace_float s 36(clamp_omega(omega s)))mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e ENV SYM REP W.
 assert(LD:Mem.load Mfloat32 m b 36=Some(Vsingle(omega s)))by(unfold repr in REP;tauto).
 assert(RD:pure_rval omega_ge e m(rd Source._omega)=Some(Vsingle(omega s))).
 { eapply read_field;eauto;left;auto. }
 pose proof(not_compare e m(rd Source._omega)(omega s) omega_min Ogt Cgt (or_introl(conj eq_refl eq_refl))eq_refl RD)as CMP1.
 pose proof(not_compare e m(rd Source._omega)(omega s) omega_max Olt Clt (or_intror(conj eq_refl eq_refl))eq_refl RD)as CMP2.
 unfold bound_stmt.
 erewrite if_boolean by (exact CMP1 || reflexivity).
 unfold clamp_omega,bound.
 destruct(Float32.cmp Cgt(omega s)omega_min)eqn:C1;cbn [negb].
 - erewrite if_boolean by (exact CMP2 || reflexivity).
   destruct(Float32.cmp Clt(omega s)omega_max)eqn:C2;cbn [negb].
   + exists m;split;[reflexivity|]. rewrite replace_omega_identity;split;[exact REP|]. split;[exact W|]. unfold preserves_access;auto.
   + eapply write_exists;eauto;try reflexivity;left;auto. 
 - eapply write_exists;eauto;try reflexivity;left;auto. 
Qed.


Lemma square_eval : forall s m b e,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval omega_ge e tfloat square_stmt m=Some(Nnormal,mf) /\
 repr(replace_float s 52(Float32.mul(omega s)(omega s)))mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e ENV SYM REP W.
 assert(O:pure_rval omega_ge e m(rd Source._omega)=Some(Vsingle(omega s))).
 { eapply read_field with (b:=b)(ofs:=36);[exact ENV|exact SYM|left;auto|unfold repr in REP;tauto].  }
 unfold square_stmt;eapply write_exists;[exact ENV|exact SYM|right;right;right;auto|exact REP|exact W|reflexivity|].
 eapply pure_single_mul;[reflexivity|reflexivity|exact O|exact O]. 
Qed.
Lemma product_eval : forall s m b e,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval omega_ge e tfloat product_stmt m=Some(Nnormal,mf) /\
 repr(replace_float s 48(Float32.mul(zeta s)(omega s)))mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e ENV SYM REP W.
 assert(Z:pure_rval omega_ge e m(rd Source._zeta)=Some(Vsingle(zeta s))).
 { eapply read_field with (b:=b)(ofs:=40);[exact ENV|exact SYM|right;left;auto|unfold repr in REP;tauto].  }
 assert(O:pure_rval omega_ge e m(rd Source._omega)=Some(Vsingle(omega s))).
 { eapply read_field with (b:=b)(ofs:=36);[exact ENV|exact SYM|left;auto|unfold repr in REP;tauto].  }
 unfold product_stmt;eapply write_exists;[exact ENV|exact SYM|right;right;left;auto|exact REP|exact W|reflexivity|].
 eapply pure_single_mul;[reflexivity|reflexivity|exact Z|exact O]. 
Qed.
Lemma body_eval : forall s m b e bx o,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol omega_ge Source._gh_ref=Some b ->
 PTree.get Source._omega e=Some(bx,tfloat) ->
 Mem.load Mfloat32 m bx 0=Some(Vsingle o) ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval omega_ge e tfloat(fn_body omega_function)m=Some(Nreturn(Vsingle(clamp_omega o)),mf) /\
 repr(set_omega s o)mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e bx o ENV SYM LOOK LOAD REP W.
 assert(P:pure_rval omega_ge e m(Evalof(Evar Source._omega tfloat)tfloat)=Some(Vsingle o))by(eapply read_parameter;eauto).
 destruct(write_exists s m b e Source._omega 36(Evalof(Evar Source._omega tfloat)tfloat)o ENV SYM (or_introl(conj eq_refl eq_refl))REP W eq_refl P)as[m1[E1[R1[W1 A1]]]]. 
 destruct(bound_eval _ _ _ _ ENV SYM R1 W1)as[m2[E2[R2[W2 A2]]]]. 
 destruct(square_eval _ _ _ _ ENV SYM R2 W2)as[m3[E3[R3[W3 A3]]]]. 
 destruct(product_eval _ _ _ _ ENV SYM R3 W3)as[m4[E4[R4[W4 A4]]]]. 
 change(repr(set_omega s o)m4 b)in R4.
 assert(RD:pure_rval omega_ge e m4(rd Source._omega)=Some(Vsingle(clamp_omega o))).
 { eapply read_field with (b:=b)(ofs:=36);[exact ENV|exact SYM|left;auto|unfold repr,set_omega in R4;simpl in R4;tauto].  }
 exists m4;split;[|split;[exact R4|];split;[exact W4|unfold preserves_access in *;eauto]]. rewrite body_shape.
 eapply sequence_normal;[exact E1|]. eapply sequence_normal;[exact E2|]. eapply sequence_normal;[exact E3|]. eapply sequence_normal;[exact E4|]. 
 change((match pure_rval omega_ge e m4(rd Source._omega)with Some v=>match sem_cast v tfloat tfloat m4 with Some v'=>Some(Nreturn v',m4)|None=>None end|None=>None end)=Some(Nreturn(Vsingle(clamp_omega o)),m4)).
 rewrite RD;reflexivity.
Qed.

Lemma entry_denotation : forall s o m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists mf,state_eval omega_ge(Execution.entry[Vsingle o]m)=Some(Vsingle(clamp_omega o),mf) /\
 repr(set_omega s o)mf b /\ writable mf b.
Proof.
 intros s o m b SYM REP W.
 destruct(Mem.alloc m 0 4)as[ma bx]eqn:ALLOC.
 set(e:=PTree.set Source._omega(bx,tfloat)empty_env).
 assert(LOOK:PTree.get Source._omega e=Some(bx,tfloat))by reflexivity.
 assert(ENV:PTree.get Source._gh_ref e=None)by reflexivity.
 assert(VB:Mem.valid_block m b).
 { eapply Mem.perm_valid_block with (ofs:=0)(k:=Cur)(p:=Writable);apply W;lia. }
 assert(D:b<>bx).
 { intro EQ;subst bx;exact(Mem.fresh_block_alloc _ _ _ _ _ ALLOC VB). }
 assert(ACCESS:Mem.valid_access ma Mfloat32 bx 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WR:Mem.valid_access ma Mfloat32 bx 0 Writable)by(eapply Mem.valid_access_freeable_any;exact ACCESS).
 destruct(Mem.valid_access_store ma Mfloat32 bx 0(Vsingle o)WR)as[m1 STORE].
 assert(RA:repr s ma b)by(eapply repr_alloc;eauto).
 assert(WA:writable ma b)by(eapply writable_alloc;eauto).
 assert(R1:repr s m1 b)by(eapply repr_store_other;eauto).
 assert(W1:writable m1 b)by(eapply writable_store_other;eauto).
 assert(LD:Mem.load Mfloat32 m1 bx 0=Some(Vsingle o)).
 { erewrite Mem.load_store_same by exact STORE;reflexivity. }
 destruct(body_eval s m1 b e bx o ENV SYM LOOK LD R1 W1)as[m2[BODY[R2[W2 KEEP]]]].
 assert(FREEABLE:Mem.valid_access m2 Mfloat32 bx 0 Freeable).
 { apply KEEP;eapply Mem.store_valid_access_1;[exact STORE|exact ACCESS]. }
 destruct(Mem.range_perm_free m2 bx 0 4(proj1 FREEABLE))as[mf FREE].
 exists mf;split.
 - assert(AV:alloc_variables omega_ge empty_env m(fn_params omega_function++fn_vars omega_function)e ma).
   { change(alloc_variables omega_ge empty_env m[(Source._omega,tfloat)]e ma).
     eapply alloc_variables_cons;[exact ALLOC|constructor]. }
   assert(BIND:bind_parameters omega_ge e ma(fn_params omega_function)[Vsingle o]m1).
   { change(bind_parameters omega_ge e ma[(Source._omega,tfloat)][Vsingle o]m1).
     eapply bind_parameters_cons;[exact LOOK| |constructor].
     eapply assign_loc_value;[reflexivity|reflexivity|exact STORE]. }
   change(state_eval omega_ge(omega_start(Vsingle o)m)=Some(Vsingle(clamp_omega o),mf)).
   cbn [state_eval omega_start].
   rewrite(do_alloc_variables_complete _ _ _ _ _ _ AV).
   rewrite(sem_bind_parameters_complete _ quiet_world _ _ _ _ _ BIND).
   change((match stmt_eval omega_ge e tfloat(fn_body omega_function)m1 with
   |Some(out,mx)=>cont_eval omega_ge e tfloat Kstop out mx|None=>None end)=Some(Vsingle(clamp_omega o),mf)).
   rewrite BODY.
   change((match Mem.free_list m2[(bx,0,4)]with Some mx=>Some(Vsingle(clamp_omega o),mx)|None=>None end)=Some(Vsingle(clamp_omega o),mf)).
   cbn [Mem.free_list];rewrite FREE;reflexivity.
 - split;[eapply repr_free_other;eauto|eapply writable_free_other;eauto].
Qed.

Lemma invariant_has_return : forall initial,
 execution_invariant initial ->
 exists t v mf,star Csem.step omega_ge initial t(Returnstate v Kstop mf).
Proof.
 intros initial INV.
 pose proof(source_accessible initial(proj1 INV))as ACC.
 revert INV;induction ACC as[initial ACC IH];intros INV.
 destruct(invariant_progress initial INV)as[[v[mf EQ]]|[t[next STEP]]].
 - subst initial;exists E0,v,mf;constructor.
 - destruct(IH next (ex_intro _ t STEP)(invariant_preserved _ _ _ INV STEP))as[rest[v[mf PATH]]].
   exists(t++rest),v,mf;eapply star_step;[exact STEP|exact PATH|reflexivity].
Qed.
Lemma entry_invariant : forall s o m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 execution_invariant(Execution.entry[Vsingle o]m).
Proof.
 intros s o m b SYM REP W.
 destruct(entry_denotation s o m b SYM REP W)as[mf[EVAL REST]].
 split;[split;reflexivity|]. split;[reflexivity|]. eauto.
Qed.
Theorem entry_return_spec : forall s o m b t v mf,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step Execution.ge(Execution.entry[Vsingle o]m)t(Returnstate v Kstop mf) ->
 v=Vsingle(clamp_omega o) /\ repr(set_omega s o)mf b /\ writable mf b.
Proof.
 intros s o m b t v mf SYM REP W PATH.
 destruct(entry_denotation s o m b SYM REP W)as[expected[EV[RF WF]]].
 assert(E:state_eval omega_ge(Execution.entry[Vsingle o]m)=Some(v,mf)).
 { eapply all_order_normal_correspondence;[split;reflexivity|reflexivity|exact PATH]. }
 rewrite EV in E;injection E as V M;subst v mf;auto.
Qed.
Theorem entry_normal : forall s o m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists t mf,star Csem.step Execution.ge(Execution.entry[Vsingle o]m)t
 (Returnstate(Vsingle(clamp_omega o))Kstop mf) /\ repr(set_omega s o)mf b /\ writable mf b.
Proof.
 intros s o m b SYM REP W.
 destruct(invariant_has_return _ (entry_invariant s o m b SYM REP W))as[t[v[mf PATH]]].
 destruct(entry_return_spec s o m b t v mf SYM REP W PATH)as[-> REST]. eauto.
Qed.
Theorem entry_no_error : forall s o m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 forall t reached,star Csem.step Execution.ge(Execution.entry[Vsingle o]m)t reached ->
 ~Execution.source_error reached.
Proof.
 intros s o m b SYM REP W t reached PATH.
 change(~Invariant.source_error reached).
 apply invariant_excludes_error.
 eapply reachable_invariant;[exact(entry_invariant s o m b SYM REP W)|exact PATH].
Qed.
Theorem entry_terminates : forall args m,
 Acc(FiveShared.verification.Obligations.successor Execution.ge)(Execution.entry args m).
Proof. intros;apply source_accessible;split;reflexivity. Qed.
Print Assumptions entry_normal.
Print Assumptions entry_return_spec.
Print Assumptions entry_no_error.
Print Assumptions entry_terminates.
