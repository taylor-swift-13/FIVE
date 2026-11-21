From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Globalenvs Ctypes Csem.
From PprzTrigRelationSupport Require Import TrigData PureEval.
From PprzTrigInitSupport Require Import GetNibble NibbleFacts.
Import ListNotations.
Local Open Scope Z_scope.

Definition source_byte (p:Z) := nth (Z.to_nat (p/2)) compressed_bytes 0.
Definition source_nibble (p:Z) := nth (Z.to_nat p) literal_nibbles 0.
Definition machine_nibble_check (n:nat) : bool :=
  let p:=Z.of_nat n in
  (Z.eqb (Ptrofs.unsigned (nibble_offset (Int.repr p))) (p/2)) &&
  ((0<=?source_nibble p) && (source_nibble p<=?15)) &&
  match nibble_machine (Int.repr p) (Int.repr (source_byte p)) with
  | Some (Vint v)=>Int.eq v (Int.repr (source_nibble p))
  | _=>false end.
Lemma original_machine_nibbles : forallb machine_nibble_check (seq 0 3379)=true.
Proof. vm_compute; reflexivity. Qed.

Lemma machine_nibble_literal : forall p, 0<=p<3379 ->
  Ptrofs.unsigned (nibble_offset (Int.repr p))=p/2 /\
  0<=source_nibble p<=15 /\
  nibble_machine (Int.repr p) (Int.repr (source_byte p))=
    Some(Vint(Int.repr(source_nibble p))).
Proof.
  intros p RANGE.
  pose proof original_machine_nibbles as ALL.
  apply forallb_forall with (x:=Z.to_nat p) in ALL.
  - unfold machine_nibble_check in ALL; rewrite Z2Nat.id in ALL by lia.
    apply andb_true_iff in ALL as [CHECK VALUE].
    apply andb_true_iff in CHECK as [OFFSET BOUNDS].
    apply Z.eqb_eq in OFFSET.
    apply andb_true_iff in BOUNDS as [LOW HIGH].
    apply Z.leb_le in LOW;apply Z.leb_le in HIGH.
    split;[exact OFFSET|];split;[lia|].
    destruct(nibble_machine (Int.repr p)(Int.repr(source_byte p))) as [v|]eqn:M;
      try discriminate.
    destruct v as [|i|il|f|fs|b ofs];try discriminate.
    pose proof(Int.eq_spec i(Int.repr(source_nibble p)))as EQ.
    rewrite VALUE in EQ;subst i;reflexivity.
  - apply in_seq;split;[lia|].
    change (Z.to_nat p<Z.to_nat 3379)%nat.
    apply (proj1(Z2Nat.inj_lt p 3379 ltac:(lia)ltac:(lia)));lia.
Qed.

Theorem get_nibble_literal_expression : forall e m bp bc p,
  0<=p<3379 ->
  e!Source._pos=Some(bp,Tint I16 Unsigned noattr) ->
  e!Source._pprz_trig_int_compr=None ->
  Genv.find_symbol (Csem.globalenv Source.prog) Source._pprz_trig_int_compr=Some bc ->
  Mem.load Mint16unsigned m bp 0=Some(Vint(Int.repr p)) ->
  Mem.load Mint8unsigned m bc (p/2)=Some(Vint(Int.repr(source_byte p))) ->
  pure_rval (Csem.globalenv Source.prog) e m nibble_expr=
    Some(Vint(Int.repr(source_nibble p))).
Proof.
  intros e m bp bc p RANGE POS LOCAL SYMBOL LP LB.
  destruct(machine_nibble_literal p RANGE)as[OFFSET[BOUND RESULT]].
  rewrite <- RESULT.
  eapply get_nibble_expression_reads;eauto.
  rewrite OFFSET;exact LB.
Qed.
