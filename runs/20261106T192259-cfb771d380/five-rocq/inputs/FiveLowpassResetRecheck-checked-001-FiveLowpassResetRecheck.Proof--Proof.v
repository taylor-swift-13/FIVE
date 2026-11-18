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
From FiveLowpassResetRecheck Require Import Spec.
Require FiveLowpassResetFunctional.Proof.
Theorem prove_P_memcpy_pointer_1:Spec.P_memcpy_pointer_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_1;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_1.
Theorem prove_P_memcpy_pointer_arithmetic_1:Spec.P_memcpy_pointer_arithmetic_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_1;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_1.
Theorem prove_P_memcpy_pointer_arithmetic_2:Spec.P_memcpy_pointer_arithmetic_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_2;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_2.
Theorem prove_P_memcpy_pointer_2:Spec.P_memcpy_pointer_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_2;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_2.
Theorem prove_P_memcpy_pointer_arithmetic_3:Spec.P_memcpy_pointer_arithmetic_3.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_3;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_3.
Theorem prove_P_memcpy_pointer_arithmetic_4:Spec.P_memcpy_pointer_arithmetic_4.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_4;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_4.
Theorem prove_P_bits_precondition_instance_1:Spec.P_bits_precondition_instance_1.
Proof. apply CbmcBits.bits_guards;unfold Spec.P_bits_precondition_instance_1;lia. Qed.
Print Assumptions prove_P_bits_precondition_instance_1.
Theorem prove_P_bits_precondition_instance_2:Spec.P_bits_precondition_instance_2.
Proof. apply CbmcBits.bits_guards;unfold Spec.P_bits_precondition_instance_2;lia. Qed.
Print Assumptions prove_P_bits_precondition_instance_2.
Theorem prove_P_bits_precondition_instance_3:Spec.P_bits_precondition_instance_3.
Proof. apply CbmcBits.bits_guards;unfold Spec.P_bits_precondition_instance_3;lia. Qed.
Print Assumptions prove_P_bits_precondition_instance_3.
Theorem prove_P_main_assertion_1:Spec.P_main_assertion_1.
Proof.
 unfold Spec.P_main_assertion_1;intros m b p value oldtc oldin oldout[P[O0[O4 O8]]];split.
 - destruct(FiveLowpassResetFunctional.Proof.normal_completion m b p value P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassResetFunctional.Proof.all_returns m b p value P t result mf PATH)as[RET[PMF[BYTES FRAME]]].
 split;[exact RET|apply copied_bits_equal;reflexivity].
Qed.
Print Assumptions prove_P_main_assertion_1.
Theorem prove_P_main_assertion_2:Spec.P_main_assertion_2.
Proof.
 unfold Spec.P_main_assertion_2;intros m b p value oldtc oldin oldout[P[O0[O4 O8]]];split.
 - destruct(FiveLowpassResetFunctional.Proof.normal_completion m b p value P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassResetFunctional.Proof.all_returns m b p value P t result mf PATH)as[RET[PMF[BYTES FRAME]]].
 apply(field_observation Execution.ge mf b p 0 oldtc PMF ltac:(simpl;auto)).
 assert(VB:Mem.valid_block m b).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply field_access;[exact P|simpl;auto]|constructor]. }
 rewrite(FRAME b(Ptrofs.unsigned p+0)4 VB ltac:(right;left;lia)).
rewrite Z.add_0_r;exact O0.
Qed.
Print Assumptions prove_P_main_assertion_2.
Theorem prove_P_main_assertion_3:Spec.P_main_assertion_3.
Proof.
 unfold Spec.P_main_assertion_3;intros m b p value oldtc oldin oldout[P[O0[O4 O8]]];split.
 - destruct(FiveLowpassResetFunctional.Proof.normal_completion m b p value P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassResetFunctional.Proof.all_returns m b p value P t result mf PATH)as[RET[PMF[BYTES FRAME]]].
 apply(field_observation Execution.ge mf b p 4 value PMF ltac:(simpl;auto)).
 destruct(encoded_two mf b(Ptrofs.unsigned p+4)value value BYTES)as[L4 L8];exact L4.
Qed.
Print Assumptions prove_P_main_assertion_3.
Theorem prove_P_main_assertion_4:Spec.P_main_assertion_4.
Proof.
 unfold Spec.P_main_assertion_4;intros m b p value oldtc oldin oldout[P[O0[O4 O8]]];split.
 - destruct(FiveLowpassResetFunctional.Proof.normal_completion m b p value P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassResetFunctional.Proof.all_returns m b p value P t result mf PATH)as[RET[PMF[BYTES FRAME]]].
 apply(field_observation Execution.ge mf b p 8 value PMF ltac:(simpl;auto)).
 destruct(encoded_two mf b(Ptrofs.unsigned p+4)value value BYTES)as[L4 L8];replace(Ptrofs.unsigned p+4+4)with(Ptrofs.unsigned p+8)in L8 by lia;exact L8.
Qed.
Print Assumptions prove_P_main_assertion_4.
Theorem prove_P_memcpy_overflow_1:Spec.P_memcpy_overflow_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_overflow_1;lia. Qed.
Print Assumptions prove_P_memcpy_overflow_1.
Theorem prove_P_memcpy_overflow_2:Spec.P_memcpy_overflow_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_overflow_2;lia. Qed.
Print Assumptions prove_P_memcpy_overflow_2.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_1:Spec.P_reset_first_order_low_pass_pointer_dereference_1.
Proof. exact SourceGuards.reset_source_property_01. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_1.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_2:Spec.P_reset_first_order_low_pass_pointer_dereference_2.
Proof. exact SourceGuards.reset_source_property_02. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_2.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_3:Spec.P_reset_first_order_low_pass_pointer_dereference_3.
Proof. exact SourceGuards.reset_source_property_03. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_3.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_4:Spec.P_reset_first_order_low_pass_pointer_dereference_4.
Proof. exact SourceGuards.reset_source_property_04. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_4.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_5:Spec.P_reset_first_order_low_pass_pointer_dereference_5.
Proof. exact SourceGuards.reset_source_property_05. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_5.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_6:Spec.P_reset_first_order_low_pass_pointer_dereference_6.
Proof. exact SourceGuards.reset_source_property_06. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_6.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_7:Spec.P_reset_first_order_low_pass_pointer_dereference_7.
Proof. exact SourceGuards.reset_source_property_07. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_7.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_8:Spec.P_reset_first_order_low_pass_pointer_dereference_8.
Proof. exact SourceGuards.reset_source_property_08. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_8.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_9:Spec.P_reset_first_order_low_pass_pointer_dereference_9.
Proof. exact SourceGuards.reset_source_property_09. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_9.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_10:Spec.P_reset_first_order_low_pass_pointer_dereference_10.
Proof. exact SourceGuards.reset_source_property_10. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_10.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_11:Spec.P_reset_first_order_low_pass_pointer_dereference_11.
Proof. exact SourceGuards.reset_source_property_11. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_11.
Theorem prove_P_reset_first_order_low_pass_pointer_dereference_12:Spec.P_reset_first_order_low_pass_pointer_dereference_12.
Proof. exact SourceGuards.reset_source_property_12. Qed.
Print Assumptions prove_P_reset_first_order_low_pass_pointer_dereference_12.
