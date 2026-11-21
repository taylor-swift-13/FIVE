From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import PureEval BranchPure InitState InitLoop PackedPrefix EncoderMachine.
From PprzTrigInitSupport Require Import EncoderBody EncoderMemory Control.
From PprzTrigCBMC Require Import TypedGuards SourceOccurrence SourceObservations CallEntryCoverage.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Definition encoder_count_expression:=Evalof(Evar PprzTrigInit.Source._cnt tshort)tshort.
Definition encoder_high_expression:=match encode_even with
 Eassign(Ederef(Ebinop Oadd _ a _)_)_ _=>a|_=>Eval Vundef tint end.
Definition encoder_half_expression:=match encoder_high_expression with
 Ebinop Oadd _ a _=>a|_=>Eval Vundef tint end.
Lemma encoder_high_index_origins :
 In encoder_count_expression(statement_nodes(fn_body PprzTrigInit.Source.f_table_encode_12)) /\
 In encoder_high_expression(statement_nodes(fn_body PprzTrigInit.Source.f_table_encode_12)) /\
 In encoder_half_expression(statement_nodes(fn_body PprzTrigInit.Source.f_table_encode_12)) /\
 (match encode_odd with Eassignop Oor(Ederef(Ebinop Oadd _ a _)_)_ _ _=>a|_=>Eval Vundef tint end)=encoder_high_expression.
Proof. vm_compute;tauto. Qed.

Lemma encoder_actual_index_reads : forall e m cnt,
 short_cell e m PprzTrigInit.Source._cnt cnt ->
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_count_expression(Vint(Int.repr cnt)) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_half_expression(Vint(Int.divs(Int.repr cnt)(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_high_expression(Vint(encoder_high_index(Int.repr cnt))).
Proof.
 intros e m cnt CELL.
 assert(COUNT:source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_count_expression(Vint(Int.repr cnt))).
 { split;[reflexivity|]. exact(@short_read_value(Csem.globalenv PprzTrigInit.Source.prog)e m PprzTrigInit.Source._cnt cnt CELL). }
 assert(HALF:source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_half_expression(Vint(Int.divs(Int.repr cnt)(Int.repr 2)))).
 { split;[reflexivity|].
   change(match branch_rval(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_count_expression with
   |Some v=>sem_binary_operation(Csem.globalenv PprzTrigInit.Source.prog)Odiv v tshort(Vint(Int.repr 2))tint m
   |None=>None end=Some(Vint(Int.divs(Int.repr cnt)(Int.repr 2)))).
   rewrite(proj2 COUNT).
   change((if Int.eq(Int.repr 2)Int.zero || (Int.eq(Int.repr cnt)(Int.repr Int.min_signed) &&Int.eq(Int.repr 2)Int.mone)
   then None else Some(Vint(Int.divs(Int.repr cnt)(Int.repr 2))))=Some(Vint(Int.divs(Int.repr cnt)(Int.repr 2)))).
   assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
   assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
   rewrite E20,E2M,andb_false_r;reflexivity. }
 assert(HIGH:source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_high_expression(Vint(encoder_high_index(Int.repr cnt)))).
 { split;[reflexivity|].
   change(match branch_rval(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_half_expression with
   |Some v=>sem_binary_operation(Csem.globalenv PprzTrigInit.Source.prog)Oadd(Vint(Int.repr 6434))tint v tint m
   |None=>None end=Some(Vint(encoder_high_index(Int.repr cnt)))).
   rewrite(proj2 HALF);reflexivity. }
 auto.
Qed.

Definition encoder_index_check(n:nat):bool:=let cnt:=Z.of_nat n in
 Z.eqb(Int.signed(Int.divs(Int.repr cnt)(Int.repr 2)))(cnt/2) &&
 Z.eqb(Int.signed(encoder_high_index(Int.repr cnt)))(high_address cnt).
Lemma original_encoder_index_arithmetic : forallb encoder_index_check(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma encoder_index_arithmetic_at : forall cnt,0<=cnt<6434 ->
 Int.signed(Int.divs(Int.repr cnt)(Int.repr 2))=cnt/2 /\
 Int.signed(encoder_high_index(Int.repr cnt))=high_address cnt.
Proof.
 intros cnt C;pose proof original_encoder_index_arithmetic as ALL.
 apply forallb_forall with(x:=Z.to_nat cnt)in ALL.
 - unfold encoder_index_check in ALL;rewrite Z2Nat.id in ALL by lia.
   apply andb_true_iff in ALL as[A B];apply Z.eqb_eq in A;apply Z.eqb_eq in B;auto.
 - apply in_seq;split;[lia|]. change(Z.to_nat cnt<Z.to_nat 6434)%nat.
   apply(proj1(Z2Nat.inj_lt cnt 6434 ltac:(lia)ltac:(lia)));lia.
Qed.

Theorem encoder_source_index_guard_cutpoint : forall e m cnt,
 0<=cnt<6434 ->short_cell e m PprzTrigInit.Source._cnt cnt ->
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_count_expression(Vint(Int.repr cnt)) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_half_expression(Vint(Int.divs(Int.repr cnt)(Int.repr 2))) /\
 source_observation(Csem.globalenv PprzTrigInit.Source.prog)e m encoder_high_expression(Vint(encoder_high_index(Int.repr cnt))) /\
 0<=Int.signed(Int.repr cnt)<9651 /\
 0<=Int.signed(encoder_high_index(Int.repr cnt))<9651 /\
 signed32(6434+Int.signed(Int.divs(Int.repr cnt)(Int.repr 2))) /\
 Ptrofs.unsigned(encoder_offset(Int.repr cnt))=cnt /\
 Ptrofs.unsigned(encoder_offset(encoder_high_index(Int.repr cnt)))=high_address cnt.
Proof.
 intros e m cnt C CELL;destruct(@encoder_actual_index_reads e m cnt CELL)as[A[B D]].
 split;[exact A|];split;[exact B|];split;[exact D|].
 destruct(@encoder_index_arithmetic_at cnt C)as[HALF HIGH].
 destruct(@literal_encoder_machine cnt C)as[LOWPTR[HIGHPTR REST]].
 rewrite HALF,HIGH,(Int.signed_repr cnt)by(change(-2147483648<=cnt<=2147483647);lia).
 pose proof(high_address_bounds cnt C)as[H NE].
 unfold high_address in *;unfold signed32;repeat split;try assumption;lia.
Qed.

Theorem original_encoder_entry_reaches_operand_pc : forall m value previous cnt tb ofs,
 0<=value<=16383 ->0<=previous<=16383 ->0<=cnt<6434 ->
 exists e mp,encoder_setup m value previous cnt tb ofs e mp /\
 (forall k,Csem.step(Csem.globalenv PprzTrigInit.Source.prog)
   (Callstate(Internal PprzTrigInit.Source.f_table_encode_12)
    [Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb ofs]k m)E0
   (State PprzTrigInit.Source.f_table_encode_12(fn_body PprzTrigInit.Source.f_table_encode_12)k e mp)) /\
 (forall k t next,Csem.step(Csem.globalenv PprzTrigInit.Source.prog)
   (Callstate(Internal PprzTrigInit.Source.f_table_encode_12)
    [Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb ofs]k m)t next ->
   t=E0 /\next=State PprzTrigInit.Source.f_table_encode_12(fn_body PprzTrigInit.Source.f_table_encode_12)k e mp).
Proof.
 intros m value previous cnt tb ofs V P C.
 destruct(@encoder_setup_exists m value previous cnt tb ofs V P ltac:(lia))as[e[mp SETUP]].
 pose proof(es_entry _ _ _ _ _ _ _ _ SETUP)as[ma[ALLOC BIND]].
 exists e,mp;split;[exact SETUP|];split.
 - intro k;apply(proj1(@original_internal_entry_observations(Csem.globalenv PprzTrigInit.Source.prog)
     PprzTrigInit.Source.f_table_encode_12[Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb ofs]k m e ma mp
     ltac:(vm_compute;repeat constructor;simpl;intuition discriminate)ALLOC BIND)).
 - intros k;apply(proj2(@original_internal_entry_observations(Csem.globalenv PprzTrigInit.Source.prog)
     PprzTrigInit.Source.f_table_encode_12[Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr cnt);Vptr tb ofs]k m e ma mp
     ltac:(vm_compute;repeat constructor;simpl;intuition discriminate)ALLOC BIND)).
Qed.
