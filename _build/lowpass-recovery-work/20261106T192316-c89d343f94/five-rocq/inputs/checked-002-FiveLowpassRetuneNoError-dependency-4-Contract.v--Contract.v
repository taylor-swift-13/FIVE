From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassSupport Require Import LowpassMemory.
From FiveLowpassRetune Require Import Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition coefficient(tau h:float32):float32:=Float32.div(Float32.mul(Float32.of_bits(Int.repr 1073741824))tau)h.
Definition Args(b:block)(p:ptrofs)(tau h:float32):list val:=[Vptr b p;Vsingle tau;Vsingle h].
Definition Output(tau h:float32):val:=Vundef.
Definition Precondition(args:list val)(m:mem):Prop:=exists(b:block)(p:ptrofs)(tau h:float32),args=Args b p tau h /\ writable12 m b p.
Definition Post(m mf:mem)(b:block)(p:ptrofs)(tau h:float32):Prop:=
 writable12 mf b p /\ Mem.loadbytes mf b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle(coefficient tau h))) /\
 (forall q z n,Mem.valid_block m q -> q<>b \/ z+n<=Ptrofs.unsigned p \/ Ptrofs.unsigned p+4<=z ->Mem.loadbytes mf q z n=Mem.loadbytes m q z n).
