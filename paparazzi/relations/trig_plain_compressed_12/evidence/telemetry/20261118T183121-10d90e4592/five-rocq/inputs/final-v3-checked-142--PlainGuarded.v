From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import TrigData InitialMemory PlainCore PlainBody PlainEntry PlainClosed BranchPure PureEval.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import TypedGuards SineGuards SineMath MathCoverage GuardedCover GuardedControl GuardedSineFront.
Import ListNotations.
Local Open Scope Z_scope.
Lemma array_read_math:forall(ge:Csem.genv)local m table idx word,
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 math_guarded ge(angle_env local)m idx ->branch_rval ge(angle_env local)m idx=Some(Vint word) ->
 math_guarded ge(angle_env local)m(array_read idx).
Proof.
 intros ge local m table idx word SYMBOL MG EV.
 change(math_guarded ge(angle_env local)m(Ebinop Oadd table_expr idx(Tpointer tshort noattr))).
 eapply math_binop;[exact I|exact MG|exact(table_address ge local m table SYMBOL)|exact EV|exact I].
Qed.
Lemma lookup_math_positive:forall(ge:Csem.genv)local m table a,
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->Mem.load Mint32 m local 0=Some(Vint a) ->
 math_guarded ge(angle_env local)m lookup_expr.
Proof. intros;change(math_guarded ge(angle_env local)m(array_read read_angle));eapply array_read_math;[exact H|exact I|exact(angle_read ge local m a H0)]. Qed.
Lemma lookup_math_negative:forall(ge:Csem.genv)local m table a v,
 -6433<=Int.signed a<0 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2* -Int.signed a)=Some(Vint v) ->
 math_guarded ge(angle_env local)m lookup_negative_expr.
Proof.
 intros ge local m table a v RANGE LOAD SYMBOL TABLE.
 assert(IDX:branch_rval ge(angle_env local)m(Eunop Oneg read_angle tint)=Some(Vint(Int.neg a))).
 { change(match pure_rval ge(angle_env local)m read_angle with Some w=>sem_unary_operation Oneg w tint m|_=>None end=Some(Vint(Int.neg a)));rewrite(angle_read ge local m a LOAD);reflexivity. }
 assert(IMG:math_guarded ge(angle_env local)m(Eunop Oneg read_angle tint)).
 { eapply math_unop;[exact I|exact(angle_read ge local m a LOAD)|]. change(signed32(-Int.signed a));unfold signed32;lia. }
 assert(ARR:branch_rval ge(angle_env local)m(array_read(Eunop Oneg read_angle tint))=Some(Vint v)).
 { change(pure_rval ge(angle_env local)m(array_read(Eunop Oneg read_angle tint))=Some(Vint v)).
   eapply lookup_index_value with(a:=Int.neg a)(table:=table);try reflexivity;try exact IDX;try exact SYMBOL.
   - rewrite neg_signed_small by lia;lia.
   - rewrite neg_signed_small by lia;exact TABLE. }
 pose proof(load_signed16_range m table(2* -Int.signed a)v TABLE)as VBOUND.
 change(math_guarded ge(angle_env local)m(Eunop Oneg(array_read(Eunop Oneg read_angle tint))tint)).
 eapply math_unop;[eapply array_read_math;eauto|exact ARR|].
 change(signed32(-Int.signed v));unfold signed32,signed16 in *;lia.
Qed.
Theorem plain_return_math_covers:forall(ge:Csem.genv)P f local m table a lookup mf,
 fn_return f=tint -> -6433<=Int.signed a<=6433 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 (forall n,0<=n<6434 ->Mem.load Mint16signed m table(2*n)=Some(Vint(lookup n))) ->
 Mem.free_list m(blocks_of_env ge(angle_env local))=Some mf ->
 P(Returnstate(Vint(table_result lookup a))Kstop mf) ->
 guarded_covers ge P(State f return_stmt Kstop(angle_env local)m).
Proof.
 intros ge P f local m table a lookup mf RET RANGE LOAD SYMBOL TABLE FREE END.
 change(guarded_covers ge P(State f(Sifthenelse return_guard return_positive return_negative)Kstop(angle_env local)m)).
 eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Cge a Int.zero))(choice:=Int.cmp Cge a Int.zero).
 - reflexivity.
 - exact(return_guard_value ge local m a LOAD).
 - change(math_guarded ge(angle_env local)m(Ebinop Oge read_angle(Eval(Vint Int.zero)tint)tint)).
   eapply math_binop;[exact I|exact I|exact(angle_read ge local m a LOAD)|reflexivity|exact I].
 - apply bool_of_bool.
 - destruct(Int.cmp Cge a Int.zero)eqn:POS;cbn.
   + assert(N:0<=Int.signed a)by(apply cmp_nonneg;exact POS).
     eapply return_math_guarded with(v:=Vint(lookup(Int.signed a)))(result:=Vint(lookup(Int.signed a)))(mf:=mf).
     * reflexivity.
     * apply lookup_value with(table:=table)(a:=a);auto;[lia|apply TABLE;lia].
     * eapply lookup_math_positive;eauto.
     * rewrite RET;reflexivity.
     * exact FREE.
     * apply guarded_here;[exact I|]. unfold table_result in END;rewrite POS in END;exact END.
   + assert(N:Int.signed a<0).
     { destruct(Z_le_gt_dec 0(Int.signed a));[|lia]. assert(C:Int.cmp Cge a Int.zero=true)by(apply cmp_nonneg;lia);congruence. }
     eapply return_math_guarded with(v:=Vint(Int.neg(lookup(-Int.signed a))))(result:=Vint(Int.neg(lookup(-Int.signed a))))(mf:=mf).
     * reflexivity.
     * apply lookup_negative_value with(table:=table)(a:=a);auto;[lia|apply TABLE;lia].
     * eapply lookup_math_negative with(table:=table)(a:=a)(v:=lookup(-Int.signed a));[lia|exact LOAD|exact SYMBOL|apply TABLE;lia].
     * rewrite RET;reflexivity.
     * exact FREE.
     * apply guarded_here;[exact I|]. unfold table_result in END;rewrite POS in END;exact END.
Qed.
Theorem plain_entry_math_total:forall(ge:Csem.genv)m table a lookup,
 -12867<=Int.signed a<=12867 ->Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 (forall n,0<=n<6434 ->Mem.load Mint16signed m table(2*n)=Some(Vint(lookup n))) ->
 guarded_total ge(fun _ _=>True)(Callstate(Internal PlainBody.fun_sin)[Vint a]Kstop m).
Proof.
 intros ge m table a lookup RANGE SYMBOL TABLE.
 destruct(Mem.alloc m 0 4)as[m1 local]eqn:ALLOC.
 assert(FRESH:~Mem.valid_block m local)by(eapply Mem.fresh_block_alloc;eauto).
 assert(TVALID:Mem.valid_block m table).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;apply(TABLE 0);lia|constructor]. }
 assert(NE:table<>local)by congruence.
 assert(VAF:Mem.valid_access m1 Mint32 local 0 Freeable)by(eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|cbn;lia|exists 0;reflexivity]).
 assert(VAW:Mem.valid_access m1 Mint32 local 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a)VAW)as[m2 STORE].
 assert(LOAD:Mem.load Mint32 m2 local 0=Some(Vint a))by exact(Mem.load_store_same _ _ _ _ _ _ STORE).
 assert(VA:Mem.valid_access m2 Mint32 local 0 Writable)by(eapply Mem.store_valid_access_1;eauto).
 assert(FREE:Mem.range_perm m2 local 0 4 Cur Freeable).
 { intros ofs B;eapply Mem.perm_store_1;[exact STORE|exact((proj1 VAF)ofs B)]. }
 apply covers_guarded_total;eapply internal_guarded with(e:=angle_env local)(m1:=m1)(m2:=m2).
 - cbn[PlainBody.fun_sin fn_params fn_vars var_names];repeat constructor;cbn;auto.
 - change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigPlain.Source._angle,tint)]=(angle_env local,m1)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 4 with|(mm,bb)=>(PTree.set PprzTrigPlain.Source._angle(bb,tint)empty_env,mm)end=(angle_env local,m1));rewrite ALLOC;reflexivity.
 - apply bind_angle;exact STORE.
 - change(guarded_covers ge(guarded_total ge(fun _ _=>True))(State PlainBody.fun_sin(Ssequence norm(Ssequence fold_stmt return_stmt))Kstop(angle_env local)m2)).
   eapply normalized_front_math_covers;[exact RANGE|exact LOAD|exact VA|].
   intros middle FM;destruct(fold_memory_local local a m2 middle LOAD FREE FM)as[MLOAD MFREE].
   destruct(Mem.range_perm_free _ _ _ _ MFREE)as[mf MEMFREE].
   assert(FL:Mem.free_list middle(blocks_of_env ge(angle_env local))=Some mf).
   { rewrite angle_env_blocks;cbn[Mem.free_list];rewrite MEMFREE;reflexivity. }
   eapply plain_return_math_covers with(table:=table)(a:=folded a)(lookup:=lookup)(mf:=mf);try reflexivity;try exact MLOAD;try exact SYMBOL;try exact FL.
   + apply folded_bounds;exact RANGE.
   + intros n NB;rewrite(fold_memory_other local a m2 middle table Mint16signed(2*n)NE FM).
     rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint16signed table(2*n))by auto.
     rewrite(Mem.load_alloc_unchanged _ _ _ _ _ ALLOC Mint16signed table(2*n))by exact TVALID;apply TABLE;exact NB.
   + apply guarded_final;exact I.
Qed.
Theorem original_plain_all_prefixes_math:forall initial a,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 guarded_total PprzTrigPlain.Execution.ge(fun _ _=>True)(PprzTrigPlain.Execution.entry[Vint a]initial).
Proof.
 intros initial a INIT RANGE;destruct plain_symbol_info_exists as[table[SYM INFO]].
 eapply plain_entry_math_total with(table:=table)(lookup:=PlainClosed.literal_lookup);try exact RANGE;try exact SYM.
 intros n NB;unfold PlainClosed.literal_lookup;eapply plain_literal_loads;eauto.
Qed.
Print Assumptions plain_entry_math_total.
Print Assumptions original_plain_all_prefixes_math.

Theorem original_plain_every_binary_guard:forall initial a prefix f expr k e m op l rv,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)prefix(ExprState f expr k e m) ->
 BinaryOperationOccurrence expr op l rv ->binary_math_guard op l rv.
Proof.
 intros initial a prefix f expr k e m op l rv INIT RANGE PATH OCC.
 eapply guarded_prefix_binary_guard;[exact(original_plain_all_prefixes_math initial a INIT RANGE)|exact PATH|exact OCC].
Qed.
Theorem original_plain_every_unary_guard:forall initial a prefix f expr k e m op v,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)prefix(ExprState f expr k e m) ->
 UnaryOperationOccurrence expr op v ->unary_math_guard op v.
Proof.
 intros initial a prefix f expr k e m op v INIT RANGE PATH OCC.
 eapply guarded_prefix_unary_guard;[exact(original_plain_all_prefixes_math initial a INIT RANGE)|exact PATH|exact OCC].
Qed.
Print Assumptions original_plain_every_binary_guard.
Print Assumptions original_plain_every_unary_guard.
