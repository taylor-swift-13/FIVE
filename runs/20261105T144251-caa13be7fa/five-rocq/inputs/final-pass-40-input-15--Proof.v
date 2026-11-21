From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveSum3 Require Import Source.
From FiveSum3Proof Require Import SourceInvariant.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum3Proof.support Require Import NormalCorrespondence.
From FiveSum3Proof Require Import PureProgress Invariant Entry Functional.
From FiveSum3Proof Require Import RecheckSpec FullSpec Termination.
Import ListNotations.
Local Open Scope Z_scope.


Lemma free_list_preserves_old : forall P m l mf,
 (forall b lo hi, In (b,lo,hi) l -> forall ofs, ~ P b ofs) ->
 Mem.free_list m l = Some mf -> Mem.unchanged_on P m mf.
Proof.
 intros P m l; revert m; induction l as [|[[b lo] hi] tl IH]; intros m mf F E.
 - simpl in E; inversion E; apply Mem.unchanged_on_refl.
 - simpl in E; destruct(Mem.free m b lo hi) as [mx|] eqn:FR; try discriminate.
   eapply Mem.unchanged_on_trans.
   + eapply Mem.free_unchanged_on; [exact FR|]. intros; eapply F; left; reflexivity.
   + eapply IH; [|exact E]. intros; eapply F; right;exact H.
Qed.

Theorem typed_entry_result : forall m (a b c:float32),
 exists mf, state_eval sum3_ge (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m) = Some (Vsingle (Float32.add (Float32.add a b) c), mf) /\ Mem.unchanged_on (fun b _ => Mem.valid_block m b) m mf.
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
 assert(FRESH: forall b, In b [ba;bb;bc] -> ~ Mem.valid_block m b).
 { intros bx IN V; simpl in IN; destruct IN as [EQ|[EQ|[EQ|[]]]]; subst bx.
   - exact(Mem.fresh_block_alloc _ _ _ _ _ AA V).
   - apply(Mem.fresh_block_alloc _ _ _ _ _ AB); eapply Mem.valid_block_alloc; eauto.
   - apply(Mem.fresh_block_alloc _ _ _ _ _ AC); eapply Mem.valid_block_alloc; [exact AB|]. eapply Mem.valid_block_alloc; eauto. }
 assert(UNCH:Mem.unchanged_on (fun b _ => Mem.valid_block m b) m mf).
 { eapply Mem.unchanged_on_trans; [eapply Mem.alloc_unchanged_on;exact AA|].
   eapply Mem.unchanged_on_trans; [eapply Mem.alloc_unchanged_on;exact AB|].
   eapply Mem.unchanged_on_trans; [eapply Mem.alloc_unchanged_on;exact AC|].
   eapply Mem.unchanged_on_trans; [eapply Mem.store_unchanged_on;[exact SA|intros; eapply FRESH; simpl;auto]|].
   eapply Mem.unchanged_on_trans; [eapply Mem.store_unchanged_on;[exact SB|intros; eapply FRESH; simpl;auto]|].
   eapply Mem.unchanged_on_trans; [eapply Mem.store_unchanged_on;[exact SC|intros; eapply FRESH; simpl;auto]|].
   eapply free_list_preserves_old; [|exact FREE].
   intros bx lo hi IN ofs.
   unfold blocks_of_env, frame_env in IN; vm_compute in IN.
   repeat destruct IN as [IN|IN]; try contradiction; inversion IN; subst; eapply FRESH; simpl; auto. }
 exists mf; split; [|exact UNCH].
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
 destruct (typed_entry_result m a b c) as [expected [INIT UNCH]].
 assert (INV: execution_invariant (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m)) by apply typed_entry_establishes_invariant.
 assert (END: state_eval sum3_ge (Returnstate v Kstop mf) =
              Some (Vsingle (Float32.add (Float32.add a b) c), expected)).
 { revert INIT INV; induction PATH; intros INIT INV; auto.
   apply IHPATH; [eapply result_step; eauto | eapply invariant_preserved; eauto]. }
 cbn [state_eval] in END; inversion END; reflexivity.
Qed.
Print Assumptions sum3_return_value.

Theorem sum3_cbmc_result_bits : RecheckSpec.ResultBitsGoal.
Proof.
 unfold RecheckSpec.ResultBitsGoal.
 intros m t v mf PATH.
 pose proof (sum3_return_value _ _ _ _ _ _ _ PATH) as EQ.
 exists sum3_concrete_model; split; [exact EQ|apply sum3_concrete_bits].
Qed.
Print Assumptions sum3_cbmc_result_bits.

Theorem sum3_preserves_caller_frame : forall m (a b c:float32) t v mf,
 star Csem.step sum3_ge (sum3_start (Vsingle a) (Vsingle b) (Vsingle c) m) t (Returnstate v Kstop mf) ->
 Mem.unchanged_on (fun b _ => Mem.valid_block m b) m mf.
Proof.
 intros m a b c t v mf PATH.
 destruct(typed_entry_result m a b c) as [expected [INIT UNCH]].
 assert(INV:execution_invariant(sum3_start(Vsingle a)(Vsingle b)(Vsingle c)m)) by apply typed_entry_establishes_invariant.
 assert(END:state_eval sum3_ge(Returnstate v Kstop mf)=Some(Vsingle(Float32.add(Float32.add a b)c),expected)).
 { revert INIT INV; induction PATH; intros INIT INV; auto.
   apply IHPATH; [eapply result_step;eauto|eapply invariant_preserved;eauto]. }
 cbn[state_eval] in END; inversion END; subst; exact UNCH.
Qed.
Print Assumptions sum3_preserves_caller_frame.

Lemma invariant_return_exists : forall s,
 Acc (FiveShared.verification.Obligations.successor sum3_ge) s -> execution_invariant s ->
 exists t v mf, star Csem.step sum3_ge s t (Returnstate v Kstop mf).
Proof.
 intros s ACCESS; induction ACCESS as [s ACCESS IH]; intros INV.
 destruct(invariant_progress _ INV) as [[v[mf EQ]]|[t[next STEP]]].
 - subst s; exists E0,v,mf; constructor.
 - destruct(IH next (ex_intro _ t STEP) (invariant_preserved _ _ _ INV STEP)) as [tr[v[mf PATH]]].
   exists(t**tr),v,mf; eapply star_step; [exact STEP|exact PATH|reflexivity].
Qed.
Theorem arbitrary_call_returns : forall m (a b c:float32),
 exists t v mf,star Csem.step sum3_ge (sum3_start(Vsingle a)(Vsingle b)(Vsingle c)m)t(Returnstate v Kstop mf).
Proof.
 intros; apply invariant_return_exists.
 - apply source_accessible; split;reflexivity.
 - apply typed_entry_establishes_invariant.
Qed.
Theorem harness_prefix_exists : forall m (a b c:float32),
 exists br bb mf v, HarnessPrefix m a b c br bb mf v.
Proof.
 intros; destruct(Mem.alloc m 0 4) as [mr br] eqn:AR.
 destruct(Mem.alloc mr 0 4) as [mh bb] eqn:AB.
 destruct(arbitrary_call_returns mh a b c)as[t1[v1[m1 P1]]].
 destruct(arbitrary_call_returns m1
 (Float32.of_bits(Int.repr 1266679808)) (Float32.of_bits(Int.repr 1065353216))
 (Float32.of_bits(Int.repr 3414163456)))as[t2[v2[m2 P2]]].
 exists br,bb,m2,v2; econstructor;eauto.
Qed.

Lemma bits_assertion_steps : forall bb m,
 Mem.load Mint32 m bb 0 = Some(Vint Int.zero) ->
 star Csem.step sum3_ge
  (ExprState sum3_function bits_assertion Kstop(bits_env bb)m) E0
  (ExprState sum3_function(Eval(Vint Int.one)tint)Kstop(bits_env bb)m).
Proof.
 intros bb m LOAD; unfold bits_assertion.
 eapply star_step with
 (s2:=ExprState sum3_function
 (Ebinop Oeq (Evalof(Eloc bb Ptrofs.zero Full tuint)tuint)(Eval(Vint Int.zero)tuint)tint)
 Kstop(bits_env bb)m)(t1:=E0)(t2:=E0).
 - left; eapply step_lred with(C:=fun a=>Ebinop Oeq(Evalof a tuint)(Eval(Vint Int.zero)tuint)tint).
   + apply red_var_local; unfold bits_env;apply PTree.gss.
   + apply ctx_binop_left;apply ctx_rvalof;apply ctx_top.
 - eapply star_step with
 (s2:=ExprState sum3_function(Ebinop Oeq(Eval(Vint Int.zero)tuint)(Eval(Vint Int.zero)tuint)tint)
 Kstop(bits_env bb)m)(t1:=E0)(t2:=E0).
   + left; eapply step_rred with(C:=fun a=>Ebinop Oeq a(Eval(Vint Int.zero)tuint)tint).
     * apply red_rvalof; eapply deref_loc_value;[reflexivity|reflexivity|].
       unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact LOAD|change(4<=18446744073709551616);lia].
     * apply ctx_binop_left;apply ctx_top.
   + eapply star_step with(t1:=E0)(t2:=E0).
     * left; eapply step_rred with(C:=fun a=>a);[apply red_binop;reflexivity|apply ctx_top].
     * constructor.
     * reflexivity.
   + reflexivity.
 - reflexivity.
Qed.

Lemma access_safety : forall m br bb,
 br<>bb -> Mem.valid_access m Mfloat32 br 0 Freeable ->
 Mem.valid_access m Mint32 bb 0 Freeable -> MemcpySafety m br bb.
Proof.
 intros m br bb DIFF [RP RA][BP BA].
 assert(R:Mem.range_perm m br 0 4 Cur Readable).
 { eapply Mem.range_perm_implies;[exact RP|constructor]. }
 assert(B:Mem.range_perm m bb 0 4 Cur Writable).
 { eapply Mem.range_perm_implies;[exact BP|constructor]. }
 constructor;auto.
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply R;lia|constructor].
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply B;change(0<=4-1<4);lia|constructor].
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply B;lia|constructor].
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply R;change(0<=4-1<4);lia|constructor].
Qed.

Theorem full_harness_observation : FullHarnessGoal.
Proof.
 unfold FullHarnessGoal;intros m a b c br bb mf v PREFIX.
 inversion PREFIX as[mr br' mh bb' t1 v1 m1 t2 v2 m2 AR AB P1 P2];subst.
 pose proof(sum3_preserves_caller_frame _ _ _ _ _ _ _ P1)as U1.
 pose proof(sum3_preserves_caller_frame _ _ _ _ _ _ _ P2)as U2.
 assert(BR:Mem.valid_block mh br).
 { eapply Mem.valid_block_alloc;[exact AB|eapply Mem.valid_new_block;exact AR]. }
 assert(BB:Mem.valid_block mh bb)by(eapply Mem.valid_new_block;exact AB).
 assert(DIFF:br<>bb).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AR)as V;rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AB V). }
 assert(R0:Mem.valid_access mh Mfloat32 br 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AB|].
   eapply Mem.valid_access_alloc_same;[exact AR|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(B0:Mem.valid_access mh Mint32 bb 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AB|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(PRES:forall chunk bx, Mem.valid_block mh bx ->
 Mem.valid_access mh chunk bx 0 Freeable -> Mem.valid_access mf chunk bx 0 Freeable).
 { intros chunk bx VALID [PERM ALIGN];split;auto.
   intros ofs RANGE;eapply Mem.perm_unchanged_on;[exact U2| |].
   - eapply Mem.valid_block_unchanged_on;[exact U1|exact VALID].
   - eapply Mem.perm_unchanged_on;[exact U1|exact VALID|apply PERM;exact RANGE]. }
 assert(RF:Mem.valid_access mf Mfloat32 br 0 Freeable)by(apply PRES;auto).
 assert(BF:Mem.valid_access mf Mint32 bb 0 Freeable)by(apply PRES;auto).
 pose proof(sum3_return_value _ _ _ _ _ _ _ P2)as RETURN;subst v.
 destruct(Mem.valid_access_store mf Mfloat32 br 0 (Vsingle sum3_concrete_model)
 (Mem.valid_access_freeable_any _ _ _ _ _ RF))as[stored STORE].
 assert(SAFE:MemcpySafety stored br bb).
 { apply access_safety;auto; eapply Mem.store_valid_access_1;eauto. }
 assert(READ:Mem.loadbytes stored br 0 4=Some(encode_val Mfloat32(Vsingle sum3_concrete_model))).
 { change(Mem.loadbytes stored br 0(size_chunk Mfloat32)=Some(encode_val Mfloat32(Vsingle sum3_concrete_model)));eapply Mem.loadbytes_store_same;exact STORE. }
 assert(WRITE:Mem.range_perm stored bb 0 (0+Z.of_nat(length(encode_val Mfloat32(Vsingle sum3_concrete_model)))) Cur Writable).
 { rewrite encode_val_length;change(Mem.range_perm stored bb 0 4 Cur Writable);exact(main_precondition_instance_3 _ _ _ SAFE). }
 destruct(Mem.range_perm_storebytes _ _ _ _ WRITE)as[copied COPY].
 assert(BYTES:Mem.loadbytes copied bb 0 4=Some(encode_val Mfloat32(Vsingle sum3_concrete_model))).
 { pose proof(Mem.loadbytes_storebytes_same _ _ _ _ _ COPY)as E;rewrite encode_val_length in E;exact E. }
 assert(LOAD:Mem.load Mint32 copied bb 0=Some(Vint Int.zero)).
 { pose proof(Mem.loadbytes_load Mint32 copied bb 0 _ BYTES (ex_intro _ 0 eq_refl))as E.
   change(Mem.load Mint32 copied bb 0=Some(Vint(Int.repr(Int.unsigned(Float32.to_bits sum3_concrete_model)))))in E.
   rewrite sum3_concrete_bits in E;exact E. }
 unfold ByteObservation;exists stored,copied,(encode_val Mfloat32(Vsingle sum3_concrete_model)).
 split;[exact STORE|]. split;[exact SAFE|]. split;[exact READ|]. split;[reflexivity|]. split.
 - econstructor;try rewrite Ptrofs.unsigned_zero;try exact READ;try exact COPY;try (left;reflexivity);try lia;try(exists 4;reflexivity);try(intros;exists 0;reflexivity);left;exact DIFF.
 - split;[exact BYTES|]. split;[exact LOAD|apply bits_assertion_steps;exact LOAD].
Qed.
Print Assumptions harness_prefix_exists.
Print Assumptions full_harness_observation.

Theorem property_memcpy_pointer_1 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ br <> bb.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_1 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_1.
Print Assumptions property_memcpy_pointer_1.

Theorem property_memcpy_pointer_arithmetic_1 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.valid_pointer stored br 0 = true.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_arithmetic_1 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_arithmetic_1.
Print Assumptions property_memcpy_pointer_arithmetic_1.

Theorem property_memcpy_pointer_arithmetic_2 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.weak_valid_pointer stored bb 4 = true.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_arithmetic_2 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_arithmetic_2.
Print Assumptions property_memcpy_pointer_arithmetic_2.

Theorem property_memcpy_pointer_2 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ bb <> br.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_2 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_2.
Print Assumptions property_memcpy_pointer_2.

Theorem property_memcpy_pointer_arithmetic_3 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.valid_pointer stored bb 0 = true.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_arithmetic_3 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_arithmetic_3.
Print Assumptions property_memcpy_pointer_arithmetic_3.

Theorem property_memcpy_pointer_arithmetic_4 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.weak_valid_pointer stored br 4 = true.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(memcpy_pointer_arithmetic_4 _ _ _ SAFE)].
Qed.
Check property_memcpy_pointer_arithmetic_4.
Print Assumptions property_memcpy_pointer_arithmetic_4.

Theorem property_main_precondition_instance_1 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (br <> bb \/ 0+4 <= 0 \/ 0+4 <= 0).
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(main_precondition_instance_1 _ _ _ SAFE)].
Qed.
Check property_main_precondition_instance_1.
Print Assumptions property_main_precondition_instance_1.

Theorem property_main_precondition_instance_2 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.range_perm stored br 0 4 Cur Readable.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(main_precondition_instance_2 _ _ _ SAFE)].
Qed.
Check property_main_precondition_instance_2.
Print Assumptions property_main_precondition_instance_2.

Theorem property_main_precondition_instance_3 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ Mem.range_perm stored bb 0 4 Cur Writable.
Proof.
 intros m a b c br bb mf v PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 exists stored;split;[exact STORE|exact(main_precondition_instance_3 _ _ _ SAFE)].
Qed.
Check property_main_precondition_instance_3.
Print Assumptions property_main_precondition_instance_3.

Theorem property_main_assertion_1 : FullHarnessGoal.
Proof. exact full_harness_observation. Qed.
Check property_main_assertion_1.
Print Assumptions property_main_assertion_1.

(** Exact logical guards from the original CBMC builtin goto instructions
 32--40. The two cross-object order tests are universally quantified,
 uninterpreted propositions: their values are never needed. Separation is
 established from actual fresh allocations and preserved across both calls. *)

Theorem cbmc_memcpy_pointer_1 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (((True /\ ~(bb <> br)) -> False)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_1.
Print Assumptions cbmc_memcpy_pointer_1.

Theorem cbmc_memcpy_pointer_arithmetic_1 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (((True /\ ~(bb <> br)) -> Mem.valid_pointer stored br 0 = true)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_arithmetic_1.
Print Assumptions cbmc_memcpy_pointer_arithmetic_1.

Theorem cbmc_memcpy_pointer_arithmetic_2 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (((True /\ ~(bb <> br)) -> Mem.weak_valid_pointer stored bb 4 = true)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_arithmetic_2.
Print Assumptions cbmc_memcpy_pointer_arithmetic_2.

Theorem cbmc_memcpy_pointer_2 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ ((~(bb <> br \/ order1) -> False)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_2.
Print Assumptions cbmc_memcpy_pointer_2.

Theorem cbmc_memcpy_pointer_arithmetic_3 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ ((~(bb <> br \/ order1) -> Mem.valid_pointer stored bb 0 = true)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_arithmetic_3.
Print Assumptions cbmc_memcpy_pointer_arithmetic_3.

Theorem cbmc_memcpy_pointer_arithmetic_4 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ ((~(bb <> br \/ order1) -> Mem.weak_valid_pointer stored br 4 = true)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_memcpy_pointer_arithmetic_4.
Print Assumptions cbmc_memcpy_pointer_arithmetic_4.

Theorem cbmc_main_precondition_instance_1 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (((bb <> br \/ order1) \/ order2)).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_main_precondition_instance_1.
Print Assumptions cbmc_main_precondition_instance_1.

Theorem cbmc_main_precondition_instance_2 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (Mem.range_perm stored br 0 4 Cur Readable).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_main_precondition_instance_2.
Print Assumptions cbmc_main_precondition_instance_2.

Theorem cbmc_main_precondition_instance_3 : forall m (a b c:float32) br bb mf v (order1 order2:Prop),
 HarnessPrefix m a b c br bb mf v ->
 exists stored, Mem.store Mfloat32 mf br 0 v = Some stored /\ (Mem.range_perm stored bb 0 4 Cur Writable).
Proof.
 intros m a b c br bb mf v order1 order2 PREFIX.
 destruct(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as[stored[copied[bytes[STORE[SAFE REST]]]]].
 destruct SAFE as [D A B E C F G R W].
 exists stored;split;[exact STORE|];tauto.
Qed.
Check cbmc_main_precondition_instance_3.
Print Assumptions cbmc_main_precondition_instance_3.

Lemma memcpy_all_outcomes_zero : forall stored copied br bb t ret,
 Mem.loadbytes stored br 0 4=Some(encode_val Mfloat32(Vsingle sum3_concrete_model)) ->
 extcall_memcpy_sem 4 1 sum3_ge [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero] stored t ret copied ->
 Mem.load Mint32 copied bb 0=Some(Vint Int.zero).
Proof.
 intros stored copied br bb t ret READ CALL.
 inversion CALL;subst;rewrite Ptrofs.unsigned_zero in *.
 match goal with H:Mem.loadbytes stored br 0 4=Some ?bytes |- _ =>
  rewrite READ in H;inversion H;subst bytes end.
 assert(BYTES:Mem.loadbytes copied bb 0 4=Some(encode_val Mfloat32(Vsingle sum3_concrete_model))).
 { replace 4 with (Z.of_nat(length(encode_val Mfloat32(Vsingle sum3_concrete_model)))) by (rewrite encode_val_length;reflexivity).
   eapply Mem.loadbytes_storebytes_same; eauto. }
 pose proof(Mem.loadbytes_load Mint32 copied bb 0 _ BYTES(ex_intro _ 0 eq_refl))as E.
 change(Mem.load Mint32 copied bb 0=Some(Vint(Int.repr(Int.unsigned(Float32.to_bits sum3_concrete_model)))))in E.
 rewrite sum3_concrete_bits in E;exact E.
Qed.
Theorem cbmc_main_assertion_1 : forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v ->
 ByteObservation br bb mf v /\
 exists stored, Mem.store Mfloat32 mf br 0 v=Some stored /\
 forall copied t ret,
 extcall_memcpy_sem 4 1 sum3_ge [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero] stored t ret copied ->
 Mem.load Mint32 copied bb 0=Some(Vint Int.zero) /\
 star Csem.step sum3_ge
 (ExprState sum3_function bits_assertion Kstop(bits_env bb)copied) E0
 (ExprState sum3_function(Eval(Vint Int.one)tint)Kstop(bits_env bb)copied).
Proof.
 intros m a b c br bb mf v PREFIX.
 pose proof(full_harness_observation _ _ _ _ _ _ _ _ PREFIX)as OBS.
 split;[exact OBS|].
 destruct OBS as[stored[copied[bytes[STORE[SAFE[READ[ENC REST]]]]]]].
 exists stored;split;[exact STORE|]. intros copied' t ret CALL.
 inversion PREFIX as[mr br' mh bb' t1 v1 m1 t2 v2 m2 AR AB P1 P2];subst.
 pose proof(sum3_return_value _ _ _ _ _ _ _ P2)as RETURN;subst v.
 pose proof(memcpy_all_outcomes_zero _ _ _ _ _ _ READ CALL)as LOAD.
 split;[exact LOAD|apply bits_assertion_steps;exact LOAD].
Qed.
Check cbmc_main_assertion_1.
Print Assumptions cbmc_main_assertion_1.
