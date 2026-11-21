From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix InitState Total.
From PprzTrigInitSupport Require Import Control Frame PostIncrement EncoderMemory EncoderCall CallFour.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque Source.prog.

Theorem encoder_statement_total : forall e m bb cnt previous btab fb,
  0<=cnt<6434 ->0<=previous<=16383 ->packed_prefix cnt m bb ->
  short_cell e m Source._val(table_at cnt) ->
  short_cell e m Source._val_prev previous ->short_cell e m Source._cnt cnt ->
  e!Source._tab_12=Some(btab,short_type) ->e!Source._table_encode_12=None ->
  Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
  Genv.find_symbol(Csem.globalenv Source.prog)Source._table_encode_12=Some fb ->
  Genv.find_funct(Csem.globalenv Source.prog)(Vptr fb Ptrofs.zero)=Some(Internal Source.f_table_encode_12) ->
  exists mf,
    packed_prefix(cnt+1)mf bb /\ Mem.unchanged_on(Frame.protected m bb)m mf /\
    (forall Q f k,Total.total(Csem.globalenv Source.prog)Q(State f Sskip k e mf) ->
      Total.total(Csem.globalenv Source.prog)Q
        (State f(Sdo(four_call Source._table_encode_12 Source._val Source._val_prev
          Source._cnt Source._tab_12 fb
          (match e!Source._val with Some(b,_)=>b | None=>1%positive end)
          (match e!Source._val_prev with Some(b,_)=>b | None=>1%positive end)
          (match e!Source._cnt with Some(b,_)=>b | None=>1%positive end)
          btab(table_at cnt)previous cnt 0 0 0 0 0))k e m)).
Proof.
  intros e m bb cnt previous btab fb COUNT PREVIOUS PREFIX CV CP CC TAB FN BUF FSYM FUN.
  destruct CV as[bv[EV[LV RV]]].
  destruct CP as[bp[EP[LP RP]]].
  destruct CC as[bc[EC[LC RC]]].
  destruct(encoder_source_call m bb cnt previous btab Ptrofs.zero COUNT PREVIOUS PREFIX BUF)
    as[mf[NEXT[FRAME BODY]]].
  exists mf;split;[exact NEXT|];split;[exact FRAME|].
  intros Q f k END;rewrite EV,EP,EC.
  apply Control.do_total.
  eapply four_argument_call_total;eauto.
  - unfold table_at;eapply TrigData.literal_value_at_bounds;exact COUNT.
  - lia.
  - reflexivity.
  - apply BODY;[exact I|].
    apply Control.return_to_caller_total.
    apply Control.do_value_total;exact END.
Qed.
