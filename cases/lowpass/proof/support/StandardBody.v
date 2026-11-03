From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Floats Values Memory Ctypes Csyntax Csyntaxdefs Csem.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import NormalCorrespondence.
From FiveCases.lowpass.proof.support Require Import ConcreteBody.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
From FiveCases.lowpass.proof.support Require Import SourceFunctional.
Open Scope Z_scope.

Lemma load_other_block : forall chunk m m' stored ofs v read read_ofs,
  Mem.store Mfloat32 m stored ofs v = Some m' -> read <> stored ->
  Mem.load chunk m' read read_ofs = Mem.load chunk m read read_ofs.
Proof. intros; eapply Mem.load_store_other; eauto. Qed.

Theorem actual_memory_gives_source_reads : forall e m bp bv b s input,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  PTree.get Source._value e = Some (bv,tfloat) ->
  Mem.load Mptr m bp 0 = Some (Vptr b Ptrofs.zero) ->
  Mem.load Mfloat32 m bv 0 = Some (Vsingle (Float32.of_bits input)) ->
  HarnessMemory.initialized_state m b s -> source_reads e m s input.
Proof.
  intros e m bp bv b s input EF EV PTR VALUE INIT.
  unfold HarnessMemory.initialized_state in INIT.
  destruct INIT as [A0[A1[B0[B1[I0[I1[O0 O1]]]]]]].
  constructor.
  - eapply read_object_b0; eauto; exact B0.
  - eapply read_local_value; eauto.
  - eapply read_object_b1; eauto; exact B1.
  - eapply read_object_i0; eauto; exact I0.
  - eapply read_object_i1; eauto; exact I1.
  - eapply read_object_a0; eauto; exact A0.
  - eapply read_object_o0; eauto; exact O0.
  - eapply read_object_a1; eauto; exact A1.
  - eapply read_object_o1; eauto; exact O1.
Qed.

(** Verification preconditions on an initialized struct and separate local
    variables.  The five store equations describe the standard memory writes;
    no computed-result or intermediate-read claim is assumed. *)
Theorem standard_memory_constructs_body_certificate :
  forall e s input bp bv bo b m0 m1 m2 m3 m4 m5,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  PTree.get Source._value e = Some (bv,tfloat) ->
  PTree.get Source._out e = Some (bo,tfloat) ->
  bp <> b -> bv <> b -> bo <> b -> bp <> bo -> bv <> bo ->
  Mem.load Mptr m0 bp 0 = Some (Vptr b Ptrofs.zero) ->
  Mem.load Mfloat32 m0 bv 0 = Some (Vsingle (Float32.of_bits input)) ->
  HarnessMemory.initialized_state m0 b s ->
  Mem.store Mfloat32 m0 bo 0 (Vsingle (Float32.of_bits (calc_out s input))) = Some m1 ->
  Mem.store Mfloat32 m1 b 20 (Vsingle (Float32.of_bits (i0 s))) = Some m2 ->
  Mem.store Mfloat32 m2 b 16 (Vsingle (Float32.of_bits input)) = Some m3 ->
  Mem.store Mfloat32 m3 b 28 (Vsingle (Float32.of_bits (o0 s))) = Some m4 ->
  Mem.store Mfloat32 m4 b 24 (Vsingle (Float32.of_bits (calc_out s input))) = Some m5 ->
  source_body_certificate e s input bo b m0 m1 m2 m3 m4 m5.
Proof.
  intros e s input bp bv bo b m0 m1 m2 m3 m4 m5
    EF EV EO PB VB OB PO VO PTR VALUE INIT S0 S1 S2 S3 S4.
  assert (PTR1: Mem.load Mptr m1 bp 0 = Some (Vptr b Ptrofs.zero)).
  { erewrite load_other_block by (exact S0 || congruence); exact PTR. }
  assert (PTR2: Mem.load Mptr m2 bp 0 = Some (Vptr b Ptrofs.zero)).
  { erewrite load_other_block by (exact S1 || congruence); exact PTR1. }
  assert (PTR3: Mem.load Mptr m3 bp 0 = Some (Vptr b Ptrofs.zero)).
  { erewrite load_other_block by (exact S2 || congruence); exact PTR2. }
  assert (PTR4: Mem.load Mptr m4 bp 0 = Some (Vptr b Ptrofs.zero)).
  { erewrite load_other_block by (exact S3 || congruence); exact PTR3. }
  assert (VALUE1: Mem.load Mfloat32 m1 bv 0 = Some (Vsingle (Float32.of_bits input))).
  { erewrite load_other_block by (exact S0 || congruence); exact VALUE. }
  assert (VALUE2: Mem.load Mfloat32 m2 bv 0 = Some (Vsingle (Float32.of_bits input))).
  { erewrite load_other_block by (exact S1 || congruence); exact VALUE1. }
  pose proof INIT as INIT0. unfold HarnessMemory.initialized_state in INIT0.
  destruct INIT0 as [A0[A1[B0[B1[I0[I1[O0 O1]]]]]]].
  assert (I0_1: Mem.load Mfloat32 m1 b 16 = Some (Vsingle (Float32.of_bits (i0 s)))).
  { erewrite load_other_block by (exact S0 || congruence); exact I0. }
  assert (O0_3: Mem.load Mfloat32 m3 b 24 = Some (Vsingle (Float32.of_bits (o0 s)))).
  { erewrite HarnessMemory.load_float_other by (exact S2 || lia).
    erewrite HarnessMemory.load_float_other by (exact S1 || lia).
    erewrite load_other_block by (exact S0 || congruence); exact O0. }
  assert (OUT1: Mem.load Mfloat32 m1 bo 0 = Some (Vsingle (Float32.of_bits (calc_out s input)))).
  { erewrite Mem.load_store_same by exact S0; reflexivity. }
  assert (OUT4: Mem.load Mfloat32 m4 bo 0 = Some (Vsingle (Float32.of_bits (calc_out s input)))).
  { erewrite load_other_block by (exact S3 || congruence).
    erewrite load_other_block by (exact S2 || congruence).
    erewrite load_other_block by (exact S1 || congruence); exact OUT1. }
  assert (OUT5: Mem.load Mfloat32 m5 bo 0 = Some (Vsingle (Float32.of_bits (calc_out s input)))).
  { erewrite load_other_block by (exact S4 || congruence); exact OUT4. }
  constructor.
  - eapply actual_memory_gives_source_reads; eauto.
  - change (pure_lval lowpass_ge e m0 (Evar Source._out tfloat) = Some (bo,Ptrofs.zero,Full)).
    apply lvalue_local_out; auto.
  - exact S0.
  - change (pure_lval lowpass_ge e m1 (object_lvalue read_i1) = Some (b,Ptrofs.repr 20,Full)).
    eapply lvalue_object_i1; eauto.
  - eapply read_object_i0; eauto.
  - exact S1.
  - change (pure_lval lowpass_ge e m2 (object_lvalue read_i0) = Some (b,Ptrofs.repr 16,Full)).
    eapply lvalue_object_i0; eauto.
  - eapply read_local_value; eauto.
  - exact S2.
  - change (pure_lval lowpass_ge e m3 (object_lvalue read_o1) = Some (b,Ptrofs.repr 28,Full)).
    eapply lvalue_object_o1; eauto.
  - eapply read_object_o0; eauto.
  - exact S3.
  - change (pure_lval lowpass_ge e m4 (object_lvalue read_o0) = Some (b,Ptrofs.repr 24,Full)).
    eapply lvalue_object_o0; eauto.
  - change (pure_rval lowpass_ge e m4 read_out = Some (Vsingle (Float32.of_bits (calc_out s input)))).
    eapply read_local_out; eauto.
  - exact S4.
  - change (pure_rval lowpass_ge e m5 read_out = Some (Vsingle (Float32.of_bits (calc_out s input)))).
    eapply read_local_out; eauto.
Qed.

Print Assumptions standard_memory_constructs_body_certificate.

Lemma store_preserves_access : forall m m' b ofs v chunk read read_ofs p,
  Mem.store Mfloat32 m b ofs v = Some m' ->
  Mem.valid_access m chunk read read_ofs p ->
  Mem.valid_access m' chunk read read_ofs p.
Proof. intros; eapply Mem.store_valid_access_1; eauto. Qed.

Theorem five_writable_stores_exist : forall m0 bo b s input,
  Mem.valid_access m0 Mfloat32 bo 0 Writable ->
  Mem.valid_access m0 Mfloat32 b 20 Writable ->
  Mem.valid_access m0 Mfloat32 b 16 Writable ->
  Mem.valid_access m0 Mfloat32 b 28 Writable ->
  Mem.valid_access m0 Mfloat32 b 24 Writable ->
  exists m1 m2 m3 m4 m5,
  Mem.store Mfloat32 m0 bo 0 (Vsingle (Float32.of_bits (calc_out s input))) = Some m1 /\
  Mem.store Mfloat32 m1 b 20 (Vsingle (Float32.of_bits (i0 s))) = Some m2 /\
  Mem.store Mfloat32 m2 b 16 (Vsingle (Float32.of_bits input)) = Some m3 /\
  Mem.store Mfloat32 m3 b 28 (Vsingle (Float32.of_bits (o0 s))) = Some m4 /\
  Mem.store Mfloat32 m4 b 24 (Vsingle (Float32.of_bits (calc_out s input))) = Some m5.
Proof.
  intros m0 bo b s input W0 W1 W2 W3 W4.
  destruct (Mem.valid_access_store m0 Mfloat32 bo 0
    (Vsingle (Float32.of_bits (calc_out s input))) W0) as [m1 S0].
  assert (W1': Mem.valid_access m1 Mfloat32 b 20 Writable)
    by (eapply store_preserves_access; eauto).
  destruct (Mem.valid_access_store m1 Mfloat32 b 20
    (Vsingle (Float32.of_bits (i0 s))) W1') as [m2 S1].
  assert (W2': Mem.valid_access m2 Mfloat32 b 16 Writable).
  { eapply store_preserves_access; [exact S1|]. eapply store_preserves_access; eauto. }
  destruct (Mem.valid_access_store m2 Mfloat32 b 16
    (Vsingle (Float32.of_bits input)) W2') as [m3 S2].
  assert (W3': Mem.valid_access m3 Mfloat32 b 28 Writable).
  { eapply store_preserves_access; [exact S2|]. eapply store_preserves_access; [exact S1|].
    eapply store_preserves_access; eauto. }
  destruct (Mem.valid_access_store m3 Mfloat32 b 28
    (Vsingle (Float32.of_bits (o0 s))) W3') as [m4 S3].
  assert (W4': Mem.valid_access m4 Mfloat32 b 24 Writable).
  { eapply store_preserves_access; [exact S3|]. eapply store_preserves_access; [exact S2|].
    eapply store_preserves_access; [exact S1|]. eapply store_preserves_access; eauto. }
  destruct (Mem.valid_access_store m4 Mfloat32 b 24
    (Vsingle (Float32.of_bits (calc_out s input))) W4') as [m5 S4].
  exists m1,m2,m3,m4,m5; repeat split; assumption.
Qed.

Theorem writable_body_has_certificate : forall e s input bp bv bo b m0,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  PTree.get Source._value e = Some (bv,tfloat) ->
  PTree.get Source._out e = Some (bo,tfloat) ->
  bp <> b -> bv <> b -> bo <> b -> bp <> bo -> bv <> bo ->
  Mem.load Mptr m0 bp 0 = Some (Vptr b Ptrofs.zero) ->
  Mem.load Mfloat32 m0 bv 0 = Some (Vsingle (Float32.of_bits input)) ->
  HarnessMemory.initialized_state m0 b s ->
  Mem.valid_access m0 Mfloat32 bo 0 Writable ->
  Mem.valid_access m0 Mfloat32 b 20 Writable ->
  Mem.valid_access m0 Mfloat32 b 16 Writable ->
  Mem.valid_access m0 Mfloat32 b 28 Writable ->
  Mem.valid_access m0 Mfloat32 b 24 Writable ->
  exists m1 m2 m3 m4 m5,
    source_body_certificate e s input bo b m0 m1 m2 m3 m4 m5.
Proof.
  intros e s input bp bv bo b m0 EF EV EO PB VB OB PO VO PTR VALUE INIT W0 W1 W2 W3 W4.
  destruct (five_writable_stores_exist m0 bo b s input W0 W1 W2 W3 W4)
    as [m1[m2[m3[m4[m5[S0[S1[S2[S3 S4]]]]]]]]].
  exists m1,m2,m3,m4,m5; eapply standard_memory_constructs_body_certificate; eauto.
Qed.

Print Assumptions writable_body_has_certificate.
