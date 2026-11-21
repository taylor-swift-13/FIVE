From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Csyntax Csem Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import Total TrigData TrigTrace TrigEmission PackedPrefix InitState InitProtocol InitLoop InitOuterPreparation.
Import ListNotations.
Local Open Scope Z_scope.
Lemma contiguous_tail : forall c cs,contiguousb(c::cs)=true ->contiguousb cs=true.
Proof.
 intros c cs;destruct cs as[|d ds];[reflexivity|].
 cbn[contiguousb];intros H;repeat rewrite andb_true_iff in H;tauto.
Qed.
Lemma contiguous_suffix : forall pre cs,contiguousb(pre++cs)=true ->contiguousb cs=true.
Proof. induction pre as[|c pre IH];cbn;intros cs H;[exact H|apply IH;eapply contiguous_tail;exact H]. Qed.
Lemma last_singleton_append : forall (pre:list chunk)(c d:chunk),last(pre++[c])d=c.
Proof. induction pre as[|a pre IH];intros c d;[reflexivity|]. destruct pre as[|b pre];[reflexivity|apply IH]. Qed.
Lemma suffix_frontiers : forall c cs,chunk_suffix(c::cs) ->
 frontier_pos cs=pos c+consumed c /\frontier_count cs=count_before c+repetitions c /\
 match cs with d::_=>value_before d=value_before c+repetitions c*delta c|[]=>True end.
Proof.
 intros c cs[pre E].
 pose proof literal_trace_contiguous as ALL;rewrite E in ALL.
 pose proof(contiguous_suffix pre(c::cs)ALL)as LOCAL.
 destruct cs as[|d ds].
 - assert(LAST:c=last_chunk).
   { unfold last_chunk;rewrite E;rewrite last_singleton_append;reflexivity. }
   pose proof literal_trace_endpoints as[_[_[_[POS CNT]]]]. rewrite<-LAST in POS,CNT.
   cbn[frontier_pos frontier_count];auto.
 - cbn[contiguousb]in LOCAL;repeat rewrite andb_true_iff in LOCAL.
   destruct LOCAL as[[[POS CNT]VAL]TAIL].
   apply Z.eqb_eq in POS;apply Z.eqb_eq in CNT;apply Z.eqb_eq in VAL.
   cbn[frontier_pos frontier_count];auto.
Qed.
Theorem iteration_to_outer_tail : forall e base input buffer c cs m,
 chunk_suffix(c::cs) ->iteration_inv e base input buffer c(repetitions c)BeforeEncode m ->
 outer_inv e base input buffer cs m.
Proof.
 intros e base input buffer c cs m SUF[C[P[[I[T FIX]][J[CNT[V PREV]]]]]].
 destruct(suffix_frontiers c cs SUF)as[POS[COUNT VAL]].
 unfold iteration_prefix,iteration_count,iteration_value,iteration_previous in *;cbn in P,CNT,V,PREV.
 repeat rewrite Z.add_0_r in P,CNT,V,PREV.
 unfold outer_inv. rewrite COUNT.
 split;[exact C|]. split;[exact P|]. split.
 - change(short_cell e m PprzTrigInit.Source._i(frontier_pos cs));rewrite POS;exact I.
 - split;[exact CNT|]. split;[exact T|].
   destruct cs as[|d ds];[exact I|]. cbn in VAL|-*;rewrite VAL;split;[exact V|exact PREV].
Qed.
Definition SourceInnerRule : Prop :=forall Q k e base input buffer c m,
 In c literal_chunks ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 iteration_inv e base input buffer c 0 BeforeEncode m ->
 (forall mf,iteration_inv e base input buffer c(repetitions c)BeforeEncode mf ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init(inner_loop c)k e m).
Theorem outer_source_loop_total : SourceInnerRule ->forall Q k e base input buffer cs m,
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some input ->
 chunk_suffix cs ->outer_inv e base input buffer cs m ->
 (forall mf,outer_inv e base input buffer[]mf ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init outer_loop k e m).
Proof.
 intros INNER Q k e base input buffer cs m BUFFER INPUT SUF INV FINISH.
 eapply rle_outer_loop_total with(P:=outer_inv e base input buffer);try eassumption.
 - intros rest mm S H;unfold outer_inv in H;destruct H as[_[_[I _]]];exact I.
 - intros c rest mm S H NEXT.
   eapply outer_chunk_preparation_total;[eapply suffix_head_in;exact S|exact H|exact INPUT|].
   intros mi PREP;eapply INNER;[eapply suffix_head_in;exact S|exact BUFFER|exact PREP|].
   intros mf LAST;apply NEXT;eapply iteration_to_outer_tail;eauto.
Qed.
Print Assumptions iteration_to_outer_tail.
Print Assumptions outer_source_loop_total.
