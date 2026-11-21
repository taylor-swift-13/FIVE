From PprzTrigPlain.proof Require Import Obligations.
From PprzTrigPlainVerification Require Import Precondition.
Definition Goal:Prop := PprzTrigPlain.proof.Obligations.termination_goal Precondition.precondition.
