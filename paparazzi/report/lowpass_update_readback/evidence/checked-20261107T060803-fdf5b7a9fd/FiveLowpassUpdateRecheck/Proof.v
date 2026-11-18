From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassUpdateCase Require Import Contract UpdateSites.
From FiveLowpassSupport Require Import LowpassMemory FieldBytes CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
Module Source:=FiveLowpassUpdate.Source.
Module Execution:=FiveLowpassUpdate.Execution.
From FiveLowpassUpdateRecheck Require Import Spec.
Require FiveLowpassUpdateFunctional.Proof.
Module Spec:=FiveLowpassUpdateRecheck.Spec.
Lemma initial_initialized:forall m b p tc li lo,Spec.Initial m b p tc li lo->Initialized m b p tc li lo.
Proof. intros m b p tc li lo [W[TC[LI LO]]];split;[exact W|].
 split;[apply encoded_load;[exact(proj2(field_access m b p 0 W ltac:(simpl;auto)))|rewrite Z.add_0_r;exact TC]|].
 split;apply encoded_load;[exact(proj2(field_access m b p 4 W ltac:(simpl;auto)))|exact LI|exact(proj2(field_access m b p 8 W ltac:(simpl;auto)))|exact LO]. Qed.
Lemma assertions:forall n,(1<=n<=3)%nat->Spec.Assertion n.
Proof.
 intros n N m b p tc li lo input INIT;pose proof(initial_initialized m b p tc li lo INIT)as P.
 split.
 - destruct(FiveLowpassUpdateFunctional.Proof.normal_completion m b p tc li lo input P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(FiveLowpassUpdateFunctional.Proof.all_returns m b p tc li lo input P t result mf PATH)as[RET[INITF[BIN[BOUT FRAME]]]].
 split;[exact RET|].
 pose proof(initialized_valid m b p tc li lo P)as VM.
 destruct INITF as[WF[TCF[LIF LOF]]].
 assert(TCB:Mem.loadbytes mf b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4)by(apply FRAME;[exact VM|right;left;lia]).
 assert(FC8:Spec.FieldCheck mf b p 8(output tc li lo input))by(split;[exact BOUT|split;[exact LOF|apply copied_bits_equal;reflexivity]]).
 assert(FC4:Spec.FieldCheck mf b p 4 input)by(split;[exact BIN|split;[exact LIF|apply copied_bits_equal;reflexivity]]).
 assert(FC0:Spec.FieldCheck mf b p 0 tc).
 { split;[rewrite Z.add_0_r,TCB;exact(proj1(proj2 INIT))|]. split;[exact TCF|apply copied_bits_equal;reflexivity]. }
 assert(C:n=1%nat\/n=2%nat\/n=3%nat)by lia;destruct C as[E|[E|E]];subst n;[exact FC8|exact FC4|split;assumption].
Qed.
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
Proof. apply assertions;unfold Spec.P_main_assertion_1;lia. Qed.
Print Assumptions prove_P_main_assertion_1.
Theorem prove_P_main_assertion_2:Spec.P_main_assertion_2.
Proof. apply assertions;unfold Spec.P_main_assertion_2;lia. Qed.
Print Assumptions prove_P_main_assertion_2.
Theorem prove_P_main_assertion_3:Spec.P_main_assertion_3.
Proof. apply assertions;unfold Spec.P_main_assertion_3;lia. Qed.
Print Assumptions prove_P_main_assertion_3.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_1:Spec.P_update_first_order_low_pass_pointer_dereference_1.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_1;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_1.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_2:Spec.P_update_first_order_low_pass_pointer_dereference_2.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_2;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_2.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_3:Spec.P_update_first_order_low_pass_pointer_dereference_3.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_3;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_3.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_4:Spec.P_update_first_order_low_pass_pointer_dereference_4.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_4;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_4.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_5:Spec.P_update_first_order_low_pass_pointer_dereference_5.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_5;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_5.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_6:Spec.P_update_first_order_low_pass_pointer_dereference_6.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_6;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_6.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_7:Spec.P_update_first_order_low_pass_pointer_dereference_7.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_7;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_7.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_8:Spec.P_update_first_order_low_pass_pointer_dereference_8.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_8;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_8.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_9:Spec.P_update_first_order_low_pass_pointer_dereference_9.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_9;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_9.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_10:Spec.P_update_first_order_low_pass_pointer_dereference_10.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_10;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_10.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_11:Spec.P_update_first_order_low_pass_pointer_dereference_11.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_11;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_11.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_12:Spec.P_update_first_order_low_pass_pointer_dereference_12.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_12;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_12.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_13:Spec.P_update_first_order_low_pass_pointer_dereference_13.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_13;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_13.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_14:Spec.P_update_first_order_low_pass_pointer_dereference_14.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_14;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_14.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_15:Spec.P_update_first_order_low_pass_pointer_dereference_15.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_15;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_15.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_16:Spec.P_update_first_order_low_pass_pointer_dereference_16.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_16;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_16.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_17:Spec.P_update_first_order_low_pass_pointer_dereference_17.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_17;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_17.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_18:Spec.P_update_first_order_low_pass_pointer_dereference_18.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_18;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_18.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_19:Spec.P_update_first_order_low_pass_pointer_dereference_19.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_19;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_19.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_20:Spec.P_update_first_order_low_pass_pointer_dereference_20.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_20;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_20.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_21:Spec.P_update_first_order_low_pass_pointer_dereference_21.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_21;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_21.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_22:Spec.P_update_first_order_low_pass_pointer_dereference_22.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_22;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_22.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_23:Spec.P_update_first_order_low_pass_pointer_dereference_23.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_23;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_23.
Theorem prove_P_update_first_order_low_pass_pointer_dereference_24:Spec.P_update_first_order_low_pass_pointer_dereference_24.
Proof. apply UpdateSites.site_properties;unfold Spec.P_update_first_order_low_pass_pointer_dereference_24;lia. Qed.
Print Assumptions prove_P_update_first_order_low_pass_pointer_dereference_24.
