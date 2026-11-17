From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
From PidPositionTranslationCore Require Import CoreMemory PreciseFrame.
From PidPositionTranslationAttempt002 Require Import ClampSemantics FrontTrace ControllerBytes.
Import ListNotations.
Open Scope Z_scope.
Theorem front_updates_word_bytes : forall m mf pb vb rx ry px py sx sy vx vy,
 pb<>vb ->
 replay_stores m(front_updates pb vb rx ry px py sx sy vx vy)=Some mf ->
 Mem.loadbytes mf pb 0 4=Some(encode_val Mint32(Vint(clamp_bits(Int.sub rx px)(Int.repr 4096)))) /\
 Mem.loadbytes mf pb 4 4=Some(encode_val Mint32(Vint(clamp_bits(Int.sub ry py)(Int.repr 4096)))) /\
 Mem.loadbytes mf vb 0 4=Some(encode_val Mint32(Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608)))) /\
 Mem.loadbytes mf vb 4 4=Some(encode_val Mint32(Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608)))).
Proof.
 intros m mf pb vb rx ry px py sx sy vx vy DI RUN.
 repeat split;
 [eapply replay_stores_word_bytes with(ch:=Mint32)(index:=2%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=3%nat)|
  eapply replay_stores_word_bytes with(ch:=Mint32)(index:=6%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=7%nat)];
 [exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity|];
 cbv beta iota zeta delta[front_updates app skipn];every_word_miss.
Qed.
Lemma front_updates_miss_bytes : forall pb vb rx ry px py sx sy vx vy b ofs n,
 (b<>pb \/ofs+n<=0 \/8<=ofs) ->
 (b<>vb \/ofs+n<=0 \/8<=ofs) ->
 Forall(misses_bytes b ofs n)(front_updates pb vb rx ry px py sx sy vx vy).
Proof.
 intros pb vb rx ry px py sx sy vx vy b ofs n P V.
 unfold front_updates;cbn[app].
 let rec go:=lazymatch goal with
 | |-Forall _ []=>constructor
 | |-Forall _ (_::_)=>constructor;
   [cbn[misses_bytes size_chunk];
    first[destruct P as[NE|[LO|HI]];[left;exact NE|right;left;lia|right;right;lia]|
          destruct V as[NE|[LO|HI]];[left;exact NE|right;left;lia|right;right;lia]]|go]
 end in go.
Qed.
Print Assumptions front_updates_word_bytes.
