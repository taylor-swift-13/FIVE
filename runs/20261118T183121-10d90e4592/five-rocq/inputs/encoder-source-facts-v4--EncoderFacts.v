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

Lemma encoder_cond_raw : forall e m bc c,
 e!Source._cnt=Some(bc,tshort) ->Mem.load Mint16signed m bc 0=Some(Vint c) ->
 pure_rval(Csem.globalenv Source.prog)e m encode_cond=Some(Val.of_bool(encoder_even_choice c)).
Proof.
 intros e m bc c BC LC. unfold encode_cond,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite BC. unfold tshort,tint. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(2<=18446744073709551616);lia). rewrite LC.
 cbv beta iota zeta delta[sem_binary_operation sem_mod sem_cmp classify_cmp sem_binarith classify_binarith
 binarith_type typeconv sem_cast classify_cast cast_int_int Archi.ptr64].
 assert(E0:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(EM:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 rewrite E0,EM,!andb_false_r. reflexivity.
Qed.
Lemma encoder_even_raw : forall e m m2 bv bc bb v c,
 e!Source._val=Some(bv,tshort) ->e!Source._cnt=Some(bc,tshort) ->
 e!Source._data_buf_12=None ->Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
 Mem.load Mint16signed m bv 0=Some(Vint v) ->Mem.load Mint16signed m bc 0=Some(Vint c) ->
 Mem.store Mint8unsigned m bb(Ptrofs.unsigned(encoder_offset(encoder_high_index c)))
  (Vint(Int.zero_ext 8(Int.shr(Int.and v(Int.repr 3840))(Int.repr 8))))=Some m2 ->
 atom_eval(Csem.globalenv Source.prog)e m encode_even=
 Some(Vint(Int.zero_ext 8(Int.shr(Int.and v(Int.repr 3840))(Int.repr 8))),m2).
Proof.
 intros e m m2 bv bc bb v c BV BC LOCAL SYMBOL LV LC STORE.
 unfold encode_even,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body atom_eval pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite BV,BC,LOCAL,SYMBOL.
 unfold tshort,tint,tuchar,tarray,tptr. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite!Ptrofs.unsigned_zero. rewrite!zle_true by(change(2<=18446744073709551616);lia). rewrite LV,LC.
 cbv beta iota zeta delta[sem_binary_operation sem_div sem_add sem_add_ptr_int ptrofs_of_int sem_and sem_shr sem_binarith classify_binarith
 binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
 assert(E0:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(EM:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 assert(S8:Int.ltu(Int.repr 8)Int.iwordsize=true)by(vm_compute;reflexivity).
 rewrite E0,EM,!andb_false_r,S8. cbn [orb].
 fold(encoder_high_index c). fold(encoder_offset(encoder_high_index c)).
 cbn [Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
 rewrite zle_true by(pose proof(Ptrofs.unsigned_range(encoder_offset(encoder_high_index c)));lia).
 rewrite STORE;reflexivity.
Qed.

Lemma encoder_odd_raw : forall e m m2 bv bc bb v c old,
 e!Source._val=Some(bv,tshort) ->e!Source._cnt=Some(bc,tshort) ->
 e!Source._data_buf_12=None ->Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
 Mem.load Mint16signed m bv 0=Some(Vint v) ->Mem.load Mint16signed m bc 0=Some(Vint c) ->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(encoder_offset(encoder_high_index c)))=Some(Vint old) ->
 Mem.store Mint8unsigned m bb(Ptrofs.unsigned(encoder_offset(encoder_high_index c)))
  (Vint(Int.zero_ext 8(Int.or old(Int.shr(Int.and v(Int.repr 3840))(Int.repr 4)))))=Some m2 ->
 atom_eval(Csem.globalenv Source.prog)e m encode_odd=
 Some(Vint(Int.zero_ext 8(Int.or old(Int.shr(Int.and v(Int.repr 3840))(Int.repr 4)))),m2).
Proof.
 intros e m m2 bv bc bb v c old BV BC LOCAL SYMBOL LV LC OLD STORE.
 unfold encode_odd,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body atom_eval pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite BV,BC,LOCAL,SYMBOL.
 unfold tshort,tint,tuchar,tarray,tptr. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite!Ptrofs.unsigned_zero. rewrite!zle_true by(change(2<=18446744073709551616);lia). rewrite LV,LC.
 cbv beta iota zeta delta[sem_binary_operation sem_div sem_add sem_add_ptr_int ptrofs_of_int sem_and sem_or sem_shr sem_binarith classify_binarith
 binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
 assert(E0:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(EM:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 assert(S4:Int.ltu(Int.repr 4)Int.iwordsize=true)by(vm_compute;reflexivity).
 rewrite E0,EM,!andb_false_r,S4. cbn [orb].
 fold(encoder_high_index c). fold(encoder_offset(encoder_high_index c)).
 cbn [Cexec.do_deref_loc Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv Mem.storev size_chunk].
 rewrite!zle_true by(pose proof(Ptrofs.unsigned_range(encoder_offset(encoder_high_index c)));lia).
 rewrite OLD. cbn [Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
 rewrite zle_true by(pose proof(Ptrofs.unsigned_range(encoder_offset(encoder_high_index c)));lia).
 rewrite STORE;reflexivity.
Qed.
Lemma encoder_high_fact : forall e m m2 bb cnt,
 0<=cnt<6434 ->short_cell e m Source._val(table_at cnt) ->short_cell e m Source._cnt cnt ->
 e!Source._data_buf_12=None ->Genv.find_symbol(Csem.globalenv Source.prog)Source._data_buf_12=Some bb ->
 Mem.load Mint8unsigned m bb(high_address cnt)=Some(Vint(Int.repr(buffer_view cnt(high_address cnt)))) ->
 Mem.store Mint8unsigned m bb(high_address cnt)(Vint(Int.repr(high_written cnt)))=Some m2 ->
 atom_eval(Csem.globalenv Source.prog)e m(if encoder_even_choice(Int.repr cnt)then encode_even else encode_odd)=
 Some(Vint(Int.repr(high_written cnt)),m2).
Proof.
 intros e m m2 bb cnt C[bv[BV[LV RV]]][bc[BC[LC RC]]]LOCAL SYMBOL OLD STORE.
 destruct(literal_encoder_machine cnt C)as[LOW[HIGH[COND[VAL WRITE]]]].
 unfold encoder_high_machine in WRITE. destruct(encoder_even_choice(Int.repr cnt))eqn:CHOICE.
 - rewrite<-WRITE. eapply encoder_even_raw;eauto. rewrite HIGH,WRITE;exact STORE.
 - rewrite<-WRITE. eapply encoder_odd_raw;eauto.
   + rewrite HIGH;exact OLD.
   + rewrite HIGH,WRITE;exact STORE.
Qed.
Lemma encoder_prev_fact : forall e m prev,
 short_cell e m Source._val_prev prev ->
 pure_rval(Csem.globalenv Source.prog)e m encode_prev=Some(Vint(Int.repr prev)).
Proof.
 intros e m prev[b[B[L R]]]. unfold encode_prev,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite B. unfold tshort,tvoid. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(2<=18446744073709551616);lia). rewrite L;reflexivity.
Qed.
Lemma encoder_tab_fact : forall e m bt tab,
 e!Source._tab=Some(bt,tptr tshort) ->Mem.load Mptr m bt 0=Some tab ->
 pure_rval(Csem.globalenv Source.prog)e m encode_tab=Some tab.
Proof.
 intros e m bt tab B L. unfold encode_tab,encoder_parts.
 cbv beta iota zeta delta[Source.f_table_encode_12 fn_body pure_rval pure_lval typeof].
 repeat rewrite dec_eq_true. rewrite B. unfold tshort,tvoid,tptr. repeat rewrite dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(8<=18446744073709551616);lia). rewrite L;reflexivity.
Qed.
