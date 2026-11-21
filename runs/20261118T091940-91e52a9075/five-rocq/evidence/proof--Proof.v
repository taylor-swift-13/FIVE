From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import CoreInputs NormalReturn.
From PidMeasurementProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
From PidAlternatingAttempt001 Require Import Semantic DriftArithmetic Witness Driver.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Lemma input_integral:forall m gh ret r kp ki ix,
 AlternatingInput m gh ret r kp ki ix ->integral_load m ix.
Proof. intros;unfold AlternatingInput in H;tauto. Qed.
Lemma environment_integral:forall gh m mf i,
 EnvironmentStep gh m mf ->integral_load m i ->integral_load mf i.
Proof.
 intros gh m mf i[_ KEEP]LOAD;unfold integral_load in *.
 rewrite(KEEP P._x ltac:(cbn;auto));exact LOAD.
Qed.
Lemma integral_unique:forall m i j,integral_load m i ->integral_load m j ->i=j.
Proof. unfold integral_load;intros;congruence. Qed.
Lemma pairs_exact:forall A kp ki n gh ret m mf,
 Parameters A kp ki ->integral_load m Int.zero ->
 AlternatingPairs gh ret A kp ki n m mf ->
 ObservedIntegral mf(drift_even(kp*A)ki n).
Proof.
 intros A kp ki n gh ret m mf PARAM ZERO RUN.
 destruct PARAM as(AR&KP&KI).
 induction RUN as[m|n m a qa ma qb mb ix iy RUN IH E1 I1 C1 E2 I2 C2].
 - exists Int.zero;rewrite drift_even_zero;split;[exact ZERO|exact Int.signed_zero].
 - specialize(IH ZERO);destruct IH as[ia[LA SA]].
   assert(LAQ:integral_load qa ia)by exact(environment_integral gh a qa ia E1 LA).
   assert(IX:ix=ia)by exact(integral_unique qa ix ia(input_integral _ _ _ _ _ _ _ I1)LAQ).
   destruct(original_call_integral_exact qa ma gh ret A kp ki ix ltac:(lia) KP KI I1 C1)as[j1[L1 S1]].
   assert(LQB:integral_load qb j1)by exact(environment_integral gh ma qb j1 E2 L1).
   assert(IY:iy=j1)by exact(integral_unique qb iy j1(input_integral _ _ _ _ _ _ _ I2)LQB).
   destruct(original_call_integral_exact qb mb gh ret (-A)kp ki iy ltac:(lia) KP KI I2 C2)as[j2[L2 S2]].
   exists j2;split;[exact L2|].
   rewrite IY,S1,IX,SA in S2.
   change(Int.signed j2=alternating_step kp ki (-A)
     (alternating_step kp ki A(drift_even(kp*A)ki n)))in S2.
   rewrite S2;exact(pair_drift_step kp ki A n AR KP KI).
Qed.
Theorem proved_drift:DriftGoal.
Proof.
 intros A kp ki n gh ret m mf PARAM ZERO RUN.
 pose proof(pairs_exact A kp ki n gh ret m mf PARAM ZERO RUN)as RESULT.
 rewrite drift_divisible_split in RESULT;exact RESULT.
Qed.
Lemma pairs_append:forall gh ret A kp ki k a b,
 AlternatingPairs gh ret A kp ki k a b ->forall n m,
 AlternatingPairs gh ret A kp ki n m a ->
 AlternatingPairs gh ret A kp ki (n+k)m b.
Proof.
 intros gh ret A kp ki k a b RUN.
 induction RUN as[a|k start a qa ma qb mb ix iy RUN IH E1 I1 C1 E2 I2 C2];intros j m PREFIX.
 - rewrite Nat.add_0_r;exact PREFIX.
 - rewrite Nat.add_succ_r.
   eapply pairs_step with(a:=a)(qa:=qa)(ma:=ma)(qb:=qb)(ix:=ix)(iy:=iy).
   + exact(IH j m PREFIX).
   + exact E1.
   + exact I1.
   + exact C1.
   + exact E2.
   + exact I2.
   + exact C2.
Qed.
Lemma normal_call_exists:forall m gh ret,InputGood m gh ret ->
 exists mf,NormalCall gh ret true m mf.
Proof.
 intros m gh ret GOOD.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 destruct(original_entry_normal_result m gh ret true D GOOD)as(mf&rx&ry&px&py&sx&sy&vx&vy&sb&CALL&REST).
 exists mf;exact CALL.
Qed.
Theorem proved_ready_execution:ReadyExecutionGoal.
Proof.
 intros A kp ki n;induction n as[|n IH];intros gh ret m READY.
 - exists m;constructor.
 - destruct READY as[qa[ix[E1[I1 NEXT]]]].
   destruct(normal_call_exists qa gh ret(input_good _ _ _ _ _ _ _ I1))as[ma C1].
   destruct(NEXT ma C1)as[qb[iy[E2[I2 NEXT2]]]].
   destruct(normal_call_exists qb gh ret(input_good _ _ _ _ _ _ _ I2))as[mb C2].
   destruct(IH gh ret mb(NEXT2 mb C2))as[mf SUFFIX].
   exists mf;replace(Datatypes.S n)with(1+n)%nat by lia.
   apply(pairs_append gh ret A kp ki n mb mf SUFFIX 1%nat m).
   eapply pairs_step with(a:=m)(qa:=qa)(ma:=ma)(qb:=qb)(ix:=ix)(iy:=iy).
   + constructor.
   + exact E1.
   + exact I1.
   + exact C1.
   + exact E2.
   + exact I2.
   + exact C2.
Qed.
Print Assumptions proved_drift.
Print Assumptions proved_ready_execution.

Theorem proved_initial_existence:InitialExistenceGoal.
Proof. exact initial_input_exists. Qed.
Lemma private_driver_pairs:forall A kp ki gh ret,
 Parameters A kp ki ->PrivateBlocks gh ret ->
 forall n m r ix,-4096<=r<=4096 ->AlternatingInput m gh ret r kp ki ix ->Mem.range_perm m gh 0 84 Cur Writable ->
 exists mf r' iy,AlternatingPairs gh ret A kp ki n m mf /\
 (-4096<=r'<=4096) /\AlternatingInput mf gh ret r' kp ki iy /\Mem.range_perm mf gh 0 84 Cur Writable.
Proof.
 intros A kp ki gh ret PARAM PRIVATE n;induction n as[|n IH];intros m r ix R INPUT WRITE.
 - exists m,r,ix;split;[constructor|];auto.
 - destruct(IH m r ix R INPUT WRITE)as(a&ar&ia&PREFIX&AR&AINPUT&AW).
   destruct PARAM as(AP&KP&KI).
   destruct(prepare_input a gh ret ar A kp ki ia ltac:(lia) AINPUT AW PRIVATE)as(qa&E1&I1&W1).
   destruct(normal_call_exists qa gh ret(input_good _ _ _ _ _ _ _ I1))as(ma&C1).
   destruct(returned_input qa ma gh ret A kp ki ia ltac:(lia) KP KI I1 W1 PRIVATE C1)as(ib&MID&MW).
   destruct(prepare_input ma gh ret A (-A)kp ki ib ltac:(lia) MID MW PRIVATE)as(qb&E2&I2&W2).
   destruct(normal_call_exists qb gh ret(input_good _ _ _ _ _ _ _ I2))as(mb&C2).
   destruct(returned_input qb mb gh ret (-A)kp ki ib ltac:(lia) KP KI I2 W2 PRIVATE C2)as(ic&FINAL&FW).
   exists mb,(-A),ic;split.
   + eapply pairs_step with(a:=a)(qa:=qa)(ma:=ma)(qb:=qb)(ix:=ia)(iy:=ib).
     * exact PREFIX.
     * exact E1.
     * exact I1.
     * exact C1.
     * exact E2.
     * exact I2.
     * exact C2.
   + split;[lia|];split;assumption.
Qed.
Theorem proved_execution_existence:ExecutionExistenceGoal.
Proof.
 intros A kp ki n PARAM.
 destruct(initial_private_writable_input_exists A kp ki PARAM)as(gh&ret&m&INPUT&WRITE&PRIVATE).
 destruct(private_driver_pairs A kp ki gh ret PARAM PRIVATE n m A Int.zero
   ltac:(unfold Parameters in PARAM;lia)INPUT WRITE)as(mf&r&iy&RUN&REST).
 exists gh,ret,m,mf;split;assumption.
Qed.
Print Assumptions proved_initial_existence.
Print Assumptions proved_execution_existence.
