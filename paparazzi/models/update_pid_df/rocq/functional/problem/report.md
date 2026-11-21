# Exact full-call return, history shifts, bytes and caller frame

Status: proved. Canonical specification: [Spec.v](Spec.v). Current attempt: [001](../attempts/001/report.md).

For all eight initial binary32 fields and arbitrary input, Initialized implies original Csem normal-return existence and the exact Post; every actual normal return has the same result and Post. Nonvacuity constructs initialized memory for every eight-value input. Post includes initialized shifted fields, exact encode_val bytes at offsets 0,4,8,12,16, frame for every original valid caller block outside bytes 0..19, and preservation of every original valid block for arbitrary call-chain composition.

Requested goals: NormalCompletion, AllReturns, Nonvacuity. Pending goals: none.

Observation semantics: original CompCert 3.17 Csyntax/Csem/Cexec, x86-64 standard ABI, little endian, binary32 round-to-nearest ties-to-even with the exact pinned CompCert NaN policy. Byte observations use Mem.loadbytes/memval and encode_val; unknown unrelated bytes remain unchanged.
