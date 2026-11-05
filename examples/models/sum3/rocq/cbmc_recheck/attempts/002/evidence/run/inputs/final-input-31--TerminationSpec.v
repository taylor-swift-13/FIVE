From FiveSum3.proof Require Import Obligations.
From FiveSum3Proof Require Import NoErrorSpec.

Definition Goal : Prop := FiveSum3.proof.Obligations.termination_goal typed_arguments.
