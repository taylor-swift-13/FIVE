From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import Total PureEval TrigData TrigTrace TrigEmission PackedPrefix InitState InitProtocol InitAssign InitLoop InitGuards InitOuterLoop.
Import ListNotations.
Local Open Scope Z_scope.
Lemma previous_after_emission : forall c j,In c literal_chunks ->0<=j<repetitions c ->
 previous_at(count_before c+(j+1))=value_before c+j*delta c.
Proof.
 intros c j IN J;unfold previous_at.
 assert(C:0<=count_before c)by(pose proof(literal_chunk_bounds c IN);tauto).
 assert(E:Z.eqb(count_before c+(j+1))0=false)by(apply Z.eqb_neq;lia).
 rewrite E.
 replace(count_before c+(j+1)-1)with(count_before c+j)by ring.
 apply literal_emission_at;assumption.
Qed.
Lemma phase_advanced : forall e base input buffer c j m mf,
 In c literal_chunks ->0<=j<repetitions c ->iteration_inv e base input buffer c j AfterValue m ->
 protocol_core e base input buffer mf ->packed_prefix(count_before c+j+1)mf buffer ->
 short_cell e mf PprzTrigInit.Source._j(j+1) ->
 (forall id z,id<>PprzTrigInit.Source._j->short_cell e m id z->short_cell e mf id z) ->
 iteration_inv e base input buffer c(j+1)BeforeEncode mf.
Proof.
 intros e base input buffer c j m mf IN RANGE[C[P[FIX[J[CNT[VAL PREV]]]]]]CN PN NEW OTHER.
 unfold iteration_inv,iteration_prefix,iteration_count,iteration_value,iteration_previous in P,CNT,VAL,PREV|-*;cbn in P,CNT,VAL,PREV|-*.
 try rewrite! Z.add_0_r in P;try rewrite! Z.add_0_r in CNT;try rewrite! Z.add_0_r in VAL;try rewrite! Z.add_0_r in PREV;try rewrite! Z.add_0_r.
 assert(FN:fixed_inner_cells e mf c).
 { destruct FIX as[I[T REST]]. split;[apply OTHER;[discriminate|exact I]|]. split;[apply OTHER;[discriminate|exact T]|].
   destruct(multi c);cbn in REST|-*;[destruct REST as[TP K];split|];apply OTHER;try discriminate;assumption. }
 assert(PN':packed_prefix(count_before c+(j+1))mf buffer).
 { replace(count_before c+(j+1))with(count_before c+j+1)by ring;exact PN. }
 assert(CNTN:short_cell e mf PprzTrigInit.Source._cnt(count_before c+(j+1))).
 { replace(count_before c+(j+1))with(count_before c+j+1)by ring;apply OTHER;[discriminate|exact CNT]. }
 assert(VN:short_cell e mf PprzTrigInit.Source._val(value_before c+(j+1)*delta c))by(apply OTHER;[discriminate|exact VAL]).
 assert(PR:short_cell e mf PprzTrigInit.Source._val_prev(previous_at(count_before c+(j+1)))).
 { rewrite(previous_after_emission c j IN RANGE);apply OTHER;[discriminate|exact PREV]. }
 repeat first[assumption|split].
Qed.
Lemma inner_advance_shape : forall c,inner_advance c=Sdo(Epostincr Incr(Evar PprzTrigInit.Source._j tshort)tshort).
Proof. intros c;unfold inner_advance,inner_with_init;destruct(multi c);reflexivity. Qed.
Theorem inner_advance_total : forall Q k e base input buffer c j m,
 In c literal_chunks ->0<=j<repetitions c ->iteration_inv e base input buffer c j AfterValue m ->
 (forall mf,iteration_inv e base input buffer c(j+1)BeforeEncode mf ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(inner_advance c)k e m).
Proof.
 intros Q k e base input buffer c j m IN RANGE INV END.
 destruct INV as[C[P[FIX[J[CNT[VAL PREV]]]]]].
 rewrite inner_advance_shape.
 eapply short_increment_action with(base:=base)(input:=input)(buffer:=buffer)(p:=count_before c+j+1)(z:=j);try eassumption.
 - pose proof(literal_chunk_bounds c IN);lia.
 - intros mf[CN[PN[NEW OTHER]]];apply END.
   eapply phase_advanced;try eassumption.
   repeat first[assumption|split].
Qed.
Definition SourceBodyRule : Prop :=forall Q k e base input buffer c j m,
 In c literal_chunks ->0<=j<repetitions c ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 iteration_inv e base input buffer c j BeforeEncode m ->
 (forall mf,iteration_inv e base input buffer c j AfterValue mf ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(inner_body c)k e m).
Theorem inner_source_rule_from_body : SourceBodyRule ->SourceInnerRule.
Proof.
 intros BODY Q k e base input buffer c m IN BUFFER INV END.
 eapply rle_inner_loop_total with(P:=fun j m=>iteration_inv e base input buffer c j BeforeEncode m)
 (A:=fun j m=>iteration_inv e base input buffer c j AfterValue m)(j:=0);try eassumption.
 - intros j mm RANGE H;destruct H as[C[P[[I[T REST]][J[COUNT[VAL PREV]]]]]].
   eapply inner_guard_value;[exact IN|exact J|exact REST].
 - intros j mm RANGE H NEXT;eapply BODY;try eassumption.
 - intros j mm RANGE H NEXT;eapply inner_advance_total;eauto.
 - pose proof(literal_chunk_bounds c IN);lia.
Qed.
Print Assumptions previous_after_emission.
Print Assumptions inner_advance_total.
Print Assumptions inner_source_rule_from_body.
