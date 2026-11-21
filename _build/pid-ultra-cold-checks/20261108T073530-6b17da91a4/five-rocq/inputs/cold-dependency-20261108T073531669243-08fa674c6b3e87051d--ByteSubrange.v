From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
Import ListNotations.
Open Scope Z_scope.
Lemma unit_loadbytes_singleton : forall m b ofs bytes,
 Mem.loadbytes m b ofs 1=Some bytes ->exists v,bytes=[v].
Proof.
 intros m b ofs bytes LOAD;pose proof(Mem.loadbytes_length _ _ _ _ _ LOAD)as LEN.
 change(length bytes=1%nat)in LEN.
 destruct bytes as[|v tail];[discriminate|].
 destruct tail as[|v' tail];[exists v;reflexivity|discriminate].
Qed.
Lemma equal_loadbytes_all_units : forall(n:nat)a b blk base bytes,
 Mem.loadbytes a blk base(Z.of_nat n)=Some bytes ->
 Mem.loadbytes b blk base(Z.of_nat n)=Some bytes ->
 forall ofs,base<=ofs<base+Z.of_nat n ->
 Mem.loadbytes a blk ofs 1=Mem.loadbytes b blk ofs 1.
Proof.
 induction n as[|n IH];intros a b blk base bytes LA LB ofs RANGE.
 - cbn in RANGE;lia.
 - replace(Z.of_nat(S n))with(1+Z.of_nat n)in LA,LB by lia.
   destruct(Mem.loadbytes_split a blk base 1(Z.of_nat n)bytes LA ltac:(lia)ltac:(lia))
   as[ah[atail[AH[AT AE]]]].
   destruct(Mem.loadbytes_split b blk base 1(Z.of_nat n)bytes LB ltac:(lia)ltac:(lia))
   as[bh[btail[BH[BT BE]]]].
   destruct(unit_loadbytes_singleton _ _ _ _ AH)as[av AV].
   destruct(unit_loadbytes_singleton _ _ _ _ BH)as[bv BV].
   rewrite AV in AH,AE;rewrite BV in BH,BE.
   rewrite AE in BE;cbn in BE;injection BE as EV ET;subst bv btail.
   destruct(Z.eq_dec ofs base)as[EQ|NE].
   + subst ofs;rewrite AH,BH;reflexivity.
   + eapply IH;[exact AT|exact BT|lia].
Qed.
Lemma equal_int32_words_all_units : forall a b blk base bytes,
 Mem.loadbytes a blk base 4=Some bytes ->
 Mem.loadbytes b blk base 4=Some bytes ->
 forall ofs,base<=ofs<base+4 ->
 Mem.loadbytes a blk ofs 1=Mem.loadbytes b blk ofs 1.
Proof.
 intros a b blk base bytes LA LB ofs RANGE.
 exact(equal_loadbytes_all_units 4 a b blk base bytes LA LB ofs RANGE).
Qed.
Print Assumptions equal_int32_words_all_units.
