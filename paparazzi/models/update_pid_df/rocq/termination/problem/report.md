# All-successor termination of original Csem

Status: proved. Canonical specification: [Spec.v](Spec.v). Current attempt: [001](../attempts/001/report.md).

For every argument list and every memory, Acc(successor Execution.ge)(Execution.entry args m). No memory or numerical precondition is needed; safety is proved separately.

Requested goals: AllSuccessorsTerminate. Pending goals: none.

Observation semantics: original CompCert 3.17 Csyntax/Csem/Cexec, x86-64 standard ABI, little endian, binary32 round-to-nearest ties-to-even with the exact pinned CompCert NaN policy. Byte observations use Mem.loadbytes/memval and encode_val; unknown unrelated bytes remain unchanged.
