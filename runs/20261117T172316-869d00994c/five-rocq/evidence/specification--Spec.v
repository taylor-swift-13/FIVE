From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Globalenvs.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.

(** A deliberately restricted, admissible slice of full sign reversal:
    only x reference position is nonzero; the physical measurements, all
    velocities, accelerations, initial integrals and heading are zero.
    Both executions use the same flight flag and identical gains. *)
Definition MirrorInput (m:mem)(gh ret:block)(r:Z):Prop:=
 InputGood m gh ret /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint(Int.repr r)) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_pos_i;S._x]=Some(Vint Int.zero) /\
 load_global Mint32 m S._state state_type[S._ned_pos_i;S._y]=Some(Vint Int.zero) /\
 (forall axis,In axis[S._x;S._y]->
  load_path Mint32 m gh gh_type[S._ref;S._speed;axis]=Some(Vint Int.zero) /\
  load_path Mint32 m gh gh_type[S._ref;S._accel;axis]=Some(Vint Int.zero) /\
  load_global Mint32 m S._state state_type[S._ned_speed_i;axis]=Some(Vint Int.zero) /\
  load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint Int.zero)) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kp]=Some(Vint Int.one) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kd]=Some(Vint Int.zero) /\
 load_global Mint32 m S._guidance_pid pid_type[S._ki]=Some(Vint Int.one) /\
 load_global Mint32 m S._guidance_pid pid_type[S._kv]=Some(Vint Int.zero) /\
 load_global Mint32 m S._guidance_pid pid_type[S._ka]=Some(Vint Int.zero) /\
 load_global Mfloat32 m S._guidance_h gh_type[S._sp;S._heading]=Some(Vsingle Float32.zero).
Definition MirroredPair gh ret a b r:Prop:=
 MirrorInput a gh ret r /\ MirrorInput b gh ret (-r) /\
 same_except_positions_and_return gh ret a b.
Definition ObservedX (ret:block)(m:mem)(cmd integral:Z):Prop:=
 load_path Mint32 m ret sp_type[S._type]=Some(Vint(Int.repr 2)) /\
 load_path Mint32 m ret sp_type[S._format]=Some(Vint Int.zero) /\
 load_path Mint32 m ret sp_type[S._sp;S._ltp_i;S._vect;S._x]=Some(Vint(Int.repr cmd)) /\
 load_global Mint32 m S._guidance_pid pid_type[S._cmd_earth;S._x]=Some(Vint(Int.repr cmd)) /\
 load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[S._x]=Some(Vint(Int.repr integral)).
Definition OppositeReturnedX ret a b:Prop:=
 exists x y,
 load_path Mint32 a ret sp_type[S._sp;S._ltp_i;S._vect;S._x]=Some(Vint x) /\
 load_path Mint32 b ret sp_type[S._sp;S._ltp_i;S._vect;S._x]=Some(Vint y) /\
 Int.signed y = -Int.signed x.
Definition StrictSymmetryGoal:Prop:=
 forall gh ret a b r af bf, MirroredPair gh ret a b r ->
 NormalCall gh ret true a af ->NormalCall gh ret true b bf ->
 OppositeReturnedX ret af bf.
Definition ActualCounterexampleGoal:Prop:=
 exists gh ret a b af bf,
 MirroredPair gh ret a b 64 /\
 NormalCall gh ret true a af /\NormalCall gh ret true b bf /\
 ObservedX ret af 1 1 /\ObservedX ret bf (-2) (-1) /\
 ~OppositeReturnedX ret af bf.
Definition StrictSymmetryRefutedGoal:Prop:=~StrictSymmetryGoal.
