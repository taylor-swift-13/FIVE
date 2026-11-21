From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import PidTermination.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Definition initializer_ready(d:ident*globdef Csyntax.fundef type):Prop:=
 match snd d with
 | Gfun _=>True
 | Gvar v=>Genv.init_data_list_aligned 0(gvar_init v) /\
   (forall id o,~In(Init_addrof id o)(gvar_init v))
 end.
Lemma all_original_initializers_ready : Forall initializer_ready S.global_definitions.
Proof.
 unfold S.global_definitions.
 let rec ready :=
 lazymatch goal with
 | |- Forall _ []=>apply Forall_nil
 | |- Forall _ (_::_)=>apply Forall_cons;
   [cbn[initializer_ready];
    first[exact I|split;
     [cbn[Genv.init_data_list_aligned Genv.init_data_alignment];split;[exists 0;reflexivity|exact I]
     |intros sym ofs BAD;cbn in BAD;intuition discriminate]]
   |ready]
 end in ready.
Qed.
Theorem original_initial_memory_exists : exists init,Genv.init_mem S.prog=Some init.
Proof.
 apply Genv.init_mem_exists;intros id gv IN.
 change(In(id,Gvar gv)(AST.prog_defs(program_of_program S.prog)))in IN.
 rewrite PidTermination.source_ast in IN.
 change(In(id,Gvar gv)S.global_definitions)in IN.
 pose proof(Forall_forall initializer_ready S.global_definitions)as RULE.
 destruct RULE as[ALL _].
 pose proof(ALL all_original_initializers_ready(id,Gvar gv)IN)as READY.
 cbn[initializer_ready]in READY;destruct READY as[AL NO].
 split;[exact AL|].
 intros sym ofs ADD;exfalso;apply(NO sym ofs);exact ADD.
Qed.
Lemma initialized_space_global_zero : forall init b gv len,
 Genv.init_mem S.prog=Some init ->
 Genv.find_var_info E.ge b=Some gv ->
 gvar_volatile gv=false ->gvar_init gv=[Init_space len] ->
 Genv.read_as_zero init b 0 len.
Proof.
 intros init b gv len INIT VAR VOL DATA.
 assert(BASE:genv_genv E.ge=Genv.globalenv(program_of_program S.prog)).
 { Local Transparent E.ge. unfold E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_genv];reflexivity. }
 rewrite BASE in VAR.
 destruct(Genv.init_mem_characterization S.prog b VAR INIT)as[_[_[LOAD _]]].
 specialize(LOAD VOL);rewrite DATA in LOAD;exact(proj1 LOAD).
Qed.
Print Assumptions original_initial_memory_exists.

Definition original_global_shape(d:ident*globdef Csyntax.fundef type):Prop:=
 match snd d with
 | Gfun _=>True
 | Gvar v=>gvar_volatile v=false /\init_data_list_size(gvar_init v)=sizeof ce(gvar_info v)
 end.
Lemma all_original_global_shapes : Forall original_global_shape S.global_definitions.
Proof.
 unfold S.global_definitions.
 let rec ready :=
 lazymatch goal with
 | |- Forall _ []=>apply Forall_nil
 | |- Forall _ (_::_)=>apply Forall_cons;
   [cbn[original_global_shape];first[exact I|split;reflexivity]|ready]
 end in ready.
Qed.
Local Transparent PidTermination.ge PidTermination.ast_prog.
Lemma original_variable_shape : forall b gv,
 Genv.find_var_info E.ge b=Some gv ->
 gvar_volatile gv=false /\init_data_list_size(gvar_init gv)=sizeof ce(gvar_info gv).
Proof.
 intros b gv VAR.
 change(Genv.find_var_info(genv_genv PidTermination.ge)b=Some gv)in VAR.
 rewrite PidTermination.ge_base in VAR.
 apply Genv.find_var_info_iff in VAR.
 destruct(Genv.find_def_inversion PidTermination.ast_prog b VAR)as[id IN].
 pose proof(Forall_forall original_global_shape S.global_definitions)as[RULE _].
 exact(RULE all_original_global_shapes(id,Gvar gv)IN).
Qed.
Lemma original_initial_memory_has_global_contract : forall init,
 Genv.init_mem S.prog=Some init ->global_bytes_initialized init.
Proof.
 intros init INIT;exists init;split;[exact INIT|].
 intros b gv VAR.
 destruct(original_variable_shape b gv VAR)as[VOL SIZE].
 assert(BASE:genv_genv E.ge=Genv.globalenv(program_of_program S.prog)).
 { Local Transparent E.ge. unfold E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_genv];reflexivity. }
 rewrite BASE in VAR.
 destruct(Genv.init_mem_characterization S.prog b VAR INIT)as[RANGE REST].
 split.
 - intros ofs OFS;eapply Mem.perm_implies.
   + apply RANGE;rewrite SIZE;exact OFS.
   + unfold Genv.perm_globvar;rewrite VOL;destruct(gvar_readonly gv);constructor.
 - intros RO ofs OFS;reflexivity.
Qed.
Print Assumptions original_initial_memory_has_global_contract.
