From Stdlib Require Import List.
From compcert Require Import Integers Values Memory Events.
From FiveShared.compcert_libc Require Import Library.
From FiveShared.safety Require Import MemorySafety.
Import ListNotations.

Lemma copy_pre_preserved : forall m m' bd od bs os n,
 (forall b ofs k p,Mem.perm m' b ofs k p <-> Mem.perm m b ofs k p) ->
 copy_pre m bd od bs os n -> copy_pre m' bd od bs os n.
Proof.
 intros m m' bd od bs os n KEEP [D[R W]]. split;[exact D|]. split;
 unfold Mem.range_perm in *;intros ofs IN;apply KEEP;auto.
Qed.

Theorem byte_copy_call_has_successor : forall m bd od bs os n,
 copy_pre m bd od bs os n -> exists m',
 memcpy_sem[Vptr bd od;Vptr bs os;Vlong n]m E0(Vptr bd od)m'.
Proof.
 intros;destruct(memcpy_total _ _ _ _ _ _ H)as[bytes[m'[CALL REST]]];eauto.
Qed.

(* Three concrete libc calls used by a swap, for arbitrary bytes. *)
Theorem three_copy_calls_total : forall m tmp ot left ol right oright n,
 copy_pre m tmp ot left ol n ->
 copy_pre m left ol right oright n ->
 copy_pre m right oright tmp ot n ->
 exists m1 m2 m3,
 memcpy_sem[Vptr tmp ot;Vptr left ol;Vlong n]m E0(Vptr tmp ot)m1 /\
 memcpy_sem[Vptr left ol;Vptr right oright;Vlong n]m1 E0(Vptr left ol)m2 /\
 memcpy_sem[Vptr right oright;Vptr tmp ot;Vlong n]m2 E0(Vptr right oright)m3.
Proof.
 intros m tmp ot left ol right oright n A B C.
 destruct(memcpy_total _ _ _ _ _ _ A)as[x[m1[C1[L1[L2 K1]]]]].
 assert(B1:copy_pre m1 left ol right oright n)by(eapply copy_pre_preserved;eauto).
 destruct(memcpy_total _ _ _ _ _ _ B1)as[y[m2[C2[L3[L4 K2]]]]].
 assert(C2':copy_pre m2 right oright tmp ot n).
 { eapply copy_pre_preserved;[exact K2|];eapply copy_pre_preserved;eauto. }
 destruct(memcpy_total _ _ _ _ _ _ C2')as[z[m3[C3 REST]]].
 exists m1,m2,m3;auto.
Qed.
Print Assumptions byte_copy_call_has_successor.
Print Assumptions three_copy_calls_total.
