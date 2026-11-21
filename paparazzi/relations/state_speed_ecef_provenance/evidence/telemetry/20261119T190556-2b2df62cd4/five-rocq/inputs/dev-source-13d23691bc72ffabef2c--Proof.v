From StateSpeedSetNedINoErrorProblem Require Import Spec.
From StateSpeedSetNedISupport Require Import Original.
Theorem proved_no_error:NoErrorGoal.
Proof. exact original_no_error. Qed.
Theorem proved_normal_result:NormalResultGoal.
Proof. exact original_normal_result. Qed.
Print Assumptions proved_no_error.
Print Assumptions proved_normal_result.
