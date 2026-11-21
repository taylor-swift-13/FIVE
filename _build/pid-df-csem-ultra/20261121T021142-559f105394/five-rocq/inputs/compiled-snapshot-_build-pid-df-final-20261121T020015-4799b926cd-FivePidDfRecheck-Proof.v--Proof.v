From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory Contract UpdateCall UpdateSites.
From FiveLowpassSupport Require Import FieldBytes CbmcBits.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.
From FivePidDfRecheck Require Import Spec.
Lemma initial_initialized:forall m b p a bc c u0 u1 e0 e1 e2,Spec.Initial m b p a bc c u0 u1 e0 e1 e2->Initialized m b p a bc c u0 u1 e0 e1 e2.
Proof.
 intros m b p a bc c u0 u1 e0 e1 e2[W[B0[B4[B8[B12[B16[B20[B24 B28]]]]]]]].
 split;[exact W|];repeat split.
 - apply encoded_load;[exact(proj2(field_access m b p 0 W ltac:(unfold field_offsets;simpl;tauto)))|exact B0].
 - apply encoded_load;[exact(proj2(field_access m b p 4 W ltac:(unfold field_offsets;simpl;tauto)))|exact B4].
 - apply encoded_load;[exact(proj2(field_access m b p 8 W ltac:(unfold field_offsets;simpl;tauto)))|exact B8].
 - apply encoded_load;[exact(proj2(field_access m b p 12 W ltac:(unfold field_offsets;simpl;tauto)))|exact B12].
 - apply encoded_load;[exact(proj2(field_access m b p 16 W ltac:(unfold field_offsets;simpl;tauto)))|exact B16].
 - apply encoded_load;[exact(proj2(field_access m b p 20 W ltac:(unfold field_offsets;simpl;tauto)))|exact B20].
 - apply encoded_load;[exact(proj2(field_access m b p 24 W ltac:(unfold field_offsets;simpl;tauto)))|exact B24].
 - apply encoded_load;[exact(proj2(field_access m b p 28 W ltac:(unfold field_offsets;simpl;tauto)))|exact B28].
Qed.
Lemma assertions:forall n,(1<=n<=8)%nat->Spec.Assertion n.
Proof.
 intros n N m b p a bc c u0 u1 e0 e1 e2 input INIT;pose proof(initial_initialized m b p a bc c u0 u1 e0 e1 e2 INIT)as P.
 split.
 - destruct(update_call_execution m b p a bc c u0 u1 e0 e1 e2 input P)as[t[mf[PATH POST]]];exists t,mf;exact PATH.
 - intros t result mf PATH;destruct(update_call_observed m b p a bc c u0 u1 e0 e1 e2 input P t result mf PATH)as[RET[INITF[BYTES[FRAME VALID]]]].
 split;[exact RET|].
 pose proof(initialized_valid m b p a bc c u0 u1 e0 e1 e2 P)as VM.
 destruct INITF as[WF[F0[F4[F8[F12[F16[F20[F24 F28]]]]]]]].
 destruct INIT as[WI[I0[I4[I8[I12[I16[I20[I24 I28]]]]]]]].
 assert(B0:Mem.loadbytes mf b(Ptrofs.unsigned p+0)4=Some(encode_val Mfloat32(Vsingle (fp_step a bc c u0 e0 e1 input))))by(apply BYTES;cbn;auto 8).
 assert(B4:Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle u0)))by(apply BYTES;cbn;auto 8).
 assert(B8:Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle input)))by(apply BYTES;cbn;auto 8).
 assert(B12:Mem.loadbytes mf b(Ptrofs.unsigned p+12)4=Some(encode_val Mfloat32(Vsingle e0)))by(apply BYTES;cbn;auto 8).
 assert(B16:Mem.loadbytes mf b(Ptrofs.unsigned p+16)4=Some(encode_val Mfloat32(Vsingle e1)))by(apply BYTES;cbn;auto 8).
 assert(K20:Mem.loadbytes mf b(Ptrofs.unsigned p+20)4=Mem.loadbytes m b(Ptrofs.unsigned p+20)4)by(apply FRAME;[exact VM|right;right;lia]).
 assert(B20:Mem.loadbytes mf b(Ptrofs.unsigned p+20)4=Some(encode_val Mfloat32(Vsingle a)))by(rewrite K20;exact I20).
 assert(K24:Mem.loadbytes mf b(Ptrofs.unsigned p+24)4=Mem.loadbytes m b(Ptrofs.unsigned p+24)4)by(apply FRAME;[exact VM|right;right;lia]).
 assert(B24:Mem.loadbytes mf b(Ptrofs.unsigned p+24)4=Some(encode_val Mfloat32(Vsingle bc)))by(rewrite K24;exact I24).
 assert(K28:Mem.loadbytes mf b(Ptrofs.unsigned p+28)4=Mem.loadbytes m b(Ptrofs.unsigned p+28)4)by(apply FRAME;[exact VM|right;right;lia]).
 assert(B28:Mem.loadbytes mf b(Ptrofs.unsigned p+28)4=Some(encode_val Mfloat32(Vsingle c)))by(rewrite K28;exact I28).
 assert(FC0:Spec.FieldCheck mf b p 0 (fp_step a bc c u0 e0 e1 input))by(split;[exact B0|split;[exact F0|apply copied_bits_equal;reflexivity]]).
 assert(FC4:Spec.FieldCheck mf b p 4 u0)by(split;[exact B4|split;[exact F4|apply copied_bits_equal;reflexivity]]).
 assert(FC8:Spec.FieldCheck mf b p 8 input)by(split;[exact B8|split;[exact F8|apply copied_bits_equal;reflexivity]]).
 assert(FC12:Spec.FieldCheck mf b p 12 e0)by(split;[exact B12|split;[exact F12|apply copied_bits_equal;reflexivity]]).
 assert(FC16:Spec.FieldCheck mf b p 16 e1)by(split;[exact B16|split;[exact F16|apply copied_bits_equal;reflexivity]]).
 assert(FC20:Spec.FieldCheck mf b p 20 a)by(split;[exact B20|split;[exact F20|apply copied_bits_equal;reflexivity]]).
 assert(FC24:Spec.FieldCheck mf b p 24 bc)by(split;[exact B24|split;[exact F24|apply copied_bits_equal;reflexivity]]).
 assert(FC28:Spec.FieldCheck mf b p 28 c)by(split;[exact B28|split;[exact F28|apply copied_bits_equal;reflexivity]]).
 assert(C:n=1%nat\/n=2%nat\/n=3%nat\/n=4%nat\/n=5%nat\/n=6%nat\/n=7%nat\/n=8%nat)by lia.
 repeat destruct C as[E|C];try(rename C into E);subst n;try exact FC0;try exact FC4;try exact FC8;try exact FC12;try exact FC16;split;assumption.
Qed.
Theorem property_1:Spec.Property_1.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_1;lia. Qed.
Print Assumptions property_1.
Theorem property_2:Spec.Property_2.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_2;lia. Qed.
Print Assumptions property_2.
Theorem property_3:Spec.Property_3.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_3;lia. Qed.
Print Assumptions property_3.
Theorem property_4:Spec.Property_4.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_4;lia. Qed.
Print Assumptions property_4.
Theorem property_5:Spec.Property_5.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_5;lia. Qed.
Print Assumptions property_5.
Theorem property_6:Spec.Property_6.
Proof. apply CbmcBits.memcpy_guards;unfold Spec.Property_6;lia. Qed.
Print Assumptions property_6.
Theorem property_7:Spec.Property_7.
Proof. apply CbmcBits.bits_guards;unfold Spec.Property_7;lia. Qed.
Print Assumptions property_7.
Theorem property_8:Spec.Property_8.
Proof. apply CbmcBits.bits_guards;unfold Spec.Property_8;lia. Qed.
Print Assumptions property_8.
Theorem property_9:Spec.Property_9.
Proof. apply CbmcBits.bits_guards;unfold Spec.Property_9;lia. Qed.
Print Assumptions property_9.
Theorem property_10:Spec.Property_10.
Proof. apply assertions;unfold Spec.Property_10;lia. Qed.
Print Assumptions property_10.
Theorem property_11:Spec.Property_11.
Proof. apply assertions;unfold Spec.Property_11;lia. Qed.
Print Assumptions property_11.
Theorem property_12:Spec.Property_12.
Proof. apply assertions;unfold Spec.Property_12;lia. Qed.
Print Assumptions property_12.
Theorem property_13:Spec.Property_13.
Proof. apply assertions;unfold Spec.Property_13;lia. Qed.
Print Assumptions property_13.
Theorem property_14:Spec.Property_14.
Proof. apply assertions;unfold Spec.Property_14;lia. Qed.
Print Assumptions property_14.
Theorem property_15:Spec.Property_15.
Proof. apply assertions;unfold Spec.Property_15;lia. Qed.
Print Assumptions property_15.
Theorem property_16:Spec.Property_16.
Proof. apply assertions;unfold Spec.Property_16;lia. Qed.
Print Assumptions property_16.
Theorem property_17:Spec.Property_17.
Proof. apply assertions;unfold Spec.Property_17;lia. Qed.
Print Assumptions property_17.
Theorem property_18:Spec.Property_18.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_18;lia. Qed.
Print Assumptions property_18.
Theorem property_19:Spec.Property_19.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_19;lia. Qed.
Print Assumptions property_19.
Theorem property_20:Spec.Property_20.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_20;lia. Qed.
Print Assumptions property_20.
Theorem property_21:Spec.Property_21.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_21;lia. Qed.
Print Assumptions property_21.
Theorem property_22:Spec.Property_22.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_22;lia. Qed.
Print Assumptions property_22.
Theorem property_23:Spec.Property_23.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_23;lia. Qed.
Print Assumptions property_23.
Theorem property_24:Spec.Property_24.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_24;lia. Qed.
Print Assumptions property_24.
Theorem property_25:Spec.Property_25.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_25;lia. Qed.
Print Assumptions property_25.
Theorem property_26:Spec.Property_26.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_26;lia. Qed.
Print Assumptions property_26.
Theorem property_27:Spec.Property_27.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_27;lia. Qed.
Print Assumptions property_27.
Theorem property_28:Spec.Property_28.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_28;lia. Qed.
Print Assumptions property_28.
Theorem property_29:Spec.Property_29.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_29;lia. Qed.
Print Assumptions property_29.
Theorem property_30:Spec.Property_30.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_30;lia. Qed.
Print Assumptions property_30.
Theorem property_31:Spec.Property_31.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_31;lia. Qed.
Print Assumptions property_31.
Theorem property_32:Spec.Property_32.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_32;lia. Qed.
Print Assumptions property_32.
Theorem property_33:Spec.Property_33.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_33;lia. Qed.
Print Assumptions property_33.
Theorem property_34:Spec.Property_34.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_34;lia. Qed.
Print Assumptions property_34.
Theorem property_35:Spec.Property_35.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_35;lia. Qed.
Print Assumptions property_35.
Theorem property_36:Spec.Property_36.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_36;lia. Qed.
Print Assumptions property_36.
Theorem property_37:Spec.Property_37.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_37;lia. Qed.
Print Assumptions property_37.
Theorem property_38:Spec.Property_38.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_38;lia. Qed.
Print Assumptions property_38.
Theorem property_39:Spec.Property_39.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_39;lia. Qed.
Print Assumptions property_39.
Theorem property_40:Spec.Property_40.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_40;lia. Qed.
Print Assumptions property_40.
Theorem property_41:Spec.Property_41.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_41;lia. Qed.
Print Assumptions property_41.
Theorem property_42:Spec.Property_42.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_42;lia. Qed.
Print Assumptions property_42.
Theorem property_43:Spec.Property_43.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_43;lia. Qed.
Print Assumptions property_43.
Theorem property_44:Spec.Property_44.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_44;lia. Qed.
Print Assumptions property_44.
Theorem property_45:Spec.Property_45.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_45;lia. Qed.
Print Assumptions property_45.
Theorem property_46:Spec.Property_46.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_46;lia. Qed.
Print Assumptions property_46.
Theorem property_47:Spec.Property_47.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_47;lia. Qed.
Print Assumptions property_47.
Theorem property_48:Spec.Property_48.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_48;lia. Qed.
Print Assumptions property_48.
Theorem property_49:Spec.Property_49.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_49;lia. Qed.
Print Assumptions property_49.
Theorem property_50:Spec.Property_50.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_50;lia. Qed.
Print Assumptions property_50.
Theorem property_51:Spec.Property_51.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_51;lia. Qed.
Print Assumptions property_51.
Theorem property_52:Spec.Property_52.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_52;lia. Qed.
Print Assumptions property_52.
Theorem property_53:Spec.Property_53.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_53;lia. Qed.
Print Assumptions property_53.
Theorem property_54:Spec.Property_54.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_54;lia. Qed.
Print Assumptions property_54.
Theorem property_55:Spec.Property_55.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_55;lia. Qed.
Print Assumptions property_55.
Theorem property_56:Spec.Property_56.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_56;lia. Qed.
Print Assumptions property_56.
Theorem property_57:Spec.Property_57.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_57;lia. Qed.
Print Assumptions property_57.
Theorem property_58:Spec.Property_58.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_58;lia. Qed.
Print Assumptions property_58.
Theorem property_59:Spec.Property_59.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_59;lia. Qed.
Print Assumptions property_59.
Theorem property_60:Spec.Property_60.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_60;lia. Qed.
Print Assumptions property_60.
Theorem property_61:Spec.Property_61.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_61;lia. Qed.
Print Assumptions property_61.
Theorem property_62:Spec.Property_62.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_62;lia. Qed.
Print Assumptions property_62.
Theorem property_63:Spec.Property_63.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_63;lia. Qed.
Print Assumptions property_63.
Theorem property_64:Spec.Property_64.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_64;lia. Qed.
Print Assumptions property_64.
Theorem property_65:Spec.Property_65.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_65;lia. Qed.
Print Assumptions property_65.
Theorem property_66:Spec.Property_66.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_66;lia. Qed.
Print Assumptions property_66.
Theorem property_67:Spec.Property_67.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_67;lia. Qed.
Print Assumptions property_67.
Theorem property_68:Spec.Property_68.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_68;lia. Qed.
Print Assumptions property_68.
Theorem property_69:Spec.Property_69.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_69;lia. Qed.
Print Assumptions property_69.
Theorem property_70:Spec.Property_70.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_70;lia. Qed.
Print Assumptions property_70.
Theorem property_71:Spec.Property_71.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_71;lia. Qed.
Print Assumptions property_71.
Theorem property_72:Spec.Property_72.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_72;lia. Qed.
Print Assumptions property_72.
Theorem property_73:Spec.Property_73.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_73;lia. Qed.
Print Assumptions property_73.
Theorem property_74:Spec.Property_74.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_74;lia. Qed.
Print Assumptions property_74.
Theorem property_75:Spec.Property_75.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_75;lia. Qed.
Print Assumptions property_75.
Theorem property_76:Spec.Property_76.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_76;lia. Qed.
Print Assumptions property_76.
Theorem property_77:Spec.Property_77.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_77;lia. Qed.
Print Assumptions property_77.
Theorem property_78:Spec.Property_78.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_78;lia. Qed.
Print Assumptions property_78.
Theorem property_79:Spec.Property_79.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_79;lia. Qed.
Print Assumptions property_79.
Theorem property_80:Spec.Property_80.
Proof. apply UpdateSites.pointer_properties;unfold Spec.Property_80;lia. Qed.
Print Assumptions property_80.
Theorem property_81:Spec.Property_81.
Proof. apply UpdateSites.array_properties;unfold Spec.Property_81;lia. Qed.
Print Assumptions property_81.
