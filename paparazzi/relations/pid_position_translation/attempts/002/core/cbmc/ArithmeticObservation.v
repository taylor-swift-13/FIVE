From Stdlib Require Import Bool List.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem.
From PidPositionSafety Require Import TaggedCallee.
From CoreCBMC Require Import ArithmeticTree ArithmeticPhases.
Definition ready_expr_safe(ge:genv)(e:env)(m:mem)(a:expr):Prop:=
 (forall C op va ta vb tb ty,context RV RV C ->
 a=C(Ebinop op(Eval va ta)(Eval vb tb)ty) ->binary_safe op ta tb va vb) /\
 (forall C op va ta ty,context RV RV C ->
 a=C(Eunop op(Eval va ta)ty) ->unary_safe op ta va).
Definition arithmetic_observation(ge:genv)(owner:function)(s:Csem.state):Prop:=
 match s with ExprState f a k e m=>f=owner->ready_expr_safe ge e m a|_=>True end.
Lemma tree_ready_safe:forall ge e m a,arithmetic_tree ge e m a ->ready_expr_safe ge e m a.
Proof.
 intros ge e m a TREE;split.
 - intros C op va ta vb tb ty CT EQ;subst a.
   eapply arithmetic_observed_binary;[exact CT|reflexivity|exact TREE].
 - intros C op va ta ty CT EQ;subst a.
   eapply arithmetic_observed_unary;[exact CT|reflexivity|exact TREE].
Qed.
Lemma tree_state_observation:forall ge owner s,tree_state ge s->arithmetic_observation ge owner s.
Proof. intros ge owner s TREE;destruct s;cbn[arithmetic_observation tree_state]in*;try exact I;intros _;apply tree_ready_safe;exact TREE. Qed.
Lemma scope_other_observation:forall ge leaf owner s,
 function_scope leaf s->leaf<>owner ->arithmetic_observation ge owner s.
Proof.
 intros ge leaf owner s SC NE;destruct s;cbn[function_scope arithmetic_observation]in*;try exact I.
 intros EQ;congruence.
Qed.
Print Assumptions tree_ready_safe.
