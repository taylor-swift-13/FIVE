From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata.
From FiveMatInv3Case Require Import MatrixMemory.
Require FiveInv2Case.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Lemma matrix_memory_exists:forall n xs (f:Z->float32),
 0<n ->4*n<=Ptrofs.modulus ->
 (forall i x,In(i,x)xs->0<=i<n) ->NoDup(map fst xs) ->
 (forall i,0<=i<n->In(i,f i)xs) ->
 exists m bo bi,bo<>bi /\WriteRegion m bo Ptrofs.zero n /\ Reads m bi Ptrofs.zero n f.
Proof.
 intros n xs f N LIMIT B ND COVER.
 destruct(Mem.alloc Mem.empty 0(4*n))as[ma bo]eqn:AO.
 destruct(Mem.alloc ma 0(4*n))as[mi bi]eqn:AI.
 assert(NE:bo<>bi).
 { rewrite(Mem.alloc_result _ _ _ _ _ AO),(Mem.alloc_result _ _ _ _ _ AI),(Mem.nextblock_alloc _ _ _ _ _ AO).
   intro E;apply(f_equal Pos.to_nat)in E;rewrite Pos2Nat.inj_succ in E;lia. }
 assert(WI:WriteRegion mi bi Ptrofs.zero n).
 { unfold WriteRegion;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|].
   intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AI|exact Z]|constructor]. }
 assert(WO:WriteRegion mi bo Ptrofs.zero n).
 { unfold WriteRegion;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|].
   intros z Z;eapply Mem.perm_alloc_1;[exact AI|].
   eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AO|exact Z]|constructor]. }
 destruct(writes_exist xs mi bi Ptrofs.zero n WI B)as[m WR].
 exists m,bo,bi;split;[exact NE|];split.
 - destruct WO as[AL[NW RP]];split;[exact AL|];split;[exact NW|].
   intros z Z;eapply writes_permissions;[exact WR|apply RP;exact Z].
 - unfold Reads;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|].
   intros i I.
   pose proof(writes_bytes xs mi bi(Ptrofs.unsigned Ptrofs.zero)m WR ND i(f i)(COVER i I))as BYTES.
   rewrite Ptrofs.unsigned_zero in BYTES;cbn[Z.add]in BYTES.
   pose proof(Mem.loadbytes_load Mfloat32 m bi(4*i)(encode_val Mfloat32(Vsingle(f i)))BYTES ltac:(change(4|4*i);exists i;lia))as LOAD.
   assert(DE:decode_val Mfloat32(encode_val Mfloat32(Vsingle(f i)))=Vsingle(f i)).
   { exact(decode_encode_val_similar (Vsingle(f i)) Mfloat32 Mfloat32 _ eq_refl eq_refl (decode_encode_val_general (Vsingle(f i)) Mfloat32 Mfloat32)). }
   rewrite DE in LOAD;exact LOAD.
Qed.
Theorem matrix4_inhabited:forall f:Z->float32,exists m bo bi,
 FiveInv2Case.Contract.Inputs m bo bi Ptrofs.zero Ptrofs.zero f.
Proof.
 intro f;set(xs:=[(0,f 0);(1,f 1);(2,f 2);(3,f 3)]).
 apply(matrix_memory_exists 4 xs f);try(change(16<=18446744073709551616);lia);try lia.
 - intros i x IN;unfold xs in IN;cbn in IN.
   repeat match goal with H:_ \/ _ |- _=>destruct H end;try contradiction;
   match goal with H:(_,_) = (_,_) |- _=>inversion H;lia end.
 - unfold xs;repeat constructor;cbn;intuition congruence.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3)by lia;destruct H as [ -> | [ -> | [ -> | -> ] ] ];unfold xs;cbn;auto 12.
Qed.
Theorem matrix9_inhabited:forall f:Z->float32,exists m bo bi,
 bo<>bi /\WriteRegion m bo Ptrofs.zero 9 /\ Reads m bi Ptrofs.zero 9 f.
Proof.
 intro f;set(xs:=[(0,f 0);(1,f 1);(2,f 2);(3,f 3);(4,f 4);(5,f 5);(6,f 6);(7,f 7);(8,f 8)]).
 apply(matrix_memory_exists 9 xs f);try(change(36<=18446744073709551616);lia);try lia.
 - intros i x IN;unfold xs in IN;cbn in IN.
   repeat match goal with H:_ \/ _ |- _=>destruct H end;try contradiction;
   match goal with H:(_,_) = (_,_) |- _=>inversion H;lia end.
 - unfold xs;repeat constructor;cbn;intuition congruence.
 - intros i I;assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;
   destruct H as [ -> | [ -> | [ -> | [ -> | [ -> | [ -> | [ -> | [ -> | -> ] ] ] ] ] ] ] ];unfold xs;cbn;auto 12.
Qed.
Print Assumptions matrix4_inhabited.
Print Assumptions matrix9_inhabited.

Lemma written_region_reads:forall n xs (g:Z->float32) m b mf,
 4*n<=Ptrofs.modulus ->Writes m b 0 xs mf ->NoDup(map fst xs) ->
 (forall i,0<=i<n->In(i,g i)xs) ->Reads mf b Ptrofs.zero n g.
Proof.
 intros n xs g m b mf LIMIT WR ND COVER.
 unfold Reads;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|];split;[exact LIMIT|].
 intros i I;pose proof(writes_bytes xs m b 0 mf WR ND i(g i)(COVER i I))as BYTES.
 cbn[Z.add]in BYTES.
 pose proof(Mem.loadbytes_load Mfloat32 mf b(4*i)(encode_val Mfloat32(Vsingle(g i)))BYTES ltac:(change(4|4*i);exists i;lia))as LOAD.
 assert(DE:decode_val Mfloat32(encode_val Mfloat32(Vsingle(g i)))=Vsingle(g i)).
 { exact(decode_encode_val_similar(Vsingle(g i))Mfloat32 Mfloat32 _ eq_refl eq_refl(decode_encode_val_general(Vsingle(g i))Mfloat32 Mfloat32)). }
 rewrite DE in LOAD;exact LOAD.
Qed.
Theorem matrix4_initialized:forall f g:Z->float32,exists m bo bi,
 FiveInv2Case.Contract.Inputs m bo bi Ptrofs.zero Ptrofs.zero f /\ Reads m bo Ptrofs.zero 4 g.
Proof.
 intros f g;destruct(matrix4_inhabited f)as[m[bo[bi[NE[WO RI]]]]].
 set(xs:=[(0,g 0);(1,g 1);(2,g 2);(3,g 3)]).
 assert(B:forall i x,In(i,x)xs->0<=i<4).
 { intros i x IN;unfold xs in IN;cbn in IN.
   repeat match goal with H:_ \/ _ |- _=>destruct H end;try contradiction;
   match goal with H:(_,_) = (_,_) |- _=>inversion H;lia end. }
 assert(ND:NoDup(map fst xs))by(unfold xs;repeat constructor;cbn;intuition congruence).
 assert(COVER:forall i,0<=i<4->In(i,g i)xs).
 { intros i I;assert(i=0\/i=1\/i=2\/i=3)by lia;destruct H as[-> | [-> | [-> | ->]]];unfold xs;cbn;auto 12. }
 destruct(writes_exist xs m bo Ptrofs.zero 4 WO B)as[mf WR].
 exists mf,bo,bi;split.
 - split;[exact NE|];split;[eapply writes_writable;[exact WR|exact WO]|].
   eapply writes_reads_other;[exact WR|exact RI|congruence].
 - eapply written_region_reads;[change(16<=18446744073709551616);lia|exact WR|exact ND|exact COVER].
Qed.
Print Assumptions matrix4_initialized.
