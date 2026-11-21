From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PureEval PlainCore Total TrigData TrigTrace TrigEmission ChunkMachine InitState InitLoop InitGuards InitProtocol InitAssign PackedPrefix.
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
