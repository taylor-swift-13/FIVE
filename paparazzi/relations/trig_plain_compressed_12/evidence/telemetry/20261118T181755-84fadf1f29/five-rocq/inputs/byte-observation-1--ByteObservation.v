From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers AST Values Memory Memdata.
Import ListNotations.
Local Open Scope Z_scope.

Lemma loadbytes_subrange : forall m b base n bytes ofs len,
  Mem.loadbytes m b base n = Some bytes ->
  0 <= ofs -> 0 <= len -> ofs + len <= n ->
  Mem.loadbytes m b (base + ofs) len =
    Some (firstn (Z.to_nat len) (skipn (Z.to_nat ofs) bytes)).
Proof.
  intros m b base n bytes ofs len LOAD OFS LEN BOUND.
  replace n with (ofs + (n-ofs)) in LOAD by lia.
  destruct (Mem.loadbytes_split m b base ofs (n-ofs) bytes LOAD
    ltac:(lia) ltac:(lia)) as [prefix [rest [PRE [REST EQ]]]].
  pose proof (Mem.loadbytes_length _ _ _ _ _ PRE) as LP.
  assert (SKIP: skipn (Z.to_nat ofs) bytes = rest).
  { rewrite EQ, <- LP, skipn_app, skipn_all, Nat.sub_diag; simpl; reflexivity. }
  replace (n-ofs) with (len + (n-ofs-len)) in REST by lia.
  destruct (Mem.loadbytes_split m b (base+ofs) len (n-ofs-len) rest
    REST ltac:(lia) ltac:(lia)) as [part [tail [PART [_ EQ2]]]].
  pose proof (Mem.loadbytes_length _ _ _ _ _ PART) as LL.
  rewrite SKIP, EQ2, <- LL, firstn_app, firstn_all, Nat.sub_diag.
  simpl; rewrite app_nil_r; exact PART.
Qed.

Lemma firstn_one_skipn_nth : forall (A:Type) (xs:list A) n d,
  (n < length xs)%nat -> firstn 1 (skipn n xs) = [nth n xs d].
Proof.
  intros A xs; induction xs as [|x xs IH]; intros [|n] d H;
    simpl in *; try lia; auto.
  apply IH; lia.
Qed.

Lemma loadbytes_one : forall m b base bytes ofs,
  Mem.loadbytes m b base (Z.of_nat (length bytes)) = Some bytes ->
  0 <= ofs < Z.of_nat (length bytes) ->
  Mem.loadbytes m b (base+ofs) 1 =
    Some [nth (Z.to_nat ofs) bytes Undef].
Proof.
  intros m b base bytes ofs LOAD RANGE.
  pose proof (loadbytes_subrange m b base (Z.of_nat (length bytes)) bytes
    ofs 1 LOAD ltac:(lia) ltac:(lia) ltac:(lia)) as SUB.
  cbn [Z.to_nat] in SUB.
  rewrite firstn_one_skipn_nth with (d:=Undef) in SUB.
  - exact SUB.
  - apply Nat2Z.inj_lt; rewrite Z2Nat.id by lia; lia.
Qed.

Lemma byte_unsigned_range : forall x:byte, 0 <= Byte.unsigned x < 256.
Proof. intro x; exact (Byte.unsigned_range x). Qed.

Lemma whole_bytes_load_unsigned : forall m b base (bytes:list byte) ofs,
  Mem.loadbytes m b base (Z.of_nat (length bytes)) =
    Some (map Byte bytes) ->
  0 <= ofs < Z.of_nat (length bytes) ->
  Mem.load Mint8unsigned m b (base+ofs) =
    Some (Vint (Int.repr (Byte.unsigned (nth (Z.to_nat ofs) bytes Byte.zero)))).
Proof.
  intros m b base bytes ofs LOAD RANGE.
  assert (LENGTH: length (map Byte bytes) = length bytes) by apply map_length.
  pose proof (loadbytes_one m b base (map Byte bytes) ofs
    ltac:(rewrite LENGTH; exact LOAD) ltac:(rewrite LENGTH; exact RANGE)) as ONE.
  assert (NTH: nth (Z.to_nat ofs) (map Byte bytes) Undef =
    Byte (nth (Z.to_nat ofs) bytes Byte.zero)).
  { rewrite nth_indep with (d':=Byte Byte.zero).
    - rewrite map_nth; reflexivity.
    - rewrite LENGTH; apply Nat2Z.inj_lt; rewrite Z2Nat.id by lia; lia. }
  rewrite NTH in ONE.
  pose proof (Mem.loadbytes_load Mint8unsigned m b (base+ofs)
    [Byte (nth (Z.to_nat ofs) bytes Byte.zero)] ONE ltac:(exists (base+ofs); lia)) as L.
  cbn [decode_val proj_bytes proj_bytes_aux decode_int] in L.
  exact L.
Qed.
