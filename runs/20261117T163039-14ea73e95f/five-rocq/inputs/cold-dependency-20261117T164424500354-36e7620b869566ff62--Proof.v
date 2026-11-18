From Stdlib Require Import List ZArith Lia Psatz.
From compcert Require Import AST Integers Values Memory.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import NormalReturn MainGoals.
From CoreCBMC Require Import NumericBounds.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic RobustnessArithmetic SemanticBridge.
From PidMeasurementProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Lemma integral_bound_mono:forall axis a b x y,
 IntegralBound axis a b x ->x<=y ->IntegralBound axis a b y.
Proof. intros axis a b x y(ia&ib&A&B&D)LE;exists ia,ib;repeat split;try assumption;lia. Qed.
Lemma command_bound_mono:forall axis ret a b x y,
 CommandBound axis ret a b x ->x<=y ->CommandBound axis ret a b y.
Proof. intros axis ret a b x y(ca&cb&A&B&RA&RB&D)LE;exists ca,cb;repeat split;try assumption;lia. Qed.

Theorem one_cycle_observed:forall axis gh ret g epsilon a b qa qb x y ma mb distance,
 In axis[P._x;P._y] ->0<=epsilon ->
 IntegralBound axis a b distance ->
 EnvironmentStep gh a qa ->EnvironmentStep gh b qb ->
 CycleInput axis gh ret g epsilon qa qb x y ->
 NormalCall gh ret true qa ma ->NormalCall gh ret true qb mb ->
 IntegralBound axis ma mb(Z.min integral_cap(distance+Int.signed(gain_i g)*Bcode g epsilon)) /\
 CommandBound axis ret ma mb(Z.min command_cap
 (Bcode g epsilon+ceil_div(distance+Int.signed(gain_i g)*Bcode g epsilon)65536)).
Proof.
 intros axis gh ret g epsilon a b qa qb x y ma mb distance AX EPS INITIAL EA EB INPUT CALLA CALLB.
 destruct INPUT as(GOODA&GOODB&READA&READB&PAIR&HEADING).
 pose proof(read_axis_bounds axis gh ret qa g x AX GOODA READA)as BA.
 pose proof(read_axis_bounds axis gh ret qb g y AX GOODB READB)as BB.
 pose proof(normal_axis_observation axis gh ret qa ma g x AX GOODA READA CALLA)as(ILA&CLA&RLA).
 pose proof(normal_axis_observation axis gh ret qb mb g y AX GOODB READB CALLB)as(ILB&CLB&RLB).
 pose proof(environment_integral_bound axis gh a b qa qb distance AX EA EB INITIAL)as(ia&ib&IA&IB&DIST).
 assert(OA:load_global Mint32 qa P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint(old_integral x)))by(unfold ReadAxis in READA;tauto).
 assert(OB:load_global Mint32 qb P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint(old_integral y)))by(unfold ReadAxis in READB;tauto).
 rewrite OA in IA;rewrite OB in IB;injection IA as IA;injection IB as IB;subst ia ib.
 destruct PAIR as(REF&RS&MS&ACC&MEASURE).
 assert(SE:mse y=mse x)by(unfold mse;rewrite<-RS,<-MS;reflexivity).
 pose proof(read_axis_position_exact axis gh ret qa g x AX GOODA READA)as PEA.
 pose proof(read_axis_position_exact axis gh ret qb g y AX GOODB READB)as PEB.
 pose proof(axis_machine_exact _ _ _ _ _ _ _ _ _ _ BA)as[IAEX CAEX].
 pose proof(axis_machine_exact _ _ _ _ _ _ _ _ _ _ BB)as[IBEX CBEX].
 fold(mi g x)in IAEX;fold(mc g x)in CAEX.
 fold(mi g y)in IBEX;fold(mc g y)in CBEX.
 rewrite PEA in IAEX,CAEX;rewrite PEB,SE,<-REF in IBEX;rewrite PEB,SE,<-REF,<-RS,<-ACC in CBEX.
 pose proof(integer_cycle_robustness(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
 (Int.signed(gain_v g))(Int.signed(gain_a g))(Int.signed(reference x))
 (Int.signed(measurement x))(Int.signed(measurement y))(Int.signed(mse x))
 (Int.signed(reference_speed x))(Int.signed(reference_accel x))
 (Int.signed(old_integral x))(Int.signed(old_integral y))epsilon distance
 (proj1(bound_kp _ _ _ _ _ _ _ _ _ _ BA))(proj1(bound_ki _ _ _ _ _ _ _ _ _ _ BA))EPS MEASURE DIST)as[INT CMD].
 fold(Bcode g epsilon)in INT,CMD.
 split.
 - exists(mi g x),(mi g y);repeat split;try assumption;rewrite IAEX,IBEX;exact INT.
 - exists(mc g x),(mc g y);repeat split;try assumption;rewrite CAEX,CBEX;exact CMD.
Qed.

Lemma cycles_growth:forall n axis gh ret g epsilon a b af bf distance,
 In axis[P._x;P._y] ->0<=epsilon ->IntegralBound axis a b distance ->
 PairedCycles axis gh ret g epsilon n a b af bf ->
 IntegralBound axis af bf(distance+Z.of_nat n*Int.signed(gain_i g)*Bcode g epsilon) /\
 ((0<n)%nat ->IntegralBound axis af bf integral_cap /\
 CommandBound axis ret af bf(Z.min command_cap(Bcode g epsilon+
 ceil_div(distance+Z.of_nat n*Int.signed(gain_i g)*Bcode g epsilon)65536))).
Proof.
 induction n as[|n IH];intros axis gh ret g epsilon a b af bf distance AX EPS INITIAL RUN.
 - inversion RUN;subst;split;[replace(distance+Z.of_nat 0*Int.signed(gain_i g)*Bcode g epsilon)with distance by ring;exact INITIAL|lia].
 - inversion RUN as[|k a0 b0 qa qb x y ma mb af0 bf0 EA EB INPUT CA CB TAIL];subst.
   destruct(one_cycle_observed axis gh ret g epsilon a b qa qb x y ma mb distance AX EPS INITIAL EA EB INPUT CA CB)as[IBOUND CBOUND].
   assert(IGROW:IntegralBound axis ma mb(distance+Int.signed(gain_i g)*Bcode g epsilon)).
   { eapply integral_bound_mono;[exact IBOUND|apply Z.le_min_r]. }
   destruct(IH axis gh ret g epsilon ma mb af bf(distance+Int.signed(gain_i g)*Bcode g epsilon)AX EPS IGROW TAIL)as[FINAL MORE].
   assert(SUM:distance+Int.signed(gain_i g)*Bcode g epsilon+Z.of_nat n*Int.signed(gain_i g)*Bcode g epsilon=
   distance+Z.of_nat(Datatypes.S n)*Int.signed(gain_i g)*Bcode g epsilon).
   { rewrite Nat2Z.inj_succ;ring. }
   rewrite SUM in FINAL,MORE;split;[exact FINAL|intros POS].
   destruct n as[|n].
   + inversion TAIL;subst;split.
     * eapply integral_bound_mono;[exact IBOUND|apply Z.le_min_l].
     * replace(distance+Z.of_nat 1*Int.signed(gain_i g)*Bcode g epsilon)
       with(distance+Int.signed(gain_i g)*Bcode g epsilon)by ring;exact CBOUND.
   + apply MORE;lia.
Qed.

Theorem proved_arbitrary_horizon:ArbitraryHorizonGoal.
Proof.
 intros axis gh ret g epsilon n a b af bf AX EPS SAME RUN.
 assert(INIT:IntegralBound axis a b 0).
 { destruct SAME as[i[A B]];exists i,i;repeat split;try assumption;rewrite Z.sub_diag;reflexivity. }
 destruct(cycles_growth n axis gh ret g epsilon a b af bf 0 AX EPS INIT RUN)as[GROW MORE].
 rewrite Z.add_0_l in GROW,MORE.
 split.
 - destruct n as[|n].
   + cbn[Z.of_nat]in *;replace(0*Int.signed(gain_i g)*Bcode g epsilon)with 0 in * by ring.
     change(IntegralBound axis af bf 0);exact GROW.
   + destruct(MORE ltac:(lia))as[CAP CMD].
     destruct GROW as[ia[ib[A[B D]]]].
     destruct CAP as[ja[jb[AA[BB C]]]].
     rewrite A in AA;rewrite B in BB;injection AA as EQ;subst ja;injection BB as EQ;subst jb.
     exists ia,ib;repeat split;try assumption;apply Z.min_glb;assumption.
 - intros POS;exact(proj2(MORE POS)).
Qed.

Theorem proved_execution_total:ExecutionTotalGoal.
Proof.
 intros axis gh ret g epsilon n;induction n as[|n IH];intros a b READY.
 - exists a,b;constructor.
 - cbn[ReadyCycles]in READY.
   destruct READY as(qa&qb&x&y&EA&EB&INPUT&NEXT).
   destruct(original_entry_normal_return qa gh ret true(proj1 INPUT))as[ma CA].
   destruct(original_entry_normal_return qb gh ret true(proj1(proj2 INPUT)))as[mb CB].
   destruct(IH ma mb(NEXT ma mb CA CB))as[af[bf TAIL]].
   exists af,bf;eapply cycles_step;[exact EA|exact EB|exact INPUT|exact CA|exact CB|exact TAIL].
Qed.
Theorem proved_every_call_no_error:EveryCallNoErrorGoal.
Proof. exact proved_no_error. Qed.
Theorem proved_every_call_termination:EveryCallTerminationGoal.
Proof. exact proved_all_successor_termination. Qed.
Theorem proved_zero_perturbation:ZeroPerturbationGoal.
Proof.
 intros axis gh ret g n a b af bf AX SAME RUN.
 pose proof(proved_arbitrary_horizon axis gh ret g 0 n a b af bf AX ltac:(lia)SAME RUN)as[IB CB].
 unfold Bcode,position_bound in IB,CB;rewrite Z.mul_0_r,ceil_div_zero in IB,CB.
 repeat rewrite Z.mul_0_r in IB,CB.
 rewrite ceil_div_zero in CB;cbn in IB,CB;split;assumption.
Qed.
Print Assumptions proved_arbitrary_horizon.
Print Assumptions proved_execution_total.
Print Assumptions proved_every_call_no_error.
Print Assumptions proved_every_call_termination.
Print Assumptions proved_zero_perturbation.
