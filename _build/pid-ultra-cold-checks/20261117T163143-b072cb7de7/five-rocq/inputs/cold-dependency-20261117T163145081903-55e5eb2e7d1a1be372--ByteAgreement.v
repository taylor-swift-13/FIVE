From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
From PidPositionTranslationCore Require Import FactoryMemory.
From PidPositionTranslationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.

Lemma loadbytes_from_equal_units : forall n a b blk ofs bytes,
 Mem.loadbytes a blk ofs(Z.of_nat n)=Some bytes ->
 (forall i,0<=i<Z.of_nat n ->Mem.loadbytes a blk(ofs+i)1=Mem.loadbytes b blk(ofs+i)1) ->
 Mem.loadbytes b blk ofs(Z.of_nat n)=Some bytes.
Proof.
 induction n as[|n IH];intros a b blk ofs bytes LOAD UNIT.
 - change(Mem.loadbytes a blk ofs 0=Some bytes)in LOAD.
   rewrite Mem.loadbytes_empty in LOAD by lia;inversion LOAD;subst bytes.
   apply Mem.loadbytes_empty;lia.
 - replace(Z.of_nat(S n))with(1+Z.of_nat n)in LOAD by lia.
   destruct(Mem.loadbytes_split a blk ofs 1(Z.of_nat n)bytes LOAD ltac:(lia)ltac:(lia))
    as[head[tail[HEAD[TAIL EQ]]]];subst bytes.
   replace(Z.of_nat(S n))with(1+Z.of_nat n)by lia.
   apply Mem.loadbytes_concat;try lia.
   + replace ofs with(ofs+0)at 1 by lia.
     rewrite<-(UNIT 0 ltac:(lia));replace(ofs+0)with ofs by lia;exact HEAD.
   + apply IH with(a:=a);[exact TAIL|].
     intros i RANGE;replace(ofs+1+i)with(ofs+(1+i))by lia;apply UNIT;lia.
Qed.

Lemma scalar_load_from_equal_units : forall ch a b blk ofs v,
 Mem.load ch a blk ofs=Some v ->
 (forall i,0<=i<size_chunk ch ->Mem.loadbytes a blk(ofs+i)1=Mem.loadbytes b blk(ofs+i)1) ->
 Mem.load ch b blk ofs=Some v.
Proof.
 intros ch a b blk ofs v LOAD UNIT.
 destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[bytes[BY DECODE]].
 rewrite DECODE;apply Mem.loadbytes_load.
 - replace(size_chunk ch)with(Z.of_nat(Z.to_nat(size_chunk ch)))in BY|-* by(rewrite Z2Nat.id;[reflexivity|pose proof(size_chunk_pos ch);lia]).
   eapply loadbytes_from_equal_units;[exact BY|].
   intros i R;apply UNIT;rewrite Z2Nat.id in R;[exact R|pose proof(size_chunk_pos ch);lia].
 - exact(proj2(Mem.load_valid_access _ _ _ _ _ LOAD)).
Qed.

Lemma canonical_frame_load_transfer : forall gh ret a b ch blk ofs v,
 same_except_positions_and_return gh ret a b ->
 blk<>ret ->
 (forall i,0<=i<size_chunk ch ->~translated_byte gh blk(ofs+i)) ->
 Mem.load ch a blk ofs=Some v ->Mem.load ch b blk ofs=Some v.
Proof.
 intros gh ret a b ch blk ofs v[_[_ BY]]RET NOT LOAD.
 eapply scalar_load_from_equal_units;[exact LOAD|].
 intros i R;apply BY;[apply NOT;exact R|exact RET].
Qed.

Lemma synchronized_store_preserves_canonical_frame : forall gh ret a b dst ofs ch v af bf,
 same_except_positions_and_return gh ret a b ->
 Mem.store ch a dst ofs v=Some af ->Mem.store ch b dst ofs v=Some bf ->
 same_except_positions_and_return gh ret af bf.
Proof.
 intros gh ret a b dst ofs ch v af bf[NEXT[PERM BY]]SA SB;split.
 - rewrite(Mem.nextblock_store _ _ _ _ _ _ SA),(Mem.nextblock_store _ _ _ _ _ _ SB);exact NEXT.
 - split.
   + intros blk i k p;split;intro H.
     * eapply Mem.perm_store_1;[exact SB|]. apply(proj1(PERM blk i k p)).
       eapply Mem.perm_store_2;[exact SA|exact H].
     * eapply Mem.perm_store_1;[exact SA|]. apply(proj2(PERM blk i k p)).
       eapply Mem.perm_store_2;[exact SB|exact H].
   + intros blk i NT RET.
     destruct(peq blk dst)as[->|DIFF].
     * destruct(zlt i ofs)as[LEFT|LEFT].
       -- rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SA dst i 1)by(right;right;left;lia).
          rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SB dst i 1)by(right;right;left;lia).
          apply BY;assumption.
       -- destruct(zle(ofs+size_chunk ch)i)as[RIGHT|RIGHT].
          ++ rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SA dst i 1)by(right;right;right;lia).
             rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SB dst i 1)by(right;right;right;lia).
             apply BY;assumption.
          ++ pose proof(Mem.loadbytes_store_same _ _ _ _ _ _ SA)as LA.
             pose proof(Mem.loadbytes_store_same _ _ _ _ _ _ SB)as LB.
             replace i with(ofs+(i-ofs))by lia.
             eapply loadbytes_equal_subrange;[exact LA|exact LB|lia|lia|lia].
     * rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SA blk i 1)by(left;exact DIFF).
       rewrite(Mem.loadbytes_store_other _ _ _ _ _ _ SB blk i 1)by(left;exact DIFF).
       apply BY;assumption.
Qed.
Print Assumptions canonical_frame_load_transfer.
Print Assumptions synchronized_store_preserves_canonical_frame.
