From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Globalenvs Ctypes Csem.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import InitState PackedPrefix.
From PprzTrigInitSupport Require Import EncoderMemory FreeList.
Import ListNotations.

Lemma encoder_parameter_fresh : forall m value previous count tb tofs e mp id b ty,
  encoder_setup m value previous count tb tofs e mp ->
  e!id=Some(b,ty) -> ~Mem.valid_block m b.
Proof.
  intros m value previous count tb tofs e mp id b ty SETUP LOOKUP.
  destruct SETUP as[ENTRY EV EP EC ET SHADOW ND REG FRESH FRAME].
  assert(IN:In (b,0,sizeof(Csem.globalenv Source.prog)ty)
    (blocks_of_env(Csem.globalenv Source.prog)e)).
  { unfold blocks_of_env;apply in_map_iff.
    exists(id,(b,ty));split;[reflexivity|apply PTree.elements_complete;exact LOOKUP]. }
  apply Forall_forall with(x:=(b,0,sizeof(Csem.globalenv Source.prog)ty))in FRESH;[|exact IN].
  exact FRESH.
Qed.

Lemma encoder_cell_buffer_store : forall m value previous count tb tofs e mp id z bb ch ofs v mf,
  encoder_setup m value previous count tb tofs e mp ->
  short_cell e mp id z -> Mem.valid_block m bb ->
  Mem.store ch mp bb ofs v=Some mf ->short_cell e mf id z.
Proof.
  intros m value previous count tb tofs e mp id z bb ch ofs v mf SETUP CELL OLD STORE.
  eapply short_cell_store_other;[exact CELL|exact STORE|].
  intros bl ENV EQ;subst bl.
  eapply(encoder_parameter_fresh _ _ _ _ _ _ _ _ _ _ _ SETUP ENV);exact OLD.
Qed.

Lemma freeable_regions_store : forall regions m ch b ofs v mf,
  Forall(region_freeable m)regions ->Mem.store ch m b ofs v=Some mf ->
  Forall(region_freeable mf)regions.
Proof.
  intros regions m ch b ofs v mf REG STORE.
  apply Forall_forall;intros [[br lo]hi] IN.
  apply Forall_forall with(x:=(br,lo,hi))in REG;[|exact IN].
  cbn [region_freeable]in REG|-*;intros i RANGE.
  eapply Mem.perm_store_1;[exact STORE|apply REG;exact RANGE].
Qed.

Lemma packed_prefix_old_frame : forall initial before after cnt bb,
  Mem.valid_block initial bb ->
  Mem.unchanged_on(fun b _=>Mem.valid_block initial b)before after ->
  packed_prefix cnt before bb ->packed_prefix cnt after bb.
Proof.
  intros initial before after cnt bb OLD FRAME [PERMS VIEW];split.
  - intros i RANGE;eapply Mem.perm_unchanged_on;[exact FRAME|exact OLD|apply PERMS;exact RANGE].
  - intros i RANGE;eapply Mem.load_unchanged_on;[exact FRAME| |apply VIEW;exact RANGE].
    intros;exact OLD.
Qed.
