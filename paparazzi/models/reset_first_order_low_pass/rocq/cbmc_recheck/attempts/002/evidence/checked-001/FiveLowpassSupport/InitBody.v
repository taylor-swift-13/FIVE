From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassInit Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Definition input_var(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Definition filter_var:expr:=Evalof(Evar Source._filter filter_type)filter_type.
Definition output_field(id:ident):expr:=Efield(Evalof(Ederef filter_var(Tstruct Source._FirstOrderLowPass noattr))(Tstruct Source._FirstOrderLowPass noattr))id tfloat.
Definition coefficient(tau h:float32):float32:=Float32.div(Float32.mul(Float32.of_bits(Int.repr 1073741824))tau)h.
Definition ratio:expr:=Ebinop Odiv(Ebinop Omul(Eval(Vsingle(Float32.of_bits(Int.repr 1073741824)))tfloat)(input_var Source._tau)tfloat)(input_var Source._sample_time)tfloat.
Lemma output_location:forall e m bp b p id delta,
 e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (id=Source._time_const /\ delta=0) \/ (id=Source._last_in /\ delta=4) \/ (id=Source._last_out /\ delta=8)->
 pure_lval Execution.ge e m(output_field id)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof.
 intros e m bp b p id delta LP LD ID.
 unfold output_field; eapply struct_field.
 - unfold filter_var,filter_type;eapply pointer_variable;eauto.
 - reflexivity.
 - destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];reflexivity.
Qed.
Lemma ratio_value:forall e m bt bh tau h,
 e!Source._tau=Some(bt,tfloat)->e!Source._sample_time=Some(bh,tfloat)->
 Mem.load Mfloat32 m bt 0=Some(Vsingle tau)->Mem.load Mfloat32 m bh 0=Some(Vsingle h)->
 pure_rval Execution.ge e m ratio=Some(Vsingle(coefficient tau h)).
Proof.
 intros;unfold ratio;cbn[pure_rval];fold(pure_rval Execution.ge e m(input_var Source._tau));fold(pure_rval Execution.ge e m(input_var Source._sample_time)).
 rewrite(float_variable _ _ _ _ _ _ H H1),(float_variable _ _ _ _ _ _ H0 H2);reflexivity.
Qed.
Lemma init_body_eval:forall e m bp bv bt bh b p value tau h m1 m2 m3,
 writable12 m b p ->
 e!Source._filter=Some(bp,filter_type)->e!Source._value=Some(bv,tfloat)->
 e!Source._tau=Some(bt,tfloat)->e!Source._sample_time=Some(bh,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->
 Mem.load Mfloat32 m bv 0=Some(Vsingle value)->Mem.load Mfloat32 m bt 0=Some(Vsingle tau)->Mem.load Mfloat32 m bh 0=Some(Vsingle h)->
 bp<>b->bv<>b->bt<>b->bh<>b->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p+4)(Vsingle value)=Some m1->Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+8)(Vsingle value)=Some m2->Mem.store Mfloat32 m2 b(Ptrofs.unsigned p+0)(Vsingle(coefficient tau h))=Some m3->
 stmt_eval Execution.ge e tvoid(fn_body Source.f_init_first_order_low_pass)m=Some(Nnormal,m3).
Proof.
 intros e m bp bv bt bh b p value tau h m1 m2 m3 W LP LV LT LH PF VF TF HF PB VB TB HB S1 S2 S3.
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S1||(left;exact PB));exact PF).
 assert(PF2:Mem.load Mptr m2 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S2||(left;exact PB));exact PF1).
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S1||(left;exact VB));exact VF).
 assert(TF2:Mem.load Mfloat32 m2 bt 0=Some(Vsingle tau)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact TB));erewrite Mem.load_store_other by(exact S1||(left;exact TB));exact TF. }
 assert(HF2:Mem.load Mfloat32 m2 bh 0=Some(Vsingle h)).
 { erewrite Mem.load_store_other by(exact S2||(left;exact HB));erewrite Mem.load_store_other by(exact S1||(left;exact HB));exact HF. }
 assert(E1:atomic_eval Execution.ge e m(Eassign(output_field Source._last_in)(input_var Source._value)tfloat)=Some(Vsingle value,m1)).
 { eapply assign_float;try reflexivity.
 - eapply output_location;[exact LP|exact PF|right;left;auto].
 - eapply float_variable;eauto.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+4+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));exact S1. }
 assert(E2:atomic_eval Execution.ge e m1(Eassign(output_field Source._last_out)(input_var Source._value)tfloat)=Some(Vsingle value,m2)).
 { eapply assign_float;try reflexivity.
 - eapply output_location;[exact LP|exact PF1|right;right;auto].
 - eapply float_variable;eauto.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));exact S2. }
 assert(E3:atomic_eval Execution.ge e m2(Eassign(output_field Source._time_const)ratio tfloat)=Some(Vsingle(coefficient tau h),m3)).
 { eapply assign_float;try reflexivity.
 - eapply output_location;[exact LP|exact PF2|left;auto].
 - eapply ratio_value;eauto.
 - rewrite(field_pointer m b p 0 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+0+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 0 W ltac:(simpl;auto));exact S3. }
 change(stmt_eval Execution.ge e tvoid(Ssequence(Sdo(Eassign(output_field Source._last_in)(input_var Source._value)tfloat))(Ssequence(Sdo(Eassign(output_field Source._last_out)(input_var Source._value)tfloat))(Sdo(Eassign(output_field Source._time_const)ratio tfloat))))m=Some(Nnormal,m3)).
 cbn[stmt_eval].
 rewrite E1,E2,E3;reflexivity.
Qed.
Print Assumptions init_body_eval.
