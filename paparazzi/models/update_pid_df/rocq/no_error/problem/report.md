# Original Csem no-error at every reachable state

Status: proved. Canonical specification: [Spec.v](Spec.v). Current attempt: [001](../attempts/001/report.md).

For every argument list and memory satisfying Contract.Precondition, every original Csem reachable state is a normal return or has an original Csem successor. Precondition permits every binary32 bit pattern in all eight struct fields and input; the 32-byte region is aligned, writable, nonwrapping and has typed initialized loads.

Requested goals: NoError. Pending goals: none.

Observation semantics: original CompCert 3.17 Csyntax/Csem/Cexec, x86-64 standard ABI, little endian, binary32 round-to-nearest ties-to-even with the exact pinned CompCert NaN policy. Byte observations use Mem.loadbytes/memval and encode_val; unknown unrelated bytes remain unchanged.
