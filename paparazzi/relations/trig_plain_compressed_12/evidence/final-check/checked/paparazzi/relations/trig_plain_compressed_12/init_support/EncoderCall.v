From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix PackedStores InitState EncoderMachine EncoderFacts Total PureEval.
From PprzTrigInitSupport Require Import Control Frame FreeList Compound EncoderBody EncoderMemory EncoderTransport.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Theorem encoder_source_call : forall m bb cnt previous tb tofs,
  0<=cnt<6434 ->0<=previous<=16383 ->packed_prefix cnt m bb ->
  Genv.find_symbol(Csem.globalenv PprzTrigInit.Source.prog)PprzTrigInit.Source._data_buf_12=Some bb ->
  exists mf,
    packed_prefix(cnt+1)mf bb /\
    Mem.unchanged_on(Frame.protected m bb)m mf /\
    (forall Q k,is_call_cont k ->
      Total.total(Csem.globalenv PprzTrigInit.Source.prog)Q(Returnstate Vundef k mf) ->
      Total.total(Csem.globalenv PprzTrigInit.Source.prog)Q
        (Callstate(Internal PprzTrigInit.Source.f_table_encode_12)
          [Vint(Int.repr(table_at cnt));Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb tofs]k m)).
Proof.
  intros m bb cnt previous tb tofs COUNT PREVIOUS PREFIX SYMBOL.
  assert(VALUE:0<=table_at cnt<=16383).
  { unfold table_at;eapply literal_value_at_bounds;exact COUNT. }
  assert(OLD:Mem.valid_block m bb).
  { pose proof((proj1 PREFIX)0 ltac:(lia))as P0;eapply Mem.perm_valid_block;exact P0. }
  destruct(encoder_setup_exists m(table_at cnt)previous cnt tb tofs VALUE PREVIOUS ltac:(lia))
    as[e[mp SETUP]].
  pose proof SETUP as SETUP0.
  destruct SETUP0 as[ENTRY CV CP CC PTR SHADOW ND REG FRESH SETUP_FRAME].
  assert(PREFIX0:packed_prefix cnt mp bb).
  { eapply packed_prefix_old_frame;eauto. }
  destruct(packed_prefix_advance cnt mp bb COUNT PREFIX0)as[m1[m2[LOW[HIGH COMPLETE]]]].
  assert(CV1:short_cell e m1 PprzTrigInit.Source._val(table_at cnt)).
  { exact(@encoder_cell_buffer_store_any m(table_at cnt)previous cnt tb tofs e mp mp
      PprzTrigInit.Source._val(table_at cnt)bb Mint8unsigned cnt(Vint(Int.repr(low_written cnt)))m1
      SETUP CV OLD LOW). }
  assert(CC1:short_cell e m1 PprzTrigInit.Source._cnt cnt).
  { exact(@encoder_cell_buffer_store_any m(table_at cnt)previous cnt tb tofs e mp mp
      PprzTrigInit.Source._cnt cnt bb Mint8unsigned cnt(Vint(Int.repr(low_written cnt)))m1
      SETUP CC OLD LOW). }
  assert(CP1:short_cell e m1 PprzTrigInit.Source._val_prev previous).
  { exact(@encoder_cell_buffer_store_any m(table_at cnt)previous cnt tb tofs e mp mp
      PprzTrigInit.Source._val_prev previous bb Mint8unsigned cnt(Vint(Int.repr(low_written cnt)))m1
      SETUP CP OLD LOW). }
  assert(CP2:short_cell e m2 PprzTrigInit.Source._val_prev previous).
  { exact(@encoder_cell_buffer_store_any m(table_at cnt)previous cnt tb tofs e mp m1
      PprzTrigInit.Source._val_prev previous bb Mint8unsigned(high_address cnt)(Vint(Int.repr(high_written cnt)))m2
      SETUP CP1 OLD HIGH). }
  assert(HIGH_OLD:Mem.load Mint8unsigned m1 bb(high_address cnt)=
    Some(Vint(Int.repr(buffer_view cnt(high_address cnt))))).
  { destruct(high_address_bounds cnt COUNT)as[BOUNDS NE].
    rewrite(byte_store_other mp m1 bb cnt(low_written cnt)(high_address cnt)LOW ltac:(congruence)).
    apply(proj2 PREFIX0);lia. }
  assert(LOW_EVAL:atom_eval(Csem.globalenv PprzTrigInit.Source.prog)e mp encode_low=
    Some(Vint(Int.repr(low_written cnt)),m1)).
  { exact(@encoder_low_fact e mp m1 bb cnt COUNT CV CC SHADOW SYMBOL LOW). }
  assert(COND_EVAL:pure_rval(Csem.globalenv PprzTrigInit.Source.prog)e m1 encode_cond=
    Some(Val.of_bool(encoder_even_choice(Int.repr cnt)))).
  { destruct CC1 as[bc[ENV[LOAD PERMS]]]. exact(@encoder_cond_raw e m1 bc(Int.repr cnt)ENV LOAD). }
  assert(COND_BOOL:bool_val(Val.of_bool(encoder_even_choice(Int.repr cnt)))(typeof encode_cond)m1=
    Some(encoder_even_choice(Int.repr cnt))).
  { change(bool_val(Val.of_bool(encoder_even_choice(Int.repr cnt)))type_int32s m1=
      Some(encoder_even_choice(Int.repr cnt))).
    destruct(encoder_even_choice(Int.repr cnt));reflexivity. }
  assert(HIGH_EVAL:atom_eval(Csem.globalenv PprzTrigInit.Source.prog)e m1
    (if encoder_even_choice(Int.repr cnt)then encode_even else encode_odd)=
    Some(Vint(Int.repr(high_written cnt)),m2)).
  { exact(@encoder_high_fact e m1 m2 bb cnt COUNT CV1 CC1 SHADOW SYMBOL HIGH_OLD HIGH). }
  assert(PREV_EVAL:pure_rval(Csem.globalenv PprzTrigInit.Source.prog)e m2 encode_prev=Some(Vint(Int.repr previous))).
  { exact(@encoder_prev_fact e m2 previous CP2). }
  destruct PTR as[btab[TAB_ENV TAB_LOAD]].
  assert(TAB_DIFF:btab<>bb).
  { intro EQ;subst btab;eapply(encoder_parameter_fresh _ _ _ _ _ _ _ _ _ _ _ SETUP TAB_ENV);exact OLD. }
  assert(TAB2:Mem.load Mptr m2 btab 0=Some(Vptr tb tofs)).
  { erewrite(Mem.load_store_other _ _ _ _ _ _ HIGH)by(left;exact TAB_DIFF).
    erewrite(Mem.load_store_other _ _ _ _ _ _ LOW)by(left;exact TAB_DIFF).
    exact TAB_LOAD. }
  assert(TAB_EVAL:pure_rval(Csem.globalenv PprzTrigInit.Source.prog)e m2 encode_tab=Some(Vptr tb tofs)).
  { exact(@encoder_tab_fact e m2 btab(Vptr tb tofs)TAB_ENV TAB2). }
  assert(REG2:Forall(region_freeable m2)(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e)).
  { eapply freeable_regions_store;[|exact HIGH]. eapply freeable_regions_store;eauto. }
  destruct(fresh_free_list m(blocks_of_env(Csem.globalenv PprzTrigInit.Source.prog)e)m2 ND REG2 FRESH)
    as[mf[FREE FREE_FRAME]].
  exists mf;split.
  - eapply packed_prefix_old_frame;eauto.
  - split.
    + eapply Mem.unchanged_on_trans.
      * eapply Mem.unchanged_on_implies;[exact SETUP_FRAME|]. intros b ofs[VB NE]_;exact VB.
      * eapply Mem.unchanged_on_trans.
        -- eapply Frame.protected_store;[exact LOW|left;reflexivity].
        -- eapply Mem.unchanged_on_trans.
           ++ eapply Frame.protected_store;[exact HIGH|left;reflexivity].
           ++ eapply Mem.unchanged_on_implies;[exact FREE_FRAME|]. intros b ofs[VB NE]_;exact VB.
    + intros Q k CALL END.
      destruct ENTRY as[ma[ALLOC BIND]].
      exact(@encoder_call_total Q
        [Vint(Int.repr(table_at cnt));Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb tofs]
        k m e ma mp m1 m2 mf (Vint(Int.repr(low_written cnt)))(Vint(Int.repr(high_written cnt)))
        (Val.of_bool(encoder_even_choice(Int.repr cnt)))(encoder_even_choice(Int.repr cnt))
        (Vint(Int.repr previous))(Vptr tb tofs)
        ALLOC BIND LOW_EVAL COND_EVAL COND_BOOL HIGH_EVAL PREV_EVAL TAB_EVAL CALL FREE END).
Qed.

