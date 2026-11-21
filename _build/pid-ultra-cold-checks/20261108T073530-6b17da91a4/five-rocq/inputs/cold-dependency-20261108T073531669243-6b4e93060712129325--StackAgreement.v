From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Values Memory Memdata.
From PidPositionTranslationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.

Lemma unit_loadbytes_absent : forall m b ofs,
 ~Mem.perm m b ofs Cur Readable ->Mem.loadbytes m b ofs 1=None.
Proof.
 intros m b ofs NP;destruct(Mem.loadbytes m b ofs 1)as[bytes|]eqn:L;auto.
 exfalso;apply NP;pose proof(Mem.loadbytes_range_perm _ _ _ _ _ L)as RP;apply RP;lia.
Qed.
Lemma allocated_unit_is_undef : forall m lo hi ma fresh ofs bytes,
 Mem.alloc m lo hi=(ma,fresh) ->
 Mem.loadbytes ma fresh ofs 1=Some bytes ->bytes=[Undef].
Proof.
 intros m lo hi ma fresh ofs bytes AL LOAD.
 pose proof(Mem.loadbytes_length _ _ _ _ _ LOAD)as LEN;change(length bytes=1%nat)in LEN.
 destruct bytes as[|v tail];[discriminate|].
 destruct tail as[|v' tail];[|discriminate].
 f_equal;eapply Mem.loadbytes_alloc_same;[exact AL|exact LOAD|left;reflexivity].
Qed.

Theorem synchronized_alloc_preserves_canonical_frame :
 forall gh ret a b lo hi af ab bf bb,
 same_except_positions_and_return gh ret a b ->
 Mem.alloc a lo hi=(af,ab) ->Mem.alloc b lo hi=(bf,bb) ->
 ab=bb /\same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret a b lo hi af ab bf bb[NB[PERMS BYTES]]AA AB.
 assert(EQ:ab=bb).
 { rewrite(Mem.alloc_result _ _ _ _ _ AA),(Mem.alloc_result _ _ _ _ _ AB);exact NB. }
 subst bb;split;[reflexivity|].
 assert(NEXT:Mem.nextblock af=Mem.nextblock bf).
 { rewrite(Mem.nextblock_alloc _ _ _ _ _ AA),(Mem.nextblock_alloc _ _ _ _ _ AB),NB;reflexivity. }
 assert(PERM:forall blk ofs k p,Mem.perm af blk ofs k p<->Mem.perm bf blk ofs k p).
 { intros blk ofs k p;destruct(peq blk ab)as[EQ|NE].
   - subst blk;split;intro P.
     + pose proof(Mem.perm_alloc_3 _ _ _ _ _ AA _ _ _ P)as R.
       eapply Mem.perm_implies;[apply(Mem.perm_alloc_2 _ _ _ _ _ AB);exact R|destruct p;constructor].
     + pose proof(Mem.perm_alloc_3 _ _ _ _ _ AB _ _ _ P)as R.
       eapply Mem.perm_implies;[apply(Mem.perm_alloc_2 _ _ _ _ _ AA);exact R|destruct p;constructor].
   - split;intro P.
     + apply(Mem.perm_alloc_1 _ _ _ _ _ AB);apply PERMS;eapply Mem.perm_alloc_4;[exact AA|exact P|exact NE].
     + apply(Mem.perm_alloc_1 _ _ _ _ _ AA);apply PERMS;eapply Mem.perm_alloc_4;[exact AB|exact P|exact NE]. }
 split;[exact NEXT|];split;[exact PERM|].
 intros blk ofs NT NR;destruct(peq blk ab)as[EQ|NE].
 - subst blk.
   destruct(Mem.loadbytes af ab ofs 1)as[av|]eqn:LA.
   + assert(RB:Mem.range_perm bf ab ofs(ofs+1)Cur Readable).
     { intros z ZR;apply PERM;exact(Mem.loadbytes_range_perm _ _ _ _ _ LA z ZR). }
     destruct(Mem.range_perm_loadbytes _ _ _ _ RB)as[bv LB];rewrite LB.
     rewrite(allocated_unit_is_undef _ _ _ _ _ _ _ AA LA).
     rewrite(allocated_unit_is_undef _ _ _ _ _ _ _ AB LB);reflexivity.
   + destruct(Mem.loadbytes bf ab ofs 1)as[bv|]eqn:LB;[|reflexivity].
     assert(RA:Mem.range_perm af ab ofs(ofs+1)Cur Readable).
     { intros z ZR;apply PERM;exact(Mem.loadbytes_range_perm _ _ _ _ _ LB z ZR). }
     destruct(Mem.range_perm_loadbytes _ _ _ _ RA)as[av L];rewrite LA in L;discriminate.
 - destruct(plt blk(Mem.nextblock a))as[VA|NVA].
   + assert(VB:Mem.valid_block b blk)by(unfold Mem.valid_block;rewrite<-NB;exact VA).
     rewrite(Mem.loadbytes_alloc_unchanged _ _ _ _ _ AA _ _ _ VA).
     rewrite(Mem.loadbytes_alloc_unchanged _ _ _ _ _ AB _ _ _ VB).
     apply BYTES;assumption.
   + assert(NA:~Mem.perm af blk ofs Cur Readable).
     { intro P;pose proof(Mem.perm_valid_block _ _ _ _ _ P)as V.
       destruct(Mem.valid_block_alloc_inv _ _ _ _ _ AA blk V)as[E|V0];[contradiction|exact(NVA V0)]. }
     assert(NB':~Mem.perm bf blk ofs Cur Readable)by(intro P;apply NA;apply PERM;exact P).
     rewrite(unit_loadbytes_absent _ _ _ NA),(unit_loadbytes_absent _ _ _ NB');reflexivity.
Qed.

Theorem synchronized_free_preserves_canonical_frame :
 forall gh ret a b blk lo hi af bf,
 same_except_positions_and_return gh ret a b ->
 Mem.free a blk lo hi=Some af ->Mem.free b blk lo hi=Some bf ->
 same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret a b blk lo hi af bf[NB[PERMS BYTES]]FA FB.
 assert(PERM:forall b ofs k p,Mem.perm af b ofs k p<->Mem.perm bf b ofs k p).
 { intros b' ofs k p;destruct(peq b' blk)as[EQ|NE].
   - subst b';destruct(zle lo ofs), (zlt ofs hi).
     + split;intro P;exfalso;[exact(Mem.perm_free_2 a blk lo hi af FA ofs k p ltac:(lia)P)|exact(Mem.perm_free_2 b blk lo hi bf FB ofs k p ltac:(lia)P)].
     + split;intro P;[eapply Mem.perm_free_1;[exact FB|right;right;lia|apply PERMS;eapply Mem.perm_free_3;eauto]|
       eapply Mem.perm_free_1;[exact FA|right;right;lia|apply PERMS;eapply Mem.perm_free_3;eauto]].
     + split;intro P;[eapply Mem.perm_free_1;[exact FB|right;left;lia|apply PERMS;eapply Mem.perm_free_3;eauto]|
       eapply Mem.perm_free_1;[exact FA|right;left;lia|apply PERMS;eapply Mem.perm_free_3;eauto]].
     + split;intro P;[eapply Mem.perm_free_1;[exact FB|right;left;lia|apply PERMS;eapply Mem.perm_free_3;eauto]|
       eapply Mem.perm_free_1;[exact FA|right;left;lia|apply PERMS;eapply Mem.perm_free_3;eauto]].
   - split;intro P;[eapply Mem.perm_free_1;[exact FB|left;exact NE|apply PERMS;eapply Mem.perm_free_3;eauto]|
      eapply Mem.perm_free_1;[exact FA|left;exact NE|apply PERMS;eapply Mem.perm_free_3;eauto]]. }
 split.
 - rewrite(Mem.nextblock_free _ _ _ _ _ FA),(Mem.nextblock_free _ _ _ _ _ FB);exact NB.
 - split;[exact PERM|].
   intros b' ofs NT NR;destruct(peq b' blk)as[EQ|NE].
   + subst b';destruct(zle lo ofs), (zlt ofs hi).
     * assert(NA:~Mem.perm af blk ofs Cur Readable)by(eapply Mem.perm_free_2;[exact FA|split;assumption]).
       assert(NB':~Mem.perm bf blk ofs Cur Readable)by(eapply Mem.perm_free_2;[exact FB|split;assumption]).
       rewrite(unit_loadbytes_absent _ _ _ NA),(unit_loadbytes_absent _ _ _ NB');reflexivity.
     * rewrite(Mem.loadbytes_free _ _ _ _ _ FA)by(right;right;right;lia).
       rewrite(Mem.loadbytes_free _ _ _ _ _ FB)by(right;right;right;lia);apply BYTES;assumption.
     * rewrite(Mem.loadbytes_free _ _ _ _ _ FA)by(right;right;left;lia).
       rewrite(Mem.loadbytes_free _ _ _ _ _ FB)by(right;right;left;lia);apply BYTES;assumption.
     * rewrite(Mem.loadbytes_free _ _ _ _ _ FA)by(right;right;left;lia).
       rewrite(Mem.loadbytes_free _ _ _ _ _ FB)by(right;right;left;lia);apply BYTES;assumption.
   + rewrite(Mem.loadbytes_free _ _ _ _ _ FA)by(left;exact NE).
     rewrite(Mem.loadbytes_free _ _ _ _ _ FB)by(left;exact NE);apply BYTES;assumption.
Qed.
Print Assumptions synchronized_alloc_preserves_canonical_frame.
Print Assumptions synchronized_free_preserves_canonical_frame.
