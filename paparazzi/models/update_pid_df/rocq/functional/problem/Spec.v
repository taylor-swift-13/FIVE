From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import Contract PidMemory UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCompletion:Prop:=forall m b p a bc c u0 u1 e0 e1 e2 x,Initialized m b p a bc c u0 u1 e0 e1 e2->exists t mf,
 star Csem.step Execution.ge(Execution.entry(Args b p x)m)t(Returnstate(Vsingle(fp_step a bc c u0 e0 e1 x))Kstop mf) /\Post m mf b p a bc c u0 e0 e1 x.
Definition AllReturns:Prop:=forall m b p a bc c u0 u1 e0 e1 e2 x,Initialized m b p a bc c u0 u1 e0 e1 e2->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args b p x)m)t(Returnstate result Kstop mf)->result=Vsingle(fp_step a bc c u0 e0 e1 x) /\Post m mf b p a bc c u0 e0 e1 x.
Definition Nonvacuity:Prop:=forall a bc c u0 u1 e0 e1 e2:float32,exists m b p,Initialized m b p a bc c u0 u1 e0 e1 e2.
