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

Definition decoder_select := match fn_body decoder with Ssequence a _=>a|_=>Sskip end.
Definition read_val := Evalof(Evar Source._val tshort)tshort.
Definition read_k := Evalof(Evar Source._k tshort)tshort.
Definition threshold(n:Z):expr := Ebinop Olt read_val(Eval(Vint(Int.repr n))tint)tint.
Definition set_high(x:Z):statement := Sdo(Eassign(Evar Source._k tshort)
 (Ebinop Oshl(Eval(Vint(Int.repr x))tint)(Eval(Vint(Int.repr 12))tint)tint)tshort).
Lemma decoder_select_shape : decoder_select=
 Sifthenelse(threshold 2145)(Sifthenelse(threshold 1035)(set_high 0)(set_high 1))
 (Sifthenelse(threshold 3474)(set_high 2)(set_high 3)).
Proof. reflexivity. Qed.
Lemma short_read : forall ge e m id b a,e!id=Some(b,tshort) ->
 Mem.load Mint16signed m b 0=Some(Vint a) ->
 pure_rval ge e m(Evalof(Evar id tshort)tshort)=Some(Vint a).
Proof.
 intros ge e m id b a ENV LOAD. cbn[pure_rval pure_lval];rewrite dec_eq_true,ENV,dec_eq_true.
 cbn[Cexec.do_deref_loc tshort access_mode type_is_volatile noattr Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_zero. destruct(zle(0+2)Ptrofs.modulus);[rewrite LOAD;reflexivity|].
 assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
Qed.
Lemma threshold_value : forall ge e m bv a n,e!Source._val=Some(bv,tshort) ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->
 pure_rval ge e m(threshold n)=Some(Val.of_bool(Int.cmp Clt a(Int.repr n))).
Proof.
 intros ge e m bv a n EV LOAD.
 change(match pure_rval ge e m read_val with Some vv=>sem_binary_operation ge Olt vv tshort(Vint(Int.repr n))tint m|None=>None end=Some(Val.of_bool(Int.cmp Clt a(Int.repr n)))).
 rewrite(short_read _ _ _ _ _ _ EV LOAD);reflexivity.
Qed.
Lemma short_assign_value : forall ge e m id b rhs v mf,
 e!id=Some(b,tshort) ->typeof rhs=tint ->pure_rval ge e m rhs=Some(Vint v) ->
 sem_cast(Vint v)tint tshort m=Some(Vint v) ->Mem.store Mint16signed m b 0(Vint v)=Some mf ->
 flat_eval ge e m(Eassign(Evar id tshort)rhs tshort)=Some(Vint v,mf).
Proof.
 intros ge e m id b rhs v mf ENV TY EV CAST STORE.
 cbn[flat_eval pure_lval];rewrite dec_eq_true,ENV,dec_eq_true,EV,TY.
 cbn[typeof]. rewrite CAST.
 cbn[Cexec.do_assign_loc tshort type_is_volatile noattr access_mode Mem.storev size_chunk].
 rewrite Ptrofs.unsigned_zero. destruct(zle(0+2)Ptrofs.modulus);[rewrite STORE;reflexivity|].
 assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
Qed.
Lemma set_high_total : forall ge Q f kont e m bk x,
 (x=0\/x=1\/x=2\/x=3) ->e!Source._k=Some(bk,tshort) ->
 Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(Int.repr(x*4096)))=Some middle ->
 total ge Q(State f Sskip kont e middle)) ->
 total ge Q(State f(set_high x)kont e m).
Proof.
 intros ge Q f kont e m bk x BX EK VA END.
 destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.repr(x*4096)))VA)as[middle STORE].
 apply do_total. eapply flat_prefix_total with(v:=Vint(Int.repr(x*4096)))(mf:=middle).
 - reflexivity.
 - reflexivity.
 - apply short_assign_value with(b:=bk);auto;try reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
 - apply do_value_total;apply END;exact STORE.
Qed.
Lemma decoder_select_total : forall ge Q f kont e m bv bk a,
 e!Source._val=Some(bv,tshort) ->e!Source._k=Some(bk,tshort) ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(machine_high_bits a))=Some middle ->
 total ge Q(State f Sskip kont e middle)) ->
 total ge Q(State f decoder_select kont e m).
Proof.
 intros ge Q f kont e m bv bk a EV EK LOAD VA END;rewrite decoder_select_shape.
 eapply if_pure_total with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 2145)))(choice:=Int.cmp Clt a(Int.repr 2145)).
 - reflexivity.
 - eapply threshold_value;eauto.
 - destruct(Int.cmp Clt a(Int.repr 2145));reflexivity.
 - destruct(Int.cmp Clt a(Int.repr 2145))eqn:C2;simpl.
   + eapply if_pure_total with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 1035)))(choice:=Int.cmp Clt a(Int.repr 1035)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * destruct(Int.cmp Clt a(Int.repr 1035));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 1035))eqn:C1;simpl;
       eapply set_high_total;eauto;[auto|intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C1;exact STORE|
                                  auto|intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C1;exact STORE].
   + eapply if_pure_total with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 3474)))(choice:=Int.cmp Clt a(Int.repr 3474)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * destruct(Int.cmp Clt a(Int.repr 3474));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 3474))eqn:C3;simpl;
       eapply set_high_total;eauto;[auto|intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C3;exact STORE|
                                  auto|intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C3;exact STORE].
Qed.
