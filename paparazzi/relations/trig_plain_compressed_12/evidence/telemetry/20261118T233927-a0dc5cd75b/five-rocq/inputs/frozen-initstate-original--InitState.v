From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Maps AST Integers Values Memory Ctypes Csyntax Csem.
From PprzTrigRelationSupport Require Import PackedPrefix.
Import ListNotations.
Open Scope Z_scope.
Definition short_cell(e:env)(m:mem)(id:ident)(z:Z):Prop := exists b,
 e!id=Some(b,Tint I16 Signed noattr) /\
 Mem.load Mint16signed m b 0=Some(Vint(Int.repr z)) /\
 Mem.range_perm m b 0 2 Cur Writable.
Lemma nonnegative_short_cast_certificate : forallb(fun n=>Int.eq(Int.sign_ext 16(Int.repr(Z.of_nat n)))(Int.repr(Z.of_nat n)))(seq 0 16384)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma nonnegative_short_cast : forall z,0<=z<=16383 ->Int.sign_ext 16(Int.repr z)=Int.repr z.
Proof.
 intros z Z. pose proof nonnegative_short_cast_certificate as H.
 apply forallb_forall with(x:=Z.to_nat z)in H.
 - rewrite Z2Nat.id in H by lia. apply Int.same_if_eq;exact H.
 - apply in_seq;split;[lia|]. cbn [Nat.add]. change(Z.to_nat z<Z.to_nat 16384)%nat.
   apply(proj1(Z2Nat.inj_lt z 16384 ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma short_store_exists : forall e m id old z,
 short_cell e m id old ->0<=z<=16383 ->
 exists b m',e!id=Some(b,Tint I16 Signed noattr) /\
 Mem.store Mint16signed m b 0(Vint(Int.repr z))=Some m' /\short_cell e m' id z.
Proof.
 intros e m id old z[b[B[L R]]]Z.
 destruct(Mem.valid_access_store m Mint16signed b 0(Vint(Int.repr z)))as[m' S].
 - split;[exact R|]. change(2|0);exists 0;lia.
 - exists b,m';split;[exact B|]. split;[exact S|]. exists b;split;[exact B|]. split.
   + pose proof(@Mem.load_store_same Mint16signed m b 0(Vint(Int.repr z))m' S)as E.
     cbn [Val.load_result]in E. rewrite nonnegative_short_cast in E by exact Z;exact E.
   + intros ofs I. eapply Mem.perm_store_1;[exact S|]. apply R;exact I.
Qed.
Lemma short_cell_store_other : forall e m m' id z chunk bw ofs v,
 short_cell e m id z ->Mem.store chunk m bw ofs v=Some m' ->
 (forall b,e!id=Some(b,Tint I16 Signed noattr)->b<>bw) ->short_cell e m' id z.
Proof.
 intros e m m' id z ch bw ofs v[b[B[L R]]]S NE.
 exists b;split;[exact B|]. split.
 - erewrite Mem.load_store_other;[exact L|exact S|]. left;apply NE;exact B.
 - intros i I. eapply Mem.perm_store_1;[exact S|]. apply R;exact I.
Qed.
Lemma packed_prefix_local_store : forall cnt m m' bb ch bl ofs v,
 packed_prefix cnt m bb ->bl<>bb ->Mem.store ch m bl ofs v=Some m' ->packed_prefix cnt m' bb.
Proof.
 intros cnt m m' bb ch bl ofs v[R V]NE S;split.
 - intros i I. eapply Mem.perm_store_1;[exact S|]. apply R;exact I.
 - intros i I. erewrite Mem.load_store_other;[apply V;exact I|exact S|]. left;congruence.
Qed.
