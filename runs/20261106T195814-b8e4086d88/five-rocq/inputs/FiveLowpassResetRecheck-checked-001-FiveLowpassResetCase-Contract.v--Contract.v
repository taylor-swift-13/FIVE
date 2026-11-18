From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassSupport Require Import LowpassMemory.
From FiveLowpassReset Require Import Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition coefficient(tau h:float32):float32:=Float32.div(Float32.mul(Float32.of_bits(Int.repr 1073741824))tau)h.
Definition Args(b:block)(p:ptrofs)(value:float32):list val:=[Vptr b p;Vsingle value].
Definition Output(value:float32):val:=Vsingle value.
Definition Precondition(args:list val)(m:mem):Prop:=exists(b:block)(p:ptrofs)(value:float32),args=Args b p value /\ writable12 m b p.
Definition Post(m mf:mem)(b:block)(p:ptrofs)(value:float32):Prop:=
 writable12 mf b p /\ Mem.loadbytes mf b(Ptrofs.unsigned p+4)8=Some(encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value)) /\
 (forall q z n,Mem.valid_block m q -> q<>b \/ z+n<=Ptrofs.unsigned p+4 \/ Ptrofs.unsigned p+12<=z ->Mem.loadbytes mf q z n=Mem.loadbytes m q z n).
