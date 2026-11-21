From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigLow Require Import Source.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix MachineData PlainEntry LowDecoder Total.
From PprzTrigInitSupport Require Import Control.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Definition buffer_loads(m:mem)(bb:block):Prop := forall i,0<=i<9651 ->
 Mem.load Mint8unsigned m bb i=Some(Vint(Int.repr(nth(Z.to_nat i)expected_bytes 0))).
Definition decoder_env(bv bk:block):env := PTree.set _k(bk,tshort)(PTree.set _val(bv,tshort)empty_env).
Lemma decoder_env_blocks : forall ge bv bk,blocks_of_env ge(decoder_env bv bk)=[(bk,0,2);(bv,0,2)].
Proof. intros;vm_compute;reflexivity. Qed.
Lemma short_index_casts : forallb(fun n=>Int.eq(Int.sign_ext 16(Int.repr(Z.of_nat n)))(Int.repr(Z.of_nat n)))(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma short_index : forall a,0<=Int.signed a<6434 ->Int.sign_ext 16 a=a.
Proof.
 intros a B. pose proof short_index_casts as ALL.
 apply forallb_forall with(x:=Z.to_nat(Int.signed a))in ALL.
 - rewrite Z2Nat.id,Int.repr_signed in ALL by lia;apply Int.same_if_eq;exact ALL.
 - apply in_seq;split;[lia|]. change(Z.to_nat(Int.signed a)<Z.to_nat 6434)%nat.
   apply(proj1(Z2Nat.inj_lt (Int.signed a) 6434 ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma low_offset_value : forall a,0<=Int.signed a<6434 ->Ptrofs.unsigned(low_offset a)=Int.signed a.
Proof.
 intros a B;unfold low_offset;rewrite Ptrofs.add_zero_l,Ptrofs.mul_commut.
 change(Ptrofs.unsigned(Ptrofs.mul(Ptrofs.of_ints a)Ptrofs.one)=Int.signed a).
 rewrite Ptrofs.mul_one. unfold Ptrofs.of_ints;rewrite Ptrofs.unsigned_repr;auto.
 change(0<=Int.signed a<=18446744073709551615);lia.
Qed.
Lemma high_offset_value : forall a,0<=Int.signed a<6434 ->
 Ptrofs.unsigned(high_offset a)=machine_high_address a /\0<=machine_high_address a<9651.
Proof.
 intros a B. destruct(machine_lookup_signed a B)as[_ ADDR].
 pose proof(high_address_bounds(Int.signed a)B)as[BD _].
 split;[|rewrite ADDR;lia].
 unfold high_offset;rewrite Ptrofs.add_zero_l,Ptrofs.mul_commut.
 change(Ptrofs.unsigned(Ptrofs.mul(Ptrofs.of_ints(Int.add(Int.repr 6434)(Int.shr a(Int.repr 1))))Ptrofs.one)=machine_high_address a).
 rewrite Ptrofs.mul_one. unfold Ptrofs.of_ints;rewrite Ptrofs.unsigned_repr;auto.
 change(0<=machine_high_address a<=18446744073709551615);rewrite ADDR;lia.
Qed.
Lemma bind_short : forall ge e local m a m',
 e!_val=Some(local,tshort) ->Mem.store Mint16signed m local 0(Vint a)=Some m' ->
 Cexec.sem_bind_parameters ge Control.quiet e m[(_val,tshort)][Vint a]=Some m'.
Proof.
 intros ge e local m a m' ENV STORE;apply sem_bind_parameters_complete.
 eapply bind_parameters_cons with(v1':=Vint a)(b:=local)(m1:=m');auto;[|constructor].
 eapply assign_loc_value with(chunk:=Mint16signed);try reflexivity.
 cbn[Mem.storev size_chunk];rewrite Ptrofs.unsigned_zero.
 destruct(zle(0+2)Ptrofs.modulus);[exact STORE|].
 assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
Qed.
Lemma decoder_free : forall ge initial middle bv bk,
 bv<>bk ->~Mem.valid_block initial bv ->~Mem.valid_block initial bk ->
 Mem.range_perm middle bv 0 2 Cur Freeable ->Mem.range_perm middle bk 0 2 Cur Freeable ->
 exists final,Mem.free_list middle(blocks_of_env ge(decoder_env bv bk))=Some final /\
 Mem.unchanged_on(old_blocks initial)middle final.
Proof.
 intros ge initial middle bv bk NE FV FK PV PK.
 destruct(Mem.range_perm_free _ _ _ _ PK)as[afterk FREEK].
 assert(PV':Mem.range_perm afterk bv 0 2 Cur Freeable).
 { intros ofs B;eapply Mem.perm_free_1;[exact FREEK|auto|apply PV;exact B]. }
 destruct(Mem.range_perm_free _ _ _ _ PV')as[final FREEV].
 exists final;split.
 - rewrite decoder_env_blocks;cbn[Mem.free_list];rewrite FREEK,FREEV;reflexivity.
 - eapply Mem.unchanged_on_trans.
   + eapply Mem.free_unchanged_on;[exact FREEK|intros;exact FK].
   + eapply Mem.free_unchanged_on;[exact FREEV|intros;exact FV].
Qed.

Theorem decoder_entry_total : forall (ge:Csem.genv)Q kont m bb a,
 0<=Int.signed a<6434 ->Genv.find_symbol ge _data_buf_12=Some bb ->buffer_loads m bb ->
 (forall final,Mem.unchanged_on(old_blocks m)m final ->
  total ge Q(Returnstate(Vint(machine_lookup a))(call_cont kont)final)) ->
 total ge Q(Callstate(Internal decoder)[Vint a]kont m).
Proof.
 intros ge Q kont m bb a B SYM BYTES END.
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
 assert(ENVV:(decoder_env bv bk)!_val=Some(bv,tshort)).
 { unfold decoder_env;rewrite PTree.gso by(vm_compute;discriminate);apply PTree.gss. }
 assert(ENVK:(decoder_env bv bk)!_k=Some(bk,tshort))by(unfold decoder_env;apply PTree.gss).
 assert(ENVB:(decoder_env bv bk)!_data_buf_12=None)by(vm_compute;reflexivity).
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
 eapply internal_function_total with(e:=decoder_env bv bk)(m1:=m2)(m2:=m3).
 - change(list_norepet[_val;_k]). apply list_norepet_cons.
   + cbn;intros[EQ|[]];vm_compute in EQ;discriminate.
   + apply list_norepet_cons;[cbn;tauto|constructor].
 - change(Cexec.do_alloc_variables ge empty_env m[(_val,tshort);(_k,tshort)]=(decoder_env bv bk,m2)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 2 with|(mm,vv)=>
    match Mem.alloc mm 0 2 with|(mmm,kk)=>(decoder_env vv kk,mmm)end end=(decoder_env bv bk,m2)).
   rewrite AV,AK;reflexivity.
 - apply bind_short with(local:=bv);auto.
 - eapply decoder_body_total with(bv:=bv)(bk:=bk)(bb:=bb)(a:=a);eauto.
   intros middle KSTORE.
   assert(PV':Mem.range_perm middle bv 0 2 Cur Freeable)by(intros ofs R;eapply Mem.perm_store_1;[exact KSTORE|apply PV;exact R]).
   assert(PK':Mem.range_perm middle bk 0 2 Cur Freeable)by(intros ofs R;eapply Mem.perm_store_1;[exact KSTORE|apply PK;exact R]).
   destruct(decoder_free ge m middle bv bk NE FV FK PV' PK')as[final[FREE FRAME]].
   exists final;split;[exact FREE|]. change(total ge Q(Returnstate(Vint(machine_lookup a))(call_cont kont)final)).
   apply END. eapply Mem.unchanged_on_trans;[exact PRE|].
   eapply Mem.unchanged_on_trans;[|exact FRAME].
   eapply Mem.store_unchanged_on;[exact KSTORE|intros;exact FK].
Qed.
Print Assumptions decoder_entry_total.
