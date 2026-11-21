From Stdlib Require Import ZArith Lia Wellfounded.
Open Scope Z_scope.

(** Independent integer specification.  The execution models are the unchanged,
    automatically exported Csyntax programs.  Constants are the actual fixed
    point values obtained from Paparazzi's ANGLE_BFP_OF_REAL configuration. *)
Definition half_pi : Z := 6433.
Definition pi : Z := 12867.
Definition period : Z := 25735.
Definition normalize (a : Z) : Z := (a + pi) mod period - pi.
Definition fold (a : Z) : Z :=
  if Z.gtb a half_pi then pi - a
  else if Z.ltb a (-half_pi) then -pi - a else a.
Definition index (a : Z) : Z := Z.abs (fold (normalize a)).
Definition sign (a : Z) : Z := if Z.ltb (fold (normalize a)) 0 then -1 else 1.

Lemma normalize_bounds : forall a, -pi <= normalize a <= pi.
Proof.
  intros a. unfold normalize, pi, period.
  pose proof (Z.mod_pos_bound (a+12867) 25735 ltac:(lia)); lia.
Qed.
Lemma normalize_small : forall a, -pi <= a <= pi -> normalize a = a.
Proof.
  intros a H. unfold normalize, pi, period in *.
  rewrite Z.mod_small; lia.
Qed.
Lemma normalize_sub_period : forall a, normalize (a-period)=normalize a.
Proof.
  intros a. unfold normalize.
  replace (a-period+pi) with ((a+pi)+(-1)*period) by ring.
  rewrite Z.mod_add; [reflexivity|unfold period;lia].
Qed.
Lemma normalize_add_period : forall a, normalize (a+period)=normalize a.
Proof.
  intros a. unfold normalize.
  replace (a+period+pi) with ((a+pi)+1*period) by ring.
  rewrite Z.mod_add; [reflexivity|unfold period;lia].
Qed.

Inductive upper : Z -> Z -> Prop :=
| upper_done : forall a, a <= pi -> upper a a
| upper_more : forall a b, pi < a -> upper (a-period) b -> upper a b.
Inductive lower : Z -> Z -> Prop :=
| lower_done : forall a, -pi <= a -> lower a a
| lower_more : forall a b, a < -pi -> lower (a+period) b -> lower a b.

Lemma upper_exists : forall a, exists b, upper a b.
Proof.
  assert (A : forall n a, Z.to_nat (Z.max 0 (a-pi)) = n -> exists b, upper a b).
  { intro n; induction n using lt_wf_ind; intros a E.
    destruct (Z_le_gt_dec a pi) as [D|D].
    - exists a; constructor; exact D.
    - destruct (H (Z.to_nat (Z.max 0 (a-period-pi)))) with (a:=a-period)
        as [b B].
      + rewrite <- E. apply Z2Nat.inj_lt; try (apply Z.le_max_l).
        unfold pi, period in *; lia.
      + reflexivity.
      + exists b; apply upper_more; [lia|exact B]. }
  intros a; eapply A; reflexivity.
Qed.
Lemma lower_exists : forall a, exists b, lower a b.
Proof.
  assert (A : forall n a, Z.to_nat (Z.max 0 (-pi-a)) = n -> exists b, lower a b).
  { intro n; induction n using lt_wf_ind; intros a E.
    destruct (Z_le_gt_dec (-pi) a) as [D|D].
    - exists a; constructor; exact D.
    - destruct (H (Z.to_nat (Z.max 0 (-pi-(a+period))))) with (a:=a+period)
        as [b B].
      + rewrite <- E. apply Z2Nat.inj_lt; try (apply Z.le_max_l).
        unfold pi, period in *; lia.
      + reflexivity.
      + exists b; apply lower_more; [lia|exact B]. }
  intros a; eapply A; reflexivity.
Qed.
Lemma upper_bound : forall a b, upper a b -> b <= pi /\ (a < -pi -> b=a) /\ (-pi <= a -> -pi <= b).
Proof.
  intros a b U; induction U; unfold pi, period in *; intuition lia.
Qed.
Lemma lower_bound : forall a b, lower a b -> -pi <= b /\ (pi < a -> b=a) /\ (a <= pi -> b<=pi).
Proof.
  intros a b L; induction L; unfold pi, period in *; intuition lia.
Qed.
Lemma upper_normalize : forall a b, upper a b -> normalize a=normalize b.
Proof. intros a b U; induction U; auto. rewrite <- normalize_sub_period; exact IHU. Qed.
Lemma lower_normalize : forall a b, lower a b -> normalize a=normalize b.
Proof. intros a b L; induction L; auto. rewrite <- normalize_add_period; exact IHL. Qed.
Theorem normalization_loops_exist_and_agree : forall a,
  exists b c, upper a b /\ lower b c /\ c=normalize a.
Proof.
  intros a. destruct (upper_exists a) as [b U]. destruct (lower_exists b) as [c L].
  exists b,c; repeat split; auto.
  pose proof (upper_bound _ _ U) as [UB _].
  pose proof (lower_bound _ _ L) as [LB [_ CB]].
  pose proof (upper_normalize _ _ U) as NU.
  pose proof (lower_normalize _ _ L) as NL.
  rewrite NU,NL,normalize_small; auto.
Qed.
Lemma fold_bounds : forall a, -pi<=a<=pi -> -half_pi <= fold a <= half_pi.
Proof.
  intros a B; unfold fold; destruct (Z.gtb a half_pi) eqn:H.
  - apply Z.gtb_lt in H. unfold half_pi,pi in *; lia.
  - apply Z.gtb_ge in H. destruct (Z.ltb a (-half_pi)) eqn:L.
    + apply Z.ltb_lt in L. unfold half_pi,pi in *; lia.
    + apply Z.ltb_ge in L. lia.
Qed.
Theorem index_bounds : forall a, 0<=index a<6434.
Proof.
  intro a. unfold index. pose proof (fold_bounds _ (normalize_bounds a)).
  unfold half_pi in *. destruct (Z_le_gt_dec 0 (fold (normalize a))).
  - rewrite Z.abs_eq; lia.
  - rewrite Z.abs_neq; lia.
Qed.
Lemma upper_machine_safe : forall a,
 -2147483648 <= a <= 2147483647 -> pi<a ->
 -2147483648 <= a-period <= 2147483647.
Proof. unfold pi,period; intros;lia. Qed.
Lemma lower_machine_safe : forall a,
 -2147483648 <= a <= 2147483647 -> a< -pi ->
 -2147483648 <= a+period <= 2147483647.
Proof. unfold pi,period; intros;lia. Qed.
Lemma fold_machine_safe : forall a, -pi<=a<=pi ->
 -2147483648<=fold a<=2147483647.
Proof. intros;pose proof(fold_bounds _ H);unfold half_pi in *;lia. Qed.
Print Assumptions normalization_loops_exist_and_agree.
Print Assumptions index_bounds.
