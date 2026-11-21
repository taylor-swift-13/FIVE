From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import PidTermination FactoryCall.
From PidPositionTranslationAttempt002 Require Import Nonvacuity WitnessMemory InputSemantics ReadOnlySemantics.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent PidTermination.ge PidTermination.ast_prog.
Lemma initialized_writable_space : forall init b gv len,
 Genv.init_mem S.prog=Some init ->Genv.find_var_info E.ge b=Some gv ->
 gvar_volatile gv=false ->gvar_readonly gv=false ->gvar_init gv=[Init_space len] ->0<=len ->
 Mem.range_perm init b 0 len Cur Writable.
Proof.
 intros init b gv len INIT VAR VOL RO DATA POS.
 rewrite ReadOnlySemantics.original_global_environment in VAR.
 destruct(Genv.init_mem_characterization S.prog b VAR INIT)as[RANGE _].
 rewrite DATA in RANGE;cbn[init_data_list_size init_data_size]in RANGE.
 unfold Genv.perm_globvar in RANGE;rewrite VOL,RO in RANGE;rewrite Z.max_l in RANGE by lia;rewrite Z.add_0_r in RANGE;exact RANGE.
Qed.
Theorem symbolic_witness_base :
 exists base gh ret bp be bv bi bh sb,
 global_bytes_initialized base /\gh<>ret /\
 (forall id,Genv.find_symbol E.ge id<>Some gh) /\
 (forall id,Genv.find_symbol E.ge id<>Some ret) /\
 (forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>gh) /\
 Mem.range_perm base gh 0 84 Cur Writable /\Mem.range_perm base ret 0 36 Cur Writable /\
 Genv.find_symbol E.ge S._guidance_pid=Some bp /\Genv.find_var_info E.ge bp=Some S.v_guidance_pid /\
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some be /\Genv.find_var_info E.ge be=Some S.v_guidance_pid_pos_err /\
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some bv /\Genv.find_var_info E.ge bv=Some S.v_guidance_pid_speed_err /\
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some bi /\Genv.find_var_info E.ge bi=Some S.v_guidance_pid_trim_att_integrator /\
 Genv.find_symbol E.ge S._guidance_h=Some bh /\
 Genv.find_symbol E.ge S._state=Some sb /\Genv.find_var_info E.ge sb=Some S.v_state /\
 Mem.range_perm base bp 0 48 Cur Writable /\Mem.range_perm base be 0 8 Cur Writable /\
 Mem.range_perm base bv 0 8 Cur Writable /\Mem.range_perm base bi 0 8 Cur Writable /\
 Mem.range_perm base sb 0 656 Cur Writable /\
 Genv.read_as_zero base bp 0 48 /\Genv.read_as_zero base bi 0 8 /\
 Genv.read_as_zero base bh 0 84 /\Genv.read_as_zero base sb 0 656.
Proof.
 destruct original_initial_memory_exists as[init INIT].
 destruct(actual_global_variable_binding S._guidance_pid S.v_guidance_pid ltac:(vm_compute;reflexivity))as[bp[SP VP]].
 destruct(actual_global_variable_binding S._guidance_pid_pos_err S.v_guidance_pid_pos_err ltac:(vm_compute;reflexivity))as[be[SE VE]].
 destruct(actual_global_variable_binding S._guidance_pid_speed_err S.v_guidance_pid_speed_err ltac:(vm_compute;reflexivity))as[bv[SV VV]].
 destruct(actual_global_variable_binding S._guidance_pid_trim_att_integrator S.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
 destruct(actual_global_variable_binding S._guidance_h S.v_guidance_h ltac:(vm_compute;reflexivity))as[bh[SH VH]].
 destruct(actual_global_variable_binding S._state S.v_state ltac:(vm_compute;reflexivity))as[sb[SS VS]].
 assert(VALIDV:forall b gv,Genv.find_var_info E.ge b=Some gv ->Mem.valid_block init b).
 { intros b gv VAR;rewrite ReadOnlySemantics.original_global_environment in VAR.
   eapply Genv.find_var_info_not_fresh;[exact INIT|exact VAR]. }
 assert(VALIDS:forall id b,Genv.find_symbol E.ge id=Some b ->Mem.valid_block init b).
 { intros id b SYM;rewrite ReadOnlySemantics.original_global_environment in SYM.
   eapply Genv.find_symbol_not_fresh;[exact INIT|exact SYM]. }
 destruct(Mem.alloc init 0 84)as[m1 gh]eqn:AG.
 destruct(Mem.alloc m1 0 36)as[base ret]eqn:AR.
 assert(FGH:~Mem.valid_block init gh)by(eapply Mem.fresh_block_alloc;exact AG).
 assert(FRET:~Mem.valid_block m1 ret)by(eapply Mem.fresh_block_alloc;exact AR).
 assert(GHR:gh<>ret).
 { intro EQ;subst ret;apply FRET;eapply Mem.valid_new_block;exact AG. }
 assert(GSYM:forall id,Genv.find_symbol E.ge id<>Some gh).
 { intros id SYM;apply FGH;apply VALIDS with(id:=id);exact SYM. }
 assert(RSYM:forall id,Genv.find_symbol E.ge id<>Some ret).
 { intros id SYM;apply FRET;eapply Mem.valid_block_alloc;[exact AG|apply VALIDS with(id:=id);exact SYM]. }
 assert(GVAR:forall b gv,Genv.find_var_info E.ge b=Some gv ->b<>gh).
 { intros b gv VAR EQ;subst b;apply FGH;apply VALIDV with(gv:=gv);exact VAR. }
 assert(CONTRACT:global_bytes_initialized base).
 { eapply global_contract_after_allocation;[| |exact AR].
   - eapply global_contract_after_allocation;[apply original_initial_memory_has_global_contract;exact INIT|exact VALIDV|exact AG].
   - intros b gv VAR;eapply Mem.valid_block_alloc;[exact AG|apply VALIDV with(gv:=gv);exact VAR]. }
 assert(WGH:Mem.range_perm base gh 0 84 Cur Writable).
 { intros ofs R;eapply Mem.perm_alloc_1;[exact AR|].
   eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AG|exact R]|constructor]. }
 assert(WRET:Mem.range_perm base ret 0 36 Cur Writable).
 { intros ofs R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact AR|exact R]|constructor]. }
 assert(OLDPERM:forall b ofs k p,Mem.perm init b ofs k p ->Mem.perm base b ofs k p).
 { intros;eapply Mem.perm_alloc_1;[exact AR|];eapply Mem.perm_alloc_1;[exact AG|exact H]. }
 assert(OLDLOAD:forall ch b ofs,Mem.valid_block init b ->Mem.load ch base b ofs=Mem.load ch init b ofs).
 { intros ch b ofs VB;transitivity(Mem.load ch m1 b ofs).
   - eapply Mem.load_alloc_unchanged;[exact AR|eapply Mem.valid_block_alloc;[exact AG|exact VB]].
   - eapply Mem.load_alloc_unchanged;[exact AG|exact VB]. }
 assert(ZP:Genv.read_as_zero base bp 0 48).
 { pose proof(initialized_space_global_zero init bp S.v_guidance_pid 48 INIT VP eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_pid);exact VP);apply Z;assumption. }
 assert(ZI:Genv.read_as_zero base bi 0 8).
 { pose proof(initialized_space_global_zero init bi S.v_guidance_pid_trim_att_integrator 8 INIT VI eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_pid_trim_att_integrator);exact VI);apply Z;assumption. }
 assert(ZH:Genv.read_as_zero base bh 0 84).
 { pose proof(initialized_space_global_zero init bh S.v_guidance_h 84 INIT VH eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_guidance_h);exact VH);apply Z;assumption. }
 assert(ZS:Genv.read_as_zero base sb 0 656).
 { pose proof(initialized_space_global_zero init sb S.v_state 656 INIT VS eq_refl eq_refl)as Z.
   intros ch ofs LO HI AL;rewrite OLDLOAD by(apply VALIDV with(gv:=S.v_state);exact VS);apply Z;assumption. }
 exists base,gh,ret,bp,be,bv,bi,bh,sb.
 repeat(first[assumption|split]).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bp S.v_guidance_pid 48 INIT VP eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init be S.v_guidance_pid_pos_err 8 INIT VE eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bv S.v_guidance_pid_speed_err 8 INIT VV eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init bi S.v_guidance_pid_trim_att_integrator 8 INIT VI eq_refl eq_refl eq_refl ltac:(lia)ofs R).
 - intros ofs R;apply OLDPERM;exact(initialized_writable_space init sb S.v_state 656 INIT VS eq_refl eq_refl eq_refl ltac:(lia)ofs R).
Qed.
Print Assumptions symbolic_witness_base.
