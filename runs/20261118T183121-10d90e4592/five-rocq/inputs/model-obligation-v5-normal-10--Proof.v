From PprzTrigInitNoError Require Import Spec.
From PprzTrigInitVerification Require Import Precondition.
Require PprzTrigRelationProof.Proof.
Theorem proved:Spec.Goal.
Proof. intros args m PRE;destruct PRE as[ARGS INIT];subst args. exact(proj1(PprzTrigRelationProof.Proof.initializer_total m INIT)). Qed.
Print Assumptions proved.
