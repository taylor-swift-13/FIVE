From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import Total PureEval.
From PprzTrigInitSupport Require Import Control GetNibble NibbleMachine IntegerFacts.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.
Local Opaque source_byte source_nibble.
Definition ushort := Tint I16 Unsigned noattr.

Theorem get_nibble_source_call : forall m bc p,
  0<=p<3379 ->
  Genv.find_symbol (Csem.globalenv PprzTrigInit.Source.prog) PprzTrigInit.Source._pprz_trig_int_compr=Some bc ->
  Mem.load Mint8unsigned m bc (p/2)=Some(Vint(Int.repr(source_byte p))) ->
  exists mf,
    Mem.unchanged_on (fun b _=>Mem.valid_block m b) m mf /\
    (forall Q k,
      Total.total (Csem.globalenv PprzTrigInit.Source.prog) Q
        (Returnstate (Vint(Int.repr(source_nibble p))) (call_cont k) mf) ->
      Total.total (Csem.globalenv PprzTrigInit.Source.prog) Q
        (Callstate (Internal PprzTrigInit.Source.f_get_nibble) [Vint(Int.repr p)] k m)).
Proof.
  intros m bc p RANGE SYMBOL BYTE.
  destruct (Mem.alloc m 0 2) as [ma bp] eqn:ALLOC.
  assert (FRESH:~Mem.valid_block m bp) by (eapply Mem.fresh_block_alloc;eauto).
  assert (VA:Mem.valid_access ma Mint16unsigned bp 0 Freeable).
  { eapply Mem.valid_access_alloc_same;eauto;cbn;try lia.
    exists 0;reflexivity. }
  assert (VW:Mem.valid_access ma Mint16unsigned bp 0 Writable).
  { eapply Mem.valid_access_implies;[exact VA|constructor]. }
  destruct(Mem.valid_access_store ma Mint16unsigned bp 0 (Vint(Int.repr p)) VW) as [mp STORE].
  assert (PARAM:Mem.load Mint16unsigned mp bp 0=Some(Vint(Int.repr p))).
  { pose proof(Mem.load_store_same _ _ _ _ _ _ STORE) as L.
    cbn [Val.load_result] in L;rewrite zero_ext16_repr in L by lia;exact L. }
  assert (PERMS:Mem.range_perm mp bp 0 2 Cur Freeable).
  { intros ofs IN;eapply Mem.perm_store_1;eauto.
    eapply Mem.perm_alloc_2;eauto. }
  destruct(Mem.range_perm_free mp bp 0 2 PERMS) as [mf FREE].
  assert (OLD:Mem.valid_block m bc).
  { eapply Mem.valid_access_valid_block.
    eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact BYTE|constructor]. }
  assert (DIFF:bc<>bp) by (intro EQ;subst bc;contradiction).
  assert (BYTEP:Mem.load Mint8unsigned mp bc (p/2)=Some(Vint(Int.repr(source_byte p)))).
  { erewrite (Mem.load_store_other _ _ _ _ _ _ STORE).
    - eapply Mem.load_alloc_other;eauto.
    - left;exact DIFF. }
  let E := constr:(PTree.set PprzTrigInit.Source._pos (bp,ushort) (PTree.empty (block*type))) in
  set (e:=E).
  assert (EPOS:e!PprzTrigInit.Source._pos=Some(bp,ushort)).
  { unfold e;apply PTree.gss. }
  assert (ECOMPR:e!PprzTrigInit.Source._pprz_trig_int_compr=None).
  { unfold e;vm_compute;reflexivity. }
  assert (AV:do_alloc_variables (Csem.globalenv PprzTrigInit.Source.prog) empty_env m
    (fn_params PprzTrigInit.Source.f_get_nibble++fn_vars PprzTrigInit.Source.f_get_nibble)=(e,ma)).
  { change (do_alloc_variables (Csem.globalenv PprzTrigInit.Source.prog) empty_env m
      [(PprzTrigInit.Source._pos,ushort)]=(e,ma)).
    cbn [do_alloc_variables ushort sizeof].
    rewrite ALLOC;reflexivity. }
  assert (BIND:sem_bind_parameters (Csem.globalenv PprzTrigInit.Source.prog) Control.quiet e ma
    (fn_params PprzTrigInit.Source.f_get_nibble) [Vint(Int.repr p)]=Some mp).
  { change (sem_bind_parameters (Csem.globalenv PprzTrigInit.Source.prog) Control.quiet e ma
      [(PprzTrigInit.Source._pos,ushort)] [Vint(Int.repr p)]=Some mp).
    rewrite sem_bind_parameters_equation.
    rewrite EPOS,dec_eq_true.
    cbv beta iota zeta delta [Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr
      access_mode Mem.storev ushort size_chunk].
    rewrite Ptrofs.unsigned_zero.
    rewrite STORE.
    rewrite zle_true by (change (2<=18446744073709551616);lia).
    rewrite sem_bind_parameters_equation;reflexivity. }
  assert (BLOCKS:blocks_of_env (Csem.globalenv PprzTrigInit.Source.prog) e=[(bp,0,2)]).
  { unfold e;vm_compute;reflexivity. }
  assert (FREELIST:Mem.free_list mp (blocks_of_env (Csem.globalenv PprzTrigInit.Source.prog) e)=Some mf).
  { rewrite BLOCKS;cbn [Mem.free_list];rewrite FREE;reflexivity. }
  assert (EXPR:pure_rval (Csem.globalenv PprzTrigInit.Source.prog) e mp nibble_expr=
    Some(Vint(Int.repr(source_nibble p)))).
  { exact(@PprzTrigInitSupport.NibbleMachine.get_nibble_literal_expression e mp bp bc p RANGE EPOS ECOMPR SYMBOL PARAM BYTEP). }
  assert (CAST:sem_cast (Vint(Int.repr(source_nibble p))) (typeof nibble_expr)
    (fn_return PprzTrigInit.Source.f_get_nibble) mp=Some(Vint(Int.repr(source_nibble p)))).
  { destruct(machine_nibble_literal p RANGE)as[_[BOUND _]].
    change (Some(Vint(Int.zero_ext 8(Int.repr(source_nibble p))))=
      Some(Vint(Int.repr(source_nibble p)))).
    rewrite zero_ext8_repr by lia;reflexivity. }
  exists mf;split.
  - eapply Mem.unchanged_on_trans.
    + eapply Mem.alloc_unchanged_on;eauto.
    + eapply Mem.unchanged_on_trans.
      * eapply Mem.store_unchanged_on;eauto;intros i IN OLD0;contradiction.
      * eapply Mem.free_unchanged_on;eauto;intros i IN OLD0;contradiction.
  - intros Q k END.
    exact(get_nibble_call_total Q[Vint(Int.repr p)]k m e ma mp
      (Vint(Int.repr(source_nibble p)))(Vint(Int.repr(source_nibble p)))mf
      AV BIND EXPR CAST FREELIST END).
Qed.
