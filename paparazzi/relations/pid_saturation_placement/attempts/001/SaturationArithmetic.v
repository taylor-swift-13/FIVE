From Stdlib Require Import ZArith Lia Psatz.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic.
Open Scope Z_scope.
Definition staged_command(a b:Z):Z:=zclamp 3216(zclamp 1429 a+b).
Definition unified_command(a b:Z):Z:=zclamp 3216(a+b).

Lemma clamp_above:forall c x,0<=c ->c<=x ->zclamp c x=c.
Proof. intros;unfold zclamp;rewrite Z.min_l by lia;rewrite Z.max_r by lia;reflexivity. Qed.
Lemma clamp_below:forall c x,0<=c ->x<= -c ->zclamp c x= -c.
Proof. intros;unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_l by lia;reflexivity. Qed.

Lemma integral_command_range:forall kp kd ki pe se old,
 -1429<=integral_z kp kd ki pe se old/65536<=1429.
Proof.
 intros;pose proof(zclamp_bounds 93650944(old+ki*pd_z kp kd pe se)ltac:(lia))as B.
 fold(integral_z kp kd ki pe se old)in B.
 pose proof(Z.div_mod(integral_z kp kd ki pe se old)65536 ltac:(lia))as D.
 pose proof(Z.mod_pos_bound(integral_z kp kd ki pe se old)65536 ltac:(lia))as R;lia.
Qed.
Lemma staged_outer_inactive:forall a b,-1429<=b<=1429 ->
 staged_command a b=zclamp 1429 a+b.
Proof.
 intros a b B;unfold staged_command;apply zclamp_identity.
 pose proof(zclamp_bounds 1429 a ltac:(lia));lia.
Qed.
Lemma positive_strict:forall a b,-1429<=b<=1429 ->1429<a ->
 staged_command a b<unified_command a b.
Proof.
 intros a b B A;rewrite staged_outer_inactive by exact B.
 rewrite clamp_above by lia;unfold unified_command.
 destruct(Z_le_dec(a+b)3216)as[LO|HI].
 - rewrite zclamp_identity by lia;lia.
 - rewrite clamp_above by lia;lia.
Qed.
Lemma negative_strict:forall a b,-1429<=b<=1429 ->a< -1429 ->
 unified_command a b<staged_command a b.
Proof.
 intros a b B A;rewrite staged_outer_inactive by exact B.
 rewrite clamp_below by lia;unfold unified_command.
 destruct(Z_le_dec(-3216)(a+b))as[HI|LO].
 - rewrite zclamp_identity by lia;lia.
 - rewrite clamp_below by lia;lia.
Qed.
Lemma clamp_loss:forall a,
 Z.abs(zclamp 1429 a-a)=Z.max 0(Z.abs a-1429).
Proof.
 intros a;destruct(Z_lt_ge_dec a(-1429))as[LO|LO].
 - rewrite clamp_below by lia;rewrite Z.abs_eq by lia.
   rewrite(Z.abs_neq a)by lia;rewrite Z.max_r by lia;lia.
 - destruct(Z_lt_ge_dec 1429 a)as[HI|HI].
   + rewrite clamp_above by lia;rewrite Z.abs_neq by lia.
     rewrite(Z.abs_eq a)by lia;rewrite Z.max_r by lia;lia.
   + assert(ABS:Z.abs a<=1429)by(apply Z.abs_le;lia).
     rewrite zclamp_identity by lia;rewrite Z.sub_diag,Z.abs_0,Z.max_l by lia;reflexivity.
Qed.
Theorem saturation_placement:forall a b,-1429<=b<=1429 ->
 staged_command a b=zclamp 1429 a+b /\
 (staged_command a b=unified_command a b <->Z.abs a<=1429) /\
 (1429<a ->staged_command a b<unified_command a b) /\
 (a< -1429 ->unified_command a b<staged_command a b) /\
 Z.abs(staged_command a b-unified_command a b)<=Z.max 0(Z.abs a-1429).
Proof.
 intros a b B;split;[apply staged_outer_inactive;exact B|].
 split.
 - split.
   + intros EQ;apply Z.abs_le;split.
     * destruct(Z_lt_ge_dec a(-1429));[pose proof(negative_strict a b B ltac:(lia));lia|lia].
     * destruct(Z_lt_ge_dec 1429 a);[pose proof(positive_strict a b B ltac:(lia));lia|lia].
   + intros A;apply Z.abs_le in A;unfold staged_command,unified_command.
     rewrite(zclamp_identity 1429 a A);reflexivity.
 - split;[apply positive_strict;exact B|];split;[apply negative_strict;exact B|].
   eapply Z.le_trans.
   + unfold staged_command,unified_command;apply zclamp_nonexpansive;lia.
   + replace(zclamp 1429 a+b-(a+b))with(zclamp 1429 a-a)by ring.
     rewrite clamp_loss;lia.
Qed.
Print Assumptions saturation_placement.
