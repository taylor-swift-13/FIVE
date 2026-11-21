From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import TrigData PureEval BranchPure.
From PprzTrigInitSupport Require Import GetNibble NibbleFacts NibbleMachine.
From PprzTrigCBMC Require Import TypedGuards SourceOccurrence SourceObservations.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Definition nibble_byte_expression:=match nibble_expr with
 Ebinop Oand(Ebinop Oshr a _ _)_ _=>a|_=>Eval Vundef tint end.
Definition nibble_shift_expression:=match nibble_expr with
 Ebinop Oand(Ebinop Oshr _ a _)_ _=>a|_=>Eval Vundef tint end.
Definition nibble_index_expression:=match nibble_byte_expression with
 Evalof(Ederef(Ebinop Oadd _ a _)_)_=>a|_=>Eval Vundef tint end.
Definition nibble_mod_expression:=match nibble_shift_expression with
 Ebinop Omul _ a _=>a|_=>Eval Vundef tint end.
Definition nibble_position_expression:=Evalof(Evar PprzTrigInit.Source._pos tushort)tushort.
Lemma nibble_source_operand_origins :
 In nibble_byte_expression(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble)) /\
 In nibble_shift_expression(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble)) /\
 In nibble_index_expression(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble)) /\
 In nibble_mod_expression(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble)).
Proof. vm_compute;tauto. Qed.

Lemma nibble_actual_operand_reads : forall e m bp bc p x,
 e!PprzTrigInit.Source._pos=Some(bp,tushort) ->
 e!PprzTrigInit.Source._pprz_trig_int_compr=None ->
 Genv.find_symbol(Csem.globalenv PprzTrigInit.Source.prog)PprzTrigInit.Source._pprz_trig_int_compr=Some bc ->
 Mem.load Mint16unsigned m bp 0=Some(Vint p) ->
 Mem.load Mint8unsigned m bc(Ptrofs.unsigned(nibble_offset p))=Some(Vint x) ->
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_position_expression(Vint p) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_index_expression(Vint(Int.divs p(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_mod_expression(Vint(Int.mods p(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_shift_expression(Vint(nibble_shift p)) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_byte_expression(Vint x).
Proof.
 intros e m bp bc p x POS LOCAL SYMBOL LP LB.
 repeat split;try reflexivity.
 all:unfold nibble_position_expression,nibble_index_expression,nibble_mod_expression,
   nibble_shift_expression,nibble_byte_expression,nibble_expr.
 all:cbv beta iota zeta delta[PprzTrigInit.Source.f_get_nibble fn_body branch_rval branch_lval typeof].
 all:repeat rewrite dec_eq_true.
 all:rewrite ?POS,?LOCAL,?SYMBOL.
 all:unfold tushort,tuchar,tarray,tptr,tint;repeat rewrite dec_eq_true.
 all:cbn[Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv].
 all:try rewrite Ptrofs.unsigned_zero.
 all:rewrite LP.
 all:cbn[attr_of_type attr_volatile noattr size_chunk].
 all:rewrite !zle_true by(change(2<=18446744073709551616);lia).
 all:cbv beta iota zeta delta[sem_binary_operation sem_div sem_mod sem_add sem_add_ptr_int ptrofs_of_int
 sem_mul sem_binarith classify_binarith binarith_type classify_add typeconv sem_cast classify_cast
 cast_int_int sizeof sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
 all:try reflexivity.
 all:assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 all:assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 all:rewrite ?E20,?E2M,?andb_false_r;cbn[orb sizeof].
 all:try reflexivity.
 all:fold(nibble_offset p).
 all:cbn[Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 all:rewrite LB,zle_true by(pose proof(Ptrofs.unsigned_range(nibble_offset p));lia).
 all:reflexivity.
Qed.

Definition nibble_arithmetic_check(n:nat):bool:=let p:=Z.of_nat n in
 Z.eqb(Int.signed(Int.divs(Int.repr p)(Int.repr 2)))(p/2) &&
 Z.eqb(Int.signed(Int.mods(Int.repr p)(Int.repr 2)))(p mod 2) &&
 Z.eqb(Int.signed(nibble_shift(Int.repr p)))(4*(p mod 2)).
Lemma original_nibble_arithmetic : forallb nibble_arithmetic_check(seq 0 3379)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma nibble_arithmetic_at : forall p,0<=p<3379 ->
 Int.signed(Int.divs(Int.repr p)(Int.repr 2))=p/2 /\
 Int.signed(Int.mods(Int.repr p)(Int.repr 2))=p mod 2 /\
 Int.signed(nibble_shift(Int.repr p))=4*(p mod 2).
Proof.
 intros p P;pose proof original_nibble_arithmetic as ALL.
 apply forallb_forall with(x:=Z.to_nat p)in ALL.
 - unfold nibble_arithmetic_check in ALL;rewrite Z2Nat.id in ALL by lia.
   repeat rewrite andb_true_iff in ALL;repeat rewrite Z.eqb_eq in ALL;tauto.
 - apply in_seq;split;[lia|]. apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;cbn;lia.
Qed.

Theorem get_nibble_source_guard_cutpoint : forall e m bp bc p,
 0<=p<3379 ->e!PprzTrigInit.Source._pos=Some(bp,tushort) ->
 e!PprzTrigInit.Source._pprz_trig_int_compr=None ->
 Genv.find_symbol(Csem.globalenv PprzTrigInit.Source.prog)PprzTrigInit.Source._pprz_trig_int_compr=Some bc ->
 Mem.load Mint16unsigned m bp 0=Some(Vint(Int.repr p)) ->
 Mem.load Mint8unsigned m bc(p/2)=Some(Vint(Int.repr(source_byte p))) ->
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_expr(Vint(Int.repr(source_nibble p))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_index_expression(Vint(Int.divs(Int.repr p)(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_mod_expression(Vint(Int.mods(Int.repr p)(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_shift_expression(Vint(nibble_shift(Int.repr p))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_byte_expression(Vint(Int.repr(source_byte p))) /\
 0<=Int.signed(Int.divs(Int.repr p)(Int.repr 2))<1690 /\
 signed32(4*Int.signed(Int.mods(Int.repr p)(Int.repr 2))) /\
 0<=Int.signed(nibble_shift(Int.repr p))<32.
Proof.
 intros e m bp bc p P POS LOCAL SYMBOL LP LB.
 destruct(@machine_nibble_literal p P)as[OFFSET[BOUND RESULT]].
 assert(BYTE:Mem.load Mint8unsigned m bc(Ptrofs.unsigned(nibble_offset(Int.repr p)))=
   Some(Vint(Int.repr(source_byte p))))by(rewrite OFFSET;exact LB).
 destruct(@nibble_actual_operand_reads e m bp bc(Int.repr p)(Int.repr(source_byte p))POS LOCAL SYMBOL LP BYTE)
   as[OBS_POS[OBS_INDEX[OBS_MOD[OBS_SHIFT OBS_BYTE]]]].
 split.
 - split;[reflexivity|]. change(pure_rval(Csem.globalenv PprzTrigInit.Source.prog)e m nibble_expr=Some(Vint(Int.repr(source_nibble p)))).
   exact(@NibbleMachine.get_nibble_literal_expression e m bp bc p P POS LOCAL SYMBOL LP LB).
 - split;[exact OBS_INDEX|];split;[exact OBS_MOD|];split;[exact OBS_SHIFT|];split;[exact OBS_BYTE|].
   destruct(@nibble_arithmetic_at p P)as[INDEX[MOD SHIFT]]. rewrite INDEX,MOD,SHIFT.
   pose proof(Z.mod_pos_bound p 2 ltac:(lia));unfold signed32;split;[apply Z.div_pos;lia|];repeat split;try lia.
   apply Z.div_lt_upper_bound;lia.
Qed.
