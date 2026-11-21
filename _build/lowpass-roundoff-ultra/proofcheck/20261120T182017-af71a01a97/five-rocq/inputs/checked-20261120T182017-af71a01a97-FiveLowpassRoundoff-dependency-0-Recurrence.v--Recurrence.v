From Stdlib Require Import Reals Psatz Lia.
Open Scope R_scope.

Definition reference_step (c x li y:R):R := (x+li+(c-1)*y)/(1+c).
Fixpoint reference (c:R)(x:nat->R)(y0:R)(n:nat):R :=
 match n with
 | O=>y0
 | S k=>reference_step c (x(S k)) (x k) (reference c x y0 k)
 end.
Definition envelope (delta:R)(n:nat):R := 2*delta*(1-(/2)^n).

Lemma coefficient_contraction:forall c,
 1<=c<=2 -> 0<1+c /\ 0<=(c-1)/(1+c)<=/2.
Proof.
 intros c C;split;[lra|].
 split;[unfold Rdiv;apply Rmult_le_pos;[lra|left;apply Rinv_0_lt_compat;lra]|].
 apply (Rmult_le_reg_r (1+c));[lra|].
 unfold Rdiv;rewrite Rmult_assoc,Rinv_l by lra; nra.
Qed.

Lemma reference_difference:forall c x li y z,
 1<=c<=2 ->
 reference_step c x li y-reference_step c x li z=
 ((c-1)/(1+c))*(y-z).
Proof. intros;unfold reference_step;field;lra. Qed.

Lemma envelope_zero:forall d,envelope d O=0.
Proof. intros;unfold envelope;simpl;ring. Qed.
Lemma envelope_step:forall d n,
 envelope d (S n)=d+(/2)*envelope d n.
Proof. intros;unfold envelope;cbn[pow];field. Qed.
Lemma envelope_bounds:forall d n,0<=d->0<=envelope d n<=2*d.
Proof.
 intros d n D.
 assert(P:0<=(/2)^n<=1).
 { induction n;cbn[pow];nra. }
 unfold envelope;nra.
Qed.

Theorem arbitrary_horizon_roundoff:forall c x y0 (actual:nat->R) delta,
 1<=c<=2 -> 0<=delta ->
 actual O=y0 ->
 (forall n,
 Rabs(actual(S n)-reference_step c (x(S n))(x n)(actual n))<=delta) ->
 forall n,Rabs(actual n-reference c x y0 n)<=envelope delta n.
Proof.
 intros c x y0 actual delta C D INIT LOCAL n.
 induction n as[|n IH].
 - cbn[reference];rewrite INIT,Rminus_diag_eq,Rabs_R0,envelope_zero;auto;lra.
 - cbn[reference].
   rewrite(envelope_step delta n).
   replace(actual(S n)-reference_step c (x(S n))(x n)(reference c x y0 n))
   with((actual(S n)-reference_step c (x(S n))(x n)(actual n))+
        (reference_step c (x(S n))(x n)(actual n)-
         reference_step c (x(S n))(x n)(reference c x y0 n)))by ring.
   eapply Rle_trans;[apply Rabs_triang|].
   rewrite(reference_difference _ _ _ _ _ C),Rabs_mult.
   pose proof(coefficient_contraction c C)as[DEN ALPHA].
   rewrite (Rabs_right ((c-1)/(1+c))) by lra.
   pose proof(Rabs_pos(actual n-reference c x y0 n))as NONNEG.
   specialize(LOCAL n).
   nra.
Qed.
Print Assumptions arbitrary_horizon_roundoff.
