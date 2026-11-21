From StateSpeedGetterNoErrorProblem Require Import Spec.
From StateSpeedGetterSupport Require Import Original GetterSource.
Theorem proved_no_error:Spec.NoErrorGoal.
Proof. exact Original.original_no_error. Qed.
Print Assumptions proved_no_error.
