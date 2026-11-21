From Stdlib Require Import List String ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract MatrixMemory Scalar Call Memcpy36 Observer TraceInputs.
From FiveMatrixInverseSupport Require Import Kernels Witness.
Require FiveMatInv3NoError.Spec FiveMatInv3NoError.Proof FiveMatInv3Functional.Spec FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Lemma valid_cell_live:forall m ch b z p,Mem.valid_access m ch b z p->size_chunk ch=4->perm_order p Nonempty->
 Mem.valid_pointer m b z=true /\Mem.weak_valid_pointer m b(z+4)=true.
Proof. intros m ch b z p[RP AL]SZ PO;split.
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply RP;rewrite SZ;lia|exact PO].
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply RP;rewrite SZ;lia|exact PO]. Qed.
Definition SourceGuards:Prop:=FiveMatInv3NoError.Spec.NoError /\
 forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 Mem.valid_block m bo /\Mem.valid_block m bi /\
 forall r c,0<=r<3->0<=c<3->0<=3*r+c<9 /\
 Mem.valid_access m Mfloat32 bi(Ptrofs.unsigned pi+4*(3*r+c))Readable /\
 Mem.valid_access m Mfloat32 bo(Ptrofs.unsigned po+4*(3*r+c))Writable /\
 Mem.valid_pointer m bi(Ptrofs.unsigned pi+4*(3*r+c))=true /\
 Mem.weak_valid_pointer m bi(Ptrofs.unsigned pi+4*(3*r+c)+4)=true /\
 Mem.valid_pointer m bo(Ptrofs.unsigned po+4*(3*r+c))=true /\
 Mem.weak_valid_pointer m bo(Ptrofs.unsigned po+4*(3*r+c)+4)=true.
Theorem source_guards:SourceGuards.
Proof. split;[exact FiveMatInv3NoError.Proof.no_error_proved|].
 intros m bo bi po pi f NE W R;split;[exact(writable_valid m bo po 9 ltac:(lia)W)|];split;[exact(reads_valid m bi pi 9 f ltac:(lia)R)|].
 intros r c RR CC;assert(B:0<=3*r+c<9)by lia.
 pose proof(Mem.load_valid_access _ _ _ _ _(proj2(proj2 R)(3*r+c)B))as RI.
 pose proof(writable_access m bo po 9(3*r+c)W B)as WO.
 destruct(valid_cell_live _ _ _ _ _ RI eq_refl ltac:(constructor))as[RL RE].
 destruct(valid_cell_live _ _ _ _ _ WO eq_refl ltac:(constructor))as[WL WE].
 split;[exact B|];split;[exact RI|];split;[exact WO|];auto.
Qed.
Inductive CopyKind:=SameForward|SourceLive|DestinationEndLive|SameReverse|DestinationLive|SourceEndLive|NoOverlap|ReadableSource|WritableDestination.
Definition CopyGuard(m:mem)(src dst:block)(kind:CopyKind):Prop:=forall(order1 order2:Prop),match kind with
 |SameForward=>(True /\~(dst<>src))->False
 |SourceLive=>(True /\~(dst<>src))->Mem.valid_pointer m src 0=true
 |DestinationEndLive=>(True /\~(dst<>src))->Mem.weak_valid_pointer m dst 36=true
 |SameReverse=>~(dst<>src \/order1)->False
 |DestinationLive=>~(dst<>src \/order1)->Mem.valid_pointer m dst 0=true
 |SourceEndLive=>~(dst<>src \/order1)->Mem.weak_valid_pointer m src 36=true
 |NoOverlap=>(dst<>src \/order1)\/order2
 |ReadableSource=>Mem.range_perm m src 0 36 Cur Readable
 |WritableDestination=>Mem.range_perm m dst 0 36 Cur Writable end.
Lemma copy_safety_guard:forall m src dst kind,MemcpySafety m src dst->CopyGuard m src dst kind.
Proof. intros m src dst kind S a b;destruct S;destruct kind;cbn;tauto. Qed.
Definition CopyClaim(kind:CopyKind):Prop:=forall se m src dst,CopyPre m src dst->
 exists mf bytes,MemcpySafety m src dst /\Mem.loadbytes m src 0 36=Some bytes /\
 Mem.storebytes m dst 0 bytes=Some mf /\extcall_memcpy_sem 36 1 se[Vptr dst Ptrofs.zero;Vptr src Ptrofs.zero]m E0 Vundef mf /\
 Mem.loadbytes mf dst 0 36=Some bytes /\CopyFrame m mf dst /\CopyGuard m src dst kind.
Theorem copy_claim:forall kind,CopyClaim kind.
Proof. intros kind se m src dst P;destruct(copy36_exact se m src dst P)as[mf[bytes[S[R[L[ST[CALL[BYTES FR]]]]]]]].
 exists mf,bytes;split;[exact S|];split;[exact R|];split;[exact ST|];split;[exact CALL|];split;[exact BYTES|];split;[exact FR|];apply copy_safety_guard;exact S. Qed.
Definition FixedOutcome(f:Z->float32)(status:val):Prop:=
 (forall m bo bi po pi,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->
 exists mf,(exists t,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate status Kstop mf))/\FiveMatInv3Functional.Spec.Post m mf bo bi po pi f) /\
 (forall m bo bi po pi,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate v Kstop mf)->v=status /\FiveMatInv3Functional.Spec.Post m mf bo bi po pi f).
Lemma fixed_outcome:forall f status,Status f=status->FixedOutcome f status.
Proof. intros f status EQ;split.
 - intros m bo bi po pi NE W RD;rewrite <-EQ;apply FiveMatInv3Functional.Proof.normal_call;assumption.
 - intros m bo bi po pi NE W RD t v mf PATH;rewrite <-EQ;eapply FiveMatInv3Functional.Proof.all_normal_observations;eauto. Qed.
Definition InitPairs(old:Z->float32):list(Z*float32):=[(0,old 0);(1,old 1);(2,old 2);(3,old 3);(4,old 4);(5,old 5);(6,old 6);(7,old 7);(8,old 8)].
Definition Initialized(m:mem)(bo bi:block)(f old:Z->float32):Prop:=bo<>bi /\WriteRegion m bo Ptrofs.zero 9 /\Reads m bi Ptrofs.zero 9 f /\
 forall i,0<=i<9->Mem.loadbytes m bo(4*i)4=Some(encode_val Mfloat32(Vsingle(old i))).
Lemma initialized_exists:forall f old,exists m bo bi,Initialized m bo bi f old.
Proof.
 intros f old;destruct(matrix9_inhabited f)as[mi[bo[bi[NE[WO RI]]]]].
 destruct(writes_exist(InitPairs old)mi bo Ptrofs.zero 9 WO)as[m WR].
 { intros i x IN;unfold InitPairs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia. }
 exists m,bo,bi;split;[exact NE|];split;[eapply writes_writable;[exact WR|exact WO]|];split.
 - eapply writes_reads_other;[exact WR|exact RI|congruence].
 - intros i I;replace(4*i)with(Ptrofs.unsigned Ptrofs.zero+4*i)by(rewrite Ptrofs.unsigned_zero;lia);eapply writes_bytes;[exact WR|unfold InitPairs;repeat constructor;simpl;intuition discriminate|].
   assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;repeat destruct H as[H|H];subst i;unfold InitPairs;repeat(first[left;reflexivity|right]).
Qed.
Definition CallReplay(f old:Z->float32)(status:val):Prop:=exists m bo bi mf t,
 Initialized m bo bi f old /\star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero Ptrofs.zero)m)t(Returnstate status Kstop mf) /\
 FiveMatInv3Functional.Spec.Post m mf bo bi Ptrofs.zero Ptrofs.zero f.
Theorem call_replay:forall f old status,Status f=status->CallReplay f old status.
Proof. intros f old status EQ;destruct(initialized_exists f old)as[m[bo[bi[NE[W[R CELLS]]]]]].
 destruct(FiveMatInv3Functional.Proof.normal_call m bo bi Ptrofs.zero Ptrofs.zero f NE W R)as[mf[[t PATH]POST]].
 exists m,bo,bi,mf,t;split;[split;[exact NE|];split;[exact W|];split;[exact R|exact CELLS]|];split;[rewrite <-EQ;exact PATH|exact POST]. Qed.
Definition OldFixed(i:Z):float32:=Diag3(Float32.of_bits(Int.repr 1099431936))i.
Definition OldArbitrary(_:Z):float32:=Float32.zero.
Theorem original_calls_replay:
 CallReplay arbitrary_0 OldArbitrary(Vint Int.one) /\CallReplay arbitrary_1 OldArbitrary(Vint Int.one) /\
 CallReplay base3 OldFixed(Vint Int.zero) /\CallReplay small3 OldFixed(Vint Int.one) /\CallReplay large3 OldFixed(Vint Int.zero).
Proof. repeat split;apply call_replay.
 - unfold Status;rewrite arbitrary_rejects_0;reflexivity.
 - unfold Status;rewrite arbitrary_rejects_1;reflexivity.
 - exact(proj1 base3_kernel).
 - exact(proj1 small3_kernel).
 - exact(proj1 large3_kernel).
Qed.
Print Assumptions source_guards.
Print Assumptions copy_claim.
Print Assumptions original_calls_replay.
