From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassRetune Require Import Source Execution.
From FiveLowpassRetuneCase Require Import Contract.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCompletion:Prop:=forall m b p (tau h:float32),writable12 m b p ->exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate(Output tau h)Kstop mf) /\ Post m mf b p tau h.
Definition AllReturns:Prop:=forall m b p (tau h:float32),writable12 m b p ->forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate result Kstop mf)->result=Output tau h /\Post m mf b p tau h.
Definition Nonvacuity:Prop:=exists m b p,writable12 m b p.
