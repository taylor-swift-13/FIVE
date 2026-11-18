From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Events Globalenvs Ctypes Csem.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Local Open Scope Z_scope.
Record VectorAccessGuards(m:mem)(b:block)(ofs:Z):Prop:={
 vector_nonnull:Vptr b(Ptrofs.repr ofs)<>Vnullptr;
 vector_typed_writable:Mem.valid_access m Mfloat32 b ofs Writable;
 vector_live:Mem.valid_pointer m b ofs=true;
 vector_current:Mem.perm m b ofs Cur Nonempty;
 vector_bounds:0<=ofs /\ofs+4<=8 /\Mem.range_perm m b ofs(ofs+4)Cur Readable;
 vector_block_address:(forall i,Vptr b(Ptrofs.repr ofs)<>Vint i)/\(forall i,Vptr b(Ptrofs.repr ofs)<>Vlong i)
}.
Lemma vector_access_guards:forall m b ofs,
 Mem.range_perm m b 0 8 Cur Writable ->(ofs=0\/ofs=4)->VectorAccessGuards m b ofs.
Proof.
 intros m b ofs W OFF.
 assert(R:0<=ofs /\ofs+4<=8)by(destruct OFF;subst;lia).
 assert(P:Mem.perm m b ofs Cur Nonempty).
 { eapply Mem.perm_implies;[apply W;lia|constructor]. }
 constructor.
 - change(Vptr b(Ptrofs.repr ofs)<>Vlong Int64.zero);discriminate.
 - split;[intros i I;cbn in I;apply W;lia|]. destruct OFF as[E|E];subst ofs;[exists 0|exists 1];reflexivity.
 - apply Mem.valid_pointer_nonempty_perm;exact P.
 - exact P.
 - split;[lia|]. split;[lia|]. intros i I;eapply Mem.perm_implies;[apply W;lia|constructor].
 - split;intros;discriminate.
Qed.
Definition sat_offset(n:nat):Z:=
 if (Nat.leb 7 n&&Nat.leb n 12||Nat.leb 19 n&&Nat.leb n 24)%bool then 4 else 0.
Definition saturation_pointer_guard_id(n:nat):Prop:=
 (1<=n<=24)%nat /\forall m b,Mem.range_perm m b 0 8 Cur Writable->VectorAccessGuards m b(sat_offset n).
Theorem saturation_pointer_guards:forall n,(1<=n<=24)%nat->saturation_pointer_guard_id n.
Proof.
 intros n B;split;[exact B|]. intros m b W;apply vector_access_guards;[exact W|].
 unfold sat_offset;destruct(Nat.leb 7 n&&Nat.leb n 12||Nat.leb 19 n&&Nat.leb n 24)%bool;auto.
Qed.
Lemma actual_vector_object:forall m,exists ma b,
 Mem.alloc m 0 8=(ma,b) /\Mem.range_perm ma b 0 8 Cur Freeable /\
 VectorAccessGuards ma b 0 /\VectorAccessGuards ma b 4.
Proof.
 intros m;destruct(Mem.alloc m 0 8)as[ma b]eqn:A;exists ma,b;split;[reflexivity|].
 assert(P:Mem.range_perm ma b 0 8 Cur Freeable).
 { intros ofs R;eapply Mem.perm_alloc_2;[exact A|exact R]. }
 split;[exact P|]. assert(W:Mem.range_perm ma b 0 8 Cur Writable)by(eapply Mem.range_perm_implies;[exact P|constructor]).
 split;apply vector_access_guards;auto.
Qed.
Definition BitsUtilityTotal:Prop:=forall ge x m,exists mf,BitsRun ge x m mf(Float32.to_bits x).
Definition memcpy_guard_id(n:nat):Prop:=match n with
 |1%nat|2%nat|3%nat|4%nat|5%nat|6%nat=>BitsUtilityTotal
 |7%nat=>0<=4<=Int64.max_signed
 |8%nat=>0<=Int64.signed(Int64.repr 4)<=Int64.max_unsigned
 |_=>False end.
Theorem memcpy_guards:forall n,(1<=n<=8)%nat->memcpy_guard_id n.
Proof.
 intros n B;assert(C:n=1%nat\/n=2%nat\/n=3%nat\/n=4%nat\/n=5%nat\/n=6%nat\/n=7%nat\/n=8%nat)by lia.
 repeat destruct C as[E|C];try(rename C into E);subst n;cbn[memcpy_guard_id];
 try exact bits_run_exists;vm_compute;intuition discriminate.
Qed.
Definition bits_guard_id(n:nat):Prop:=match n with
 |1%nat|2%nat|3%nat=>BitsUtilityTotal|_=>False end.
Theorem bits_guards:forall n,(1<=n<=3)%nat->bits_guard_id n.
Proof. intros n B;destruct n as[|[|[|[|n]]]];try lia;exact bits_run_exists. Qed.
Print Assumptions saturation_pointer_guards.
Print Assumptions memcpy_guards.
Print Assumptions bits_guards.
