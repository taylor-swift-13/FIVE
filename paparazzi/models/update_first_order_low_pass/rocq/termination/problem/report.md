# termination

Status: proved. Active attempt: [001](../attempts/001/report.md). Requested goals: AllSuccessorsTerminate. Pending goals: none.

Acc over every original Csem successor for every machine argument list and memory, including states outside the safety precondition. No fixed execution bound.

Canonical question: [Spec.v](Spec.v), SHA-256 `ced7bd83eacc7ffb93f8817824b5222d64c022aa68ee64808d9bf0bdad07f812`. The implementation is original CompCert3.17 Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with the pinned CompCert NaN policy. The generated execution model retains all machine inputs; proof preconditions are separate.

