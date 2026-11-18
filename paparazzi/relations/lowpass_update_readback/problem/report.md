# relation

Status: proved. Active attempt: [001](../attempts/001/report.md). Requested goals: NormalCompletion, AllReturns. Pending goals: none.

Actual update Csem output memory mu feeds actual getter Csem input. Normal completion exists; all normal returns have equal binary32 bits, including NaNs. Both mu/mf store input bytes4..8 and returned result bytes8..12; time_const0..4 unchanged; getter preserves all mu-valid caller blocks, update preserves original-valid caller bytes outside4..12.

Canonical question: [Spec.v](Spec.v), SHA-256 `6813a394666eeeab1577c8703bb738b521c43c0e0d6d2f90e85063c44092e0de`. The implementation is original CompCert3.17 Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with the pinned CompCert NaN policy. The generated execution model retains all machine inputs; proof preconditions are separate.

