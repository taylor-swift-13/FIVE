From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import PidTermination.
From PidPositionTranslationAttempt002 Require Import ByteAgreement.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent E.ge.
Lemma original_global_environment :
 genv_genv E.ge=Genv.globalenv(program_of_program S.prog).
Proof.
 unfold E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_genv];reflexivity.
Qed.
Local Opaque E.ge.

Lemma initialized_readonly_int32 : forall m b gv n,
 global_bytes_initialized m ->
 Genv.find_var_info E.ge b=Some gv ->
 gvar_info gv=tint ->
 gvar_readonly gv=true ->
 gvar_volatile gv=false ->
 gvar_init gv=[Init_int32 n] ->
 Mem.load Mint32 m b 0=Some(Vint n).
Proof.
 intros m b gv n[init[INIT GLOBAL]]VAR TY RO VOL DATA.
 destruct(GLOBAL b gv VAR)as[READABLE BYTES].
 assert(VAR0:Genv.find_var_info(Genv.globalenv(program_of_program S.prog))b=Some gv).
 { rewrite<-original_global_environment;exact VAR. }
 destruct(Genv.init_mem_characterization S.prog b VAR0 INIT)as[_[_[LOAD _]]].
 specialize(LOAD VOL);rewrite DATA in LOAD;cbn[Genv.load_store_init_data]in LOAD.
 destruct LOAD as[LOAD _].
 eapply scalar_load_from_equal_units;[exact LOAD|].
 intros i RANGE;symmetry;apply BYTES;[exact RO|].
 rewrite TY;change(0<=0+i<4);cbn in RANGE;lia.
Qed.

Local Transparent PidTermination.ge PidTermination.ast_prog.
Lemma actual_trajectory_constant :
 exists b,Genv.find_symbol E.ge S._traj_max_bank=Some b /\
 Genv.find_var_info E.ge b=Some S.v_traj_max_bank.
Proof.
 exists(PidTermination.symbol_block S._traj_max_bank);split.
 - change(Genv.find_symbol(genv_genv PidTermination.ge)S._traj_max_bank=Some(PidTermination.symbol_block S._traj_max_bank)).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
 - change(Genv.find_var_info(genv_genv PidTermination.ge)(PidTermination.symbol_block S._traj_max_bank)=Some S.v_traj_max_bank).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
Qed.
Lemma actual_total_constant :
 exists b,Genv.find_symbol E.ge S._total_max_bank=Some b /\
 Genv.find_var_info E.ge b=Some S.v_total_max_bank.
Proof.
 exists(PidTermination.symbol_block S._total_max_bank);split.
 - change(Genv.find_symbol(genv_genv PidTermination.ge)S._total_max_bank=Some(PidTermination.symbol_block S._total_max_bank)).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
 - change(Genv.find_var_info(genv_genv PidTermination.ge)(PidTermination.symbol_block S._total_max_bank)=Some S.v_total_max_bank).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
Qed.
Lemma inputgood_static_limits : forall m gh ret,
 InputGood m gh ret ->
 exists trajectory total,
 Genv.find_symbol E.ge S._traj_max_bank=Some trajectory /\
 Genv.find_symbol E.ge S._total_max_bank=Some total /\
 Mem.load Mint32 m trajectory 0=Some(Vint(Int.repr 1429)) /\
 Mem.load Mint32 m total 0=Some(Vint(Int.repr 3216)).
Proof.
 intros m gh ret[GOOD _].
 assert(INIT:global_bytes_initialized m)by(unfold InputGoodLegacy in GOOD;tauto).
 destruct actual_trajectory_constant as[traj[TS TV]].
 destruct actual_total_constant as[total[US UV]].
 exists traj,total;split;[exact TS|]. split;[exact US|]. split.
 - eapply initialized_readonly_int32 with(gv:=S.v_traj_max_bank);eauto;reflexivity.
 - eapply initialized_readonly_int32 with(gv:=S.v_total_max_bank);eauto;reflexivity.
Qed.
Print Assumptions inputgood_static_limits.
