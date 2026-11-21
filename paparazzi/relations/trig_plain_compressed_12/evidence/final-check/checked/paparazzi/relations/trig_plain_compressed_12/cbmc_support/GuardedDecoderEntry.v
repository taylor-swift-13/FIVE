From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
Require PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix MachineData PlainEntry LowDecoder LowEntry Total.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import GuardedCover GuardedDecoder.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Theorem decoder_entry_guarded : forall (ge:Csem.genv)Q kont m bb a,
 0<=Int.signed a<6434 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 (forall final,Mem.unchanged_on(old_blocks m)m final ->
  guarded_covers ge Q(Returnstate(Vint(machine_lookup a))(call_cont kont)final)) ->
 guarded_covers ge Q(Callstate(Internal decoder)[Vint a]kont m).
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
 eapply internal_guarded with(e:=decoder_env bv bk)(m1:=m2)(m2:=m3).
 - change(list_norepet[PprzTrigLow.Source._val;PprzTrigLow.Source._k]). apply list_norepet_cons.
   + cbn;intros[EQ|[]];vm_compute in EQ;discriminate.
   + apply list_norepet_cons;[cbn;tauto|constructor].
 - change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigLow.Source._val,tshort);(PprzTrigLow.Source._k,tshort)]=(decoder_env bv bk,m2)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 2 with|(mm,vv)=>
    match Mem.alloc mm 0 2 with|(mmm,kk)=>(decoder_env vv kk,mmm)end end=(decoder_env bv bk,m2)).
   rewrite AV,AK;reflexivity.
 - apply bind_short with(local:=bv);auto.
 - eapply decoder_body_guarded with(bv:=bv)(bk:=bk)(bb:=bb)(a:=a);eauto.
   intros middle KSTORE.
   assert(PV':Mem.range_perm middle bv 0 2 Cur Freeable)by(intros ofs R;eapply Mem.perm_store_1;[exact KSTORE|apply PV;exact R]).
   assert(PK':Mem.range_perm middle bk 0 2 Cur Freeable)by(intros ofs R;eapply Mem.perm_store_1;[exact KSTORE|apply PK;exact R]).
   destruct(decoder_free ge m middle bv bk NE FV FK PV' PK')as[final[FREE FRAME]].
   exists final;split;[exact FREE|]. change(guarded_covers ge Q(Returnstate(Vint(machine_lookup a))(call_cont kont)final)).
   apply END. eapply Mem.unchanged_on_trans;[exact PRE|].
   eapply Mem.unchanged_on_trans;[|exact FRAME].
   eapply Mem.store_unchanged_on;[exact KSTORE|intros;exact FK].
Qed.
Print Assumptions decoder_entry_guarded.
