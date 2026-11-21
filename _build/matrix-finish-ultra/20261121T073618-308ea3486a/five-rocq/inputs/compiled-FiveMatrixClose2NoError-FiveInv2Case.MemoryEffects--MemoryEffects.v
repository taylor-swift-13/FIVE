From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem.
From FiveMatInv3Case Require Import MatrixMemory.
From FiveInv2Case Require Import Contract Body.
Import ListNotations.
Local Open Scope Z_scope.
Lemma output_bounds:forall f i x,In(i,x)(Outputs f)->0<=i<4.
Proof. intros f i x H;cbn[Outputs]in H;repeat destruct H as[EQ|H];try contradiction;inversion EQ;lia. Qed.
Lemma output_nodup:forall f,NoDup(map fst(Outputs f)).
Proof. intros;cbn[Outputs];repeat constructor;simpl;intuition discriminate. Qed.
Lemma writes_valid:forall xs m b base me,Writes m b base xs me->forall q,Mem.valid_block m q->Mem.valid_block me q.
Proof. induction xs as[|[i x]xs IH];intros m b base me WR q V;cbn[Writes]in WR;[subst me;exact V|].
 destruct WR as[m1[ST REST]];eapply IH;[exact REST|eapply Mem.store_valid_block_1;eauto]. Qed.
Lemma free_list_valid:forall rs m mf,Mem.free_list m rs=Some mf->forall q,Mem.valid_block m q->Mem.valid_block mf q.
Proof. induction rs as[|[[b lo]hi]rs IH];intros m mf FREE q V;cbn[Mem.free_list]in FREE.
 - inversion FREE;subst;exact V.
 - destruct(Mem.free m b lo hi)as[ma|]eqn:F;try discriminate;eapply IH;[exact FREE|eapply Mem.valid_block_free_1;eauto]. Qed.
Lemma branch_permissions:forall m bo po f me,Branch m bo po f me->forall q z k p,Mem.perm m q z k p->Mem.perm me q z k p.
Proof. intros m bo po f me BR;unfold Branch in BR;destruct(Reject f);[subst me;auto|eapply writes_permissions;exact BR]. Qed.
Lemma branch_valid:forall m bo po f me,Branch m bo po f me->forall q,Mem.valid_block m q->Mem.valid_block me q.
Proof. intros m bo po f me BR;unfold Branch in BR;destruct(Reject f);[subst me;auto|eapply writes_valid;exact BR]. Qed.
Lemma branch_writable:forall m bo po f me,Branch m bo po f me->WriteRegion m bo po 4->WriteRegion me bo po 4.
Proof. intros m bo po f me BR W;unfold Branch in BR;destruct(Reject f);[subst me;exact W|eapply writes_writable;eauto]. Qed.
Lemma branch_reads:forall m bo po f me bi pi,Branch m bo po f me->Reads m bi pi 4 f->bi<>bo->Reads me bi pi 4 f.
Proof. intros m bo po f me bi pi BR RD NE;unfold Branch in BR;destruct(Reject f);[subst me;exact RD|eapply writes_reads_other;eauto]. Qed.
Lemma branch_frame:forall m bo po f me,Branch m bo po f me->forall q z n,q<>bo\/z+n<=Ptrofs.unsigned po\/Ptrofs.unsigned po+16<=z->Mem.loadbytes me q z n=Mem.loadbytes m q z n.
Proof. intros m bo po f me BR q z n OUT;unfold Branch in BR;destruct(Reject f);[subst me;reflexivity|].
 eapply writes_frame;[exact BR|exact(output_bounds f)|exact OUT]. Qed.
Lemma branch_bytes:forall m bo po f me,Branch m bo po f me->Mem.loadbytes me bo(Ptrofs.unsigned po)16=if Reject f then Mem.loadbytes m bo(Ptrofs.unsigned po)16 else Some(Encoded f).
Proof. intros m bo po f me BR;unfold Branch in BR;destruct(Reject f);[subst me;reflexivity|].
 assert(L0:Mem.loadbytes me bo(Ptrofs.unsigned po)4=Some(encode_val Mfloat32(Vsingle(Output f 0)))).
 { replace(Ptrofs.unsigned po)with(Ptrofs.unsigned po+4*0)by lia;eapply writes_bytes;[exact BR|apply output_nodup|unfold Outputs;left;reflexivity]. }
 assert(L1:Mem.loadbytes me bo(Ptrofs.unsigned po+4)4=Some(encode_val Mfloat32(Vsingle(Output f 1)))).
 { replace(Ptrofs.unsigned po+4)with(Ptrofs.unsigned po+4*1)by lia;eapply writes_bytes;[exact BR|apply output_nodup|unfold Outputs;right;left;reflexivity]. }
 assert(L2:Mem.loadbytes me bo(Ptrofs.unsigned po+8)4=Some(encode_val Mfloat32(Vsingle(Output f 2)))).
 { replace(Ptrofs.unsigned po+8)with(Ptrofs.unsigned po+4*2)by lia;eapply writes_bytes;[exact BR|apply output_nodup|unfold Outputs;right;right;left;reflexivity]. }
 assert(L3:Mem.loadbytes me bo(Ptrofs.unsigned po+12)4=Some(encode_val Mfloat32(Vsingle(Output f 3)))).
 { replace(Ptrofs.unsigned po+12)with(Ptrofs.unsigned po+4*3)by lia;eapply writes_bytes;[exact BR|apply output_nodup|unfold Outputs;right;right;right;left;reflexivity]. }
 assert(L23:Mem.loadbytes me bo(Ptrofs.unsigned po+8)8=Some(encode_val Mfloat32(Vsingle(Output f 2))++encode_val Mfloat32(Vsingle(Output f 3)))).
 { replace 8 with(4+4)at 2 by lia;eapply Mem.loadbytes_concat;try exact L2;try lia;replace(Ptrofs.unsigned po+8+4)with(Ptrofs.unsigned po+12)by lia;exact L3. }
 assert(L123:Mem.loadbytes me bo(Ptrofs.unsigned po+4)12=Some(encode_val Mfloat32(Vsingle(Output f 1))++encode_val Mfloat32(Vsingle(Output f 2))++encode_val Mfloat32(Vsingle(Output f 3)))).
 { replace 12 with(4+8)by lia;eapply Mem.loadbytes_concat;try exact L1;try lia;replace(Ptrofs.unsigned po+4+4)with(Ptrofs.unsigned po+8)by lia;exact L23. }
 unfold Encoded;replace 16 with(4+12)by lia;eapply Mem.loadbytes_concat;eauto;lia.
Qed.
Print Assumptions branch_bytes.
Print Assumptions branch_frame.

Lemma branch_access:forall m bo po f me,Branch m bo po f me->forall ch q z p,Mem.valid_access m ch q z p->Mem.valid_access me ch q z p.
Proof. intros m bo po f me BR ch q z p[RP AL];split;auto;intros off B;eapply branch_permissions;[exact BR|apply RP;exact B]. Qed.
