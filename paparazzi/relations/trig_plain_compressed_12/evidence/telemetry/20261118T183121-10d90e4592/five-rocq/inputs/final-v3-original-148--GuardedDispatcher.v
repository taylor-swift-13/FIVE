From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
Require PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import PlainCore PlainBody PlainEntry LowDecoder LowEntry MachineData Total CallOne LowDispatcher.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import TypedGuards GuardedCover GuardedControl GuardedCallOne GuardedDecoderEntry.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Theorem dispatcher_entry_guarded : forall (ge:Csem.genv)Q kont m bb a funblock,
 0<=Int.signed a<6434 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_12=Some funblock ->
 Genv.find_funct ge(Vptr funblock Ptrofs.zero)=Some(Internal decoder) ->
 (forall final,Mem.unchanged_on(old_blocks m)m final ->
  guarded_covers ge Q(Returnstate(Vint(machine_lookup a))(call_cont kont)final)) ->
 guarded_covers ge Q(Callstate(Internal dispatcher)[Vint a]kont m).
Proof.
 intros ge Q kont m bb a funblock B SYM BYTES LINK FUN END.
 assert(BVALID:Mem.valid_block m bb).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;
   [eapply Mem.load_valid_access;apply(BYTES 0);lia|constructor]. }
 destruct(Mem.alloc m 0 4)as[m1 local]eqn:ALLOC.
 assert(FRESH:~Mem.valid_block m local)by(eapply Mem.fresh_block_alloc;eauto).
 assert(VAF:Mem.valid_access m1 Mint32 local 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(VAW:Mem.valid_access m1 Mint32 local 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a) VAW)as[m2 STORE].
 assert(PRE:Mem.unchanged_on(old_blocks m)m m2).
 { eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact ALLOC|].
   eapply Mem.store_unchanged_on;[exact STORE|intros;exact FRESH]. }
 assert(LOAD:Mem.load Mint32 m2 local 0=Some(Vint a))by(exact(Mem.load_store_same _ _ _ _ _ _ STORE)).
 assert(PERM:Mem.range_perm m2 local 0 4 Cur Freeable).
 { intros ofs R;eapply Mem.perm_store_1;[exact STORE|eapply Mem.perm_alloc_2;[exact ALLOC|exact R]]. }
 assert(LOCAL:Mem.valid_block m2 local).
 { eapply Mem.perm_valid_block;apply(PERM 0);lia. }
 assert(BYTES2:buffer_loads m2 bb).
 { intros i I;rewrite(Mem.load_unchanged_on_1 _ _ _ _ _ _ PRE BVALID ltac:(intros;exact BVALID));apply BYTES;exact I. }
 eapply internal_guarded with(e:=angle_env local)(m1:=m1)(m2:=m2).
 - change(list_norepet[PprzTrigLow.Source._angle]);repeat constructor;cbn;auto.
 - change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigLow.Source._angle,tint)]=(angle_env local,m1)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 4 with
    |(mm,bb)=>(angle_env bb,mm)end=(angle_env local,m1));rewrite ALLOC;reflexivity.
 - apply bind_angle;exact STORE.
 - apply return_start_guarded.
   eapply read_call_guarded with(fnid:=PprzTrigLow.Source._pprz_trig_int_12)(argid:=PprzTrigLow.Source._angle)(targetty:=tshort)(returnty:=tshort)
    (target:=decoder)(funblock:=funblock)(argblock:=local)(a:=a)(castarg:=Vint a)(neg:=false).
   + unfold angle_env;rewrite PTree.gso by(vm_compute;discriminate);apply PTree.gempty.
   + unfold angle_env;apply PTree.gss.
   + exact LINK.
   + apply angle_deref;exact LOAD.
   + exact FUN.
   + reflexivity.
   + change(Some(Vint(Int.sign_ext 16 a))=Some(Vint a));rewrite short_index by exact B;reflexivity.
   + reflexivity.
   + unfold signed32;lia.
   + apply decoder_entry_guarded with(bb:=bb)(a:=a);auto.
     intros returned DFRAME.
     apply return_to_caller_guarded.
     assert(PERM':Mem.range_perm returned local 0 4 Cur Freeable).
     { intros ofs R;eapply Mem.perm_unchanged_on;[exact DFRAME|exact LOCAL|apply PERM;exact R]. }
     destruct(Mem.range_perm_free _ _ _ _ PERM')as[final FREE].
     eapply return_value_guarded with(result:=Vint(machine_lookup a))(mf:=final).
     * change(Some(Vint(Int.sign_ext 16(machine_lookup a)))=Some(Vint(machine_lookup a))).
       unfold machine_lookup;rewrite Int.sign_ext_idem by lia;reflexivity.
     * rewrite angle_env_blocks;cbn[Mem.free_list];rewrite FREE;reflexivity.
     * apply END. eapply Mem.unchanged_on_trans;[exact PRE|].
       eapply Mem.unchanged_on_trans;[apply old_frame_weaken;exact DFRAME|].
       eapply Mem.free_unchanged_on;[exact FREE|intros;exact FRESH].
Qed.
Print Assumptions dispatcher_entry_guarded.
