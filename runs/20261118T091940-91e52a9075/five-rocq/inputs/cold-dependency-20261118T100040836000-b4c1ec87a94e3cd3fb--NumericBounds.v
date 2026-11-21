From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib Integers.
From PidPositionTranslationCore Require Import CoreSemantics ClampSemantics FlightSemantics ControllerPrefix.
Open Scope Z_scope.
Definition signed32(z:Z):Prop:=-2147483648<=z<=2147483647.
Definition int_bound(x:int)(bound:Z):Prop:=-bound<=Int.signed x<=bound.
Lemma signed_mul_exact:forall a b,
 signed32(Int.signed a*Int.signed b) ->
 Int.signed(Int.mul a b)=Int.signed a*Int.signed b.
Proof. intros;rewrite Int.mul_signed,Int.signed_repr;[reflexivity|exact H]. Qed.
Lemma signed_add_exact:forall a b,
 signed32(Int.signed a+Int.signed b) ->
 Int.signed(Int.add a b)=Int.signed a+Int.signed b.
Proof. intros;rewrite Int.add_signed,Int.signed_repr;[reflexivity|exact H]. Qed.
Lemma signed_shift_exact:forall x sh d,
 0<d ->two_p(Int.unsigned sh)=d ->
 Int.signed(Int.shr x sh)=Int.signed x/d.
Proof.
 intros x sh d POS POWER;rewrite Int.shr_div_two_p,POWER,Int.signed_repr;[reflexivity|].
 pose proof(Int.signed_range x)as XR;change(-2147483648<=Int.signed x<=2147483647)in XR.
 change(-2147483648<=Int.signed x/d<=2147483647);split.
 - apply Z.div_le_lower_bound;nia.
 - apply Z.div_le_upper_bound;nia.
Qed.
Lemma shift_bound:forall x sh d bound out,
 int_bound x bound ->0<d ->two_p(Int.unsigned sh)=d ->
 -out<=(-bound)/d ->bound/d<=out ->
 int_bound(Int.shr x sh)out.
Proof.
 intros x sh d bound out B POS POWER LOW HIGH;unfold int_bound in *.
 rewrite(signed_shift_exact x sh d POS POWER);split.
 - eapply Z.le_trans with(m:=(-bound)/d);[lia|apply Z.div_le_mono;lia].
 - eapply Z.le_trans with(m:=bound/d);[apply Z.div_le_mono;lia|exact HIGH].
Qed.
Lemma clamp_bound:forall v maximum,
 0<=maximum<=2147483647 ->
 int_bound(clip_bits v(Int.repr maximum))maximum.
Proof.
 intros v maximum RANGE;unfold clip_bits,int_bound.
 assert(SP:Int.signed(Int.repr maximum)=maximum)by(apply Int.signed_repr;change(-2147483648<=maximum<=2147483647);lia).
 assert(SN:Int.signed(Int.neg(Int.repr maximum))= -maximum).
 { rewrite Int.neg_repr,Int.signed_repr;[reflexivity|change(-2147483648<= -maximum<=2147483647);lia]. }
 destruct(Int.lt v(Int.neg(Int.repr maximum)))eqn:LOW.
 - rewrite SN;lia.
 - destruct(Int.lt(Int.repr maximum)v)eqn:HIGH.
   + rewrite SP;lia.
   + unfold Int.lt in LOW,HIGH;rewrite SN in LOW;rewrite SP in HIGH.
     destruct(zlt(Int.signed v)(-maximum));try discriminate.
     destruct(zlt maximum(Int.signed v));try discriminate;lia.
Qed.
Lemma gain_product_bound:forall gain x bound,
 0<=Int.signed gain<=100 ->int_bound x bound ->0<=bound ->
 100*bound<=2147483647 ->
 int_bound(Int.mul gain x)(100*bound) /\signed32(Int.signed gain*Int.signed x).
Proof.
 intros gain x bound G X B CAP;unfold int_bound,signed32 in *.
 assert(R:-100*bound<=Int.signed gain*Int.signed x<=100*bound)by nia.
 assert(SAFE:signed32(Int.signed gain*Int.signed x))by(unfold signed32;lia).
 split;[rewrite(signed_mul_exact gain x SAFE);lia|exact SAFE].
Qed.
Lemma bounded_sum:forall a b ba bb,
 int_bound a ba ->int_bound b bb ->0<=ba ->0<=bb ->ba+bb<=2147483647 ->
 int_bound(Int.add a b)(ba+bb) /\signed32(Int.signed a+Int.signed b).
Proof.
 intros a b ba bb A B PA PB CAP;unfold int_bound,signed32 in *.
 assert(SAFE:signed32(Int.signed a+Int.signed b))by(unfold signed32;lia).
 split;[rewrite(signed_add_exact a b SAFE);lia|exact SAFE].
Qed.
Lemma trajectory_high_resolution:
 Int.shl(Int.repr 1429)(Int.repr 16)=Int.repr 93650944.
Proof. reflexivity. Qed.

Record axis_bounds(kp kd ki kv ka pe se rs ra initial_i:int):Prop:={
 bound_kp:0<=Int.signed kp<=100;bound_kd:0<=Int.signed kd<=100;
 bound_ki:0<=Int.signed ki<=100;bound_kv:0<=Int.signed kv<=100;bound_ka:0<=Int.signed ka<=100;
 bound_pe:int_bound pe 4096;bound_se:int_bound se 8388608;
 bound_rs:int_bound rs 10000;bound_ra:int_bound ra 10000;bound_initial_i:int_bound initial_i 100000000
}.
Definition pd_stage(kp kd pe se:int):int:=pd_bits kp kd pe se.
Definition velocity_stage(kp kd kv pe se rs:int):int:=
 Int.add(pd_stage kp kd pe se)(Int.shr(Int.mul kv rs)(Int.repr 17)).
Definition feedforward_stage(kp kd kv ka pe se rs ra:int):int:=
 feedforward_bits(pd_stage kp kd pe se)kv rs ka ra.
Definition integral_sum(kp kd ki pe se initial_i:int):int:=
 Int.add initial_i(Int.mul ki(pd_stage kp kd pe se)).
Definition integral_trim(kp kd ki pe se initial_i:int):int:=
 clip_bits(integral_sum kp kd ki pe se initial_i)(Int.shl(Int.repr 1429)(Int.repr 16)).
Definition command_before_total(kp kd ki kv ka pe se rs ra initial_i:int):int:=
 Int.add(clip_bits(feedforward_stage kp kd kv ka pe se rs ra)(Int.repr 1429))
 (Int.shr(integral_trim kp kd ki pe se initial_i)(Int.repr 16)).

Theorem original_axis_intermediate_bounds:forall kp kd ki kv ka pe se rs ra initial_i,
 axis_bounds kp kd ki kv ka pe se rs ra initial_i ->
 int_bound(pd_stage kp kd pe se)12800 /\
 int_bound(velocity_stage kp kd kv pe se rs)12808 /\
 int_bound(feedforward_stage kp kd kv ka pe se rs ra)16715 /\
 int_bound(integral_sum kp kd ki pe se initial_i)101280000 /\
 int_bound(integral_trim kp kd ki pe se initial_i)93650944 /\
 int_bound(command_before_total kp kd ki kv ka pe se rs ra initial_i)2858.
Proof.
 intros kp kd ki kv ka pe se rs ra initial_i D;destruct D as[KP KD KI KV KA PE SE RS RA II].
 destruct(gain_product_bound kp pe 4096 KP PE ltac:(lia)ltac:(lia))as[PM PMOK].
 assert(PS:int_bound(Int.shr(Int.mul kp pe)(Int.repr 6))6400).
 { eapply shift_bound with(d:=64)(bound:=409600);[exact PM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 assert(SS:int_bound(Int.shr se(Int.repr 2))2097152).
 { eapply shift_bound with(d:=4)(bound:=8388608);[exact SE|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(gain_product_bound kd _ 2097152 KD SS ltac:(lia)ltac:(lia))as[DM DMOK].
 assert(DS:int_bound(Int.shr(Int.mul kd(Int.shr se(Int.repr 2)))(Int.repr 15))6400).
 { eapply shift_bound with(d:=32768)(bound:=209715200);[exact DM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 6400 6400 PS DS ltac:(lia)ltac:(lia)ltac:(lia))as[PD PDOK].
 change(int_bound(pd_stage kp kd pe se)12800)in PD.
 destruct(gain_product_bound kv rs 10000 KV RS ltac:(lia)ltac:(lia))as[VM VMOK].
 assert(VS:int_bound(Int.shr(Int.mul kv rs)(Int.repr 17))8).
 { eapply shift_bound with(d:=131072)(bound:=1000000);[exact VM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 12800 8 PD VS ltac:(lia)ltac:(lia)ltac:(lia))as[PV PVOK].
 change(int_bound(velocity_stage kp kd kv pe se rs)12808)in PV.
 destruct(gain_product_bound ka ra 10000 KA RA ltac:(lia)ltac:(lia))as[AM AMOK].
 assert(AS:int_bound(Int.shr(Int.mul ka ra)(Int.repr 8))3907).
 { eapply shift_bound with(d:=256)(bound:=1000000);[exact AM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 12808 3907 PV AS ltac:(lia)ltac:(lia)ltac:(lia))as[FF FFOK].
 change(int_bound(feedforward_stage kp kd kv ka pe se rs ra)16715)in FF.
 destruct(gain_product_bound ki _ 12800 KI PD ltac:(lia)ltac:(lia))as[IM IMOK].
 destruct(bounded_sum _ _ 100000000 1280000 II IM ltac:(lia)ltac:(lia)ltac:(lia))as[IS ISOK].
 change(int_bound(integral_sum kp kd ki pe se initial_i)101280000)in IS.
 assert(IT:int_bound(integral_trim kp kd ki pe se initial_i)93650944).
 { unfold integral_trim;rewrite trajectory_high_resolution;apply clamp_bound;lia. }
 assert(ISH:int_bound(Int.shr(integral_trim kp kd ki pe se initial_i)(Int.repr 16))1429).
 { eapply shift_bound with(d:=65536)(bound:=93650944);[exact IT|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 assert(TR:int_bound(clip_bits(feedforward_stage kp kd kv ka pe se rs ra)(Int.repr 1429))1429)
 by(apply clamp_bound;lia).
 destruct(bounded_sum _ _ 1429 1429 TR ISH ltac:(lia)ltac:(lia)ltac:(lia))as[OUT OUTOK].
 change(int_bound(command_before_total kp kd ki kv ka pe se rs ra initial_i)2858)in OUT.
 split;[exact PD|];split;[exact PV|];split;[exact FF|];split;[exact IS|];split;[exact IT|exact OUT].
Qed.
Print Assumptions original_axis_intermediate_bounds.

Record axis_arithmetic_safe(kp kd ki kv ka pe se rs ra initial_i:int):Prop:={
 safe_kp_product:signed32(Int.signed kp*Int.signed pe);
 safe_kd_product:signed32(Int.signed kd*Int.signed(Int.shr se(Int.repr 2)));
 safe_pd_add:signed32(Int.signed(Int.shr(Int.mul kp pe)(Int.repr 6))+
  Int.signed(Int.shr(Int.mul kd(Int.shr se(Int.repr 2)))(Int.repr 15)));
 safe_kv_product:signed32(Int.signed kv*Int.signed rs);
 safe_velocity_add:signed32(Int.signed(pd_stage kp kd pe se)+Int.signed(Int.shr(Int.mul kv rs)(Int.repr 17)));
 safe_ka_product:signed32(Int.signed ka*Int.signed ra);
 safe_feedforward_add:signed32(Int.signed(velocity_stage kp kd kv pe se rs)+Int.signed(Int.shr(Int.mul ka ra)(Int.repr 8)));
 safe_ki_product:signed32(Int.signed ki*Int.signed(pd_stage kp kd pe se));
 safe_integral_add:signed32(Int.signed initial_i+Int.signed(Int.mul ki(pd_stage kp kd pe se)));
 safe_command_add:signed32(Int.signed(clip_bits(feedforward_stage kp kd kv ka pe se rs ra)(Int.repr 1429))+
  Int.signed(Int.shr(integral_trim kp kd ki pe se initial_i)(Int.repr 16)))
}.
Theorem original_axis_arithmetic_safe:forall kp kd ki kv ka pe se rs ra initial_i,
 axis_bounds kp kd ki kv ka pe se rs ra initial_i ->
 axis_arithmetic_safe kp kd ki kv ka pe se rs ra initial_i.
Proof.
 intros kp kd ki kv ka pe se rs ra initial_i D;destruct D as[KP KD KI KV KA PE SE RS RA II].
 destruct(gain_product_bound kp pe 4096 KP PE ltac:(lia)ltac:(lia))as[PM PMOK].
 assert(PS:int_bound(Int.shr(Int.mul kp pe)(Int.repr 6))6400).
 { eapply shift_bound with(d:=64)(bound:=409600);[exact PM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 assert(SS:int_bound(Int.shr se(Int.repr 2))2097152).
 { eapply shift_bound with(d:=4)(bound:=8388608);[exact SE|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(gain_product_bound kd _ 2097152 KD SS ltac:(lia)ltac:(lia))as[DM DMOK].
 assert(DS:int_bound(Int.shr(Int.mul kd(Int.shr se(Int.repr 2)))(Int.repr 15))6400).
 { eapply shift_bound with(d:=32768)(bound:=209715200);[exact DM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 6400 6400 PS DS ltac:(lia)ltac:(lia)ltac:(lia))as[PD PDOK].
 change(int_bound(pd_stage kp kd pe se)12800)in PD.
 destruct(gain_product_bound kv rs 10000 KV RS ltac:(lia)ltac:(lia))as[VM VMOK].
 assert(VS:int_bound(Int.shr(Int.mul kv rs)(Int.repr 17))8).
 { eapply shift_bound with(d:=131072)(bound:=1000000);[exact VM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 12800 8 PD VS ltac:(lia)ltac:(lia)ltac:(lia))as[PV PVOK].
 change(int_bound(velocity_stage kp kd kv pe se rs)12808)in PV.
 destruct(gain_product_bound ka ra 10000 KA RA ltac:(lia)ltac:(lia))as[AM AMOK].
 assert(AS:int_bound(Int.shr(Int.mul ka ra)(Int.repr 8))3907).
 { eapply shift_bound with(d:=256)(bound:=1000000);[exact AM|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum _ _ 12808 3907 PV AS ltac:(lia)ltac:(lia)ltac:(lia))as[FF FFOK].
 change(int_bound(feedforward_stage kp kd kv ka pe se rs ra)16715)in FF.
 destruct(gain_product_bound ki _ 12800 KI PD ltac:(lia)ltac:(lia))as[IM IMOK].
 destruct(bounded_sum _ _ 100000000 1280000 II IM ltac:(lia)ltac:(lia)ltac:(lia))as[IS ISOK].
 change(int_bound(integral_sum kp kd ki pe se initial_i)101280000)in IS.
 assert(IT:int_bound(integral_trim kp kd ki pe se initial_i)93650944).
 { unfold integral_trim;rewrite trajectory_high_resolution;apply clamp_bound;lia. }
 assert(ISH:int_bound(Int.shr(integral_trim kp kd ki pe se initial_i)(Int.repr 16))1429).
 { eapply shift_bound with(d:=65536)(bound:=93650944);[exact IT|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 assert(TR:int_bound(clip_bits(feedforward_stage kp kd kv ka pe se rs ra)(Int.repr 1429))1429)
 by(apply clamp_bound;lia).
 destruct(bounded_sum _ _ 1429 1429 TR ISH ltac:(lia)ltac:(lia)ltac:(lia))as[OUT OUTOK].
 change(int_bound(command_before_total kp kd ki kv ka pe se rs ra initial_i)2858)in OUT.
 constructor;[exact PMOK|exact DMOK|exact PDOK|exact VMOK|exact PVOK|
 exact AMOK|exact FFOK|exact IMOK|exact ISOK|exact OUTOK].
Qed.
Print Assumptions original_axis_arithmetic_safe.
