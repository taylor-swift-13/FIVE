From Stdlib Require Import List Bool Lia.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From StateSpeedGetEcefF Require Import Source Execution.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure TableSupport.
Import ListNotations.
Definition ge:=Execution.ge.
Definition allowed:=TableSupport.allowed Source.global_definitions.
Definition budget:type->Csyntax.fundef->Prop:=fun _ _=>True.
Local Notation CS:=(SourceClosure.core_stmt ge allowed budget).
Definition check_signature(sig:type)(gd:ident*globdef Csyntax.fundef type):bool:=
 match snd gd with Gfun fd=>
 if type_eq(type_of_fundef fd)sig then
 match fd with Internal _=>true|External ef _ _ _=>executable_builtin ef end
 else true|_=>true end.
Lemma checked_calls:forall params result conv out,
 forallb(check_signature(Tfunction params result conv))Source.global_definitions=true ->
 SourceClosure.valid_call ge allowed budget(Tfunction params result conv)out.
Proof.
 intros params result conv out CHECK vf fd tys ret cc FIND CLASS TY.
 cbn[classify_fun]in CLASS;inversion CLASS;subst.
 destruct(TableSupport.global_function_in Source.prog vf fd FIND)as[id IN].
 apply forallb_forall with(x:=(id,Gfun fd))in CHECK;[|exact IN].
 unfold check_signature in CHECK;cbn[snd]in CHECK;rewrite TY in CHECK.
 match type of CHECK with context[type_eq ?a ?a]=>destruct(type_eq a a);[|contradiction]end.
 split;[destruct fd;cbn[allowed TableSupport.allowed]in *;[exists id;exact IN|exact CHECK]|exact I].
Qed.
Lemma calc_call:SourceClosure.valid_call ge allowed budget(Tfunction[]tvoid cc_default)tvoid.
Proof. apply checked_calls;vm_compute;reflexivity. Qed.
Lemma ned_call:SourceClosure.valid_call ge allowed budget
 (Tfunction[tptr(Tstruct Source._EcefCoor_f noattr);tptr(Tstruct Source._LtpDef_f noattr);tptr(Tstruct Source._NedCoor_f noattr)]tvoid cc_default)tvoid.
Proof. apply checked_calls;vm_compute;reflexivity. Qed.
Lemma enu_call:SourceClosure.valid_call ge allowed budget
 (Tfunction[tptr(Tstruct Source._EcefCoor_f noattr);tptr(Tstruct Source._LtpDef_f noattr);tptr(Tstruct Source._EnuCoor_f noattr)]tvoid cc_default)tvoid.
Proof. apply checked_calls;vm_compute;reflexivity. Qed.
Ltac build_core:=repeat match goal with|-_ /\ _=>split|-True=>exact I end;
 try reflexivity;try exact calc_call;try exact ned_call;try exact enu_call.
Lemma enu_core:CS(fn_body Source.f_ecef_of_enu_vect_f).
Proof. cbn[fn_body Source.f_ecef_of_enu_vect_f SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma ned_core:CS(fn_body Source.f_ecef_of_ned_vect_f).
Proof. cbn[fn_body Source.f_ecef_of_ned_vect_f SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma calc_core:CS(fn_body Source.f_stateCalcSpeedEcef_f).
Proof. cbn[fn_body Source.f_stateCalcSpeedEcef_f SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma getter_core:CS(fn_body Source.f_stateGetSpeedEcef_f).
Proof. cbn[fn_body Source.f_stateGetSpeedEcef_f SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma internal_body:forall f,allowed(Internal f)->CS(fn_body f).
Proof.
 intros f[id IN];pose proof(internal_functions_in _ _ _ IN)as IF.
 change(In f[Source.f_ecef_of_enu_vect_f;Source.f_ecef_of_ned_vect_f;Source.f_stateCalcSpeedEcef_f;Source.f_stateGetSpeedEcef_f])in IF.
 destruct IF as[EQ|[EQ|[EQ|[EQ|IF]]]];try contradiction;subst f;auto using enu_core,ned_core,calc_core,getter_core.
Qed.
Lemma external_supported:forall ef args ret cc,allowed(External ef args ret cc)->executable_builtin ef=true.
Proof. auto. Qed.
Definition source_state:=SourceClosure.source_state ge allowed budget.
Theorem entry_source:forall args m,source_state(Execution.entry args m).
Proof. intros;split;[|constructor];exists Source._stateGetSpeedEcef_f;cbn[Source.global_definitions In];repeat first[left;reflexivity|right]. Qed.
Theorem source_step_invariant:forall s t next,source_state s->Csem.step ge s t next->t=E0 /\source_state next.
Proof. exact(SourceClosure.source_step_invariant ge allowed budget internal_body external_supported). Qed.
Theorem one_step_correspondence:forall cb asm w s t next,source_state s->
 ((exists rule,In(TR rule t next)(Cexec.do_step ge cb asm w s))<->Csem.step ge s t next).
Proof. exact(SourceClosure.source_do_step_exact ge allowed budget internal_body external_supported). Qed.
Theorem source_reachable:forall args m t reached,star Csem.step ge(Execution.entry args m)t reached->source_state reached.
Proof. intros args m t reached PATH;pose proof(entry_source args m)as INIT;induction PATH;auto;apply IHPATH;exact(proj2(source_step_invariant _ _ _ INIT H)). Qed.
Definition closed_step:=Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Theorem whole_execution_correspondence:forall args m t final,
 star closed_step tt(Execution.entry args m)t final<->star Csem.step ge(Execution.entry args m)t final.
Proof.
 intros args m t final;split;intro PATH;pose proof(entry_source args m)as INIT;
 revert INIT;induction PATH;intros INV;[constructor| |constructor|].
 - pose proof(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV)H)as STEP.
   eapply star_step;[exact STEP|apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV STEP))|assumption].
 - eapply star_step.
   + apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact H.
   + apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV H)).
   + assumption.
Qed.
Theorem invalid_operation_correspondence:forall args m t reached,
 star Csem.step ge(Execution.entry args m)t reached->
 (Execution.source_error reached<->~Execution.normal_return reached /\nostep closed_step tt reached).
Proof.
 intros args m t reached PATH;pose proof(source_reachable _ _ _ _ PATH)as INV.
 unfold Execution.source_error;split;intros[N STOP];split;auto;intros tr nxt STEP;apply(STOP tr nxt).
 - apply(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
 - apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
Qed.
Print Assumptions entry_source.
Print Assumptions one_step_correspondence.
Print Assumptions whole_execution_correspondence.
Print Assumptions invalid_operation_correspondence.
