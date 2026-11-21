From StateSpeedGetterFunctionalProblem Require Import Spec.
From StateSpeedGetterSupport Require Import Original GetterSource.
Theorem proved_original_result:Spec.OriginalResultGoal.
Proof. exact Original.original_normal_result. Qed.
Print Assumptions proved_original_result.
