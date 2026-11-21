From FiveRmatOfQuatCorrespondence Require Import Spec.
From FiveRmatOfQuatCorrespondence Require Import Closure.
Theorem domain_preservation:Spec.domain_preservation_goal.
Proof. intros;split;[reflexivity|apply Closure.entry_source]. Qed.
Lemma reachable_step:Spec.reachable_step_goal.
Proof.
 intros args m t reached tr next PATH.
 apply (Closure.one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world).
 eapply Closure.source_reachable;eauto.
Qed.
Theorem floating_point_correspondence:Spec.floating_point_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem machine_integer_correspondence:Spec.machine_integer_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem memory_access_correspondence:Spec.memory_access_correspondence_goal.
Proof. exact reachable_step. Qed.
Theorem control_and_exhaustion_correspondence:Spec.control_and_exhaustion_correspondence_goal.
Proof. exact Closure.whole_execution_correspondence. Qed.
Theorem normal_result_and_memory_correspondence:Spec.normal_result_and_memory_correspondence_goal.
Proof. intros;split;[apply Closure.whole_execution_correspondence|reflexivity]. Qed.
Theorem invalid_operation_correspondence:Spec.invalid_operation_correspondence_goal.
Proof. exact Closure.invalid_operation_correspondence. Qed.
Theorem whole_execution_correspondence:Spec.whole_execution_correspondence_goal.
Proof. exact Closure.whole_execution_correspondence. Qed.
Print Assumptions domain_preservation.
Print Assumptions floating_point_correspondence.
Print Assumptions machine_integer_correspondence.
Print Assumptions memory_access_correspondence.
Print Assumptions control_and_exhaustion_correspondence.
Print Assumptions normal_result_and_memory_correspondence.
Print Assumptions invalid_operation_correspondence.
Print Assumptions whole_execution_correspondence.
