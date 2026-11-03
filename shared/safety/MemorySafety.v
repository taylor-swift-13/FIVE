From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats Values AST Memory Memdata Events.
From FiveShared.compcert_libc Require Import Library.
Import ListNotations.
Local Open Scope Z_scope.

Definition copy_pre(m:mem)(bd:block)(od:ptrofs)(bs:block)(os:ptrofs)(n:int64):Prop :=
 disjoint bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os)(Int64.unsigned n) /\
 Mem.range_perm m bs(Ptrofs.unsigned os)(Ptrofs.unsigned os+Int64.unsigned n) Cur Readable /\
 Mem.range_perm m bd(Ptrofs.unsigned od)(Ptrofs.unsigned od+Int64.unsigned n) Cur Writable.

Theorem memcpy_total : forall m bd od bs os n,
 copy_pre m bd od bs os n -> exists bytes m',
 memcpy_sem[Vptr bd od;Vptr bs os;Vlong n]m E0(Vptr bd od)m' /\
 Mem.loadbytes m bs(Ptrofs.unsigned os)(Int64.unsigned n)=Some bytes /\
 Mem.loadbytes m' bd(Ptrofs.unsigned od)(Int64.unsigned n)=Some bytes /\
 (forall b ofs k p,Mem.perm m' b ofs k p <-> Mem.perm m b ofs k p).
Proof.
 intros m bd od bs os n [DIS[READ WRITE]].
 destruct(Mem.range_perm_loadbytes _ _ _ _ READ)as[bytes LOAD].
 pose proof(Mem.loadbytes_length _ _ _ _ _ LOAD)as LEN.
 assert(SIZE:Z.of_nat(length bytes)=Int64.unsigned n).
 { rewrite LEN,Z2Nat.id;[reflexivity|apply Int64.unsigned_range_2]. }
 destruct(Mem.range_perm_storebytes m bd(Ptrofs.unsigned od)bytes)
  as[m' STORE];[rewrite SIZE;exact WRITE|].
 exists bytes,m';split;[eapply memcpy_intro with(bytes:=bytes);eauto|]. split;[exact LOAD|]. split.
 - rewrite <-SIZE. eapply Mem.loadbytes_storebytes_same;exact STORE.
 - intros;split;[eapply Mem.perm_storebytes_2|eapply Mem.perm_storebytes_1];eauto.
Qed.

(* Array shape is a caller memory condition, independent of reachability/error. *)
Definition float_array(m:mem)(b:block)(base n:Z):Prop :=
 0<=n /\ forall i,0<=i<n ->
  Mem.valid_access m Mfloat32 b(base+4*i) Writable /\
  exists f,Mem.load Mfloat32 m b(base+4*i)=Some(Vsingle f).

Theorem array_element_read_write : forall m b base n i,
 float_array m b base n -> 0<=i<n ->
 (exists f,Mem.load Mfloat32 m b(base+4*i)=Some(Vsingle f)) /\
 (forall f,exists m',Mem.store Mfloat32 m b(base+4*i)(Vsingle f)=Some m').
Proof.
 intros m b base n i [N ELEMS] I;destruct(ELEMS i I)as[W R].
 split;[exact R|]. intros f;destruct(Mem.valid_access_store m Mfloat32 b(base+4*i)(Vsingle f)W)as[mx STORE];eauto.
Qed.

Theorem float_store_preserves_array : forall m b base n i f m',
 float_array m b base n -> 0<=i<n ->
 Mem.store Mfloat32 m b(base+4*i)(Vsingle f)=Some m' ->
 float_array m' b base n.
Proof.
 intros m b base n i f m' [N ELEMS] I STORE;split;[exact N|].
 intros j J;destruct(ELEMS j J)as[W R];split.
 - eapply Mem.store_valid_access_1;eauto.
 - destruct(Z.eq_dec i j)as[EQ|NE].
   + subst j;exists f;erewrite Mem.load_store_same by exact STORE;reflexivity.
   + destruct R as[g LOAD];exists g.
     erewrite Mem.load_store_other;[exact LOAD|exact STORE|].
     right;change(base+4*j+4<=base+4*i \/ base+4*i+4<=base+4*j);lia.
Qed.
Print Assumptions memcpy_total.
Print Assumptions float_store_preserves_array.
