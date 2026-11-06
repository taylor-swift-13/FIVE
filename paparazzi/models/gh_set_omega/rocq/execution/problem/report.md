# execution

Canonical question: Spec.v. Actual original CompCert x86-64 Linux Csem/Cexec, little endian binary32, all NaNs/infinities/signed zeros retained. Caller precondition names a full initialized14-field gh_ref with writable64-byte region and actual global symbol; Public.caller_precondition_satisfiable supplies concrete original zero-initialized memory. No-error quantifies all reachable original states; termination uses Acc over all successors.

Active attempt001 proves domain_preservation_goal, one_step_correspondence_goal, whole_execution_correspondence_goal, invalid_operation_correspondence_goal, normal_result_memory_correspondence_goal. See independently compiled exact GoalBinding, assumptions output and kernel receipts.
