From Stdlib Require Import Bool List Lia.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import SourceClosure WeightedTermination.
Section TERMINATION.
Variable ge:genv.
Variable allowed:Csyntax.fundef -> Prop.
Variable call_weight:type -> nat.
Definition static_budget (ty:type) (fd:Csyntax.fundef):Prop :=
 activation_rank call_weight fd + 2 < 1 + call_weight ty.
Local Notation CE := (SourceClosure.core_expr ge allowed static_budget).
Local Notation CS := (SourceClosure.core_stmt ge allowed static_budget).
Local Notation CK := (SourceClosure.core_cont ge allowed static_budget).
Local Notation SS := (SourceClosure.source_state ge allowed static_budget).
Hypothesis internal_body:forall f,allowed(Internal f) -> CS(fn_body f).
Hypothesis external_supported:forall ef args ret cc,
 allowed(External ef args ret cc) -> SemanticsSupport.executable_builtin ef=true.
Lemma core_statement_finite:forall s,CS s -> finite_statement s=true.
Proof. induction s;simpl;intros;repeat match goal with H:_ /\ _ |- _ => destruct H end;try contradiction;auto;apply andb_true_iff;auto. Qed.
Lemma core_continuation_finite:forall k,CK k -> finite_continuation k.
Proof. induction 1;eauto using finite_continuation,core_statement_finite. Qed.
Lemma source_state_finite:forall s,SS s -> finite_state s.
Proof. destruct s;simpl;intros;repeat match goal with H:_ /\ _ |- _ => destruct H end;auto using core_continuation_finite,core_statement_finite. Qed.
Lemma cast_arguments_rank:forall m el types vals,
 cast_arguments m el types vals -> expressionlist_rank call_weight el=0.
Proof. induction 1;simpl;auto. Qed.
Lemma source_calls_bounded:forall s,SS s -> calls_within_budget call_weight ge s.
Proof.
 destruct s;simpl;auto;intros [CO CK0] C a fd args ty CT EQ RED;subst r.
 pose proof(SourceClosure.core_context_hole ge allowed static_budget _ _ _ CT a CO) as CA.
 destruct(SourceClosure.core_callred ge allowed static_budget _ _ _ _ _ CA RED) as [AL [BUD REST]].
 unfold static_budget in BUD.
 inversion RED;subst;simpl.
 pose proof(cast_arguments_rank _ _ _ _ H0) as AR;rewrite AR;lia.
Qed.
Theorem source_all_successors_accessible:
 forall s,SS s -> Acc(successor ge)s.
Proof.
 eapply all_successors_accessible.
 - apply source_state_finite.
 - apply source_calls_bounded.
 - intros;exact(proj2(SourceClosure.source_step_invariant ge allowed static_budget internal_body external_supported _ _ _ H H0)).
Qed.
End TERMINATION.
Print Assumptions source_all_successors_accessible.
