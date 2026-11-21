From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Globalenvs Ctypes.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidMeasurementProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Definition Parameters(A kp ki:Z):Prop:=0<=A<=4096 /\0<=kp<=100 /\0<=ki<=100.
Definition integral_limit:Z:=1429*65536.
Definition integral_load(m:mem)(i:int):Prop:=
 load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[P._x]=Some(Vint i).
(** These are input facts about the unchanged original model, with the actual
    stored x integral [ix]; no future execution or output is assumed. *)
Definition AlternatingInput(m:mem)(gh ret:block)(r kp ki:Z)(ix:int):Prop:=
 InputGood m gh ret /\
 load_path Mint32 m gh gh_type[P._ref;P._pos;P._x]=Some(Vint(Int.repr r)) /\
 load_path Mint32 m gh gh_type[P._ref;P._pos;P._y]=Some(Vint Int.zero) /\
 load_global Mint32 m P._state state_type[P._ned_pos_i;P._x]=Some(Vint Int.zero) /\
 load_global Mint32 m P._state state_type[P._ned_pos_i;P._y]=Some(Vint Int.zero) /\
 (forall axis,In axis[P._x;P._y] ->
 load_path Mint32 m gh gh_type[P._ref;P._speed;axis]=Some(Vint Int.zero) /\
 load_path Mint32 m gh gh_type[P._ref;P._accel;axis]=Some(Vint Int.zero) /\
 load_global Mint32 m P._state state_type[P._ned_speed_i;axis]=Some(Vint Int.zero)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._kp]=Some(Vint(Int.repr kp)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._kd]=Some(Vint Int.zero) /\
 load_global Mint32 m P._guidance_pid pid_type[P._ki]=Some(Vint(Int.repr ki)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._kv]=Some(Vint Int.zero) /\
 load_global Mint32 m P._guidance_pid pid_type[P._ka]=Some(Vint Int.zero) /\
 load_global Mfloat32 m P._guidance_h gh_type[P._sp;P._heading]=Some(Vsingle Float32.zero) /\
 integral_load m ix /\
 load_global Mint32 m P._guidance_pid_trim_att_integrator vec_type[P._y]=Some(Vint Int.zero).
(** EnvironmentStep permits only input bytes and explicitly preserves the
    actual stored integrators.  The two original Csem calls form one pair. *)
Inductive AlternatingPairs(gh ret:block)(A kp ki:Z):nat->mem->mem->Prop:=
 | pairs_zero:forall m,AlternatingPairs gh ret A kp ki O m m
 | pairs_step:forall n m a qa ma qb mb ix iy,
 AlternatingPairs gh ret A kp ki n m a ->
 EnvironmentStep gh a qa ->AlternatingInput qa gh ret A kp ki ix ->
 NormalCall gh ret true qa ma ->
 EnvironmentStep gh ma qb ->AlternatingInput qb gh ret (-A) kp ki iy ->
 NormalCall gh ret true qb mb ->
 AlternatingPairs gh ret A kp ki (Datatypes.S n)m mb.
Fixpoint ReadyPairs(gh ret:block)(A kp ki:Z)(n:nat)(m:mem):Prop:=
 match n with
 | O=>True
 | Datatypes.S k=>exists qa ix,
 EnvironmentStep gh m qa /\AlternatingInput qa gh ret A kp ki ix /\
 (forall ma,NormalCall gh ret true qa ma ->exists qb iy,
 EnvironmentStep gh ma qb /\AlternatingInput qb gh ret (-A) kp ki iy /\
 (forall mb,NormalCall gh ret true qb mb ->ReadyPairs gh ret A kp ki k mb))
 end.
Definition ObservedIntegral(m:mem)(z:Z):Prop:=exists i,integral_load m i /\Int.signed i=z.
Definition DriftGoal:Prop:=forall A kp ki n gh ret m mf,
 Parameters A kp ki ->integral_load m Int.zero ->
 AlternatingPairs gh ret A kp ki n m mf ->
 ObservedIntegral mf(if Z.eqb((kp*A) mod 64)0 then 0
 else -Z.min(Z.of_nat n*ki)integral_limit).
Definition RecurrenceGoal:Prop:=forall A kp ki n gh ret m mf,
 Parameters A kp ki ->integral_load m Int.zero ->
 AlternatingPairs gh ret A kp ki n m mf ->
 ObservedIntegral mf(-Z.min(Z.of_nat n*ki*((- (kp*A))/64 + (kp*A)/64)*(-1))integral_limit).
Definition InitialExistenceGoal:Prop:=forall A kp ki,Parameters A kp ki ->
 exists gh ret m,AlternatingInput m gh ret A kp ki Int.zero.
Definition ReadyExecutionGoal:Prop:=forall A kp ki n gh ret m,
 ReadyPairs gh ret A kp ki n m ->exists mf,AlternatingPairs gh ret A kp ki n m mf.
Definition ExecutionExistenceGoal:Prop:=forall A kp ki n,Parameters A kp ki ->
 exists gh ret m mf,AlternatingInput m gh ret A kp ki Int.zero /\
 AlternatingPairs gh ret A kp ki n m mf.
