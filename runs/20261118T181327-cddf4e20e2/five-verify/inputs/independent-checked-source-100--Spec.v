From PprzTrigInit.proof Require Import Obligations.
From PprzTrigInitVerification Require Import Precondition.
Definition Goal:Prop := PprzTrigInit.proof.Obligations.no_error_goal Precondition.precondition.
