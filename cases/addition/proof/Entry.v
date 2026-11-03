From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Smallstep.
From compcert Require Import Csem Cexec Cstrategy.
From FiveShared.strict_execution Require Import Source.
From FiveCases.addition.proof.support Require Import SimpleFacts SourceInvariant NormalCorrespondence PureProgress Invariant.
Import ListNotations.
Local Open Scope Z_scope.

Definition frame_env (ba bb:block):env :=
 PTree.set Source._b (bb,tfloat) (PTree.set Source._a (ba,tfloat) empty_env).
Lemma frame_lookup : forall ba bb,
 PTree.get Source._a(frame_env ba bb)=Some(ba,tfloat) /\
 PTree.get Source._b(frame_env ba bb)=Some(bb,tfloat).
Proof. intros;split;reflexivity. Qed.
Lemma frame_blocks : forall ba bb,
 blocks_of_env addition_ge(frame_env ba bb)=[(ba,0,4);(bb,0,4)].
Proof. reflexivity. Qed.

Lemma read_parameter : forall ge e m id bx f,
 PTree.get id e=Some(bx,tfloat) ->
 Mem.load Mfloat32 m bx 0=Some(Vsingle f) ->
 pure_rval ge e m (Evalof(Evar id tfloat)tfloat)=Some(Vsingle f).
Proof.
 intros ge e m id bx f LOOK LOAD.
 cbn [pure_rval pure_lval]. rewrite LOOK. repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world tfloat m bx Ptrofs.zero Full=
  Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
   - eapply deref_loc_value;[reflexivity|reflexivity|].
     unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
     rewrite zle_true;[exact LOAD|change(4<=18446744073709551616)%Z;lia].
   - constructor. }
 rewrite D;reflexivity.
Qed.

Lemma pure_single_add : forall ge e m a b x y,
 typeof a=tfloat -> typeof b=tfloat ->
 pure_rval ge e m a=Some(Vsingle x) ->
 pure_rval ge e m b=Some(Vsingle y) ->
 pure_rval ge e m(Ebinop Oadd a b tfloat)=Some(Vsingle(Float32.add x y)).
Proof.
 intros ge e m a b x y TA TB A B.
 change((match pure_rval ge e m a,pure_rval ge e m b with
 |Some v,Some w=>sem_binary_operation ge Oadd v(typeof a)w(typeof b)m
 |_,_=>None end)=Some(Vsingle(Float32.add x y))).
 rewrite A,B,TA,TB;reflexivity.
Qed.

Lemma return_single : forall ge e m a f,
 typeof a=tfloat -> pure_rval ge e m a=Some(Vsingle f) ->
 stmt_eval ge e tfloat(Sreturn(Some a))m=Some(Nreturn(Vsingle f),m).
Proof. intros ge e m a f TY READ;cbn [stmt_eval];rewrite READ,TY;reflexivity. Qed.

Theorem typed_entry_establishes_invariant : forall m(a b:float32),
 execution_invariant(addition_start(Vsingle a)(Vsingle b)m).
Proof.
 intros m a b.
 destruct(Mem.alloc m 0 4)as [mA ba]eqn:AA.
 destruct(Mem.alloc mA 0 4)as [ma bb]eqn:AB.
 set(e:=frame_env ba bb).
 destruct(frame_lookup ba bb)as [EA EB].
 assert(ALLOC:alloc_variables addition_ge empty_env m
  (fn_params addition_function++fn_vars addition_function)e ma).
 { change(alloc_variables addition_ge empty_env m
   [(Source._a,tfloat);(Source._b,tfloat)]e ma).
   eapply alloc_variables_cons;[exact AA|].
   eapply alloc_variables_cons;[exact AB|constructor]. }
 assert(DAB:ba<>bb).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AA)as V.
   rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AB V). }
 assert(WA:Mem.valid_access ma Mfloat32 ba 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AB|].
   eapply Mem.valid_access_alloc_same;[exact AA|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WB:Mem.valid_access ma Mfloat32 bb 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AB|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WAW:Mem.valid_access ma Mfloat32 ba 0 Writable)
  by(eapply Mem.valid_access_freeable_any;exact WA).
 destruct(Mem.valid_access_store ma Mfloat32 ba 0(Vsingle a)WAW)as [m1 SA].
 assert(WBW:Mem.valid_access m1 Mfloat32 bb 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SA|];eapply Mem.valid_access_freeable_any;exact WB. }
 destruct(Mem.valid_access_store m1 Mfloat32 bb 0(Vsingle b)WBW)as [m0 SB].
 assert(BIND:bind_parameters addition_ge e ma(fn_params addition_function)
   [Vsingle a;Vsingle b]m0).
 { change(bind_parameters addition_ge e ma
    [(Source._a,tfloat);(Source._b,tfloat)][Vsingle a;Vsingle b]m0).
   eapply bind_parameters_cons with(m1:=m1);[exact EA| |].
   - eapply assign_loc_value;[reflexivity|reflexivity|].
     change(Mem.store Mfloat32 ma ba 0(Vsingle a)=Some m1);exact SA.
   - eapply bind_parameters_cons with(m1:=m0);[exact EB| |].
     + eapply assign_loc_value;[reflexivity|reflexivity|].
       change(Mem.store Mfloat32 m1 bb 0(Vsingle b)=Some m0);exact SB.
     + constructor. }
 assert(LA:Mem.load Mfloat32 m0 ba 0=Some(Vsingle a)).
 { erewrite Mem.load_store_other by(exact SB||(left;exact DAB)).
   erewrite Mem.load_store_same by exact SA;reflexivity. }
 assert(LB:Mem.load Mfloat32 m0 bb 0=Some(Vsingle b)).
 { erewrite Mem.load_store_same by exact SB;reflexivity. }
 assert(BODY:stmt_eval addition_ge e tfloat(fn_body addition_function)m0=
  Some(Nreturn(Vsingle(Float32.add a b)),m0)).
 { apply return_single;[reflexivity|].
   eapply pure_single_add;[reflexivity|reflexivity| |];eapply read_parameter;eauto. }
 assert(WA0:Mem.valid_access m0 Mfloat32 ba 0 Freeable).
 { eapply Mem.store_valid_access_1;[exact SB|];eapply Mem.store_valid_access_1;eauto. }
 assert(WB0:Mem.valid_access m0 Mfloat32 bb 0 Freeable).
 { eapply Mem.store_valid_access_1;[exact SB|];eapply Mem.store_valid_access_1;eauto. }
 destruct(Mem.range_perm_free m0 ba 0 4(proj1 WA0))as [mf1 F1].
 assert(WB1:Mem.valid_access mf1 Mfloat32 bb 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F1|exact WB0|left;congruence]. }
 destruct(Mem.range_perm_free mf1 bb 0 4(proj1 WB1))as [mf F2].
 assert(FREE:Mem.free_list m0(blocks_of_env addition_ge e)=Some mf).
 { unfold e;rewrite frame_blocks. cbn [Mem.free_list]. rewrite F1,F2;reflexivity. }
 split;[apply addition_start_source|]. split;[reflexivity|].
 exists(Vsingle(Float32.add a b),mf).
 cbn [state_eval addition_start].
 rewrite(do_alloc_variables_complete addition_ge _ _ _ _ _ ALLOC).
 rewrite(sem_bind_parameters_complete addition_ge quiet_world _ _ _ _ _ BIND).
 change((match stmt_eval addition_ge e tfloat(fn_body addition_function)m0 with
 |Some(out,mx)=>cont_eval addition_ge e tfloat Kstop out mx|None=>None end)=
 Some(Vsingle(Float32.add a b),mf)).
 rewrite BODY. change((match Mem.free_list m0(blocks_of_env addition_ge e)with
 |Some mx=>Some(Vsingle(Float32.add a b),mx)|None=>None end)=Some(Vsingle(Float32.add a b),mf)).
 rewrite FREE;reflexivity.
Qed.
