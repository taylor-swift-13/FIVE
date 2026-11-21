From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Contract Output CallSummary.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FiveRmatOfQuatNoError Require Import Spec.
Local Open Scope Z_scope.
Theorem no_error_proved:Spec.NoError.
Proof. unfold Spec.NoError;intros args m(q&out&qi&qx&qy&qz&EQ&IN);subst args.
 destruct(call_summary m q out qi qx qy qz IN)as[mf[EV[FRAME[BYTES[LOADS ACCESS]]]]].
 eapply defined_evaluator_no_error;[vm_compute;reflexivity|vm_compute;repeat constructor;simpl;intuition discriminate|exact EV]. Qed.
Theorem normal_call_exists:forall m q out qi qx qy qz,Inputs m q out qi qx qy qz->
 exists mf t,star Csem.step Execution.ge(Execution.entry(Args out q)m)t(Returnstate Vundef Kstop mf) /\
 (forall b z n,Mem.valid_block m b->(b<>out\/z+n<=0\/36<=z)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n) /\
 Mem.loadbytes mf out 0 36=Some(matrix_bytes(matrix_values qi qx qy qz)) /\
 (forall i:nat,(i<9)%nat->Mem.load AST.Mfloat32 mf out(Z.of_nat i*4)=Some(Vsingle(nth i(matrix_values qi qx qy qz)Floats.Float32.zero))) /\
 (forall ch b ofs p,Mem.valid_block m b->Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p).
Proof. intros m q out qi qx qy qz IN;destruct(call_summary m q out qi qx qy qz IN)as[mf[EV[FRAME[BYTES[LOADS ACCESS]]]]];exists mf.
 destruct(defined_evaluator_return_exists Execution.ge(Execution.entry(Args out q)m)Vundef mf ltac:(vm_compute;reflexivity)ltac:(vm_compute;repeat constructor;simpl;intuition discriminate) EV)as[t RET];exists t;auto. Qed.
Print Assumptions no_error_proved.
Print Assumptions normal_call_exists.
