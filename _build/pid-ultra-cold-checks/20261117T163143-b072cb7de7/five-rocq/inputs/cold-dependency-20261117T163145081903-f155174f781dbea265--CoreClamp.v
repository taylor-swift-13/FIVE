From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics.
Import ListNotations.
Open Scope Z_scope.
Fixpoint top_statement(n:nat)(s:statement):statement:=
 match n with O=>match s with Ssequence a _=>a|_=>s end
 |Datatypes.S n=>match s with Ssequence _ b=>top_statement n b|_=>Sskip end end.
Definition cmd_lvalue(axis:ident):expr:=Efield(Evalof(Efield(Evalof(Evar S._guidance_pid pid_type)pid_type)S._cmd_earth vec_type)vec_type)axis tint.
Definition max_rvalue(id:ident):expr:=Evalof(Evar id tint)tint.
Definition clamp_assignment(l mx:expr):statement:=Sdo(Eassign l(clamp_expr(Evalof l tint)mx)tint).
Definition trajectory_clamp:=top_statement 4(fn_body S.f_guidance_pid_h_run).
Definition total_clamp:=top_statement 7(fn_body S.f_guidance_pid_h_run).
Lemma trajectory_clamp_source:trajectory_clamp=
 Ssequence(clamp_assignment(cmd_lvalue S._x)(max_rvalue S._traj_max_bank))
 (clamp_assignment(cmd_lvalue S._y)(max_rvalue S._traj_max_bank)).
Proof. reflexivity. Qed.
Lemma total_clamp_source:total_clamp=
 Ssequence(clamp_assignment(cmd_lvalue S._x)(max_rvalue S._total_max_bank))
 (clamp_assignment(cmd_lvalue S._y)(max_rvalue S._total_max_bank)).
Proof. reflexivity. Qed.
Lemma command_scalar_clamp:forall e m bp bm maxid axis ofs value maximum mf,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!maxid=None ->Genv.find_symbol ge maxid=Some bm ->
 (axis=S._x/\ofs=32)\/(axis=S._y/\ofs=36) ->
 Mem.load Mint32 m bp ofs=Some(Vint value) ->Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Mem.store Mint32 m bp ofs(Vint(clip_bits value maximum))=Some mf ->
 exec_stmt ge e m(clamp_assignment(cmd_lvalue axis)(max_rvalue maxid))E0 mf Out_normal.
Proof.
 intros e m bp bm maxid axis ofs value maximum mf NP SP NM SM AX LOAD MAX STORE.
 assert(LV:eval_simple_lvalue ge e m(cmd_lvalue axis)bp(Ptrofs.repr ofs)Full).
 { destruct AX as[[-> ->]|[-> ->]];unfold cmd_lvalue,pid_type,vec_type;
   lazymatch goal with|-eval_simple_lvalue _ _ _ _ _(Ptrofs.repr ?n) _=>replace(Ptrofs.repr n)with(Ptrofs.add(Ptrofs.add Ptrofs.zero(Ptrofs.repr 32))(Ptrofs.repr(n-32)))by reflexivity end;core_lv I I I NP I I SP I I I I I I. }
 assert(RV:eval_simple_rvalue ge e m(Evalof(cmd_lvalue axis)tint)(Vint value)).
 { eapply read_scalar with(chunk:=Mint32);[exact LV|reflexivity|reflexivity|reflexivity|].
   destruct AX as[[-> ->]|[-> ->]];exact LOAD. }
 assert(MV:eval_simple_rvalue ge e m(max_rvalue maxid)(Vint maximum)).
 { unfold max_rvalue;eapply read_scalar with(chunk:=Mint32)(b:=bm)(ofs:=Ptrofs.zero);
   [apply esl_var_global;assumption|reflexivity|reflexivity|reflexivity|exact MAX]. }
 unfold clamp_assignment;eapply atomic_assign_expression;
 [exact LV|reflexivity|eapply int32_clamp_expression;[reflexivity|reflexivity|reflexivity|reflexivity|exact RV|exact MV]|reflexivity| |reflexivity].
 eapply assign_loc_value;[reflexivity|reflexivity|].
 destruct AX as[[-> ->]|[-> ->]];exact STORE.
Qed.
Definition clamp_updates(bp:block)(x y maximum:int):list scalar_update:=
 [(Mint32,bp,32,Vint(clip_bits x maximum));(Mint32,bp,36,Vint(clip_bits y maximum))].
Theorem command_pair_clamp_normal:forall e m bp bm maxid x y maximum,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!maxid=None ->Genv.find_symbol ge maxid=Some bm ->bp<>bm ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,
 exec_stmt ge e m(Ssequence(clamp_assignment(cmd_lvalue S._x)(max_rvalue maxid))(clamp_assignment(cmd_lvalue S._y)(max_rvalue maxid)))E0 mf Out_normal /\
 Mem.load Mint32 mf bp 32=Some(Vint(clip_bits x maximum)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(clip_bits y maximum)) /\raw_writes(fun b=>b=bp)m mf /\replay_stores m(clamp_updates bp x y maximum)=Some mf.
Proof.
 intros e m bp bm maxid x y maximum NP SP NM SM DIST LX LY LM AX AY.
 destruct(Mem.valid_access_store m Mint32 bp 32(Vint(clip_bits x maximum))AX)as[m1 ST1].
 assert(AY1:Mem.valid_access m1 Mint32 bp 36 Writable)by(eapply Mem.store_valid_access_1;eauto).
 destruct(Mem.valid_access_store m1 Mint32 bp 36(Vint(clip_bits y maximum))AY1)as[mf ST2].
 exists mf;split.
 - eapply sequence_normal.
   + eapply command_scalar_clamp with(value:=x)(maximum:=maximum);eauto;left;auto.
   + eapply command_scalar_clamp with(value:=y)(maximum:=maximum);eauto;try(right;auto);scalar_frame;assumption.
 - repeat split;try(scalar_frame;reflexivity).
   eapply raw_writes_store;[reflexivity|exact ST1|].
   eapply raw_writes_store;[reflexivity|exact ST2|constructor].
   cbv beta iota zeta delta[clamp_updates replay_stores];rewrite ST1,ST2;reflexivity.
Qed.
Corollary original_trajectory_clamp_normal:forall e m bp bm x y maximum,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bm ->bp<>bm ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,exec_stmt ge e m trajectory_clamp E0 mf Out_normal /\
 Mem.load Mint32 mf bp 32=Some(Vint(clip_bits x maximum)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(clip_bits y maximum)) /\raw_writes(fun b=>b=bp)m mf /\replay_stores m(clamp_updates bp x y maximum)=Some mf.
Proof. intros;rewrite trajectory_clamp_source;eapply command_pair_clamp_normal;eauto. Qed.
Print Assumptions original_trajectory_clamp_normal.
