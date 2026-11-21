From Stdlib Require Import ZArith.
Open Scope Z_scope.
From compcert Require Import AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
(** All actual ready signed-subtraction nodes in the original entry.
    This covers each of the four original reference/cache subtraction sites,
    retaining every original Csem evaluation order. *)
Definition EntrySubtractionEventGoal:Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall t C x y k e ma,
 star Csem.step Execution.ge(Execution.entry(call_args gh ret flight)m)t
 (ExprState Source.f_guidance_pid_h_run_pos
   (C(Ebinop Osub(Eval(Vint x)tint)(Eval(Vint y)tint)tint))k e ma) ->
 context RV RV C ->
 signed32(Int.signed x-Int.signed y).
Definition EntryOverflow1Goal:Prop:=EntrySubtractionEventGoal.
Definition EntryOverflow2Goal:Prop:=EntrySubtractionEventGoal.
Definition EntryOverflow3Goal:Prop:=EntrySubtractionEventGoal.
Definition EntryOverflow4Goal:Prop:=EntrySubtractionEventGoal.
