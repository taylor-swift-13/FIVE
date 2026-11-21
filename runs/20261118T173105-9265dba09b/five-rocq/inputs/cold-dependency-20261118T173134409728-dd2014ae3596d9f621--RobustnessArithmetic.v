From Stdlib Require Import ZArith Lia Psatz.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic.
Open Scope Z_scope.
Definition position_bound (kp epsilon:Z):Z := ceil_div (kp*epsilon) 64.
Definition integral_cap:Z := 2*1429*65536.
Definition command_cap:Z := 2*3216.
Definition position_error (r p:Z):Z := zclamp 4096 (r-p).

Lemma position_error_difference : forall r a b epsilon,
 Z.abs(a-b)<=epsilon ->
 Z.abs(position_error r a-position_error r b)<=epsilon.
Proof.
 intros;unfold position_error.
 eapply Z.le_trans;[apply zclamp_nonexpansive;lia|].
 replace (r-a-(r-b)) with (-(a-b)) by ring.
 rewrite Z.abs_opp;assumption.
Qed.

Theorem integer_cycle_robustness : forall kp kd ki kv ka r pa pb se rs acc ia ib epsilon distance,
 0<=kp ->0<=ki ->0<=epsilon ->
 Z.abs(pa-pb)<=epsilon -> Z.abs(ia-ib)<=distance ->
 let peA:=position_error r pa in
 let peB:=position_error r pb in
 let B:=position_bound kp epsilon in
 let nextA:=integral_z kp kd ki peA se ia in
 let nextB:=integral_z kp kd ki peB se ib in
 Z.abs(nextA-nextB)<=Z.min integral_cap (distance+ki*B) /\
 Z.abs(command_z kp kd ki kv ka peA se rs acc ia-
       command_z kp kd ki kv ka peB se rs acc ib)
 <=Z.min command_cap (B+ceil_div (distance+ki*B) 65536).
Proof.
 intros kp kd ki kv ka r pa pb se rs acc ia ib epsilon distance KP KI EPS MEASURE OLD.
 cbv zeta.
 pose proof(ceil_div_cover (kp*epsilon) 64 ltac:(nia) ltac:(lia))as[BN BC].
 fold(position_bound kp epsilon)in BN,BC.
 assert(PE:Z.abs(position_error r pa-position_error r pb)<=epsilon)
 by(apply position_error_difference;exact MEASURE).
 pose proof(multiply_difference_bound kp (position_error r pa)(position_error r pb)epsilon KP PE)as PROD.
 pose proof(floor_div_difference_bound (kp*position_error r pa)(kp*position_error r pb)(kp*epsilon)64 ltac:(nia)ltac:(lia)PROD)as DIV.
 fold(position_bound kp epsilon)in DIV.
 assert(PD:Z.abs(pd_z kp kd(position_error r pa)se-pd_z kp kd(position_error r pb)se)<=position_bound kp epsilon).
 { unfold pd_z;replace (kp*position_error r pa/64+kd*(se/4)/32768-(kp*position_error r pb/64+kd*(se/4)/32768))
 with(kp*position_error r pa/64-kp*position_error r pb/64)by ring;exact DIV. }
 assert(FF:Z.abs(ff_z kp kd kv ka(position_error r pa)se rs acc-
 ff_z kp kd kv ka(position_error r pb)se rs acc)<=position_bound kp epsilon).
 { unfold ff_z;replace(pd_z kp kd(position_error r pa)se+kv*rs/131072+ka*acc/256-
 (pd_z kp kd(position_error r pb)se+kv*rs/131072+ka*acc/256))
 with(pd_z kp kd(position_error r pa)se-pd_z kp kd(position_error r pb)se)by ring;exact PD. }
 pose proof(multiply_difference_bound ki _ _ _ KI PD)as IM.
 pose proof(addition_difference_bound ia ib _ _ distance _ OLD IM)as SUM.
 assert(GROW:Z.abs(integral_z kp kd ki(position_error r pa)se ia-
 integral_z kp kd ki(position_error r pb)se ib)<=distance+ki*position_bound kp epsilon).
 { unfold integral_z;eapply Z.le_trans;[apply zclamp_nonexpansive;lia|exact SUM]. }
 assert(CAP:Z.abs(integral_z kp kd ki(position_error r pa)se ia-
 integral_z kp kd ki(position_error r pb)se ib)<=integral_cap).
 { unfold integral_z,integral_cap;apply zclamp_pair_cap;lia. }
 split;[apply Z.min_glb;assumption|].
 assert(TR:Z.abs(zclamp 1429(ff_z kp kd kv ka(position_error r pa)se rs acc)-
 zclamp 1429(ff_z kp kd kv ka(position_error r pb)se rs acc))<=position_bound kp epsilon).
 { eapply Z.le_trans;[apply zclamp_nonexpansive;lia|exact FF]. }
 assert(GNON:0<=distance+ki*position_bound kp epsilon).
 { pose proof(Z.abs_nonneg(ia-ib));nia. }
 pose proof(floor_div_difference_bound _ _ (distance+ki*position_bound kp epsilon)65536 GNON ltac:(lia)GROW)as ID.
 pose proof(addition_difference_bound _ _ _ _ _ _ TR ID)as CSUM.
 apply Z.min_glb.
 - unfold command_z,command_cap;apply zclamp_pair_cap;lia.
 - unfold command_z;eapply Z.le_trans;[apply zclamp_nonexpansive;lia|exact CSUM].
Qed.
Print Assumptions integer_cycle_robustness.
