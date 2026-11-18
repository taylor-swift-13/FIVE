From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassGetCase Require Import Contract GetCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCompletion:Prop:=forall m b p value,ReadableOut m b p value->exists t mf,
 star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate(Vsingle value)Kstop mf) /\Post m mf b p value.
Definition AllReturns:Prop:=forall m b p value,ReadableOut m b p value->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate result Kstop mf)->result=Vsingle value /\Post m mf b p value.
