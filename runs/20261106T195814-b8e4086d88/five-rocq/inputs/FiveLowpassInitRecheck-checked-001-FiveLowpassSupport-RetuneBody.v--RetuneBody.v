From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassRetune Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition retune_filter_type:=tptr(Tstruct Source._FirstOrderLowPass noattr).
Definition retune_coefficient(tau h:float32):float32:=
 Float32.div(Float32.mul(Float32.of_bits(Int.repr 1073741824))tau)h.
Lemma retune_body_eval: forall e m bp bt bh b p tau h m1,
 e!Source._filter=Some(bp,retune_filter_type) ->
 e!Source._tau=Some(bt,tfloat) ->
 e!Source._sample_time=Some(bh,tfloat) ->
 Mem.load Mptr m bp 0=Some(Vptr b p) ->
 Mem.load Mfloat32 m bt 0=Some(Vsingle tau) ->
 Mem.load Mfloat32 m bh 0=Some(Vsingle h) ->
 Ptrofs.unsigned p+12<=Ptrofs.modulus ->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p)(Vsingle(retune_coefficient tau h))=Some m1 ->
 stmt_eval Execution.ge e tvoid(fn_body Source.f_update_first_order_low_pass_tau)m=
 Some(Nnormal,m1).
Proof.
 intros e m bp bt bh b p tau h m1 LP LT LH PF TF HF BOUND ST.
 let co := eval vm_compute in ((genv_cenv Execution.ge)!Source._FirstOrderLowPass) in assert(LAY:((genv_cenv Execution.ge)!Source._FirstOrderLowPass)=co)by reflexivity.
 cbn[Execution.ge genv_cenv Csem.globalenv]in LAY.
 cbn[fn_body Source.f_update_first_order_low_pass_tau stmt_eval atomic_eval pure_lval pure_rval typeof].
 rewrite ?LP,?LT,?LH;cbn[retune_filter_type];rewrite ?dec_eq_true.
 cbn[Cexec.do_deref_loc access_mode type_is_volatile Mem.loadv tptr tfloat noattr];rewrite ?Ptrofs.unsigned_zero;cbn;rewrite ?PF,?TF,?HF.
 try rewrite (zle_true _ (size_chunk Mptr) Ptrofs.modulus _ _ ltac:(change(8<=18446744073709551616);lia)).
 try rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[Cexec.do_deref_loc tptr tfloat noattr access_mode type_is_volatile].
 rewrite ?LAY;
 cbn[field_offset field_offset_rec sizeof alignof];cbn;unfold ident_eq;rewrite ?dec_eq_true;repeat rewrite dec_eq_false by discriminate.
 cbn[commit sem_cast classify_cast Cexec.do_assign_loc access_mode type_is_volatile Mem.storev tfloat noattr].
 rewrite ?Ptrofs.add_zero.
 try rewrite zle_true by lia.
 cbn[sem_binary_operation sem_binarith classify_binarith sem_mul sem_div].
 unfold retune_coefficient in ST.
 rewrite (zle_true _ 4 Ptrofs.modulus _ _ ltac:(change(4<=18446744073709551616);lia)).
 cbn[attr_of_type tfloat noattr attr_volatile size_chunk].
 rewrite zle_true by lia.
 rewrite ST;reflexivity.
Qed.
Print Assumptions retune_body_eval.
