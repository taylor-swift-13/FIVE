From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGhSetZeta Require Import Source Execution.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveGhSetZetaProof Require Import SourceInvariant NormalCorrespondence Invariant Termination.
From FivePaparazziState Require Import State MemorySupport.
From FiveGhSetZetaProof Require Import FieldSupport.
Import ListNotations.
Local Open Scope Z_scope.
Definition fld (id:ident) := global_field Source._gh_ref Source._GuidanceHRef id.
Definition rd (id:ident) := Evalof (fld id) tfloat.
Definition cn (x:float32) := Csyntax.Eval(Vsingle x)tfloat.
Definition wr (id:ident)(r:expr) := Sdo(Eassign(fld id)r tfloat).
Definition bound_stmt :=
 Sifthenelse(Eunop Onotbool(Ebinop Ogt(rd Source._zeta)(cn zeta_min)tint)tint)
  (wr Source._zeta(cn zeta_min))
  (Sifthenelse(Eunop Onotbool(Ebinop Olt(rd Source._zeta)(cn zeta_max)tint)tint)
    (wr Source._zeta(cn zeta_max)) Sskip).
Definition product_stmt := wr Source._zeta_omega(Ebinop Omul(rd Source._zeta)(rd Source._omega)tfloat).
Lemma body_shape : fn_body zeta_function = Ssequence
 (wr Source._zeta(Evalof(Evar Source._zeta tfloat)tfloat))
 (Ssequence bound_stmt(Ssequence product_stmt(Sreturn(Some(rd Source._zeta))))).
Proof. reflexivity. Qed.
Lemma field_location : forall e m b id ofs,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 (id=Source._zeta /\ ofs=40 \/ id=Source._omega /\ ofs=36 \/ id=Source._zeta_omega /\ ofs=48) ->
 pure_lval zeta_ge e m(fld id)=Some(b,Ptrofs.repr ofs,Full).
Proof.
 intros e m b id ofs ENV SYM [[-> ->]|[[-> ->]|[-> ->]]].
 all:(unfold fld; eapply global_field_location; [exact ENV|exact SYM|reflexivity|reflexivity]).
Qed.
Lemma read_field : forall e m b id ofs x,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 (id=Source._zeta /\ ofs=40 \/ id=Source._omega /\ ofs=36 \/ id=Source._zeta_omega /\ ofs=48) ->
 Mem.load Mfloat32 m b ofs=Some(Vsingle x) ->
 pure_rval zeta_ge e m(rd id)=Some(Vsingle x).
Proof.
 intros e m b id ofs x ENV SYM OFF LD; unfold rd.
 eapply read_single_location with (b:=b)(offset:=ofs); [reflexivity|eapply field_location;eauto| | |exact LD];
 destruct OFF as [[-> ->]|[[-> ->]|[-> ->]]]; try lia.
 all:change Ptrofs.modulus with 18446744073709551616;lia.
Qed.
Lemma write_field : forall e m b id ofs r x mf,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 (id=Source._zeta /\ ofs=40 \/ id=Source._omega /\ ofs=36 \/ id=Source._zeta_omega /\ ofs=48) ->
 typeof r=tfloat -> pure_rval zeta_ge e m r=Some(Vsingle x) ->
 Mem.store Mfloat32 m b ofs(Vsingle x)=Some mf ->
 stmt_eval zeta_ge e tfloat(wr id r)m=Some(Nnormal,mf).
Proof.
 intros e m b id ofs r x mf ENV SYM OFF TY RV ST; unfold wr.
 eapply assign_single_location with (b:=b)(offset:=ofs); [reflexivity|exact TY|eapply field_location;eauto|exact RV| | |exact ST];
 destruct OFF as [[-> ->]|[[-> ->]|[-> ->]]]; try lia.
 all:change Ptrofs.modulus with 18446744073709551616;lia.
Qed.
Lemma read_parameter : forall ge e m id bx f,
 PTree.get id e=Some(bx,tfloat) -> Mem.load Mfloat32 m bx 0=Some(Vsingle f) ->
 pure_rval ge e m (Evalof(Evar id tfloat)tfloat)=Some(Vsingle f).
Proof.
 intros ge e m id bx f LOOK LOAD. cbn [pure_rval pure_lval]. rewrite LOOK.
 repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world tfloat m bx Ptrofs.zero Full=Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
 - eapply deref_loc_value;[reflexivity|reflexivity|]. unfold Mem.loadv.
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
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 (id=Source._zeta /\ ofs=40 \/ id=Source._omega /\ ofs=36 \/ id=Source._zeta_omega /\ ofs=48) ->
 repr s m b -> writable m b -> typeof r=tfloat ->
 pure_rval zeta_ge e m r=Some(Vsingle x) ->
 exists mf, stmt_eval zeta_ge e tfloat(wr id r)m=Some(Nnormal,mf) /\
 repr(replace_float s ofs x)mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e id ofs r x ENV SYM OFF REP W TY RV.
 assert(IN:In ofs float_offsets).
 { destruct OFF as [[-> ->]|[[-> ->]|[-> ->]]];unfold float_offsets;simpl;tauto. }
 destruct(Mem.valid_access_store m Mfloat32 b ofs(Vsingle x)(writable_float_access _ _ _ W IN))as[mf ST].
 exists mf;split;[eapply write_field;eauto|]. split;[eapply repr_store_float;eauto|]. split;[eapply writable_store;eauto|].
 unfold preserves_access;intros;eapply Mem.store_valid_access_1;eauto.
Qed.
Lemma if_boolean : forall ge e ret a yes no m flag,
 typeof a=tint -> pure_rval ge e m a=Some(Val.of_bool flag) ->
 stmt_eval ge e ret(Sifthenelse a yes no)m=stmt_eval ge e ret(if flag then yes else no)m.
Proof. intros ge e ret a yes no m flag TY RV. cbn [stmt_eval];rewrite RV,TY;destruct flag;reflexivity. Qed.
Lemma not_compare : forall e m a x c op cmp,
 (op=Ogt /\ cmp=Cgt \/ op=Olt /\ cmp=Clt) -> typeof a=tfloat ->
 pure_rval zeta_ge e m a=Some(Vsingle x) ->
 pure_rval zeta_ge e m(Eunop Onotbool(Ebinop op a(cn c)tint)tint)=
 Some(Val.of_bool(negb(Float32.cmp cmp x c))).
Proof.
 intros e m a x c op cmp OP TY RV.
 assert(C: pure_rval zeta_ge e m(Ebinop op a(cn c)tint)=Some(Val.of_bool(Float32.cmp cmp x c))).
 { eapply pure_single_comparison;[exact OP|exact TY|reflexivity|exact RV|reflexivity]. }
 change((match pure_rval zeta_ge e m(Ebinop op a(cn c)tint)with Some v=>sem_unary_operation Onotbool v tint m|None=>None end)=Some(Val.of_bool(negb(Float32.cmp cmp x c)))).
 rewrite C;destruct(Float32.cmp cmp x c);reflexivity.
Qed.
Lemma replace_zeta_identity : forall s,replace_float s 40(zeta s)=s.
Proof. intros [];reflexivity. Qed.
Lemma bound_eval : forall s m b e,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval zeta_ge e tfloat bound_stmt m=Some(Nnormal,mf) /\
 repr(replace_float s 40(clamp_zeta(zeta s)))mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e ENV SYM REP W.
 assert(LD:Mem.load Mfloat32 m b 40=Some(Vsingle(zeta s)))by(unfold repr in REP;tauto).
 assert(RD:pure_rval zeta_ge e m(rd Source._zeta)=Some(Vsingle(zeta s))).
 { eapply read_field;eauto;left;auto. }
 pose proof(not_compare e m(rd Source._zeta)(zeta s) zeta_min Ogt Cgt (or_introl(conj eq_refl eq_refl))eq_refl RD)as CMP1.
 pose proof(not_compare e m(rd Source._zeta)(zeta s) zeta_max Olt Clt (or_intror(conj eq_refl eq_refl))eq_refl RD)as CMP2.
 unfold bound_stmt.
 erewrite if_boolean by(exact CMP1 || reflexivity).
 unfold clamp_zeta,bound.
 destruct(Float32.cmp Cgt(zeta s)zeta_min)eqn:C1;cbn [negb].
 - erewrite if_boolean by(exact CMP2 || reflexivity).
   destruct(Float32.cmp Clt(zeta s)zeta_max)eqn:C2;cbn [negb].
   + exists m;split;[reflexivity|]. rewrite replace_zeta_identity;split;[exact REP|]. split;[exact W|]. unfold preserves_access;auto.
   + eapply write_exists;eauto;try reflexivity;left;auto.
 - eapply write_exists;eauto;try reflexivity;left;auto.
Qed.

Lemma product_eval : forall s m b e,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval zeta_ge e tfloat product_stmt m=Some(Nnormal,mf) /\
 repr(replace_float s 48(Float32.mul(zeta s)(omega s)))mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e ENV SYM REP W.
 assert(Z:pure_rval zeta_ge e m(rd Source._zeta)=Some(Vsingle(zeta s))).
 { eapply read_field with (b:=b)(ofs:=40);[exact ENV|exact SYM|left;auto|unfold repr in REP;tauto]. }
 assert(O:pure_rval zeta_ge e m(rd Source._omega)=Some(Vsingle(omega s))).
 { eapply read_field with (b:=b)(ofs:=36);[exact ENV|exact SYM|right;left;auto|unfold repr in REP;tauto]. }
 unfold product_stmt;eapply write_exists;[exact ENV|exact SYM|right;right;auto|exact REP|exact W|reflexivity|].
 eapply pure_single_mul;[reflexivity|reflexivity|exact Z|exact O].
Qed.
Lemma body_eval : forall s m b e bx z,
 PTree.get Source._gh_ref e=None -> Genv.find_symbol zeta_ge Source._gh_ref=Some b ->
 PTree.get Source._zeta e=Some(bx,tfloat) ->
 Mem.load Mfloat32 m bx 0=Some(Vsingle z) ->
 repr s m b -> writable m b ->
 exists mf,stmt_eval zeta_ge e tfloat(fn_body zeta_function)m=Some(Nreturn(Vsingle(clamp_zeta z)),mf) /\
 repr(set_zeta s z)mf b /\ writable mf b /\ preserves_access m mf.
Proof.
 intros s m b e bx z ENV SYM LOOK LOAD REP W.
 assert(P:pure_rval zeta_ge e m(Evalof(Evar Source._zeta tfloat)tfloat)=Some(Vsingle z))by(eapply read_parameter;eauto).
 destruct(write_exists s m b e Source._zeta 40(Evalof(Evar Source._zeta tfloat)tfloat)z ENV SYM (or_introl(conj eq_refl eq_refl))REP W eq_refl P)as[m1[E1[R1[W1 A1]]]].
 destruct(bound_eval _ _ _ _ ENV SYM R1 W1)as[m2[E2[R2[W2 A2]]]].
 destruct(product_eval _ _ _ _ ENV SYM R2 W2)as[m3[E3[R3[W3 A3]]]].
 change(repr(set_zeta s z)m3 b)in R3.
 assert(RD:pure_rval zeta_ge e m3(rd Source._zeta)=Some(Vsingle(clamp_zeta z))).
 { eapply read_field with (b:=b)(ofs:=40);[exact ENV|exact SYM|left;auto|unfold repr,set_zeta in R3;simpl in R3;tauto]. }
 exists m3;split;[|split;[exact R3|];split;[exact W3|unfold preserves_access in *;eauto]]. rewrite body_shape.
 eapply sequence_normal;[exact E1|]. eapply sequence_normal;[exact E2|]. eapply sequence_normal;[exact E3|].
 change((match pure_rval zeta_ge e m3(rd Source._zeta)with Some v=>match sem_cast v tfloat tfloat m3 with Some v'=>Some(Nreturn v',m3)|None=>None end|None=>None end)=Some(Nreturn(Vsingle(clamp_zeta z)),m3)).
 rewrite RD;reflexivity.
Qed.

Definition parameter_env(bx:block):env := PTree.set Source._zeta(bx,tfloat)empty_env.
Lemma typed_entry_result : forall s m b z,
 Genv.find_symbol zeta_ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists mf,state_eval zeta_ge(zeta_start(Vsingle z)m)=Some(Vsingle(clamp_zeta z),mf) /\
 repr(set_zeta s z)mf b /\ writable mf b.
Proof.
 intros s m b z SYM REP W.
 destruct(Mem.alloc m 0 4)as[ma bx]eqn:AA.
 set(e:=parameter_env bx).
 assert(LOOK:PTree.get Source._zeta e=Some(bx,tfloat))by reflexivity.
 assert(ENV:PTree.get Source._gh_ref e=None)by reflexivity.
 assert(ALLOC:alloc_variables zeta_ge empty_env m(fn_params zeta_function++fn_vars zeta_function)e ma).
 { change(alloc_variables zeta_ge empty_env m[(Source._zeta,tfloat)]e ma).
 eapply alloc_variables_cons;[exact AA|constructor]. }
 assert(VB:Mem.valid_block m b).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable). apply W. lia. }
 assert(DIST:b<>bx).
 { intro EQ;subst bx;exact(Mem.fresh_block_alloc _ _ _ _ _ AA VB). }
 assert(WA:Mem.valid_access ma Mfloat32 bx 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AA|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store ma Mfloat32 bx 0(Vsingle z)(Mem.valid_access_freeable_any _ _ _ _ _ WA))as[m1 ST].
 assert(BIND:bind_parameters zeta_ge e ma(fn_params zeta_function)[Vsingle z]m1).
 { change(bind_parameters zeta_ge e ma[(Source._zeta,tfloat)][Vsingle z]m1).
 eapply bind_parameters_cons;[exact LOOK| |constructor]. eapply assign_loc_value;[reflexivity|reflexivity|exact ST]. }
 assert(LD:Mem.load Mfloat32 m1 bx 0=Some(Vsingle z)).
 { erewrite Mem.load_store_same by exact ST;reflexivity. }
 assert(R1:repr s m1 b).
 { eapply repr_store_other;[eapply repr_alloc;eauto|exact DIST|exact ST]. }
 assert(W1:writable m1 b).
 { eapply writable_store_other;[eapply writable_alloc;eauto|exact ST]. }
 destruct(body_eval s m1 b e bx z ENV SYM LOOK LD R1 W1)as[m2[BODY[R2[W2 ACCESS]]]].
 assert(WF:Mem.valid_access m2 Mfloat32 bx 0 Freeable).
 { apply ACCESS. eapply Mem.store_valid_access_1;[exact ST|exact WA]. }
 destruct(Mem.range_perm_free m2 bx 0 4(proj1 WF))as[mf FREE].
 exists mf;split.
 - cbn [state_eval zeta_start].
 rewrite(do_alloc_variables_complete zeta_ge _ _ _ _ _ ALLOC).
 rewrite(sem_bind_parameters_complete zeta_ge quiet_world _ _ _ _ _ BIND).
 change((match stmt_eval zeta_ge e tfloat(fn_body zeta_function)m1 with Some(out,mx)=>cont_eval zeta_ge e tfloat Kstop out mx|None=>None end)=Some(Vsingle(clamp_zeta z),mf)).
 rewrite BODY.
 change((match Mem.free_list m2[(bx,0,4)]with Some mx=>Some(Vsingle(clamp_zeta z),mx)|None=>None end)=Some(Vsingle(clamp_zeta z),mf)).
 cbn [Mem.free_list];rewrite FREE;reflexivity.
 - split;[eapply repr_free_other;eauto|eapply writable_free_other;eauto].
Qed.

Lemma entry_denotation : forall s z m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists mf,state_eval zeta_ge(Execution.entry[Vsingle z]m)=Some(Vsingle(clamp_zeta z),mf) /\ repr(set_zeta s z)mf b /\ writable mf b.
Proof. intros;eapply typed_entry_result;eauto. Qed.
Lemma invariant_has_return : forall initial,
 execution_invariant initial ->
 exists t v mf,star Csem.step zeta_ge initial t(Returnstate v Kstop mf).
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
 v=Vsingle(clamp_zeta o) /\ repr(set_zeta s o)mf b /\ writable mf b.
Proof.
 intros s o m b t v mf SYM REP W PATH.
 destruct(entry_denotation s o m b SYM REP W)as[expected[EV[RF WF]]].
 assert(E:state_eval zeta_ge(Execution.entry[Vsingle o]m)=Some(v,mf)).
 { eapply all_order_normal_correspondence;[split;reflexivity|reflexivity|exact PATH]. }
 rewrite EV in E;injection E as V M;subst v mf;auto.
Qed.
Theorem entry_normal : forall s o m b,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists t mf,star Csem.step Execution.ge(Execution.entry[Vsingle o]m)t
 (Returnstate(Vsingle(clamp_zeta o))Kstop mf) /\ repr(set_zeta s o)mf b /\ writable mf b.
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
