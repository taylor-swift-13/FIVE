From Stdlib Require Import Bool List.
From compcert Require Import Coqlib Maps Values Memory Events Ctypes Csyntax Csem.
From FiveGuidanceAllOrder Require Import AtomicDenotation BlockExecution ContinuationLift PhaseComposition.
Theorem atomic_expression_certificate:forall ge caller e k m mf a v,
 atomic_expr a=true ->atomic_eval ge e m a=Some(v,mf) ->
 certificate ge(block_context_invariant ge k caller e mf)(State caller Sskip k e mf) /\
 block_context_invariant ge k caller e mf(ExprState caller a(Kdo k)e m).
Proof.
 intros ge caller e k m mf a v SYNTAX EVAL;split.
 - split.
   + intros s INV;eapply block_context_progress;exact INV.
   + intros s t next INV NF STEP;eapply block_context_all_successors;eauto.
 - exists(ExprState caller a(Kdo Kstop)e m);split;[reflexivity|];split.
   + split.
     * cbn[block_state block_cont];rewrite SYNTAX;reflexivity.
     * cbn[block_denotation];rewrite EVAL;reflexivity.
   + split;reflexivity.
Qed.
Print Assumptions atomic_expression_certificate.
