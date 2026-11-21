From Stdlib Require Import Bool.
From compcert Require Import Ctypes Csyntax Csyntaxdefs Cop.
From PidPositionRunPos Require Import Source.
From PidPositionTranslationCore Require Import CoreClamp.
From PidPositionSafety Require Import EntryOverflowGoal EntryOverflowProof.
Definition entry_source_assignment(n:nat):statement:=
 let pair:=top_statement(match n with 0|1=>0|_=>2 end)(fn_body Source.f_guidance_pid_h_run_pos)in
 match pair with Ssequence a b=>match n with 0|4=>a|_=>b end|_=>Sskip end.
Definition entry_source_signed_subtraction(n:nat):bool:=
 match entry_source_assignment n with
 | Sdo(Eassign _ (Ebinop Osub aa bb result) target)=>
   (if Ctypes.type_eq(typeof aa)tint then true else false)&&
   (if Ctypes.type_eq(typeof bb)tint then true else false)&&
   (if Ctypes.type_eq result tint then true else false)&&
   (if Ctypes.type_eq target tint then true else false)
 | _=>false end.
Definition EntryMappedOverflow1Goal:Prop:=entry_source_signed_subtraction 0=true /\EntryOverflow1Goal.
Definition EntryMappedOverflow2Goal:Prop:=entry_source_signed_subtraction 1=true /\EntryOverflow2Goal.
Definition EntryMappedOverflow3Goal:Prop:=entry_source_signed_subtraction 4=true /\EntryOverflow3Goal.
Definition EntryMappedOverflow4Goal:Prop:=entry_source_signed_subtraction 5=true /\EntryOverflow4Goal.
Theorem entry_mapped_overflow_1:EntryMappedOverflow1Goal.
Proof. split;[reflexivity|exact original_entry_overflow_1]. Qed.
Theorem entry_mapped_overflow_2:EntryMappedOverflow2Goal.
Proof. split;[reflexivity|exact original_entry_overflow_2]. Qed.
Theorem entry_mapped_overflow_3:EntryMappedOverflow3Goal.
Proof. split;[reflexivity|exact original_entry_overflow_3]. Qed.
Theorem entry_mapped_overflow_4:EntryMappedOverflow4Goal.
Proof. split;[reflexivity|exact original_entry_overflow_4]. Qed.
Print Assumptions entry_mapped_overflow_1.
