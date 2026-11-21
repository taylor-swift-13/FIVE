From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitialMemory PlainClosed LowClosed InitComplete.
From PprzTrigCBMC Require Import GlobalMemory GlobalAccess GlobalSource NoShadow.
Import ListNotations.
Local Open Scope Z_scope.
Lemma low_source_no_error:forall ml after a,
 Spec.initial_low ml ->Spec.init_returns ml(Vint Int.zero)after ->Spec.normalized_angle a ->
 no_error PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]after).
Proof.
 intros ml after a INIT RETURN RANGE;destruct buffer_symbol_info_exists as[b[SYM VAR]].
 exact(proj1(LowClosed.low_total_from_packed after b a RANGE(InitComplete.low_buffer_symbol b SYM)
  (InitComplete.initialized_packed ml after b INIT SYM RETURN))).
Qed.
(** Each result quantifies EVERY actual original-Csem prefix and an attempted
    access head in any legal evaluation context.  An index word is related to
    the ACTUAL machine pointer offset; no successful load/store is assumed. *)
Theorem every_plain_array_load_guard:forall initial a b prefix f k e m C index,
 Spec.initial_plain initial ->Spec.normalized_angle a ->
 Genv.find_symbol PprzTrigPlain.Execution.ge PprzTrigPlain.Source._pprz_trig_int=Some b ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)prefix
 (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(2*Int.signed index))Full tshort)tshort))k e m) ->
 context RV RV C ->0<=Int.signed index<6434 /\e!PprzTrigPlain.Source._pprz_trig_int=None.
Proof.
 intros initial a b prefix f k e m C index INIT RANGE SYMBOL PATH CT.
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(2*Int.signed index))<12868).
 { eapply every_reachable_global_load_in_bounds with(initial:=PprzTrigPlain.Execution.entry[Vint a]initial)(ch:=Mint16signed).
   - exact(proj1(PlainClosed.plain_sine_total_normalized_proved initial a INIT RANGE)).
   - exact(plain_initial_bounds initial b INIT SYMBOL).
   - exact PATH.
   - eapply plain_source_silent;exact PATH.
   - exact CT.
   - reflexivity.
   - reflexivity. }
 split.
 - apply ordinary_index_from_pointer_guard;[pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;exact WORD|exact PTR].
 - eapply plain_reachable_array_unshadowed;[exact PATH|unfold array_names;cbn;auto].
Qed.
Theorem every_init_rom_load_guard:forall initial b prefix f k e m C index,
 Spec.initial_low initial ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some b ->
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(Int.signed index))Full tuchar)tuchar))k e m) ->
 context RV RV C ->0<=Int.signed index<1690 /\e!PprzTrigInit.Source._pprz_trig_int_compr=None.
Proof.
 intros initial b prefix f k e m C index INIT SYMBOL PATH CT.
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(Int.signed index))<1690).
 { eapply every_reachable_global_load_in_bounds with(initial:=PprzTrigInit.Execution.entry[]initial)(ch:=Mint8unsigned).
   - exact(proj1(InitComplete.initializer_total_proved initial INIT)).
   - exact(rom_initial_bounds initial b INIT SYMBOL).
   - exact PATH.
   - eapply init_source_silent;exact PATH.
   - exact CT.
   - reflexivity.
   - reflexivity. }
 split.
 - eapply byte_index_from_pointer_guard;[pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;lia|lia|exact PTR].
 - eapply init_reachable_array_unshadowed;[exact PATH|unfold array_names;cbn;auto].
Qed.
Theorem every_init_buffer_store_guard:forall initial b prefix f k e m C index v ty,
 Spec.initial_low initial ->Spec.buffer_symbol b ->
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Eassign(Eloc b(Ptrofs.repr(Int.signed index))Full tuchar)(Eval v ty)tuchar))k e m) ->
 context RV RV C ->0<=Int.signed index<9651 /\e!PprzTrigInit.Source._data_buf_12=None.
Proof.
 intros initial b prefix f k e m C index v ty INIT SYMBOL PATH CT.
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(Int.signed index))<9651).
 { eapply every_reachable_global_store_in_bounds with(initial:=PprzTrigInit.Execution.entry[]initial)(ch:=Mint8unsigned).
   - exact(proj1(InitComplete.initializer_total_proved initial INIT)).
   - exact(buffer_initial_bounds initial b INIT SYMBOL).
   - exact PATH.
   - eapply init_source_silent;exact PATH.
   - exact CT.
   - reflexivity.
   - reflexivity. }
 split.
 - eapply byte_index_from_pointer_guard;[pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;lia|lia|exact PTR].
 - eapply init_reachable_array_unshadowed;[exact PATH|unfold array_names;cbn;auto].
Qed.
Theorem every_init_buffer_load_guard:forall initial b prefix f k e m C index,
 Spec.initial_low initial ->Spec.buffer_symbol b ->
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix
 (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(Int.signed index))Full tuchar)tuchar))k e m) ->
 context RV RV C ->0<=Int.signed index<9651 /\e!PprzTrigInit.Source._data_buf_12=None.
Proof.
 intros initial b prefix f k e m C index INIT SYMBOL PATH CT.
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(Int.signed index))<9651).
 { eapply every_reachable_global_load_in_bounds with(initial:=PprzTrigInit.Execution.entry[]initial)(ch:=Mint8unsigned).
   - exact(proj1(InitComplete.initializer_total_proved initial INIT)).
   - exact(buffer_initial_bounds initial b INIT SYMBOL).
   - exact PATH.
   - eapply init_source_silent;exact PATH.
   - exact CT.
   - reflexivity.
   - reflexivity. }
 split.
 - eapply byte_index_from_pointer_guard;[pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;lia|lia|exact PTR].
 - eapply init_reachable_array_unshadowed;[exact PATH|unfold array_names;cbn;auto].
Qed.
Theorem every_low_buffer_load_guard:forall initial after a b prefix f k e m C index,
 Spec.initial_low initial ->Spec.init_returns initial(Vint Int.zero)after ->Spec.normalized_angle a ->Spec.buffer_symbol b ->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]after)prefix
 (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(Int.signed index))Full tuchar)tuchar))k e m) ->
 context RV RV C ->0<=Int.signed index<9651 /\e!PprzTrigLow.Source._data_buf_12=None.
Proof.
 intros initial after a b prefix f k e m C index INIT RETURN RANGE SYMBOL PATH CT.
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(Int.signed index))<9651).
 { eapply every_reachable_global_load_in_bounds with(initial:=PprzTrigLow.Execution.entry[Vint a]after)(ch:=Mint8unsigned).
   - exact(low_source_no_error initial after a INIT RETURN RANGE).
   - exact(initialized_buffer_bounds initial after b INIT SYMBOL RETURN).
   - exact PATH.
   - eapply low_source_silent;exact PATH.
   - exact CT.
   - reflexivity.
   - reflexivity. }
 split.
 - eapply byte_index_from_pointer_guard;[pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;lia|lia|exact PTR].
 - eapply low_reachable_array_unshadowed;[exact PATH|unfold array_names;cbn;auto].
Qed.
Print Assumptions every_plain_array_load_guard.
Print Assumptions every_init_rom_load_guard.
Print Assumptions every_init_buffer_store_guard.
Print Assumptions every_low_buffer_load_guard.
