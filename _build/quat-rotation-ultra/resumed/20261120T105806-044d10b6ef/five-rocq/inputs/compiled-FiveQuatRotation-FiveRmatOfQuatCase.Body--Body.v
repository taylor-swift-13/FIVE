From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Base Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition scale(x:float32):float32:=Float.to_single(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single x)).
Definition rho0(q out:block):PTree.t val:=PTree.set Source._q(Vptr q Ptrofs.zero)(PTree.set Source._rm(Vptr out Ptrofs.zero)(PTree.empty val)).
Definition rho1(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source.__a(Vsingle(scale qi))(rho0 q out).
Definition rho2(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source.__b(Vsingle(scale qx))(rho1 q out qi qx qy qz).
Definition rho3(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source.__c(Vsingle(scale qy))(rho2 q out qi qx qy qz).
Definition rho4(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source.__d(Vsingle(scale qz))(rho3 q out qi qx qy qz).
Definition rho5(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._a2_1(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))(rho4 q out qi qx qy qz).
Definition rho6(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._ab(Vsingle(Float32.mul(scale qi)(scale qx)))(rho5 q out qi qx qy qz).
Definition rho7(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._ac(Vsingle(Float32.mul(scale qi)(scale qy)))(rho6 q out qi qx qy qz).
Definition rho8(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._ad(Vsingle(Float32.mul(scale qi)(scale qz)))(rho7 q out qi qx qy qz).
Definition rho9(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._bc(Vsingle(Float32.mul(scale qx)(scale qy)))(rho8 q out qi qx qy qz).
Definition rho10(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._bd(Vsingle(Float32.mul(scale qx)(scale qz)))(rho9 q out qi qx qy qz).
Definition rho11(q out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._cd(Vsingle(Float32.mul(scale qy)(scale qz)))(rho10 q out qi qx qy qz).
Definition locals_defined(e:env):Prop:=forall id,In id[Source.__a;Source.__b;Source.__c;Source.__d;Source._a2_1;Source._ab;Source._ac;Source._ad;Source._bc;Source._bd;Source._cd]->exists b,e!id=Some(b,tfloat).
Section BODY.
Variable e:env.
Variable q out:block.
Variable qi qx qy qz:float32.
Hypothesis SEP:env_separated e.
Hypothesis NL:Nonlocal e q out.
Hypothesis DEFS:locals_defined e.
Variable bq br:block.
Hypothesis LOOKQ:e!Source._q=Some(bq,qtype).
Hypothesis LOOKRM:e!Source._rm=Some(br,rmtype).
Theorem locals_body:forall m,
 Context e q out qi qx qy qz(rho0 q out)m->
 exists mf,stmt_eval Execution.ge e tvoid
 (fold_right(fun a s=>Ssequence(Sdo a)s)Sskip(firstn 11 acts))m=Some(Nnormal,mf) /\
 Context e q out qi qx qy qz(rho11 q out qi qx qy qz)mf /\ stores e out m mf.
Proof.
 intros m CT0.
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
 assert(PQ0:Mem.load Mptr m bq 0=Some(Vptr q Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT0 Source._q bq qtype(Vptr q Ptrofs.zero) LOOKQ eq_refl). }
 assert(Q0:Mem.load Mfloat32 m q 0=Some(Vsingle qi))by(exact(lqi _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT0))).
 assert(RV0:pure_rval Execution.ge e m(rhs act0)=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qi)))).
 { change(match pure_rval Execution.ge e m(Evalof(qfield Source._qi)tfloat)with Some w=>sem_binary_operation Execution.ge Omul(Vfloat(Float.of_bits(Int64.repr 4609047870845172685)))tdouble w tfloat m|None=>None end=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qi)))).
 rewrite(q_value e m bq q Source._qi 0 qi LOOKQ PQ0 ltac:(simpl;tauto) Q0);reflexivity. }
 destruct(write_local e q out qi qx qy qz(rho0 q out)m Source.__a b__a(rhs act0)(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qi)))(scale qi)SEP NL CT0 L__a RV0 ltac:(reflexivity))as[m1[A0[CT1 ST0]]].
 assert(PQ1:Mem.load Mptr m1 bq 0=Some(Vptr q Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT1 Source._q bq qtype(Vptr q Ptrofs.zero) LOOKQ eq_refl). }
 assert(Q1:Mem.load Mfloat32 m1 q 4=Some(Vsingle qx))by(exact(lqx _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT1))).
 assert(RV1:pure_rval Execution.ge e m1(rhs act1)=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qx)))).
 { change(match pure_rval Execution.ge e m1(Evalof(qfield Source._qx)tfloat)with Some w=>sem_binary_operation Execution.ge Omul(Vfloat(Float.of_bits(Int64.repr 4609047870845172685)))tdouble w tfloat m1|None=>None end=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qx)))).
 rewrite(q_value e m1 bq q Source._qx 4 qx LOOKQ PQ1 ltac:(simpl;tauto) Q1);reflexivity. }
 destruct(write_local e q out qi qx qy qz(rho1 q out qi qx qy qz)m1 Source.__b b__b(rhs act1)(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qx)))(scale qx)SEP NL CT1 L__b RV1 ltac:(reflexivity))as[m2[A1[CT2 ST1]]].
 assert(PQ2:Mem.load Mptr m2 bq 0=Some(Vptr q Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT2 Source._q bq qtype(Vptr q Ptrofs.zero) LOOKQ eq_refl). }
 assert(Q2:Mem.load Mfloat32 m2 q 8=Some(Vsingle qy))by(exact(lqy _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT2))).
 assert(RV2:pure_rval Execution.ge e m2(rhs act2)=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qy)))).
 { change(match pure_rval Execution.ge e m2(Evalof(qfield Source._qy)tfloat)with Some w=>sem_binary_operation Execution.ge Omul(Vfloat(Float.of_bits(Int64.repr 4609047870845172685)))tdouble w tfloat m2|None=>None end=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qy)))).
 rewrite(q_value e m2 bq q Source._qy 8 qy LOOKQ PQ2 ltac:(simpl;tauto) Q2);reflexivity. }
 destruct(write_local e q out qi qx qy qz(rho2 q out qi qx qy qz)m2 Source.__c b__c(rhs act2)(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qy)))(scale qy)SEP NL CT2 L__c RV2 ltac:(reflexivity))as[m3[A2[CT3 ST2]]].
 assert(PQ3:Mem.load Mptr m3 bq 0=Some(Vptr q Ptrofs.zero)).
 { exact(context_repr _ _ _ _ _ _ _ _ _ CT3 Source._q bq qtype(Vptr q Ptrofs.zero) LOOKQ eq_refl). }
 assert(Q3:Mem.load Mfloat32 m3 q 12=Some(Vsingle qz))by(exact(lqz _ _ _ _ _ _ _(context_inputs _ _ _ _ _ _ _ _ _ CT3))).
 assert(RV3:pure_rval Execution.ge e m3(rhs act3)=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qz)))).
 { change(match pure_rval Execution.ge e m3(Evalof(qfield Source._qz)tfloat)with Some w=>sem_binary_operation Execution.ge Omul(Vfloat(Float.of_bits(Int64.repr 4609047870845172685)))tdouble w tfloat m3|None=>None end=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qz)))).
 rewrite(q_value e m3 bq q Source._qz 12 qz LOOKQ PQ3 ltac:(simpl;tauto) Q3);reflexivity. }
 destruct(write_local e q out qi qx qy qz(rho3 q out qi qx qy qz)m3 Source.__d b__d(rhs act3)(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qz)))(scale qz)SEP NL CT3 L__d RV3 ltac:(reflexivity))as[m4[A3[CT4 ST3]]].
 assert(V4_0:pure_rval Execution.ge e m4(scalar Source.__a)=Some(Vsingle(scale qi))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT4)|exact L__a|reflexivity]. }
 assert(RV4:pure_rval Execution.ge e m4(rhs act4)=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))).
 { change(pure_rval Execution.ge e m4(Ebinop Osub(Ebinop Omul(scalar Source.__a)(scalar Source.__a)tfloat)(Eval(Vint(Int.repr 1))tint)tfloat)=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))));apply subtract_one;[reflexivity|];apply mul_value;try reflexivity;exact V4_0. }
 destruct(write_local e q out qi qx qy qz(rho4 q out qi qx qy qz)m4 Source._a2_1 b_a2_1(rhs act4)(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))))(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1)))SEP NL CT4 L_a2_1 RV4 ltac:(reflexivity))as[m5[A4[CT5 ST4]]].
 assert(V5_0:pure_rval Execution.ge e m5(scalar Source.__a)=Some(Vsingle(scale qi))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT5)|exact L__a|reflexivity]. }
 assert(V5_1:pure_rval Execution.ge e m5(scalar Source.__b)=Some(Vsingle(scale qx))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT5)|exact L__b|reflexivity]. }
 assert(RV5:pure_rval Execution.ge e m5(rhs act5)=Some(Vsingle(Float32.mul(scale qi)(scale qx)))).
 { change(pure_rval Execution.ge e m5(Ebinop Omul(scalar Source.__a)(scalar Source.__b)tfloat)=Some(Vsingle(Float32.mul(scale qi)(scale qx))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho5 q out qi qx qy qz)m5 Source._ab b_ab(rhs act5)(Vsingle(Float32.mul(scale qi)(scale qx)))(Float32.mul(scale qi)(scale qx))SEP NL CT5 L_ab RV5 ltac:(reflexivity))as[m6[A5[CT6 ST5]]].
 assert(V6_0:pure_rval Execution.ge e m6(scalar Source.__a)=Some(Vsingle(scale qi))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT6)|exact L__a|reflexivity]. }
 assert(V6_2:pure_rval Execution.ge e m6(scalar Source.__c)=Some(Vsingle(scale qy))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT6)|exact L__c|reflexivity]. }
 assert(RV6:pure_rval Execution.ge e m6(rhs act6)=Some(Vsingle(Float32.mul(scale qi)(scale qy)))).
 { change(pure_rval Execution.ge e m6(Ebinop Omul(scalar Source.__a)(scalar Source.__c)tfloat)=Some(Vsingle(Float32.mul(scale qi)(scale qy))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho6 q out qi qx qy qz)m6 Source._ac b_ac(rhs act6)(Vsingle(Float32.mul(scale qi)(scale qy)))(Float32.mul(scale qi)(scale qy))SEP NL CT6 L_ac RV6 ltac:(reflexivity))as[m7[A6[CT7 ST6]]].
 assert(V7_0:pure_rval Execution.ge e m7(scalar Source.__a)=Some(Vsingle(scale qi))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT7)|exact L__a|reflexivity]. }
 assert(V7_3:pure_rval Execution.ge e m7(scalar Source.__d)=Some(Vsingle(scale qz))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT7)|exact L__d|reflexivity]. }
 assert(RV7:pure_rval Execution.ge e m7(rhs act7)=Some(Vsingle(Float32.mul(scale qi)(scale qz)))).
 { change(pure_rval Execution.ge e m7(Ebinop Omul(scalar Source.__a)(scalar Source.__d)tfloat)=Some(Vsingle(Float32.mul(scale qi)(scale qz))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho7 q out qi qx qy qz)m7 Source._ad b_ad(rhs act7)(Vsingle(Float32.mul(scale qi)(scale qz)))(Float32.mul(scale qi)(scale qz))SEP NL CT7 L_ad RV7 ltac:(reflexivity))as[m8[A7[CT8 ST7]]].
 assert(V8_1:pure_rval Execution.ge e m8(scalar Source.__b)=Some(Vsingle(scale qx))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT8)|exact L__b|reflexivity]. }
 assert(V8_2:pure_rval Execution.ge e m8(scalar Source.__c)=Some(Vsingle(scale qy))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT8)|exact L__c|reflexivity]. }
 assert(RV8:pure_rval Execution.ge e m8(rhs act8)=Some(Vsingle(Float32.mul(scale qx)(scale qy)))).
 { change(pure_rval Execution.ge e m8(Ebinop Omul(scalar Source.__b)(scalar Source.__c)tfloat)=Some(Vsingle(Float32.mul(scale qx)(scale qy))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho8 q out qi qx qy qz)m8 Source._bc b_bc(rhs act8)(Vsingle(Float32.mul(scale qx)(scale qy)))(Float32.mul(scale qx)(scale qy))SEP NL CT8 L_bc RV8 ltac:(reflexivity))as[m9[A8[CT9 ST8]]].
 assert(V9_1:pure_rval Execution.ge e m9(scalar Source.__b)=Some(Vsingle(scale qx))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT9)|exact L__b|reflexivity]. }
 assert(V9_3:pure_rval Execution.ge e m9(scalar Source.__d)=Some(Vsingle(scale qz))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT9)|exact L__d|reflexivity]. }
 assert(RV9:pure_rval Execution.ge e m9(rhs act9)=Some(Vsingle(Float32.mul(scale qx)(scale qz)))).
 { change(pure_rval Execution.ge e m9(Ebinop Omul(scalar Source.__b)(scalar Source.__d)tfloat)=Some(Vsingle(Float32.mul(scale qx)(scale qz))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho9 q out qi qx qy qz)m9 Source._bd b_bd(rhs act9)(Vsingle(Float32.mul(scale qx)(scale qz)))(Float32.mul(scale qx)(scale qz))SEP NL CT9 L_bd RV9 ltac:(reflexivity))as[m10[A9[CT10 ST9]]].
 assert(V10_2:pure_rval Execution.ge e m10(scalar Source.__c)=Some(Vsingle(scale qy))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT10)|exact L__c|reflexivity]. }
 assert(V10_3:pure_rval Execution.ge e m10(scalar Source.__d)=Some(Vsingle(scale qz))).
 { unfold scalar;eapply local_float;[exact(context_repr _ _ _ _ _ _ _ _ _ CT10)|exact L__d|reflexivity]. }
 assert(RV10:pure_rval Execution.ge e m10(rhs act10)=Some(Vsingle(Float32.mul(scale qy)(scale qz)))).
 { change(pure_rval Execution.ge e m10(Ebinop Omul(scalar Source.__c)(scalar Source.__d)tfloat)=Some(Vsingle(Float32.mul(scale qy)(scale qz))));apply mul_value;try reflexivity;assumption. }
 destruct(write_local e q out qi qx qy qz(rho10 q out qi qx qy qz)m10 Source._cd b_cd(rhs act10)(Vsingle(Float32.mul(scale qy)(scale qz)))(Float32.mul(scale qy)(scale qz))SEP NL CT10 L_cd RV10 ltac:(reflexivity))as[m11[A10[CT11 ST10]]].
 change(atomic_eval Execution.ge e m act0=Some(Vsingle(scale qi),m1))in A0.
 change(atomic_eval Execution.ge e m1 act1=Some(Vsingle(scale qx),m2))in A1.
 change(atomic_eval Execution.ge e m2 act2=Some(Vsingle(scale qy),m3))in A2.
 change(atomic_eval Execution.ge e m3 act3=Some(Vsingle(scale qz),m4))in A3.
 change(atomic_eval Execution.ge e m4 act4=Some(Vsingle(Float32.sub(Float32.mul(scale qi)(scale qi))(Float32.of_int(Int.repr 1))),m5))in A4.
 change(atomic_eval Execution.ge e m5 act5=Some(Vsingle(Float32.mul(scale qi)(scale qx)),m6))in A5.
 change(atomic_eval Execution.ge e m6 act6=Some(Vsingle(Float32.mul(scale qi)(scale qy)),m7))in A6.
 change(atomic_eval Execution.ge e m7 act7=Some(Vsingle(Float32.mul(scale qi)(scale qz)),m8))in A7.
 change(atomic_eval Execution.ge e m8 act8=Some(Vsingle(Float32.mul(scale qx)(scale qy)),m9))in A8.
 change(atomic_eval Execution.ge e m9 act9=Some(Vsingle(Float32.mul(scale qx)(scale qz)),m10))in A9.
 change(atomic_eval Execution.ge e m10 act10=Some(Vsingle(Float32.mul(scale qy)(scale qz)),m11))in A10.
 exists m11;split.
 - change(stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip[act0;act1;act2;act3;act4;act5;act6;act7;act8;act9;act10])m=Some(Nnormal,m11)).
 cbn[fold_right stmt_eval];rewrite A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10;reflexivity.
 - split;[exact CT11|].
 eapply stores_step;[|right;exists Source._cd,tfloat;exact L_cd|exact ST10].
 eapply stores_step;[|right;exists Source._bd,tfloat;exact L_bd|exact ST9].
 eapply stores_step;[|right;exists Source._bc,tfloat;exact L_bc|exact ST8].
 eapply stores_step;[|right;exists Source._ad,tfloat;exact L_ad|exact ST7].
 eapply stores_step;[|right;exists Source._ac,tfloat;exact L_ac|exact ST6].
 eapply stores_step;[|right;exists Source._ab,tfloat;exact L_ab|exact ST5].
 eapply stores_step;[|right;exists Source._a2_1,tfloat;exact L_a2_1|exact ST4].
 eapply stores_step;[|right;exists Source.__d,tfloat;exact L__d|exact ST3].
 eapply stores_step;[|right;exists Source.__c,tfloat;exact L__c|exact ST2].
 eapply stores_step;[|right;exists Source.__b,tfloat;exact L__b|exact ST1].
 eapply stores_step;[|right;exists Source.__a,tfloat;exact L__a|exact ST0].
 constructor.
Qed.
End BODY.
Print Assumptions locals_body.
