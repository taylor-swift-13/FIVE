From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import AST Archi Integers Values Memory Memdata.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix.
Import ListNotations.
Open Scope Z_scope.
Lemma decode_single_byte : forall b,
 decode_val Mint8unsigned[Byte b]=Vint(Int.repr(Byte.unsigned b)).
Proof.
 intro b. cbn [decode_val proj_bytes].
 replace(decode_int[b])with(Byte.unsigned b)by(cbn [decode_int rev_if_be Archi.big_endian int_of_bytes];lia).
 rewrite byte_extension;[reflexivity|exact(Byte.unsigned_range b)].
Qed.
Lemma load_unsigned_byte_exact : forall m b ofs z,
 0<=z<256 ->Mem.load Mint8unsigned m b ofs=Some(Vint(Int.repr z)) ->
 Mem.loadbytes m b ofs 1=Some[Byte(Byte.repr z)].
Proof.
 intros m b ofs z R LOAD.
 destruct(Mem.load_loadbytes Mint8unsigned m b ofs(Vint(Int.repr z))LOAD)as[bs[LB EQ]].
 pose proof(Mem.loadbytes_length _ _ _ _ _ LB)as LEN.
 change(length bs=1%nat)in LEN. destruct bs as[|v[|w tail]];cbn in LEN;try lia.
 destruct v as[|c|v q n];try(cbn [decode_val proj_bytes]in EQ;discriminate).
 rewrite decode_single_byte in EQ. injection EQ as E.
 change(Int.unsigned(Int.repr z)=Int.unsigned(Int.repr(Byte.unsigned c)))in E.
 assert(CR:0<=Byte.unsigned c<256)by apply Byte.unsigned_range.
 rewrite(Int.unsigned_repr z)in E by(change(0<=z<=4294967295);lia).
 rewrite(Int.unsigned_repr(Byte.unsigned c))in E by(change(0<=Byte.unsigned c<=4294967295);lia).
 subst z. rewrite Byte.repr_unsigned. exact LB.
Qed.
Lemma loads_to_loadbytes : forall xs m b base,
 Forall(fun z=>0<=z<256)xs ->
 (forall n,(n<length xs)%nat ->Mem.load Mint8unsigned m b(base+Z.of_nat n)=Some(Vint(Int.repr(nth n xs 0)))) ->
 Mem.loadbytes m b base(Z.of_nat(length xs))=Some(map(fun z=>Byte(Byte.repr z))xs).
Proof.
 induction xs as[|x xs IH];intros m b base R READ.
 - cbn. apply Mem.loadbytes_empty;lia.
 - inversion R as[|? ? RX RS];subst.
   assert(L1:Mem.loadbytes m b base 1=Some[Byte(Byte.repr x)]).
   { apply load_unsigned_byte_exact;[exact RX|]. pose proof(READ 0%nat ltac:(cbn;lia))as A. cbn in A. replace(base+0)with base in A by lia;exact A. }
   assert(L2:Mem.loadbytes m b(base+1)(Z.of_nat(length xs))=Some(map(fun z=>Byte(Byte.repr z))xs)).
   { apply IH;[exact RS|]. intros n N. pose proof(READ(S n)ltac:(cbn;lia))as A. cbn [nth]in A.
     rewrite Nat2Z.inj_succ in A. replace(base+Z.succ(Z.of_nat n))with((base+1)+Z.of_nat n)in A by lia;exact A. }
   pose proof(Mem.loadbytes_concat m b base 1(Z.of_nat(length xs))[Byte(Byte.repr x)](map(fun z=>Byte(Byte.repr z))xs)L1 L2 ltac:(lia)ltac:(lia))as C.
   cbn [length map]. rewrite Nat2Z.inj_succ. replace(Z.succ(Z.of_nat(length xs)))with(1+Z.of_nat(length xs))by lia. exact C.
Qed.
Lemma completed_prefix_bytes : forall m b,byte_view 6434 m b ->
 Mem.loadbytes m b 0 9651=Some(map(fun z=>Byte(Byte.repr z))expected_bytes).
Proof.
 intros m b V. replace 9651 with(Z.of_nat(length expected_bytes))by(rewrite expected_bytes_length;reflexivity).
 apply loads_to_loadbytes.
 - apply Forall_forall;intros z IN. pose proof expected_bytes_bounded as B. apply forallb_forall with(x:=z)in B;auto.
   apply andb_true_iff in B as[L U]. apply Z.leb_le in L;apply Z.leb_le in U;lia.
 - intros n N. assert(I:0<=Z.of_nat n<9651)by(rewrite expected_bytes_length in N;lia).
   pose proof(V(Z.of_nat n)I)as H. rewrite buffer_view_complete in H by exact I.
   rewrite Nat2Z.id in H. cbn [Z.add]. exact H.
Qed.
