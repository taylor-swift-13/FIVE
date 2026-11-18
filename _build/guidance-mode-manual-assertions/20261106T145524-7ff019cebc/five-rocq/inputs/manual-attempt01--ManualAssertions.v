From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Integers Floats Values Memory Events Csem.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry SpeedEntry AccelEntry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import EntryCorollaries Unconditional.
Import ListNotations.
Local Open Scope Z_scope.
Definition delta_or_zero(v timestep:float32):int64:=match pos_increment v timestep with Some d=>d|None=>Int64.zero end.
Definition expected_integrated(s:state):state:=integrated s(delta_or_zero(speed_x s)(dt s))(delta_or_zero(speed_y s)(dt s)).
Definition speed_expected(s:state)(sp:vector):state:=
 with_accel(expected_integrated s)(saturate fixed_maximum(raw_speed_accel(expected_integrated s)sp)).
Definition accel_expected(s:state)(a:vector):state:=with_accel(expected_integrated s)(saturate fixed_maximum a).
Lemma expected_integrate:forall s,integration_safe s->integrate s=Some(expected_integrated s).
Proof.
 intros s[dx[dy[X[Y REST]]]];unfold integrate,expected_integrated,delta_or_zero;rewrite X,Y;reflexivity.
Qed.
Lemma speed_expected_update:forall s sp,integration_safe s->speed_update fixed_maximum s sp=Some(speed_expected s sp).
Proof. intros s sp SAFE;unfold speed_update;rewrite(expected_integrate s SAFE);reflexivity. Qed.
Lemma accel_expected_update:forall s a,integration_safe s->accel_update fixed_maximum s a=Some(accel_expected s a).
Proof. intros s a SAFE;unfold accel_update;rewrite(expected_integrate s SAFE);reflexivity. Qed.
Lemma speed_expected_config:forall s sp,config(speed_expected s sp)=config s.
Proof. reflexivity. Qed.
Lemma accel_expected_config:forall s a,config(accel_expected s a)=config s.
Proof. reflexivity. Qed.
Definition float_bits_load(m:mem)(b:block)(offset:Z)(expected:float32):Prop:=
 exists actual,Mem.load Mfloat32 m b offset=Some(Vsingle actual)/\Float32.to_bits actual=Float32.to_bits expected.
Definition parameter_memory_bits(old:state)(m:mem)(b:block):Prop:=
 float_bits_load m b 32(tau old)/\float_bits_load m b 36(omega old)/\
 float_bits_load m b 40(zeta old)/\float_bits_load m b 44(max_speed old)/\
 float_bits_load m b 48(zeta_omega old)/\float_bits_load m b 52(omega_2 old)/\
 float_bits_load m b 56(inv_tau old)/\float_bits_load m b 60(dt old).
Definition manual_observation(index:nat)(old expected:state)(m:mem)(b:block):Prop:=
 match index with
 |1%nat=>Mem.load Mint64 m b 16=Some(Vlong(pos_x expected))
 |2%nat=>float_bits_load m b 8(speed_x expected)
 |3%nat=>float_bits_load m b 0(accel_x expected)
 |4%nat=>Mem.load Mint64 m b 24=Some(Vlong(pos_y expected))
 |5%nat=>float_bits_load m b 12(speed_y expected)
 |6%nat=>float_bits_load m b 4(accel_y expected)
 |7%nat=>parameter_memory_bits old m b
 |_=>False end.
Lemma repr_parameter_memory_bits:forall old expected m b,
 repr expected m b->config expected=config old->parameter_memory_bits old m b.
Proof.
 intros old expected m b REP CFG;destruct old;destruct expected;cbn[config]in CFG;inversion CFG;subst.
 unfold repr in REP;cbn in REP;repeat match goal with H:_ /\ _|-_=>destruct H end.
 unfold parameter_memory_bits,float_bits_load;cbn;repeat split;eexists;split;[eassumption|reflexivity].
Qed.
Lemma repr_manual_observation:forall index old expected m b,
 (1<=index<=7)%nat->repr expected m b->config expected=config old->manual_observation index old expected m b.
Proof.
 intros index old expected m b RANGE REP CFG;pose proof REP as R.
 unfold repr in R;repeat match goal with H:_ /\ _|-_=>destruct H end.
 assert(CASES:index=1%nat\/index=2%nat\/index=3%nat\/index=4%nat\/index=5%nat\/index=6%nat\/index=7%nat)by lia.
 repeat destruct CASES as[EQ|CASES];try(rename CASES into EQ);subst index;cbn[manual_observation];
 first[assumption|eexists;split;[eassumption|reflexivity]|eapply repr_parameter_memory_bits;eauto].
Qed.
Definition fsix:float32:=Float32.of_bits(Int.repr 1086324736).
Definition fnegative_small:float32:=Float32.of_bits(Int.repr 3154116608).
Definition fsaturated:float32:=Float32.of_bits(Int.repr 1092608000).
Definition fnegative_zero:float32:=Float32.of_bits(Int.repr 2147483648).
Definition speed_scenario(index:nat):vector:=if Nat.leb index 7 then vec fone fzero else vec fsix fzero.
Definition accel_scenario(index:nat):vector:=if Nat.leb index 7 then vec fnegative_small fnegative_zero else vec fsaturated fnegative_zero.
Definition observation_index(index:nat):nat:=if Nat.leb index 7 then index else index-7.
Lemma observation_index_range:forall index,(1<=index<=14)%nat->(1<=observation_index index<=7)%nat.
Proof. intros index RANGE;unfold observation_index;destruct(Nat.leb index 7)eqn:L;[apply Nat.leb_le in L|apply Nat.leb_gt in L];lia. Qed.
Definition manual_speed_id(index:nat):Prop:=forall s m bg src o,
 speed_initial s(speed_scenario index)m bg src o->
 exists mf,
 speed_call m src o mf /\
 manual_observation(observation_index index)s(speed_expected s(speed_scenario index))mf bg /\
 forall final,speed_call m src o final->manual_observation(observation_index index)s(speed_expected s(speed_scenario index))final bg.
Definition manual_accel_id(index:nat):Prop:=forall s m bg src o,
 accel_initial s(accel_scenario index)m bg src o->
 exists mf,
 accel_call m src o mf /\
 manual_observation(observation_index index)s(accel_expected s(accel_scenario index))mf bg /\
 forall final,accel_call m src o final->manual_observation(observation_index index)s(accel_expected s(accel_scenario index))final bg.
Theorem manual_speed_assertions:forall index,(1<=index<=14)%nat->manual_speed_id index.
Proof.
 intros index RANGE s m bg src o INIT.
 assert(SAFE:integration_safe s)by(destruct INIT as[_[_[_[H REST]]]];exact H).
 pose proof(speed_expected_update s(speed_scenario index)SAFE)as UPDATE.
 destruct(speed_entry_normal speed_sqrt_contract s(speed_scenario index)m bg src o INIT)
 as[sf[mf[UP[PATH[REP REST]]]]].
 rewrite UPDATE in UP;injection UP as EQ;subst sf.
 exists mf;split;[exists E0,Vundef;exact PATH|];split.
 - apply repr_manual_observation;[apply observation_index_range;exact RANGE|exact REP|apply speed_expected_config].
 - intros final CALL;destruct(speed_all_returns_given_software speed_sqrt_contract s(speed_scenario index)m bg src o INIT final CALL)as[sf[UP REPFINAL]].
   rewrite UPDATE in UP;injection UP as EQ;subst sf.
   apply repr_manual_observation;[apply observation_index_range;exact RANGE|exact REPFINAL|apply speed_expected_config].
Qed.
Theorem manual_accel_assertions:forall index,(1<=index<=14)%nat->manual_accel_id index.
Proof.
 intros index RANGE s m bg src o INIT.
 assert(SAFE:integration_safe s)by(destruct INIT as[_[_[_[H REST]]]];exact H).
 pose proof(accel_expected_update s(accel_scenario index)SAFE)as UPDATE.
 destruct(accel_entry_normal accel_sqrt_contract s(accel_scenario index)m bg src o INIT)
 as[sf[mf[UP[PATH[REP REST]]]]].
 rewrite UPDATE in UP;injection UP as EQ;subst sf.
 exists mf;split;[exists E0,Vundef;exact PATH|];split.
 - apply repr_manual_observation;[apply observation_index_range;exact RANGE|exact REP|apply accel_expected_config].
 - intros final CALL;destruct(accel_all_returns_given_software accel_sqrt_contract s(accel_scenario index)m bg src o INIT final CALL)as[sf[UP REPFINAL]].
   rewrite UPDATE in UP;injection UP as EQ;subst sf.
   apply repr_manual_observation;[apply observation_index_range;exact RANGE|exact REPFINAL|apply accel_expected_config].
Qed.
Print Assumptions manual_speed_assertions.
Print Assumptions manual_accel_assertions.
