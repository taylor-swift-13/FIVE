From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
From FiveLowpassUpdateCase Require Import Contract.
Definition filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Definition input_var(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Definition filter_var:=Evalof(Evar Source._filter filter_type)filter_type.
Definition field(id:ident):expr:=Efield(Evalof(Ederef filter_var(Tstruct Source._FirstOrderLowPass noattr))(Tstruct Source._FirstOrderLowPass noattr))id tfloat.
Definition fv(id:ident):expr:=Evalof(field id)tfloat.
Definition unit:expr:=(Eval(Vsingle one)tfloat).
Definition formula:expr:=Ebinop Odiv (Ebinop Oadd (Ebinop Oadd(input_var Source._value)(fv Source._last_in)tfloat)(Ebinop Omul(Ebinop Osub(fv Source._time_const)unit tfloat)(fv Source._last_out)tfloat)tfloat)(Ebinop Oadd unit(fv Source._time_const)tfloat)tfloat.
Lemma field_location:forall e m bp b p id delta,
 e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (id=Source._time_const /\ delta=0) \/ (id=Source._last_in /\ delta=4) \/ (id=Source._last_out /\ delta=8)->
 pure_lval Execution.ge e m(field id)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof. intros e m bp b p id delta LP LD ID;unfold field;eapply struct_field.
 - unfold filter_var,filter_type;eapply pointer_variable;eauto.
 - reflexivity.
 - destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];reflexivity.
Qed.
Lemma field_value:forall e m bp b p id delta x,
 writable12 m b p->e!Source._filter=Some(bp,filter_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (id=Source._time_const /\delta=0)\/(id=Source._last_in /\delta=4)\/(id=Source._last_out /\delta=8)->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+delta)=Some(Vsingle x)->
 pure_rval Execution.ge e m(fv id)=Some(Vsingle x).
Proof.
 intros e m bp b p id delta x W LP PF ID LD.
 assert(D:In delta[0;4;8])by(destruct ID as[[_ ->]|[[_ ->]|[_ ->]]];simpl;auto).
 change(match pure_lval Execution.ge e m(field id)with Some(bx,ofs,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m bx ofs bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle x)).
 rewrite(field_location e m bp b p id delta LP PF ID).
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite(field_pointer m b p delta W D);rewrite zle_true by(destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+delta+4<=18446744073709551616);destruct D as[<-|[<-|[<-|[]]]];lia).
 rewrite LD;reflexivity.
Qed.
Lemma formula_value:forall e m bp bv b p tc li lo value,
 Initialized m b p tc li lo -> e!Source._filter=Some(bp,filter_type)->e!Source._value=Some(bv,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->Mem.load Mfloat32 m bv 0=Some(Vsingle value)->
 pure_rval Execution.ge e m formula=Some(Vsingle(output tc li lo value)).
Proof.
 intros e m bp bv b p tc li lo value [W[TC[LI LO]]] LP LV PF VF.
 pose proof(field_value e m bp b p Source._time_const 0 tc W LP PF ltac:(left;auto)TC)as T.
 pose proof(field_value e m bp b p Source._last_in 4 li W LP PF ltac:(right;left;auto)LI)as I.
 pose proof(field_value e m bp b p Source._last_out 8 lo W LP PF ltac:(right;right;auto)LO)as O.
 pose proof(float_variable Execution.ge e m Source._value bv value LV VF)as V.
 change(pure_rval Execution.ge e m(input_var Source._value)=Some(Vsingle value))in V.
 unfold formula;cbn[pure_rval];fold(pure_rval Execution.ge e m(fv Source._time_const));fold(pure_rval Execution.ge e m(fv Source._last_in));fold(pure_rval Execution.ge e m(fv Source._last_out));fold(pure_rval Execution.ge e m(input_var Source._value)).
 rewrite T,I,O,V;reflexivity.
Qed.

Lemma update_body_eval:forall e m bp bv bo b p tc li lo value m0 m1 m2,
 Initialized m b p tc li lo ->
 e!Source._filter=Some(bp,filter_type)->e!Source._value=Some(bv,tfloat)->e!Source._out=Some(bo,tfloat)->
 Mem.load Mptr m bp 0=Some(Vptr b p)->Mem.load Mfloat32 m bv 0=Some(Vsingle value)->
 bp<>b->bv<>b->bo<>b->bp<>bo->bv<>bo->
 Mem.store Mfloat32 m bo 0(Vsingle(output tc li lo value))=Some m0->
 Mem.store Mfloat32 m0 b(Ptrofs.unsigned p+4)(Vsingle value)=Some m1->
 Mem.store Mfloat32 m1 b(Ptrofs.unsigned p+8)(Vsingle(output tc li lo value))=Some m2->
 stmt_eval Execution.ge e tfloat(fn_body Source.f_update_first_order_low_pass)m=Some(Nreturn(Vsingle(output tc li lo value)),m2).
Proof.
 intros e m bp bv bo b p tc li lo value m0 m1 m2 P LP LV LO PF VF PB VB OB PO VO S0 S4 S8.
 pose proof(proj1 P)as W.
 assert(PF0:Mem.load Mptr m0 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S0||(left;exact PO));exact PF).
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b p))by(erewrite Mem.load_store_other by(exact S4||(left;exact PB));exact PF0).
 assert(VF0:Mem.load Mfloat32 m0 bv 0=Some(Vsingle value))by(erewrite Mem.load_store_other by(exact S0||(left;exact VO));exact VF).
 assert(OF0:Mem.load Mfloat32 m0 bo 0=Some(Vsingle(output tc li lo value)))by(erewrite Mem.load_store_same by exact S0;reflexivity).
 assert(OF1:Mem.load Mfloat32 m1 bo 0=Some(Vsingle(output tc li lo value)))by(erewrite Mem.load_store_other by(exact S4||(left;exact OB));exact OF0).
 assert(OF2:Mem.load Mfloat32 m2 bo 0=Some(Vsingle(output tc li lo value)))by(erewrite Mem.load_store_other by(exact S8||(left;exact OB));exact OF1).
 assert(E0:atomic_eval Execution.ge e m(Eassign(Evar Source._out tfloat)formula tfloat)=Some(Vsingle(output tc li lo value),m0)).
 { eapply assign_float;try reflexivity.
 - cbn[pure_lval];rewrite LO,dec_eq_true;reflexivity.
 - eapply formula_value;eauto.
 - rewrite Ptrofs.unsigned_zero;change(4<=18446744073709551616);lia.
 - rewrite Ptrofs.unsigned_zero;exact S0. }
 assert(E1:atomic_eval Execution.ge e m0(Eassign(field Source._last_in)(input_var Source._value)tfloat)=Some(Vsingle value,m1)).
 { eapply assign_float;try reflexivity.
 - eapply field_location;[exact LP|exact PF0|right;left;auto].
 - unfold input_var;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+4+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 4 W ltac:(simpl;auto));exact S4. }
 assert(E2:atomic_eval Execution.ge e m1(Eassign(field Source._last_out)(input_var Source._out)tfloat)=Some(Vsingle(output tc li lo value),m2)).
 { eapply assign_float;try reflexivity.
 - eapply field_location;[exact LP|exact PF1|right;right;auto].
 - unfold input_var;eapply float_variable;eauto.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));destruct W as[_[NW _]];change(Ptrofs.unsigned p+12<=18446744073709551616)in NW;change(Ptrofs.unsigned p+8+4<=18446744073709551616);lia.
 - rewrite(field_pointer m b p 8 W ltac:(simpl;auto));exact S8. }
 change(stmt_eval Execution.ge e tfloat(Ssequence(Sdo(Eassign(Evar Source._out tfloat)formula tfloat))(Ssequence(Sdo(Eassign(field Source._last_in)(input_var Source._value)tfloat))(Ssequence(Sdo(Eassign(field Source._last_out)(input_var Source._out)tfloat))(Sreturn(Some(input_var Source._out))))))m=Some(Nreturn(Vsingle(output tc li lo value)),m2)).
 cbn[stmt_eval];rewrite E0,E1,E2;unfold input_var;rewrite(float_variable _ _ _ _ _ _ LO OF2);reflexivity.
Qed.
Print Assumptions update_body_eval.
