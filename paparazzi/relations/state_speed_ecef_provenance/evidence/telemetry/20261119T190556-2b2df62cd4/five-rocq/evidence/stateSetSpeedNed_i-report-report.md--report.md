Original stateSetSpeedNed_i accepted-call verification.

The original body and model are immutable. The only C exposure change is static-inline storage exposure; the body is unchanged. State uses the original656-byte layout, ushort filter/status and three int32 coordinates. InputGood states a State symbol, full State write permission, loaded ANY filter, three readable input words and source/State separation. The original call returns and copies to offsets296,300,304, stores status2, preserves the input, all old permissions and all bytes outside the14 actual written bytes.

No-error covers every reachable original Csem state under InputGood. Acc termination and the eight execution-translation obligations cover the complete raw argument/memory domain. All32 actual original CBMC IDs are independently mapped and rechecked; the proof constructs the original zero/filter/snapshot harness preparation and covers every byte index0..655.

Development proofs compile under actual GPT-6.1 Sol Ultra. Final typed-goal and independent-kernel receipts are produced by the shared checker; canonical status files and spec-recheck.json record acceptance. No original source, CBMC harness/result or align artifact was modified. CompCert3.17 x86-64 Linux little-endian C semantics is the boundary; this stage asserts no compiled GCC or hardware equivalence.

Costs are one shared two-setter authoring interval plus a separate GuardShell helper interval, each counted once globally. Command059 lost part of the historical timing due a writer collision; the surviving subset and incident are retained, so missing complete CPU/peak metrics remain null.
