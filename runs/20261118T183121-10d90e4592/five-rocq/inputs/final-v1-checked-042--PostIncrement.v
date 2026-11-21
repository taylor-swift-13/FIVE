From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From PprzTrigRelationSupport Require Import InitState Total PureEval.
From PprzTrigInitSupport Require Import Control SideEffects.
Import ListNotations.
Local Open Scope Z_scope.
Definition short_type := Tint I16 Signed noattr.

Lemma short_deref : forall ge w m b z,
  Mem.load Mint16signed m b 0=Some(Vint(Int.repr z)) ->
  Cexec.do_deref_loc ge w short_type m b Ptrofs.zero Full=Some(w,E0,Vint(Int.repr z)).
Proof.
  intros ge w m b z LOAD.
  cbv beta iota zeta delta [Cexec.do_deref_loc short_type type_is_volatile
    attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
  rewrite Ptrofs.unsigned_zero,LOAD,zle_true by (change (2<=18446744073709551616);lia).
  reflexivity.
Qed.
Lemma short_assign : forall ge w m b z mf,
  Mem.store Mint16signed m b 0(Vint(Int.repr z))=Some mf ->
  Cexec.do_assign_loc ge w short_type m b Ptrofs.zero Full(Vint(Int.repr z))=
    Some(w,E0,mf,Vint(Int.repr z)).
Proof.
  intros ge w m b z mf STORE.
  cbv beta iota zeta delta [Cexec.do_assign_loc short_type type_is_volatile
    attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
  rewrite Ptrofs.unsigned_zero,STORE,zle_true by (change (2<=18446744073709551616);lia).
  reflexivity.
Qed.
Lemma short_add_one : forall ge m z, 0<=z<16383 ->
  sem_binary_operation ge Oadd (Vint(Int.repr z)) short_type
    (Vint Int.one) type_int32s m=Some(Vint(Int.repr(z+1))).
Proof.
  intros ge m z RANGE.
  change (Some(Vint(Int.add(Int.repr z)Int.one))=Some(Vint(Int.repr(z+1)))).
  rewrite Int.add_unsigned,Int.unsigned_one,Int.unsigned_repr
    by (change (0<=z<=4294967295);lia).
  reflexivity.
Qed.
Lemma short_increment_cast : forall m z, 0<=z<16383 ->
  sem_cast(Vint(Int.repr(z+1))) (incrdecr_type short_type) short_type m=
    Some(Vint(Int.repr(z+1))).
Proof.
  intros m z RANGE.
  change (Some(Vint(Int.sign_ext 16(Int.repr(z+1))))=Some(Vint(Int.repr(z+1)))).
  rewrite nonnegative_short_cast by lia;reflexivity.
Qed.

Theorem postincrement_statement_total : forall ge Q f id k e m b z mf,
  0<=z<16383 ->
  e!id=Some(b,short_type) ->
  Mem.load Mint16signed m b 0=Some(Vint(Int.repr z)) ->
  Mem.store Mint16signed m b 0(Vint(Int.repr(z+1)))=Some mf ->
  Total.total ge Q (State f Sskip k e mf) ->
  Total.total ge Q (State f (Sdo(Epostincr Incr(Evar id short_type)short_type)) k e m).
Proof.
  intros ge Q f id k e m b z mf RANGE ENV LOAD STORE END.
  pose proof(short_add_one ge m z RANGE)as ADD.
  pose proof(short_increment_cast m z RANGE)as CAST.
  pose proof(short_assign ge Control.quiet m b (z+1) mf STORE)as ASSIGN.
  apply Control.do_total.
  eapply SideEffects.postincr_variable_total;[reflexivity|exact ENV|].
  eapply SideEffects.postincr_head_total;[reflexivity|eapply short_deref;exact LOAD|].
  eapply SideEffects.quiet_singleton_total.
  - vm_compute;reflexivity.
  - cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
    rewrite ADD;reflexivity.
  - cbv beta iota zeta delta [fst snd].
    eapply SideEffects.quiet_singleton_total.
    + vm_compute;reflexivity.
    + cbn [Cexec.do_step Cexec.step_expr Cexec.is_val Cexec.is_loc].
      rewrite dec_eq_true,CAST,ASSIGN;reflexivity.
    + cbv beta iota zeta delta [fst snd].
      eapply SideEffects.comma_head_total;try reflexivity.
      apply Control.do_value_total;exact END.
Qed.

Theorem postincrement_short_cell : forall e m id z,
  short_cell e m id z -> 0<=z<16383 ->
  exists b mf,
    e!id=Some(b,short_type) /\
    Mem.store Mint16signed m b 0(Vint(Int.repr(z+1)))=Some mf /\
    short_cell e mf id (z+1) /\
    (forall ge Q f k,
      Total.total ge Q(State f Sskip k e mf) ->
      Total.total ge Q(State f(Sdo(Epostincr Incr(Evar id short_type)short_type))k e m)).
Proof.
  intros e m id z CELL RANGE.
  destruct(short_store_exists e m id z (z+1) CELL ltac:(lia))as[b[mf[ENV[STORE NEW]]]].
  exists b,mf;repeat split;try assumption.
  intros ge Q f k END.
  destruct CELL as[b0[ENV0[LOAD PERM]]].
  assert(b0=b)by congruence;subst b0.
  eapply postincrement_statement_total;eauto.
Qed.
