From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Floats Values Memory Globalenvs Ctypes.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import CoreSemantics FlightSemantics ControllerPrefix.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic RobustnessArithmetic SemanticBridge.
From PidMeasurementProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Definition fixed_gains(kp ki:Z):Gains:={|gain_p:=Int.repr kp;gain_d:=Int.zero;
 gain_i:=Int.repr ki;gain_v:=Int.zero;gain_a:=Int.zero|}.
Definition fixed_sample(r:Z)(ix:int):AxisSample:={|reference:=Int.repr r;measurement:=Int.zero;
 reference_speed:=Int.zero;measurement_speed:=Int.zero;reference_accel:=Int.zero;old_integral:=ix|}.
Lemma input_read_x:forall m gh ret r kp ki ix,
 AlternatingInput m gh ret r kp ki ix ->
 ReadAxis P._x gh m(fixed_gains kp ki)(fixed_sample r ix).
Proof.
 intros m gh ret r kp ki ix
 (GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 destruct(AXES P._x ltac:(cbn;auto))as(SX&AX&VX).
 unfold ReadAxis,fixed_gains,fixed_sample;cbn.
 repeat(first[assumption|split]).
Qed.
Lemma input_good:forall m gh ret r kp ki ix,
 AlternatingInput m gh ret r kp ki ix ->InputGood m gh ret.
Proof. intros;exact(proj1 H). Qed.
Lemma signed_repr_small:forall z,-2147483648<=z<=2147483647 ->Int.signed(Int.repr z)=z.
Proof. intros;apply Int.signed_repr;exact H. Qed.
Theorem original_call_integral_exact:forall m mf gh ret r kp ki ix,
 -4096<=r<=4096 ->0<=kp<=100 ->0<=ki<=100 ->
 AlternatingInput m gh ret r kp ki ix ->NormalCall gh ret true m mf ->
 exists iy,integral_load mf iy /\
 Int.signed iy=zclamp integral_limit(Int.signed ix+ki*(kp*r/64)).
Proof.
 intros m mf gh ret r kp ki ix R KP KI INPUT CALL.
 pose proof(input_good _ _ _ _ _ _ _ INPUT)as GOOD.
 pose proof(input_read_x _ _ _ _ _ _ _ INPUT)as READ.
 pose proof(read_axis_bounds P._x gh ret m _ _ ltac:(cbn;auto) GOOD READ)as BOUNDS.
 pose proof(read_axis_position_exact P._x gh ret m _ _ ltac:(cbn;auto) GOOD READ)as PE.
 pose proof(normal_axis_observation P._x gh ret m mf _ _ ltac:(cbn;auto) GOOD READ CALL)as(LOAD&_).
 exists(mi(fixed_gains kp ki)(fixed_sample r ix));split;[exact LOAD|].
 unfold mi.
 rewrite(integral_machine_exact _ _ _ _ _ _ _ _ _ _ BOUNDS).
 change(Int.signed(mpe(fixed_sample r ix))=
   position_error(Int.signed(Int.repr r))(Int.signed Int.zero))in PE.
 assert(POS:Int.signed(mpe(fixed_sample r ix))=r).
 { rewrite PE;unfold position_error;change(zclamp 4096(Int.signed(Int.repr r)-Int.signed Int.zero)=r).
   rewrite signed_repr_small by lia;rewrite Int.signed_zero,Z.sub_0_r.
   unfold zclamp;rewrite Z.min_r by lia;rewrite Z.max_r by lia;reflexivity. }
 change(integral_z(Int.signed(Int.repr kp))0(Int.signed(Int.repr ki))
   (Int.signed(mpe(fixed_sample r ix)))(Int.signed(mse(fixed_sample r ix)))(Int.signed ix)=
   zclamp integral_limit(Int.signed ix+ki*(kp*r/64))).
 rewrite !signed_repr_small by lia.
 unfold integral_z,pd_z;rewrite POS.
 change(zclamp integral_limit(Int.signed ix+ki*(kp*r/64+0))=
   zclamp integral_limit(Int.signed ix+ki*(kp*r/64))).
 rewrite Z.add_0_r;reflexivity.
Qed.
Print Assumptions original_call_integral_exact.

Lemma input_read_y:forall m gh ret r kp ki ix,
 AlternatingInput m gh ret r kp ki ix ->
 ReadAxis P._y gh m(fixed_gains kp ki)(fixed_sample 0 Int.zero).
Proof.
 intros m gh ret r kp ki ix
 (GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 destruct(AXES P._y ltac:(cbn;auto))as(SY&AY&VY).
 unfold ReadAxis,fixed_gains,fixed_sample;cbn.
 repeat(first[assumption|split]).
Qed.
Theorem original_call_y_zero:forall m mf gh ret r kp ki ix,
 AlternatingInput m gh ret r kp ki ix ->NormalCall gh ret true m mf ->
 load_global Mint32 mf P._guidance_pid_trim_att_integrator vec_type[P._y]=Some(Vint Int.zero).
Proof.
 intros m mf gh ret r kp ki ix INPUT CALL.
 pose proof(input_good _ _ _ _ _ _ _ INPUT)as GOOD.
 pose proof(input_read_y _ _ _ _ _ _ _ INPUT)as READ.
 pose proof(read_axis_bounds P._y gh ret m _ _ ltac:(cbn;auto) GOOD READ)as BOUNDS.
 pose proof(normal_axis_observation P._y gh ret m mf _ _ ltac:(cbn;auto) GOOD READ CALL)as(LOAD&_).
 assert(SIGNED:Int.signed(mi(fixed_gains kp ki)(fixed_sample 0 Int.zero))=0).
 { unfold mi;rewrite(integral_machine_exact _ _ _ _ _ _ _ _ _ _ BOUNDS).
   change(integral_z(Int.signed(Int.repr kp))0(Int.signed(Int.repr ki))0 0 0=0).
   unfold integral_z,pd_z;repeat rewrite Z.mul_0_r;reflexivity. }
 assert(EQ:mi(fixed_gains kp ki)(fixed_sample 0 Int.zero)=Int.zero).
 { rewrite<-(Int.repr_signed(mi(fixed_gains kp ki)(fixed_sample 0 Int.zero))),SIGNED;reflexivity. }
 rewrite EQ in LOAD;exact LOAD.
Qed.
Print Assumptions original_call_y_zero.
