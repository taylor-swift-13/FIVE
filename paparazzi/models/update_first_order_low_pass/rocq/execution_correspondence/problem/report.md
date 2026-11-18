# execution_correspondence

Status: proved. Active attempt: [001](../attempts/001/report.md). Requested goals: domain_preservation_goal, floating_point_correspondence_goal, machine_integer_correspondence_goal, memory_access_correspondence_goal, control_and_exhaustion_correspondence_goal, normal_result_and_memory_correspondence_goal, invalid_operation_correspondence_goal, whole_execution_correspondence_goal. Pending goals: none.

Eight unrestricted Csem/Cexec correspondence obligations: arbitrary machine arguments/memory, all reachable states, exact traces, values, bytes, errors and successor relation. No domain restriction.

Canonical question: [Spec.v](Spec.v), SHA-256 `6c7115572420d1a1981f739097540446481c5eb179335c5959287903bb863226`. The implementation is original CompCert3.17 Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with the pinned CompCert NaN policy. The generated execution model retains all machine inputs; proof preconditions are separate.

