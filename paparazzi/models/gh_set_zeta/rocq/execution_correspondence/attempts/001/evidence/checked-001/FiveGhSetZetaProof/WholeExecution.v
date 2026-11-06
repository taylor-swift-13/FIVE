From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveGhSetZeta Require Import Source Execution.
From FiveGhSetZetaProof Require Import SourceInvariant.
Import ListNotations.
Definition closed_step := Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Theorem domain_preservation : forall args m,
 Execution.entry args m=Callstate(Internal Source.f_gh_set_zeta)args Kstop m /\
 source_state(Execution.entry args m).
Proof. intros;split;[reflexivity|split;reflexivity]. Qed.
(** Exact raw transition equivalence simultaneously preserves every actual
    float/integer operation, load/store, evaluation order, trace and successor.
    No machine-value or memory restriction appears. *)
Theorem one_step_correspondence : forall s t next,
 source_state s -> (closed_step tt s t next <-> Csem.step Execution.ge s t next).
Proof. intros;apply source_do_step_exact;assumption. Qed.
Theorem whole_execution_correspondence : forall args m t final,
 star closed_step tt(Execution.entry args m)t final <->
 star Csem.step Execution.ge(Execution.entry args m)t final.
Proof.
 intros args m t final;split;intro PATH.
 - assert(SOURCE:source_state(Execution.entry args m))by(split;reflexivity).
   revert SOURCE;induction PATH;intros SOURCE;[constructor|].
   pose proof(proj1(one_step_correspondence _ _ _ SOURCE)H)as STEP.
   eapply star_step;[exact STEP|apply IHPATH;exact(proj2(source_step_invariant _ _ _ _ SOURCE STEP))|assumption].
 - assert(SOURCE:source_state(Execution.entry args m))by(split;reflexivity).
   revert SOURCE;induction PATH;intros SOURCE;[constructor|].
   eapply star_step;[apply(proj2(one_step_correspondence _ _ _ SOURCE));exact H|apply IHPATH;exact(proj2(source_step_invariant _ _ _ _ SOURCE H))|assumption].
Qed.
Theorem invalid_operation_correspondence : forall args m t reached,
 star Csem.step Execution.ge(Execution.entry args m)t reached ->
 (Execution.source_error reached <-> ~Execution.normal_return reached /\ nostep closed_step tt reached).
Proof.
 intros args m t reached PATH.
 assert(SOURCE:source_state reached).
 { assert(I:source_state(Execution.entry args m))by(split;reflexivity).
   revert I;induction PATH;intros I;auto;apply IHPATH;exact(proj2(source_step_invariant _ _ _ _ I H)). }
 unfold Execution.source_error;split;intros[N STOP];split;auto;intros tr nxt STEP;
 apply(STOP tr nxt);[apply(proj1(one_step_correspondence _ _ _ SOURCE))|apply(proj2(one_step_correspondence _ _ _ SOURCE))];exact STEP.
Qed.
Theorem normal_result_memory_correspondence : forall v m b ofs n,
 Execution.normal_return(Returnstate v Kstop m) /\
 Execution.observe_bytes m b ofs n=Mem.loadbytes m b ofs n.
Proof. intros;split;[exists v,m;reflexivity|reflexivity]. Qed.
Print Assumptions domain_preservation.
Print Assumptions one_step_correspondence.
Print Assumptions whole_execution_correspondence.
Print Assumptions invalid_operation_correspondence.
Print Assumptions normal_result_memory_correspondence.
