From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract.
Definition NormalCall:Prop:=forall m bo bi po pi f,Inputs m bo bi po pi f->exists t mf,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate(Result f)Kstop mf)/\Post m mf bo bi po pi f.
Definition AllReturns:Prop:=forall m bo bi po pi f,Inputs m bo bi po pi f->forall t result mf,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop mf)->result=Result f/\Post m mf bo bi po pi f.
Definition Nonvacuity:Prop:=forall f:Z->float32,exists m bo bi,Inputs m bo bi Ptrofs.zero Ptrofs.zero f.
