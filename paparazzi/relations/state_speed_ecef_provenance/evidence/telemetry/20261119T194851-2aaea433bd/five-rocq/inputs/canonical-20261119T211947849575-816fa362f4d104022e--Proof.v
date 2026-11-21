From StateSpeedGetterTerminationProblem Require Import Spec.
From StateSpeedGetterSupport Require Import Original GetterSource.
Theorem proved_termination:Spec.TerminationGoal.
Proof. exact GetterSource.all_successor_termination. Qed.
Print Assumptions proved_termination.
