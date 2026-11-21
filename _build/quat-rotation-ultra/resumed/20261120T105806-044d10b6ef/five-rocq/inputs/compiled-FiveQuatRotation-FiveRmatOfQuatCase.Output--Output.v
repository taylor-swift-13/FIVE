From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Base Contract.
Import ListNotations.
Local Open Scope Z_scope.
From FiveRmatOfQuatCase Require Import Body.
Definition matrix_values(qi qx qy qz:float32):list float32:= [Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx));Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz));Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy));Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz));Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy));Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx));Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy));Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx));Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))].
Definition nine_stores(m:mem)(out:block)(values:list float32)(mf:mem):Prop:=exists m1 m2 m3 m4 m5 m6 m7 m8,
Mem.store Mfloat32 m out 0(Vsingle(nth 0 values Float32.zero))=Some m1 /\
Mem.store Mfloat32 m1 out 4(Vsingle(nth 1 values Float32.zero))=Some m2 /\
Mem.store Mfloat32 m2 out 8(Vsingle(nth 2 values Float32.zero))=Some m3 /\
Mem.store Mfloat32 m3 out 12(Vsingle(nth 3 values Float32.zero))=Some m4 /\
Mem.store Mfloat32 m4 out 16(Vsingle(nth 4 values Float32.zero))=Some m5 /\
Mem.store Mfloat32 m5 out 20(Vsingle(nth 5 values Float32.zero))=Some m6 /\
Mem.store Mfloat32 m6 out 24(Vsingle(nth 6 values Float32.zero))=Some m7 /\
Mem.store Mfloat32 m7 out 28(Vsingle(nth 7 values Float32.zero))=Some m8 /\
Mem.store Mfloat32 m8 out 32(Vsingle(nth 8 values Float32.zero))=Some mf.
Section OUTPUT.
Variable e:env.
Variable q out:block.
Variable qi qx qy qz:float32.
Hypothesis NL:Nonlocal e q out.
Hypothesis DEFS:locals_defined e.
Variable br:block.
Hypothesis LOOKRM:e!Source._rm=Some(br,rmtype).
Theorem output_body:forall m,
 Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m->
 exists mf,stmt_eval Execution.ge e tvoid
 (fold_right(fun a s=>Ssequence(Sdo a)s)Sskip(skipn 11 acts))m=Some(Nnormal,mf) /\
 Context e q out qi qx qy qz(rho11 q out qi qx qy qz)mf /\
 nine_stores m out(matrix_values qi qx qy qz)mf /\stores e out m mf.
Proof. intros m CT0.
 destruct(DEFS Source.__a ltac:(simpl;tauto))as[b__a L__a].
 destruct(DEFS Source.__b ltac:(simpl;tauto))as[b__b L__b].
 destruct(DEFS Source.__c ltac:(simpl;tauto))as[b__c L__c].
 destruct(DEFS Source.__d ltac:(simpl;tauto))as[b__d L__d].
 destruct(DEFS Source._a2_1 ltac:(simpl;tauto))as[b_a2_1 L_a2_1].
 destruct(DEFS Source._ab ltac:(simpl;tauto))as[b_ab L_ab].
 destruct(DEFS Source._ac ltac:(simpl;tauto))as[b_ac L_ac].
 destruct(DEFS Source._ad ltac:(simpl;tauto))as[b_ad L_ad].
 destruct(DEFS Source._bc ltac:(simpl;tauto))as[b_bc L_bc].
 destruct(DEFS Source._bd ltac:(simpl;tauto))as[b_bd L_bd].
 destruct(DEFS Source._cd ltac:(simpl;tauto))as[b_cd L_cd].
 assert(V0_4:pure_rval Execution.ge e m(scalar Source._a2_1)=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT0)|exact L_a2_1|reflexivity]. }
 assert(V0_1:pure_rval Execution.ge e m(scalar Source.__b)=Some(Vsingle(scale qx))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT0)|exact L__b|reflexivity]. }
 assert(RV0:pure_rval Execution.ge e m(rhs act11)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx))))).
 { change(pure_rval Execution.ge e m(Ebinop Oadd (scalar Source._a2_1) (Ebinop Omul (scalar Source.__b) (scalar Source.__b) tfloat) tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx)))));apply add_value;[reflexivity|reflexivity|exact V0_4|apply mul_value;[reflexivity|reflexivity|exact V0_1|exact V0_1]]. }
 assert(PR0:Mem.load Mptr m br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT0 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT0) 0 ltac:(simpl;tauto))as W0.
 destruct(Mem.valid_access_store m Mfloat32 out 0(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx))))W0)as[m1 ST0].
 assert(A0:atomic_eval Execution.ge e m act11=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx))),m1)).
 { change(atomic_eval Execution.ge e m(Eassign(lhs act11)(rhs act11)tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx))),m1)).
 eapply assign_float_any;[reflexivity|exact(rm_location0 e m br out LOOKRM PR0)|exact RV0|reflexivity|change(0+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m out 0(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qx)(scale qx))))=Some m1);exact ST0]. }
 assert(CT1:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m1)by(eapply store_output_context;eauto).
 assert(V1_8:pure_rval Execution.ge e m1(scalar Source._bc)=Some(Vsingle(Float32.mul(scale qx)(scale qy)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT1)|exact L_bc|reflexivity]. }
 assert(V1_7:pure_rval Execution.ge e m1(scalar Source._ad)=Some(Vsingle(Float32.mul(scale qi)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT1)|exact L_ad|reflexivity]. }
 assert(RV1:pure_rval Execution.ge e m1(rhs act12)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))).
 { change(pure_rval Execution.ge e m1(Ebinop Oadd (scalar Source._bc) (scalar Source._ad) tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz)))));apply add_value;[reflexivity|reflexivity|exact V1_8|exact V1_7]. }
 assert(PR1:Mem.load Mptr m1 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT1 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT1) 4 ltac:(simpl;tauto))as W1.
 destruct(Mem.valid_access_store m1 Mfloat32 out 4(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))W1)as[m2 ST1].
 assert(A1:atomic_eval Execution.ge e m1 act12=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))),m2)).
 { change(atomic_eval Execution.ge e m1(Eassign(lhs act12)(rhs act12)tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))),m2)).
 eapply assign_float_any;[reflexivity|exact(rm_location1 e m1 br out LOOKRM PR1)|exact RV1|reflexivity|change(4+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m1 out 4(Vsingle(Float32.add(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))=Some m2);exact ST1]. }
 assert(CT2:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m2)by(eapply store_output_context;eauto).
 assert(V2_9:pure_rval Execution.ge e m2(scalar Source._bd)=Some(Vsingle(Float32.mul(scale qx)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT2)|exact L_bd|reflexivity]. }
 assert(V2_6:pure_rval Execution.ge e m2(scalar Source._ac)=Some(Vsingle(Float32.mul(scale qi)(scale qy)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT2)|exact L_ac|reflexivity]. }
 assert(RV2:pure_rval Execution.ge e m2(rhs act13)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))).
 { change(pure_rval Execution.ge e m2(Ebinop Osub (scalar Source._bd) (scalar Source._ac) tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy)))));apply sub_value;[reflexivity|reflexivity|exact V2_9|exact V2_6]. }
 assert(PR2:Mem.load Mptr m2 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT2 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT2) 8 ltac:(simpl;tauto))as W2.
 destruct(Mem.valid_access_store m2 Mfloat32 out 8(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))W2)as[m3 ST2].
 assert(A2:atomic_eval Execution.ge e m2 act13=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))),m3)).
 { change(atomic_eval Execution.ge e m2(Eassign(lhs act13)(rhs act13)tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))),m3)).
 eapply assign_float_any;[reflexivity|exact(rm_location2 e m2 br out LOOKRM PR2)|exact RV2|reflexivity|change(8+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m2 out 8(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))=Some m3);exact ST2]. }
 assert(CT3:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m3)by(eapply store_output_context;eauto).
 assert(V3_8:pure_rval Execution.ge e m3(scalar Source._bc)=Some(Vsingle(Float32.mul(scale qx)(scale qy)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT3)|exact L_bc|reflexivity]. }
 assert(V3_7:pure_rval Execution.ge e m3(scalar Source._ad)=Some(Vsingle(Float32.mul(scale qi)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT3)|exact L_ad|reflexivity]. }
 assert(RV3:pure_rval Execution.ge e m3(rhs act14)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))).
 { change(pure_rval Execution.ge e m3(Ebinop Osub (scalar Source._bc) (scalar Source._ad) tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz)))));apply sub_value;[reflexivity|reflexivity|exact V3_8|exact V3_7]. }
 assert(PR3:Mem.load Mptr m3 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT3 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT3) 12 ltac:(simpl;tauto))as W3.
 destruct(Mem.valid_access_store m3 Mfloat32 out 12(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))W3)as[m4 ST3].
 assert(A3:atomic_eval Execution.ge e m3 act14=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))),m4)).
 { change(atomic_eval Execution.ge e m3(Eassign(lhs act14)(rhs act14)tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))),m4)).
 eapply assign_float_any;[reflexivity|exact(rm_location3 e m3 br out LOOKRM PR3)|exact RV3|reflexivity|change(12+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m3 out 12(Vsingle(Float32.sub(Float32.mul(scale qx)(scale qy))(Float32.mul(scale qi)(scale qz))))=Some m4);exact ST3]. }
 assert(CT4:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m4)by(eapply store_output_context;eauto).
 assert(V4_4:pure_rval Execution.ge e m4(scalar Source._a2_1)=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT4)|exact L_a2_1|reflexivity]. }
 assert(V4_2:pure_rval Execution.ge e m4(scalar Source.__c)=Some(Vsingle(scale qy))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT4)|exact L__c|reflexivity]. }
 assert(RV4:pure_rval Execution.ge e m4(rhs act15)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy))))).
 { change(pure_rval Execution.ge e m4(Ebinop Oadd (scalar Source._a2_1) (Ebinop Omul (scalar Source.__c) (scalar Source.__c) tfloat) tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy)))));apply add_value;[reflexivity|reflexivity|exact V4_4|apply mul_value;[reflexivity|reflexivity|exact V4_2|exact V4_2]]. }
 assert(PR4:Mem.load Mptr m4 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT4 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT4) 16 ltac:(simpl;tauto))as W4.
 destruct(Mem.valid_access_store m4 Mfloat32 out 16(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy))))W4)as[m5 ST4].
 assert(A4:atomic_eval Execution.ge e m4 act15=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy))),m5)).
 { change(atomic_eval Execution.ge e m4(Eassign(lhs act15)(rhs act15)tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy))),m5)).
 eapply assign_float_any;[reflexivity|exact(rm_location4 e m4 br out LOOKRM PR4)|exact RV4|reflexivity|change(16+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m4 out 16(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qy)(scale qy))))=Some m5);exact ST4]. }
 assert(CT5:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m5)by(eapply store_output_context;eauto).
 assert(V5_10:pure_rval Execution.ge e m5(scalar Source._cd)=Some(Vsingle(Float32.mul(scale qy)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT5)|exact L_cd|reflexivity]. }
 assert(V5_5:pure_rval Execution.ge e m5(scalar Source._ab)=Some(Vsingle(Float32.mul(scale qi)(scale qx)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT5)|exact L_ab|reflexivity]. }
 assert(RV5:pure_rval Execution.ge e m5(rhs act16)=Some(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))).
 { change(pure_rval Execution.ge e m5(Ebinop Oadd (scalar Source._cd) (scalar Source._ab) tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx)))));apply add_value;[reflexivity|reflexivity|exact V5_10|exact V5_5]. }
 assert(PR5:Mem.load Mptr m5 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT5 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT5) 20 ltac:(simpl;tauto))as W5.
 destruct(Mem.valid_access_store m5 Mfloat32 out 20(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))W5)as[m6 ST5].
 assert(A5:atomic_eval Execution.ge e m5 act16=Some(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))),m6)).
 { change(atomic_eval Execution.ge e m5(Eassign(lhs act16)(rhs act16)tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))),m6)).
 eapply assign_float_any;[reflexivity|exact(rm_location5 e m5 br out LOOKRM PR5)|exact RV5|reflexivity|change(20+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m5 out 20(Vsingle(Float32.add(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))=Some m6);exact ST5]. }
 assert(CT6:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m6)by(eapply store_output_context;eauto).
 assert(V6_9:pure_rval Execution.ge e m6(scalar Source._bd)=Some(Vsingle(Float32.mul(scale qx)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT6)|exact L_bd|reflexivity]. }
 assert(V6_6:pure_rval Execution.ge e m6(scalar Source._ac)=Some(Vsingle(Float32.mul(scale qi)(scale qy)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT6)|exact L_ac|reflexivity]. }
 assert(RV6:pure_rval Execution.ge e m6(rhs act17)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))).
 { change(pure_rval Execution.ge e m6(Ebinop Oadd (scalar Source._bd) (scalar Source._ac) tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy)))));apply add_value;[reflexivity|reflexivity|exact V6_9|exact V6_6]. }
 assert(PR6:Mem.load Mptr m6 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT6 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT6) 24 ltac:(simpl;tauto))as W6.
 destruct(Mem.valid_access_store m6 Mfloat32 out 24(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))W6)as[m7 ST6].
 assert(A6:atomic_eval Execution.ge e m6 act17=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))),m7)).
 { change(atomic_eval Execution.ge e m6(Eassign(lhs act17)(rhs act17)tfloat)=Some(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))),m7)).
 eapply assign_float_any;[reflexivity|exact(rm_location6 e m6 br out LOOKRM PR6)|exact RV6|reflexivity|change(24+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m6 out 24(Vsingle(Float32.add(Float32.mul(scale qx)(scale qz))(Float32.mul(scale qi)(scale qy))))=Some m7);exact ST6]. }
 assert(CT7:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m7)by(eapply store_output_context;eauto).
 assert(V7_10:pure_rval Execution.ge e m7(scalar Source._cd)=Some(Vsingle(Float32.mul(scale qy)(scale qz)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT7)|exact L_cd|reflexivity]. }
 assert(V7_5:pure_rval Execution.ge e m7(scalar Source._ab)=Some(Vsingle(Float32.mul(scale qi)(scale qx)))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT7)|exact L_ab|reflexivity]. }
 assert(RV7:pure_rval Execution.ge e m7(rhs act18)=Some(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))).
 { change(pure_rval Execution.ge e m7(Ebinop Osub (scalar Source._cd) (scalar Source._ab) tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx)))));apply sub_value;[reflexivity|reflexivity|exact V7_10|exact V7_5]. }
 assert(PR7:Mem.load Mptr m7 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT7 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT7) 28 ltac:(simpl;tauto))as W7.
 destruct(Mem.valid_access_store m7 Mfloat32 out 28(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))W7)as[m8 ST7].
 assert(A7:atomic_eval Execution.ge e m7 act18=Some(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))),m8)).
 { change(atomic_eval Execution.ge e m7(Eassign(lhs act18)(rhs act18)tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))),m8)).
 eapply assign_float_any;[reflexivity|exact(rm_location7 e m7 br out LOOKRM PR7)|exact RV7|reflexivity|change(28+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m7 out 28(Vsingle(Float32.sub(Float32.mul(scale qy)(scale qz))(Float32.mul(scale qi)(scale qx))))=Some m8);exact ST7]. }
 assert(CT8:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m8)by(eapply store_output_context;eauto).
 assert(V8_4:pure_rval Execution.ge e m8(scalar Source._a2_1)=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT8)|exact L_a2_1|reflexivity]. }
 assert(V8_3:pure_rval Execution.ge e m8(scalar Source.__d)=Some(Vsingle(scale qz))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT8)|exact L__d|reflexivity]. }
 assert(RV8:pure_rval Execution.ge e m8(rhs act19)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))))).
 { change(pure_rval Execution.ge e m8(Ebinop Oadd (scalar Source._a2_1) (Ebinop Omul (scalar Source.__d) (scalar Source.__d) tfloat) tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz)))));apply add_value;[reflexivity|reflexivity|exact V8_4|apply mul_value;[reflexivity|reflexivity|exact V8_3|exact V8_3]]. }
 assert(PR8:Mem.load Mptr m8 br 0=Some(Vptr out Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT8 Source._rm br rmtype(Vptr out Ptrofs.zero)LOOKRM eq_refl). }
 pose proof(wout _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT8) 32 ltac:(simpl;tauto))as W8.
 destruct(Mem.valid_access_store m8 Mfloat32 out 32(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))))W8)as[m9 ST8].
 assert(A8:atomic_eval Execution.ge e m8 act19=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))),m9)).
 { change(atomic_eval Execution.ge e m8(Eassign(lhs act19)(rhs act19)tfloat)=Some(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))),m9)).
 eapply assign_float_any;[reflexivity|exact(rm_location8 e m8 br out LOOKRM PR8)|exact RV8|reflexivity|change(32+4<=18446744073709551616);lia|change(Mem.store Mfloat32 m8 out 32(Vsingle(Float32.add(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))(Float32.mul(scale qz)(scale qz))))=Some m9);exact ST8]. }
 assert(CT9:Context e q out qi qx qy qz(rho11 q out qi qx qy qz)m9)by(eapply store_output_context;eauto).
 exists m9;split.
 - change(stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip[act11;act12;act13;act14;act15;act16;act17;act18;act19])m=Some(Nnormal,m9)).
 cbn[fold_right stmt_eval];rewrite A0,A1,A2,A3,A4,A5,A6,A7,A8;reflexivity.
 - split;[exact CT9|];split.
 + exists m1,m2,m3,m4,m5,m6,m7,m8;repeat split;assumption.
 + eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=32);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST8].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=28);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST7].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=24);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST6].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=20);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST5].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=16);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST4].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=12);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST3].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=8);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST2].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=4);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST1].
eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=0);[|left;repeat split;try reflexivity;cbn[size_chunk];lia|exact ST0].
constructor.
Qed.
End OUTPUT.
Print Assumptions output_body.

Definition matrix_bytes(values:list float32):list memval:=encode_val Mfloat32(Vsingle(nth 0 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 1 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)).
Lemma nine_stores_bytes:forall m out values mf,nine_stores m out values mf->Mem.loadbytes mf out 0 36=Some(matrix_bytes values).
Proof. intros m out values mf(m1&m2&m3&m4&m5&m6&m7&m8&ST0&ST1&ST2&ST3&ST4&ST5&ST6&ST7&ST8).
 assert(L0:Mem.loadbytes mf out 0 4=Some(encode_val Mfloat32(Vsingle(nth 0 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST3||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST2||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST1||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST0). }
 assert(L1:Mem.loadbytes mf out 4 4=Some(encode_val Mfloat32(Vsingle(nth 1 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST3||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST2||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST1). }
 assert(L2:Mem.loadbytes mf out 8 4=Some(encode_val Mfloat32(Vsingle(nth 2 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST3||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST2). }
 assert(L3:Mem.loadbytes mf out 12 4=Some(encode_val Mfloat32(Vsingle(nth 3 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST4||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST3). }
 assert(L4:Mem.loadbytes mf out 16 4=Some(encode_val Mfloat32(Vsingle(nth 4 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST5||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST4). }
 assert(L5:Mem.loadbytes mf out 20 4=Some(encode_val Mfloat32(Vsingle(nth 5 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST6||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST5). }
 assert(L6:Mem.loadbytes mf out 24 4=Some(encode_val Mfloat32(Vsingle(nth 6 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.loadbytes_store_other by(exact ST7||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST6). }
 assert(L7:Mem.loadbytes mf out 28 4=Some(encode_val Mfloat32(Vsingle(nth 7 values Float32.zero)))).
 { erewrite Mem.loadbytes_store_other by(exact ST8||(cbn[size_chunk];lia));
 exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST7). }
 assert(L8:Mem.loadbytes mf out 32 4=Some(encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST8). }
 assert(C7:Mem.loadbytes mf out 28 8=Some(encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 8 with(4+4)by lia;eapply Mem.loadbytes_concat;[exact L7|change(Mem.loadbytes mf out 32 4=Some(encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact L8|lia|lia]. }
 assert(C6:Mem.loadbytes mf out 24 12=Some(encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 12 with(4+8)by lia;eapply Mem.loadbytes_concat;[exact L6|change(Mem.loadbytes mf out 28 8=Some(encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C7|lia|lia]. }
 assert(C5:Mem.loadbytes mf out 20 16=Some(encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 16 with(4+12)by lia;eapply Mem.loadbytes_concat;[exact L5|change(Mem.loadbytes mf out 24 12=Some(encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C6|lia|lia]. }
 assert(C4:Mem.loadbytes mf out 16 20=Some(encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 20 with(4+16)by lia;eapply Mem.loadbytes_concat;[exact L4|change(Mem.loadbytes mf out 20 16=Some(encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C5|lia|lia]. }
 assert(C3:Mem.loadbytes mf out 12 24=Some(encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 24 with(4+20)by lia;eapply Mem.loadbytes_concat;[exact L3|change(Mem.loadbytes mf out 16 20=Some(encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C4|lia|lia]. }
 assert(C2:Mem.loadbytes mf out 8 28=Some(encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 28 with(4+24)by lia;eapply Mem.loadbytes_concat;[exact L2|change(Mem.loadbytes mf out 12 24=Some(encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C3|lia|lia]. }
 assert(C1:Mem.loadbytes mf out 4 32=Some(encode_val Mfloat32(Vsingle(nth 1 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 32 with(4+28)by lia;eapply Mem.loadbytes_concat;[exact L1|change(Mem.loadbytes mf out 8 28=Some(encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C2|lia|lia]. }
 assert(C0:Mem.loadbytes mf out 0 36=Some(encode_val Mfloat32(Vsingle(nth 0 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 1 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero)))).
 { replace 36 with(4+32)by lia;eapply Mem.loadbytes_concat;[exact L0|change(Mem.loadbytes mf out 4 32=Some(encode_val Mfloat32(Vsingle(nth 1 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 2 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 3 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 4 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 5 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 6 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 7 values Float32.zero))++encode_val Mfloat32(Vsingle(nth 8 values Float32.zero))));exact C1|lia|lia]. }
 exact C0.
Qed.
Print Assumptions nine_stores_bytes.
Lemma nine_stores_loads:forall m out values mf,nine_stores m out values mf->forall i:nat,(i<9)%nat->
 Mem.load Mfloat32 mf out(Z.of_nat i*4)=Some(Vsingle(nth i values Float32.zero)).
Proof. intros m out values mf(m1&m2&m3&m4&m5&m6&m7&m8&ST0&ST1&ST2&ST3&ST4&ST5&ST6&ST7&ST8).
 assert(L0:Mem.load Mfloat32 mf out 0=Some(Vsingle(nth 0 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST3||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST2||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST1||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST0;reflexivity. }
 assert(L1:Mem.load Mfloat32 mf out 4=Some(Vsingle(nth 1 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST3||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST2||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST1;reflexivity. }
 assert(L2:Mem.load Mfloat32 mf out 8=Some(Vsingle(nth 2 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST3||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST2;reflexivity. }
 assert(L3:Mem.load Mfloat32 mf out 12=Some(Vsingle(nth 3 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST4||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST3;reflexivity. }
 assert(L4:Mem.load Mfloat32 mf out 16=Some(Vsingle(nth 4 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST5||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST4;reflexivity. }
 assert(L5:Mem.load Mfloat32 mf out 20=Some(Vsingle(nth 5 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST6||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST5;reflexivity. }
 assert(L6:Mem.load Mfloat32 mf out 24=Some(Vsingle(nth 6 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_other by(exact ST7||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST6;reflexivity. }
 assert(L7:Mem.load Mfloat32 mf out 28=Some(Vsingle(nth 7 values Float32.zero))).
 { erewrite Mem.load_store_other by(exact ST8||(cbn[size_chunk];lia));
 erewrite Mem.load_store_same by exact ST7;reflexivity. }
 assert(L8:Mem.load Mfloat32 mf out 32=Some(Vsingle(nth 8 values Float32.zero))).
 { erewrite Mem.load_store_same by exact ST8;reflexivity. }
 intros i IX;do 9(destruct i as[|i];[cbn;assumption|]);lia.
Qed.
Print Assumptions nine_stores_loads.
