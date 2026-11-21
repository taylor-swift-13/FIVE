From Stdlib Require Import ZArith Lia Psatz QArith Qminmax.
From PidMeasurementAttempt001 Require Import IntegerBounds.
From PidQuantizationAttempt001 Require Import ExactArithmetic.
Open Scope Q_scope.

(** A Q value is an exact mathematical rational.  No Q operation rounds. *)
Definition decode(num:Z)(den:positive):Q:=num#den.
Definition decode_integral(num:Z):Q:=decode num 131072.
Definition decode_command(num:Z):Q:=decode num 8589934592.
Definition qclip(limit value:Q):Q:=
 if Qle_bool value(-limit) then -limit
 else if Qle_bool limit value then limit else value.
Definition exact_pd(kp kd pe se:Z):Q:=
 inject_Z kp*inject_Z pe/64+inject_Z kd*(inject_Z se/4)/32768.
Definition exact_total(kp kd kv ka pe se rs ra:Z):Q:=
 exact_pd kp kd pe se+inject_Z kv*inject_Z rs/131072+
 inject_Z ka*inject_Z ra/256.
Definition exact_integral(kp kd ki pe se old_num:Z):Q:=
 qclip 93650944(decode_integral old_num+inject_Z ki*exact_pd kp kd pe se).
Definition exact_command(kp kd ki kv ka pe se rs ra old_num:Z):Q:=
 qclip 3216(qclip 1429(exact_total kp kd kv ka pe se rs ra)+
 exact_integral kp kd ki pe se old_num/65536).

Lemma qclip_respects:forall c x y,x==y ->qclip c x==qclip c y.
Proof.
 intros c x y E;unfold qclip.
 assert(L:Qle_bool x(-c)=Qle_bool y(-c)).
 { destruct(Qle_bool x(-c))eqn:A;destruct(Qle_bool y(-c))eqn:B;auto.
   - apply Qle_bool_iff in A.
     assert(Qle_bool y(-c)=true)by(apply Qle_bool_iff;setoid_rewrite<-E;exact A);congruence.
   - apply Qle_bool_iff in B.
     assert(Qle_bool x(-c)=true)by(apply Qle_bool_iff;setoid_rewrite E;exact B);congruence. }
 assert(H:Qle_bool c x=Qle_bool c y).
 { destruct(Qle_bool c x)eqn:A;destruct(Qle_bool c y)eqn:B;auto.
   - apply Qle_bool_iff in A.
     assert(Qle_bool c y=true)by(apply Qle_bool_iff;setoid_rewrite<-E;exact A);congruence.
   - apply Qle_bool_iff in B.
     assert(Qle_bool c x=true)by(apply Qle_bool_iff;setoid_rewrite E;exact B);congruence. }
 rewrite L,H;destruct(Qle_bool y(-c));[reflexivity|].
 destruct(Qle_bool c y);[reflexivity|exact E].
Qed.

Lemma decode_clamp:forall c num den,(0<=c)%Z ->
 decode(zclamp(c*Z.pos den)num)den==qclip(inject_Z c)(decode num den).
Proof.
 intros c num den C.
 pose proof(Pos2Z.is_pos den)as D.
 unfold qclip.
 destruct(Z_le_dec num(-c*Z.pos den))as[LO|LO].
 - assert(L:Qle_bool(decode num den)(-inject_Z c)=true).
   { apply Qle_bool_iff;unfold Qle,decode,inject_Z;cbn;lia. }
   rewrite L;unfold zclamp.
   rewrite Z.min_r by nia;rewrite Z.max_l by nia.
   unfold Qeq,decode,inject_Z;cbn;ring.
 - assert(L:Qle_bool(decode num den)(-inject_Z c)=false).
   { destruct(Qle_bool(decode num den)(-inject_Z c))eqn:A;auto.
     apply Qle_bool_iff in A;unfold Qle,decode,inject_Z in A;cbn in A;lia. }
   rewrite L.
   destruct(Z_le_dec(c*Z.pos den)num)as[HI|HI].
   + assert(H:Qle_bool(inject_Z c)(decode num den)=true).
     { apply Qle_bool_iff;unfold Qle,decode,inject_Z;cbn;lia. }
     rewrite H;unfold zclamp.
     rewrite Z.min_l by nia;rewrite Z.max_r by nia.
     unfold Qeq,decode,inject_Z;cbn;ring.
   + assert(H:Qle_bool(inject_Z c)(decode num den)=false).
     { destruct(Qle_bool(inject_Z c)(decode num den))eqn:A;auto.
       apply Qle_bool_iff in A;unfold Qle,decode,inject_Z in A;cbn in A;lia. }
     rewrite H;unfold zclamp.
     rewrite Z.min_r by nia;rewrite Z.max_r by nia;reflexivity.
Qed.

Theorem pd_rational_exact:forall kp kd pe se,
 decode_integral(pd_num kp kd pe se)==exact_pd kp kd pe se.
Proof. intros;unfold decode_integral,decode,pd_num,exact_pd,Qeq;cbn -[Z.mul Z.add Z.sub Z.opp];ring. Qed.
Theorem total_rational_exact:forall kp kd kv ka pe se rs ra,
 decode_integral(total_num kp kd kv ka pe se rs ra)==exact_total kp kd kv ka pe se rs ra.
Proof.
 intros;unfold decode_integral,decode,total_num,pd_num,exact_total,exact_pd,Qeq;cbn -[Z.mul Z.add Z.sub Z.opp];ring.
Qed.
Theorem integral_rational_exact:forall kp kd ki pe se old_num,
 decode_integral(integral_num kp kd ki pe se old_num)==exact_integral kp kd ki pe se old_num.
Proof.
 intros;unfold integral_num,decode_integral,T.
 change(decode(zclamp(93650944*Z.pos 131072)(old_num+ki*pd_num kp kd pe se))131072==exact_integral kp kd ki pe se old_num).
 rewrite decode_clamp by lia;unfold exact_integral.
 apply qclip_respects.
 unfold decode_integral,decode,pd_num,exact_pd,Qeq;cbn -[Z.mul Z.add Z.sub Z.opp];ring.
Qed.
Theorem command_rational_exact:forall kp kd ki kv ka pe se rs ra old_num,
 decode_command(command_num kp kd ki kv ka pe se rs ra old_num)==
 exact_command kp kd ki kv ka pe se rs ra old_num.
Proof.
 intros;unfold command_num,decode_command,T,S.
 change(decode(zclamp(3216*Z.pos 8589934592)
 (65536*zclamp(1429*131072)(total_num kp kd kv ka pe se rs ra)+
 integral_num kp kd ki pe se old_num))8589934592==exact_command kp kd ki kv ka pe se rs ra old_num).
 rewrite decode_clamp by lia;unfold exact_command.
 apply qclip_respects.
 transitivity(decode_integral(zclamp(1429*131072)(total_num kp kd kv ka pe se rs ra))+
 decode_integral(integral_num kp kd ki pe se old_num)/65536).
 - unfold decode_integral,decode,Qeq;cbn -[Z.mul Z.add Z.sub Z.opp];ring.
 - rewrite integral_rational_exact.
   apply Qplus_comp;[|reflexivity].
   unfold decode_integral.
   change(decode(zclamp(1429*Z.pos 131072)(total_num kp kd kv ka pe se rs ra))131072==qclip 1429(exact_total kp kd kv ka pe se rs ra)).
   rewrite decode_clamp by lia.
   apply qclip_respects;apply total_rational_exact.
Qed.

Definition ExactRationalReferenceGoal:Prop:=forall kp kd ki kv ka pe se rs ra old_num,
 decode_integral(pd_num kp kd pe se)==exact_pd kp kd pe se /\
 decode_integral(total_num kp kd kv ka pe se rs ra)==exact_total kp kd kv ka pe se rs ra /\
 decode_integral(integral_num kp kd ki pe se old_num)==exact_integral kp kd ki pe se old_num /\
 decode_command(command_num kp kd ki kv ka pe se rs ra old_num)==
 exact_command kp kd ki kv ka pe se rs ra old_num.
Theorem proved_exact_rational_reference:ExactRationalReferenceGoal.
Proof.
 intros;repeat split;[apply pd_rational_exact|apply total_rational_exact|
 apply integral_rational_exact|apply command_rational_exact].
Qed.

(** The target command's Q12 conversion is exact division by 4096.
    This lemma converts an already proved numerator bound into radians. *)
Theorem radians_error_scaling:forall ci cr b:Z,
 (0<=cr-ci*T*S<=b)%Z ->
 0<=decode cr 35184372088832-inject_Z ci/4096 /\
 decode cr 35184372088832-inject_Z ci/4096<=
 inject_Z b/inject_Z(T*S*4096).
Proof.
 intros ci cr b B;unfold T,S in *.
 change(0<=decode cr 35184372088832-inject_Z ci/4096 /\
 decode cr 35184372088832-inject_Z ci/4096<=inject_Z b/35184372088832).
 split;unfold Qle,decode,inject_Z;cbn -[Z.mul Z.add Z.sub Z.opp].
 all:nia.
Qed.

Print Assumptions pd_rational_exact.
Print Assumptions total_rational_exact.
Print Assumptions integral_rational_exact.
Print Assumptions command_rational_exact.
Print Assumptions proved_exact_rational_reference.
Print Assumptions radians_error_scaling.
