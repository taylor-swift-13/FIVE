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
   apply(proj1(Z2Nat.inj_lt _ _ ltac:(lia)ltac:(lia)));lia.
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
 split;[reflexivity|]. change(match branch_rval ge e m LowDecoder.read_val with Some v=>
 match sem_binary_operation ge Oshr v tshort(Vint(Int.repr 1))tint m with Some w=>
 sem_binary_operation ge Oadd(Vint(Int.repr 6434))tint w tint m|_=>None end|_=>None end=
 Some(Vint(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1))))).
 rewrite READ;reflexivity.
Qed.
Theorem source_ternary_observation : forall(ge:Csem.genv)e m bv a,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->Mem.load Mint16signed m bv 0=Some(Vint a)->
 source_observation ge e m decoder_shift_choice(Vint(machine_shift a)) /\
 (Int.signed(machine_shift a)=4 \/Int.signed(machine_shift a)=8).
Proof.
 intros ge e m bv a E L;pose proof(proj2(source_val_observation ge e m bv a E L))as READ.
 split;[split;[reflexivity|]|apply original_shift_choice_bound].
 change(match branch_rval ge e m LowDecoder.read_val with Some v=>
 match sem_binary_operation ge Omod v tshort(Vint(Int.repr 2))tint m with Some w=>
 match bool_val w tint m with Some choice=>Some(Vint(if choice then Int.repr 4 else Int.repr 8))|_=>None end|_=>None end|_=>None end=Some(Vint(machine_shift a))).
 rewrite READ;unfold machine_shift.
 cbv beta iota zeta delta[sem_binary_operation sem_mod sem_binarith classify_binarith binarith_type typeconv sem_cast classify_cast cast_int_int tshort tint Archi.ptr64 bool_val classify_bool].
 assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 rewrite E20,E2M,andb_false_r;destruct(Int.eq(Int.mods a(Int.repr 2))Int.zero);reflexivity.
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
 pose proof(proj2(source_high_index_observation ge e m bv a E L))as INDEX.
 pose proof(proj2(source_buffer_observation ge e m bb EB S))as BUF.
 split;[reflexivity|]. change(match branch_rval ge e m decoder_buffer,branch_rval ge e m decoder_high_index with
 |Some v,Some w=>match sem_binary_operation ge Oadd v(tarray tuchar 9651)w tint m with
 |Some(Vptr b ofs)=>match Cexec.do_deref_loc ge branch_world tuchar m b ofs Full with
 |Some(_,_,v')=>Some v'|_=>None end|_=>None end|_,_=>None end=Some(Vint hi)).
 rewrite BUF,INDEX.
 change(match Cexec.do_deref_loc ge branch_world tuchar m bb(high_offset a)Full with
 |Some(_,_,v')=>Some v'|_=>None end=Some(Vint hi)).
 cbn[Cexec.do_deref_loc tuchar type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite H,zle_true;[reflexivity|pose proof(Ptrofs.unsigned_range(high_offset a));lia].
Qed.
Lemma source_low_read_observation : forall(ge:Csem.genv)e m bv bb a lo,
 e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(low_offset a))=Some(Vint lo)->
 source_observation ge e m decoder_low_read(Vint lo).
Proof.
 intros ge e m bv bb a lo E EB S L H.
 pose proof(proj2(source_val_observation ge e m bv a E L))as INDEX.
 pose proof(proj2(source_buffer_observation ge e m bb EB S))as BUF.
 split;[reflexivity|]. change(match branch_rval ge e m decoder_buffer,branch_rval ge e m LowDecoder.read_val with
 |Some v,Some w=>match sem_binary_operation ge Oadd v(tarray tuchar 9651)w tshort m with
 |Some(Vptr b ofs)=>match Cexec.do_deref_loc ge branch_world tuchar m b ofs Full with
 |Some(_,_,v')=>Some v'|_=>None end|_=>None end|_,_=>None end=Some(Vint lo)).
 rewrite BUF,INDEX.
 change(match Cexec.do_deref_loc ge branch_world tuchar m bb(low_offset a)Full with
 |Some(_,_,v')=>Some v'|_=>None end=Some(Vint lo)).
 cbn[Cexec.do_deref_loc tuchar type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite H,zle_true;[reflexivity|pose proof(Ptrofs.unsigned_range(low_offset a));lia].
Qed.
Theorem decoder_source_pc_guards : forall(ge:Csem.genv)e m bv bb a hi,
 0<=Int.signed a<6434 ->e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi)->
 source_observation ge e m decoder_high_index(Vint(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1)))) /\
 source_observation ge e m decoder_high_read(Vint hi) /\source_observation ge e m decoder_shift_choice(Vint(machine_shift a)) /\
 signed32(6434+Int.signed(Int.shr a(Int.repr 1))) /\
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
 repeat first[assumption|split];try(unfold signed32;lia);lia.
Qed.
Print Assumptions source_ternary_observation.
Print Assumptions decoder_source_pc_guards.
