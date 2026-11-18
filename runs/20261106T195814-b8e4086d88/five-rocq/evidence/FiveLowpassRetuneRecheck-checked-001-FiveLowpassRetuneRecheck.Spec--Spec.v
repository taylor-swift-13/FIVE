From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassRetune Require Import Source Execution.
From FiveLowpassRetuneCase Require Import Contract.
From FiveLowpassSupport Require Import LowpassMemory FieldBytes SourceGuards CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
Module Source:=FiveLowpassRetune.Source.
Module Execution:=FiveLowpassRetune.Execution.
Definition Initial(m:mem)(b:block)(p:ptrofs)(oldtc oldin oldout:float32):Prop:=
 writable12 m b p /\
 Mem.loadbytes m b(Ptrofs.unsigned p)4=Some(encode_val Mfloat32(Vsingle oldtc)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle oldin)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle oldout)).
Definition P_memcpy_pointer_1:Prop:=CbmcBits.memcpy_guard_id 1%nat.
Definition P_memcpy_pointer_arithmetic_1:Prop:=CbmcBits.memcpy_guard_id 2%nat.
Definition P_memcpy_pointer_arithmetic_2:Prop:=CbmcBits.memcpy_guard_id 3%nat.
Definition P_memcpy_pointer_2:Prop:=CbmcBits.memcpy_guard_id 4%nat.
Definition P_memcpy_pointer_arithmetic_3:Prop:=CbmcBits.memcpy_guard_id 5%nat.
Definition P_memcpy_pointer_arithmetic_4:Prop:=CbmcBits.memcpy_guard_id 6%nat.
Definition P_bits_precondition_instance_1:Prop:=CbmcBits.bits_guard_id 1%nat.
Definition P_bits_precondition_instance_2:Prop:=CbmcBits.bits_guard_id 2%nat.
Definition P_bits_precondition_instance_3:Prop:=CbmcBits.bits_guard_id 3%nat.
Definition P_main_assertion_1:Prop:=forall m b p (tau h oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate(Output tau h)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate result Kstop mf)->FieldObservation Execution.ge mf b(Ptrofs.unsigned p+4)oldin).
Definition P_main_assertion_2:Prop:=forall m b p (tau h oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate(Output tau h)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p tau h)m)t(Returnstate result Kstop mf)->FieldObservation Execution.ge mf b(Ptrofs.unsigned p+8)oldout).
Definition P_memcpy_overflow_1:Prop:=CbmcBits.memcpy_guard_id 7%nat.
Definition P_memcpy_overflow_2:Prop:=CbmcBits.memcpy_guard_id 8%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_1:Prop:=SourceGuards.RetuneProperty 1%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_2:Prop:=SourceGuards.RetuneProperty 2%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_3:Prop:=SourceGuards.RetuneProperty 3%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_4:Prop:=SourceGuards.RetuneProperty 4%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_5:Prop:=SourceGuards.RetuneProperty 5%nat.
Definition P_update_first_order_low_pass_tau_pointer_dereference_6:Prop:=SourceGuards.RetuneProperty 6%nat.
