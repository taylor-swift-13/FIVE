From PprzTrigLow.proof Require Import Obligations.
From PprzTrigLowVerification Require Import Precondition.
Definition Goal:Prop := PprzTrigLow.proof.Obligations.termination_goal Precondition.precondition.
