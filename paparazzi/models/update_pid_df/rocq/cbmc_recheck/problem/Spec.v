From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory Contract UpdateCall UpdateSites.
From FiveLowpassSupport Require Import FieldBytes CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
Definition Initial(m:mem)(b:block)(p:ptrofs)(a bc c u0 u1 e0 e1 e2:float32):Prop:=
 writable32 m b p /\
 Mem.loadbytes m b(Ptrofs.unsigned p+0)4=Some(encode_val Mfloat32(Vsingle u0)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle u1)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle e0)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+12)4=Some(encode_val Mfloat32(Vsingle e1)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+16)4=Some(encode_val Mfloat32(Vsingle e2)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+20)4=Some(encode_val Mfloat32(Vsingle a)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+24)4=Some(encode_val Mfloat32(Vsingle bc)) /\
 Mem.loadbytes m b(Ptrofs.unsigned p+28)4=Some(encode_val Mfloat32(Vsingle c)).
Definition FieldCheck(mf:mem)(b:block)(p:ptrofs)(delta:Z)(v:float32):Prop:=
 Mem.loadbytes mf b(Ptrofs.unsigned p+delta)4=Some(encode_val Mfloat32(Vsingle v)) /\
 Mem.load Mfloat32 mf b(Ptrofs.unsigned p+delta)=Some(Vsingle v) /\
 CopiedBitsEqualBothOrders Execution.ge v v mf.
Definition Assertion(n:nat):Prop:=forall m b p a bc c u0 u1 e0 e1 e2 input,Initial m b p a bc c u0 u1 e0 e1 e2->
 (exists t mf,star Csem.step Execution.ge(Execution.entry(Args b p input)m)t(Returnstate(Vsingle(fp_step a bc c u0 e0 e1 input))Kstop mf)) /\
 (forall t result mf,star Csem.step Execution.ge(Execution.entry(Args b p input)m)t(Returnstate result Kstop mf)->
 result=Vsingle(fp_step a bc c u0 e0 e1 input) /\
 match n with
 |1%nat=>FieldCheck mf b p 0(fp_step a bc c u0 e0 e1 input)
 |2%nat=>FieldCheck mf b p 4 u0
 |3%nat=>FieldCheck mf b p 8 input
 |4%nat=>FieldCheck mf b p 12 e0
 |5%nat=>FieldCheck mf b p 16 e1
 |6%nat=>FieldCheck mf b p 20 a /\Mem.loadbytes mf b(Ptrofs.unsigned p+20)4=Mem.loadbytes m b(Ptrofs.unsigned p+20)4
 |7%nat=>FieldCheck mf b p 24 bc /\Mem.loadbytes mf b(Ptrofs.unsigned p+24)4=Mem.loadbytes m b(Ptrofs.unsigned p+24)4
 |8%nat=>FieldCheck mf b p 28 c /\Mem.loadbytes mf b(Ptrofs.unsigned p+28)4=Mem.loadbytes m b(Ptrofs.unsigned p+28)4
 |_=>False end).
(* Actual CBMC property: memcpy.pointer_arithmetic.1; source line 33. *)
Definition Property_1:Prop:=CbmcBits.memcpy_guard_id 3%nat.
(* Actual CBMC property: memcpy.pointer.1; source line 33. *)
Definition Property_2:Prop:=CbmcBits.memcpy_guard_id 1%nat.
(* Actual CBMC property: memcpy.pointer_arithmetic.2; source line 33. *)
Definition Property_3:Prop:=CbmcBits.memcpy_guard_id 2%nat.
(* Actual CBMC property: memcpy.pointer_arithmetic.3; source line 34. *)
Definition Property_4:Prop:=CbmcBits.memcpy_guard_id 6%nat.
(* Actual CBMC property: memcpy.pointer.2; source line 34. *)
Definition Property_5:Prop:=CbmcBits.memcpy_guard_id 4%nat.
(* Actual CBMC property: memcpy.pointer_arithmetic.4; source line 34. *)
Definition Property_6:Prop:=CbmcBits.memcpy_guard_id 5%nat.
(* Actual CBMC property: bits.precondition_instance.1; source line 5. *)
Definition Property_7:Prop:=CbmcBits.bits_guard_id 1%nat.
(* Actual CBMC property: bits.precondition_instance.2; source line 5. *)
Definition Property_8:Prop:=CbmcBits.bits_guard_id 2%nat.
(* Actual CBMC property: bits.precondition_instance.3; source line 5. *)
Definition Property_9:Prop:=CbmcBits.bits_guard_id 3%nat.
(* Actual CBMC property: main.assertion.1; source line 13. *)
Definition Property_10:Prop:=Assertion 1%nat.
(* Actual CBMC property: main.assertion.2; source line 14. *)
Definition Property_11:Prop:=Assertion 2%nat.
(* Actual CBMC property: main.assertion.3; source line 15. *)
Definition Property_12:Prop:=Assertion 3%nat.
(* Actual CBMC property: main.assertion.4; source line 16. *)
Definition Property_13:Prop:=Assertion 4%nat.
(* Actual CBMC property: main.assertion.5; source line 17. *)
Definition Property_14:Prop:=Assertion 5%nat.
(* Actual CBMC property: main.assertion.6; source line 18. *)
Definition Property_15:Prop:=Assertion 6%nat.
(* Actual CBMC property: main.assertion.7; source line 19. *)
Definition Property_16:Prop:=Assertion 7%nat.
(* Actual CBMC property: main.assertion.8; source line 20. *)
Definition Property_17:Prop:=Assertion 8%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.1; source line 9. *)
Definition Property_18:Prop:=UpdateSites.PointerProperty 0%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.2; source line 9. *)
Definition Property_19:Prop:=UpdateSites.PointerProperty 0%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.3; source line 9. *)
Definition Property_20:Prop:=UpdateSites.PointerProperty 0%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.4; source line 9. *)
Definition Property_21:Prop:=UpdateSites.PointerProperty 0%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.5; source line 9. *)
Definition Property_22:Prop:=UpdateSites.PointerProperty 0%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.6; source line 9. *)
Definition Property_23:Prop:=UpdateSites.PointerProperty 0%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.1; source line 9. *)
Definition Property_24:Prop:=UpdateSites.ArrayProperty 0%nat.
(* Actual CBMC property: update_pid_df.array_bounds.2; source line 9. *)
Definition Property_25:Prop:=UpdateSites.ArrayProperty 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.7; source line 10. *)
Definition Property_26:Prop:=UpdateSites.PointerProperty 1%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.8; source line 10. *)
Definition Property_27:Prop:=UpdateSites.PointerProperty 1%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.9; source line 10. *)
Definition Property_28:Prop:=UpdateSites.PointerProperty 1%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.10; source line 10. *)
Definition Property_29:Prop:=UpdateSites.PointerProperty 1%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.11; source line 10. *)
Definition Property_30:Prop:=UpdateSites.PointerProperty 1%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.12; source line 10. *)
Definition Property_31:Prop:=UpdateSites.PointerProperty 1%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.3; source line 10. *)
Definition Property_32:Prop:=UpdateSites.ArrayProperty 2%nat.
(* Actual CBMC property: update_pid_df.array_bounds.4; source line 10. *)
Definition Property_33:Prop:=UpdateSites.ArrayProperty 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.13; source line 11. *)
Definition Property_34:Prop:=UpdateSites.PointerProperty 2%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.14; source line 11. *)
Definition Property_35:Prop:=UpdateSites.PointerProperty 2%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.15; source line 11. *)
Definition Property_36:Prop:=UpdateSites.PointerProperty 2%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.16; source line 11. *)
Definition Property_37:Prop:=UpdateSites.PointerProperty 2%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.17; source line 11. *)
Definition Property_38:Prop:=UpdateSites.PointerProperty 2%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.18; source line 11. *)
Definition Property_39:Prop:=UpdateSites.PointerProperty 2%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.5; source line 11. *)
Definition Property_40:Prop:=UpdateSites.ArrayProperty 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.19; source line 12. *)
Definition Property_41:Prop:=UpdateSites.PointerProperty 3%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.20; source line 12. *)
Definition Property_42:Prop:=UpdateSites.PointerProperty 3%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.21; source line 12. *)
Definition Property_43:Prop:=UpdateSites.PointerProperty 3%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.22; source line 12. *)
Definition Property_44:Prop:=UpdateSites.PointerProperty 3%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.23; source line 12. *)
Definition Property_45:Prop:=UpdateSites.PointerProperty 3%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.24; source line 12. *)
Definition Property_46:Prop:=UpdateSites.PointerProperty 3%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.6; source line 12. *)
Definition Property_47:Prop:=UpdateSites.ArrayProperty 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.7; source line 12. *)
Definition Property_48:Prop:=UpdateSites.ArrayProperty 6%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.25; source line 13. *)
Definition Property_49:Prop:=UpdateSites.PointerProperty 4%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.26; source line 13. *)
Definition Property_50:Prop:=UpdateSites.PointerProperty 4%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.27; source line 13. *)
Definition Property_51:Prop:=UpdateSites.PointerProperty 4%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.28; source line 13. *)
Definition Property_52:Prop:=UpdateSites.PointerProperty 4%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.29; source line 13. *)
Definition Property_53:Prop:=UpdateSites.PointerProperty 4%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.30; source line 13. *)
Definition Property_54:Prop:=UpdateSites.PointerProperty 4%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.8; source line 13. *)
Definition Property_55:Prop:=UpdateSites.ArrayProperty 7%nat.
(* Actual CBMC property: update_pid_df.array_bounds.9; source line 13. *)
Definition Property_56:Prop:=UpdateSites.ArrayProperty 8%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.31; source line 13. *)
Definition Property_57:Prop:=UpdateSites.PointerProperty 5%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.32; source line 13. *)
Definition Property_58:Prop:=UpdateSites.PointerProperty 5%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.33; source line 13. *)
Definition Property_59:Prop:=UpdateSites.PointerProperty 5%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.34; source line 13. *)
Definition Property_60:Prop:=UpdateSites.PointerProperty 5%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.35; source line 13. *)
Definition Property_61:Prop:=UpdateSites.PointerProperty 5%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.36; source line 13. *)
Definition Property_62:Prop:=UpdateSites.PointerProperty 5%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.10; source line 13. *)
Definition Property_63:Prop:=UpdateSites.ArrayProperty 9%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.37; source line 13. *)
Definition Property_64:Prop:=UpdateSites.PointerProperty 6%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.38; source line 13. *)
Definition Property_65:Prop:=UpdateSites.PointerProperty 6%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.39; source line 13. *)
Definition Property_66:Prop:=UpdateSites.PointerProperty 6%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.40; source line 13. *)
Definition Property_67:Prop:=UpdateSites.PointerProperty 6%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.41; source line 13. *)
Definition Property_68:Prop:=UpdateSites.PointerProperty 6%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.42; source line 13. *)
Definition Property_69:Prop:=UpdateSites.PointerProperty 6%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.11; source line 13. *)
Definition Property_70:Prop:=UpdateSites.ArrayProperty 10%nat.
(* Actual CBMC property: update_pid_df.array_bounds.12; source line 13. *)
Definition Property_71:Prop:=UpdateSites.ArrayProperty 11%nat.
(* Actual CBMC property: update_pid_df.array_bounds.13; source line 13. *)
Definition Property_72:Prop:=UpdateSites.ArrayProperty 12%nat.
(* Actual CBMC property: update_pid_df.array_bounds.14; source line 13. *)
Definition Property_73:Prop:=UpdateSites.ArrayProperty 13%nat.
(* Actual CBMC property: update_pid_df.array_bounds.15; source line 13. *)
Definition Property_74:Prop:=UpdateSites.ArrayProperty 14%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.43; source line 14. *)
Definition Property_75:Prop:=UpdateSites.PointerProperty 7%nat 0%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.44; source line 14. *)
Definition Property_76:Prop:=UpdateSites.PointerProperty 7%nat 1%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.45; source line 14. *)
Definition Property_77:Prop:=UpdateSites.PointerProperty 7%nat 2%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.46; source line 14. *)
Definition Property_78:Prop:=UpdateSites.PointerProperty 7%nat 3%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.47; source line 14. *)
Definition Property_79:Prop:=UpdateSites.PointerProperty 7%nat 4%nat.
(* Actual CBMC property: update_pid_df.pointer_dereference.48; source line 14. *)
Definition Property_80:Prop:=UpdateSites.PointerProperty 7%nat 5%nat.
(* Actual CBMC property: update_pid_df.array_bounds.16; source line 14. *)
Definition Property_81:Prop:=UpdateSites.ArrayProperty 15%nat.
