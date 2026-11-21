From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Globalenvs Ctypes Cop Csyntax Csem Cexec.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import InitProtocol PackedPrefix.
From PprzTrigInitSupport Require Import Control Frame PostIncrement EncoderTransport.
Import ListNotations.
Local Open Scope Z_scope.

Record allocated_env(names:list ident)(base:mem)(e:env)(m:mem):Prop:={
  ae_cover:forall id,In id names->exists b,e!id=Some(b,short_type);
  ae_domain:forall id b ty,e!id=Some(b,ty)->In id names /\ty=short_type;
  ae_injective:forall id1 id2 b1 b2,e!id1=Some(b1,short_type)->e!id2=Some(b2,short_type)->id1<>id2->b1<>b2;
  ae_fresh:forall id b,e!id=Some(b,short_type)->~Mem.valid_block base b;
  ae_freeable:forall id b,e!id=Some(b,short_type)->Mem.range_perm m b 0 2 Cur Freeable;
  ae_frame:Mem.unchanged_on(fun b _=>Mem.valid_block base b)base m
}.

Lemma allocated_env_empty : forall m,allocated_env [] m empty_env m.
Proof.
  intro m;constructor.
  - intros id IN;contradiction.
  - intros id b ty EQ;rewrite PTree.gempty in EQ;discriminate.
  - intros id1 id2 b1 b2 EQ;rewrite PTree.gempty in EQ;discriminate.
  - intros id b EQ;rewrite PTree.gempty in EQ;discriminate.
  - intros id b EQ;rewrite PTree.gempty in EQ;discriminate.
  - apply Mem.unchanged_on_refl.
Qed.

Lemma allocated_env_step : forall names base e m id m1 b,
  allocated_env names base e m ->Mem.alloc m 0 2=(m1,b) ->
  allocated_env(names++[id])base(PTree.set id(b,short_type)e)m1.
Proof.
  intros names base e m id m1 b ENV ALLOC.
  destruct ENV as[COVER DOMAIN INJECT FRESH FREE FRAME].
  assert(NEW:~Mem.valid_block m b)by(eapply Mem.fresh_block_alloc;eauto).
  constructor.
  - intros x IN;destruct(peq x id)as[EQ|NE].
    + subst x;exists b;apply PTree.gss.
    + apply in_app_or in IN;destruct IN as[IN|IN].
      * destruct(COVER x IN)as[bx BX]. exists bx;rewrite PTree.gso;auto.
      * simpl in IN;destruct IN as[EQ|BAD];[congruence|contradiction].
  - intros x bx ty LOOK;rewrite PTree.gsspec in LOOK;destruct(peq x id)as[EQ|NE].
    + inversion LOOK;subst bx ty;split;[apply in_or_app;right;simpl;auto|reflexivity].
    + destruct(DOMAIN x bx ty LOOK)as[IN TY];split;[apply in_or_app;left;exact IN|exact TY].
  - intros id1 id2 b1 b2 LOOK1 LOOK2 DIFF.
    rewrite PTree.gsspec in LOOK1,LOOK2.
    destruct(peq id1 id)as[E1|N1];destruct(peq id2 id)as[E2|N2].
    + congruence.
    + inversion LOOK1;subst b1.
      assert(OLD:Mem.valid_block m b2).
      { eapply Mem.perm_valid_block;apply(FREE id2 b2 LOOK2);instantiate(1:=0);lia. }
      intro EQ;apply NEW;rewrite EQ;exact OLD.
    + inversion LOOK2;subst b2.
      assert(OLD:Mem.valid_block m b1).
      { eapply Mem.perm_valid_block;apply(FREE id1 b1 LOOK1);instantiate(1:=0);lia. }
      intro EQ;apply NEW;rewrite<-EQ;exact OLD.
    + eapply INJECT;eauto.
  - intros x bx LOOK;rewrite PTree.gsspec in LOOK;destruct(peq x id)as[EQ|NE].
    + inversion LOOK;subst bx;intro OLD;apply NEW.
      eapply Mem.valid_block_unchanged_on;[exact FRAME|exact OLD].
    + apply(FRESH x bx LOOK).
  - intros x bx LOOK;rewrite PTree.gsspec in LOOK;destruct(peq x id)as[EQ|NE].
    + inversion LOOK;subst bx;intros ofs RANGE;eapply Mem.perm_alloc_2;eauto.
    + intros ofs RANGE;eapply Mem.perm_alloc_1;[exact ALLOC|apply(FREE x bx LOOK);exact RANGE].
  - eapply Mem.unchanged_on_trans;[exact FRAME|eapply Mem.alloc_unchanged_on;exact ALLOC].
Qed.

Theorem allocate_short_variables : forall (ge:Csem.genv) ids names base e m,
  allocated_env names base e m ->exists e' m',
  do_alloc_variables ge e m(map(fun id=>(id,short_type))ids)=(e',m') /\
  allocated_env(names++ids)base e' m'.
Proof.
  intros ge ids;induction ids as[|id rest IH];intros names base e m ENV.
  - exists e,m;split;[reflexivity|rewrite app_nil_r;exact ENV].
  - destruct(Mem.alloc m 0 2)as[m1 b]eqn:ALLOC.
    pose proof(allocated_env_step names base e m id m1 b ENV ALLOC)as ENV1.
    destruct(IH(names++[id])base(PTree.set id(b,short_type)e)m1 ENV1)as[e'[m'[RUN SHAPE]]].
    exists e',m';split.
    + cbn [map do_alloc_variables short_type sizeof];rewrite ALLOC;exact RUN.
    + replace(names++id::rest)with((names++[id])++rest)by(rewrite<-app_assoc;reflexivity).
      exact SHAPE.
Qed.

Lemma init_variables_are_short : fn_vars PprzTrigInit.Source.f_pprz_trig_int_init=
  map(fun id=>(id,short_type))init_local_ids.
Proof. reflexivity. Qed.

Theorem init_entry_allocation : forall base input buffer,
  Mem.valid_block base input ->Mem.valid_block base buffer ->input<>buffer ->
  (forall i,0<=i<1690->Mem.load Mint8unsigned base input i=
    Some(Vint(Integers.Int.repr(nth(Z.to_nat i)TrigData.compressed_bytes 0)))) ->
  packed_prefix 0 base buffer ->
  exists e mp,
    do_alloc_variables(Csem.globalenv PprzTrigInit.Source.prog)empty_env base
      (fn_params PprzTrigInit.Source.f_pprz_trig_int_init++fn_vars PprzTrigInit.Source.f_pprz_trig_int_init)=(e,mp) /\
    sem_bind_parameters(Csem.globalenv PprzTrigInit.Source.prog)Control.quiet e mp
      (fn_params PprzTrigInit.Source.f_pprz_trig_int_init)[]=Some mp /\
    init_shape e base input buffer /\protocol_core e base input buffer mp /\
    packed_prefix 0 mp buffer /\allocated_env init_local_ids base e mp.
Proof.
  intros base input buffer INPUT BUFFER DISTINCT READ PREFIX.
  destruct(allocate_short_variables(Csem.globalenv PprzTrigInit.Source.prog)init_local_ids [] base empty_env base
    (allocated_env_empty base))as[e[mp[ALLOC ENV]]].
  cbn [app]in ENV.
  pose proof ENV as ENV0;destruct ENV0 as[COVER DOMAIN INJECT FRESH FREE FRAME].
  assert(SHAPE:init_shape e base input buffer).
  { constructor;eauto. }
  exists e,mp;split.
  - change(do_alloc_variables(Csem.globalenv PprzTrigInit.Source.prog)empty_env base
      (fn_vars PprzTrigInit.Source.f_pprz_trig_int_init)=(e,mp)).
    rewrite init_variables_are_short;exact ALLOC.
  - split.
    + change(sem_bind_parameters(Csem.globalenv PprzTrigInit.Source.prog)Control.quiet e mp[][]=Some mp).
      rewrite sem_bind_parameters_equation;reflexivity.
    + split;[exact SHAPE|];split.
      * constructor;[exact SHAPE|exact FREE| |].
        -- intros i RANGE;eapply Mem.load_unchanged_on;[exact FRAME| |apply READ;exact RANGE].
           intros;exact INPUT.
        -- eapply Mem.unchanged_on_implies;[exact FRAME|]. intros b ofs[OLD NE]_;exact OLD.
      * split;[eapply packed_prefix_old_frame;eauto|exact ENV].
Qed.
