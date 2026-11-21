From PprzTrigPlainNoError Require Import Spec.
From PprzTrigPlainVerification Require Import Precondition.
Require PprzTrigRelationProof.Proof.
Theorem proved:Spec.Goal.
Proof. intros args m PRE;destruct PRE as[a[ARGS[INIT RANGE]]];subst args. exact(proj1(PprzTrigRelationProof.Proof.plain_sine_total m a INIT RANGE)). Qed.
Print Assumptions proved.
