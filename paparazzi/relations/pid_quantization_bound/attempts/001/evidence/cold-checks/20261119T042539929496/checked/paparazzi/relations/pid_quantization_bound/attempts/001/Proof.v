From Stdlib Require Import List ZArith Lia Psatz.
From compcert Require Import AST Integers Values Memory.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import NormalReturn MainGoals.
From CoreCBMC Require Import NumericBounds.
From PidMeasurementProblem Require Import Spec.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic SemanticBridge.
From PidQuantizationAttempt001 Require Import ExactArithmetic RationalReference WitnessBridge.
From PidQuantizationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.

Theorem one_cycle_observed:forall axis gh ret g a j q x m distance,
 In axis[P._x;P._y] ->IntegralGap axis a j distance ->
 EnvironmentStep gh a q ->CycleInput axis gh ret g q x ->
 NormalCall gh ret true q m ->
 IntegralGap axis m(ref_integral g x j)
 (distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))) /\
 CommandGap axis ret m(Some(ref_command g x j))
 (output_loss(Int.signed(gain_d g))+distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))).
Proof.
 intros axis gh ret g a j q x m distance AX INITIAL ENV INPUT CALL.
 destruct INPUT as[GOOD READ].
 pose proof(read_axis_bounds axis gh ret q g x AX GOOD READ)as B.
 pose proof(normal_axis_observation axis gh ret q m g x AX GOOD READ CALL)as[IL[CL RL]].
 destruct INITIAL as[i[IA DIST]].
 destruct ENV as[FRAME PRESERVE].
 assert(IQ:load_global Mint32 q P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint i)).
 { rewrite(PRESERVE axis AX);exact IA. }
 assert(OQ:load_global Mint32 q P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint(old_integral x)))
 by(unfold ReadAxis in READ;tauto).
 rewrite OQ in IQ;injection IQ as EQ;subst i.
 pose proof(axis_machine_exact _ _ _ _ _ _ _ _ _ _ B)as[MI MC].
 fold(mi g x)in MI;fold(mc g x)in MC.
 pose proof(exact_cycle_error(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
 (Int.signed(gain_v g))(Int.signed(gain_a g))(Int.signed(mpe x))(Int.signed(mse x))
 (Int.signed(reference_speed x))(Int.signed(reference_accel x))(Int.signed(old_integral x))j distance
 (proj1(bound_kd _ _ _ _ _ _ _ _ _ _ B))(proj1(bound_ki _ _ _ _ _ _ _ _ _ _ B))DIST)as[IG CG].
 split.
 - exists(mi g x);split;[exact IL|];rewrite MI;exact IG.
 - exists(mc g x),(ref_command g x j);repeat split;try reflexivity;try assumption.
   + unfold ref_command;rewrite MC;exact(proj1 CG).
   + apply Z.min_glb.
     * pose proof(command_numerator_bounds(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
       (Int.signed(gain_v g))(Int.signed(gain_a g))(Int.signed(mpe x))(Int.signed(mse x))
       (Int.signed(reference_speed x))(Int.signed(reference_accel x))j)as RB.
       pose proof(actual_command_bounds(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
       (Int.signed(gain_v g))(Int.signed(gain_a g))(Int.signed(mpe x))(Int.signed(mse x))
       (Int.signed(reference_speed x))(Int.signed(reference_accel x))(Int.signed(old_integral x)))as CB.
       unfold ref_command;rewrite MC;unfold output_cap,T,S in *;nia.
     * unfold ref_command;rewrite MC;exact(proj2 CG).
Qed.

Lemma cycles_growth:forall n axis gh ret g a j af jf out distance,
 In axis[P._x;P._y] ->IntegralGap axis a j distance ->
 ActualCycles axis gh ret g n a j af jf out ->
 IntegralGap axis af jf(distance+Z.of_nat n*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))) /\
 ((0<n)%nat ->CommandGap axis ret af out
 (output_loss(Int.signed(gain_d g))+distance+Z.of_nat n*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))).
Proof.
 induction n as[|n IH];intros axis gh ret g a j af jf out distance AX INITIAL RUN.
 - inversion RUN;subst;split;[|lia].
   replace(distance+Z.of_nat 0*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))with distance by ring.
   exact INITIAL.
 - inversion RUN as[|k a0 j0 q x m af0 jf0 tail ENV INPUT CALL TAIL];subst.
   destruct(one_cycle_observed axis gh ret g a j q x m distance AX INITIAL ENV INPUT CALL)as[IG CG].
   destruct(IH axis gh ret g m(ref_integral g x j)af jf tail
   (distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))AX IG TAIL)as[FINAL MORE].
   assert(SUM:distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))+
   Z.of_nat n*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))=
   distance+Z.of_nat(Datatypes.S n)*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))).
   { rewrite Nat2Z.inj_succ;ring. }
   rewrite SUM in FINAL;split;[exact FINAL|intros POS].
   destruct n as[|n].
   + inversion TAIL;subst;cbn[last_command].
     replace(output_loss(Int.signed(gain_d g))+distance+
     Z.of_nat 1*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))
     with(output_loss(Int.signed(gain_d g))+distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))by ring.
     exact CG.
   + specialize(MORE ltac:(lia)).
     destruct MORE as[c[r[OUT[CL[RL GAP]]]]];subst tail;cbn[last_command].
     exists c,r;split;[reflexivity|];split;[exact CL|];split;[exact RL|].
     replace(output_loss(Int.signed(gain_d g))+
     (distance+Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))+
     Z.of_nat(Datatypes.S n)*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))
     with(output_loss(Int.signed(gain_d g))+distance+
     Z.of_nat(Datatypes.S(Datatypes.S n))*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g)))in GAP
     by(rewrite Nat2Z.inj_succ;ring).
     exact GAP.
Qed.

Theorem proved_arbitrary_horizon:ArbitraryHorizonGoal.
Proof.
 intros axis gh ret g n m j mf jf out AX SAME RUN.
 assert(INIT:IntegralGap axis m j 0).
 { destruct SAME as[i[LOAD EQ]];exists i;split;[exact LOAD|subst j;lia]. }
 pose proof(cycles_growth n axis gh ret g m j mf jf out 0 AX INIT RUN)as[IG CG].
 rewrite Z.add_0_l in IG;unfold horizon_loss;rewrite Z.add_0_r in CG;split;assumption.
Qed.

Theorem proved_execution_total:ExecutionTotalGoal.
Proof.
 intros axis gh ret g n;induction n as[|n IH];intros m j READY.
 - exists m,j,None;constructor.
 - cbn[ReadyCycles]in READY;destruct READY as(q&x&ENV&INPUT&NEXT).
   destruct(original_entry_normal_return q gh ret true(proj1 INPUT))as[mf CALL].
   destruct(IH mf(ref_integral g x j)(NEXT mf CALL))as(af&jf&out&TAIL).
   exists af,jf,(last_command(ref_command g x j)out);eapply cycles_step;eassumption.
Qed.
Theorem proved_every_call_no_error:EveryCallNoErrorGoal.
Proof. exact proved_no_error. Qed.
Theorem proved_every_call_termination:EveryCallTerminationGoal.
Proof. exact proved_all_successor_termination. Qed.
Theorem proved_reference_interpretation:ReferenceInterpretationGoal.
Proof. exact proved_exact_rational_reference. Qed.
Theorem proved_execution_existence:ExecutionExistenceGoal.
Proof.
 intros A kp ki n AR KPR KIR.
 destruct(witness_driver_exists A kp ki n AR KPR KIR)as(gh&ret&m&SX&SY&RX&RY).
 exists gh,ret,m;split;[exact SX|];split;[exact SY|];split;[exact RX|];split;[exact RY|].
 intros axis AX;destruct AX as[<-|[<-|[]]];apply proved_execution_total;assumption.
Qed.

Print Assumptions proved_arbitrary_horizon.
Print Assumptions proved_execution_total.
Print Assumptions proved_every_call_no_error.
Print Assumptions proved_every_call_termination.
Print Assumptions proved_reference_interpretation.
Print Assumptions proved_execution_existence.
