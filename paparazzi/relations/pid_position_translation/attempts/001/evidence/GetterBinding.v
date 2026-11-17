From Stdlib Require Import List ZArith.
From compcert Require Import Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Csyntax Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import GetterSemantics.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.
Definition position_getter_checked : forall m b co,
 Genv.find_symbol Execution.ge Source._state=Some b ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 forall flags delta,
 field_offset Execution.ge Source._pos_status (co_members co)=OK(2,Full) ->
 field_offset Execution.ge Source._ned_pos_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m b 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 star Csem.step Execution.ge (Callstate(Internal Source.f_stateGetPositionNed_i)[]Kstop m) E0 (Returnstate(Vptr b(Ptrofs.repr delta))Kstop m)
 := original_position_getter_cached_normal.
Definition speed_getter_checked : forall m b co,
 Genv.find_symbol Execution.ge Source._state=Some b ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 forall flags statusofs delta,
 field_offset Execution.ge Source._speed_status (co_members co)=OK(statusofs,Full) ->
 field_offset Execution.ge Source._ned_speed_i (co_members co)=OK(delta,Full) ->
 Mem.loadv Mint16unsigned m(Vptr b(Ptrofs.repr statusofs))=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 star Csem.step Execution.ge (Callstate(Internal Source.f_stateGetSpeedNed_i)[]Kstop m) E0 (Returnstate(Vptr b(Ptrofs.repr delta))Kstop m)
 := original_speed_getter_cached_normal.
Print Assumptions position_getter_checked.
Print Assumptions speed_getter_checked.
