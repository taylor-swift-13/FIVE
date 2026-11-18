From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
From PidPositionTranslationAttempt002 Require Import ByteAgreement.
Import ListNotations.
Open Scope Z_scope.

Lemma replay_stores_exists : forall us m,
 Forall(fun u=>let '(ch,b,ofs,_):=u in Mem.valid_access m ch b ofs Writable)us ->
 exists mf,replay_stores m us=Some mf.
Proof.
 induction us as[|[[[ch b]ofs]v]us IH];intros m ACCESS.
 - exists m;reflexivity.
 - inversion ACCESS as[|u tail A REST];subst.
   destruct(Mem.valid_access_store m ch b ofs v A)as[ma STORE].
   destruct(IH ma ltac:(eapply Forall_impl;[|exact REST];intros[[[cu bu]ou]vu] VA;eapply Mem.store_valid_access_1;eauto))as[mf RUN].
   exists mf;cbn[replay_stores];rewrite STORE;exact RUN.
Qed.
Lemma replay_stores_value_at : forall i us m mf ch b ofs v,
 nth_error us i=Some(ch,b,ofs,v) ->replay_stores m us=Some mf ->
 Forall(misses_chunk ch b ofs)(skipn(S i)us) ->
 Mem.load ch mf b ofs=Some(Val.load_result ch v).
Proof.
 induction i as[|i IH];intros us m mf ch b ofs v NTH RUN MISS;
 destruct us as[|[[[cu bu]ou]vu]us];try discriminate;
 cbn[replay_stores]in RUN;
 destruct(Mem.store cu m bu ou vu)as[ma|]eqn:STORE;try discriminate.
 - cbn[nth_error]in NTH;injection NTH as<- <- <- <-.
   cbn[skipn]in MISS;rewrite(replay_stores_load_frame _ _ _ _ _ _ RUN MISS).
   eapply Mem.load_store_same;exact STORE.
 - eapply IH;[exact NTH|exact RUN|exact MISS].
Qed.

Lemma global_contract_after_allocation : forall m ma fresh lo hi,
 global_bytes_initialized m ->
 (forall b gv,Genv.find_var_info Execution.ge b=Some gv ->Mem.valid_block m b) ->
 Mem.alloc m lo hi=(ma,fresh) ->global_bytes_initialized ma.
Proof.
 intros m ma fresh lo hi[init[INIT GLOBAL]]VALID ALLOC.
 exists init;split;[exact INIT|].
 intros b gv VAR;destruct(GLOBAL b gv VAR)as[RP BY];split.
 - intros ofs R;eapply Mem.perm_alloc_1;[exact ALLOC|apply RP;exact R].
 - intros RO ofs R;erewrite Mem.loadbytes_alloc_unchanged;[|exact ALLOC|apply VALID with(gv:=gv);exact VAR].
   apply BY;assumption.
Qed.
Lemma global_contract_after_store : forall m mf ch dst ofs v,
 global_bytes_initialized m ->
 (forall b gv,Genv.find_var_info Execution.ge b=Some gv ->gvar_readonly gv=true ->b<>dst) ->
 Mem.store ch m dst ofs v=Some mf ->global_bytes_initialized mf.
Proof.
 intros m mf ch dst ofs v[init[INIT GLOBAL]]OUT STORE.
 exists init;split;[exact INIT|].
 intros b gv VAR;destruct(GLOBAL b gv VAR)as[RP BY];split.
 - intros i R;eapply Mem.perm_store_1;[exact STORE|apply RP;exact R].
 - intros RO i R;rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ STORE b i 1)
    by(left;eapply OUT;eauto);apply BY;assumption.
Qed.
Lemma global_contract_after_replay : forall us m mf,
 global_bytes_initialized m ->
 Forall(fun u=>let '(_,dst,_,_):=u in
 forall b gv,Genv.find_var_info Execution.ge b=Some gv ->gvar_readonly gv=true ->b<>dst)us ->
 replay_stores m us=Some mf ->global_bytes_initialized mf.
Proof.
 induction us as[|[[[ch dst]ofs]v]us IH];intros m mf GOOD OUT RUN;cbn[replay_stores]in RUN.
 - injection RUN as<-;exact GOOD.
 - destruct(Mem.store ch m dst ofs v)as[ma|]eqn:STORE;try discriminate.
   inversion OUT as[|u tail HEAD REST];subst.
   eapply IH;[eapply global_contract_after_store;eauto|exact REST|exact RUN].
Qed.

Lemma translated_store_pair_preserves_canonical_frame : forall gh ret a b dst ofs ch va vb af bf,
 same_except_positions_and_return gh ret a b ->
 (forall i,ofs<=i<ofs+size_chunk ch ->translated_byte gh dst i) ->
 Mem.store ch a dst ofs va=Some af ->Mem.store ch b dst ofs vb=Some bf ->
 same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret a b dst ofs ch va vb af bf[NEXT[PERM BY]]TRAN SA SB;split.
 - rewrite(Mem.nextblock_store _ _ _ _ _ _ SA),(Mem.nextblock_store _ _ _ _ _ _ SB);exact NEXT.
 - split.
   + intros blk i k p;split;intro H.
     * eapply Mem.perm_store_1;[exact SB|]. apply(proj1(PERM blk i k p)).
       eapply Mem.perm_store_2;[exact SA|exact H].
     * eapply Mem.perm_store_1;[exact SA|]. apply(proj2(PERM blk i k p)).
       eapply Mem.perm_store_2;[exact SB|exact H].
   + intros blk i NT RET.
     assert(OUT:blk<>dst \/i+1<=ofs\/ofs+size_chunk ch<=i).
     { destruct(peq blk dst)as[->|D];[right|left;exact D].
       destruct(zlt i ofs);[left;lia|right].
       destruct(zle(ofs+size_chunk ch)i);[exact l|].
       exfalso;apply NT;apply TRAN;lia. }
     rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SA blk i 1)by(tauto).
     rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SB blk i 1)by(tauto).
     apply BY;assumption.
Qed.
Definition compatible_update(gh:block)(u v:scalar_update):Prop:=
 exists ch dst ofs va vb,u=(ch,dst,ofs,va)/\v=(ch,dst,ofs,vb)/\
 (va=vb\/(forall i,ofs<=i<ofs+size_chunk ch->translated_byte gh dst i)).
Lemma compatible_replay_preserves_canonical_frame : forall gh ret us vs a b af bf,
 Forall2(compatible_update gh)us vs ->
 same_except_positions_and_return gh ret a b ->
 replay_stores a us=Some af ->replay_stores b vs=Some bf ->
 same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret us vs a b af bf COMP;revert a b af bf.
 induction COMP;intros a b af bf FRAME UA UB.
 - cbn[replay_stores]in UA,UB;injection UA as<-;injection UB as<-;exact FRAME.
 - destruct H as[ch[dst[ofs[va[vb[-> [-> CASE]]]]]]].
   cbn[replay_stores]in UA,UB.
   destruct(Mem.store ch a dst ofs va)as[ma|]eqn:SA;try discriminate.
   destruct(Mem.store ch b dst ofs vb)as[mb|]eqn:SB;try discriminate.
   eapply IHCOMP;[|exact UA|exact UB].
   destruct CASE as[EQ|TR].
   + subst vb;eapply synchronized_store_preserves_canonical_frame;eauto.
   + eapply translated_store_pair_preserves_canonical_frame;eauto.
Qed.
Print Assumptions compatible_replay_preserves_canonical_frame.
