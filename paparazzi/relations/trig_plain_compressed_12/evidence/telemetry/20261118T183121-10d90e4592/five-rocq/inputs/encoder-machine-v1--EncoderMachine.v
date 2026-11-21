From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib AST Integers.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix.
Open Scope Z_scope.
Definition encoder_high_index(a:Int.int):Int.int :=Int.add(Int.repr 6434)(Int.divs a(Int.repr 2)).
Definition encoder_offset(a:Int.int):ptrofs :=Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr 1)(Ptrofs.of_ints a)).
Definition encoder_even_choice(a:Int.int):bool :=Int.cmp Ceq(Int.mods a(Int.repr 2))Int.zero.
Definition encoder_low_machine(v:Int.int):Int.int :=Int.zero_ext 8(Int.mods v(Int.repr 256)).
Definition encoder_high_machine(a v old:Int.int):Int.int :=Int.zero_ext 8
 (if encoder_even_choice a then Int.shr(Int.and v(Int.repr 3840))(Int.repr 8)
 else Int.or old(Int.shr(Int.and v(Int.repr 3840))(Int.repr 4))).
Definition encoder_machine_ok(cnt:Z):bool :=
 Z.eqb(Ptrofs.unsigned(encoder_offset(Int.repr cnt)))cnt &&
 Z.eqb(Ptrofs.unsigned(encoder_offset(encoder_high_index(Int.repr cnt))))(high_address cnt) &&
 Bool.eqb(encoder_even_choice(Int.repr cnt))(Z.eqb(cnt mod 2)0) &&
 Int.eq(encoder_low_machine(Int.repr(table_at cnt)))(Int.repr(low_written cnt)) &&
 Int.eq(encoder_high_machine(Int.repr cnt)(Int.repr(table_at cnt))(Int.repr(buffer_view cnt(high_address cnt))))(Int.repr(high_written cnt)).
Lemma literal_encoder_machine_certificate : forallb(fun n=>encoder_machine_ok(Z.of_nat n))(seq 0 6434)=true.
Proof. vm_compute;reflexivity. Qed.
Lemma literal_encoder_machine : forall cnt,0<=cnt<6434 ->
 Ptrofs.unsigned(encoder_offset(Int.repr cnt))=cnt /\
 Ptrofs.unsigned(encoder_offset(encoder_high_index(Int.repr cnt)))=high_address cnt /\
 encoder_even_choice(Int.repr cnt)=Z.eqb(cnt mod 2)0 /\
 encoder_low_machine(Int.repr(table_at cnt))=Int.repr(low_written cnt) /\
 encoder_high_machine(Int.repr cnt)(Int.repr(table_at cnt))(Int.repr(buffer_view cnt(high_address cnt)))=Int.repr(high_written cnt).
Proof.
 intros cnt C. pose proof literal_encoder_machine_certificate as H.
 apply forallb_forall with(x:=Z.to_nat cnt)in H.
 - rewrite Z2Nat.id in H by lia. unfold encoder_machine_ok in H.
   repeat rewrite andb_true_iff in H. destruct H as[[[[A B]D]E]F].
   apply Z.eqb_eq in A;apply Z.eqb_eq in B;apply Bool.eqb_true_iff in D;
   apply Int.same_if_eq in E;apply Int.same_if_eq in F;auto.
 - apply in_seq;split;[lia|]. cbn [Nat.add]. change(Z.to_nat cnt<Z.to_nat 6434)%nat.
   apply(proj1(Z2Nat.inj_lt cnt 6434 ltac:(lia)ltac:(lia)));lia.
Qed.
