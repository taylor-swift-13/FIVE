From Stdlib Require Import List Bool.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Csyntax Csem Cexec Smallstep.
From FivePidDf Require Import Source Execution.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure.
Import ListNotations.
Definition ge := Csem.globalenv Source.prog.
Definition allowed (fd:Csyntax.fundef):Prop := fd=Internal Source.f_update_pid_df.
Definition budget (_:type)(_:Csyntax.fundef):Prop := True.
Definition SS := SourceClosure.source_state ge allowed budget.
Lemma entry_body_core:SourceClosure.core_stmt ge allowed budget(fn_body Source.f_update_pid_df).
Proof. cbn [fn_body Source.f_update_pid_df SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];repeat split;reflexivity. Qed.
Lemma internal_body:forall f,allowed(Internal f) -> SourceClosure.core_stmt ge allowed budget(fn_body f).
Proof. intros f H;unfold allowed in H;inversion H;subst;apply entry_body_core. Qed.
Lemma external_supported:forall ef args ret cc,allowed(External ef args ret cc) -> executable_builtin ef=true.
Proof. intros;unfold allowed in H;discriminate. Qed.
Theorem entry_source:forall args m,SS(Execution.entry args m).
Proof. intros;split;[reflexivity|constructor]. Qed.
Theorem source_step_invariant:forall s t s',SS s -> Csem.step ge s t s' -> t=E0 /\ SS s'.
Proof. exact(SourceClosure.source_step_invariant ge allowed budget internal_body external_supported). Qed.
Theorem one_step_correspondence:forall cb asm w s t s',SS s ->
 ((exists rule,In(TR rule t s')(Cexec.do_step ge cb asm w s)) <-> Csem.step ge s t s').
Proof. exact(SourceClosure.source_do_step_exact ge allowed budget internal_body external_supported). Qed.
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
Print Assumptions one_step_correspondence.
Print Assumptions whole_execution_correspondence.
Print Assumptions invalid_operation_correspondence.
