From Stdlib Require Import ZArith Lia Psatz.
From PidMeasurementAttempt001 Require Import IntegerBounds.
Open Scope Z_scope.

(** All numbers are signed integer codes.  This limit is exactly
    1429 << 16 in the unchanged controller. *)
Definition drift_limit : Z := 93650944.
Definition residue_bit (p : Z) : Z :=
  if Z.eqb (p mod 64) 0 then 0 else 1.
Definition alternating_step (kp ki r old : Z) : Z :=
  zclamp drift_limit (old + ki * (kp*r/64)).
Definition drift_even (p ki : Z) (n : nat) : Z :=
  - Z.min (Z.of_nat n * ki * residue_bit p) drift_limit.

Lemma residue_bit_bounds : forall p, 0 <= residue_bit p <= 1.
Proof. intro p; unfold residue_bit; destruct (Z.eqb (p mod 64) 0); lia. Qed.

Lemma negative_floor_exact : forall p,
  (-p)/64 = -(p/64 + residue_bit p).
Proof.
  intro p.
  pose proof (Z.div_mod p 64 ltac:(lia)) as POS.
  pose proof (Z.mod_pos_bound p 64 ltac:(lia)) as RP.
  pose proof (Z.div_mod (-p) 64 ltac:(lia)) as NEG.
  pose proof (Z.mod_pos_bound (-p) 64 ltac:(lia)) as RN.
  unfold residue_bit.
  destruct (Z.eqb (p mod 64) 0) eqn:R.
  - apply Z.eqb_eq in R; nia.
  - apply Z.eqb_neq in R; nia.
Qed.

Lemma quotient_bounds : forall p,
  0 <= p <= 409600 -> 0 <= p/64 <= 6400.
Proof.
  intros p P.
  pose proof (Z.div_mod p 64 ltac:(lia)).
  pose proof (Z.mod_pos_bound p 64 ltac:(lia)); nia.
Qed.

Lemma positive_integral_increment_bounds : forall p ki,
  0 <= p <= 409600 -> 0 <= ki <= 100 ->
  0 <= ki*(p/64) <= 640000.
Proof.
  intros p ki P KI; pose proof (quotient_bounds p P); nia.
Qed.

Lemma drift_even_bounds : forall p ki n,
  0 <= ki -> -drift_limit <= drift_even p ki n <= 0.
Proof.
  intros p ki n KI.
  pose proof (residue_bit_bounds p).
  pose proof (Nat2Z.is_nonneg n).
  unfold drift_even,drift_limit.
  pose proof (Z.min_spec (Z.of_nat n * ki * residue_bit p) 93650944).
  destruct H1 as [[? ?]|[? ?]]; nia.
Qed.

Lemma clamp_negative_decrement : forall limit x decrement,
  0 <= limit -> 0 <= x -> 0 <= decrement ->
  zclamp limit (- Z.min x limit - decrement) =
  - Z.min (x + decrement) limit.
Proof.
  intros limit x decrement LIMIT X DEC.
  unfold zclamp.
  destruct (Z_le_gt_dec x limit) as [XL|XL].
  - rewrite (Z.min_l x limit) by lia.
    rewrite (Z.min_r limit (-x-decrement)) by lia.
    destruct (Z_le_gt_dec (x+decrement) limit) as [SUM|SUM].
    + rewrite (Z.min_l (x+decrement) limit) by lia.
      rewrite Z.max_r by lia; lia.
    + rewrite (Z.min_r (x+decrement) limit) by lia.
      rewrite Z.max_l by lia; lia.
  - rewrite (Z.min_r x limit) by lia.
    rewrite (Z.min_r limit (-limit-decrement)) by lia.
    rewrite (Z.min_r (x+decrement) limit) by lia.
    rewrite Z.max_l by lia; lia.
Qed.

(** The positive half-cycle cannot hit the upper integral cap:
    its increment is at most 640000, while every even integral is <= 0.
    It cannot hit the lower cap because that increment is nonnegative. *)
Lemma positive_half_exact : forall p kp ki A n,
  p = kp*A -> 0 <= p <= 409600 -> 0 <= ki <= 100 ->
  alternating_step kp ki A (drift_even p ki n) =
  drift_even p ki n + ki*(p/64).
Proof.
  intros p kp ki A n P RANGE KI.
  pose proof (positive_integral_increment_bounds p ki RANGE KI) as INC.
  pose proof (drift_even_bounds p ki n ltac:(lia)) as OLD.
  unfold alternating_step; rewrite <-P.
  apply zclamp_identity; unfold drift_limit in *; lia.
Qed.

Theorem pair_drift_step : forall kp ki A n,
  0 <= A <= 4096 -> 0 <= kp <= 100 -> 0 <= ki <= 100 ->
  alternating_step kp ki (-A)
    (alternating_step kp ki A (drift_even (kp*A) ki n)) =
  drift_even (kp*A) ki (S n).
Proof.
  intros kp ki A n A_RANGE KP KI.
  assert (P_RANGE : 0 <= kp*A <= 409600) by nia.
  rewrite (positive_half_exact (kp*A) kp ki A n eq_refl P_RANGE KI).
  unfold alternating_step.
  replace (kp * -A) with (-(kp*A)) by ring.
  rewrite negative_floor_exact.
  replace (drift_even (kp*A) ki n + ki*(kp*A/64) +
    ki * -(kp*A/64 + residue_bit (kp*A)))
    with (drift_even (kp*A) ki n - ki*residue_bit (kp*A)) by ring.
  unfold drift_even.
  rewrite clamp_negative_decrement.
  - rewrite Nat2Z.inj_succ.
    f_equal; f_equal; ring.
  - unfold drift_limit; lia.
  - pose proof (Nat2Z.is_nonneg n).
    pose proof (residue_bit_bounds (kp*A)); nia.
  - pose proof (residue_bit_bounds (kp*A)); nia.
Qed.

Lemma drift_even_zero : forall p ki, drift_even p ki O = 0.
Proof.
  intros p ki; unfold drift_even,drift_limit; cbn.
  reflexivity.
Qed.

Theorem drift_divisible_split : forall p ki n,
  drift_even p ki n =
  if Z.eqb (p mod 64) 0 then 0
  else - Z.min (Z.of_nat n * ki) drift_limit.
Proof.
  intros p ki n; unfold drift_even,residue_bit.
  destruct (Z.eqb (p mod 64) 0).
  - rewrite Z.mul_0_r; reflexivity.
  - rewrite Z.mul_1_r; reflexivity.
Qed.

Lemma residue_bit_zero_iff : forall p,
  residue_bit p = 0 <-> (64 | p).
Proof.
  intro p; unfold residue_bit.
  rewrite <- (Z.mod_divide p 64 ltac:(lia)).
  destruct (Z.eqb (p mod 64) 0) eqn:R.
  - apply Z.eqb_eq in R; tauto.
  - apply Z.eqb_neq in R; split; [discriminate|congruence].
Qed.

Theorem drift_divisible_cases : forall p ki n,
  ((64 | p) -> drift_even p ki n = 0) /\
  (~(64 | p) -> drift_even p ki n =
    -Z.min (Z.of_nat n*ki) drift_limit).
Proof.
  intros p ki n; rewrite drift_divisible_split.
  destruct (Z.eqb (p mod 64) 0) eqn:R.
  - apply Z.eqb_eq in R.
    assert (D : (64|p)) by (apply (proj1 (Z.mod_divide p 64 ltac:(lia))); exact R).
    split; [reflexivity|contradiction].
  - apply Z.eqb_neq in R.
    assert (D : ~(64|p)).
    { intro D; apply R; apply (proj2 (Z.mod_divide p 64 ltac:(lia))); exact D. }
    split; [contradiction|reflexivity].
Qed.

Print Assumptions pair_drift_step.
Print Assumptions drift_divisible_cases.

