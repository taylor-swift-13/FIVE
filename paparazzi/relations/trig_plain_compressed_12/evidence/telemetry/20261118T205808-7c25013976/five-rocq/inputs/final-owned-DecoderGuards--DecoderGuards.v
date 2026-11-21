From Stdlib Require Import List ZArith Bool Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec.
Require PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import LowDecoder LowEntry MachineData BranchPure PureEval TrigData PackedPrefix.
From PprzTrigCBMC Require Import TypedGuards SourceObservations.
Import ListNotations.
Local Open Scope Z_scope.
Definition decoder_shift_expr:=match decoder_expr with Ebinop Oor(Ebinop Oor _(Ebinop Oand s _ _)_)_ _=>s|_=>Eval Vundef tint end.
Definition decoder_high_read:=match decoder_shift_expr with Ebinop Oshl h _ _=>h|_=>Eval Vundef tint end.
Definition decoder_shift_choice:=match decoder_shift_expr with Ebinop Oshl _ c _=>c|_=>Eval Vundef tint end.
Definition decoder_high_index:=match decoder_high_read with Evalof(Ederef(Ebinop Oadd _ i _)_)_=>i|_=>Eval Vundef tint end.
Definition decoder_low_read:=match decoder_expr with Ebinop Oor _ l _=>l|_=>Eval Vundef tint end.
Definition decoder_buffer:=Evalof(Evar PprzTrigLow.Source._data_buf_12(tarray tuchar 9651))(tarray tuchar 9651).
Lemma decoder_source_guard_shapes :
 decoder_shift_expr=Ebinop Oshl decoder_high_read decoder_shift_choice tint /\
 decoder_shift_choice=Econdition(Ebinop Omod LowDecoder.read_val(Eval(Vint(Int.repr 2))tint)tint)
 (Eval(Vint(Int.repr 4))tint)(Eval(Vint(Int.repr 8))tint)tint /\
 decoder_high_index=Ebinop Oadd(Eval(Vint(Int.repr 6434))tint)
 (Ebinop Oshr LowDecoder.read_val(Eval(Vint(Int.repr 1))tint)tint)tint /\
 decoder_high_read=Evalof(Ederef(Ebinop Oadd decoder_buffer decoder_high_index(tptr tuchar))tuchar)tuchar /\
 decoder_low_read=Evalof(Ederef(Ebinop Oadd decoder_buffer LowDecoder.read_val(tptr tuchar))tuchar)tuchar.
Proof. repeat split;reflexivity. Qed.
Definition shr_one_bound_check(n:nat):bool :=
 let a:=Int.repr(Z.of_nat n)in (0<=?Int.signed(Int.shr a(Int.repr 1)))&&
 (Int.signed(Int.shr a(Int.repr 1))<=?3216).
Lemma original_index_shift_certificate : forallb shr_one_bound_check(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma original_index_shift_bound : forall a,0<=Int.signed a<6434 ->0<=Int.signed(Int.shr a(Int.repr 1))<=3216.
Proof.
 intros a A;pose proof original_index_shift_certificate as H.
 apply forallb_forall with(x:=Z.to_nat(Int.signed a))in H.
 - unfold shr_one_bound_check in H;rewrite Z2Nat.id,Int.repr_signed in H by lia.
   apply andb_true_iff in H as[L U];apply Z.leb_le in L;apply Z.leb_le in U;lia.
 - apply in_seq;split;[lia|]. change(Z.to_nat(Int.signed a)<Z.to_nat 6434)%nat.
   apply(proj1(Z2Nat.inj_lt (Int.signed a) 6434 ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma original_shift_choice_bound : forall a,Int.signed(machine_shift a)=4 \/Int.signed(machine_shift a)=8.
Proof. intro a;unfold machine_shift;destruct(Int.eq(Int.mods a(Int.repr 2))Int.zero);vm_compute;auto. Qed.
Lemma source_val_observation : forall(ge:Csem.genv)e m bv a,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->Mem.load Mint16signed m bv 0=Some(Vint a)->
 source_observation ge e m LowDecoder.read_val(Vint a).
Proof. intros;split;[reflexivity|]. exact(LowDecoder.short_read ge e m _ bv a H H0). Qed.
Lemma source_high_index_observation : forall(ge:Csem.genv)e m bv a,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->Mem.load Mint16signed m bv 0=Some(Vint a)->
 source_observation ge e m decoder_high_index(Vint(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1)))).
Proof.
 intros ge e m bv a E L;pose proof(proj2(source_val_observation ge e m bv a E L))as READ.
 split;[reflexivity|].
 change(branch_rval ge e m(Ebinop Oadd(Eval(Vint(Int.repr 6434))tint)
 (Ebinop Oshr LowDecoder.read_val(Eval(Vint(Int.repr 1))tint)tint)tint)=Some(Vint(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1))))).
 cbn[branch_rval].
 rewrite READ;reflexivity.
Qed.
Theorem source_ternary_observation : forall(ge:Csem.genv)e m bv a,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->Mem.load Mint16signed m bv 0=Some(Vint a)->
 source_observation ge e m decoder_shift_choice(Vint(machine_shift a)) /\
 (Int.signed(machine_shift a)=4 \/Int.signed(machine_shift a)=8).
Proof.
 intros ge e m bv a E L;pose proof(proj2(source_val_observation ge e m bv a E L))as READ.
 split;[split;[reflexivity|]|apply original_shift_choice_bound].
 change(branch_rval ge e m(Econdition(Ebinop Omod LowDecoder.read_val(Eval(Vint(Int.repr 2))tint)tint)
 (Eval(Vint(Int.repr 4))tint)(Eval(Vint(Int.repr 8))tint)tint)=Some(Vint(machine_shift a))).
 cbn[branch_rval];rewrite READ;unfold machine_shift;cbn[typeof LowDecoder.read_val].
 cbv beta iota zeta delta[sem_binary_operation sem_mod sem_binarith classify_binarith binarith_type typeconv sem_cast classify_cast cast_int_int tshort tint Archi.ptr64 bool_val classify_bool].
 assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 rewrite ?E20,?E2M,?andb_false_r;cbn[orb remove_attributes change_attributes branch_rval typeof];destruct(Int.eq(Int.mods a(Int.repr 2))Int.zero);reflexivity.
Qed.
Lemma source_buffer_observation : forall(ge:Csem.genv)e m bb,
 e!PprzTrigLow.Source._data_buf_12=None ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->
 source_observation ge e m decoder_buffer(Vptr bb Ptrofs.zero).
Proof.
 intros ge e m bb E S;split;[reflexivity|].
 cbn[decoder_buffer branch_rval branch_lval typeof];rewrite dec_eq_true,E,S;reflexivity.
Qed.
Lemma source_high_read_observation : forall(ge:Csem.genv)e m bv bb a hi,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi)->
 source_observation ge e m decoder_high_read(Vint hi).
Proof.
 intros ge e m bv bb a hi E EB S L H.
 split;[reflexivity|].
 cbv beta iota zeta delta[decoder_high_read decoder_shift_expr decoder_expr decoder PprzTrigLow.Source.f_pprz_trig_int_12 fn_body branch_rval branch_lval typeof].
 repeat rewrite dec_eq_true;rewrite E,EB,S.
 unfold tshort,tuchar,tarray,tptr,tint;repeat rewrite dec_eq_true.
 cbn[Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite Ptrofs.unsigned_zero,L,zle_true by(change(2<=18446744073709551616);lia).
 cbv beta iota zeta delta[sem_binary_operation sem_add sem_add_ptr_int ptrofs_of_int sem_shr sem_binarith classify_binarith binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof sem_shift classify_shift remove_attributes change_attributes Archi.ptr64].
 assert(SH1:Int.ltu(Int.repr 1)(Int.repr 32)=true)by(vm_compute;reflexivity).
 change Int.iwordsize with(Int.repr 32);rewrite SH1;fold(high_offset a).
 cbn[Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite H,zle_true;[reflexivity|pose proof(Ptrofs.unsigned_range(high_offset a));lia].
Qed.
Lemma source_low_read_observation : forall(ge:Csem.genv)e m bv bb a lo,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(low_offset a))=Some(Vint lo)->
 source_observation ge e m decoder_low_read(Vint lo).
Proof.
 intros ge e m bv bb a lo E EB S L H.
 split;[reflexivity|].
 cbv beta iota zeta delta[decoder_low_read decoder_expr decoder PprzTrigLow.Source.f_pprz_trig_int_12 fn_body branch_rval branch_lval typeof].
 repeat rewrite dec_eq_true;rewrite E,EB,S.
 unfold tshort,tuchar,tarray,tptr,tint;repeat rewrite dec_eq_true.
 cbn[Cexec.do_deref_loc type_is_volatile access_mode Mem.loadv attr_of_type attr_volatile noattr size_chunk].
 rewrite Ptrofs.unsigned_zero,L,zle_true by(change(2<=18446744073709551616);lia).
 cbv beta iota zeta delta[sem_binary_operation sem_add sem_add_ptr_int ptrofs_of_int sem_binarith classify_binarith binarith_type classify_add typeconv sem_cast classify_cast cast_int_int sizeof remove_attributes change_attributes Archi.ptr64].
 fold(low_offset a).
 cbn[Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite H,zle_true;[reflexivity|pose proof(Ptrofs.unsigned_range(low_offset a));lia].
Qed.
Theorem decoder_source_pc_guards : forall(ge:Csem.genv)e m bv bb a hi,
 0<=Int.signed a<6434 ->e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi)->
 source_observation ge e m decoder_high_index(Vint(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1)))) /\
 source_observation ge e m decoder_high_read(Vint hi) /\source_observation ge e m decoder_shift_choice(Vint(machine_shift a)) /\
 signed32(6434+Int.signed(Int.shr a(Int.repr 1))) /\0<=6434+Int.signed(Int.shr a(Int.repr 1))<9651 /\
 0<=Ptrofs.unsigned(high_offset a)<9651 /\0<=Ptrofs.unsigned(low_offset a)<9651 /\
 0<=Int.signed hi<=255 /\0<=Int.signed(machine_shift a)<32 /\
 signed32(Int.signed hi*2^Int.signed(machine_shift a)).
Proof.
 intros ge e m bv bb a hi A E EB S L H.
 pose proof(source_high_index_observation ge e m bv a E L)as IX.
 pose proof(source_high_read_observation ge e m bv bb a hi E EB S L H)as HR.
 destruct(source_ternary_observation ge e m bv a E L)as[TC TB].
 pose proof(load_unsigned8_range m bb(Ptrofs.unsigned(high_offset a))hi H)as HB.
 pose proof(original_index_shift_bound a A)as SHR.
 destruct(high_offset_value a A)as[HOFF HBOUND]. pose proof(low_offset_value a A)as LOFF.
 pose proof(uchar_decoder_shift_guards(Int.signed hi)(Int.signed(machine_shift a))HB TB)as G.
 destruct G as[NH[SC SHL]].
 repeat first[assumption|split];unfold signed32;lia.
Qed.
Print Assumptions source_ternary_observation.
Print Assumptions decoder_source_pc_guards.

Lemma source_observation_binop : forall(ge:Csem.genv)e m op l r ty vl vr result,
 PlainCore.nv ty=true ->source_observation ge e m l vl ->source_observation ge e m r vr ->
 sem_binary_operation ge op vl(typeof l)vr(typeof r)m=Some result ->
 source_observation ge e m(Ebinop op l r ty)result.
Proof.
 intros ge e m op l r ty vl vr result NV[SL VL][SR VR]OP;split.
 - cbn[branch_simple];rewrite NV,SL,SR;reflexivity.
 - cbn[branch_rval];rewrite VL,VR;exact OP.
Qed.
Theorem source_shift_operation_observation : forall(ge:Csem.genv)e m bv bb a hi,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi)->
 source_observation ge e m decoder_shift_expr(Vint(Int.shl hi(machine_shift a))).
Proof.
 intros ge e m bv bb a hi E EB S L H.
 rewrite(proj1 decoder_source_guard_shapes).
 eapply source_observation_binop;[reflexivity|exact(source_high_read_observation ge e m bv bb a hi E EB S L H)|
 exact(proj1(source_ternary_observation ge e m bv a E L))|].
 change(sem_binary_operation ge Oshl(Vint hi)tuchar(Vint(machine_shift a))tint m=Some(Vint(Int.shl hi(machine_shift a)))).
 unfold machine_shift;destruct(Int.eq(Int.mods a(Int.repr 2))Int.zero);reflexivity.
Qed.
Print Assumptions source_shift_operation_observation.
