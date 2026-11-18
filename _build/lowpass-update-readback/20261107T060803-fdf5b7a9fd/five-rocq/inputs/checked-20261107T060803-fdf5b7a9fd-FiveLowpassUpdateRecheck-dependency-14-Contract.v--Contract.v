From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition Args(b:block)(p:ptrofs)(value:float32):list val:=[Vptr b p;Vsingle value].
Definition one:float32:=Float32.of_bits(Int.repr 1065353216).
Definition output(tc li lo value:float32):float32:=Float32.div (Float32.add (Float32.add value li)(Float32.mul (Float32.sub tc one) lo))(Float32.add one tc).
Definition Initialized(m:mem)(b:block)(p:ptrofs)(tc li lo:float32):Prop:=
 writable12 m b p /\ Mem.load Mfloat32 m b(Ptrofs.unsigned p+0)=Some(Vsingle tc) /\ Mem.load Mfloat32 m b(Ptrofs.unsigned p+4)=Some(Vsingle li) /\ Mem.load Mfloat32 m b(Ptrofs.unsigned p+8)=Some(Vsingle lo).
Definition Precondition(args:list val)(m:mem):Prop:=exists b p tc li lo value,args=Args b p value /\Initialized m b p tc li lo.
Definition Frame(m mf:mem)(b:block)(p:ptrofs):Prop:=forall q z n,Mem.valid_block m q->q<>b \/ z+n<=Ptrofs.unsigned p+4 \/Ptrofs.unsigned p+12<=z ->Mem.loadbytes mf q z n=Mem.loadbytes m q z n.
Definition Post(m mf:mem)(b:block)(p:ptrofs)(tc li lo value:float32):Prop:=
 Initialized mf b p tc value(output tc li lo value) /\ Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle value)) /\ Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle(output tc li lo value))) /\ Frame m mf b p.
Lemma initialized_valid:forall m b p tc li lo,Initialized m b p tc li lo->Mem.valid_block m b.
Proof. intros m b p tc li lo [W [L _]];eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact L|constructor]. Qed.
