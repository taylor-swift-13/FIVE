Require Import FiveGhSetOmegaExecution.Spec.
Require Import FiveGhSetOmegaExecution.Proof.
Definition goal_0 : FiveGhSetOmegaExecution.Spec.domain_preservation_goal := FiveGhSetOmegaExecution.Proof.domain_preservation.
Print Assumptions goal_0.
Definition goal_1 : FiveGhSetOmegaExecution.Spec.one_step_correspondence_goal := FiveGhSetOmegaExecution.Proof.one_step_correspondence.
Print Assumptions goal_1.
Definition goal_2 : FiveGhSetOmegaExecution.Spec.whole_execution_correspondence_goal := FiveGhSetOmegaExecution.Proof.whole_execution_correspondence.
Print Assumptions goal_2.
Definition goal_3 : FiveGhSetOmegaExecution.Spec.invalid_operation_correspondence_goal := FiveGhSetOmegaExecution.Proof.invalid_operation_correspondence.
Print Assumptions goal_3.
Definition goal_4 : FiveGhSetOmegaExecution.Spec.normal_result_memory_correspondence_goal := FiveGhSetOmegaExecution.Proof.normal_result_memory_correspondence.
Print Assumptions goal_4.
