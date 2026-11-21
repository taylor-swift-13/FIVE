From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
From FiveMatInv3Case Require Import MatrixMemory.
From FiveMatrixInverseSupport Require Import Witness.
Require FiveInv2Case.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition GuardValue(n i:Z):float32:=if Z.eqb i 0 then Float32.of_bits(Int.repr 305419896) else if Z.eqb i(n+1)then Float32.of_bits(Int.repr 2596069104)else Float32.zero.
Definition Guarded(n:Z)(m:mem)(bo bi:block)(f:Z->float32):Prop:=bo<>bi /\WriteRegion m bo(Ptrofs.repr 4)n /\Reads m bi Ptrofs.zero n f /\Reads m bo(Ptrofs.repr 4)n(fun _=>Float32.zero) /\
 Mem.load Mint32 m bo 0=Some(Vint(Int.repr 305419896)) /\Mem.load Mint32 m bo(4*n+4)=Some(Vint(Int.repr 2596069104)).
Lemma guarded_extend:forall n xs m0 bi f,
 (n=4\/n=9)->Reads m0 bi Ptrofs.zero n f->
 (forall i x,In(i,x)xs->0<=i<n+2)->NoDup(map fst xs)->(forall i,0<=i<n+2->In(i,GuardValue n i)xs)->
 exists m bo,Guarded n m bo bi f.
Proof.
 intros n xs m0 bi f N RD RANGE ND COVER.
 assert(POS:0<n)by(destruct N as[-> | ->];lia).
 pose proof(reads_valid m0 bi Ptrofs.zero n f POS RD)as VI.
 destruct(Mem.alloc m0 0(4*(n+2)))as[ma bo]eqn:A.
 assert(NE:bo<>bi)by(intro EQ;subst bo;exact(Mem.fresh_block_alloc _ _ _ _ _ A VI)).
 assert(W:WriteRegion ma bo Ptrofs.zero(n+2)).
 { unfold WriteRegion;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split.
 - change Ptrofs.modulus with 18446744073709551616;destruct N as[-> | ->];lia.
 - intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact Z]|constructor]. }
 assert(RA:Reads ma bi Ptrofs.zero n f).
 { destruct RD as[AL[NW R]];split;[exact AL|];split;[exact NW|];intros i I;erewrite Mem.load_alloc_unchanged;[apply R;exact I|exact A|exact VI]. }
 destruct(writes_exist xs ma bo Ptrofs.zero(n+2)W RANGE)as[m WR].
 assert(WF:WriteRegion m bo Ptrofs.zero(n+2))by(eapply writes_writable;[exact WR|exact W]).
 assert(RF:Reads m bi Ptrofs.zero n f)by(eapply writes_reads_other;[exact WR|exact RA|congruence]).
 assert(CELLS:forall i,0<=i<n+2->Mem.loadbytes m bo(4*i)4=Some(encode_val Mfloat32(Vsingle(GuardValue n i)))).
 { intros i I;replace(4*i)with(Ptrofs.unsigned Ptrofs.zero+4*i)by(rewrite Ptrofs.unsigned_zero;lia);eapply writes_bytes;[exact WR|exact ND|apply COVER;exact I]. }
 assert(OUTW:WriteRegion m bo(Ptrofs.repr 4)n).
 { destruct WF as[_[NW RP]];rewrite Ptrofs.unsigned_zero in NW,RP;unfold WriteRegion;change((4|4)/\4+4*n<=Ptrofs.modulus/\Mem.range_perm m bo 4(4+4*n)Cur Writable).
 split;[exists 1;lia|];split;[lia|intros z Z;apply RP;lia]. }
 assert(OUTR:Reads m bo(Ptrofs.repr 4)n(fun _=>Float32.zero)).
 { destruct OUTW as[AL[NW P]];split;[exact AL|];split;[exact NW|];intros i I.
   assert(G:GuardValue n(i+1)=Float32.zero).
   { unfold GuardValue;rewrite(proj2(Z.eqb_neq(i+1)0)ltac:(lia)),(proj2(Z.eqb_neq(i+1)(n+1))ltac:(lia));reflexivity. }
   pose proof(CELLS(i+1)ltac:(lia))as B;rewrite G in B.
   replace(4*(i+1))with(4+4*i)in B by lia.
   pose proof(Mem.loadbytes_load Mfloat32 m bo(4+4*i)_ B ltac:(change(4|4+4*i);exists(1+i);lia))as L.
   pose proof(decode_encode_val_similar(Vsingle Float32.zero)Mfloat32 Mfloat32 _ eq_refl eq_refl(decode_encode_val_general(Vsingle Float32.zero)Mfloat32 Mfloat32))as DE.
   change(decode_val Mfloat32(encode_val Mfloat32(Vsingle Float32.zero))=Vsingle Float32.zero)in DE;rewrite DE in L;exact L. }
 assert(G0:Mem.load Mint32 m bo 0=Some(Vint(Int.repr 305419896))).
 { pose proof(CELLS 0 ltac:(lia))as B;unfold GuardValue in B;rewrite Z.eqb_refl in B.
   pose proof(Mem.loadbytes_load Mint32 m bo 0 _ B ltac:(exists 0;lia))as L.
   pose proof(decode_encode_val_general(Vsingle(Float32.of_bits(Int.repr 305419896)))Mfloat32 Mint32)as DE.
   change(decode_val Mint32(encode_val Mfloat32(Vsingle(Float32.of_bits(Int.repr 305419896))))=Vint(Int.repr 305419896))in DE;rewrite DE in L;exact L. }
 assert(GN:Mem.load Mint32 m bo(4*n+4)=Some(Vint(Int.repr 2596069104))).
 { pose proof(CELLS(n+1)ltac:(lia))as B;unfold GuardValue in B;rewrite(proj2(Z.eqb_neq(n+1)0)ltac:(lia))in B;rewrite Z.eqb_refl in B.
   replace(4*(n+1))with(4*n+4)in B by lia.
   pose proof(Mem.loadbytes_load Mint32 m bo(4*n+4)_ B ltac:(change(4|4*n+4);exists(n+1);lia))as L.
   pose proof(decode_encode_val_general(Vsingle(Float32.of_bits(Int.repr 2596069104)))Mfloat32 Mint32)as DE.
   change(decode_val Mint32(encode_val Mfloat32(Vsingle(Float32.of_bits(Int.repr 2596069104))))=Vint(Int.repr 2596069104))in DE;rewrite DE in L;exact L. }
 exists m,bo;split;[exact NE|];split;[exact OUTW|];split;[exact RF|];split;[exact OUTR|];split;assumption.
Qed.
Theorem matrix4_guarded:forall f:Z->float32,exists m bo bi,Guarded 4 m bo bi f.
Proof.
 intro f;destruct(matrix4_inhabited f)as[m0[unused[bi H]]].
 unfold FiveInv2Case.Contract.Inputs in H;destruct H as[NE[W RD]].
 set(xs:=[(0,GuardValue 4 0);(1,GuardValue 4 1);(2,GuardValue 4 2);(3,GuardValue 4 3);(4,GuardValue 4 4);(5,GuardValue 4 5)]).
 destruct(guarded_extend 4 xs m0 bi f ltac:(left;reflexivity)RD)as[m[bo G]].
 - intros i x IN;unfold xs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia.
 - unfold xs;repeat constructor;simpl;intuition discriminate.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5)by lia;repeat destruct H as[H|H];subst i;unfold xs;repeat(first[left;reflexivity|right]).
 - exists m,bo,bi;exact G.
Qed.
Print Assumptions matrix4_guarded.
Theorem matrix9_guarded:forall f:Z->float32,exists m bo bi,Guarded 9 m bo bi f.
Proof.
 intro f;destruct(matrix9_inhabited f)as[m0[unused[bi H]]].
 destruct H as[NE[W RD]].
 set(xs:=[(0,GuardValue 9 0);(1,GuardValue 9 1);(2,GuardValue 9 2);(3,GuardValue 9 3);(4,GuardValue 9 4);(5,GuardValue 9 5);(6,GuardValue 9 6);(7,GuardValue 9 7);(8,GuardValue 9 8);(9,GuardValue 9 9);(10,GuardValue 9 10)]).
 destruct(guarded_extend 9 xs m0 bi f ltac:(right;reflexivity)RD)as[m[bo G]].
 - intros i x IN;unfold xs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia.
 - unfold xs;repeat constructor;simpl;intuition discriminate.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8\/i=9\/i=10)by lia;repeat destruct H as[H|H];subst i;unfold xs;repeat(first[left;reflexivity|right]).
 - exists m,bo,bi;exact G.
Qed.
Print Assumptions matrix9_guarded.
