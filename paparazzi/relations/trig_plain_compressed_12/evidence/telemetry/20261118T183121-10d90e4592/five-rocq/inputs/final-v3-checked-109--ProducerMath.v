From Stdlib Require Import ZArith Lia.
From compcert Require Import Integers.
From PprzTrigCBMC Require Import TypedGuards.
Local Open Scope Z_scope.

Lemma signed_mod5_value : forall x,-4<=Int.signed(Int.mods x(Int.repr 5))<=4.
Proof.
 intro x;unfold Int.mods;rewrite(Int.signed_repr 5)by(change(-2147483648<=5<=2147483647);lia).
 pose proof(signed_remainder_five_bound(Int.signed x))as B.
 rewrite Int.signed_repr by(change(-2147483648<=Z.rem(Int.signed x)5<=2147483647);lia);exact B.
Qed.
Lemma signed_mask7_value : forall x,0<=Int.signed(Int.and x(Int.repr 7))<=7.
Proof.
 intro x;unfold Int.and;rewrite(Int.unsigned_repr 7)by(change(0<=7<=4294967295);lia).
 pose proof(mask7_bound(Int.unsigned x))as B.
 rewrite Int.signed_repr by(change(-2147483648<=Z.land(Int.unsigned x)7<=2147483647);lia);exact B.
Qed.
Lemma signed_mask8_value : forall x,0<=Int.signed(Int.and x(Int.repr 8))<=8.
Proof.
 intro x;unfold Int.and;rewrite(Int.unsigned_repr 8)by(change(0<=8<=4294967295);lia).
 pose proof(mask8_bound(Int.unsigned x))as B.
 rewrite Int.signed_repr by(change(-2147483648<=Z.land(Int.unsigned x)8<=2147483647);lia);exact B.
Qed.
Lemma signed_div5_value : forall x,signed16(Int.signed x)->
 -6553<=Int.signed(Int.divs x(Int.repr 5))<=6553.
Proof.
 intros x X;unfold signed16 in X.
 pose proof(Z.quot_le_mono(-32768)(Int.signed x)5 ltac:(lia)ltac:(lia))as L.
 pose proof(Z.quot_le_mono(Int.signed x)32767 5 ltac:(lia)ltac:(lia))as U.
 change(-6553<=Z.quot(Int.signed x)5)in L;change(Z.quot(Int.signed x)5<=6553)in U.
 unfold Int.divs;rewrite(Int.signed_repr 5)by(change(-2147483648<=5<=2147483647);lia).
 rewrite Int.signed_repr by(change(-2147483648<=Z.quot(Int.signed x)5<=2147483647);lia);lia.
Qed.
Lemma signed_div2_value : forall x,signed16(Int.signed x)->
 -16384<=Int.signed(Int.divs x(Int.repr 2))<=16383.
Proof.
 intros x X;unfold signed16 in X.
 pose proof(Z.quot_le_mono(-32768)(Int.signed x)2 ltac:(lia)ltac:(lia))as L.
 pose proof(Z.quot_le_mono(Int.signed x)32767 2 ltac:(lia)ltac:(lia))as U.
 change(-16384<=Z.quot(Int.signed x)2)in L;change(Z.quot(Int.signed x)2<=16383)in U.
 unfold Int.divs;rewrite(Int.signed_repr 2)by(change(-2147483648<=2<=2147483647);lia).
 rewrite Int.signed_repr by(change(-2147483648<=Z.quot(Int.signed x)2<=2147483647);lia);lia.
Qed.
Lemma signed_rem2_value : forall x,0<=Int.signed x<=65535 ->
 0<=Int.signed(Int.mods x(Int.repr 2))<=1.
Proof.
 intros x X;pose proof(Z.rem_bound_pos(Int.signed x)2 ltac:(lia)ltac:(lia))as B.
 unfold Int.mods;rewrite(Int.signed_repr 2)by(change(-2147483648<=2<=2147483647);lia).
 rewrite Int.signed_repr by(change(-2147483648<=Z.rem(Int.signed x)2<=2147483647);lia);lia.
Qed.
Lemma signed_mul4_small : forall x,0<=Int.signed x<=1 ->
 0<=Int.signed(Int.mul(Int.repr 4)x)<=4.
Proof.
 intros x X;rewrite Int.mul_signed,(Int.signed_repr 4)by(change(-2147483648<=4<=2147483647);lia).
 rewrite Int.signed_repr by(change(-2147483648<=4*Int.signed x<=2147483647);lia);lia.
Qed.
Lemma signed_add1_div5 : forall x,-6553<=Int.signed x<=6553 ->
 -6552<=Int.signed(Int.add x Int.one)<=6554.
Proof.
 intros x X;rewrite Int.add_signed,Int.signed_one.
 rewrite Int.signed_repr by(change(-2147483648<=Int.signed x+1<=2147483647);lia);lia.
 all:vm_compute;auto.
Qed.
