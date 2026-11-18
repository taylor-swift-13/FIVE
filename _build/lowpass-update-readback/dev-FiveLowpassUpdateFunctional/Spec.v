From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassUpdateCase Require Import Contract UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCompletion:Prop:=forall m b p tc li lo value,Initialized m b p tc li lo->exists t mf,
 star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate(Vsingle(output tc li lo value))Kstop mf) /\Post m mf b p tc li lo value.
Definition AllReturns:Prop:=forall m b p tc li lo value,Initialized m b p tc li lo->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate result Kstop mf)->result=Vsingle(output tc li lo value) /\Post m mf b p tc li lo value.
