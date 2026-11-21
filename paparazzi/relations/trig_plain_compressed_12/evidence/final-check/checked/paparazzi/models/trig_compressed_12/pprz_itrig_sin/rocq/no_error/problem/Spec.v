From PprzTrigLow.proof Require Import Obligations.
From PprzTrigLowVerification Require Import Precondition.
Definition Goal:Prop := PprzTrigLow.proof.Obligations.no_error_goal Precondition.precondition.
