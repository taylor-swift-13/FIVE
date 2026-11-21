From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigLow Require Import Source.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total BranchPure TrigData MachineData.
From PprzTrigInitSupport Require Import Control.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Local Opaque Source.prog.
Definition decoder := Source.f_pprz_trig_int_12.
Definition decoder_expr := match fn_body decoder with Ssequence _ (Sreturn(Some a))=>a|_=>Eval Vundef tint end.
Definition low_offset(a:int):ptrofs := Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr 1)(Ptrofs.of_ints a)).
Definition high_offset(a:int):ptrofs := Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr 1)
 (Ptrofs.of_ints(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1))))).
Definition raw_decoder(k a high low:int):int :=
 Int.or(Int.or k(Int.and(Int.shl high(machine_shift a))(Int.repr 3840)))low.
Lemma decoder_expr_branch_simple : branch_simple decoder_expr=true.
Proof. reflexivity. Qed.
Lemma decoder_expression_reads : forall (ge:Csem.genv)e m bv bk bb a k hi lo,
 e!Source._val=Some(bv,tshort) ->e!Source._k=Some(bk,tshort) ->e!Source._data_buf_12=None ->
 Genv.find_symbol ge Source._data_buf_12=Some bb ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->Mem.load Mint16signed m bk 0=Some(Vint k) ->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(low_offset a))=Some(Vint lo) ->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi) ->
 branch_rval ge e m decoder_expr=Some(Vint(raw_decoder k a hi lo)).
Proof.
 intros ge e m bv bk bb a k hi lo EV EK EB SYM LV LK LL LH.
 unfold decoder_expr,decoder.
 cbv beta iota zeta delta[Source.f_pprz_trig_int_12 fn_body branch_rval branch_lval typeof].
 repeat rewrite dec_eq_true. rewrite EV,EK,EB,SYM.
 unfold Ctypesdefs.tshort,Ctypesdefs.tuchar,Ctypesdefs.tarray,Ctypesdefs.tptr,Ctypesdefs.tint.
 repeat rewrite dec_eq_true.
 cbn[Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite !Ptrofs.unsigned_zero,LV,LK.
 rewrite !zle_true by(change(2<=18446744073709551616);lia).
 cbv beta iota zeta delta[sem_binary_operation sem_add sem_add_ptr_int ptrofs_of_int
  sem_mod sem_shr sem_shl sem_or sem_and sem_binarith classify_binarith binarith_type
  classify_add typeconv sem_cast classify_cast cast_int_int sizeof sem_shift classify_shift
  remove_attributes change_attributes Archi.ptr64 sem_unary_operation bool_val classify_bool].
 assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 rewrite E20,E2M,!andb_false_r.
 change Int.iwordsize with(Int.repr 32).
 assert(SH1:Int.ltu(Int.repr 1)(Int.repr 32)=true)by(vm_compute;reflexivity).
 rewrite SH1. cbn[orb].
 fold(low_offset a);fold(high_offset a).
 cbn[Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite LL,LH.
 rewrite !zle_true by(pose proof(Ptrofs.unsigned_range(low_offset a));pose proof(Ptrofs.unsigned_range(high_offset a));lia).
 unfold raw_decoder,machine_shift.
 destruct(Int.eq(Int.mods a(Int.repr 2))Int.zero);reflexivity.
Qed.
