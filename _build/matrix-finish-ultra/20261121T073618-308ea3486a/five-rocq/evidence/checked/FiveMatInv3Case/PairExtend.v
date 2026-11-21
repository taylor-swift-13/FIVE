From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
From FiveMatInv3Case Require Import MatrixMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition BytePreserved(m0 m:mem):Prop:=forall b z n,Mem.valid_block m0 b->Mem.loadbytes m b z n=Mem.loadbytes m0 b z n.
Definition LoadPreserved(m0 m:mem):Prop:=forall ch b z,Mem.valid_block m0 b->Mem.load ch m b z=Mem.load ch m0 b z.
Definition AccessPreserved(m0 m:mem):Prop:=forall ch b z p,Mem.valid_access m0 ch b z p->Mem.valid_access m ch b z p.
Definition BlocksPreserved(m0 m:mem):Prop:=forall b,Mem.valid_block m0 b->Mem.valid_block m b.
Lemma writes_load_other_block:forall xs m b base mf,Writes m b base xs mf->forall ch q z,q<>b->Mem.load ch mf q z=Mem.load ch m q z.
Proof. induction xs as[|[i x]xs IH];intros m b base mf WR ch q z NE;cbn[Writes]in WR;[subst mf;reflexivity|].
 destruct WR as[m1[ST REST]];rewrite(IH m1 b base mf REST ch q z NE);erewrite Mem.load_store_other;[reflexivity|exact ST|left;exact NE]. Qed.
Lemma writes_blocks:forall xs m b base mf,Writes m b base xs mf->BlocksPreserved m mf.
Proof. induction xs as[|[i x]xs IH];intros m b base mf WR q VB;cbn[Writes]in WR;[subst mf;exact VB|].
 destruct WR as[m1[ST REST]];eapply IH;[exact REST|];eapply Mem.store_valid_block_1;eauto. Qed.
Definition ArrayExtended(n:Z)(m0 m:mem)(b:block)(f:Z->float32):Prop:=
 ~Mem.valid_block m0 b /\WriteRegion m b Ptrofs.zero n /\Reads m b Ptrofs.zero n f /\
 BytePreserved m0 m /\LoadPreserved m0 m /\AccessPreserved m0 m /\BlocksPreserved m0 m.
Lemma array_extend:forall n xs m0 f,
 0<n->4*n<=Ptrofs.modulus->(forall i x,In(i,x)xs->0<=i<n)->NoDup(map fst xs)->(forall i,0<=i<n->In(i,f i)xs)->
 exists m b,ArrayExtended n m0 m b f.
Proof.
 intros n xs m0 f N LIMIT RANGE ND COVER.
 destruct(Mem.alloc m0 0(4*n))as[ma b]eqn:A.
 pose proof(Mem.fresh_block_alloc _ _ _ _ _ A)as FRESH.
 assert(WA:WriteRegion ma b Ptrofs.zero n).
 { unfold WriteRegion;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|].
   intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact Z]|constructor]. }
 destruct(writes_exist xs ma b Ptrofs.zero n WA RANGE)as[m WR].
 exists m,b;split;[exact FRESH|];split;[eapply writes_writable;[exact WR|exact WA]|];split.
 - unfold Reads;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|];intros i I.
   pose proof(writes_bytes xs ma b(Ptrofs.unsigned Ptrofs.zero)m WR ND i(f i)(COVER i I))as B;rewrite Ptrofs.unsigned_zero in B;cbn[Z.add]in B.
   pose proof(Mem.loadbytes_load Mfloat32 m b(4*i)_ B ltac:(change(4|4*i);exists i;lia))as L.
   pose proof(decode_encode_val_similar(Vsingle(f i))Mfloat32 Mfloat32 _ eq_refl eq_refl(decode_encode_val_general(Vsingle(f i))Mfloat32 Mfloat32))as DE.
   change(decode_val Mfloat32(encode_val Mfloat32(Vsingle(f i)))=Vsingle(f i))in DE;rewrite DE in L;exact L.
 - split.
   + intros q z count V;rewrite(writes_unaffected xs ma b(Ptrofs.unsigned Ptrofs.zero)m WR q z count)by(intros;left;intro EQ;subst q;exact(FRESH V));eapply Mem.loadbytes_alloc_unchanged;eauto.
   + split.
     * intros ch q z V;rewrite(writes_load_other_block xs ma b(Ptrofs.unsigned Ptrofs.zero)m WR ch q z)by(intro EQ;subst q;exact(FRESH V));eapply Mem.load_alloc_unchanged;eauto.
     * split.
       -- intros ch q z perm VA;eapply writes_access;[exact WR|]. destruct VA as[RP AL];split;[intros off B;eapply Mem.perm_alloc_1;[exact A|apply RP;exact B]|exact AL].
       -- intros q V;eapply writes_blocks;[exact WR|];eapply Mem.valid_block_alloc;eauto.
Qed.
Theorem array4_extend:forall m0 f,exists m b,ArrayExtended 4 m0 m b f.
Proof.
 intros m0 f;set(xs:=[(0,f 0);(1,f 1);(2,f 2);(3,f 3)]);apply(array_extend 4 xs m0 f);try(change(16<=18446744073709551616);lia);try lia.
 - intros i x IN;unfold xs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia.
 - unfold xs;repeat constructor;simpl;intuition discriminate.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3)by lia;repeat destruct H as[H|H];subst i;unfold xs;repeat(first[left;reflexivity|right]).
Qed.
Theorem array9_extend:forall m0 f,exists m b,ArrayExtended 9 m0 m b f.
Proof.
 intros m0 f;set(xs:=[(0,f 0);(1,f 1);(2,f 2);(3,f 3);(4,f 4);(5,f 5);(6,f 6);(7,f 7);(8,f 8)]);apply(array_extend 9 xs m0 f);try(change(36<=18446744073709551616);lia);try lia.
 - intros i x IN;unfold xs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia.
 - unfold xs;repeat constructor;simpl;intuition discriminate.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;repeat destruct H as[H|H];subst i;unfold xs;repeat(first[left;reflexivity|right]).
Qed.
Definition PairExtended(n:Z)(m0 m:mem)(bo bi:block)(f old:Z->float32):Prop:=
 bo<>bi /\WriteRegion m bo Ptrofs.zero n /\Reads m bi Ptrofs.zero n f /\Reads m bo Ptrofs.zero n old /\
 ~Mem.valid_block m0 bo /\~Mem.valid_block m0 bi /\
 BytePreserved m0 m /\LoadPreserved m0 m /\AccessPreserved m0 m /\BlocksPreserved m0 m.
Theorem pair4_extend:forall m0 f old,exists m bo bi,PairExtended 4 m0 m bo bi f old.
Proof.
 intros m0 f old;destruct(array4_extend m0 f)as[mi[bi[FI[WI[RI[B1[L1[A1 V1]]]]]]]].
 destruct(array4_extend mi old)as[m[bo[FO[WO[RO[B2[L2[A2 V2]]]]]]]].
 pose proof(reads_valid mi bi Ptrofs.zero 4 f ltac:(lia)RI)as VI.
 assert(NE:bo<>bi)by(intro EQ;subst bo;exact(FO VI)).
 assert(RF:Reads m bi Ptrofs.zero 4 f).
 { destruct RI as[AL[NW RD]];split;[exact AL|];split;[exact NW|];intros i I;rewrite L2 by exact VI;apply RD;exact I. }
 exists m,bo,bi;split;[exact NE|];split;[exact WO|];split;[exact RF|];split;[exact RO|];split.
 - intro V;apply FO;apply V1;exact V.
 - split;[exact FI|];split.
   + intros q z count V;rewrite B2 by(apply V1;exact V);apply B1;exact V.
   + split.
     * intros ch q z V;rewrite L2 by(apply V1;exact V);apply L1;exact V.
     * split;[intros ch q z perm VA;apply A2;apply A1;exact VA|intros q V;apply V2;apply V1;exact V].
Qed.
Print Assumptions pair4_extend.
Theorem pair9_extend:forall m0 f old,exists m bo bi,PairExtended 9 m0 m bo bi f old.
Proof.
 intros m0 f old;destruct(array9_extend m0 f)as[mi[bi[FI[WI[RI[B1[L1[A1 V1]]]]]]]].
 destruct(array9_extend mi old)as[m[bo[FO[WO[RO[B2[L2[A2 V2]]]]]]]].
 pose proof(reads_valid mi bi Ptrofs.zero 9 f ltac:(lia)RI)as VI.
 assert(NE:bo<>bi)by(intro EQ;subst bo;exact(FO VI)).
 assert(RF:Reads m bi Ptrofs.zero 9 f).
 { destruct RI as[AL[NW RD]];split;[exact AL|];split;[exact NW|];intros i I;rewrite L2 by exact VI;apply RD;exact I. }
 exists m,bo,bi;split;[exact NE|];split;[exact WO|];split;[exact RF|];split;[exact RO|];split.
 - intro V;apply FO;apply V1;exact V.
 - split;[exact FI|];split.
   + intros q z count V;rewrite B2 by(apply V1;exact V);apply B1;exact V.
   + split.
     * intros ch q z V;rewrite L2 by(apply V1;exact V);apply L1;exact V.
     * split;[intros ch q z perm VA;apply A2;apply A1;exact VA|intros q V;apply V2;apply V1;exact V].
Qed.
Print Assumptions pair9_extend.
