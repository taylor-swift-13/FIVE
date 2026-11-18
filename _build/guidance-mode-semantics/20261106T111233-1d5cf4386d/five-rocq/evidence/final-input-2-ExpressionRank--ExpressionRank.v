From Stdlib Require Import Arith Lia Wellfounded.
From compcert Require Import Csyntax Csem Events.
From FiveShared.verification Require Import Obligations.

(** Exact expression reduction measure.  Compound assignments and increment
    reserve the cost of their actual Csem expansion.  Calls are counted here;
    lifting this measure over function activation requires a call-graph weight. *)
Fixpoint expression_rank (a:expr):nat :=
 match a with
 | Eval _ _ | Eloc _ _ _ _ => 0
 | Evar _ _ | Esizeof _ _ | Ealignof _ _ => 1
 | Efield a _ _ | Evalof a _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _ => S(expression_rank a)
 | Ebinop _ a b _ | Eassign a b _ | Ecomma a b _ =>
   S(expression_rank a + expression_rank b)
 | Eassignop _ a b _ _ => 3 + expression_rank a + expression_rank b
 | Epostincr _ a _ => 4 + expression_rank a
 | Eseqand a b _ | Eseqor a b _ => 2 + expression_rank a + expression_rank b
 | Econdition a b c _ => 2 + expression_rank a + expression_rank b + expression_rank c
 | Ecall a al _ => 1 + expression_rank a + expressionlist_rank al
 | Ebuiltin _ _ al _ => 1 + expressionlist_rank al
 end
with expressionlist_rank (al:exprlist):nat :=
 match al with Enil => 0 | Econs a al => expression_rank a + expressionlist_rank al end.

Theorem lred_rank_decreases: forall ge e a m a' m',
 lred ge e a m a' m' -> expression_rank a' < expression_rank a.
Proof. intros; inversion H; subst; simpl; try lia; try (destruct b; simpl; lia). Qed.

Theorem rred_rank_decreases: forall ge a m t a' m',
 rred ge a m t a' m' -> expression_rank a' < expression_rank a.
Proof. intros; inversion H; subst; simpl; try lia; try (destruct b; simpl; lia). Qed.

Scheme context_rank_ind := Induction for context Sort Prop
with contextlist_rank_ind := Induction for contextlist Sort Prop.
Combined Scheme contexts_rank_ind from context_rank_ind, contextlist_rank_ind.

Lemma context_rank_decreases_mut:
 (forall from to C, context from to C -> forall a b,
 expression_rank b < expression_rank a ->
 expression_rank (C b) < expression_rank (C a)) /\
 (forall from C, contextlist from C -> forall a b,
 expression_rank b < expression_rank a ->
 expressionlist_rank (C b) < expressionlist_rank (C a)).
Proof.
 apply contexts_rank_ind; simpl; intros; try lia;
 match goal with IH:forall a b, _ |- _ =>
   specialize(IH a b ltac:(assumption)); lia end.
Qed.

Theorem context_rank_decreases:
 forall from to C, context from to C -> forall a b,
 expression_rank b < expression_rank a ->
 expression_rank (C b) < expression_rank (C a).
Proof. exact (proj1 context_rank_decreases_mut). Qed.

Theorem contextlist_rank_decreases:
 forall from C, contextlist from C -> forall a b,
 expression_rank b < expression_rank a ->
 expressionlist_rank (C b) < expressionlist_rank (C a).
Proof. exact (proj2 context_rank_decreases_mut). Qed.

Print Assumptions lred_rank_decreases.
Print Assumptions rred_rank_decreases.
Print Assumptions context_rank_decreases.


Definition expression_state_rank (s:Csem.state):nat :=
 match s with ExprState _ a _ _ _ => S(expression_rank a) | _ => 0 end.
Definition expression_successor (ge:genv) (next current:Csem.state):Prop :=
 exists t, Csem.estep ge current t next.

Theorem estep_rank_decreases: forall ge s t s',
 Csem.estep ge s t s' -> expression_state_rank s' < expression_state_rank s.
Proof.
 intros ge s t s' STEP; inversion STEP; subst; simpl.
 - pose proof(lred_rank_decreases _ _ _ _ _ _ H).
   pose proof(context_rank_decreases _ _ _ H0 _ _ H1). lia.
 - pose proof(rred_rank_decreases _ _ _ _ _ _ H).
   pose proof(context_rank_decreases _ _ _ H0 _ _ H1). lia.
 - lia.
 - lia.
Qed.

(** All possible expression successors are accessible, including call transfer
    and error.  This theorem concerns expression reduction only: whole-program
    termination additionally requires a finite acyclic call graph and statements. *)
Theorem all_expression_successors_accessible: forall ge s,
 Acc (expression_successor ge) s.
Proof.
 intros ge.
 apply (well_founded_induction (well_founded_ltof _ expression_state_rank)).
 intros s IH; constructor; intros next [t STEP]; apply IH.
 unfold ltof; eapply estep_rank_decreases; eauto.
Qed.

Print Assumptions all_expression_successors_accessible.
