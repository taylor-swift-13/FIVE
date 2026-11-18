From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassReset Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Lemma reset_body_eval: forall e m bp bv b value m1 m2,
 e!Source._filter=Some(bp,filter_type) ->
 e!Source._value=Some(bv,tfloat) ->
 Mem.load Mptr m bp 0=Some(Vptr b Ptrofs.zero) ->
 Mem.load Mfloat32 m bv 0=Some(Vsingle value) ->
 bp<>b -> bv<>b ->
 Mem.store Mfloat32 m b 4(Vsingle value)=Some m1 ->
 Mem.store Mfloat32 m1 b 8(Vsingle value)=Some m2 ->
 stmt_eval Execution.ge e tfloat(fn_body Source.f_reset_first_order_low_pass)m=
 Some(Nreturn(Vsingle value),m2).
Proof.
 intros e m bp bv b value m1 m2 LP LV PF VF PB VB S1 S2.
 let co := eval vm_compute in ((genv_cenv Execution.ge)!Source._FirstOrderLowPass) in assert(LAY:((genv_cenv Execution.ge)!Source._FirstOrderLowPass)=co)by reflexivity.
 cbn[Execution.ge genv_cenv Csem.globalenv]in LAY.
 assert(PF1:Mem.load Mptr m1 bp 0=Some(Vptr b Ptrofs.zero)).
 { erewrite Mem.load_store_other by(exact S1|| (left;exact PB));exact PF. }
 assert(VF1:Mem.load Mfloat32 m1 bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_other by(exact S1|| (left;exact VB));exact VF. }
 assert(VF2:Mem.load Mfloat32 m2 bv 0=Some(Vsingle value)).
 { erewrite Mem.load_store_other by(exact S2|| (left;exact VB));exact VF1. }
 cbn[fn_body Source.f_reset_first_order_low_pass stmt_eval atomic_eval pure_lval pure_rval typeof].
 rewrite ?LP,?LV;cbn[filter_type];rewrite ?dec_eq_true.
 cbn[Cexec.do_deref_loc access_mode type_is_volatile Mem.loadv tptr tfloat noattr];rewrite ?Ptrofs.unsigned_zero; cbn; rewrite PF,VF.
 try rewrite (zle_true _ (size_chunk Mptr) Ptrofs.modulus _ _ ltac:(change(8<=18446744073709551616);lia)).
 try rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[Cexec.do_deref_loc tptr tfloat noattr access_mode type_is_volatile].
 rewrite ?LAY;
 cbn[field_offset field_offset_rec sizeof alignof];cbn;unfold ident_eq;rewrite ?dec_eq_true;repeat rewrite dec_eq_false by discriminate;
 cbn[commit sem_cast classify_cast Cexec.do_assign_loc access_mode type_is_volatile Mem.storev tfloat noattr].
 rewrite ?Ptrofs.add_zero_l,?Ptrofs.unsigned_repr;
 try rewrite (zle_true _ (size_chunk Mptr) Ptrofs.modulus _ _ ltac:(change(8<=18446744073709551616);lia)).
 try rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[Cexec.do_deref_loc tptr tfloat noattr access_mode type_is_volatile].
 rewrite S1.
 cbn[stmt_eval atomic_eval pure_lval pure_rval typeof].
 rewrite ?LP,?LV;cbn[filter_type];rewrite ?dec_eq_true.
 cbn[Cexec.do_deref_loc access_mode type_is_volatile Mem.loadv tptr tfloat noattr];rewrite ?Ptrofs.unsigned_zero; cbn; rewrite ?PF1,?VF1.
 try rewrite (zle_true _ (size_chunk Mptr) Ptrofs.modulus _ _ ltac:(change(8<=18446744073709551616);lia)).
 try rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[Cexec.do_deref_loc tptr tfloat noattr access_mode type_is_volatile].
 rewrite ?LAY;
 cbn[field_offset field_offset_rec sizeof alignof];cbn;unfold ident_eq;rewrite ?dec_eq_true;repeat rewrite dec_eq_false by discriminate;
 cbn[commit sem_cast classify_cast Cexec.do_assign_loc access_mode type_is_volatile Mem.storev tfloat noattr].
 rewrite ?Ptrofs.add_zero_l,?Ptrofs.unsigned_repr;
 try rewrite (zle_true _ (size_chunk Mptr) Ptrofs.modulus _ _ ltac:(change(8<=18446744073709551616);lia)).
 try rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[Cexec.do_deref_loc tptr tfloat noattr access_mode type_is_volatile].
 try rewrite (zle_true _ 12 Ptrofs.modulus _ _ ltac:(change(12<=18446744073709551616);lia)).
 unfold commit;cbn[sem_cast classify_cast Cexec.do_assign_loc tfloat noattr access_mode type_is_volatile Mem.storev];rewrite Ptrofs.add_zero_l;rewrite Ptrofs.unsigned_repr by(change(0<=8<=18446744073709551615);lia);rewrite zle_true by(change(12<=18446744073709551616);lia).
rewrite S2;cbv[tfloat attr_of_type noattr attr_volatile];cbn.
 cbn[stmt_eval pure_rval pure_lval typeof].
 rewrite ?LV;rewrite ?dec_eq_true.
 cbn[Cexec.do_deref_loc access_mode type_is_volatile Mem.loadv tptr tfloat noattr];rewrite ?Ptrofs.unsigned_zero;try rewrite zle_true by(change(4<=18446744073709551616);lia);rewrite VF2;reflexivity.
 all: try(change(0<=4<=18446744073709551615);lia);try(change(0<=8<=18446744073709551615);lia).
Qed.
Print Assumptions reset_body_eval.
