# no_error

Status: proved. Active attempt: [001](../attempts/001/report.md). Requested goals: NoError. Pending goals: none.

Every state reachable by original Csem is safe under Initialized: an aligned nonwrapping writable12-byte caller object with typed binary32 loads at0/4/8. No finite, non-NaN or nonzero-denominator restriction.

Canonical question: [Spec.v](Spec.v), SHA-256 `389ade7c6abc7e8f1d5860d1976d0b2254e1f2646a01b3a48dd9f88bcdb04bec`. The implementation is original CompCert3.17 Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with the pinned CompCert NaN policy. The generated execution model retains all machine inputs; proof preconditions are separate.

