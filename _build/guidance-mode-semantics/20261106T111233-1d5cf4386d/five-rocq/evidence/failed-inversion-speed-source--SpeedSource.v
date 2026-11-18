From Stdlib Require Import List Bool Lia.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Smallstep Csyntaxdefs.
From FiveShared.verification Require Import Obligations.
From FiveGhSpeed Require Import Source Execution.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure WeightedTermination SourceTermination.
Import ListNotations.

Definition sqrt_weight:nat := 10 + statement_rank(fun _=>0)(fn_body Source.f_five_sqrtf).
Definition void_weight:nat := 10 + statement_rank(fun ty=>if type_eq ty tfloat then sqrt_weight else 0)(fn_body Source.f_gh_saturate_accel).
Definition call_weight(ty:type):nat :=
 if type_eq ty tfloat then sqrt_weight else if type_eq ty tvoid then void_weight else 0.
Definition allowed(fd:Csyntax.fundef):Prop :=
 fd=Internal Source.f_five_sqrtf \/
 fd=Internal Source.f_gh_saturate_accel \/
 fd=Internal Source.f_gh_update_ref_from_speed_sp \/
 match fd with External ef _ _ _ => executable_builtin ef=true | _=>False end.
Definition budget := SourceTermination.static_budget call_weight.
Definition ge := Csem.globalenv Source.prog.
Local Notation CE := (SourceClosure.core_expr ge allowed budget).
Local Notation CS := (SourceClosure.core_stmt ge allowed budget).
Local Notation SS := (SourceClosure.source_state ge allowed budget).

Lemma float_call_closed:
 SourceClosure.valid_call ge allowed budget (Tfunction [tfloat] tfloat cc_default) tfloat.
Proof.
 intros vf fd tyargs tyres cc FIND CL TY.
 simpl in CL;inversion CL;subst tyargs tyres cc.
 destruct(Genv.find_funct_inversion _ _ FIND) as [id IN].
 change (In (id,Gfun fd) Source.global_definitions) in IN.
 cbn [Source.global_definitions In] in IN.
 repeat match goal with H:_ \/ _ |- _ => destruct H as [EQ|H];[inversion EQ;subst;clear EQ|] end;
 try contradiction;simpl in TY;try discriminate.
 all: split;[unfold allowed;auto;try (right;right;right;vm_compute;reflexivity)|unfold budget,SourceTermination.static_budget;vm_compute;lia].
Qed.

Lemma sat_call_closed:
 SourceClosure.valid_call ge allowed budget
 (Tfunction [tptr(Tstruct Source._FloatVect2 noattr)] tvoid cc_default) tvoid.
Proof.
 intros vf fd tyargs tyres cc FIND CL TY.
 simpl in CL;inversion CL;subst tyargs tyres cc.
 destruct(Genv.find_funct_inversion _ _ FIND) as [id IN].
 change (In (id,Gfun fd) Source.global_definitions) in IN.
 cbn [Source.global_definitions In] in IN.
 repeat match goal with H:_ \/ _ |- _ => destruct H as [EQ|H];[inversion EQ;subst;clear EQ|] end;
 try contradiction;simpl in TY;try discriminate.
 all: split;[unfold allowed;auto;try (right;right;right;vm_compute;reflexivity)|unfold budget,SourceTermination.static_budget;vm_compute;lia].
Qed.

Ltac build_core :=
 repeat match goal with
 | |- _ /\ _ => split
 | |- True => exact I end;
 try reflexivity; try exact float_call_closed;try exact sat_call_closed.
Lemma sqrt_body_core:CS(fn_body Source.f_five_sqrtf).
Proof. cbn [CS Source.f_five_sqrtf SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma sat_body_core:CS(fn_body Source.f_gh_saturate_accel).
Proof. cbn [CS Source.f_gh_saturate_accel SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma entry_body_core:CS(fn_body Source.f_gh_update_ref_from_speed_sp).
Proof. cbn [CS Source.f_gh_update_ref_from_speed_sp SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];build_core. Qed.
Lemma internal_body:forall f,allowed(Internal f) -> CS(fn_body f).
Proof.
 intros f [H|[H|[H|H]]];try contradiction;inversion H;subst;
 auto using sqrt_body_core,sat_body_core,entry_body_core.
Qed.
Lemma external_supported:forall ef args ret cc,
 allowed(External ef args ret cc) -> executable_builtin ef=true.
Proof. intros ef args ret cc [H|[H|[H|H]]];try discriminate;auto. Qed.

Theorem entry_source:forall args m,SS(Execution.entry args m).
Proof. intros;split;[right;right;left;reflexivity|constructor]. Qed.
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
