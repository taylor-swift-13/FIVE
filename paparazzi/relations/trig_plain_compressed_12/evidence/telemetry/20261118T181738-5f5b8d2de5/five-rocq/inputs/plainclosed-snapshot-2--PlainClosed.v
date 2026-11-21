From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Integers Values Memory Csem Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigPlain.Execution.
From PprzTrigRelationSupport Require Import TrigData InitialMemory PlainBody PlainEntry Total.
From PprzTrigRelation Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Definition literal_lookup(n:Z):Int.int := Int.repr(nth(Z.to_nat n)ordinary_values 0).
Definition literal_result(a:Int.int):Int.int := table_result literal_lookup(folded a).
Theorem plain_total_initialized : forall mp a,
 Spec.initial_plain mp -> Spec.normalized_angle a ->
 Total.total PprzTrigPlain.Execution.ge
  (fun v mf=>v=Vint(literal_result a) /\ Spec.existing_frame mp mf)
  (PprzTrigPlain.Execution.entry[Vint a]mp).
Proof.
 intros mp a INIT RANGE.
 destruct plain_symbol_info_exists as[table[SYM INFO]].
 unfold PprzTrigPlain.Execution.entry.
 change(Total.total PprzTrigPlain.Execution.ge
  (fun v mf=>v=Vint(table_result literal_lookup(folded a)) /\
    Mem.unchanged_on(old_blocks mp)mp mf)
  (Callstate(Ctypes.Internal fun_sin)[Vint a]Kstop mp)).
 apply plain_entry_total with(table:=table);auto.
 intros n NB;unfold literal_lookup;apply plain_literal_loads;auto.
Qed.
Theorem plain_sine_total_normalized_proved : Spec.plain_sine_total_normalized.
Proof.
 intros mp a INIT RANGE. pose proof(plain_total_initialized _ _ INIT RANGE)as T.
 split;[apply Total.total_no_error|apply Total.total_termination];exact T.
Qed.
Theorem plain_returns_initialized : forall mp a,
 Spec.initial_plain mp -> Spec.normalized_angle a ->
 exists mf,Spec.Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry[Vint a]mp(Vint(literal_result a))mf.
Proof.
 intros mp a INIT RANGE.
 destruct(total_exists_return _ _ _ (plain_total_initialized _ _ INIT RANGE))as[v[mf[t[PATH[VALUE FRAME]]]]].
 subst v;exists mf,t;exact PATH.
Qed.
Theorem plain_normal_returns_value_and_frame : forall mp a v mf,
 Spec.initial_plain mp -> Spec.normalized_angle a ->
 Spec.Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry[Vint a]mp v mf ->
 v=Vint(literal_result a) /\ Spec.existing_frame mp mf.
Proof.
 intros mp a v mf INIT RANGE[t PATH].
 eapply Total.total_result;[apply plain_total_initialized;eauto|exact PATH].
Qed.
Print Assumptions plain_sine_total_normalized_proved.
Print Assumptions plain_returns_initialized.
Print Assumptions plain_normal_returns_value_and_frame.
