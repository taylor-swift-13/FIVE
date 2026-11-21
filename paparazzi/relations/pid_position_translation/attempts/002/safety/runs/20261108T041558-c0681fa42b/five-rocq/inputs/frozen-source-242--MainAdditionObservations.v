From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import SnapshotInts AssertionSyntax AssertionEval LocalObservations MappedMain.
Import ListNotations.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.
Definition local_initial_state:ident:=100010%positive.
Inductive addition_case:=ReferenceX|ReferenceY|MeasuredX|MeasuredY.
Definition addition_axis(c:addition_case):ident:=match c with ReferenceX|MeasuredX=>S._x|_=>S._y end.
Definition addition_measured(c:addition_case):bool:=match c with MeasuredX|MeasuredY=>true|_=>false end.
Definition addition_type(c:addition_case):type:=if addition_measured c then state_type else gh_type.
Definition addition_local(c:addition_case):ident:=if addition_measured c then local_initial_state else local_a.
Definition addition_delta_local(c:addition_case):ident:=match c with ReferenceX|MeasuredX=>local_dx|_=>local_dy end.
Definition addition_offset(c:addition_case):Z:=match c with ReferenceX=>44|ReferenceY=>48|MeasuredX=>100|MeasuredY=>104 end.
Definition addition_delta(c:addition_case)(dx dy:Z):Z:=match c with ReferenceX|MeasuredX=>dx|_=>dy end.
Definition addition_expr(c:addition_case):expr:=
 Ebinop Oadd
 (if addition_measured c then
   member(member(object local_initial_state state_type)S._ned_pos_i(Tstruct S._NedCoor_i noattr))(addition_axis c)tint
  else gh_pos local_a(addition_axis c))
 (object(addition_delta_local c)tint)tint.
Definition addition_environment(c:addition_case)(source delta:block):env:=
 PTree.set(addition_delta_local c)(delta,tint)(local_one(addition_local c)(addition_type c)source).
Definition AdditionObservation(c:addition_case)(gh:block)(a b:mem)(dx dy:Z):Prop:=
 exists u v source delta intermediate observed,
 (if addition_measured c then load_global Mint32 a S._state state_type(measured_pos(addition_axis c))
 else load_path Mint32 a gh gh_type(ref_pos(addition_axis c)))=Some(Vint u) /\
 (if addition_measured c then load_global Mint32 b S._state state_type(measured_pos(addition_axis c))
 else load_path Mint32 b gh gh_type(ref_pos(addition_axis c)))=Some(Vint v) /\
 signed32(Int.signed u+addition_delta c dx dy) /\
 typed_snapshot(addition_type c)b[(addition_offset c,u)]source intermediate /\
 typed_snapshot tint intermediate[(0,Int.repr(addition_delta c dx dy))]delta observed /\
 eval_simple_rvalue E.ge(addition_environment c source delta)observed(addition_expr c)(Vint v) /\
 star Csem.step E.ge
 (ExprState S.f_guidance_pid_h_run_pos(addition_expr c)Kstop(addition_environment c source delta)observed)E0
 (ExprState S.f_guidance_pid_h_run_pos(Eval(Vint v)tint)Kstop(addition_environment c source delta)observed).
Definition MainAdditionObservationGoal(c:addition_case):Prop:=
 forall gh ret a b dx dy,InputPair gh ret a b dx dy ->AdditionObservation c gh a b dx dy.
Lemma addition_expr_eval:forall c e m bs bd u d,
 e!(addition_local c)=Some(bs,addition_type c) ->
 e!(addition_delta_local c)=Some(bd,tint) ->
 Mem.load Mint32 m bs(addition_offset c)=Some(Vint u) ->
 Mem.load Mint32 m bd 0=Some(Vint d) ->
 eval_simple_rvalue E.ge e m(addition_expr c)(Vint(Int.add u d)).
Proof.
 intros c;destruct c;intros;
 unfold addition_expr,addition_measured,addition_axis,addition_local,addition_type,
 addition_delta_local,addition_offset in *;cbn in *;
 unfold gh_pos,vector_axis,member,object,gh_type,state_type,vec_type;a_rv.
Qed.

Theorem main_referencex_addition_observation:MainAdditionObservationGoal ReferenceX.
Proof.
 intros gh ret a b dx dy PAIR.
 destruct(main_addition_x false gh ret a b dx dy PAIR)as[u[v[LU[LV[SAFE ADD]]]]].
 assert(BS:Forall(cell_bounds(sizeof E.ge gh_type))[(44,u)]).
 { rewrite assertion_ge_ce;let n:=eval vm_compute in(sizeof ce gh_type)in snapshot_bounds n. }
 assert(BD:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dx)])by(snapshot_bounds 4).
 destruct(typed_snapshot_exists gh_type b[(44,u)]BS ltac:(snapshot_separated))
 as[bs[intermediate[SS FS]]].
 destruct(typed_snapshot_exists tint intermediate[(0,Int.repr dx)]BD ltac:(snapshot_separated))
 as[bd[observed[SD FD]]].
 assert(SRC:Mem.load Mint32 observed bs 44=Some(Vint u)).
 { apply FD;apply(proj1(proj2 SS));cbn;auto. }
 assert(DELTA:Mem.load Mint32 observed bd 0=Some(Vint(Int.repr dx))).
 { apply(proj1(proj2 SD));cbn;auto. }
 assert(EVAL:eval_simple_rvalue E.ge(addition_environment ReferenceX bs bd)observed(addition_expr ReferenceX)(Vint v)).
 { rewrite <-ADD;eapply addition_expr_eval with(bs:=bs)(bd:=bd);
   [reflexivity|reflexivity|exact SRC|exact DELTA]. }
 exists u,v,bs,bd,intermediate,observed.
 split;[exact LU|];split;[exact LV|];split;[exact SAFE|];
 split;[exact SS|];split;[exact SD|];split;[exact EVAL|].
 exact(Cstrategy.eval_simple_rvalue_steps E.ge S.f_guidance_pid_h_run_pos Kstop
 (addition_environment ReferenceX bs bd)observed(addition_expr ReferenceX)(Vint v)EVAL(fun x=>x)(ctx_top RV)).
Qed.

Theorem main_referencey_addition_observation:MainAdditionObservationGoal ReferenceY.
Proof.
 intros gh ret a b dx dy PAIR.
 destruct(main_addition_y false gh ret a b dx dy PAIR)as[u[v[LU[LV[SAFE ADD]]]]].
 assert(BS:Forall(cell_bounds(sizeof E.ge gh_type))[(48,u)]).
 { rewrite assertion_ge_ce;let n:=eval vm_compute in(sizeof ce gh_type)in snapshot_bounds n. }
 assert(BD:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dy)])by(snapshot_bounds 4).
 destruct(typed_snapshot_exists gh_type b[(48,u)]BS ltac:(snapshot_separated))
 as[bs[intermediate[SS FS]]].
 destruct(typed_snapshot_exists tint intermediate[(0,Int.repr dy)]BD ltac:(snapshot_separated))
 as[bd[observed[SD FD]]].
 assert(SRC:Mem.load Mint32 observed bs 48=Some(Vint u)).
 { apply FD;apply(proj1(proj2 SS));cbn;auto. }
 assert(DELTA:Mem.load Mint32 observed bd 0=Some(Vint(Int.repr dy))).
 { apply(proj1(proj2 SD));cbn;auto. }
 assert(EVAL:eval_simple_rvalue E.ge(addition_environment ReferenceY bs bd)observed(addition_expr ReferenceY)(Vint v)).
 { rewrite <-ADD;eapply addition_expr_eval with(bs:=bs)(bd:=bd);
   [reflexivity|reflexivity|exact SRC|exact DELTA]. }
 exists u,v,bs,bd,intermediate,observed.
 split;[exact LU|];split;[exact LV|];split;[exact SAFE|];
 split;[exact SS|];split;[exact SD|];split;[exact EVAL|].
 exact(Cstrategy.eval_simple_rvalue_steps E.ge S.f_guidance_pid_h_run_pos Kstop
 (addition_environment ReferenceY bs bd)observed(addition_expr ReferenceY)(Vint v)EVAL(fun x=>x)(ctx_top RV)).
Qed.

Theorem main_measuredx_addition_observation:MainAdditionObservationGoal MeasuredX.
Proof.
 intros gh ret a b dx dy PAIR.
 destruct(main_addition_x true gh ret a b dx dy PAIR)as[u[v[LU[LV[SAFE ADD]]]]].
 assert(BS:Forall(cell_bounds(sizeof E.ge state_type))[(100,u)]).
 { rewrite assertion_ge_ce;let n:=eval vm_compute in(sizeof ce state_type)in snapshot_bounds n. }
 assert(BD:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dx)])by(snapshot_bounds 4).
 destruct(typed_snapshot_exists state_type b[(100,u)]BS ltac:(snapshot_separated))
 as[bs[intermediate[SS FS]]].
 destruct(typed_snapshot_exists tint intermediate[(0,Int.repr dx)]BD ltac:(snapshot_separated))
 as[bd[observed[SD FD]]].
 assert(SRC:Mem.load Mint32 observed bs 100=Some(Vint u)).
 { apply FD;apply(proj1(proj2 SS));cbn;auto. }
 assert(DELTA:Mem.load Mint32 observed bd 0=Some(Vint(Int.repr dx))).
 { apply(proj1(proj2 SD));cbn;auto. }
 assert(EVAL:eval_simple_rvalue E.ge(addition_environment MeasuredX bs bd)observed(addition_expr MeasuredX)(Vint v)).
 { rewrite <-ADD;eapply addition_expr_eval with(bs:=bs)(bd:=bd);
   [reflexivity|reflexivity|exact SRC|exact DELTA]. }
 exists u,v,bs,bd,intermediate,observed.
 split;[exact LU|];split;[exact LV|];split;[exact SAFE|];
 split;[exact SS|];split;[exact SD|];split;[exact EVAL|].
 exact(Cstrategy.eval_simple_rvalue_steps E.ge S.f_guidance_pid_h_run_pos Kstop
 (addition_environment MeasuredX bs bd)observed(addition_expr MeasuredX)(Vint v)EVAL(fun x=>x)(ctx_top RV)).
Qed.

Theorem main_measuredy_addition_observation:MainAdditionObservationGoal MeasuredY.
Proof.
 intros gh ret a b dx dy PAIR.
 destruct(main_addition_y true gh ret a b dx dy PAIR)as[u[v[LU[LV[SAFE ADD]]]]].
 assert(BS:Forall(cell_bounds(sizeof E.ge state_type))[(104,u)]).
 { rewrite assertion_ge_ce;let n:=eval vm_compute in(sizeof ce state_type)in snapshot_bounds n. }
 assert(BD:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dy)])by(snapshot_bounds 4).
 destruct(typed_snapshot_exists state_type b[(104,u)]BS ltac:(snapshot_separated))
 as[bs[intermediate[SS FS]]].
 destruct(typed_snapshot_exists tint intermediate[(0,Int.repr dy)]BD ltac:(snapshot_separated))
 as[bd[observed[SD FD]]].
 assert(SRC:Mem.load Mint32 observed bs 104=Some(Vint u)).
 { apply FD;apply(proj1(proj2 SS));cbn;auto. }
 assert(DELTA:Mem.load Mint32 observed bd 0=Some(Vint(Int.repr dy))).
 { apply(proj1(proj2 SD));cbn;auto. }
 assert(EVAL:eval_simple_rvalue E.ge(addition_environment MeasuredY bs bd)observed(addition_expr MeasuredY)(Vint v)).
 { rewrite <-ADD;eapply addition_expr_eval with(bs:=bs)(bd:=bd);
   [reflexivity|reflexivity|exact SRC|exact DELTA]. }
 exists u,v,bs,bd,intermediate,observed.
 split;[exact LU|];split;[exact LV|];split;[exact SAFE|];
 split;[exact SS|];split;[exact SD|];split;[exact EVAL|].
 exact(Cstrategy.eval_simple_rvalue_steps E.ge S.f_guidance_pid_h_run_pos Kstop
 (addition_environment MeasuredY bs bd)observed(addition_expr MeasuredY)(Vint v)EVAL(fun x=>x)(ctx_top RV)).
Qed.

Definition main_overflow_observation_1:MainAdditionObservationGoal ReferenceX:=main_referencex_addition_observation.
Definition main_overflow_observation_2:MainAdditionObservationGoal ReferenceY:=main_referencey_addition_observation.
Definition main_overflow_observation_3:MainAdditionObservationGoal MeasuredX:=main_measuredx_addition_observation.
Definition main_overflow_observation_4:MainAdditionObservationGoal MeasuredY:=main_measuredy_addition_observation.
Definition main_overflow_observation_5:MainAdditionObservationGoal ReferenceX:=main_referencex_addition_observation.
Definition main_overflow_observation_6:MainAdditionObservationGoal ReferenceY:=main_referencey_addition_observation.
Print Assumptions main_measuredx_addition_observation.
