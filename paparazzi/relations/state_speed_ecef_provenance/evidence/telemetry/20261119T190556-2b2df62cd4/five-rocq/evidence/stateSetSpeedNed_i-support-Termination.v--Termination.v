From Stdlib Require Import List.
From compcert Require Import AST Values Memory Ctypes Csyntax Csem.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure SourceTermination.
From StateSpeedSetNedI Require Import Source Execution.
Definition allowed(fd:Csyntax.fundef):Prop:=fd=Internal Source.f_stateSetSpeedNed_i.
Definition cost(_:type):nat:=0%nat.
Definition budget:=SourceTermination.static_budget cost.
Lemma internal_body:forall f,allowed(Internal f) ->
 SourceClosure.core_stmt Execution.ge allowed budget(fn_body f).
Proof.
 intros f EQ;unfold allowed in EQ;inversion EQ;subst f.
 cbn[fn_body Source.f_stateSetSpeedNed_i SourceClosure.core_stmt SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];repeat split;reflexivity.
Qed.
Lemma external_supported:forall ef args ret cc,allowed(External ef args ret cc) ->executable_builtin ef=true.
Proof. intros;unfold allowed in H;discriminate. Qed.
Theorem all_successor_termination:forall args m,
 Acc(successor Execution.ge)(Execution.entry args m).
Proof.
 intros args m;eapply(SourceTermination.source_all_successors_accessible Execution.ge allowed cost internal_body external_supported).
 split;[reflexivity|constructor].
Qed.
Print Assumptions all_successor_termination.
