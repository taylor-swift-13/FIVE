# functional

Status: proved. Active attempt: [001](../attempts/001/report.md). Requested goals: NormalCompletion, AllReturns, Nonvacuity. Pending goals: none.

Normal Csem completion, exact original-tree binary32 result, last_in=input bytes, last_out=returned output bytes, preserved time_const and old-valid caller frame outside4..12. All normal returns satisfy the same postcondition. Explicit Nonvacuity constructs initialized memory for every tc/li/lo binary32 triple.

Canonical question: [Spec.v](Spec.v), SHA-256 `9623b37504830ef2a2718b22d8340235124025368a828976a21feb983d8eb39d`. The implementation is original CompCert3.17 Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with the pinned CompCert NaN policy. The generated execution model retains all machine inputs; proof preconditions are separate.

