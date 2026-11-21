From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib AST Values Memory.
Import ListNotations.
Definition region_block (r:block*Z*Z) := let '(b,_,_):=r in b.
Definition region_freeable (m:mem)(r:block*Z*Z) :=
  let '(b,lo,hi):=r in Mem.range_perm m b lo hi Cur Freeable.
Definition region_fresh (initial:mem)(r:block*Z*Z) :=
  ~Mem.valid_block initial (region_block r).

Theorem fresh_free_list : forall initial regions m,
  NoDup(map region_block regions) ->
  Forall(region_freeable m) regions ->
  Forall(region_fresh initial) regions ->
  exists mf, Mem.free_list m regions=Some mf /\
    Mem.unchanged_on(fun b _=>Mem.valid_block initial b)m mf.
Proof.
  intros initial regions;induction regions as[|[[b lo]hi]rest IH];
    intros m DISTINCT PERMS FRESH.
  - exists m;split;[reflexivity|apply Mem.unchanged_on_refl].
  - inversion DISTINCT as[|head blocks NOTIN ND];subst.
    inversion PERMS as[|r rs FREEABLE RP];subst.
    inversion FRESH as[|r rs NEW RF];subst.
    cbn [region_freeable] in FREEABLE.
    destruct(Mem.range_perm_free m b lo hi FREEABLE)as[m1 FREE].
    assert (OTHER:forall r,In r rest ->region_block r<>b).
    { intros r IN EQ;apply NOTIN;apply in_map_iff;exists r;split;auto. }
    assert (RP1:Forall(region_freeable m1)rest).
    { apply Forall_forall;intros [[b' lo']hi'] IN.
      apply Forall_forall with(x:=(b',lo',hi'))in RP;[|exact IN].
      cbn [region_freeable] in RP|-*;intros ofs RANGE.
      eapply Mem.perm_free_1;[exact FREE| |apply RP;exact RANGE].
      left;apply(OTHER (b',lo',hi'));exact IN. }
    destruct(IH m1 ND RP1 RF)as[mf[ALL FRAME]].
    exists mf;split.
    + cbn [Mem.free_list];rewrite FREE;exact ALL.
    + eapply Mem.unchanged_on_trans;[|exact FRAME].
      eapply Mem.free_unchanged_on;[exact FREE|].
      intros ofs RANGE OLD;apply NEW;exact OLD.
Qed.
