From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassGet Require Import Source Execution.
From FiveLowpassGetCase Require Import Contract GetSites.
From FiveLowpassSupport Require Import LowpassMemory FieldBytes CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
Module Source:=FiveLowpassGet.Source.
Module Execution:=FiveLowpassGet.Execution.
Definition Initial(m:mem)(b:block)(p:ptrofs)(tc vi vo:float32):Prop:=
 writable12 m b p /\
 Mem.loadbytes m b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle tc)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle vi)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle vo)).
Definition FieldCheck(m mf:mem)(b:block)(p:ptrofs)(delta:Z)(v:float32):Prop:=
 Mem.loadbytes mf b(Ptrofs.unsigned p+delta)4=Mem.loadbytes m b(Ptrofs.unsigned p+delta)4 /\
 Mem.load Mfloat32 mf b(Ptrofs.unsigned p+delta)=Some(Vsingle v) /\
 CopiedBitsEqualBothOrders Execution.ge v v mf.
Definition P_memcpy_pointer_arithmetic_1:Prop:=CbmcBits.memcpy_guard_id 3%nat.
Definition P_memcpy_pointer_1:Prop:=CbmcBits.memcpy_guard_id 1%nat.
Definition P_memcpy_pointer_arithmetic_2:Prop:=CbmcBits.memcpy_guard_id 2%nat.
Definition P_memcpy_pointer_arithmetic_3:Prop:=CbmcBits.memcpy_guard_id 6%nat.
Definition P_memcpy_pointer_2:Prop:=CbmcBits.memcpy_guard_id 4%nat.
Definition P_memcpy_pointer_arithmetic_4:Prop:=CbmcBits.memcpy_guard_id 5%nat.
Definition P_bits_precondition_instance_1:Prop:=CbmcBits.bits_guard_id 1%nat.
Definition P_bits_precondition_instance_2:Prop:=CbmcBits.bits_guard_id 2%nat.
Definition P_bits_precondition_instance_3:Prop:=CbmcBits.bits_guard_id 3%nat.
Definition P_get_first_order_low_pass_pointer_dereference_1:Prop:=GetSites.SiteProperty 0%nat.
Definition P_get_first_order_low_pass_pointer_dereference_2:Prop:=GetSites.SiteProperty 1%nat.
Definition P_get_first_order_low_pass_pointer_dereference_3:Prop:=GetSites.SiteProperty 2%nat.
Definition P_get_first_order_low_pass_pointer_dereference_4:Prop:=GetSites.SiteProperty 3%nat.
Definition P_get_first_order_low_pass_pointer_dereference_5:Prop:=GetSites.SiteProperty 4%nat.
Definition P_get_first_order_low_pass_pointer_dereference_6:Prop:=GetSites.SiteProperty 5%nat.
Definition P_main_assertion_1:Prop:=forall m b p tc vi vo,Initial m b p tc vi vo->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate(Vsingle vo)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate result Kstop mf)->result=Vsingle vo /\ CopiedBitsEqualBothOrders Execution.ge vo vo mf).
Definition P_main_assertion_2:Prop:=forall m b p tc vi vo,Initial m b p tc vi vo->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate(Vsingle vo)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate result Kstop mf)->FieldCheck m mf b p 0 tc).
Definition P_main_assertion_3:Prop:=forall m b p tc vi vo,Initial m b p tc vi vo->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate(Vsingle vo)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate result Kstop mf)->FieldCheck m mf b p 4 vi).
Definition P_main_assertion_4:Prop:=forall m b p tc vi vo,Initial m b p tc vi vo->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate(Vsingle vo)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p)m)t(Returnstate result Kstop mf)->FieldCheck m mf b p 8 vo).
