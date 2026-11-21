From PprzTrigInitTermination Require Import Spec.
From PprzTrigInitVerification Require Import Precondition.
Require PprzTrigRelationProof.Proof.
Theorem proved:Spec.Goal.
Proof. intros args m PRE;destruct PRE as[ARGS INIT];subst args. exact(proj2(PprzTrigRelationProof.Proof.initializer_total m INIT)). Qed.
Print Assumptions proved.
