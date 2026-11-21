From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import PureEval.
From PprzTrigInitSupport Require Import GetNibble.
Import ListNotations.
Local Opaque Source.prog.

Definition nibble_offset (p:Int.int) : ptrofs :=
  Ptrofs.add Ptrofs.zero
    (Ptrofs.mul (Ptrofs.repr 1) (Ptrofs.of_ints (Int.divs p (Int.repr 2)))).
Definition nibble_shift (p:Int.int) := Int.mul (Int.repr 4) (Int.mods p (Int.repr 2)).
Definition nibble_machine (p x:Int.int) : option val :=
  if Int.ltu (nibble_shift p) (Int.repr 32) then
    Some (Vint (Int.and (Int.shr x (nibble_shift p)) (Int.repr 15)))
  else None.

Lemma get_nibble_expression_reads : forall e m bp bc p x,
  e!Source._pos=Some(bp,Tint I16 Unsigned noattr) ->
  e!Source._pprz_trig_int_compr=None ->
  Genv.find_symbol (Csem.globalenv Source.prog) Source._pprz_trig_int_compr=Some bc ->
  Mem.load Mint16unsigned m bp 0=Some(Vint p) ->
  Mem.load Mint8unsigned m bc (Ptrofs.unsigned (nibble_offset p))=Some(Vint x) ->
  pure_rval (Csem.globalenv Source.prog) e m nibble_expr=nibble_machine p x.
Proof.
  intros e m bp bc p x POS LOCAL SYMBOL LP LB.
  unfold nibble_expr.
  cbv beta iota zeta delta [Source.f_get_nibble fn_body pure_rval pure_lval typeof].
  repeat rewrite dec_eq_true.
  rewrite POS,LOCAL,SYMBOL.
  unfold Ctypesdefs.tushort, Ctypesdefs.tuchar, Ctypesdefs.tarray, Ctypesdefs.tptr, Ctypesdefs.tint.
  repeat rewrite dec_eq_true.
  cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv
    Ctypesdefs.tushort Ctypesdefs.tuchar Ctypesdefs.tarray Ctypesdefs.tptr Ctypesdefs.tint].
  try rewrite Ptrofs.unsigned_zero.
  rewrite LP.
  simpl -[Int.divs Int.mods Int.mul Int.shr Int.and Ptrofs.add Ptrofs.mul Ptrofs.of_ints].
  Show.
Abort.
