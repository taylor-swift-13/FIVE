From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidMeasurementProblem Require Import Spec.
From PidMeasurementAttempt001 Require Import SemanticBridge.
From PidQuantizationAttempt001 Require Import ExactArithmetic RationalReference.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.

(** Units: integral numerator / T, command numerator / (T*S), radians
    command numerator / (4096*T*S). Numerators are unbounded Z values.
    Every dynamic right shift is exact division at these denominators.
    The original input clamps, integral clamp and both command clamps remain. *)
Definition ref_integral(g:Gains)(x:AxisSample)(old:Z):Z:=
 integral_num(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
 (Int.signed(mpe x))(Int.signed(mse x))old.
Definition ref_command(g:Gains)(x:AxisSample)(old:Z):Z:=
 command_num(Int.signed(gain_p g))(Int.signed(gain_d g))(Int.signed(gain_i g))
 (Int.signed(gain_v g))(Int.signed(gain_a g))
 (Int.signed(mpe x))(Int.signed(mse x))
 (Int.signed(reference_speed x))(Int.signed(reference_accel x))old.
Definition CycleInput(axis:ident)(gh ret:block)(g:Gains)(m:mem)(x:AxisSample):Prop:=
 InputGood m gh ret /\ReadAxis axis gh m g x.
Definition last_command(first:Z)(tail:option Z):option Z:=
 match tail with None=>Some first|Some c=>Some c end.

(** Each step executes the unmodified original Csem entry. Reference and
    implementation receive identical encoded inputs and fixed gains. *)
Inductive ActualCycles(axis:ident)(gh ret:block)(g:Gains):
 nat->mem->Z->mem->Z->option Z->Prop:=
 | cycles_zero:forall a j,ActualCycles axis gh ret g O a j a j None
 | cycles_step:forall n a j q x m af jf out,
 EnvironmentStep gh a q ->CycleInput axis gh ret g q x ->
 NormalCall gh ret true q m ->
 ActualCycles axis gh ret g n m(ref_integral g x j)af jf out ->
 ActualCycles axis gh ret g(Datatypes.S n)a j af jf
 (last_command(ref_command g x j)out).
Fixpoint ReadyCycles(axis:ident)(gh ret:block)(g:Gains)(n:nat)(m:mem):Prop:=
 match n with
 | O=>True
 | Datatypes.S k=>exists q x,EnvironmentStep gh m q /\CycleInput axis gh ret g q x /\
 (forall mf,NormalCall gh ret true q mf ->ReadyCycles axis gh ret g k mf)
 end.
Definition IntegralGap(axis:ident)(m:mem)(reference_numerator distance:Z):Prop:=
 exists i,load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint i) /\
 0<=reference_numerator-Int.signed i*T<=distance.
Definition SameStart(axis:ident)(m:mem)(j:Z):Prop:=
 exists i,load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint i) /\j=Int.signed i*T.
Definition CommandGap(axis:ident)(ret:block)(m:mem)(out:option Z)(distance:Z):Prop:=
 exists c r,out=Some r /\
 load_global Mint32 m P._guidance_pid pid_type[P._cmd_earth;axis]=Some(Vint c) /\
 load_path Mint32 m ret sp_type[P._sp;P._ltp_i;P._vect;axis]=Some(Vint c) /\
 0<=r-Int.signed c*T*S<=Z.min output_cap distance.

Definition ArbitraryHorizonGoal:Prop:=forall axis gh ret g n m j mf jf out,
 In axis[P._x;P._y] ->SameStart axis m j ->ActualCycles axis gh ret g n m j mf jf out ->
 IntegralGap axis mf jf(Z.of_nat n*Int.signed(gain_i g)*pd_loss(Int.signed(gain_d g))) /\
 ((0<n)%nat ->CommandGap axis ret mf out(horizon_loss n(Int.signed(gain_i g))(Int.signed(gain_d g)))).
Definition ExecutionTotalGoal:Prop:=forall axis gh ret g n m j,
 ReadyCycles axis gh ret g n m ->exists mf jf out,ActualCycles axis gh ret g n m j mf jf out.
Definition EveryCallNoErrorGoal:Prop:=PidPositionTranslationProblem.Spec.NoErrorGoal.
Definition EveryCallTerminationGoal:Prop:=PidPositionTranslationProblem.Spec.AllSuccessorTerminationGoal.
Definition ReferenceInterpretationGoal:Prop:=ExactRationalReferenceGoal.

(** A symbolic admissible family for arbitrary n; no future return is assumed.
    Both actual integrators start at zero. *)
Definition witness_gains(kp ki:Z):Gains:=
 {|gain_p:=Int.repr kp;gain_d:=Int.zero;gain_i:=Int.repr ki;
   gain_v:=Int.zero;gain_a:=Int.zero|}.
Definition ExecutionExistenceGoal:Prop:=forall A kp ki n,
 0<=A<=4096 ->0<=kp<=100 ->0<=ki<=100 ->
 exists gh ret m,SameStart P._x m 0 /\SameStart P._y m 0 /\
 ReadyCycles P._x gh ret(witness_gains kp ki)n m /\
 ReadyCycles P._y gh ret(witness_gains kp ki)n m /\
 (forall axis,In axis[P._x;P._y] ->
 exists mf jf out,ActualCycles axis gh ret(witness_gains kp ki)n m 0 mf jf out).
