From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Globalenvs.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceRelationSupport Require Import Initialization.

Lemma initialized_matching_pair : forall sp,
 exists ma mb ba bb pa pb,
 speed_initial nontrivial_state sp ma ba pa Ptrofs.zero /\
 accel_initial nontrivial_state(raw_speed_accel nontrivial_integrated sp)mb bb pb Ptrofs.zero.
Proof.
 intros sp.
 destruct SpeedInit.zero_memory as[ms[RS[WS CS]]].
 destruct(nontrivial_memory ms SpeedInit.global_block SpeedInit.maximum_block RS WS SpeedInit.distinct_objects CS)as[ns[RNS[WNS CNS]]].
 destruct(vector_argument_object nontrivial_state ns SpeedInit.global_block SpeedInit.maximum_block sp RNS WNS CNS)as[ma[pa[RA[WA[CA ARGSA]]]]].
 destruct AccelInit.zero_memory as[mc[RC[WC CC]]].
 destruct(nontrivial_memory mc AccelInit.global_block AccelInit.maximum_block RC WC AccelInit.distinct_objects CC)as[nc[RNC[WNC CNC]]].
 destruct(vector_argument_object nontrivial_state nc AccelInit.global_block AccelInit.maximum_block(raw_speed_accel nontrivial_integrated sp)RNC WNC CNC)as[mb[pb[RB[WB[CB ARGAB]]]]].
 exists ma,mb,SpeedInit.global_block,AccelInit.global_block,pa,pb;split.
 - unfold speed_initial;split;[exact RA|]. split;[exact WA|]. split;[exact ARGSA|].
   split;[exact nontrivial_safe|]. split;[exact SpeedInit.global_symbol|].
   exists SpeedInit.maximum_block;split;[exact SpeedInit.maximum_symbol|exact CA].
 - unfold accel_initial;split;[exact RB|]. split;[exact WB|]. split;[exact ARGAB|].
   split;[exact nontrivial_safe|]. split;[exact AccelInit.global_symbol|].
   exists AccelInit.maximum_block;split;[exact AccelInit.maximum_symbol|exact CB].
Qed.
Lemma branch_witness : forall sp taken,
 saturation_branch fixed_maximum(raw_speed_accel nontrivial_integrated sp)=taken ->
 BranchWitness taken.
Proof.
 intros sp taken BRANCH.
 destruct(initialized_matching_pair sp)as[ma[mb[ba[bb[pa[pb[IA IB]]]]]]].
 exists nontrivial_state,sp,(raw_speed_accel nontrivial_integrated sp),ma,mb,ba,bb,pa,pb,Ptrofs.zero,Ptrofs.zero.
 split;[exact IA|]. split;[exact IB|]. split.
 - exists nontrivial_integrated;split;[exact nontrivial_integration|reflexivity].
 - split;[exact BRANCH|]. split;[exact nontrivial_position_advance|exact nontrivial_speed_advance].
Qed.
Theorem nontrivial_witnesses : NontrivialWitnesses.
Proof.
 split;[eapply branch_witness;exact nontrivial_unsaturated|
 eapply branch_witness;exact nontrivial_saturated].
Qed.
Print Assumptions initialized_matching_pair.
Print Assumptions nontrivial_witnesses.
