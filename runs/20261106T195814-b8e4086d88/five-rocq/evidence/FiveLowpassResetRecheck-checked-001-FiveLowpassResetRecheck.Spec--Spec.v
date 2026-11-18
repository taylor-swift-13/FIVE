From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassResetCase Require Import Contract.
From FiveLowpassSupport Require Import LowpassMemory FieldBytes SourceGuards CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
Module Source:=FiveLowpassReset.Source.
Module Execution:=FiveLowpassReset.Execution.
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
Definition P_main_assertion_1:Prop:=forall m b p (value oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate(Output value)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate result Kstop mf)->result=Vsingle value /\ CopiedBitsEqualBothOrders Execution.ge value value mf).
Definition P_main_assertion_2:Prop:=forall m b p (value oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate(Output value)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate result Kstop mf)->FieldObservation Execution.ge mf b(Ptrofs.unsigned p+0)oldtc).
Definition P_main_assertion_3:Prop:=forall m b p (value oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate(Output value)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate result Kstop mf)->FieldObservation Execution.ge mf b(Ptrofs.unsigned p+4)value).
Definition P_main_assertion_4:Prop:=forall m b p (value oldtc oldin oldout:float32),Initial m b p oldtc oldin oldout->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate(Output value)Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p value)m)t(Returnstate result Kstop mf)->FieldObservation Execution.ge mf b(Ptrofs.unsigned p+8)value).
Definition P_memcpy_overflow_1:Prop:=CbmcBits.memcpy_guard_id 7%nat.
Definition P_memcpy_overflow_2:Prop:=CbmcBits.memcpy_guard_id 8%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_1:Prop:=SourceGuards.ResetProperty 1%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_2:Prop:=SourceGuards.ResetProperty 2%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_3:Prop:=SourceGuards.ResetProperty 3%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_4:Prop:=SourceGuards.ResetProperty 4%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_5:Prop:=SourceGuards.ResetProperty 5%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_6:Prop:=SourceGuards.ResetProperty 6%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_7:Prop:=SourceGuards.ResetProperty 7%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_8:Prop:=SourceGuards.ResetProperty 8%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_9:Prop:=SourceGuards.ResetProperty 9%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_10:Prop:=SourceGuards.ResetProperty 10%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_11:Prop:=SourceGuards.ResetProperty 11%nat.
Definition P_reset_first_order_low_pass_pointer_dereference_12:Prop:=SourceGuards.ResetProperty 12%nat.
