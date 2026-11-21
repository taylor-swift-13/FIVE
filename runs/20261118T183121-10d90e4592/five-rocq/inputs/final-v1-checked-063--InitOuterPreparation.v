From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import Total PureEval PlainCore TrigData TrigTrace TrigEmission ChunkMachine PackedPrefix InitState InitProtocol InitAssign InitLoop InitGuards InitNibble InitPreparation.
From PprzTrigInitSupport Require Import Control NibbleMachine.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_nibble.
Definition retained_cells(e:env)(m:mem)(c:chunk):Prop :=
 short_cell e m PprzTrigInit.Source._cnt(count_before c) /\short_cell e m PprzTrigInit.Source._tab_12 0 /\
 short_cell e m PprzTrigInit.Source._val(value_before c) /\short_cell e m PprzTrigInit.Source._val_prev(previous_at(count_before c)).
Lemma retained_nibble : forall e m mf c target,
 retained_cells e m c ->(target=PprzTrigInit.Source._temp \/target=PprzTrigInit.Source._k)->
 (forall id old,id<>PprzTrigInit.Source._i->id<>target->short_cell e m id old->short_cell e mf id old)->retained_cells e mf c.
Proof.
 intros e m mf c target[A[B[C D]]][-> | ->]O;unfold retained_cells;
 repeat split;apply O;try discriminate;assumption.
Qed.
Lemma retained_k_update : forall e m mf c,
 retained_cells e m c ->
 (forall id old,id<>PprzTrigInit.Source._k->short_cell e m id old->short_cell e mf id old)->retained_cells e mf c.
Proof. intros e m mf c[A[B[C D]]]O;unfold retained_cells;repeat split;apply O;try discriminate;assumption. Qed.
Lemma single_prepared : forall e base input buffer c m,
 multi c=false ->protocol_core e base input buffer m ->packed_prefix(count_before c)m buffer ->
 retained_cells e m c ->short_cell e m PprzTrigInit.Source._i(pos c+1) ->short_cell e m PprzTrigInit.Source._temp(first c) ->
 prepared_inv e base input buffer c m.
Proof.
 intros e base input buffer c m M C P[CNT[TAB[V PREV]]]I T.
 unfold prepared_inv,fixed_inner_cells,consumed;rewrite M.
 repeat first[assumption|split].
Qed.
Lemma multi_prepared : forall e base input buffer c m,
 multi c=true ->protocol_core e base input buffer m ->packed_prefix(count_before c)m buffer ->
 retained_cells e m c ->short_cell e m PprzTrigInit.Source._i(pos c+3) ->short_cell e m PprzTrigInit.Source._temp(third c) ->
 short_cell e m PprzTrigInit.Source._k(k_value c) ->prepared_inv e base input buffer c m.
Proof.
 intros e base input buffer c m M C P[CNT[TAB[V PREV]]]I T K.
 unfold prepared_inv,fixed_inner_cells,consumed;rewrite M.
 repeat first[assumption|split].
Qed.
Theorem outer_chunk_preparation_total : forall Q k e base input buffer c cs m,
 In c literal_chunks ->outer_inv e base input buffer(c::cs)m ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some input ->
 (forall mf,iteration_inv e base input buffer c 0 BeforeEncode mf ->Total.total PprzTrigInit.Execution.ge Q
 (State PprzTrigInit.Source.f_pprz_trig_int_init(inner_loop c)k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init outer_body k e m).
Proof.
 intros Q k e base input buffer c cs m IN[C[P[I[CNT[TAB[V PREV]]]]]]INPUT END.
 change(packed_prefix(count_before c)m buffer)in P.
 assert(R:retained_cells e m c)by(repeat split;assumption).
 pose proof(literal_chunk_bounds c IN)as BOUNDS.
 destruct(chunk_read_values c IN)as[FIRST READS].
 assert(POS:0<=pos c<3379).
 { repeat match goal with H:_/\_ |- _=>destruct H end;unfold consumed in *;destruct(multi c);lia. }
 change(Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init
 (Ssequence(nibble_statement PprzTrigInit.Source._temp)outer_choice)k e m)).
 apply Control.sequence_total.
 eapply nibble_protocol_action with(base:=base)(input:=input)(buffer:=buffer)(prefix:=count_before c)(p:=pos c);try eassumption;try discriminate.
 - vm_compute;auto 12.
 - intros m1[C1[P1[I1[T1 O1]]]].
   rewrite FIRST in T1.
   assert(R1:retained_cells e m1 c)by(eapply retained_nibble;[exact R|left;reflexivity|exact O1]).
   apply Control.skip_sequence_total.
   eapply Control.if_pure_total with(v:=Val.of_bool(negb(multi c)))(choice:=negb(multi c)).
   + reflexivity.
   + apply choice_guard_value;assumption.
   + destruct(multi c);reflexivity.
   + destruct(multi c)eqn:M;cbn[negb].
     * change(Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init
       (Ssequence(nibble_statement PprzTrigInit.Source._k)(Ssequence input_guard
       (Ssequence(nibble_statement PprzTrigInit.Source._temp)(Ssequence input_guard
       (Ssequence k_or_statement multi_with_init)))))k e m1)).
       destruct READS as[F15[SECOND THIRD]].
       assert(P2:0<=pos c+1<3379).
       { repeat match goal with H:_/\_ |- _=>destruct H end;unfold consumed in *;rewrite M in *;lia. }
       apply Control.sequence_total.
       eapply nibble_protocol_action with(base:=base)(input:=input)(buffer:=buffer)(prefix:=count_before c)(p:=pos c+1);try eassumption;try discriminate.
       -- vm_compute;auto 12.
       -- intros m2[C2[PP2[I2[K2 O2]]]].
          rewrite SECOND in K2.
          assert(R2:retained_cells e m2 c)by(eapply retained_nibble;[exact R1|right;reflexivity|exact O2]).
          apply Control.skip_sequence_total;apply Control.sequence_total.
          eapply input_guard_total with(p:=pos c+1+1);try eassumption;try lia.
          apply Control.skip_sequence_total;apply Control.sequence_total.
          assert(P3:0<=pos c+2<3379).
          { repeat match goal with H:_/\_ |- _=>destruct H end;unfold consumed in *;rewrite M in *;lia. }
          replace(pos c+1+1)with(pos c+2)in I2 by lia.
          eapply nibble_protocol_action with(base:=base)(input:=input)(buffer:=buffer)(prefix:=count_before c)(p:=pos c+2);try eassumption;try discriminate.
          ++ vm_compute;auto 12.
          ++ intros m3[C3[P3M[I3[T3 O3]]]].
             rewrite THIRD in T3.
             assert(R3:retained_cells e m3 c)by(eapply retained_nibble;[exact R2|left;reflexivity|exact O3]).
             assert(K3:short_cell e m3 PprzTrigInit.Source._k(second c))by(apply O3;try discriminate;exact K2).
             apply Control.skip_sequence_total;apply Control.sequence_total.
             eapply input_guard_total with(p:=pos c+2+1);try eassumption.
             ** repeat match goal with H:_/\_ |- _=>destruct H end;unfold consumed in *;rewrite M in *;lia.
             ** apply Control.skip_sequence_total;apply Control.sequence_total.
                eapply k_or_action with(base:=base)(input:=input)(buffer:=buffer)(prefix:=count_before c)(c:=c);try eassumption.
                intros m4[C4[P4[K4 O4]]].
                assert(R4:retained_cells e m4 c)by(eapply retained_k_update;eauto).
                apply Control.skip_sequence_total.
                assert(IP4:prepared_inv e base input buffer c m4).
                { eapply multi_prepared;try eassumption.
                  - replace(pos c+3)with(pos c+2+1)by lia;apply O4;try discriminate;exact I3.
                  - apply O4;try discriminate;exact T3. }
                pose proof(prepared_inner_start Q k e base input buffer c m4 IP4 END)as DONE.
                unfold inner_with_init in DONE;rewrite M in DONE;exact DONE.
     * change(Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init single_with_init k e m1)).
       assert(IP:prepared_inv e base input buffer c m1)by(eapply single_prepared;eauto).
       pose proof(prepared_inner_start Q k e base input buffer c m1 IP END)as DONE.
       unfold inner_with_init in DONE;rewrite M in DONE;exact DONE.
Qed.
Print Assumptions outer_chunk_preparation_total.
