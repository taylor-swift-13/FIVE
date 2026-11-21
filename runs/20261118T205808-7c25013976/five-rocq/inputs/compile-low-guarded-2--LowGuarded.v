From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
Require PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import PlainCore PlainBody PlainEntry LowDecoder LowEntry LowDispatcher MachineData Total PureEval CallOne LowSin.
From PprzTrigInitSupport Require Import Control.
From PprzTrigRelationSupport Require Import InitialMemory LowClosed InitComplete.
From PprzTrigRelation Require Import Spec.
From PprzTrigCBMC Require Import TypedGuards MathCoverage SineMath DecoderMath SineGuards GuardedCover GuardedControl GuardedCallOne GuardedDispatcher GuardedSineFront.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Lemma sine_callee_return_guarded : forall ge Q local before returned r flag,
 signed32(-Int.signed r)->Mem.range_perm before local 0 4 Cur Freeable ->
 Mem.unchanged_on(old_blocks before)before returned ->
 (forall final,low_finish ge local before final ->guarded_covers ge Q(Returnstate(Vint(negate_int flag r))Kstop final)) ->
 guarded_covers ge Q(Returnstate(Vint r)
  (Kcall sin_low(angle_env local)(fun x=>negate_expr flag x)tshort(Kreturn Kstop))returned).
Proof.
 intros ge Q local before returned r flag BOUND PERM FRAME END.
 assert(LOCAL:Mem.valid_block before local)by(eapply Mem.perm_valid_block;apply(PERM 0);lia).
 assert(PERM':Mem.range_perm returned local 0 4 Cur Freeable).
 { intros ofs R;eapply Mem.perm_unchanged_on;[exact FRAME|exact LOCAL|apply PERM;exact R]. }
 destruct(Mem.range_perm_free _ _ _ _ PERM')as[final FREE].
 apply return_to_caller_guarded.
 eapply math_observation_prefix_guarded with(v:=Vint(negate_int flag r)).
 - destruct flag;reflexivity.
 - destruct flag;reflexivity.
 - destruct flag;[eapply math_unop;[exact I|reflexivity|exact BOUND]|exact I].
 - eapply return_value_guarded with(result:=Vint(negate_int flag r))(mf:=final).
   + destruct flag;reflexivity.
   + rewrite angle_env_blocks;cbn[Mem.free_list];rewrite FREE;reflexivity.
   + apply END. exists returned;split;[exact FRAME|].
     rewrite angle_env_blocks;cbn[Mem.free_list];rewrite FREE;reflexivity.
Qed.
Theorem low_return_guarded : forall (ge:Csem.genv)Q local m bb a decoderblock dispatcherblock,
 -6433<=Int.signed a<=6433 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 Mem.range_perm m local 0 4 Cur Freeable ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_12=Some decoderblock ->
 Genv.find_funct ge(Vptr decoderblock Ptrofs.zero)=Some(Internal decoder) ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_f=Some dispatcherblock ->
 Genv.find_funct ge(Vptr dispatcherblock Ptrofs.zero)=Some(Internal dispatcher) ->
 (forall final,low_finish ge local m final ->guarded_covers ge Q(Returnstate(Vint(low_result a))Kstop final)) ->
 guarded_covers ge Q(State sin_low low_return_stmt Kstop(angle_env local)m).
Proof.
 intros ge Q local m bb a decoderblock dispatcherblock B LOAD PERM SYM BYTES DS DF FS FF END.
 change(guarded_covers ge Q(State sin_low(Sifthenelse PlainBody.return_guard
  (Sreturn(Some(Ecall(Evalof(Evar PprzTrigLow.Source._pprz_trig_int_f(Tfunction[tint]tshort cc_default))(Tfunction[tint]tshort cc_default))
    (Econs PlainBody.read_angle Enil)tshort)))
  (Sreturn(Some(negate_expr true(Ecall(Evalof(Evar PprzTrigLow.Source._pprz_trig_int_f(Tfunction[tint]tshort cc_default))(Tfunction[tint]tshort cc_default))
    (Econs(negate_expr true PlainBody.read_angle)Enil)tshort)))))Kstop(angle_env local)m)).
 eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Cge a Int.zero))(choice:=Int.cmp Cge a Int.zero).
 - reflexivity.
 - apply return_guard_value;exact LOAD.
 - apply math_other_binop;[intros v w;destruct v,w;exact I|exact I|exact I].
 - apply bool_of_bool.
 - destruct(Int.cmp Cge a Int.zero)eqn:POS;simpl.
   + assert(NB:0<=Int.signed a<6434)by(apply cmp_nonneg in POS;lia).
     apply return_start_guarded.
     eapply read_call_guarded with(fnid:=PprzTrigLow.Source._pprz_trig_int_f)(argid:=PprzTrigLow.Source._angle)(targetty:=tint)(returnty:=tshort)
      (target:=dispatcher)(funblock:=dispatcherblock)(argblock:=local)(a:=a)(castarg:=Vint a)(neg:=false).
     * unfold angle_env;rewrite PTree.gso by(vm_compute;discriminate);apply PTree.gempty.
     * unfold angle_env;apply PTree.gss.
     * exact FS.
     * apply angle_deref;exact LOAD.
     * exact FF.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * unfold signed32;lia.
     * apply dispatcher_entry_guarded with(bb:=bb)(a:=a)(funblock:=decoderblock);auto.
       intros returned FRAME;apply sine_callee_return_guarded with(before:=m);auto.
       unfold signed32;pose proof(decoded_result_bound a NB);lia.
       intros final FIN;unfold low_result in END;rewrite POS in END;exact(END final FIN).
   + assert(NEG:Int.signed a<0).
     { destruct(Z_le_gt_dec 0(Int.signed a));[|lia].
       assert(C:Int.cmp Cge a Int.zero=true)by(apply cmp_nonneg;lia);congruence. }
     assert(NB:0<=Int.signed(Int.neg a)<6434)by(rewrite neg_signed_small by exact B;lia).
     apply return_start_guarded.
     eapply read_call_guarded with(fnid:=PprzTrigLow.Source._pprz_trig_int_f)(argid:=PprzTrigLow.Source._angle)(targetty:=tint)(returnty:=tshort)
      (target:=dispatcher)(funblock:=dispatcherblock)(argblock:=local)(a:=a)(castarg:=Vint(Int.neg a))(neg:=true).
     * unfold angle_env;rewrite PTree.gso by(vm_compute;discriminate);apply PTree.gempty.
     * unfold angle_env;apply PTree.gss.
     * exact FS.
     * apply angle_deref;exact LOAD.
     * exact FF.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * unfold signed32;lia.
     * apply dispatcher_entry_guarded with(bb:=bb)(a:=Int.neg a)(funblock:=decoderblock);auto.
       intros returned FRAME;apply sine_callee_return_guarded with(before:=m);auto.
       unfold signed32;pose proof(decoded_result_bound(Int.neg a) NB);lia.
       intros final FIN;unfold low_result in END;rewrite POS in END;exact(END final FIN).
Qed.

Theorem low_entry_math_total : forall (ge:Csem.genv)m bb a decoderblock dispatcherblock,
 -12867<=Int.signed a<=12867 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_12=Some decoderblock ->
 Genv.find_funct ge(Vptr decoderblock Ptrofs.zero)=Some(Internal decoder) ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_f=Some dispatcherblock ->
 Genv.find_funct ge(Vptr dispatcherblock Ptrofs.zero)=Some(Internal dispatcher) ->
 guarded_total ge(fun _ _=>True)(Callstate(Internal sin_low)[Vint a]Kstop m).
Proof.
 intros ge m bb a decoderblock dispatcherblock RANGE SYM BYTES DS DF FS FF.
 assert(BVALID:Mem.valid_block m bb).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;
   [eapply Mem.load_valid_access;apply(BYTES 0);lia|constructor]. }
 destruct(Mem.alloc m 0 4)as[m1 local]eqn:ALLOC.
 assert(FRESH:~Mem.valid_block m local)by(eapply Mem.fresh_block_alloc;eauto).
 assert(NE:bb<>local)by congruence.
 assert(VAF:Mem.valid_access m1 Mint32 local 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(VAW:Mem.valid_access m1 Mint32 local 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a) VAW)as[m2 STORE].
 assert(PRE:Mem.unchanged_on(old_blocks m)m m2).
 { eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact ALLOC|].
   eapply Mem.store_unchanged_on;[exact STORE|intros;exact FRESH]. }
 assert(LOAD:Mem.load Mint32 m2 local 0=Some(Vint a))by(exact(Mem.load_store_same _ _ _ _ _ _ STORE)).
 assert(PERM:Mem.range_perm m2 local 0 4 Cur Freeable).
 { intros ofs R;eapply Mem.perm_store_1;[exact STORE|eapply Mem.perm_alloc_2;[exact ALLOC|exact R]]. }
 assert(BYTES2:buffer_loads m2 bb).
 { intros i I;rewrite(Mem.load_unchanged_on_1 _ _ _ _ _ _ PRE BVALID ltac:(intros;exact BVALID));apply BYTES;exact I. }
 apply covers_guarded_total;eapply internal_guarded with(e:=angle_env local)(m1:=m1)(m2:=m2).
 - change(list_norepet[PprzTrigLow.Source._angle]);repeat constructor;cbn;auto.
 - change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigLow.Source._angle,tint)]=(angle_env local,m1)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 4 with|(mm,bb)=>(angle_env bb,mm)end=(angle_env local,m1)).
   rewrite ALLOC;reflexivity.
 - apply bind_angle;exact STORE.
 - rewrite low_body_shape;apply normalized_front_math_covers with(a:=a);auto.
   + eapply Mem.store_valid_access_1;[exact STORE|exact VAW].
   + intros middle FM.
     destruct(fold_memory_local _ _ _ _ LOAD PERM FM)as[MLOAD MPERM].
     apply low_return_guarded with(bb:=bb)(a:=folded a)(decoderblock:=decoderblock)(dispatcherblock:=dispatcherblock);auto.
     * apply folded_bounds;exact RANGE.
     * intros i I;rewrite(fold_memory_other _ _ _ _ _ _ _ NE FM);apply BYTES2;exact I.
     * intros final FIN;apply guarded_here;[exact I|apply guarded_final;exact I].
Qed.
Print Assumptions low_entry_math_total.

Theorem original_low_all_prefixes_math : forall initial initialized a,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->Spec.normalized_angle a->
 guarded_total PprzTrigLow.Execution.ge(fun _ _=>True)(PprzTrigLow.Execution.entry[Vint a]initialized).
Proof.
 intros initial initialized a INIT RAN RANGE.
 destruct buffer_symbol_info_exists as[bb[SYMBOL INFO]].
 assert(BS:Spec.buffer_symbol bb)by exact SYMBOL.
 pose proof(initialized_packed initial initialized bb INIT BS RAN)as PACKED.
 destruct decoder_link as[db[DS DF]];destruct dispatcher_link as[fb[FS FF]].
 eapply low_entry_math_total with(bb:=bb)(decoderblock:=db)(dispatcherblock:=fb);try exact RANGE;try exact DS;try exact DF;try exact FS;try exact FF.
 - exact(low_buffer_symbol bb BS).
 - exact(buffer_loads_from_packed initialized bb PACKED).
Qed.
Theorem original_low_every_binary_guard : forall initial initialized a tr f expression k e current op v w,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr(ExprState f expression k e current)->
 BinaryOperationOccurrence expression op v w->binary_math_guard op v w.
Proof. intros;eapply guarded_prefix_binary_guard;eauto using original_low_all_prefixes_math. Qed.
Theorem original_low_every_unary_guard : forall initial initialized a tr f expression k e current op v,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)initialized->Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr(ExprState f expression k e current)->
 UnaryOperationOccurrence expression op v->unary_math_guard op v.
Proof. intros;eapply guarded_prefix_unary_guard;eauto using original_low_all_prefixes_math. Qed.
Print Assumptions original_low_all_prefixes_math.
Print Assumptions original_low_every_binary_guard.
Print Assumptions original_low_every_unary_guard.
