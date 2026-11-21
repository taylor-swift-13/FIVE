From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassSupport Require Import Expressions.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import PidMemory Contract Expressions.
Import ListNotations.
Local Open Scope Z_scope.
Definition formula:expr:=
 Ebinop Oadd(Ebinop Oadd(Ebinop Oadd(slotval Source._u 2 1)
 (Ebinop Omul(slotval Source._g 3 0)(slotval Source._e 3 0)tfloat)tfloat)
 (Ebinop Omul(slotval Source._g 3 1)(slotval Source._e 3 1)tfloat)tfloat)
 (Ebinop Omul(slotval Source._g 3 2)(slotval Source._e 3 2)tfloat)tfloat.
Lemma formula_value:forall e m bp b p a bc c u0 e0 e1 x,
 writable32 m b p->e!Source._pid=Some(bp,pid_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+4)=Some(Vsingle u0)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+20)=Some(Vsingle a)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+24)=Some(Vsingle bc)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+28)=Some(Vsingle c)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+8)=Some(Vsingle x)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+12)=Some(Vsingle e0)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+16)=Some(Vsingle e1)->
 pure_rval Execution.ge e m formula=Some(Vsingle(fp_step a bc c u0 e0 e1 x)).
Proof.
 intros e m bp b p a bc c u0 e0 e1 x W LP PF L4 L20 L24 L28 L8 L12 L16.
 pose proof(slot_value e m bp b p Source._u 2 1 4 u0 W LP PF ltac:(unfold Slot;auto 8) L4)as V4.
 pose proof(slot_value e m bp b p Source._g 3 0 20 a W LP PF ltac:(unfold Slot;auto 8) L20)as V20.
 pose proof(slot_value e m bp b p Source._g 3 1 24 bc W LP PF ltac:(unfold Slot;auto 8) L24)as V24.
 pose proof(slot_value e m bp b p Source._g 3 2 28 c W LP PF ltac:(unfold Slot;auto 8) L28)as V28.
 pose proof(slot_value e m bp b p Source._e 3 0 8 x W LP PF ltac:(unfold Slot;auto 8) L8)as V8.
 pose proof(slot_value e m bp b p Source._e 3 1 12 e0 W LP PF ltac:(unfold Slot;auto 8) L12)as V12.
 pose proof(slot_value e m bp b p Source._e 3 2 16 e1 W LP PF ltac:(unfold Slot;auto 8) L16)as V16.
 unfold formula;cbn[pure_rval];fold(pure_rval Execution.ge e m(slotval Source._u 2 1));fold(pure_rval Execution.ge e m(slotval Source._g 3 0));fold(pure_rval Execution.ge e m(slotval Source._g 3 1));fold(pure_rval Execution.ge e m(slotval Source._g 3 2));fold(pure_rval Execution.ge e m(slotval Source._e 3 0));fold(pure_rval Execution.ge e m(slotval Source._e 3 1));fold(pure_rval Execution.ge e m(slotval Source._e 3 2));
 rewrite V4,V20,V24,V28,V8,V12,V16;reflexivity.
Qed.

Definition BodyTrace(e:env)(m m1 m2 m3 m4 m5:mem)(bp b:block)(p:ptrofs)(a bc c u0 e0 e1 x:float32):Prop:=
 atomic_eval Execution.ge e m(Eassign (slot Source._e 3 2) (slotval Source._e 3 1) tfloat)=Some(Vsingle e1,m1) /\
 atomic_eval Execution.ge e m1(Eassign (slot Source._e 3 1) (slotval Source._e 3 0) tfloat)=Some(Vsingle e0,m2) /\
 atomic_eval Execution.ge e m2(Eassign (slot Source._e 3 0) input_var tfloat)=Some(Vsingle x,m3) /\
 atomic_eval Execution.ge e m3(Eassign (slot Source._u 2 1) (slotval Source._u 2 0) tfloat)=Some(Vsingle u0,m4) /\
 atomic_eval Execution.ge e m4(Eassign (slot Source._u 2 0) formula tfloat)=Some(Vsingle (fp_step a bc c u0 e0 e1 x),m5) /\
 (forall mm,In mm[m;m1;m2;m3;m4;m5]->writable32 mm b p /\Mem.load Mptr mm bp 0=Some(Vptr b p)) /\
 pure_rval Execution.ge e m5(slotval Source._u 2 0)=Some(Vsingle(fp_step a bc c u0 e0 e1 x)).
Lemma update_body_trace:forall e m bp bv b p a bc c u0 u1 e0 e1 e2 x m1 m2 m3 m4 m5,
 Initialized m b p a bc c u0 u1 e0 e1 e2->
 e!Source._pid=Some(bp,pid_type)->e!Source._value=Some(bv,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->Mem.load Mfloat32 m bv 0=Some(Vsingle x)->
 bp<>b->bv<>b->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p+16)(Vsingle e1)=Some m1->
 Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+12)(Vsingle e0)=Some m2->
 Mem.store Mfloat32 m2 b(Ptrofs.unsigned p+8)(Vsingle x)=Some m3->
 Mem.store Mfloat32 m3 b(Ptrofs.unsigned p+4)(Vsingle u0)=Some m4->
 Mem.store Mfloat32 m4 b(Ptrofs.unsigned p+0)(Vsingle(fp_step a bc c u0 e0 e1 x))=Some m5->
 BodyTrace e m m1 m2 m3 m4 m5 bp b p a bc c u0 e0 e1 x.
Proof.
 intros e m bp bv b p a bc c u0 u1 e0 e1 e2 x m1 m2 m3 m4 m5 INIT LP LV PF VF PB VB S1 S2 S3 S4 S5.
 destruct INIT as[W[L0[L4[L8[L12[L16[L20[L24 L28]]]]]]]].
 assert(W1:writable32 m1 b p)by(eapply store_preserves_writable32;[exact W|exact S1]).
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact S1||(left;exact PB));exact PF. }
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle x)).
 { erewrite Mem.load_store_other by(exact S1||(left;exact VB));exact VF. }
 assert(W2:writable32 m2 b p)by(eapply store_preserves_writable32;[exact W1|exact S2]).
 assert(PF2:Mem.load Mptr m2 bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact PB));exact PF1. }
 assert(VF2:Mem.load Mfloat32 m2 bv 0=Some(Vsingle x)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact VB));exact VF1. }
 assert(W3:writable32 m3 b p)by(eapply store_preserves_writable32;[exact W2|exact S3]).
 assert(PF3:Mem.load Mptr m3 bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact S3||(left;exact PB));exact PF2. }
 assert(W4:writable32 m4 b p)by(eapply store_preserves_writable32;[exact W3|exact S4]).
 assert(PF4:Mem.load Mptr m4 bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact S4||(left;exact PB));exact PF3. }
 assert(W5:writable32 m5 b p)by(eapply store_preserves_writable32;[exact W4|exact S5]).
 assert(PF5:Mem.load Mptr m5 bp 0=Some(Vptr b p)).
 { erewrite Mem.load_store_other by(exact S5||(left;exact PB));exact PF4. }
 assert(READ8:Mem.load Mfloat32 m1 b(Ptrofs.unsigned p+8)=Some(Vsingle e0)).
 { erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact L8. }
 assert(READ0:Mem.load Mfloat32 m3 b(Ptrofs.unsigned p+0)=Some(Vsingle u0)).
 { erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact L0. }
 assert(Q4:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+4)=Some(Vsingle u0)).
 { erewrite Mem.load_store_same by exact S4;reflexivity. }
 assert(Q20:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+20)=Some(Vsingle a)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact L20. }
 assert(Q24:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+24)=Some(Vsingle bc)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact L24. }
 assert(Q28:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+28)=Some(Vsingle c)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S1||(cbn[size_chunk];intuition lia)). exact L28. }
 assert(Q8:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+8)=Some(Vsingle x)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S3;reflexivity. }
 assert(Q12:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+12)=Some(Vsingle e0)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S2;reflexivity. }
 assert(Q16:Mem.load Mfloat32 m4 b(Ptrofs.unsigned p+16)=Some(Vsingle e1)).
 { erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S1;reflexivity. }
 assert(RESULT:Mem.load Mfloat32 m5 b(Ptrofs.unsigned p+0)=Some(Vsingle (fp_step a bc c u0 e0 e1 x))).
 { erewrite Mem.load_store_same by exact S5;reflexivity. }
 assert(E1:atomic_eval Execution.ge e m(Eassign(slot Source._e 3 2)(slotval Source._e 3 1)tfloat)=Some(Vsingle e1,m1)).
 { eapply assign_float;try reflexivity.
 - eapply slot_location;[exact LP|exact PF|unfold Slot;auto 8].
 - eapply slot_value;[exact W|exact LP|exact PF|unfold Slot;auto 8|exact L12].
 - rewrite(field_pointer m b p 16 W ltac:(unfold field_offsets;simpl;tauto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+16+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 16 W ltac:(unfold field_offsets;simpl;tauto));exact S1. }
 assert(E2:atomic_eval Execution.ge e m1(Eassign(slot Source._e 3 1)(slotval Source._e 3 0)tfloat)=Some(Vsingle e0,m2)).
 { eapply assign_float;try reflexivity.
 - eapply slot_location;[exact LP|exact PF1|unfold Slot;auto 8].
 - eapply slot_value;[exact W1|exact LP|exact PF1|unfold Slot;auto 8|exact READ8].
 - rewrite(field_pointer m1 b p 12 W1 ltac:(unfold field_offsets;simpl;tauto));destruct W1 as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+12+4<=18446744073709551616);lia.
 - rewrite(field_pointer m1 b p 12 W1 ltac:(unfold field_offsets;simpl;tauto));exact S2. }
 assert(E3:atomic_eval Execution.ge e m2(Eassign(slot Source._e 3 0)input_var tfloat)=Some(Vsingle x,m3)).
 { eapply assign_float;try reflexivity.
 - eapply slot_location;[exact LP|exact PF2|unfold Slot;auto 8].
 - unfold input_var;eapply float_variable;[exact LV|exact VF2].
 - rewrite(field_pointer m2 b p 8 W2 ltac:(unfold field_offsets;simpl;tauto));destruct W2 as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia.
 - rewrite(field_pointer m2 b p 8 W2 ltac:(unfold field_offsets;simpl;tauto));exact S3. }
 assert(E4:atomic_eval Execution.ge e m3(Eassign(slot Source._u 2 1)(slotval Source._u 2 0)tfloat)=Some(Vsingle u0,m4)).
 { eapply assign_float;try reflexivity.
 - eapply slot_location;[exact LP|exact PF3|unfold Slot;auto 8].
 - eapply slot_value;[exact W3|exact LP|exact PF3|unfold Slot;auto 8|exact READ0].
 - rewrite(field_pointer m3 b p 4 W3 ltac:(unfold field_offsets;simpl;tauto));destruct W3 as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+4+4<=18446744073709551616);lia.
 - rewrite(field_pointer m3 b p 4 W3 ltac:(unfold field_offsets;simpl;tauto));exact S4. }
 assert(E5:atomic_eval Execution.ge e m4(Eassign(slot Source._u 2 0)formula tfloat)=Some(Vsingle (fp_step a bc c u0 e0 e1 x),m5)).
 { eapply assign_float;try reflexivity.
 - eapply slot_location;[exact LP|exact PF4|unfold Slot;auto 8].
 - eapply formula_value;eauto.
 - rewrite(field_pointer m4 b p 0 W4 ltac:(unfold field_offsets;simpl;tauto));destruct W4 as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+0+4<=18446744073709551616);lia.
 - rewrite(field_pointer m4 b p 0 W4 ltac:(unfold field_offsets;simpl;tauto));exact S5. }
 unfold BodyTrace;split;[exact E1|];split;[exact E2|];split;[exact E3|];split;[exact E4|];split;[exact E5|];split.
 - intros mm IN;repeat destruct IN as[<-|IN];try contradiction;split;assumption.
 - exact(slot_value e m5 bp b p Source._u 2 0 0(fp_step a bc c u0 e0 e1 x)W5 LP PF5 ltac:(unfold Slot;auto 8)RESULT).
Qed.
Print Assumptions update_body_trace.
Lemma update_body_eval:forall e m bp bv b p a bc c u0 u1 e0 e1 e2 x m1 m2 m3 m4 m5,
 Initialized m b p a bc c u0 u1 e0 e1 e2->
 e!Source._pid=Some(bp,pid_type)->e!Source._value=Some(bv,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->Mem.load Mfloat32 m bv 0=Some(Vsingle x)->
 bp<>b->bv<>b->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p+16)(Vsingle e1)=Some m1->
 Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+12)(Vsingle e0)=Some m2->
 Mem.store Mfloat32 m2 b(Ptrofs.unsigned p+8)(Vsingle x)=Some m3->
 Mem.store Mfloat32 m3 b(Ptrofs.unsigned p+4)(Vsingle u0)=Some m4->
 Mem.store Mfloat32 m4 b(Ptrofs.unsigned p+0)(Vsingle(fp_step a bc c u0 e0 e1 x))=Some m5->
 stmt_eval Execution.ge e tfloat(fn_body Source.f_update_pid_df)m=Some(Nreturn(Vsingle(fp_step a bc c u0 e0 e1 x)),m5).
Proof.
 intros e m bp bv b p a bc c u0 u1 e0 e1 e2 x m1 m2 m3 m4 m5 INIT LP LV PF VF PB VB S1 S2 S3 S4 S5.
 destruct(update_body_trace e m bp bv b p a bc c u0 u1 e0 e1 e2 x m1 m2 m3 m4 m5 INIT LP LV PF VF PB VB S1 S2 S3 S4 S5)as[E1[E2[E3[E4[E5[WS RET]]]]]].
 change(stmt_eval Execution.ge e tfloat(Ssequence(Sdo(Eassign(slot Source._e 3 2)(slotval Source._e 3 1)tfloat))(Ssequence(Sdo(Eassign(slot Source._e 3 1)(slotval Source._e 3 0)tfloat))(Ssequence(Sdo(Eassign(slot Source._e 3 0)input_var tfloat))(Ssequence(Sdo(Eassign(slot Source._u 2 1)(slotval Source._u 2 0)tfloat))(Ssequence(Sdo(Eassign(slot Source._u 2 0)formula tfloat))(Sreturn(Some(slotval Source._u 2 0))))))))m=Some(Nreturn(Vsingle(fp_step a bc c u0 e0 e1 x)),m5)).
 cbn[stmt_eval];rewrite E1,E2,E3,E4,E5.
 rewrite RET;reflexivity.
Qed.
Print Assumptions update_body_eval.
