From Stdlib Require Import Bool List ZArith Lia.
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
  cbn [attr_of_type attr_volatile noattr size_chunk].
  rewrite !zle_true by (change (2 <= 18446744073709551616)%Z; lia).
  unfold sem_div,sem_mod,sem_add,sem_mul,sem_shr,sem_and.
  cbv beta iota zeta delta [sem_binary_operation sem_div sem_mod sem_add sem_add_ptr_int
    ptrofs_of_int sem_mul sem_shr sem_and sem_binarith classify_binarith
    binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof
    sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
  assert (E20:Int.eq (Int.repr 2) Int.zero=false) by (vm_compute;reflexivity).
  assert (E2M:Int.eq (Int.repr 2) Int.mone=false) by (vm_compute;reflexivity).
  rewrite E20,E2M,!andb_false_r.
  cbn [orb sizeof].
  fold (nibble_offset p).
  cbn [Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
  rewrite LB.
  rewrite zle_true by (pose proof(Ptrofs.unsigned_range(nibble_offset p));lia).
  unfold nibble_machine,nibble_shift.
  destruct (Int.ltu (Int.mul (Int.repr 4) (Int.mods p (Int.repr 2))) (Int.repr 32)); reflexivity.
Qed.
