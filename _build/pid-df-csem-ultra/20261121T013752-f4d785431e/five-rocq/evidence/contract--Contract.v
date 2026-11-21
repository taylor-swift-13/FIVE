From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition Args(b:block)(p:ptrofs)(value:float32):list val:=[Vptr b p;Vsingle value].
Definition fp_step(a bc c u e0 e1 x:float32):float32:=
 Float32.add(Float32.add(Float32.add u(Float32.mul a x))(Float32.mul bc e0))(Float32.mul c e1).
Definition Initialized(m:mem)(b:block)(p:ptrofs)(a bc c u0 u1 e0 e1 e2:float32):Prop:=
 writable32 m b p /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+0)=Some(Vsingle u0) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+4)=Some(Vsingle u1) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+8)=Some(Vsingle e0) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+12)=Some(Vsingle e1) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+16)=Some(Vsingle e2) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+20)=Some(Vsingle a) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+24)=Some(Vsingle bc) /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+28)=Some(Vsingle c).
Definition Precondition(args:list val)(m:mem):Prop:=exists b p a bc c u0 u1 e0 e1 e2 x,
 args=Args b p x /\Initialized m b p a bc c u0 u1 e0 e1 e2.
Definition Frame(m mf:mem)(b:block)(p:ptrofs):Prop:=forall q z n,Mem.valid_block m q->
 q<>b \/ z+n<=Ptrofs.unsigned p \/Ptrofs.unsigned p+20<=z ->
 Mem.loadbytes mf q z n=Mem.loadbytes m q z n.
Definition PreservesValid(m mf:mem):Prop:=forall q,Mem.valid_block m q->Mem.valid_block mf q.
Definition WrittenBytes(mf:mem)(b:block)(p:ptrofs)(a bc c u0 e0 e1 x:float32):Prop:=
 forall delta y,In(delta,y)[(0,fp_step a bc c u0 e0 e1 x);(4,u0);(8,x);(12,e0);(16,e1)]->
 Mem.loadbytes mf b(Ptrofs.unsigned p+delta)4=Some(encode_val Mfloat32(Vsingle y)).
Definition Post(m mf:mem)(b:block)(p:ptrofs)(a bc c u0 e0 e1 x:float32):Prop:=
 Initialized mf b p a bc c(fp_step a bc c u0 e0 e1 x)u0 x e0 e1 /\
 WrittenBytes mf b p a bc c u0 e0 e1 x /\ Frame m mf b p /\PreservesValid m mf.
Lemma initialized_valid:forall m b p a bc c u0 u1 e0 e1 e2,Initialized m b p a bc c u0 u1 e0 e1 e2->Mem.valid_block m b.
Proof. intros m b p a bc c u0 u1 e0 e1 e2[W[L _]];eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact L|constructor]. Qed.
Lemma frame_trans:forall m m1 mf b p,Frame m m1 b p->Frame m1 mf b p->PreservesValid m m1->Frame m mf b p.
Proof. intros m m1 mf b p A B V q z n VB OUT;rewrite(B q z n(V q VB)OUT);apply A;assumption. Qed.
