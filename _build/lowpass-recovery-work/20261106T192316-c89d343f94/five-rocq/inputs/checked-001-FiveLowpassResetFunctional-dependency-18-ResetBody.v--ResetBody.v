From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassReset Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Definition reset_input:=Evalof(Evar Source._value tfloat)tfloat.
Definition reset_filter:=Evalof(Evar Source._filter filter_type)filter_type.
Definition reset_field(id:ident):expr:=Efield(Evalof(Ederef reset_filter(Tstruct Source._FirstOrderLowPass noattr))(Tstruct Source._FirstOrderLowPass noattr))id tfloat.
Lemma reset_location:forall e m bp b p id delta,
 e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (id=Source._last_in /\ delta=4) \/ (id=Source._last_out /\ delta=8)->
 pure_lval Execution.ge e m(reset_field id)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof.
 intros e m bp b p id delta LP LD ID;unfold reset_field;eapply struct_field.
 - unfold reset_filter,filter_type;eapply pointer_variable;eauto.
 - reflexivity.
 - destruct ID as[[-> ->]|[-> ->]];reflexivity.
Qed.
Lemma reset_body_eval:forall e m bp bv b p value m1 m2,
 writable12 m b p ->
 e!Source._filter=Some(bp,filter_type)->e!Source._value=Some(bv,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->Mem.load Mfloat32 m bv 0=Some(Vsingle value)->
 bp<>b->bv<>b->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p+4)(Vsingle value)=Some m1->
 Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+8)(Vsingle value)=Some m2->
 stmt_eval Execution.ge e tfloat(fn_body Source.f_reset_first_order_low_pass)m=Some(Nreturn(Vsingle value),m2).
Proof.
 intros e m bp bv b p value m1 m2 W LP LV PF VF PB VB S1 S2.
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S1||(left;exact PB));exact PF).
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S1||(left;exact VB));exact VF).
 assert(VF2:Mem.load Mfloat32 m2 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S2||(left;exact VB));exact VF1).
 assert(E1:atomic_eval Execution.ge e m(Eassign(reset_field Source._last_in)reset_input tfloat)=Some(Vsingle value,m1)).
 { eapply assign_float;try reflexivity.
 - eapply reset_location;[exact LP|exact PF|left;auto].
 - unfold reset_input;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+4+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));exact S1. }
 assert(E2:atomic_eval Execution.ge e m1(Eassign(reset_field Source._last_out)reset_input tfloat)=Some(Vsingle value,m2)).
 { eapply assign_float;try reflexivity.
 - eapply reset_location;[exact LP|exact PF1|right;auto].
 - unfold reset_input;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));exact S2. }
 change (stmt_eval Execution.ge e tfloat (Ssequence (Sdo (Eassign (reset_field Source._last_in) reset_input tfloat)) (Ssequence (Sdo (Eassign (reset_field Source._last_out) reset_input tfloat)) (Sreturn (Some reset_input)))) m = Some(Nreturn(Vsingle value),m2)).
 cbn[stmt_eval];rewrite E1,E2;unfold reset_input;rewrite(float_variable _ _ _ _ _ _ LV VF2);reflexivity.
Qed.
Print Assumptions reset_body_eval.
