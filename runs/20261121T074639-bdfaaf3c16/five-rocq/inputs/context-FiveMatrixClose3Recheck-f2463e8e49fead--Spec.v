From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract.
Definition Post(m mf:mem)(bo bi:block)(po pi:ptrofs)(f:Z->float32):Prop:=
 OutputBytes m mf bo po f /\ Frame m mf bo po /\ WriteRegion mf bo po 9 /\ OldBlocks m mf /\ OldAccess m mf /\
 Mem.loadbytes mf bi(Ptrofs.unsigned pi)36=Mem.loadbytes m bi(Ptrofs.unsigned pi)36.
Definition NormalCall:Prop:=forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 exists mf,(exists t,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate(Status f)Kstop mf))/\Post m mf bo bi po pi f.
Definition AllNormalObservations:Prop:=forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 forall t v mf,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate v Kstop mf)->v=Status f /\Post m mf bo bi po pi f.
