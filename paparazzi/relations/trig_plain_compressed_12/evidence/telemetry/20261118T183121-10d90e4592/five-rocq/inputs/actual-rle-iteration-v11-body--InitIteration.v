From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PureEval PlainCore Total TrigData TrigTrace TrigEmission ChunkMachine InitState InitLoop InitGuards InitProtocol InitAssign PackedPrefix LowDispatcher.
From PprzTrigInitSupport Require Import Control Frame EncoderStatement.
Import ListNotations.
Open Scope Z_scope.
Lemma previous_at_bounds : forall n,0<=n<=6434 ->0<=previous_at n<=16383.
Proof.
 intros n N;unfold previous_at. destruct(Z.eqb_spec n 0);[lia|]. unfold table_at;apply literal_value_at_bounds;lia.
Qed.
Lemma short_cell_call_frame : forall e base input buffer m mf id z,
 protocol_core e base input buffer m ->Mem.unchanged_on(protected m buffer)m mf ->
 short_cell e m id z ->short_cell e mf id z.
Proof.
 intros e base input buffer m mf id z C F[b[B[L R]]].
 assert(VALID:Mem.valid_block m b)by(eapply Mem.perm_valid_block;apply(R 0);lia).
 assert(NE:b<>buffer)by(eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ C)|exact B]).
 exists b;split;[exact B|]. split.
 - eapply Mem.load_unchanged_on;[exact F| |exact L]. intros i I;split;assumption.
 - intros i I;eapply Mem.perm_unchanged_on;[exact F|split;assumption|apply R;exact I].
Qed.
Lemma fixed_cells_other : forall e m mf c id,
 (PprzTrigInit.Source._i<>id /\PprzTrigInit.Source._tab_12<>id /\PprzTrigInit.Source._temp<>id /\PprzTrigInit.Source._k<>id) ->
 (forall id' z,id'<>id->short_cell e m id' z->short_cell e mf id' z) ->fixed_inner_cells e m c ->fixed_inner_cells e mf c.
Proof.
 intros e m mf c id[NI[NT[NP NK]]]OTHER[I[T REST]]. split;[apply OTHER;assumption|]. split;[apply OTHER;assumption|].
 destruct(multi c);cbn in REST|-*;[destruct REST as[TP K];split|];apply OTHER;assumption.
Qed.
Lemma fixed_cells_frame : forall e base input buffer m mf c,
 protocol_core e base input buffer m ->Mem.unchanged_on(protected m buffer)m mf ->
 fixed_inner_cells e m c->fixed_inner_cells e mf c.
Proof.
 intros e base input buffer m mf c C F[I[T REST]]. split;[eapply short_cell_call_frame;eauto|]. split;[eapply short_cell_call_frame;eauto|].
 destruct(multi c);cbn in REST|-*;[destruct REST as[TP K];split|];eapply short_cell_call_frame;eauto.
Qed.
Definition first_statement(s:statement):statement :=match s with Ssequence a _=>a|_=>s end.
Definition encoder_statement(c:chunk):statement :=first_statement(inner_body c).
Definition previous_statement(c:chunk):statement :=first_statement(sequence_tail 1(inner_body c)).
Definition count_statement(c:chunk):statement :=first_statement(sequence_tail 2(inner_body c)).
Definition value_statement(c:chunk):statement :=first_statement(sequence_tail 3(inner_body c)).
Definition count_check(c:chunk):statement :=sequence_tail 4(inner_body c).
Definition delta_expr(c:chunk):expr :=match value_statement c with Sdo(Eassignop _ _ r _ _)=>r|_=>Eval Vundef tint end.
Lemma delta_shape : forall c,delta_expr c=
 Ebinop(if multi c then Oand else Omod)(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)
 (Eval(Vint(Int.repr(if multi c then 7 else 5)))tint)tint.
Proof. intros c;unfold delta_expr,value_statement,inner_body,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma delta_value : forall ge e m c,In c literal_chunks ->fixed_inner_cells e m c ->
 pure_rval ge e m(delta_expr c)=Some(Vint(Int.repr(delta c))).
Proof.
 intros ge e m c IN[I[T REST]]. pose proof(literal_chunk_machine c IN)as[LIM[DELTA K]].
 rewrite delta_shape,<-DELTA. unfold machine_delta. destruct(multi c)eqn:M;cbn in REST|-*.
 - destruct REST as[TP CK]. change(match pure_rval ge e m(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)with
   |Some v=>sem_binary_operation ge Oand v tshort(Vint(Int.repr 7))tint m|None=>None end=Some(Vint(Int.and(Int.repr(third c))(Int.repr 7)))).
   rewrite(short_read_value _ _ _ _ _ TP);reflexivity.
 - change(match pure_rval ge e m(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)with
   |Some v=>sem_binary_operation ge Omod v tshort(Vint(Int.repr 5))tint m|None=>None end=Some(Vint(Int.mods(Int.repr(first c))(Int.repr 5)))).
   rewrite(short_read_value _ _ _ _ _ REST).
   cbv beta iota zeta delta[sem_binary_operation sem_mod sem_binarith classify_binarith binarith_type typeconv sem_cast classify_cast cast_int_int tshort tint Archi.ptr64].
   assert(E0:Int.eq(Int.repr 5)Int.zero=false)by(vm_compute;reflexivity).
   assert(EM:Int.eq(Int.repr 5)Int.mone=false)by(vm_compute;reflexivity).
   rewrite E0,EM,andb_false_r;reflexivity.
Qed.
Lemma count_check_shape : forall c,count_check c=Sifthenelse
 (Ebinop Ogt(Evalof(Evar PprzTrigInit.Source._cnt tshort)tshort)(Eval(Vint(Int.repr 6434))tint)tint)
 (Sreturn(Some(Eunop Oneg(Eval(Vint(Int.repr 1))tint)tint)))Sskip.
Proof. intros c;unfold count_check,inner_body,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma count_check_false_total : forall ge Q f k e m c n,
 0<=n<=6434 ->short_cell e m PprzTrigInit.Source._cnt n ->Total.total ge Q(State f Sskip k e m) ->
 Total.total ge Q(State f(count_check c)k e m).
Proof.
 intros ge Q f k e m c n N C END;rewrite count_check_shape.
 eapply if_pure_total with(v:=Vint Int.zero)(choice:=false).
 - reflexivity.
 - change(match pure_rval ge e m(Evalof(Evar PprzTrigInit.Source._cnt tshort)tshort)with
   |Some v=>sem_binary_operation ge Ogt v tshort(Vint(Int.repr 6434))tint m|None=>None end=Some(Vint Int.zero)).
   rewrite(short_read_value _ _ _ _ _ C).
   change(Some(Val.of_bool(Int.cmp Cgt(Int.repr n)(Int.repr 6434)))=Some(Vint Int.zero)).
   unfold Int.cmp,Int.lt. rewrite(Int.signed_repr n)by(change(-2147483648<=n<=2147483647);lia).
   rewrite(Int.signed_repr 6434)by(change(-2147483648<=6434<=2147483647);lia).
   rewrite zlt_false by lia;reflexivity.
 - reflexivity.
 - exact END.
Qed.

Lemma phase_encoded : forall e base input buffer c j m mf,
 iteration_inv e base input buffer c j BeforeEncode m ->
 packed_prefix(count_before c+j+1)mf buffer ->Mem.unchanged_on(protected m buffer)m mf ->
 iteration_inv e base input buffer c j AfterEncode mf.
Proof.
 intros e base input buffer c j m mf[C[P[FIX[J[CNT[VAL PREV]]]]]]PN F.
 unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous in *;cbn in *.
 repeat rewrite Z.add_0_r in *.
 assert(CN:protocol_core e base input buffer mf)by(eapply protocol_core_frame;eauto).
 assert(FN:fixed_inner_cells e mf c)by(exact(@fixed_cells_frame e base input buffer m mf c C F FIX)).
 assert(JN:short_cell e mf PprzTrigInit.Source._j j)by(eapply short_cell_call_frame;[exact C|exact F|eassumption]).
 assert(CNTN:short_cell e mf PprzTrigInit.Source._cnt(count_before c+j))by(eapply short_cell_call_frame;[exact C|exact F|eassumption]).
 assert(VN:short_cell e mf PprzTrigInit.Source._val(value_before c+j*delta c))by(eapply short_cell_call_frame;[exact C|exact F|eassumption]).
 assert(PN':short_cell e mf PprzTrigInit.Source._val_prev(previous_at(count_before c+j)))by(eapply short_cell_call_frame;[exact C|exact F|eassumption]).
 repeat first[assumption|split].
Qed.
Lemma phase_previous : forall e base input buffer c j m mf,
 iteration_inv e base input buffer c j AfterEncode m ->
 protocol_core e base input buffer mf ->packed_prefix(count_before c+j+1)mf buffer ->
 short_cell e mf PprzTrigInit.Source._val_prev(value_before c+j*delta c) ->
 (forall id z,id<>PprzTrigInit.Source._val_prev->short_cell e m id z->short_cell e mf id z) ->
 iteration_inv e base input buffer c j AfterPrevious mf.
Proof.
 intros e base input buffer c j m mf[C[P[FIX[J[CNT[VAL PREV]]]]]]CN PN NEW OTHER.
 unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous in *;cbn in *.
 repeat rewrite Z.add_0_r in *.
 assert(FN:fixed_inner_cells e mf c).
 { eapply fixed_cells_other with(id:=PprzTrigInit.Source._val_prev);[vm_compute;repeat split;discriminate|exact OTHER|exact FIX]. }
 assert(JN:short_cell e mf PprzTrigInit.Source._j j)by(apply OTHER;[vm_compute;discriminate|exact J]).
 assert(CNTN:short_cell e mf PprzTrigInit.Source._cnt(count_before c+j))by(apply OTHER;[vm_compute;discriminate|exact CNT]).
 assert(VN:short_cell e mf PprzTrigInit.Source._val(value_before c+j*delta c))by(apply OTHER;[vm_compute;discriminate|exact VAL]).
 repeat first[assumption|split].
Qed.
Lemma phase_count : forall e base input buffer c j m mf,
 iteration_inv e base input buffer c j AfterPrevious m ->
 protocol_core e base input buffer mf ->packed_prefix(count_before c+j+1)mf buffer ->
 short_cell e mf PprzTrigInit.Source._cnt(count_before c+j+1) ->
 (forall id z,id<>PprzTrigInit.Source._cnt->short_cell e m id z->short_cell e mf id z) ->
 iteration_inv e base input buffer c j AfterCount mf.
Proof.
 intros e base input buffer c j m mf[C[P[FIX[J[CNT[VAL PREV]]]]]]CN PN NEW OTHER.
 unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous in *;cbn in *.
 repeat rewrite Z.add_0_r in *.
 assert(FN:fixed_inner_cells e mf c).
 { eapply fixed_cells_other with(id:=PprzTrigInit.Source._cnt);[vm_compute;repeat split;discriminate|exact OTHER|exact FIX]. }
 assert(JN:short_cell e mf PprzTrigInit.Source._j j)by(apply OTHER;[vm_compute;discriminate|exact J]).
 assert(VN:short_cell e mf PprzTrigInit.Source._val(value_before c+j*delta c))by(apply OTHER;[vm_compute;discriminate|exact VAL]).
 assert(PR:short_cell e mf PprzTrigInit.Source._val_prev(value_before c+j*delta c))by(apply OTHER;[vm_compute;discriminate|exact PREV]).
 repeat first[assumption|split].
Qed.
Lemma phase_value : forall e base input buffer c j m mf,
 iteration_inv e base input buffer c j AfterCount m ->
 protocol_core e base input buffer mf ->packed_prefix(count_before c+j+1)mf buffer ->
 short_cell e mf PprzTrigInit.Source._val(value_before c+j*delta c+delta c) ->
 (forall id z,id<>PprzTrigInit.Source._val->short_cell e m id z->short_cell e mf id z) ->
 iteration_inv e base input buffer c j AfterValue mf.
Proof.
 intros e base input buffer c j m mf[C[P[FIX[J[CNT[VAL PREV]]]]]]CN PN NEW OTHER.
 unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous in *;cbn in *.
 repeat rewrite Z.add_0_r in *.
 replace(value_before c+j*delta c+delta c)with(value_before c+(j+1)*delta c)in NEW by ring.
 assert(FN:fixed_inner_cells e mf c).
 { eapply fixed_cells_other with(id:=PprzTrigInit.Source._val);[vm_compute;repeat split;discriminate|exact OTHER|exact FIX]. }
 assert(JN:short_cell e mf PprzTrigInit.Source._j j)by(apply OTHER;[vm_compute;discriminate|exact J]).
 assert(CC:short_cell e mf PprzTrigInit.Source._cnt(count_before c+j+1))by(apply OTHER;[vm_compute;discriminate|exact CNT]).
 assert(PR:short_cell e mf PprzTrigInit.Source._val_prev(value_before c+j*delta c))by(apply OTHER;[vm_compute;discriminate|exact PREV]).
 repeat first[assumption|split].
Qed.

Lemma encoder_function_link : exists fb,
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._table_encode_12=Some fb /\
 Genv.find_funct PprzTrigInit.Execution.ge(Vptr fb Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_table_encode_12).
Proof. apply(LowDispatcher.source_function_link PprzTrigInit.Source.prog PprzTrigInit.Source._table_encode_12 PprzTrigInit.Source.f_table_encode_12);vm_compute;reflexivity. Qed.
Lemma encoder_unshadowed : forall e base input buffer,init_shape e base input buffer->e!PprzTrigInit.Source._table_encode_12=None.
Proof.
 intros e base input buffer S;destruct(e!PprzTrigInit.Source._table_encode_12)as[[b ty]|]eqn:E;[|reflexivity].
 destruct(sh_domain _ _ _ _ S _ _ _ E)as[IN TY]. vm_compute in IN;intuition discriminate.
Qed.
Lemma source_body_shape : forall c,inner_body c=Ssequence(encoder_statement c)
 (Ssequence(previous_statement c)(Ssequence(count_statement c)(Ssequence(value_statement c)(count_check c)))).
Proof.
 intros c;unfold encoder_statement,previous_statement,count_statement,value_statement,count_check,first_statement,inner_body,inner_with_init;destruct(multi c);reflexivity.
Qed.
Lemma previous_shape : forall c,previous_statement c=Sdo(Eassign(Evar PprzTrigInit.Source._val_prev tshort)
 (Evalof(Evar PprzTrigInit.Source._val tshort)tshort)tshort).
Proof. intros c;unfold previous_statement,first_statement,inner_body,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma count_shape : forall c,count_statement c=Sdo(Epostincr Incr(Evar PprzTrigInit.Source._cnt tshort)tshort).
Proof. intros c;unfold count_statement,first_statement,inner_body,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma value_shape : forall c,value_statement c=Sdo(Eassignop Oadd(Evar PprzTrigInit.Source._val tshort)(delta_expr c)tint tshort).
Proof. intros c;unfold delta_expr,value_statement,first_statement,inner_body,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma iteration_encoder_total : forall Q k e base input buffer c j m,
 In c literal_chunks->0<=j<repetitions c ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 iteration_inv e base input buffer c j BeforeEncode m ->
 (forall mf,iteration_inv e base input buffer c j AfterEncode mf->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(encoder_statement c)k e m).
Proof.
 intros Q k e base input buffer c j m IN J BBUF INV END.
 pose proof INV as INV0;destruct INV as[C[P[FIX[JC[CC[VC PR]]]]]].
 unfold iteration_prefix,iteration_count,iteration_value,iteration_previous in P,CC,VC,PR;cbn in P,CC,VC,PR;rewrite!Z.add_0_r in P,CC,VC.
 pose proof(emitted_prefix_bounds c IN j ltac:(lia))as[CB VB].
 pose proof(literal_chunk_bounds c IN)as[POS[PE[CB0[REP[CE[V0[DEL[VE BOUNDSREST]]]]]]]].
 assert(COUNT:0<=count_before c+j<6434)by lia.
 assert(PREV:0<=previous_at(count_before c+j)<=16383)by(apply previous_at_bounds;lia).
 assert(VT:short_cell e m PprzTrigInit.Source._val(table_at(count_before c+j))).
 { rewrite(literal_emission_at c IN j J);exact VC. }
 destruct FIX as[IC[TC REST]]. destruct TC as[bt[BT[LT WT]]].
 destruct encoder_function_link as[fb[FSYM FUN]].
 assert(FN:e!PprzTrigInit.Source._table_encode_12=None)by(eapply encoder_unshadowed;exact(pc_shape _ _ _ _ _ C)).
 destruct(@EncoderStatement.encoder_statement_total e m buffer(count_before c+j)(previous_at(count_before c+j))bt fb
 COUNT PREV P VT PR CC BT FN BBUF FSYM FUN)as[mf[PN[FRAME EXEC]]].
 assert(POST:iteration_inv e base input buffer c j AfterEncode mf).
 { eapply phase_encoded;[|exact PN|exact FRAME]. exact INV0. }
 specialize(EXEC Q PprzTrigInit.Source.f_pprz_trig_int_init k(END mf POST)).
 unfold encoder_statement,first_statement,inner_body,inner_with_init;destruct(multi c);exact EXEC.
Qed.
Lemma iteration_previous_total : forall Q k e base input buffer c j m,
 In c literal_chunks->0<=j<repetitions c ->iteration_inv e base input buffer c j AfterEncode m ->
 (forall mf,iteration_inv e base input buffer c j AfterPrevious mf->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(previous_statement c)k e m).
Proof.
 intros Q k e base input buffer c j m IN J INV END.
 pose proof INV as INV0;destruct INV as[C[P[FIX[JC[CC[VC PR]]]]]].
 unfold iteration_prefix,iteration_count,iteration_value,iteration_previous in P,CC,VC,PR;cbn in P,CC,VC,PR;rewrite!Z.add_0_r in CC,VC.
 pose proof(emitted_prefix_bounds c IN j ltac:(lia))as[CB VB]. rewrite previous_shape.
 eapply short_assignment_action with(base:=base)(input:=input)(buffer:=buffer)(p:=count_before c+j+1)(z:=value_before c+j*delta c).
 - exact C.
 - exact P.
 - vm_compute;auto.
 - reflexivity.
 - reflexivity.
 - apply short_read_value;exact VC.
 - left;reflexivity.
 - exact VB.
 - intros mf[CN[PN[NEW OTHER]]]. apply END.
   eapply phase_previous;[|exact CN|exact PN|exact NEW|exact OTHER].
   exact INV0.
Qed.
Lemma iteration_count_total : forall Q k e base input buffer c j m,
 In c literal_chunks->0<=j<repetitions c ->iteration_inv e base input buffer c j AfterPrevious m ->
 (forall mf,iteration_inv e base input buffer c j AfterCount mf->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(count_statement c)k e m).
Proof.
 intros Q k e base input buffer c j m IN J INV END.
 pose proof INV as INV0;destruct INV as[C[P[FIX[JC[CC[VC PR]]]]]].
 unfold iteration_prefix,iteration_count,iteration_value,iteration_previous in P,CC,VC,PR;cbn in P,CC,VC,PR;rewrite!Z.add_0_r in CC,VC.
 pose proof(literal_chunk_bounds c IN)as[POS[PE[CB0[REP[CE[V0[DEL[VE BOUNDSREST]]]]]]]].
 rewrite count_shape. eapply short_increment_action with(base:=base)(input:=input)(buffer:=buffer)(p:=count_before c+j+1)(z:=count_before c+j).
 - exact C.
 - exact P.
 - exact CC.
 - lia.
 - intros mf[CN[PN[NEW OTHER]]]. apply END.
   eapply phase_count;[|exact CN|exact PN|exact NEW|exact OTHER]. exact INV0.
Qed.
Lemma iteration_value_total : forall Q k e base input buffer c j m,
 In c literal_chunks->0<=j<repetitions c ->iteration_inv e base input buffer c j AfterCount m ->
 (forall mf,iteration_inv e base input buffer c j AfterValue mf->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(value_statement c)k e m).
Proof.
 intros Q k e base input buffer c j m IN J INV END.
 pose proof INV as INV0;destruct INV as[C[P[FIX[JC[CC[VC PR]]]]]].
 unfold iteration_prefix,iteration_count,iteration_value,iteration_previous in P,CC,VC,PR;cbn in P,CC,VC,PR;rewrite!Z.add_0_r in VC.
 pose proof(emitted_prefix_bounds c IN j ltac:(lia))as[CB VB].
 pose proof(emitted_prefix_bounds c IN(j+1)ltac:(lia))as[CB1 VB1].
 pose proof(literal_chunk_bounds c IN)as[POS[PE[CB0[REP[CE[V0[DEL[VE BOUNDSREST]]]]]]]].
 rewrite value_shape. eapply short_addition_action with(base:=base)(input:=input)(buffer:=buffer)(p:=count_before c+j+1)(v:=value_before c+j*delta c)(d:=delta c).
 - exact C.
 - exact P.
 - exact VC.
 - rewrite delta_shape;destruct(multi c);reflexivity.
 - rewrite delta_shape;destruct(multi c);reflexivity.
 - apply delta_value;assumption.
 - rewrite delta_shape;reflexivity.
 - exact VB.
 - lia.
 - nia.
 - intros mf[CN[PN[NEW OTHER]]]. apply END.
   eapply phase_value;[|exact CN|exact PN|exact NEW|exact OTHER]. exact INV0.
Qed.
Theorem iteration_body_total : forall Q k e base input buffer c j m,
 In c literal_chunks->0<=j<repetitions c ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 iteration_inv e base input buffer c j BeforeEncode m ->
 (forall mf,iteration_inv e base input buffer c j AfterValue mf->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(inner_body c)k e m).
Proof.
 intros Q k e base input buffer c j m IN J BUF INV END;rewrite source_body_shape.
 apply sequence_total. eapply iteration_encoder_total;[exact IN|exact J|exact BUF|exact INV|].
 intros m1 I1;apply skip_sequence_total;apply sequence_total. eapply iteration_previous_total;[exact IN|exact J|exact I1|].
 intros m2 I2;apply skip_sequence_total;apply sequence_total. eapply iteration_count_total;[exact IN|exact J|exact I2|].
 intros m3 I3;apply skip_sequence_total;apply sequence_total. eapply iteration_value_total;[exact IN|exact J|exact I3|].
 intros m4 I4;apply skip_sequence_total.
 eapply count_check_false_total with(n:=count_before c+j+1).
 - pose proof(literal_chunk_bounds c IN)as[POS[PE[CB0[REP[CE[V0[DEL[VE BOUNDSREST]]]]]]]];lia.
 - destruct I4 as[_[_[_[_[CC _]]]]]. exact CC.
 - apply END;exact I4.
Qed.
