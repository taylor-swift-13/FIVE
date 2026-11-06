# gh_set_zeta cbmc_recheck

All three properties emitted by the actual unchanged scalar-union harness. Assertion1 proves returned and stored Bound bits and Csem integer equality evaluation. Assertion2 proves source-order coefficient bits and integer equality evaluation. Assertion3 proves all twelve unrelated named scalar fields retain initial bits. UnionObservation proves actual fresh four-byte allocation/store/loadbytes/uint32 reinterpretation for arbitrary binary32 including every NaN. No cross-tool NaN-payload equality is asserted.

Canonical proposition: [Spec.v](Spec.v). Current checked attempt: [001](../attempts/001/report.md). Quantifiers and conditions are exactly the definitions in Spec.v. Target is CompCert3.17 x86-64 Linux little endian binary32 nearest ties to even, with pinned CompCert NaN policy; no external calls are reachable.
