From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassInit Require Import Source Execution.
From FiveLowpassInitCase Require Import Contract.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCompletion:Prop:=forall m b p (tau h value:float32),writable12 m b p ->exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h value)m)t(Returnstate(Output tau h value)Kstop mf) /\ Post m mf b p tau h value.
Definition AllReturns:Prop:=forall m b p (tau h value:float32),writable12 m b p ->forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h value)m)t(Returnstate result Kstop mf)->result=Output tau h value /\Post m mf b p tau h value.
Definition Nonvacuity:Prop:=exists m b p,writable12 m b p.
