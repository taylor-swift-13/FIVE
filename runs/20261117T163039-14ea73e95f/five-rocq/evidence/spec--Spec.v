From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes Csyntax Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidMeasurementAttempt001 Require Import IntegerBounds RobustnessArithmetic.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Record Gains:Type:={ gain_p:int;gain_d:int;gain_i:int;gain_v:int;gain_a:int }.
Record AxisSample:Type:={ reference:int;measurement:int;reference_speed:int;measurement_speed:int;reference_accel:int;old_integral:int }.
Definition ReadAxis(axis:ident)(gh:block)(m:mem)(g:Gains)(x:AxisSample):Prop:=
 load_global Mint32 m P._guidance_pid pid_type[P._kp]=Some(Vint(gain_p g)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._kd]=Some(Vint(gain_d g)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._ki]=Some(Vint(gain_i g)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._kv]=Some(Vint(gain_v g)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._ka]=Some(Vint(gain_a g)) /\
 load_path Mint32 m gh gh_type[P._ref;P._pos;axis]=Some(Vint(reference x)) /\
 load_global Mint32 m P._state state_type[P._ned_pos_i;axis]=Some(Vint(measurement x)) /\
 load_path Mint32 m gh gh_type[P._ref;P._speed;axis]=Some(Vint(reference_speed x)) /\
 load_global Mint32 m P._state state_type[P._ned_speed_i;axis]=Some(Vint(measurement_speed x)) /\
 load_path Mint32 m gh gh_type[P._ref;P._accel;axis]=Some(Vint(reference_accel x)) /\
 load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint(old_integral x)).
Definition SamplesPaired(epsilon:Z)(a b:AxisSample):Prop:=
 reference a=reference b /\reference_speed a=reference_speed b /\
 measurement_speed a=measurement_speed b /\reference_accel a=reference_accel b /\
 Z.abs(Int.signed(measurement a)-Int.signed(measurement b))<=epsilon.
Definition CycleInput(axis:ident)(gh ret:block)(g:Gains)(epsilon:Z)(a b:mem)(x y:AxisSample):Prop:=
 InputGood a gh ret /\InputGood b gh ret /\ReadAxis axis gh a g x /\ReadAxis axis gh b g y /\
 SamplesPaired epsilon x y /\
 load_global Mfloat32 a P._guidance_h gh_type[P._sp;P._heading]=
 load_global Mfloat32 b P._guidance_h gh_type[P._sp;P._heading].
(** The environment may update only the measured/reference inputs and heading.
    Gains, integrator state, commands and all remaining frame bytes persist.
    The explicit load clause expresses the integrator preservation interface
    independently of byte-decoding lemmas; it never assumes a numeric bound. *)
Definition environment_byte(gh b:block)(ofs:Z):Prop:=
 (b=gh /\36<=ofs<68) \/
 (exists sb,Genv.find_symbol Execution.ge P._state=Some sb /\b=sb /\
    (100<=ofs<108 \/296<=ofs<304)) \/
 (exists hb,Genv.find_symbol Execution.ge P._guidance_h=Some hb /\b=hb /\28<=ofs<32).
Definition EnvironmentStep(gh:block)(before after:mem):Prop:=
 Mem.unchanged_on(fun b ofs=>~environment_byte gh b ofs)before after /\
 (forall axis,In axis[P._x;P._y] ->
 load_global Mint32 after P._guidance_pid_trim_att_integrator vec_type[axis]=
 load_global Mint32 before P._guidance_pid_trim_att_integrator vec_type[axis]).
Inductive PairedCycles(axis:ident)(gh ret:block)(g:Gains)(epsilon:Z):nat->mem->mem->mem->mem->Prop:=
 | cycles_zero:forall a b,PairedCycles axis gh ret g epsilon O a b a b
 | cycles_step:forall n a b qa qb x y ma mb af bf,
 EnvironmentStep gh a qa ->EnvironmentStep gh b qb ->
 CycleInput axis gh ret g epsilon qa qb x y ->
 NormalCall gh ret true qa ma ->NormalCall gh ret true qb mb ->
 PairedCycles axis gh ret g epsilon n ma mb af bf ->
 PairedCycles axis gh ret g epsilon (Datatypes.S n)a b af bf.
(** A driver promises admissible input preparation after each actual return.
    It contains no assumed execution, termination or robustness conclusion. *)
Fixpoint ReadyCycles(axis:ident)(gh ret:block)(g:Gains)(epsilon:Z)(n:nat)(a b:mem):Prop:=
 match n with
 | O=>True
 | Datatypes.S k=>exists qa qb x y,
 EnvironmentStep gh a qa /\EnvironmentStep gh b qb /\
 CycleInput axis gh ret g epsilon qa qb x y /\
 (forall ma mb,NormalCall gh ret true qa ma ->NormalCall gh ret true qb mb ->
 ReadyCycles axis gh ret g epsilon k ma mb)
 end.
Definition IntegralBound(axis:ident)(a b:mem)(bound:Z):Prop:=
 exists ia ib,
 load_global Mint32 a P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint ia) /\
 load_global Mint32 b P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint ib) /\
 Z.abs(Int.signed ia-Int.signed ib)<=bound.
Definition SameIntegral(axis:ident)(a b:mem):Prop:=
 exists i,
 load_global Mint32 a P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint i) /\
 load_global Mint32 b P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint i).
Definition CommandBound(axis:ident)(ret:block)(a b:mem)(bound:Z):Prop:=
 exists ca cb,
 load_global Mint32 a P._guidance_pid pid_type[P._cmd_earth;axis]=Some(Vint ca) /\
 load_global Mint32 b P._guidance_pid pid_type[P._cmd_earth;axis]=Some(Vint cb) /\
 load_path Mint32 a ret sp_type[P._sp;P._ltp_i;P._vect;axis]=Some(Vint ca) /\
 load_path Mint32 b ret sp_type[P._sp;P._ltp_i;P._vect;axis]=Some(Vint cb) /\
 Z.abs(Int.signed ca-Int.signed cb)<=bound.
Definition Bcode(g:Gains)(epsilon:Z):Z:=position_bound(Int.signed(gain_p g))epsilon.
Definition ArbitraryHorizonGoal:Prop:=forall axis gh ret g epsilon n a b af bf,
 In axis[P._x;P._y] ->0<=epsilon ->SameIntegral axis a b ->
 PairedCycles axis gh ret g epsilon n a b af bf ->
 IntegralBound axis af bf(Z.min integral_cap(Z.of_nat n*Int.signed(gain_i g)*Bcode g epsilon)) /\
 ((0<n)%nat ->CommandBound axis ret af bf
 (Z.min command_cap(Bcode g epsilon+ceil_div(Z.of_nat n*Int.signed(gain_i g)*Bcode g epsilon)65536))).
Definition ExecutionTotalGoal:Prop:=forall axis gh ret g epsilon n a b,
 ReadyCycles axis gh ret g epsilon n a b ->
 exists af bf,PairedCycles axis gh ret g epsilon n a b af bf.
Definition EveryCallNoErrorGoal:Prop:=PidPositionTranslationProblem.Spec.NoErrorGoal.
Definition EveryCallTerminationGoal:Prop:=PidPositionTranslationProblem.Spec.AllSuccessorTerminationGoal.
Definition ZeroPerturbationGoal:Prop:=forall axis gh ret g n a b af bf,
 In axis[P._x;P._y] ->SameIntegral axis a b ->
 PairedCycles axis gh ret g 0 n a b af bf ->
 IntegralBound axis af bf 0 /\((0<n)%nat ->CommandBound axis ret af bf 0).
