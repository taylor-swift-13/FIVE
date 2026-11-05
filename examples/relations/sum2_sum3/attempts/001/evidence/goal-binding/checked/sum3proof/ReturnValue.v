From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveSum3 Require Import Source.
From FiveSum3Proof Require Import SourceInvariant.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum3Proof.support Require Import NormalCorrespondence.
From FiveSum3Proof Require Import PureProgress Invariant Entry Core.
Import ListNotations.
Local Open Scope Z_scope.

Theorem typed_entry_result : forall m (a b c:float32),
 exists mf, state_eval sum3_ge (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m) = Some (Vsingle (Float32.add (Float32.add a b) c), mf).
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
 exists mf.
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

Lemma result_step : forall s t s' result,
 execution_invariant s -> state_eval sum3_ge s = Some result ->
 Csem.step sum3_ge s t s' -> state_eval sum3_ge s' = Some result.
Proof.
 intros s t s' result [SOURCE [NORMAL [old OLD]]] EVAL STEP.
 destruct STEP as [ES|SS].
 - destruct s as [f stmt k e m|f a k e m|fd args k m|v k m|]; try solve[inversion ES].
   exact (normal_estep_forward sum3_ge f a k e m t s' result SOURCE NORMAL EVAL ES).
 - rewrite <- (normal_sstep_denotation _ _ _ _ SOURCE NORMAL SS); exact EVAL.
Qed.

Theorem sum3_return_value : forall m (a b c:float32) t v mf,
 star Csem.step sum3_ge (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m) t (Returnstate v Kstop mf) ->
 v = Vsingle (Float32.add (Float32.add a b) c).
Proof.
 intros m a b c t v mf PATH.
 destruct (typed_entry_result m a b c) as [expected INIT].
 assert (INV: execution_invariant (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m)) by apply typed_entry_establishes_invariant.
 assert (END: state_eval sum3_ge (Returnstate v Kstop mf) =
              Some (Vsingle (Float32.add (Float32.add a b) c), expected)).
 { revert INIT INV; induction PATH; intros INIT INV; auto.
   apply IHPATH; [eapply result_step; eauto | eapply invariant_preserved; eauto]. }
 cbn [state_eval] in END; inversion END; reflexivity.
Qed.
Print Assumptions sum3_return_value.

