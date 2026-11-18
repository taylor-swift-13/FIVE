From Stdlib Require Import ZArith Lia Psatz.
Open Scope Z_scope.

(** Saturation and ceiling are on mathematical signed integer codes. *)
Definition zclamp (limit value : Z) : Z :=
  Z.max (-limit) (Z.min limit value).

Definition ceil_div (error denominator : Z) : Z :=
  - ((-error) / denominator).

Lemma zclamp_bounds : forall limit value,
  0 <= limit -> -limit <= zclamp limit value <= limit.
Proof.
  intros limit value LIMIT; unfold zclamp.
  pose proof (Z.max_spec (-limit) (Z.min limit value)).
  pose proof (Z.min_spec limit value).
  destruct H as [[? ?]|[? ?]]; destruct H0 as [[? ?]|[? ?]]; lia.
Qed.

Lemma zclamp_identity : forall limit value,
  -limit <= value <= limit -> zclamp limit value = value.
Proof.
  intros limit value [LO HI]; unfold zclamp.
  rewrite Z.min_r by exact HI.
  rewrite Z.max_r by exact LO; reflexivity.
Qed.

Lemma zclamp_nonexpansive : forall limit x y,
  0 <= limit ->
  Z.abs (zclamp limit x - zclamp limit y) <= Z.abs (x-y).
Proof.
  intros limit x y LIMIT; unfold zclamp.
  pose proof (Z.max_spec (-limit) (Z.min limit x)) as HX.
  pose proof (Z.max_spec (-limit) (Z.min limit y)) as HY.
  pose proof (Z.min_spec limit x) as MX.
  pose proof (Z.min_spec limit y) as MY.
  destruct HX as [[? ?]|[? ?]]; destruct HY as [[? ?]|[? ?]];
  destruct MX as [[? ?]|[? ?]]; destruct MY as [[? ?]|[? ?]];
  apply Z.abs_le;
  destruct (Z.abs_spec (x-y)); lia.
Qed.

Lemma zclamp_pair_cap : forall limit x y,
  0 <= limit -> Z.abs (zclamp limit x - zclamp limit y) <= 2*limit.
Proof.
  intros limit x y LIMIT.
  pose proof (zclamp_bounds limit x LIMIT).
  pose proof (zclamp_bounds limit y LIMIT).
  apply Z.abs_le; lia.
Qed.

Lemma ceil_div_zero : forall denominator, ceil_div 0 denominator = 0.
Proof. intros denominator; destruct denominator; reflexivity. Qed.

Lemma ceil_div_cover : forall error denominator,
  0 <= error -> 0 < denominator ->
  0 <= ceil_div error denominator /\ error <= denominator * ceil_div error denominator.
Proof.
  intros error denominator ERROR DEN.
  pose proof (Z.div_mod (-error) denominator ltac:(lia)) as DIV.
  pose proof (Z.mod_pos_bound (-error) denominator DEN) as MOD.
  unfold ceil_div; split; nia.
Qed.

Lemma ceil_div_positive_formula : forall error denominator,
  0 <= error -> 0 < denominator ->
  ceil_div error denominator = (error + denominator - 1) / denominator.
Proof.
  intros error denominator ERROR DEN.
  pose proof (Z.div_mod (-error) denominator ltac:(lia)) as NEG.
  pose proof (Z.mod_pos_bound (-error) denominator DEN) as RN.
  pose proof (Z.div_mod (error+denominator-1) denominator ltac:(lia)) as POS.
  pose proof (Z.mod_pos_bound (error+denominator-1) denominator DEN) as RP.
  unfold ceil_div; nia.
Qed.

Lemma floor_div_difference_bound : forall x y error denominator,
  0 <= error -> 0 < denominator -> Z.abs (x-y) <= error ->
  Z.abs (x/denominator-y/denominator) <= ceil_div error denominator.
Proof.
  intros x y error denominator ERROR DEN DIFFERENCE.
  apply Z.abs_le in DIFFERENCE.
  pose proof (ceil_div_cover error denominator ERROR DEN) as [NONNEG COVER].
  pose proof (Z.div_mod x denominator ltac:(lia)) as DX.
  pose proof (Z.mod_pos_bound x denominator DEN) as RX.
  pose proof (Z.div_mod y denominator ltac:(lia)) as DY.
  pose proof (Z.mod_pos_bound y denominator DEN) as RY.
  apply Z.abs_le; split; nia.
Qed.

Lemma floor_div_difference_zero : forall x y denominator,
  0 < denominator -> Z.abs (x-y) <= 0 ->
  x/denominator = y/denominator.
Proof.
  intros x y denominator DEN DIFFERENCE.
  pose proof (floor_div_difference_bound x y 0 denominator ltac:(lia) DEN DIFFERENCE).
  rewrite ceil_div_zero in H.
  apply Z.abs_le in H; lia.
Qed.

Lemma multiply_difference_bound : forall gain x y error,
  0 <= gain -> Z.abs (x-y) <= error ->
  Z.abs (gain*x-gain*y) <= gain*error.
Proof.
  intros gain x y error GAIN DIFF.
  replace (gain*x-gain*y) with (gain*(x-y)) by ring.
  rewrite Z.abs_mul, Z.abs_eq by exact GAIN; nia.
Qed.

Lemma addition_difference_bound : forall x y a b dx da,
  Z.abs (x-y) <= dx -> Z.abs (a-b) <= da ->
  Z.abs ((x+a)-(y+b)) <= dx+da.
Proof.
  intros x y a b dx da HX HA.
  replace ((x+a)-(y+b)) with ((x-y)+(a-b)) by ring.
  eapply Z.le_trans; [apply Z.abs_triangle|lia].
Qed.

Print Assumptions zclamp_nonexpansive.
Print Assumptions floor_div_difference_bound.
Print Assumptions ceil_div_positive_formula.

