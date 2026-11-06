# gh_set_zeta cbmc_recheck — attempt001

Proved: Assertion1, Assertion2, Assertion3. All three properties emitted by the actual unchanged scalar-union harness. Assertion1 proves returned and stored Bound bits and Csem integer equality evaluation. Assertion2 proves source-order coefficient bits and integer equality evaluation. Assertion3 proves all twelve unrelated named scalar fields retain initial bits. UnionObservation proves actual fresh four-byte allocation/store/loadbytes/uint32 reinterpretation for arbitrary binary32 including every NaN. No cross-tool NaN-payload equality is asserted.

The actual worker is GPT6.1Sol, medium effort, confirmed by its runtime session receipt. No new unproved axiom or admitted proof is used. Print Assumptions output and independent kernel receipts preserve inherited CompCert/library assumptions. Proofs establish the pinned CompCert Csem/Cexec result, with recorded frontend trust and no GCC/hardware equivalence claim.

[Proof](Proof.v), [canonical specification](../../problem/Spec.v), [reproducible checker](check.py), [goal validation](evidence/goal-validation.json), [kernel receipt](evidence/kernel-evidence.json), [costs](costs.json). Each checked-NNN directory preserves actual compiled source snapshots and retry evidence.

Source model SHA256 a2b14d1514fd06d22c8454faeb2a2486a07f92652e75ce43053848f9bbf31eb8; execution wrapper 3b4472bcbd4418905dcdaa962e036eda5eb8ee11946707814909e15947afebca; exact specification e092e8d3f6c25a16e685269376fc884262f219df3e4b7999759393f870f295fa.

Resource measurements cover the shared five-rocq authoring and checking session; no per-problem token allocation was observed. Historical checker-wrapper telemetry nesting was corrected by direct instrumented checker runs; canonical receipts bind current real independent checks.
