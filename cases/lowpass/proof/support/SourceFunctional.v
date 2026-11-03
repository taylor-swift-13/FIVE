From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Floats Values Memory Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import NormalCorrespondence.
From FiveCases.lowpass.proof.support Require Import ConcreteBody.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
Import ListNotations.

Fixpoint source_statement (n:nat) (s:statement): statement :=
  match n,s with O,Ssequence s _ => s | S n,Ssequence _ s => source_statement n s | _,s => s end.
Definition body_statement (n:nat) := source_statement n (fn_body lowpass_function).
Definition body_assignment (n:nat):expr :=
  match body_statement n with Sdo a => a | _ => Eval Vundef tfloat end.
Definition body_lhs (n:nat):expr :=
  match body_assignment n with Eassign a _ _ => a | _ => Eloc 1%positive Ptrofs.zero Full tfloat end.
Definition body_rhs (n:nat):expr :=
  match body_assignment n with Eassign _ a _ => a | _ => Eval Vundef tfloat end.
Definition body_return:expr :=
  match body_statement 5 with Sreturn (Some a) => a | _ => Eval Vundef tfloat end.

Lemma body_decomposition:
  fn_body lowpass_function =
  Ssequence (Sdo (body_assignment 0))
  (Ssequence (Sdo (body_assignment 1))
  (Ssequence (Sdo (body_assignment 2))
  (Ssequence (Sdo (body_assignment 3))
  (Ssequence (Sdo (body_assignment 4)) (Sreturn (Some body_return)))))).
Proof. reflexivity. Qed.
Lemma body_assignment_shape:
  forall n, (n < 5)%nat -> body_assignment n = Eassign (body_lhs n) (body_rhs n) tfloat.
Proof. intros [|[|[|[|[|n]]]]]; simpl; intros; try reflexivity; lia. Qed.
Lemma body_assignment_types:
  forall n, (n < 5)%nat -> typeof (body_lhs n) = tfloat /\ typeof (body_rhs n) = tfloat.
Proof. intros [|[|[|[|[|n]]]]]; simpl; intros; try (split; reflexivity); lia. Qed.
Lemma body_rhs_zero: body_rhs 0 = source_rhs. Proof. reflexivity. Qed.
Lemma body_rhs_one: body_rhs 1 = read_i0. Proof. reflexivity. Qed.
Lemma body_rhs_two: body_rhs 2 = read_value. Proof. reflexivity. Qed.
Lemma body_rhs_three: body_rhs 3 = read_o0. Proof. reflexivity. Qed.
Lemma body_rhs_four: body_rhs 4 = body_return. Proof. reflexivity. Qed.

Lemma flat_float_assignment:
  forall ge e m l r b ofs v m',
  typeof l = tfloat -> typeof r = tfloat ->
  pure_lval ge e m l = Some (b,ofs,Full) -> pure_rval ge e m r = Some (Vsingle v) ->
  Mem.storev Mfloat32 m (Vptr b ofs) (Vsingle v) = Some m' ->
  flat_eval ge e m (Eassign l r tfloat) = Some (Vsingle v,m').
Proof.
  intros ge e m l r b ofs v m' TL TR LEFT RIGHT STORE.
  unfold flat_eval. rewrite TL,TR,LEFT,RIGHT. rewrite dec_eq_true.
  assert (CAST: sem_cast (Vsingle v) tfloat tfloat m = Some (Vsingle v)) by reflexivity.
  rewrite CAST.
  assert (ASSIGN: assign_loc ge tfloat m b ofs Full (Vsingle v) Events.E0 m' (Vsingle v)).
  { eapply assign_loc_value; [reflexivity|reflexivity|exact STORE]. }
  rewrite (do_assign_loc_complete ge quiet_world tfloat m b ofs Full (Vsingle v) quiet_world Events.E0 m' (Vsingle v) ASSIGN (Determinism.possible_trace_nil _)).
  reflexivity.
Qed.

Lemma original_assignment_eval:
  forall e m n b ofs v m', (n < 5)%nat ->
  pure_lval lowpass_ge e m (body_lhs n) = Some (b,ofs,Full) ->
  pure_rval lowpass_ge e m (body_rhs n) = Some (Vsingle v) ->
  Mem.storev Mfloat32 m (Vptr b ofs) (Vsingle v) = Some m' ->
  flat_eval lowpass_ge e m (body_assignment n) = Some (Vsingle v,m').
Proof.
  intros e m n b ofs v m' LT LEFT RIGHT STORE.
  rewrite (body_assignment_shape n LT).
  destruct (body_assignment_types n LT) as [TL TR]. eapply flat_float_assignment; eauto.
Qed.

(** A checkable memory representation certificate for the ORIGINAL five stores:
    the temporary out store and the four source object stores in source order.
    These assumptions occur only in this functional-property theorem. *)
Record source_body_certificate (e:env) (s:filter_state) (input:int)
  (bout b:block) (m0 m1 m2 m3 m4 m5:mem): Prop := {
  body_initial_reads: source_reads e m0 s input;
  body_lhs0: pure_lval lowpass_ge e m0 (body_lhs 0) = Some (bout,Ptrofs.zero,Full);
  body_store0: Mem.storev Mfloat32 m0 (Vptr bout Ptrofs.zero) (Vsingle (Float32.of_bits (calc_out s input))) = Some m1;
  body_lhs1: pure_lval lowpass_ge e m1 (body_lhs 1) = Some (b,Ptrofs.repr 20,Full);
  body_read1: pure_rval lowpass_ge e m1 read_i0 = Some (Vsingle (Float32.of_bits (i0 s)));
  body_store1: Mem.storev Mfloat32 m1 (Vptr b (Ptrofs.repr 20)) (Vsingle (Float32.of_bits (i0 s))) = Some m2;
  body_lhs2: pure_lval lowpass_ge e m2 (body_lhs 2) = Some (b,Ptrofs.repr 16,Full);
  body_read2: pure_rval lowpass_ge e m2 read_value = Some (Vsingle (Float32.of_bits input));
  body_store2: Mem.storev Mfloat32 m2 (Vptr b (Ptrofs.repr 16)) (Vsingle (Float32.of_bits input)) = Some m3;
  body_lhs3: pure_lval lowpass_ge e m3 (body_lhs 3) = Some (b,Ptrofs.repr 28,Full);
  body_read3: pure_rval lowpass_ge e m3 read_o0 = Some (Vsingle (Float32.of_bits (o0 s)));
  body_store3: Mem.storev Mfloat32 m3 (Vptr b (Ptrofs.repr 28)) (Vsingle (Float32.of_bits (o0 s))) = Some m4;
  body_lhs4: pure_lval lowpass_ge e m4 (body_lhs 4) = Some (b,Ptrofs.repr 24,Full);
  body_read4: pure_rval lowpass_ge e m4 body_return = Some (Vsingle (Float32.of_bits (calc_out s input)));
  body_store4: Mem.storev Mfloat32 m4 (Vptr b (Ptrofs.repr 24)) (Vsingle (Float32.of_bits (calc_out s input))) = Some m5;
  body_return_read: pure_rval lowpass_ge e m5 body_return = Some (Vsingle (Float32.of_bits (calc_out s input)))
}.

Theorem original_body_is_exact_filter_update:
  forall e s input bout b m0 m1 m2 m3 m4 m5,
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  stmt_eval lowpass_ge e tfloat (fn_body lowpass_function) m0 =
  Some (Nreturn (Vsingle (Float32.of_bits (calc_out s input))),m5).
Proof.
  intros e s input bout b m0 m1 m2 m3 m4 m5 CERT.
  destruct CERT as [READS L0 S0 L1 R1 S1 L2 R2 S2 L3 R3 S3 L4 R4 S4 R5].
  assert (A0: flat_eval lowpass_ge e m0 (body_assignment 0) =
    Some (Vsingle (Float32.of_bits (calc_out s input)),m1)).
  { eapply original_assignment_eval; [lia|exact L0| |exact S0]. rewrite body_rhs_zero.
    apply original_rhs_is_exact_filter_recurrence; exact READS. }
  assert (A1: flat_eval lowpass_ge e m1 (body_assignment 1) =
    Some (Vsingle (Float32.of_bits (i0 s)),m2)).
  { eapply original_assignment_eval; [lia|exact L1| |exact S1]. rewrite body_rhs_one; exact R1. }
  assert (A2: flat_eval lowpass_ge e m2 (body_assignment 2) =
    Some (Vsingle (Float32.of_bits input),m3)).
  { eapply original_assignment_eval; [lia|exact L2| |exact S2]. rewrite body_rhs_two; exact R2. }
  assert (A3: flat_eval lowpass_ge e m3 (body_assignment 3) =
    Some (Vsingle (Float32.of_bits (o0 s)),m4)).
  { eapply original_assignment_eval; [lia|exact L3| |exact S3]. rewrite body_rhs_three; exact R3. }
  assert (A4: flat_eval lowpass_ge e m4 (body_assignment 4) =
    Some (Vsingle (Float32.of_bits (calc_out s input)),m5)).
  { eapply original_assignment_eval; [lia|exact L4| |exact S4]. rewrite body_rhs_four; exact R4. }
  rewrite body_decomposition. cbn [stmt_eval]. rewrite A0; cbn [stmt_eval].
  rewrite A1; cbn [stmt_eval]. rewrite A2; cbn [stmt_eval].
  rewrite A3; cbn [stmt_eval]. rewrite A4; cbn [stmt_eval].
  rewrite R5. reflexivity.
Qed.

(** Ordinary C call boundary: alloc_variables and bind_parameters are the
    actual CompCert memory operations, and final free_list is observed. *)
Theorem source_entry_denotation:
  forall filter input m e ma m0 s bout b m1 m2 m3 m4 m5 mf,
  alloc_variables lowpass_ge empty_env m
    (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function)
    [filter; Vsingle (Float32.of_bits input)] m0 ->
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  Mem.free_list m5 (blocks_of_env lowpass_ge e) = Some mf ->
  state_eval lowpass_ge (lowpass_start filter (Vsingle (Float32.of_bits input)) m) =
  Some (Vsingle (Float32.of_bits (calc_out s input)),mf).
Proof.
  intros filter input m e ma m0 s bout b m1 m2 m3 m4 m5 mf ALLOC BIND CERT FREE.
  unfold lowpass_start; cbn [state_eval].
  rewrite (do_alloc_variables_complete _ _ _ _ _ _ ALLOC).
  rewrite (sem_bind_parameters_complete _ quiet_world _ _ _ _ _ BIND).
  change (match stmt_eval lowpass_ge e tfloat (fn_body lowpass_function) m0 with
          | Some (out,m') => cont_eval lowpass_ge e tfloat Kstop out m' | None => None end =
          Some (Vsingle (Float32.of_bits (calc_out s input)),mf)).
  rewrite (original_body_is_exact_filter_update _ _ _ _ _ _ _ _ _ _ _ CERT).
  cbn [cont_eval]. rewrite FREE; reflexivity.
Qed.

Theorem all_order_source_entry_return:
  forall filter input m e ma m0 s bout b m1 m2 m3 m4 m5 mf t v mout,
  alloc_variables lowpass_ge empty_env m
    (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function)
    [filter; Vsingle (Float32.of_bits input)] m0 ->
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  Mem.free_list m5 (blocks_of_env lowpass_ge e) = Some mf ->
  star Csem.step lowpass_ge (lowpass_start filter (Vsingle (Float32.of_bits input)) m)
    t (Returnstate v Kstop mout) ->
  v = Vsingle (Float32.of_bits (calc_out s input)) /\ mout = mf.
Proof.
  intros filter input m e ma m0 s bout b m1 m2 m3 m4 m5 mf t v mout A B C F PATH.
  pose proof (source_entry_denotation filter input m e ma m0 s bout b m1 m2 m3 m4 m5 mf A B C F) as EVAL.
  pose proof (lowpass_all_order_normal_correspondence filter (Vsingle (Float32.of_bits input)) m t v mout PATH) as NORMAL.
  rewrite EVAL in NORMAL; inversion NORMAL; auto.
Qed.

Theorem certificate_has_four_ordered_object_stores:
  forall e s input bout b m0 m1 m2 m3 m4 m5,
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  HarnessMemory.four_stores m1 b (i0 s) input (o0 s) (calc_out s input) m5.
Proof.
  intros e s input bout b m0 m1 m2 m3 m4 m5 CERT.
  destruct CERT as [READS L0 S0 L1 R1 S1 L2 R2 S2 L3 R3 S3 L4 R4 S4 R5].
  exists m2,m3,m4; repeat split; assumption.
Qed.

Theorem original_body_has_exact_next_words:
  forall e s input bout b m0 m1 m2 m3 m4 m5,
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  HarnessMemory.initialized_state m1 b s ->
  HarnessMemory.initialized_state m5 b (next s input).
Proof.
  intros. eapply HarnessMemory.four_stores_next_words; eauto using certificate_has_four_ordered_object_stores.
Qed.

Theorem original_body_has_exact_slot_bytes:
  forall e s input bout b m0 m1 m2 m3 m4 m5,
  source_body_certificate e s input bout b m0 m1 m2 m3 m4 m5 ->
  Mem.loadbytes m5 b 20 4 = Some (HarnessMemory.word_bytes (i0 s)) /\
  Mem.loadbytes m5 b 16 4 = Some (HarnessMemory.word_bytes input) /\
  Mem.loadbytes m5 b 28 4 = Some (HarnessMemory.word_bytes (o0 s)) /\
  Mem.loadbytes m5 b 24 4 = Some (HarnessMemory.word_bytes (calc_out s input)).
Proof.
  intros. eapply HarnessMemory.four_stores_exact_slot_bytes; eauto using certificate_has_four_ordered_object_stores.
Qed.
