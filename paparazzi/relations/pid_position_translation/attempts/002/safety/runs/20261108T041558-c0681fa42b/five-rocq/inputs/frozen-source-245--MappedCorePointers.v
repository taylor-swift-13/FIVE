From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Events Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionSafety Require Import MappedEntrySafety MappedPointerChecks ReachableAccess.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
(** The CBMC group at source line 861 checks the 24-byte gh->ref
    subobject. Its scalar consumers are speed/acceleration x/y.
    The initial C object extent and the live current scalar footprint
    are retained as distinct conjuncts. *)
Definition CorePointerGoal(kind:pointer_kind):Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall t C k e ma ofs,In ofs[52;56;60;64] ->
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState S.f_guidance_pid_h_run
   (C(ready_read gh(Ptrofs.repr ofs)tint))k e ma) ->
 context RV RV C ->
 pointer_check kind ma gh(Ptrofs.repr ofs)4 /\
 readable_span m gh 44 24.
Theorem original_core_pointer_at_point:forall kind,CorePointerGoal kind.
Proof.
 intros kind m gh ret flight GOOD t C k e ma ofs SITE PATH CT.
 split.
 - apply span_checks;eapply original_ready_int32_read_span;
   [exact GOOD|exact PATH|exact CT].
 - exact(proj1(original_entry_pointer_contract m gh ret GOOD)).
Qed.
Theorem original_core_reference_layout:
 path_info gh_type[S._ref;S._speed;S._x]=Some(tint,52) /\
 path_info gh_type[S._ref;S._speed;S._y]=Some(tint,56) /\
 path_info gh_type[S._ref;S._accel;S._x]=Some(tint,60) /\
 path_info gh_type[S._ref;S._accel;S._y]=Some(tint,64).
Proof. repeat split;reflexivity. Qed.
Definition core_pointer_dereference_1:CorePointerGoal PointerNull:=
 original_core_pointer_at_point PointerNull.
Definition core_pointer_dereference_2:CorePointerGoal PointerInvalid:=
 original_core_pointer_at_point PointerInvalid.
Definition core_pointer_dereference_3:CorePointerGoal PointerDeallocated:=
 original_core_pointer_at_point PointerDeallocated.
Definition core_pointer_dereference_4:CorePointerGoal PointerDead:=
 original_core_pointer_at_point PointerDead.
Definition core_pointer_dereference_5:CorePointerGoal PointerBounds:=
 original_core_pointer_at_point PointerBounds.
Definition core_pointer_dereference_6:CorePointerGoal PointerInteger:=
 original_core_pointer_at_point PointerInteger.
Print Assumptions original_core_pointer_at_point.
