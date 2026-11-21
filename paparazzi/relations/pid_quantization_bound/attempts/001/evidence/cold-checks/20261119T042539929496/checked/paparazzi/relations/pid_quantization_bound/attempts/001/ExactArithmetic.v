From Stdlib Require Import ZArith Lia Psatz.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic.
Open Scope Z_scope.

(** Exact rationals are represented by integer numerators at fixed powers of
    two. No operation below divides a dynamic value or rounds it. *)
Definition T:Z:=131072.
Definition S:Z:=65536.
Definition pd_num(kp kd pe se:Z):Z:=2048*kp*pe+kd*se.
Definition total_num(kp kd kv ka pe se rs ra:Z):Z:=
 pd_num kp kd pe se+kv*rs+512*ka*ra.
Definition integral_num(kp kd ki pe se old_num:Z):Z:=
 zclamp(93650944*T)(old_num+ki*pd_num kp kd pe se).
Definition command_num(kp kd ki kv ka pe se rs ra old_num:Z):Z:=
 zclamp(3216*T*S)
 (S*zclamp(1429*T)(total_num kp kd kv ka pe se rs ra)+
  integral_num kp kd ki pe se old_num).
Definition pd_loss(kd:Z):Z:=2*T+3*kd.
Definition output_loss(kd:Z):Z:=(5*T+3*kd)*S.
Definition horizon_loss(n:nat)(ki kd:Z):Z:=output_loss kd+Z.of_nat n*ki*pd_loss kd.
Definition output_cap:Z:=6432*T*S.

Lemma clamp_scaled:forall c x k,0<=k ->
 zclamp(c*k)(x*k)=zclamp c x*k.
Proof.
 intros c x k K;unfold zclamp.
 pose proof(Z.min_spec c x)as A.
 pose proof(Z.max_spec(-c)(Z.min c x))as B.
 pose proof(Z.min_spec(c*k)(x*k))as C.
 pose proof(Z.max_spec(-(c*k))(Z.min(c*k)(x*k)))as D.
 destruct A as[[? ?]|[? ?]];destruct B as[[? ?]|[? ?]];
 destruct C as[[? ?]|[? ?]];destruct D as[[? ?]|[? ?]];nia.
Qed.

Lemma clamp_ordered:forall c x y d,0<=c ->0<=y-x<=d ->
 0<=zclamp c y-zclamp c x<=d.
Proof.
 intros c x y d C D;unfold zclamp.
 pose proof(Z.min_spec c x)as A;pose proof(Z.min_spec c y)as B.
 pose proof(Z.max_spec(-c)(Z.min c x))as F.
 pose proof(Z.max_spec(-c)(Z.min c y))as G.
 destruct A as[[? ?]|[? ?]];destruct B as[[? ?]|[? ?]];
 destruct F as[[? ?]|[? ?]];destruct G as[[? ?]|[? ?]];lia.
Qed.

Lemma pd_quantization:forall kp kd pe se,0<=kd ->
 0<=pd_num kp kd pe se-pd_z kp kd pe se*T<=pd_loss kd.
Proof.
 intros kp kd pe se KD.
 pose proof(Z.div_mod(kp*pe)64 ltac:(lia))as P.
 pose proof(Z.mod_pos_bound(kp*pe)64 ltac:(lia))as PR.
 pose proof(Z.div_mod se 4 ltac:(lia))as E.
 pose proof(Z.mod_pos_bound se 4 ltac:(lia))as ER.
 pose proof(Z.div_mod(kd*(se/4))32768 ltac:(lia))as D.
 pose proof(Z.mod_pos_bound(kd*(se/4))32768 ltac:(lia))as DR.
 unfold pd_num,pd_z,pd_loss,T;nia.
Qed.

Lemma total_quantization:forall kp kd kv ka pe se rs ra,0<=kd ->
 0<=total_num kp kd kv ka pe se rs ra-
 ff_z kp kd kv ka pe se rs ra*T<=pd_loss kd+2*T.
Proof.
 intros kp kd kv ka pe se rs ra KD.
 pose proof(pd_quantization kp kd pe se KD)as PD.
 pose proof(Z.div_mod(kv*rs)131072 ltac:(lia))as V.
 pose proof(Z.mod_pos_bound(kv*rs)131072 ltac:(lia))as VR.
 pose proof(Z.div_mod(ka*ra)256 ltac:(lia))as A.
 pose proof(Z.mod_pos_bound(ka*ra)256 ltac:(lia))as AR.
 unfold total_num,ff_z,T in *;nia.
Qed.

Theorem exact_cycle_error:forall kp kd ki kv ka pe se rs ra ci ri distance,
 0<=kd ->0<=ki ->0<=ri-ci*T<=distance ->
 let ni:=integral_z kp kd ki pe se ci in
 let nr:=integral_num kp kd ki pe se ri in
 0<=nr-ni*T<=distance+ki*pd_loss kd /\
 0<=command_num kp kd ki kv ka pe se rs ra ri-
 command_z kp kd ki kv ka pe se rs ra ci*T*S
 <=output_loss kd+distance+ki*pd_loss kd.
Proof.
 intros kp kd ki kv ka pe se rs ra ci ri distance KD KI OLD;cbv zeta.
 pose proof(pd_quantization kp kd pe se KD)as PD.
 assert(INTEGRAL:0<=integral_num kp kd ki pe se ri-
 integral_z kp kd ki pe se ci*T<=distance+ki*pd_loss kd).
 { unfold integral_num,integral_z.
   rewrite<-(clamp_scaled 93650944(ci+ki*pd_z kp kd pe se)T ltac:(unfold T;lia)).
   apply clamp_ordered;[unfold T;lia|nia]. }
 split;[exact INTEGRAL|].
 pose proof(total_quantization kp kd kv ka pe se rs ra KD)as TOTAL.
 assert(INNER:0<=zclamp(1429*T)(total_num kp kd kv ka pe se rs ra)-
 zclamp 1429(ff_z kp kd kv ka pe se rs ra)*T<=pd_loss kd+2*T).
 { rewrite<-(clamp_scaled 1429(ff_z kp kd kv ka pe se rs ra)T ltac:(unfold T;lia)).
   apply clamp_ordered;[unfold T;lia|exact TOTAL]. }
 pose proof(Z.div_mod(integral_z kp kd ki pe se ci)S ltac:(unfold S;lia))as I.
 pose proof(Z.mod_pos_bound(integral_z kp kd ki pe se ci)S ltac:(unfold S;lia))as IR.
 unfold command_num,command_z.
 replace(zclamp 3216(zclamp 1429(ff_z kp kd kv ka pe se rs ra)+
 integral_z kp kd ki pe se ci/65536)*T*S)
 with(zclamp(3216*(T*S))
 ((zclamp 1429(ff_z kp kd kv ka pe se rs ra)+integral_z kp kd ki pe se ci/65536)*(T*S))).
 2:{ rewrite clamp_scaled by(unfold T,S;lia);ring. }
 replace(3216*T*S)with(3216*(T*S))by ring.
 apply clamp_ordered;[unfold T,S;lia|].
 unfold output_loss,pd_loss,T,S in *;nia.
Qed.

Lemma command_numerator_bounds:forall kp kd ki kv ka pe se rs ra ri,
 -(3216*T*S)<=command_num kp kd ki kv ka pe se rs ra ri<=3216*T*S.
Proof. intros;unfold command_num;apply zclamp_bounds;unfold T,S;lia. Qed.

Lemma actual_command_bounds:forall kp kd ki kv ka pe se rs ra ci,
 -3216<=command_z kp kd ki kv ka pe se rs ra ci<=3216.
Proof.
 intros;unfold command_z.
 pose proof(zclamp_bounds 3216(zclamp 1429(ff_z kp kd kv ka pe se rs ra)+
 integral_z kp kd ki pe se ci/65536)ltac:(lia));lia.
Qed.

Print Assumptions exact_cycle_error.
