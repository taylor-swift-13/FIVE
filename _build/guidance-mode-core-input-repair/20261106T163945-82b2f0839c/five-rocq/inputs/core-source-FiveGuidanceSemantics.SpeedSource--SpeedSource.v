From Stdlib Require Import List Bool Lia Arith.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Smallstep Csyntaxdefs.
From FiveShared.verification Require Import Obligations.
From FiveGhSpeed Require Import Source Execution.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure WeightedTermination SourceTermination TableSupport.
Import ListNotations.

Definition sqrt_weight:nat := 10 + statement_rank(fun _=>0)(fn_body Source.f_five_sqrtf).
Definition void_weight:nat := 10 + statement_rank(fun ty=>if type_eq ty tfloat then sqrt_weight else 0)(fn_body Source.f_gh_saturate_accel).
Definition call_weight(ty:type):nat :=
 if type_eq ty tfloat then sqrt_weight else if type_eq ty tvoid then void_weight else 0.
Definition allowed := TableSupport.allowed Source.global_definitions.
Definition budget := SourceTermination.static_budget call_weight.
Definition ge := Csem.globalenv Source.prog.
Local Notation CE := (SourceClosure.core_expr ge allowed budget).
Local Notation CS := (SourceClosure.core_stmt ge allowed budget).
Local Notation SS := (SourceClosure.source_state ge allowed budget).

Definition check_global := TableSupport.check_global call_weight.
Lemma function_in_global:forall v fd,Genv.find_funct ge v=Some fd -> exists id,In(id,Gfun fd)Source.global_definitions.
Proof. intros;exact(TableSupport.global_function_in Source.prog _ _ H). Qed.
Lemma checked_float_table:
 forallb(check_global(Tfunction[tfloat]tfloat cc_default)tfloat) Source.global_definitions=true.
Proof. vm_compute;reflexivity. Qed.
Lemma checked_sat_table:
 forallb(check_global(Tfunction[tptr(Tstruct Source._FloatVect2 noattr)]tvoid cc_default)tvoid) Source.global_definitions=true.
Proof. vm_compute;reflexivity. Qed.

Lemma float_call_closed:
 SourceClosure.valid_call ge allowed budget (Tfunction [tfloat] tfloat cc_default) tfloat.
Proof. apply(TableSupport.checked_call_closed ge Source.global_definitions call_weight function_in_global);exact checked_float_table. Qed.
Lemma sat_call_closed:
 SourceClosure.valid_call ge allowed budget
 (Tfunction [tptr(Tstruct Source._FloatVect2 noattr)] tvoid cc_default) tvoid.
Proof. apply(TableSupport.checked_call_closed ge Source.global_definitions call_weight function_in_global);exact checked_sat_table. Qed.

Ltac build_core :=
 repeat match goal with
 | |- _ /\ _ => split
 | |- True => exact I end;
 try reflexivity; try exact float_call_closed;try exact sat_call_closed.
Lemma sqrt_body_core:CS(fn_body Source.f_five_sqrtf).
Proof. cbn [fn_body CS Source.f_five_sqrtf SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma sat_body_core:CS(fn_body Source.f_gh_saturate_accel).
Proof. cbn [fn_body CS Source.f_gh_saturate_accel SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma entry_body_core:CS(fn_body Source.f_gh_update_ref_from_speed_sp).
Proof. cbn [fn_body CS Source.f_gh_update_ref_from_speed_sp SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma internal_body:forall f,allowed(Internal f) -> CS(fn_body f).
Proof.
 intros f [id IN].
 pose proof(internal_functions_in _ _ _ IN) as IF.
 change (In f [Source.f_five_sqrtf;Source.f_gh_update_ref_from_speed_sp;Source.f_gh_saturate_accel]) in IF.
 destruct IF as [EQ|[EQ|[EQ|IF]]];try contradiction;subst f;
 auto using sqrt_body_core,sat_body_core,entry_body_core.
Qed.
Lemma external_supported:forall ef args ret cc,
 allowed(External ef args ret cc) -> executable_builtin ef=true.
Proof. auto. Qed.

Theorem entry_source:forall args m,SS(Execution.entry args m).
Proof.
 intros;split;[|constructor].
 exists Source._gh_update_ref_from_speed_sp.
 cbn [Source.global_definitions In].
 repeat first [left;reflexivity|right].
Qed.
Theorem source_step_invariant:forall s t s',SS s -> Csem.step ge s t s' -> t=E0 /\ SS s'.
Proof. exact(SourceClosure.source_step_invariant ge allowed budget internal_body external_supported). Qed.
Theorem all_successor_termination:forall args m,
 Acc(successor ge)(Execution.entry args m).
Proof. intros;apply(SourceTermination.source_all_successors_accessible ge allowed call_weight internal_body external_supported);apply entry_source. Qed.
Theorem one_step_correspondence:forall cb asm w s t s',SS s ->
 ((exists rule,In(TR rule t s')(Cexec.do_step ge cb asm w s)) <-> Csem.step ge s t s').
Proof. exact(SourceClosure.source_do_step_exact ge allowed budget internal_body external_supported). Qed.
Print Assumptions all_successor_termination.
Print Assumptions one_step_correspondence.


Definition closed_step := Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Theorem source_reachable:forall args m t reached,
 star Csem.step ge(Execution.entry args m)t reached -> SS reached.
Proof.
 intros args m t reached PATH.
 pose proof(entry_source args m) as INIT.
 induction PATH;auto;apply IHPATH;exact(proj2(source_step_invariant _ _ _ INIT H)).
Qed.
Theorem whole_execution_correspondence:forall args m t final,
 star closed_step tt(Execution.entry args m)t final <->
 star Csem.step ge(Execution.entry args m)t final.
Proof.
 intros args m t final;split;intro PATH;
 pose proof(entry_source args m) as INIT;
 revert INIT;induction PATH;intros INV;[constructor| |constructor|].
 - pose proof(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV)H)as STEP.
   eapply star_step;[exact STEP|apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV STEP))|assumption].
 - eapply star_step.
   + apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact H.
   + apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV H)).
   + assumption.
Qed.
Theorem invalid_operation_correspondence:forall args m t reached,
 star Csem.step ge(Execution.entry args m)t reached ->
 (Execution.source_error reached <->
 ~Execution.normal_return reached /\ nostep closed_step tt reached).
Proof.
 intros args m t reached PATH.
 pose proof(source_reachable _ _ _ _ PATH)as INV.
 unfold Execution.source_error;split;intros[N STOP];split;auto;intros tr nxt STEP;apply(STOP tr nxt).
 - apply(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
 - apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
Qed.
Theorem normal_result_memory_correspondence:forall v m b ofs n,
 Execution.normal_return(Returnstate v Kstop m) /\
 Execution.observe_bytes m b ofs n=Mem.loadbytes m b ofs n.
Proof. intros;split;[exists v,m;reflexivity|reflexivity]. Qed.
Print Assumptions whole_execution_correspondence.
Print Assumptions invalid_operation_correspondence.

Print Assumptions entry_source.

Print Assumptions source_step_invariant.

Print Assumptions source_reachable.

Print Assumptions normal_result_memory_correspondence.
