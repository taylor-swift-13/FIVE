From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory
 Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveSum3 Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum3Proof Require Import SourceInvariant.
From FiveSum3Proof.support Require Import NormalCorrespondence.
From FiveSum3Proof Require Import PureProgress.
From FiveSum3Proof Require Import Invariant.
Import ListNotations.
Local Open Scope Z_scope.

Definition frame_env (ba bb bc:block):env :=
 PTree.set Source._c (bc,tfloat)
 (PTree.set Source._b (bb,tfloat)
 (PTree.set Source._a (ba,tfloat) empty_env)).
Lemma frame_lookup : forall ba bb bc,
 PTree.get Source._a(frame_env ba bb bc)=Some(ba,tfloat) /\
 PTree.get Source._b(frame_env ba bb bc)=Some(bb,tfloat) /\
 PTree.get Source._c(frame_env ba bb bc)=Some(bc,tfloat).
Proof. intros;repeat split;reflexivity. Qed.

Lemma read_parameter : forall ge e m id bx f,
 PTree.get id e=Some(bx,tfloat) ->
 Mem.load Mfloat32 m bx 0=Some(Vsingle f) ->
 pure_rval ge e m (Evalof(Evar id tfloat)tfloat)=Some(Vsingle f).
Proof.
 intros ge e m id bx f LOOK LOAD.
 cbn [pure_rval pure_lval]. rewrite LOOK.
 repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world tfloat m bx Ptrofs.zero Full=
  Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
   - eapply deref_loc_value;[reflexivity|reflexivity|].
     unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
     rewrite zle_true.
     + exact LOAD.
     + change(4<=18446744073709551616)%Z;lia.
   - constructor. }
 rewrite D;reflexivity.
Qed.

Lemma frame_blocks : forall ba bb bc,
 blocks_of_env sum3_ge(frame_env ba bb bc)=[(bc,0,4);(ba,0,4);(bb,0,4)].
Proof. reflexivity. Qed.

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

Lemma free_frame_exists : forall m ba bb bc,
 ba<>bb -> ba<>bc -> bb<>bc ->
 Mem.valid_access m Mfloat32 ba 0 Freeable ->
 Mem.valid_access m Mfloat32 bb 0 Freeable ->
 Mem.valid_access m Mfloat32 bc 0 Freeable ->
 exists mf,Mem.free_list m(blocks_of_env sum3_ge(frame_env ba bb bc))=Some mf.
Proof.
 intros m ba bb bc AB AC BC WA WB WC.
 destruct(Mem.range_perm_free m bc 0 4(proj1 WC))as [m1 F1].
 assert(WA1:Mem.valid_access m1 Mfloat32 ba 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F1|exact WA|left;congruence]. }
 assert(WB1:Mem.valid_access m1 Mfloat32 bb 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F1|exact WB|left;congruence]. }
 destruct(Mem.range_perm_free m1 ba 0 4(proj1 WA1))as [m2 F2].
 assert(WB2:Mem.valid_access m2 Mfloat32 bb 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F2|exact WB1|left;congruence]. }
 destruct(Mem.range_perm_free m2 bb 0 4(proj1 WB2))as [mf F3].
 exists mf;rewrite frame_blocks.
 change((match Mem.free m bc 0 4 with
 |Some mx=>match Mem.free mx ba 0 4 with
 |Some my=>match Mem.free my bb 0 4 with Some mz=>Some mz|None=>None end
 |None=>None end|None=>None end)=Some mf).
 rewrite F1,F2,F3;reflexivity.
Qed.

Theorem typed_entry_establishes_invariant : forall m (a b c:float32),
 execution_invariant(sum3_start(Vsingle a)(Vsingle b)(Vsingle c)m).
Proof.
 intros m a b c.
 destruct(Mem.alloc m 0 4)as [mA ba]eqn:AA.
 destruct(Mem.alloc mA 0 4)as [mB bb]eqn:AB.
 destruct(Mem.alloc mB 0 4)as [ma bc]eqn:AC.
 set(e:=frame_env ba bb bc).
 destruct(frame_lookup ba bb bc)as [EA[EB EC]].
 assert(ALLOC:alloc_variables sum3_ge empty_env m
  (fn_params sum3_function++fn_vars sum3_function)e ma).
 { change(alloc_variables sum3_ge empty_env m
   [(Source._a,tfloat);(Source._b,tfloat);(Source._c,tfloat)]e ma).
   eapply alloc_variables_cons;[exact AA|].
   eapply alloc_variables_cons;[exact AB|].
   eapply alloc_variables_cons;[exact AC|constructor]. }
 assert(DAB:ba<>bb).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AA)as V.
   rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AB V). }
 assert(DAC:ba<>bc).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AA)as V.
   pose proof(Mem.valid_block_alloc _ _ _ _ _ AB ba V)as V'.
   rewrite EQ in V';exact(Mem.fresh_block_alloc _ _ _ _ _ AC V'). }
 assert(DBC:bb<>bc).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AB)as V.
   rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AC V). }
 assert(WA:Mem.valid_access ma Mfloat32 ba 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AC|].
   eapply Mem.valid_access_alloc_other;[exact AB|].
   eapply Mem.valid_access_alloc_same;[exact AA|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WB:Mem.valid_access ma Mfloat32 bb 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AC|].
   eapply Mem.valid_access_alloc_same;[exact AB|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WC:Mem.valid_access ma Mfloat32 bc 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AC|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WAW:Mem.valid_access ma Mfloat32 ba 0 Writable)
  by(eapply Mem.valid_access_freeable_any;exact WA).
 destruct(Mem.valid_access_store ma Mfloat32 ba 0(Vsingle a)WAW)as [m1 SA].
 assert(WBW:Mem.valid_access m1 Mfloat32 bb 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SA|];eapply Mem.valid_access_freeable_any;exact WB. }
 destruct(Mem.valid_access_store m1 Mfloat32 bb 0(Vsingle b)WBW)as [m2 SB].
 assert(WCW:Mem.valid_access m2 Mfloat32 bc 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SB|].
   eapply Mem.store_valid_access_1;[exact SA|];eapply Mem.valid_access_freeable_any;exact WC. }
 destruct(Mem.valid_access_store m2 Mfloat32 bc 0(Vsingle c)WCW)as [m0 SC].
 assert(BIND:bind_parameters sum3_ge e ma(fn_params sum3_function)
   [Vsingle a;Vsingle b;Vsingle c]m0).
 { change(bind_parameters sum3_ge e ma
    [(Source._a,tfloat);(Source._b,tfloat);(Source._c,tfloat)]
    [Vsingle a;Vsingle b;Vsingle c]m0).
   eapply bind_parameters_cons with(m1:=m1);[exact EA| |].
   - eapply assign_loc_value;[reflexivity|reflexivity|].
     change(Mem.store Mfloat32 ma ba 0(Vsingle a)=Some m1);exact SA.
   - eapply bind_parameters_cons with(m1:=m2);[exact EB| |].
     + eapply assign_loc_value;[reflexivity|reflexivity|].
       change(Mem.store Mfloat32 m1 bb 0(Vsingle b)=Some m2);exact SB.
     + eapply bind_parameters_cons with(m1:=m0);[exact EC| |].
       * eapply assign_loc_value;[reflexivity|reflexivity|].
         change(Mem.store Mfloat32 m2 bc 0(Vsingle c)=Some m0);exact SC.
       * constructor. }
 assert(LA:Mem.load Mfloat32 m0 ba 0=Some(Vsingle a)).
 { erewrite Mem.load_store_other by(exact SC||(left;exact DAC)).
   erewrite Mem.load_store_other by(exact SB||(left;exact DAB)).
   erewrite Mem.load_store_same by exact SA;reflexivity. }
 assert(LB:Mem.load Mfloat32 m0 bb 0=Some(Vsingle b)).
 { erewrite Mem.load_store_other by(exact SC||(left;exact DBC)).
   erewrite Mem.load_store_same by exact SB;reflexivity. }
 assert(LC:Mem.load Mfloat32 m0 bc 0=Some(Vsingle c)).
 { erewrite Mem.load_store_same by exact SC;reflexivity. }
 assert(BODY:stmt_eval sum3_ge e tfloat(fn_body sum3_function)m0=
  Some(Nreturn(Vsingle(Float32.add(Float32.add a b)c)),m0)).
 { apply return_single;[reflexivity|].
   eapply pure_single_add;[reflexivity|reflexivity| |].
   - eapply pure_single_add;[reflexivity|reflexivity| |];eapply read_parameter;eauto.
   - eapply read_parameter;eauto. }
 assert(KEEP:forall chunk bx ofs p,Mem.valid_access ma chunk bx ofs p ->
  Mem.valid_access m0 chunk bx ofs p).
 { intros chunk bx ofs p ACCESS.
   eapply Mem.store_valid_access_1;[exact SC|].
   eapply Mem.store_valid_access_1;[exact SB|].
   eapply Mem.store_valid_access_1;[exact SA|exact ACCESS]. }
 destruct(free_frame_exists m0 ba bb bc DAB DAC DBC
  (KEEP _ _ _ _ WA)(KEEP _ _ _ _ WB)(KEEP _ _ _ _ WC))as [mf FREE].
 split;[apply sum3_start_source|]. split;[reflexivity|].
 exists(Vsingle(Float32.add(Float32.add a b)c),mf).
 cbn [state_eval sum3_start].
 rewrite(do_alloc_variables_complete sum3_ge _ _ _ _ _ ALLOC).
 rewrite(sem_bind_parameters_complete sum3_ge quiet_world _ _ _ _ _ BIND).
 change((match stmt_eval sum3_ge e tfloat(fn_body sum3_function)m0 with
 |Some(out,mx)=>cont_eval sum3_ge e tfloat Kstop out mx|None=>None end)=
 Some(Vsingle(Float32.add(Float32.add a b)c),mf)).
 rewrite BODY.
 change((match Mem.free_list m0(blocks_of_env sum3_ge(frame_env ba bb bc)) with
 |Some mx=>Some(Vsingle(Float32.add(Float32.add a b)c),mx)|None=>None end)=
 Some(Vsingle(Float32.add(Float32.add a b)c),mf)).
 rewrite FREE;reflexivity.
Qed.
