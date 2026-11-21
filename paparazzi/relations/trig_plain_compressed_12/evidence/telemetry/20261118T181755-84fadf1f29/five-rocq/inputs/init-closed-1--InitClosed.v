From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Memdata Globalenvs Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import TrigData InitProtocol InitLoop InitialMemory InitialCompressed InitBuffer ByteRepresentation PackedPrefix Total.
From PprzTrigInitSupport Require Import Control InitStart InitFinish TotalExistence.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

(** The sole parameter is the original source outer-loop control rule.  It
    must be discharged by the checked RLE body and inner-loop theorems. *)
Definition InitOuterRule:Prop:=forall Q k e base input buffer m,
 outer_inv e base input buffer literal_chunks m ->
 (forall mf,outer_inv e base input buffer [] mf ->
  Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init outer_loop k e m).

Definition InitPost(base:mem)(buffer:block)(v:val)(mf:mem):Prop:=
 v=Vint Int.zero /\
 Mem.loadbytes mf buffer 0 9651=Some(map(fun z=>Byte(Byte.repr z))expected_bytes) /\
 Mem.unchanged_on(Frame.protected base buffer)base mf.

Theorem initializer_source_total : InitOuterRule ->forall base buffer,
 Genv.init_mem PprzTrigInit.Source.prog=Some base ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 Total.total PprzTrigInit.Execution.ge(InitPost base buffer)(PprzTrigInit.Execution.entry [] base).
Proof.
 intros OUTER base buffer INIT BUFFER_SYMBOL.
 destruct compressed_symbol_info_exists as[input[INPUT_SYMBOL INPUT_VAR]].
 destruct buffer_symbol_info_exists as[bb[BUF_SYMBOL BUFFER_VAR]].
 change(Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some bb)in BUF_SYMBOL.
 rewrite BUFFER_SYMBOL in BUF_SYMBOL;injection BUF_SYMBOL as SAME;subst bb.
 assert(INPUT:Mem.valid_block base input).
 { eapply Genv.find_symbol_not_fresh;[exact INIT|exact INPUT_SYMBOL]. }
 assert(BUFFER:Mem.valid_block base buffer).
 { eapply Genv.find_symbol_not_fresh;[exact INIT|exact BUFFER_SYMBOL]. }
 assert(DISTINCT:input<>buffer)by(eapply compressed_buffer_distinct;eauto).
 change(Total.total PprzTrigInit.Execution.ge(InitPost base buffer)
   (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_init)[]Kstop base)).
 eapply init_source_entry_prefix_total with(input:=input)(buffer:=buffer).
 - exact INPUT.
 - exact BUFFER.
 - exact DISTINCT.
 - exact(compressed_literal_loads base input INIT INPUT_VAR).
 - exact(buffer_initial_prefix base buffer INIT BUFFER_VAR).
 - intros e m INV;apply(OUTER(InitPost base buffer)(Kseq init_finish_statement Kstop)e base input buffer m INV).
   intros mf FINISHED;apply skip_sequence_total.
   destruct(init_finish_total e base input buffer mf FINISHED)as[mm[PACKED[FRAME FINISH]]].
   apply(FINISH(InitPost base buffer)Kstop);apply Total.total_final.
   split;[reflexivity|];split;[apply completed_prefix_bytes;exact(proj2 PACKED)|exact FRAME].
Qed.

Theorem initializer_source_safe_termination : InitOuterRule ->forall base,
 Genv.init_mem PprzTrigInit.Source.prog=Some base ->
 safe_termination PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry [] base).
Proof.
 intros OUTER base INIT;destruct buffer_symbol_info_exists as[buffer[SYMBOL VAR]].
 pose proof(initializer_source_total OUTER base buffer INIT SYMBOL)as TOTAL.
 split;[eapply Total.total_no_error;exact TOTAL|eapply Total.total_termination;exact TOTAL].
Qed.

Theorem initializer_source_success_and_representation : InitOuterRule ->forall base buffer,
 Genv.init_mem PprzTrigInit.Source.prog=Some base ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some buffer ->
 (exists mf t,star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry [] base)t
   (Returnstate(Vint Int.zero)Kstop mf)) /\
 (forall v mf t,star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry [] base)t
   (Returnstate v Kstop mf)->InitPost base buffer v mf).
Proof.
 intros OUTER base buffer INIT SYMBOL.
 pose proof(initializer_source_total OUTER base buffer INIT SYMBOL)as TOTAL.
 split.
 - destruct(total_actual_execution _ _ _ TOTAL)as[v[mf[t[PATH[VALUE POST]]]]].
   subst v;exists mf,t;exact PATH.
 - intros v mf t PATH;exact(Total.total_result _ _ _ _ _ _ TOTAL PATH).
Qed.
