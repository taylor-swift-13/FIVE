From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata.
From FiveMatInv3Case Require Export MatrixMemory Scalar.
Import ListNotations.
Definition Args(bo bi:block)(po pi:ptrofs):list val:=[Vptr bo po;Vptr bi pi].
Definition FunctionalPre(args:list val)(m:mem):Prop:=exists bo bi po pi f,args=Args bo bi po pi /\ bo<>bi /\ WriteRegion m bo po 9 /\ Reads m bi pi 9 f.
Definition Frame(m mf:mem)(bo:block)(po:ptrofs):Prop:=forall b z n,Mem.valid_block m b->b<>bo \/ z+n<=Ptrofs.unsigned po \/ Ptrofs.unsigned po+36<=z->Mem.loadbytes mf b z n=Mem.loadbytes m b z n.
Definition OutputBytes(m mf:mem)(bo:block)(po:ptrofs)(f:Z->float32):Prop:=
 if Accept f then forall i,0<=i<9->Mem.loadbytes mf bo(Ptrofs.unsigned po+4*i)4=Some(encode_val Mfloat32(Vsingle(Output f i)))
 else Mem.loadbytes mf bo(Ptrofs.unsigned po)36=Mem.loadbytes m bo(Ptrofs.unsigned po)36.
Definition OldBlocks(m mf:mem):Prop:=forall b,Mem.valid_block m b->Mem.valid_block mf b.
Definition OldAccess(m mf:mem):Prop:=forall ch b z p,Mem.valid_block m b->Mem.valid_access m ch b z p->Mem.valid_access mf ch b z p.
