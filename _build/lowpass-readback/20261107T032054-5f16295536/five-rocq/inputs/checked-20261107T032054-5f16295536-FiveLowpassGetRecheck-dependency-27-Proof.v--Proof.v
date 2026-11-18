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
From FiveLowpassGetRecheck Require Import Spec.
Require FiveLowpassGetFunctional.Proof.
Lemma initial_read:forall m b p tc vi vo,Spec.Initial m b p tc vi vo->ReadableOut m b p vo.
Proof. intros m b p tc vi vo[P[TC[VI VO]]];destruct P as[AL[NW RP]];repeat split;auto.
 apply encoded_load;[destruct AL as[k K];exists(k+2);lia|exact VO]. Qed.
Lemma object_valid:forall m b p,writable12 m b p->Mem.valid_block m b.
Proof. intros;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[apply(field_access m b p 8 H ltac:(simpl;auto))|constructor]. Qed.
Theorem prove_P_memcpy_pointer_arithmetic_1:Spec.P_memcpy_pointer_arithmetic_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_1;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_1.
Theorem prove_P_memcpy_pointer_1:Spec.P_memcpy_pointer_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_1;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_1.
Theorem prove_P_memcpy_pointer_arithmetic_2:Spec.P_memcpy_pointer_arithmetic_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_2;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_2.
Theorem prove_P_memcpy_pointer_arithmetic_3:Spec.P_memcpy_pointer_arithmetic_3.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_arithmetic_3;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_arithmetic_3.
Theorem prove_P_memcpy_pointer_2:Spec.P_memcpy_pointer_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.P_memcpy_pointer_2;lia. Qed.
Print Assumptions prove_P_memcpy_pointer_2.
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
Theorem prove_P_get_first_order_low_pass_pointer_dereference_1:Spec.P_get_first_order_low_pass_pointer_dereference_1.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_1;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_1.
Theorem prove_P_get_first_order_low_pass_pointer_dereference_2:Spec.P_get_first_order_low_pass_pointer_dereference_2.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_2;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_2.
Theorem prove_P_get_first_order_low_pass_pointer_dereference_3:Spec.P_get_first_order_low_pass_pointer_dereference_3.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_3;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_3.
Theorem prove_P_get_first_order_low_pass_pointer_dereference_4:Spec.P_get_first_order_low_pass_pointer_dereference_4.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_4;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_4.
Theorem prove_P_get_first_order_low_pass_pointer_dereference_5:Spec.P_get_first_order_low_pass_pointer_dereference_5.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_5;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_5.
Theorem prove_P_get_first_order_low_pass_pointer_dereference_6:Spec.P_get_first_order_low_pass_pointer_dereference_6.
Proof. apply GetSites.site_properties;unfold Spec.P_get_first_order_low_pass_pointer_dereference_6;lia. Qed.
Print Assumptions prove_P_get_first_order_low_pass_pointer_dereference_6.
Theorem prove_P_main_assertion_1:Spec.P_main_assertion_1.
Proof. unfold Spec.P_main_assertion_1;intros m b p tc vi vo INI;pose proof(initial_read m b p tc vi vo INI)as R;destruct INI as[P[TC[VI VO]]];split.
 - destruct(FiveLowpassGetFunctional.Proof.normal_completion m b p vo R)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassGetFunctional.Proof.all_returns m b p vo R t result mf PATH)as[RET[RF FRAME]].
split;[exact RET|apply copied_bits_equal;reflexivity]. Qed.
Print Assumptions prove_P_main_assertion_1.
Theorem prove_P_main_assertion_2:Spec.P_main_assertion_2.
Proof. unfold Spec.P_main_assertion_2;intros m b p tc vi vo INI;pose proof(initial_read m b p tc vi vo INI)as R;destruct INI as[P[TC[VI VO]]];split.
 - destruct(FiveLowpassGetFunctional.Proof.normal_completion m b p vo R)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassGetFunctional.Proof.all_returns m b p vo R t result mf PATH)as[RET[RF FRAME]].
unfold Spec.FieldCheck;split;[apply FRAME;exact(object_valid m b p P)|]. split;[|apply copied_bits_equal;reflexivity].
 apply encoded_load.
 + exact(proj2(field_access m b p 0 P ltac:(simpl;auto))).
 + rewrite FRAME by exact(object_valid m b p P). rewrite Z.add_0_r; exact TC. Qed.
Print Assumptions prove_P_main_assertion_2.
Theorem prove_P_main_assertion_3:Spec.P_main_assertion_3.
Proof. unfold Spec.P_main_assertion_3;intros m b p tc vi vo INI;pose proof(initial_read m b p tc vi vo INI)as R;destruct INI as[P[TC[VI VO]]];split.
 - destruct(FiveLowpassGetFunctional.Proof.normal_completion m b p vo R)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassGetFunctional.Proof.all_returns m b p vo R t result mf PATH)as[RET[RF FRAME]].
unfold Spec.FieldCheck;split;[apply FRAME;exact(object_valid m b p P)|]. split;[|apply copied_bits_equal;reflexivity].
 apply encoded_load.
 + exact(proj2(field_access m b p 4 P ltac:(simpl;auto))).
 + rewrite FRAME by exact(object_valid m b p P). exact VI. Qed.
Print Assumptions prove_P_main_assertion_3.
Theorem prove_P_main_assertion_4:Spec.P_main_assertion_4.
Proof. unfold Spec.P_main_assertion_4;intros m b p tc vi vo INI;pose proof(initial_read m b p tc vi vo INI)as R;destruct INI as[P[TC[VI VO]]];split.
 - destruct(FiveLowpassGetFunctional.Proof.normal_completion m b p vo R)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassGetFunctional.Proof.all_returns m b p vo R t result mf PATH)as[RET[RF FRAME]].
unfold Spec.FieldCheck;split;[apply FRAME;exact(object_valid m b p P)|]. split;[|apply copied_bits_equal;reflexivity].
 apply encoded_load.
 + exact(proj2(field_access m b p 8 P ltac:(simpl;auto))).
 + rewrite FRAME by exact(object_valid m b p P). exact VO. Qed.
Print Assumptions prove_P_main_assertion_4.
