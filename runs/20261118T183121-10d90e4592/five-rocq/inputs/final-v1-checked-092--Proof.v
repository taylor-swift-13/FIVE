From PprzTrigLowNoError Require Import Spec.
From PprzTrigLowVerification Require Import Precondition.
Require PprzTrigRelationProof.Proof.
Theorem proved:Spec.Goal.
Proof. intros args m PRE;destruct PRE as[base[a[ARGS[INIT[RETURN RANGE]]]]];subst args. exact(proj1(PprzTrigRelationProof.Proof.low_sine_total base m a INIT RETURN RANGE)). Qed.
Print Assumptions proved.
