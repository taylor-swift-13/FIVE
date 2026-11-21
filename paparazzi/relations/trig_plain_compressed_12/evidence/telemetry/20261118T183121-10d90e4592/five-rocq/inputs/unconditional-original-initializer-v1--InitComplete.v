From Stdlib Require Import List.
From compcert Require Import Coqlib Integers Values Memory Globalenvs Ctypes Csem.
Require PprzTrigInit.Source PprzTrigInit.Execution PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import InitLoop InitProtocol InitIteration InitInner InitOuterLoop.
From PprzTrigInitSupport Require Import InitClosed.
From PprzTrigRelation Require Import Spec.
Import ListNotations.
Theorem original_inner_body : InitInner.SourceBodyRule.
Proof. exact InitIteration.iteration_body_total. Qed.
Theorem original_inner_loop : InitOuterLoop.SourceInnerRule.
Proof. exact(InitInner.inner_source_rule_from_body original_inner_body). Qed.
Theorem original_outer_loop : InitClosed.InitOuterRule.
Proof.
 intros Q k e base input buffer m BUFFER INPUT INV END.
 eapply InitOuterLoop.outer_source_loop_total;[exact original_inner_loop|exact BUFFER|exact INPUT| |exact INV|exact END].
 exists [];reflexivity.
Qed.
Theorem initializer_total_proved : Spec.initializer_total.
Proof. exact(InitClosed.initializer_source_safe_termination original_outer_loop). Qed.
Theorem initializer_representation_proved : Spec.initializer_success_and_representation.
Proof.
 intros ml b INIT SYMBOL.
 destruct(InitClosed.initializer_source_success_and_representation original_outer_loop ml b INIT SYMBOL)as[EX ALL].
 split.
 - destruct EX as[mf[t PATH]];exists mf,t;exact PATH.
 - intros v mf[t PATH];exact(ALL v mf t PATH).
Qed.
Lemma initialized_packed : forall ml ml' b,
 Spec.initial_low ml ->Spec.buffer_symbol b ->Spec.init_returns ml(Vint Int.zero)ml' ->Spec.packed_state b ml'.
Proof. intros ml ml' b INIT SYMBOL PATH;exact(proj1(proj2(proj2(initializer_representation_proved ml b INIT SYMBOL)(Vint Int.zero)ml' PATH))). Qed.
Lemma low_buffer_symbol : forall b,Spec.buffer_symbol b ->
 Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12=Some b.
Proof. intros b H;exact H. Qed.
Print Assumptions original_outer_loop.
Print Assumptions initializer_total_proved.
Print Assumptions initializer_representation_proved.
