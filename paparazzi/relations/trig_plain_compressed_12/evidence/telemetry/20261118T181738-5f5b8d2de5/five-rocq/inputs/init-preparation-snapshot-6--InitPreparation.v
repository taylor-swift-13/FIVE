From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import Total PureEval PlainCore TrigData TrigTrace TrigEmission ChunkMachine PackedPrefix InitState InitProtocol InitAssign InitLoop InitGuards InitNibble.
From PprzTrigInitSupport Require Import Control Compound EncoderBody NibbleMachine PostIncrement.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_nibble.
Lemma chunk_read_values : forall c,In c literal_chunks ->
 source_nibble(pos c)=first c /\
 (if multi c then first c=15 /\source_nibble(pos c+1)=second c /\source_nibble(pos c+2)=third c else first c<15).
Proof.
 intros c IN. pose proof literal_trace_reads as H;apply forallb_forall with(x:=c)in H;auto.
 unfold nibble_matchb in H. apply andb_true_iff in H as[A B]. apply Z.eqb_eq in A;split;[exact A|].
 destruct(multi c);repeat rewrite andb_true_iff in B.
 - destruct B as[[F S]T];apply Z.eqb_eq in F;apply Z.eqb_eq in S;apply Z.eqb_eq in T;auto.
 - apply Z.ltb_lt in B;exact B.
Qed.
Definition choice_condition :=match outer_choice with Sifthenelse a _ _=>a|_=>Eval Vundef tint end.
Definition multi_preparation :=match outer_choice with Sifthenelse _ _ s=>s|_=>Sskip end.
Definition input_guard :=match sequence_tail 1 multi_preparation with Ssequence s _=>s|_=>Sskip end.
Definition k_or_statement :=match sequence_tail 4 multi_preparation with Ssequence s _=>s|_=>Sskip end.
Definition k_or_rhs:=Ebinop Oshl(Ebinop Oand(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)(Eval(Vint(Int.repr 8))tint)tint)(Eval(Vint(Int.repr 1))tint)tint.
Lemma choice_guard_value : forall e m c,In c literal_chunks ->short_cell e m PprzTrigInit.Source._temp(first c) ->
 pure_rval PprzTrigInit.Execution.ge e m choice_condition=Some(Val.of_bool(negb(multi c))).
Proof.
 intros e m c IN T.
 change(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge Olt v tshort(Vint(Int.repr 15))tint m|None=>None end=Some(Val.of_bool(negb(multi c)))).
 rewrite(short_read_value _ _ _ _ _ T). change(Some(Val.of_bool(Int.cmp Clt(Int.repr(first c))(Int.repr 15)))=Some(Val.of_bool(negb(multi c)))).
 destruct(chunk_read_values c IN)as[_READ CHOICE].
 pose proof(literal_chunk_bounds c IN)as H;repeat match goal with H:_/\_ |- _=>destruct H end.
 unfold Int.cmp,Int.lt. rewrite(Int.signed_repr(first c))by(change(-2147483648<=first c<=2147483647);lia).
 rewrite(Int.signed_repr 15)by(change(-2147483648<=15<=2147483647);lia).
 destruct(multi c)eqn:M;cbn in CHOICE|-*.
 - destruct CHOICE as[F _];rewrite F,zlt_false by lia;reflexivity.
 - rewrite zlt_true by lia;reflexivity.
Qed.
Lemma input_guard_total : forall Q k e m p,
 0<=p<=3379 ->short_cell e m PprzTrigInit.Source._i p ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e m) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init input_guard k e m).
Proof.
 intros Q k e m p P I END. unfold input_guard.
 eapply Control.if_pure_total with(v:=Vint Int.zero)(choice:=false).
 - reflexivity.
 - change(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._i tshort)tshort)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge Ogt v tshort(Vint(Int.repr 3379))tint m|None=>None end=Some(Vint Int.zero)).
 rewrite(short_read_value _ _ _ _ _ I). change(Some(Val.of_bool(Int.cmp Cgt(Int.repr p)(Int.repr 3379)))=Some(Vint Int.zero)).
 unfold Int.cmp,Int.lt;rewrite(Int.signed_repr p)by(change(-2147483648<=p<=2147483647);lia).
 rewrite(Int.signed_repr 3379)by(change(-2147483648<=3379<=2147483647);lia).
 rewrite zlt_false by lia;reflexivity.
 - reflexivity.
 - exact END.
Qed.
Lemma k_or_atom : forall e m mf c b,In c literal_chunks ->
 e!PprzTrigInit.Source._k=Some(b,tshort) ->Mem.load Mint16signed m b 0=Some(Vint(Int.repr(second c))) ->
 short_cell e m PprzTrigInit.Source._temp(third c) ->
 Mem.store Mint16signed m b 0(Vint(Int.repr(k_value c)))=Some mf ->
 atom_eval PprzTrigInit.Execution.ge e m(match k_or_statement with Sdo a=>a|_=>Eval Vundef tint end)=Some(Vint(Int.repr(k_value c)),mf).
Proof.
 intros e m mf c b IN B LOAD TEMP STORE.
 change(atom_eval PprzTrigInit.Execution.ge e m(Eassignop Oor(Evar PprzTrigInit.Source._k tshort)k_or_rhs tint tshort)=Some(Vint(Int.repr(k_value c)),mf)).
 assert(RHS:pure_rval PprzTrigInit.Execution.ge e m k_or_rhs=Some(Vint(Int.shl(Int.and(Int.repr(third c))(Int.repr 8))(Int.repr 1)))).
 { change(match(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge Oand v tshort(Vint(Int.repr 8))tint m|None=>None end)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge Oshl v tint(Vint(Int.repr 1))tint m|None=>None end=Some(Vint(Int.shl(Int.and(Int.repr(third c))(Int.repr 8))(Int.repr 1)))).
 rewrite(short_read_value _ _ _ _ _ TEMP);reflexivity. }
 unfold atom_eval;cbn[typeof];repeat(progress(rewrite ?B,?dec_eq_true,?RHS;cbn[typeof pure_lval])).
 pose proof(short_deref PprzTrigInit.Execution.ge PureEval.quiet_world m b(second c)LOAD)as READ.
 change(Cexec.do_deref_loc PprzTrigInit.Execution.ge PureEval.quiet_world tshort m b Ptrofs.zero Full=Some(PureEval.quiet_world,Events.E0,Vint(Int.repr(second c))))in READ;rewrite READ.
 change(match sem_cast(Vint(machine_k c))tint tshort m with
 |Some v=>match Cexec.do_assign_loc PprzTrigInit.Execution.ge PureEval.quiet_world tshort m b Ptrofs.zero Full v with
 |Some(_,_,m',v')=>Some(v',m')|_=>None end|_=>None end=Some(Vint(Int.repr(k_value c)),mf)).
 change(match Some(Vint(Int.sign_ext 16(machine_k c)))with
 |Some v=>match Cexec.do_assign_loc PprzTrigInit.Execution.ge PureEval.quiet_world tshort m b Ptrofs.zero Full v with
 |Some(_,_,m',v')=>Some(v',m')|_=>None end|_=>None end=Some(Vint(Int.repr(k_value c)),mf)).
 rewrite(proj2(proj2(literal_chunk_machine c IN))).
 pose proof(short_assign PprzTrigInit.Execution.ge PureEval.quiet_world m b(k_value c)mf STORE)as WRITE.
 change(Cexec.do_assign_loc PprzTrigInit.Execution.ge PureEval.quiet_world tshort m b Ptrofs.zero Full(Vint(Int.repr(k_value c)))=Some(PureEval.quiet_world,Events.E0,mf,Vint(Int.repr(k_value c))))in WRITE;rewrite WRITE;reflexivity.
Qed.
Lemma literal_k_bounds_certificate : forallb(fun c=>(0<=?k_value c)&&(k_value c<=?31))literal_chunks=true.
Proof. vm_compute;reflexivity. Qed.
Lemma literal_k_bounds : forall c,In c literal_chunks ->0<=k_value c<=31.
Proof.
 intros c IN;pose proof literal_k_bounds_certificate as H;apply forallb_forall with(x:=c)in H;auto.
 apply andb_true_iff in H as[A B];apply Z.leb_le in A;apply Z.leb_le in B;lia.
Qed.
Theorem k_or_action : forall Q k e base input buffer prefix m c,
 In c literal_chunks ->protocol_core e base input buffer m ->packed_prefix prefix m buffer ->
 short_cell e m PprzTrigInit.Source._k(second c) ->short_cell e m PprzTrigInit.Source._temp(third c) ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix prefix mf buffer /\short_cell e mf PprzTrigInit.Source._k(k_value c) /\
 (forall id old,id<>PprzTrigInit.Source._k->short_cell e m id old->short_cell e mf id old) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init k_or_statement k e m).
Proof.
 intros Q k e base input buffer prefix m c IN C P K T END.
 destruct(short_store_exists _ _ _ _ (k_value c)K ltac:(pose proof(literal_k_bounds c IN);lia))as[b[mf[B[S NEW]]]].
 eapply do_atom_total with(v:=Vint(Int.repr(k_value c)))(mf:=mf);try reflexivity.
 - eapply k_or_atom;try eassumption;destruct K as[b0[B0[L R]]];assert(b0=b)by congruence;subst b0;exact L.
 - apply END;split;[eapply protocol_core_local_store;eauto|]. split.
   + eapply packed_prefix_local_store;[exact P|eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ C)|exact B]|exact S].
   + split;[exact NEW|]. intros id old NE CELL;eapply short_cell_store_other;[exact CELL|exact S|].
     intros b' B';eapply sh_injective;[exact(pc_shape _ _ _ _ _ C)|exact B'|exact B|exact NE].
Qed.
Definition prepared_inv(e:env)(base:mem)(input buffer:block)(c:chunk)(m:mem):Prop :=
 protocol_core e base input buffer m /\packed_prefix(count_before c)m buffer /\fixed_inner_cells e m c /\
 short_cell e m PprzTrigInit.Source._cnt(count_before c) /\short_cell e m PprzTrigInit.Source._val(value_before c) /\
 short_cell e m PprzTrigInit.Source._val_prev(previous_at(count_before c)).
Theorem prepared_inner_start : forall Q k e base input buffer c m,
 prepared_inv e base input buffer c m ->
 (forall mf,iteration_inv e base input buffer c 0 BeforeEncode mf ->Total.total PprzTrigInit.Execution.ge Q
 (State PprzTrigInit.Source.f_pprz_trig_int_init(inner_loop c)k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(inner_with_init c)k e m).
Proof.
 intros Q k e base input buffer c m[C[P[F[CNT[VAL PREV]]]]]END.
 assert(SHAPE:inner_with_init c=Sfor(Sdo(Eassign(Evar PprzTrigInit.Source._j tshort)(Eval(Vint(Int.repr 0))tint)tshort))
 (inner_condition c)(inner_advance c)(inner_body c)).
 { unfold inner_condition,inner_advance,inner_body,inner_with_init;destruct(multi c);reflexivity. }
 rewrite SHAPE;apply Control.for_start_total;[discriminate|].
 eapply short_assignment_action with(base:=base)(input:=input)(buffer:=buffer)(p:=count_before c)(z:=0);try eassumption;try reflexivity.
 - vm_compute;auto.
 - left;right;left;reflexivity.
 - lia.
 - intros mf[CF[PF[J OTHER]]]. apply Control.skip_sequence_total;apply END.
   unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous;cbn.
   rewrite Z.add_0_r,Z.mul_0_l,Z.add_0_r.
   split;[exact CF|]. split;[exact PF|]. split.
   + destruct F as[I[T F]];unfold fixed_inner_cells;split;[apply OTHER;[discriminate|exact I]|].
     split;[apply OTHER;[discriminate|exact T]|]. destruct(multi c).
     * destruct F as[A B];split;apply OTHER;try discriminate;assumption.
     * apply OTHER;[discriminate|exact F].
   + split;[exact J|]. split;[apply OTHER;[discriminate|exact CNT]|]. split;apply OTHER;try discriminate;assumption.
Qed.
