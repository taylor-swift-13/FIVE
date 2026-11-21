From Stdlib Require Import List.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem.
From FiveGuidanceAllOrder Require Import BlockExecution ContinuationLift.
From PidPositionSafety Require Import TaggedCallee HiddenResultPost.
Lemma block_context_function_scope:forall ge k f e mf s,
 block_context_invariant ge k f e mf s ->function_scope f s.
Proof.
 intros ge k f e mf s[raw[EQ[[BL DEN]OWN]]];subst s.
 destruct raw;cbn[plug_state function_scope block_state block_owner]in*;intuition discriminate.
Qed.
Lemma hidden_post_function_scope:forall ge f e k m mf sid ires br ret post s,
 HiddenResultPost.invariant ge f e k m mf sid ires br ret post s ->function_scope f s.
Proof.
 intros ge f e k m mf sid ires br ret post s[[st EQ]|BLOCK].
 - subst s;reflexivity.
 - eapply block_context_function_scope;exact BLOCK.
Qed.
Print Assumptions hidden_post_function_scope.
