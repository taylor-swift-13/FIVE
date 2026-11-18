From FiveGhAccelExecutionCorrespondence Require Import Spec.
From FiveGuidanceSemantics Require Import AccelSource.
Theorem domain_preservation:Spec.domain_preservation_goal.
Proof. intros;split;[reflexivity|apply AccelSource.entry_source]. Qed.
Lemma reachable_step:Spec.reachable_step_goal.
Proof.
 intros args m t reached tr next PATH.
 apply (AccelSource.one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world).
 eapply AccelSource.source_reachable;eauto.
Qed.
Theorem floating_point_correspondence:Spec.floating_point_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem machine_integer_correspondence:Spec.machine_integer_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem memory_access_correspondence:Spec.memory_access_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem control_and_exhaustion_correspondence:Spec.control_and_exhaustion_correspondence_goal.
Proof. exact AccelSource.whole_execution_correspondence. Qed.
Theorem normal_result_and_memory_correspondence:Spec.normal_result_and_memory_correspondence_goal.
Proof. intros;split;[apply AccelSource.whole_execution_correspondence|reflexivity]. Qed.
Theorem invalid_operation_correspondence:Spec.invalid_operation_correspondence_goal.
Proof. exact AccelSource.invalid_operation_correspondence. Qed.
Theorem whole_execution_correspondence:Spec.whole_execution_correspondence_goal.
Proof. exact AccelSource.whole_execution_correspondence. Qed.
Print Assumptions domain_preservation.
Print Assumptions floating_point_correspondence.
Print Assumptions machine_integer_correspondence.
Print Assumptions memory_access_correspondence.
Print Assumptions control_and_exhaustion_correspondence.
Print Assumptions normal_result_and_memory_correspondence.
Print Assumptions invalid_operation_correspondence.
Print Assumptions whole_execution_correspondence.
