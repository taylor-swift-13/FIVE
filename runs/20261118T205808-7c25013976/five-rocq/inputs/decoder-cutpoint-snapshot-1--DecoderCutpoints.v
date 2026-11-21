From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Cexec Csem Cstrategy.
Require PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix MachineData PlainBody PlainEntry LowDecoder LowEntry Total PureEval BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import SourceObservations DecoderGuards Cutpoint.
Import ListNotations.
Local Open Scope Z_scope.
Lemma set_high_covers : forall ge Q f kont e m bk x,
 (x=0\/x=1\/x=2\/x=3) ->e!PprzTrigLow.Source._k=Some(bk,tshort) ->
 Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(Int.repr(x*4096)))=Some middle ->
 covers ge Q(State f Sskip kont e middle)) ->
 covers ge Q(State f(set_high x)kont e m).
Proof.
 intros ge Q f kont e m bk x BX EK VA END.
 destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.repr(x*4096)))VA)as[middle STORE].
 apply do_covers. eapply flat_prefix_covers with(v:=Vint(Int.repr(x*4096)))(mf:=middle).
 - reflexivity.
 - reflexivity.
 - apply short_assign_value with(b:=bk);auto;try reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
 - apply do_value_covers;apply END;exact STORE.
Qed.
Lemma decoder_select_covers : forall ge Q f kont e m bv bk a,
 e!PprzTrigLow.Source._val=Some(bv,tshort) ->e!PprzTrigLow.Source._k=Some(bk,tshort) ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(machine_high_bits a))=Some middle ->
 covers ge Q(State f Sskip kont e middle)) ->
 covers ge Q(State f decoder_select kont e m).
Proof.
 intros ge Q f kont e m bv bk a EV EK LOAD VA END;rewrite decoder_select_shape.
 eapply if_pure_covers with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 2145)))(choice:=Int.cmp Clt a(Int.repr 2145)).
 - reflexivity.
 - eapply threshold_value;eauto.
 - destruct(Int.cmp Clt a(Int.repr 2145));reflexivity.
 - destruct(Int.cmp Clt a(Int.repr 2145))eqn:C2;simpl.
   + eapply if_pure_covers with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 1035)))(choice:=Int.cmp Clt a(Int.repr 1035)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * destruct(Int.cmp Clt a(Int.repr 1035));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 1035))eqn:C1;simpl;
       eapply set_high_covers;eauto;intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C1;exact STORE.
   + eapply if_pure_covers with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 3474)))(choice:=Int.cmp Clt a(Int.repr 3474)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * destruct(Int.cmp Clt a(Int.repr 3474));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 3474))eqn:C3;simpl;
       eapply set_high_covers;eauto;intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C3;exact STORE.
Qed.
Definition DecoderReadPC(ge:Csem.genv)(kont:cont)(bb:block)(a:int)(s:Csem.state):Prop :=
 exists e mc bv bk hi lo,
 s=ExprState LowDecoder.decoder LowDecoder.decoder_expr(Kreturn kont)e mc /\
 e!PprzTrigLow.Source._val=Some(bv,tshort) /\e!PprzTrigLow.Source._k=Some(bk,tshort) /\e!PprzTrigLow.Source._data_buf_12=None /\
 Mem.load Mint16signed mc bv 0=Some(Vint a) /\Mem.load Mint16signed mc bk 0=Some(Vint(machine_high_bits a)) /\
 Mem.load Mint8unsigned mc bb(Ptrofs.unsigned(low_offset a))=Some(Vint lo) /\
 Mem.load Mint8unsigned mc bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi) /\
 source_observation ge e mc decoder_expr(Vint(raw_decoder(machine_high_bits a)a hi lo)) /\
 source_observation ge e mc DecoderGuards.decoder_shift_expr(Vint(Int.shl hi(machine_shift a))) /\
 0<=Int.signed hi<=255 /\0<=Int.signed(machine_shift a)<32 /\
 TypedGuards.signed32(Int.signed hi*2^Int.signed(machine_shift a)) /\
 0<=Ptrofs.unsigned(high_offset a)<9651 /\0<=Ptrofs.unsigned(low_offset a)<9651.
Theorem decoder_entry_guard_cut : forall(ge:Csem.genv)kont m bb a,
 0<=Int.signed a<6434 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 covers ge(DecoderReadPC ge kont bb a)(Callstate(Internal LowDecoder.decoder)[Vint a]kont m).
Proof.
 intros ge kont m bb a B SYM BYTES.
 assert(BVALID:Mem.valid_block m bb).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;
   [eapply Mem.load_valid_access;apply(BYTES 0);lia|constructor]. }
 destruct(Mem.alloc m 0 2)as[m1 bv]eqn:AV.
 destruct(Mem.alloc m1 0 2)as[m2 bk]eqn:AK.
 assert(FV:~Mem.valid_block m bv)by(eapply Mem.fresh_block_alloc;eauto).
 assert(FK1:~Mem.valid_block m1 bk)by(eapply Mem.fresh_block_alloc;eauto).
 assert(FK:~Mem.valid_block m bk).
 { intro V;apply FK1;eapply Mem.valid_block_alloc;eauto. }
 assert(NE:bv<>bk).
 { intro E;subst bk;apply FK1;eapply Mem.valid_new_block;eauto. }
 assert(NBV:bb<>bv)by congruence.
 assert(NBK:bb<>bk)by congruence.
 assert(ENVV:(decoder_env bv bk)!PprzTrigLow.Source._val=Some(bv,tshort)).
 { unfold decoder_env;rewrite PTree.gso by(vm_compute;discriminate);apply PTree.gss. }
 assert(ENVK:(decoder_env bv bk)!PprzTrigLow.Source._k=Some(bk,tshort))by(unfold decoder_env;apply PTree.gss).
 assert(ENVB:(decoder_env bv bk)!PprzTrigLow.Source._data_buf_12=None)by(vm_compute;reflexivity).
 assert(VAV:Mem.valid_access m2 Mint16signed bv 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AK|].
   eapply Mem.valid_access_alloc_same;[exact AV|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(VAW:Mem.valid_access m2 Mint16signed bv 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a) VAW)as[m3 STORE].
 assert(PRE:Mem.unchanged_on(old_blocks m)m m3).
 { eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact AV|].
   eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact AK|].
   eapply Mem.store_unchanged_on;[exact STORE|intros;exact FV]. }
 assert(LV:Mem.load Mint16signed m3 bv 0=Some(Vint a)).
 { rewrite(Mem.load_store_same _ _ _ _ _ _ STORE);cbn[Val.load_result];rewrite short_index by exact B;reflexivity. }
 assert(VAK:Mem.valid_access m3 Mint16signed bk 0 Writable).
 { eapply Mem.store_valid_access_1;[exact STORE|]. eapply Mem.valid_access_freeable_any.
   eapply Mem.valid_access_alloc_same;[exact AK|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(PV:Mem.range_perm m3 bv 0 2 Cur Freeable).
 { intros ofs R;eapply Mem.perm_store_1;[exact STORE|]. eapply Mem.perm_alloc_1;[exact AK|].
   eapply Mem.perm_alloc_2;[exact AV|exact R]. }
 assert(PK:Mem.range_perm m3 bk 0 2 Cur Freeable).
 { intros ofs R;eapply Mem.perm_store_1;[exact STORE|]. eapply Mem.perm_alloc_2;[exact AK|exact R]. }
 destruct(high_offset_value a B)as[HIGH HBOUND].
 assert(LOW:Ptrofs.unsigned(low_offset a)=Int.signed a)by(apply low_offset_value;exact B).
 assert(LOADLO:Mem.load Mint8unsigned m3 bb(Ptrofs.unsigned(low_offset a))=
 Some(Vint(Int.repr(nth(Z.to_nat(Int.signed a))expected_bytes 0)))).
 { rewrite LOW,(Mem.load_unchanged_on_1 _ _ _ _ _ _ PRE BVALID ltac:(intros;exact BVALID));apply BYTES;lia. }
 assert(LOADHI:Mem.load Mint8unsigned m3 bb(Ptrofs.unsigned(high_offset a))=
 Some(Vint(Int.repr(nth(Z.to_nat(machine_high_address a))expected_bytes 0)))).
 { rewrite HIGH,(Mem.load_unchanged_on_1 _ _ _ _ _ _ PRE BVALID ltac:(intros;exact BVALID));apply BYTES;lia. }
 eapply internal_covers with(e:=decoder_env bv bk)(m1:=m2)(m2:=m3).
 - change(list_norepet[PprzTrigLow.Source._val;PprzTrigLow.Source._k]). apply list_norepet_cons.
   + cbn;intros[EQ|[]];vm_compute in EQ;discriminate.
   + apply list_norepet_cons;[cbn;tauto|constructor].
 - change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigLow.Source._val,tshort);(PprzTrigLow.Source._k,tshort)]=(decoder_env bv bk,m2)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 2 with|(mm,vv)=>
    match Mem.alloc mm 0 2 with|(mmm,kk)=>(decoder_env vv kk,mmm)end end=(decoder_env bv bk,m2)).
   rewrite AV,AK;reflexivity.
 - apply bind_short with(local:=bv);auto.
 - change(covers ge(DecoderReadPC ge kont bb a)(State decoder(Ssequence decoder_select(Sreturn(Some decoder_expr)))kont(decoder_env bv bk)m3)).
   apply sequence_covers;eapply decoder_select_covers;try eassumption.
   intros middle KSTORE;apply skip_sequence_covers;apply return_start_covers;apply covers_here.
   assert(LV':Mem.load Mint16signed middle bv 0=Some(Vint a)).
   { erewrite Mem.load_store_other;[exact LV|exact KSTORE|left;exact NE]. }
   assert(LK:Mem.load Mint16signed middle bk 0=Some(Vint(machine_high_bits a))).
   { rewrite(Mem.load_store_same _ _ _ _ _ _ KSTORE);cbn[Val.load_result];rewrite high_bits_short;reflexivity. }
   assert(LL:Mem.load Mint8unsigned middle bb(Ptrofs.unsigned(low_offset a))=Some(Vint(Int.repr(nth(Z.to_nat(Int.signed a))expected_bytes 0)))).
   { erewrite Mem.load_store_other;[exact LOADLO|exact KSTORE|left;exact NBK]. }
   assert(LH:Mem.load Mint8unsigned middle bb(Ptrofs.unsigned(high_offset a))=Some(Vint(Int.repr(nth(Z.to_nat(machine_high_address a))expected_bytes 0)))).
   { erewrite Mem.load_store_other;[exact LOADHI|exact KSTORE|left;exact NBK]. }
   exists(decoder_env bv bk),middle,bv,bk,(Int.repr(nth(Z.to_nat(machine_high_address a))expected_bytes 0)),(Int.repr(nth(Z.to_nat(Int.signed a))expected_bytes 0)).
   split;[reflexivity|]. split;[exact ENVV|]. split;[exact ENVK|]. split;[exact ENVB|]. split;[exact LV'|]. split;[exact LK|]. split;[exact LL|]. split;[exact LH|].
   split;[split;[reflexivity|eapply decoder_expression_reads;eauto]|].
   split;[eapply source_shift_operation_observation;eauto|].
   pose proof(decoder_source_pc_guards ge(decoder_env bv bk)middle bv bb a _ B ENVV ENVB SYM LV' LH)as G.
   repeat match goal with H:_/\_|-_=>destruct H end.
   repeat first[assumption|split].
Qed.
Print Assumptions decoder_entry_guard_cut.
