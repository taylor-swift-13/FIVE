From FiveGhSetZetaCorrespondence Require Import Spec.
From FiveGhSetZetaProof Require Import WholeExecution.
Theorem domain:Spec.DomainGoal. Proof. exact WholeExecution.domain_preservation. Qed.
Print Assumptions domain.
Theorem floating:Spec.FloatGoal. Proof. exact WholeExecution.one_step_correspondence. Qed.
Print Assumptions floating.
Theorem integer:Spec.IntGoal. Proof. exact WholeExecution.one_step_correspondence. Qed.
Print Assumptions integer.
Theorem memory:Spec.MemoryGoal. Proof. exact WholeExecution.one_step_correspondence. Qed.
Print Assumptions memory.
Theorem control:Spec.ControlGoal. Proof. exact WholeExecution.whole_execution_correspondence. Qed.
Print Assumptions control.
Theorem normal:Spec.NormalGoal. Proof. exact WholeExecution.normal_result_memory_correspondence. Qed.
Print Assumptions normal.
Theorem invalid:Spec.InvalidGoal. Proof. exact WholeExecution.invalid_operation_correspondence. Qed.
Print Assumptions invalid.
Theorem whole:Spec.WholeGoal. Proof. exact WholeExecution.whole_execution_correspondence. Qed.
Print Assumptions whole.
