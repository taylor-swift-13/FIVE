From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidMeasurementProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
From PidAlternatingAttempt001 Require Import Witness Driver.
From PidQuantizationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Module A:=PidAlternatingProblem.Spec.
Module Q:=PidQuantizationProblem.Spec.
Local Opaque PidPositionRunPos.Execution.ge.

(** The witness receives the exact encoded original inputs.  Both axes have
    zero velocity and acceleration; the x integral is the actual stored ix. *)
Lemma read_alternating_axis : forall axis gh ret m r kp ki ix,
 In axis[P._x;P._y] ->A.AlternatingInput m gh ret r kp ki ix ->
 exists sample,Q.CycleInput axis gh ret(Q.witness_gains kp ki)m sample.
Proof.
 intros axis gh ret m r kp ki ix AX
 (GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 destruct AX as[<-|[<-|[]]].
 - destruct(AXES P._x ltac:(cbn;auto))as(SPEED&ACCEL&VEL).
   exists {|reference:=Int.repr r;measurement:=Int.zero;
     reference_speed:=Int.zero;measurement_speed:=Int.zero;
     reference_accel:=Int.zero;old_integral:=ix|}.
   unfold Q.CycleInput;split;[exact GOOD|].
   unfold ReadAxis;cbn [Q.witness_gains].
   exact(conj KP(conj KD(conj KI(conj KV(conj KA(conj RX
     (conj PX(conj SPEED(conj VEL(conj ACCEL IX)))))))))).
 - destruct(AXES P._y ltac:(cbn;auto))as(SPEED&ACCEL&VEL).
   exists {|reference:=Int.zero;measurement:=Int.zero;
     reference_speed:=Int.zero;measurement_speed:=Int.zero;
     reference_accel:=Int.zero;old_integral:=Int.zero|}.
   unfold Q.CycleInput;split;[exact GOOD|].
   unfold ReadAxis;cbn [Q.witness_gains].
   exact(conj KP(conj KD(conj KI(conj KV(conj KA(conj RY
     (conj PY(conj SPEED(conj VEL(conj ACCEL IY)))))))))).
Qed.

(** Each next input is a real reference-position store after the actual
    preceding return.  The driver assumes neither an execution nor its result. *)
Lemma witness_ready : forall A0 kp ki n gh ret m r ix,
 0<=A0<=4096 ->0<=kp<=100 ->0<=ki<=100 ->-4096<=r<=4096 ->
 A.AlternatingInput m gh ret r kp ki ix ->
 Mem.range_perm m gh 0 84 Cur Writable ->PrivateBlocks gh ret ->
 forall axis,In axis[P._x;P._y] ->
 Q.ReadyCycles axis gh ret(Q.witness_gains kp ki)n m.
Proof.
 intros A0 kp ki n;induction n as[|n IH];
 intros gh ret m r ix AR KPR KIR RR INPUT WG PRIVATE axis AX.
 - cbn [Q.ReadyCycles];exact I.
 - destruct(prepare_input m gh ret r A0 kp ki ix ltac:(lia) INPUT WG PRIVATE)
     as[q[ENV[QI QW]]].
   destruct(read_alternating_axis axis gh ret q A0 kp ki ix AX QI)as[sample CQ].
   cbn [Q.ReadyCycles];exists q,sample;split;[exact ENV|];split;[exact CQ|].
   intros mf CALL.
   destruct(returned_input q mf gh ret A0 kp ki ix ltac:(lia) KPR KIR
     QI QW PRIVATE CALL)as[iy[MI MW]].
   exact(IH gh ret mf A0 iy AR KPR KIR ltac:(lia) MI MW PRIVATE axis AX).
Qed.

Lemma same_start_zero : forall axis m,
 load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint Int.zero) ->
 Q.SameStart axis m 0.
Proof.
 intros axis m LOAD;exists Int.zero;split;[exact LOAD|].
 rewrite Int.signed_zero;reflexivity.
Qed.

Lemma initial_both_same : forall m gh ret A0 kp ki,
 A.AlternatingInput m gh ret A0 kp ki Int.zero ->
 Q.SameStart P._x m 0 /\Q.SameStart P._y m 0.
Proof.
 intros m gh ret A0 kp ki
 (_&_&_&_&_&_&_&_&_&_&_&_&IX&IY).
 split;apply same_start_zero;assumption.
Qed.

Theorem witness_driver_exists : forall A0 kp ki n,
 0<=A0<=4096 ->0<=kp<=100 ->0<=ki<=100 ->
 exists gh ret m,Q.SameStart P._x m 0 /\Q.SameStart P._y m 0 /\
 Q.ReadyCycles P._x gh ret(Q.witness_gains kp ki)n m /\
 Q.ReadyCycles P._y gh ret(Q.witness_gains kp ki)n m.
Proof.
 intros A0 kp ki n AR KPR KIR.
 destruct(initial_private_writable_input_exists A0 kp ki(conj AR(conj KPR KIR)))
   as(gh&ret&m&INPUT&WG&PRIVATE).
 destruct(initial_both_same m gh ret A0 kp ki INPUT)as[SX SY].
 pose proof(witness_ready A0 kp ki n gh ret m A0 Int.zero AR KPR KIR
   ltac:(lia)INPUT WG PRIVATE)as READY.
 exists gh,ret,m;exact(conj SX(conj SY(conj
   (READY P._x ltac:(cbn;auto))(READY P._y ltac:(cbn;auto))))).
Qed.
Print Assumptions witness_ready.
Print Assumptions witness_driver_exists.
