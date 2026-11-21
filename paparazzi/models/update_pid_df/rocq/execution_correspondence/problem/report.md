# Complete original Cexec/Csem execution correspondence

Status: proved. Canonical specification: [Spec.v](Spec.v). Current attempt: [001](../attempts/001/report.md).

For all argument lists and memories, prove entry/source domain preservation; reachable step equivalence for floating, integer and memory operations; whole trace/control/exhaustion equivalence; returned value and loadbytes equivalence; and error/stuck correspondence. There is no numerical input restriction and no clipped AST.

Requested goals: domain_preservation_goal, floating_point_correspondence_goal, machine_integer_correspondence_goal, memory_access_correspondence_goal, control_and_exhaustion_correspondence_goal, normal_result_and_memory_correspondence_goal, invalid_operation_correspondence_goal, whole_execution_correspondence_goal. Pending goals: none.

Observation semantics: original CompCert 3.17 Csyntax/Csem/Cexec, x86-64 standard ABI, little endian, binary32 round-to-nearest ties-to-even with the exact pinned CompCert NaN policy. Byte observations use Mem.loadbytes/memval and encode_val; unknown unrelated bytes remain unchanged.
