From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition Args(b:block)(p:ptrofs):list val:=[Vptr b p].
Definition ReadableOut(m:mem)(b:block)(p:ptrofs)(value:float32):Prop:=
 (4|Ptrofs.unsigned p) /\ Ptrofs.unsigned p+12<=Ptrofs.modulus /\
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+8)=Some(Vsingle value).
Definition Precondition(args:list val)(m:mem):Prop:=exists b p value,args=Args b p /\ReadableOut m b p value.
Definition Frame(m mf:mem):Prop:=forall q z n,Mem.valid_block m q->Mem.loadbytes mf q z n=Mem.loadbytes m q z n.
Definition Post(m mf:mem)(b:block)(p:ptrofs)(value:float32):Prop:=ReadableOut mf b p value /\ Frame m mf.
Lemma read_out_valid:forall m b p value,ReadableOut m b p value->Mem.valid_block m b.
Proof. intros m b p value [_[_ L]];eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact L|constructor]. Qed.
Lemma out_pointer:forall m b p value,ReadableOut m b p value->
 Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr 8))=Ptrofs.unsigned p+8.
Proof. intros m b p value[AL[NW LD]];rewrite Ptrofs.add_unsigned. rewrite(Ptrofs.unsigned_repr 8 ltac:(change(0<=8<=18446744073709551615);lia)).
 apply Ptrofs.unsigned_repr;pose proof(Ptrofs.unsigned_range p);change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(0<=Ptrofs.unsigned p+8<=18446744073709551615);lia. Qed.
