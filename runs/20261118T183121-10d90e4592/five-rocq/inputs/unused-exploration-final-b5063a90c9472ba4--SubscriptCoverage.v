From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigCBMC Require Import GlobalMemory GlobalAccess GlobalSource PointerAccess.
Local Open Scope Z_scope.
Theorem every_reachable_read_subscript_guard:forall(ge:Csem.genv)initial prefix f k e m C elem n b index index_type scale bytesize ch,
 no_error ge initial ->global_state b bytesize initial ->
 (forall p s,star Csem.step ge initial p s ->silent_state ge s) ->
 star Csem.step ge initial prefix(ExprState f(C(source_read elem n b index index_type))k e m) ->
 context RV RV C ->sizeof ge elem=scale ->0<=scale<=2 ->0<=bytesize<=12868 ->typeconv index_type=Ctypesdefs.tint ->
 access_mode elem=By_value ch ->type_is_volatile elem=false ->0<=scale*Int.signed index<bytesize.
Proof.
 intros ge initial prefix f k e m C elem n b index index_type scale bytesize ch SAFE BOUND SIL PATH CT SIZE SCALE BS TYPE MODE NV.
 pose proof(read_pointer_reaches_attempt ge f k e m C elem n b index index_type scale CT SIZE ltac:(lia)TYPE)as TO_ATTEMPT.
 assert(FULL:star Csem.step ge initial(prefix**E0)
  (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(scale*Int.signed index))Full elem)elem))k e m)).
 { eapply star_trans;[exact PATH|exact TO_ATTEMPT|reflexivity]. }
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(scale*Int.signed index))<bytesize).
 { eapply every_reachable_global_load_in_bounds;[exact SAFE|exact BOUND|exact FULL|apply SIL with(p:=prefix**E0);exact FULL|exact CT|exact MODE|exact NV]. }
 eapply signed_offset_nowrap;[|exact BS|exact PTR].
 pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;nia.
Qed.
Theorem every_reachable_write_subscript_guard:forall(ge:Csem.genv)initial prefix f k e m C elem n b index index_type scale bytesize ch v vty,
 no_error ge initial ->global_state b bytesize initial ->
 (forall p s,star Csem.step ge initial p s ->silent_state ge s) ->
 star Csem.step ge initial prefix(ExprState f(C(source_write elem n b index index_type v vty))k e m) ->
 context RV RV C ->sizeof ge elem=scale ->0<=scale<=2 ->0<=bytesize<=12868 ->typeconv index_type=Ctypesdefs.tint ->
 access_mode elem=By_value ch ->type_is_volatile elem=false ->0<=scale*Int.signed index<bytesize.
Proof.
 intros ge initial prefix f k e m C elem n b index index_type scale bytesize ch v vty SAFE BOUND SIL PATH CT SIZE SCALE BS TYPE MODE NV.
 pose proof(write_pointer_reaches_attempt ge f k e m C elem n b index index_type scale v vty CT SIZE ltac:(lia)TYPE)as TO_ATTEMPT.
 assert(FULL:star Csem.step ge initial(prefix**E0)
  (ExprState f(C(Eassign(Eloc b(Ptrofs.repr(scale*Int.signed index))Full elem)(Eval v vty)elem))k e m)).
 { eapply star_trans;[exact PATH|exact TO_ATTEMPT|reflexivity]. }
 assert(PTR:0<=Ptrofs.unsigned(Ptrofs.repr(scale*Int.signed index))<bytesize).
 { eapply every_reachable_global_store_in_bounds;[exact SAFE|exact BOUND|exact FULL|apply SIL with(p:=prefix**E0);exact FULL|exact CT|exact MODE|exact NV]. }
 eapply signed_offset_nowrap;[|exact BS|exact PTR].
 pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;nia.
Qed.
Print Assumptions every_reachable_read_subscript_guard.
Print Assumptions every_reachable_write_subscript_guard.
