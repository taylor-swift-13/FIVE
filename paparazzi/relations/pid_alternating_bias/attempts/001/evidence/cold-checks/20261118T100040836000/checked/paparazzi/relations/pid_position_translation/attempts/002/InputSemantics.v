From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import PidTermination.
Import ListNotations.
Open Scope Z_scope.
Module S := PidPositionRunPos.Source.
Module E := PidPositionRunPos.Execution.
Local Transparent PidTermination.ge PidTermination.ast_prog.

Lemma actual_error_global_type : forall id b gv,
 In id[S._guidance_pid_pos_err;S._guidance_pid_speed_err] ->
 Genv.find_symbol E.ge id=Some b ->
 Genv.find_var_info E.ge b=Some gv ->
 gvar_info gv=vec_type.
Proof.
 intros id b gv IDS SYM VAR;destruct IDS as[<-|[<-|[]]].
 - change(Genv.find_symbol(genv_genv PidTermination.ge)S._guidance_pid_pos_err=Some b)in SYM.
   rewrite PidTermination.ge_base in SYM;vm_compute in SYM;injection SYM as EQ;subst b.
   match type of VAR with Genv.find_var_info _ ?bb= _=>change(Genv.find_var_info(genv_genv PidTermination.ge)bb=Some gv)in VAR end.
   rewrite PidTermination.ge_base in VAR;vm_compute in VAR;inversion VAR;reflexivity.
 - change(Genv.find_symbol(genv_genv PidTermination.ge)S._guidance_pid_speed_err=Some b)in SYM.
   rewrite PidTermination.ge_base in SYM;vm_compute in SYM;injection SYM as EQ;subst b.
   match type of VAR with Genv.find_var_info _ ?bb= _=>change(Genv.find_var_info(genv_genv PidTermination.ge)bb=Some gv)in VAR end.
   rewrite PidTermination.ge_base in VAR;vm_compute in VAR;inversion VAR;reflexivity.
Qed.

Lemma inputgood_error_global_writable : forall m gh ret id b,
 InputGood m gh ret ->
 In id[S._guidance_pid_pos_err;S._guidance_pid_speed_err] ->
 Genv.find_symbol E.ge id=Some b ->
 Mem.range_perm m b 0 8 Cur Writable.
Proof.
 intros m gh ret id b[GOOD _]IDS SYM.
 assert(WR:writable_controller_globals m)by(unfold InputGoodLegacy in GOOD;tauto).
 destruct(WR id ltac:(destruct IDS as[<-|[<-|[]]];cbn;tauto))as[bb[gv[SYM0[VAR RANGE]]]].
 rewrite SYM in SYM0;injection SYM0 as EQ;subst bb.
 rewrite(actual_error_global_type id b gv IDS SYM VAR)in RANGE.
 exact RANGE.
Qed.
Lemma inputgood_cached_flags : forall m gh ret sb,
 InputGood m gh ret ->Genv.find_symbol E.ge S._state=Some sb ->
 exists flags sflags,
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) /\
 Mem.load Mint16unsigned m sb 280=Some(Vint sflags) /\
 Int.and flags(Int.repr 2)=Int.repr 2 /\Int.and sflags(Int.repr 2)=Int.repr 2.
Proof.
 intros m gh ret sb[GOOD _]STATE.
 assert(CACHE:caches_valid m)by(unfold InputGoodLegacy in GOOD;tauto).
 destruct CACHE as[flags[sflags[POS[SPD[VALID SVALID]]]]].
 unfold load_global in POS,SPD;rewrite STATE in POS,SPD.
 exists flags,sflags;repeat split;assumption.
Qed.
Lemma inputgood_position_values : forall m gh ret sb,
 InputGood m gh ret ->Genv.find_symbol E.ge S._state=Some sb ->
 exists rx ry px py,
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) /\
 Mem.load Mint32 m sb 100=Some(Vint px) /\
 Mem.load Mint32 m sb 104=Some(Vint py).
Proof.
 intros m gh ret sb[_[INIT _]]STATE.
 destruct(INIT S._x ltac:(cbn;auto))as[rx[px[RX PX]]].
 destruct(INIT S._y ltac:(cbn;auto))as[ry[py[RY PY]]].
 unfold load_global in PX,PY;rewrite STATE in PX,PY.
 exists rx,ry,px,py;repeat split;assumption.
Qed.
Lemma inputgood_speed_values : forall m gh ret sb,
 InputGood m gh ret ->Genv.find_symbol E.ge S._state=Some sb ->
 exists sx sy vx vy,
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy) /\
 Mem.load Mint32 m sb 296=Some(Vint vx) /\
 Mem.load Mint32 m sb 300=Some(Vint vy).
Proof.
 intros m gh ret sb[GOOD _]STATE.
 assert(AX:forall axis,In axis[S._x;S._y] ->
 bounded_global m S._guidance_pid_trim_att_integrator vec_type[axis](-100000000)100000000 /\
 bounded_path m gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
 bounded_path m gh gh_type[S._ref;S._accel;axis](-10000)10000 /\
 bounded_global m S._state state_type[S._ned_speed_i;axis](-10000)10000)
 by(unfold InputGoodLegacy in GOOD;tauto).
 destruct(AX S._x ltac:(cbn;auto))as[_[[sx[SX _]][_[vx[VX _]]]]].
 destruct(AX S._y ltac:(cbn;auto))as[_[[sy[SY _]][_[vy[VY _]]]]].
 unfold load_global in VX,VY;rewrite STATE in VX,VY.
 exists sx,sy,vx,vy;repeat split;assumption.
Qed.
Print Assumptions inputgood_error_global_writable.
Print Assumptions inputgood_position_values.

Lemma actual_state_symbol : exists sb,Genv.find_symbol E.ge S._state=Some sb.
Proof.
 exists(PidTermination.symbol_block S._state).
 change(Genv.find_symbol(genv_genv PidTermination.ge)S._state=Some(PidTermination.symbol_block S._state)).
 rewrite PidTermination.ge_base;vm_compute;reflexivity.
Qed.

Lemma actual_global_variable_binding : forall id gv,
 PTree.get id(AST.prog_defmap PidTermination.ast_prog)=Some(Gvar gv) ->
 exists b,Genv.find_symbol E.ge id=Some b /\Genv.find_var_info E.ge b=Some gv.
Proof.
 intros id gv LOOK.
 destruct(proj1(Genv.find_def_symbol PidTermination.ast_prog id(Gvar gv))LOOK)as[b[SYM DEF]].
 exists b;split.
 - change(Genv.find_symbol(genv_genv PidTermination.ge)id=Some b).
   rewrite PidTermination.ge_base;exact SYM.
 - change(Genv.find_var_info(genv_genv PidTermination.ge)b=Some gv).
   rewrite PidTermination.ge_base;apply Genv.find_var_info_iff;exact DEF.
Qed.
