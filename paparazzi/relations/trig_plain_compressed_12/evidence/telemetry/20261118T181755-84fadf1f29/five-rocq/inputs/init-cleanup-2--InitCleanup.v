From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Ctypes Ctypesdefs Csyntax Csem Globalenvs.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import InitProtocol PackedPrefix.
From PprzTrigInitSupport Require Import FreeList EncoderTransport.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Definition binding_block(x:ident*(block*type)):block:=let '(_, (b,_)):=x in b.

Lemma injective_short_bindings_distinct : forall e (bindings:list(ident*(block*type))),
  list_norepet(map fst bindings) ->
  (forall id b ty,In(id,(b,ty))bindings->e!id=Some(b,ty) /\ty=tshort) ->
  (forall id1 id2 b1 b2,e!id1=Some(b1,tshort)->e!id2=Some(b2,tshort)->id1<>id2->b1<>b2) ->
  NoDup(map binding_block bindings).
Proof.
  intros e bindings;induction bindings as[|[id[b ty]]rest IH];intros KEYS LOOKS INJECT.
  - constructor.
  - inversion KEYS as[|key keys NOTIN REST];subst.
    destruct(LOOKS id b ty(or_introl eq_refl))as[LOOK TY];subst ty.
    constructor.
    + intro IN;apply in_map_iff in IN;destruct IN as[[id'[b' ty']][EQ IN]].
      cbn[binding_block]in EQ;subst b'.
      destruct(LOOKS id' b ty'(or_intror IN))as[LOOK' TY'];subst ty'.
      assert(NE:id<>id').
      { intro SAME;subst id';apply NOTIN;apply in_map_iff;exists(id,(b,tshort));split;auto. }
      exact(INJECT id id' b b LOOK LOOK' NE eq_refl).
    + apply IH;[exact REST| |exact INJECT].
      intros id' b' ty' IN;apply LOOKS;right;exact IN.
Qed.

Lemma init_regions_distinct : forall e base input buffer,
  init_shape e base input buffer ->
  NoDup(map region_block(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e)).
Proof.
  intros e base input buffer SHAPE.
  change(NoDup(map region_block(map(block_of_binding(Csem.globalenv PprzTrigInit.Source.prog))(PTree.elements e)))).
  rewrite map_map.
  change(NoDup(map binding_block(PTree.elements e))).
  apply injective_short_bindings_distinct.
  - apply PTree.elements_keys_norepet.
  - intros id b ty IN;pose proof(PTree.elements_complete _ _ _ IN)as LOOK.
    split;[exact LOOK|exact(proj2(sh_domain _ _ _ _ SHAPE id b ty LOOK))].
  - exact(sh_injective _ _ _ _ SHAPE).
Qed.

Lemma init_regions_freeable : forall e base input buffer m,
  protocol_core e base input buffer m ->
  Forall(region_freeable m)(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e).
Proof.
  intros e base input buffer m CORE;apply Forall_forall;intros r IN.
  apply in_map_iff in IN;destruct IN as[[id[b ty]][EQ IN]].
  pose proof(PTree.elements_complete _ _ _ IN)as LOOK.
  pose proof(proj2(sh_domain _ _ _ _ (pc_shape _ _ _ _ _ CORE)id b ty LOOK))as TY;subst ty.
  subst r;change(Mem.range_perm m b 0 2 Cur Freeable).
  exact(pc_freeable _ _ _ _ _ CORE id b LOOK).
Qed.

Lemma init_regions_fresh : forall e base input buffer,
  init_shape e base input buffer ->
  Forall(region_fresh base)(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e).
Proof.
  intros e base input buffer SHAPE;apply Forall_forall;intros r IN.
  apply in_map_iff in IN;destruct IN as[[id[b ty]][EQ IN]].
  pose proof(PTree.elements_complete _ _ _ IN)as LOOK.
  pose proof(proj2(sh_domain _ _ _ _ SHAPE id b ty LOOK))as TY;subst ty.
  subst r;change(~Mem.valid_block base b).
  exact(sh_fresh _ _ _ _ SHAPE id b LOOK).
Qed.

Theorem init_locals_free : forall e base input buffer m cnt,
  protocol_core e base input buffer m ->packed_prefix cnt m buffer ->
  exists mf,
    Mem.free_list m(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e)=Some mf /\
    Mem.unchanged_on(fun b _=>Mem.valid_block base b)m mf /\
    Mem.unchanged_on(Frame.protected base buffer)base mf /\packed_prefix cnt mf buffer.
Proof.
  intros e base input buffer m cnt CORE PREFIX.
  pose proof(pc_shape _ _ _ _ _ CORE)as SHAPE.
  destruct(fresh_free_list base(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e)m
    (init_regions_distinct _ _ _ _ SHAPE)(init_regions_freeable _ _ _ _ _ CORE)
    (init_regions_fresh _ _ _ _ SHAPE))as[mf[FREE FRAME]].
  exists mf;split;[exact FREE|];split;[exact FRAME|];split.
  - eapply Mem.unchanged_on_trans;[exact(pc_frame _ _ _ _ _ CORE)|].
    eapply Mem.unchanged_on_implies;[exact FRAME|]. intros b ofs[OLD NE]_;exact OLD.
  - eapply packed_prefix_old_frame;[exact(sh_buffer_valid _ _ _ _ SHAPE)|exact FRAME|exact PREFIX].
Qed.
