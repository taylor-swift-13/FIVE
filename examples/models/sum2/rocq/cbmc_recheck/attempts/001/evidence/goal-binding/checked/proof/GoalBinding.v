Require Import FiveSum2Proof.RecheckSpec.
Require Import FiveSum2Proof.Attempt.
Definition goal_0 : FiveSum2Proof.RecheckSpec.FullAssertionGoal := FiveSum2Proof.Attempt.full_main_assertion_1.
Print Assumptions goal_0.
Definition goal_1 : FiveSum2Proof.RecheckSpec.AssertionGoal := FiveSum2Proof.Attempt.main_assertion_1.
Print Assumptions goal_1.
Definition goal_2 : FiveSum2Proof.RecheckSpec.ArbitrarySafetyGoal := FiveSum2Proof.Attempt.arbitrary_call_safe.
Print Assumptions goal_2.
Definition goal_3 : FiveSum2Proof.RecheckSpec.ReturnExistsGoal := FiveSum2Proof.Attempt.arbitrary_call_returns.
Print Assumptions goal_3.
