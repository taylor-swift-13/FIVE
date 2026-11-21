From PprzTrigPlain.proof Require Import Obligations.
From PprzTrigPlainVerification Require Import Precondition.
Definition Goal:Prop := PprzTrigPlain.proof.Obligations.no_error_goal Precondition.precondition.
