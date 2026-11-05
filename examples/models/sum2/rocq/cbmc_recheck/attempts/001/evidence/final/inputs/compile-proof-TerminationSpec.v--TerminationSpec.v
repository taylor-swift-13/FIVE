From FiveSum2.proof Require Import Obligations.
From FiveSum2Proof Require Import NoErrorSpec.

Definition Goal : Prop := FiveSum2.proof.Obligations.termination_goal typed_arguments.
