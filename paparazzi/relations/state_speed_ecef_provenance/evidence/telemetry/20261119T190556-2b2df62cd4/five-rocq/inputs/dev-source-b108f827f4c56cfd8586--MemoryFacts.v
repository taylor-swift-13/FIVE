From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Events Ctypes Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation.
Import ListNotations.
Open Scope Z_scope.

Lemma range_access:forall m b n ch ofs p,
 Mem.range_perm m b 0 n Cur p ->0<=ofs ->ofs+size_chunk ch<=n ->
 (align_chunk ch|ofs) ->Mem.valid_access m ch b ofs p.
Proof. intros;split;[intros i R;apply H;lia|assumption]. Qed.
Lemma range_valid:forall m b n p,0<n ->Mem.range_perm m b 0 n Cur p ->Mem.valid_block m b.
Proof. intros m b n p N RP;eapply Mem.perm_valid_block;apply(RP 0);lia. Qed.
Lemma loaded_valid:forall ch m b ofs v,Mem.load ch m b ofs=Some v ->Mem.valid_block m b.
Proof.
 intros ch m b ofs v LOAD;pose proof(Mem.load_valid_access _ _ _ _ _ LOAD)as[PERM ALIGN].
 eapply Mem.perm_valid_block;apply(PERM ofs);pose proof(size_chunk_pos ch);lia.
Qed.
Lemma scalar_deref:forall ge m ty ch b ofs v,
 type_is_volatile ty=false ->access_mode ty=By_value ch ->
 0<=ofs<=Ptrofs.max_unsigned ->ofs+size_chunk ch<=Ptrofs.modulus ->
 Mem.load ch m b ofs=Some v ->
 Cexec.do_deref_loc ge quiet_world ty m b(Ptrofs.repr ofs)Full=Some(quiet_world,E0,v).
Proof.
 intros ge m ty ch b ofs v NV AM R END LOAD.
 unfold Cexec.do_deref_loc;rewrite AM,NV;unfold Mem.loadv.
 rewrite Ptrofs.unsigned_repr by exact R.
 rewrite zle_true by exact END;rewrite LOAD;reflexivity.
Qed.
Lemma pure_scalar:forall ge e m l ty ch b ofs v,
 typeof l=ty ->type_is_volatile ty=false ->access_mode ty=By_value ch ->
 pure_lval ge e m l=Some(b,Ptrofs.repr ofs,Full) ->
 0<=ofs<=Ptrofs.max_unsigned ->ofs+size_chunk ch<=Ptrofs.modulus ->
 Mem.load ch m b ofs=Some v ->pure_rval ge e m(Evalof l ty)=Some v.
Proof.
 intros ge e m l ty ch b ofs v TY NV AM LL R END LOAD.
 change((if type_eq ty(typeof l)then
 match pure_lval ge e m l with
 |Some(bb,oo,bf)=>match Cexec.do_deref_loc ge quiet_world ty m bb oo bf with
 |Some(_,_,w)=>Some w|None=>None end|None=>None end else None)=Some v).
 rewrite TY,dec_eq_true,LL.
 rewrite(scalar_deref ge m ty ch b ofs v NV AM R END LOAD);reflexivity.
Qed.

Lemma interval_miss:forall ofs n w k,
 0<=n ->0<k ->
 (forall i,ofs<=i<ofs+n ->~(w<=i<w+k)) ->
 n<=0 \/ofs+n<=w \/w+k<=ofs.
Proof.
 intros ofs n w k N K MISS.
 destruct(Z_le_dec n 0);[auto|].
 destruct(Z_le_dec(ofs+n)w);[auto|].
 destruct(Z_le_dec(w+k)ofs);[auto|].
 exfalso;apply(MISS(Z.max ofs w)).
 - pose proof(Z.le_max_l ofs w);pose proof(Z.max_spec ofs w)as[[A E]|[A E]];lia.
 - pose proof(Z.le_max_r ofs w);pose proof(Z.max_spec ofs w)as[[A E]|[A E]];lia.
Qed.
Lemma store_bytes_frame:forall ch m b ofs v mf target start n,
 Mem.store ch m b ofs v=Some mf ->0<=n ->
 (target<>b \/forall i,start<=i<start+n ->~(ofs<=i<ofs+size_chunk ch)) ->
 Mem.loadbytes mf target start n=Mem.loadbytes m target start n.
Proof.
 intros ch m b ofs v mf target start n STORE N[NE|MISS].
 - eapply Mem.loadbytes_store_other;[exact STORE|left;exact NE].
 - eapply Mem.loadbytes_store_other;[exact STORE|].
   right;destruct(interval_miss start n ofs(size_chunk ch)N ltac:(pose proof(size_chunk_pos ch);lia)MISS)as[Z|[L|R]];auto.
Qed.
Lemma store_perm_iff:forall ch m b ofs v mf,
 Mem.store ch m b ofs v=Some mf ->forall b' ofs' k p,
 Mem.perm m b' ofs' k p<->Mem.perm mf b' ofs' k p.
Proof. intros;split;[eapply Mem.perm_store_1|eapply Mem.perm_store_2];eauto. Qed.
Print Assumptions pure_scalar.
Print Assumptions store_bytes_frame.
