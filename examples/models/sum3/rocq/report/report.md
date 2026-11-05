# Sum3 proof-stage result

**COMPLETE for the recorded verification request.** All requested current problems have proofs and independent kernel evidence under GPT-6.1 Sol medium.

| Question | Active proof report | Result |
| --- | --- | --- |
| [No error](../no_error/problem/Spec.v) | [001](../no_error/attempts/001/report.md) | Every reachable original Csem state avoids errors |
| [Termination](../termination/problem/Spec.v) | [001](../termination/attempts/001/report.md) | Acc over all original Csem successors |
| [Full original CBMC recheck](../cbmc_recheck/problem/Spec.v) | [002](../cbmc_recheck/attempts/002/report.md) | All ten actual property IDs proved |

Typed entry arguments are arbitrary binary32 values, including NaNs, infinities and signed zero; initial memory is arbitrary. No-error and all-successor termination are separate conclusions. The full harness prefix is proved to exist for every first-call input triple and initial memory, so observation implications are nonvacuous.

The original memcpy harness is unchanged. Its two caller objects are allocated before both calls; all return paths preserve their frame. Actual stored binary32 bytes, CompCert memcpy outcomes, uint32 load and Csem assertion steps are proved. CBMC internal pointer guards short-circuit on distinct object IDs; the adapter proves fresh distinct CompCert blocks and live endpoints without inventing cross-object C ordering. This is an explicit property-by-property harness adapter; it does not claim a generated whole-main Csyntax trace or universal CBMC/CompCert NaN-payload equivalence.

[Historical attempt 001](../cbmc_recheck/attempts/001/report.md) only proved return bits and remains an honestly incomplete historical attempt. The appended full specification keeps its original ResultBitsGoal verbatim.

The current relocated frontend replay passed strict provenance audit. The unchanged frozen Source.prog and f_sum3 are formally equal to the fresh automatic export, with no assumptions: [relocation proof](../support/evidence/relocation-proof/Relocation.v), [kernel evidence](../support/evidence/relocation-proof/kernel-evidence.json), [exact metadata-only diff](../support/evidence/relocation-proof/source.diff), [frontend provenance](../../align/report/evidence/relocation-provenance.json). Earlier proof input manifests retain their historical hash; that exact manifest is preserved under align/report/evidence/relocation-history. Source.v and Execution.v were never edited.

Target: CompCert 3.17, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even. Rocq 9.2; OCaml 4.14.2. Inherited assumptions and exact source/model/spec/proof hashes are in the linked attempt reports and receipts. The boundary is the recorded C semantics and frontend, not a GCC/native-hardware equivalence claim.

[Costs](costs.json) count shared authoring and independent verification sessions once, preserve failures and historical records, and distinguish per-attempt tool subsets from shared model tokens. Unknown historical measurements remain null; current reconstruction/replay measurements do not recover past expense.
