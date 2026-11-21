From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import PureEval InitState TrigData PackedPrefix EncoderMachine.
From PprzTrigInitSupport Require Import Compound EncoderBody.
Local Opaque Source.prog.
Open Scope Z_scope.
Lemma encoder_low_raw : forall e m m1 bv bc bb v c,
 e!Source._val=Some(bv,tshort) ->e!Source._cnt=Some(bc,tshort) ->
 e!Source._data_buf_12=None ->Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
 Mem.load Mint16signed m bv 0=Some(Vint v) ->Mem.load Mint16signed m bc 0=Some(Vint c) ->
 Mem.store Mint8unsigned m bb(Ptrofs.unsigned(encoder_offset c))(Vint(encoder_low_machine v))=Some m1 ->
 atom_eval(Csem.globalenv Source.prog)e m encode_low=Some(Vint(encoder_low_machine v),m1).
Proof.
 intros e m m1 bv bc bb v c BV BC LOCAL SYMBOL LV LC STORE.
 unfold encode_low,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body atom_eval pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite BV,BC,LOCAL,SYMBOL.
 unfold tshort,tint,tuchar,tarray,tptr. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite!Ptrofs.unsigned_zero.
 rewrite!zle_true by(change(2<=18446744073709551616);lia).
 rewrite LV,LC.
 cbv beta iota zeta delta[sem_binary_operation sem_mod sem_add sem_add_ptr_int ptrofs_of_int sem_binarith classify_binarith
 binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
 assert(E0:Int.eq(Int.repr 256)Int.zero=false)by(vm_compute;reflexivity).
 assert(EM:Int.eq(Int.repr 256)Int.mone=false)by(vm_compute;reflexivity).
 rewrite E0,EM,!andb_false_r. cbn [orb].
 fold(encoder_offset c). fold(encoder_low_machine v).
 cbn [Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
 rewrite zle_true by(pose proof(Ptrofs.unsigned_range(encoder_offset c));lia).
 rewrite STORE;reflexivity.
Qed.
Lemma encoder_low_fact : forall e m m1 bb cnt,
 0<=cnt<6434 ->short_cell e m Source._val(table_at cnt) ->short_cell e m Source._cnt cnt ->
 e!Source._data_buf_12=None ->Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
 Mem.store Mint8unsigned m bb cnt(Vint(Int.repr(low_written cnt)))=Some m1 ->
 atom_eval(Csem.globalenv Source.prog)e m encode_low=Some(Vint(Int.repr(low_written cnt)),m1).
Proof.
 intros e m m1 bb cnt C[bv[BV[LV RV]]][bc[BC[LC RC]]]LOCAL SYMBOL STORE.
 destruct(literal_encoder_machine cnt C)as[LOW[HIGH[COND[VAL REST]]]].
 rewrite<-VAL. eapply encoder_low_raw;eauto. rewrite LOW,VAL;exact STORE.
Qed.
