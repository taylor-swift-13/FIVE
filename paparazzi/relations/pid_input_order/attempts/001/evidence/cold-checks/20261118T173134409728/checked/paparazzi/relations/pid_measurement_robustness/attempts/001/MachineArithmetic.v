From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib Integers Floats.
From PidPositionTranslationCore Require Import CoreSemantics ClampSemantics FlightSemantics ControllerPrefix.
From PidPositionTranslationAttempt002 Require Import ClampSemantics.
From CoreCBMC Require Import NumericBounds FloatBounds.
From PidMeasurementAttempt001 Require Import IntegerBounds.
Open Scope Z_scope.

Definition pd_z (kp kd pe se:Z) : Z := kp*pe/64 + kd*(se/4)/32768.
Definition ff_z (kp kd kv ka pe se rs ra:Z) : Z :=
 pd_z kp kd pe se + kv*rs/131072 + ka*ra/256.
Definition integral_z (kp kd ki pe se old:Z) : Z :=
 zclamp 93650944 (old + ki * pd_z kp kd pe se).
Definition command_z (kp kd ki kv ka pe se rs ra old:Z) : Z :=
 zclamp 3216 (zclamp 1429 (ff_z kp kd kv ka pe se rs ra)
                 + integral_z kp kd ki pe se old/65536).

Lemma signed_clip : forall x c,
 0<=c<=2147483647 ->
 Int.signed(clip_bits x (Int.repr c))=zclamp c (Int.signed x).
Proof.
 intros x c C.
 assert(P:Int.signed(Int.repr c)=c)by(apply Int.signed_repr;change(-2147483648<=c<=2147483647);lia).
 assert(N:Int.signed(Int.neg(Int.repr c))= -c).
 { rewrite Int.neg_repr,Int.signed_repr;[reflexivity|change(-2147483648<= -c<=2147483647);lia]. }
 unfold clip_bits,Int.lt;rewrite P,N.
 destruct(zlt(Int.signed x)(-c))as[L|L].
 - rewrite N;unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_l by lia;reflexivity.
 - destruct(zlt c(Int.signed x))as[H|H].
   + rewrite P;unfold zclamp;rewrite Z.min_l by lia;rewrite Z.max_r by lia;reflexivity.
   + unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_r by lia;reflexivity.
Qed.

Lemma front_clamp_signed : forall x c,
 0<=c<=2147483647 ->
 Int.signed(PidPositionTranslationAttempt002.ClampSemantics.clamp_bits x (Int.repr c))=
 zclamp c (Int.signed x).
Proof.
 intros x c C.
 assert(P:Int.signed(Int.repr c)=c)by(apply Int.signed_repr;change(-2147483648<=c<=2147483647);lia).
 assert(N:Int.signed(Int.neg(Int.repr c))= -c).
 { rewrite Int.neg_repr,Int.signed_repr;[reflexivity|change(-2147483648<= -c<=2147483647);lia]. }
 unfold PidPositionTranslationAttempt002.ClampSemantics.clamp_bits.
 destruct(Float.cmp Clt(Float.of_int x)(Float.of_int(Int.neg(Int.repr c))))eqn:L.
 - apply double_integer_clt in L;rewrite N in L;rewrite N.
   unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_l by lia;reflexivity.
 - assert(LO: -c<=Int.signed x).
   { destruct(Z_lt_ge_dec(Int.signed x)(-c));[|lia].
     assert(T:Float.cmp Clt(Float.of_int x)(Float.of_int(Int.neg(Int.repr c)))=true)
       by(apply double_integer_clt;rewrite N;lia).
     congruence. }
   destruct(Float.cmp Cgt(Float.of_int x)(Float.of_int(Int.repr c)))eqn:H.
   + apply double_integer_cgt in H;rewrite P in H;rewrite P.
     unfold zclamp;rewrite Z.min_l by lia;rewrite Z.max_r by lia;reflexivity.
   + assert(HI:Int.signed x<=c).
     { destruct(Z_lt_ge_dec c(Int.signed x));[|lia].
       assert(T:Float.cmp Cgt(Float.of_int x)(Float.of_int(Int.repr c))=true)
         by(apply double_integer_cgt;rewrite P;lia).
       congruence. }
     unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_r by lia;reflexivity.
Qed.

Lemma pd_machine_exact : forall kp kd ki kv ka pe se rs ra old,
 axis_bounds kp kd ki kv ka pe se rs ra old ->
 Int.signed(pd_bits kp kd pe se)=
 pd_z(Int.signed kp)(Int.signed kd)(Int.signed pe)(Int.signed se).
Proof.
 intros kp kd ki kv ka pe se rs ra old B.
 pose proof(original_axis_arithmetic_safe kp kd ki kv ka pe se rs ra old B)as S.
 destruct S as[PK DK PA VK VA AK FA IK IA CA].
 unfold pd_bits,pd_z.
 rewrite(signed_add_exact _ _ PA).
 rewrite(signed_shift_exact _ (Int.repr 6) 64 ltac:(lia)eq_refl).
 rewrite(signed_shift_exact _ (Int.repr 15) 32768 ltac:(lia)eq_refl).
 rewrite(signed_mul_exact _ _ PK),(signed_mul_exact _ _ DK).
 rewrite(signed_shift_exact _ (Int.repr 2) 4 ltac:(lia)eq_refl).
 reflexivity.
Qed.

Lemma ff_machine_exact : forall kp kd ki kv ka pe se rs ra old,
 axis_bounds kp kd ki kv ka pe se rs ra old ->
 Int.signed(feedforward_bits(pd_bits kp kd pe se)kv rs ka ra)=
 ff_z(Int.signed kp)(Int.signed kd)(Int.signed kv)(Int.signed ka)
     (Int.signed pe)(Int.signed se)(Int.signed rs)(Int.signed ra).
Proof.
 intros kp kd ki kv ka pe se rs ra old B.
 pose proof(original_axis_arithmetic_safe kp kd ki kv ka pe se rs ra old B)as S.
 destruct S as[PK DK PA VK VA AK FA IK IA CA].
 unfold velocity_stage,pd_stage in FA,VA.
 unfold feedforward_bits,ff_z.
 rewrite(signed_add_exact _ _ FA),(signed_add_exact _ _ VA).
 rewrite(signed_shift_exact _ (Int.repr 17) 131072 ltac:(lia)eq_refl).
 rewrite(signed_shift_exact _ (Int.repr 8) 256 ltac:(lia)eq_refl).
 rewrite(signed_mul_exact _ _ VK),(signed_mul_exact _ _ AK).
 rewrite(pd_machine_exact kp kd ki kv ka pe se rs ra old B).
 reflexivity.
Qed.

Lemma integral_machine_exact : forall kp kd ki kv ka pe se rs ra old,
 axis_bounds kp kd ki kv ka pe se rs ra old ->
 Int.signed(next_integral true old ki(pd_bits kp kd pe se)(Int.repr 1429))=
 integral_z(Int.signed kp)(Int.signed kd)(Int.signed ki)
           (Int.signed pe)(Int.signed se)(Int.signed old).
Proof.
 intros kp kd ki kv ka pe se rs ra old B.
 pose proof(original_axis_arithmetic_safe kp kd ki kv ka pe se rs ra old B)as S.
 destruct S as[PK DK PA VK VA AK FA IK IA CA].
 unfold pd_stage in IA,IK.
 unfold next_integral;rewrite trajectory_high_resolution.
 rewrite signed_clip by lia.
 rewrite(signed_add_exact _ _ IA),(signed_mul_exact _ _ IK).
 rewrite(pd_machine_exact kp kd ki kv ka pe se rs ra old B).
 reflexivity.
Qed.

Theorem axis_machine_exact : forall kp kd ki kv ka pe se rs ra old,
 axis_bounds kp kd ki kv ka pe se rs ra old ->
 Int.signed(next_integral true old ki(pd_bits kp kd pe se)(Int.repr 1429))=
 integral_z(Int.signed kp)(Int.signed kd)(Int.signed ki)
           (Int.signed pe)(Int.signed se)(Int.signed old) /\
 Int.signed(controller_command true kp kd ki kv ka pe se rs ra old(Int.repr 1429)(Int.repr 3216))=
 command_z(Int.signed kp)(Int.signed kd)(Int.signed ki)(Int.signed kv)(Int.signed ka)
          (Int.signed pe)(Int.signed se)(Int.signed rs)(Int.signed ra)(Int.signed old).
Proof.
 intros kp kd ki kv ka pe se rs ra old B.
 split;[exact(integral_machine_exact kp kd ki kv ka pe se rs ra old B)|].
 pose proof(original_axis_arithmetic_safe kp kd ki kv ka pe se rs ra old B)as S.
 destruct S as[PK DK PA VK VA AK FA IK IA CA].
 unfold controller_command,next_command.
 rewrite signed_clip by lia.
 change(signed32(Int.signed(after_feedforward kp kd kv ka pe se rs ra(Int.repr 1429))+Int.signed(Int.shr(next_integral true old ki(pd_bits kp kd pe se)(Int.repr 1429))(Int.repr 16))))in CA.
 rewrite(signed_add_exact _ _ CA).
 rewrite(signed_shift_exact _ (Int.repr 16) 65536 ltac:(lia)eq_refl).
 rewrite(integral_machine_exact kp kd ki kv ka pe se rs ra old B).
 unfold after_feedforward.
 rewrite signed_clip by lia.
 rewrite(ff_machine_exact kp kd ki kv ka pe se rs ra old B).
 reflexivity.
Qed.

Print Assumptions axis_machine_exact.

Print Assumptions front_clamp_signed.
