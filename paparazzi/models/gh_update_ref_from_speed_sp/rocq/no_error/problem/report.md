# no_error proof

Status: PROVED.

Original CompCert Csem no-error for every reachable state under the explicit natural caller predicate: full writable64-byte/fourteen-field global representation, real readable eight-byte struct-by-value input, valid position casts and signed additions, and separate fixed maximum-acceleration read.

The active attempt is [002](../attempts/002/Proof.v). Exact goal bindings and independent kernel evidence are in [goal-validation.json](../attempts/002/evidence/goal-validation.json). [Costs and actual runtime evidence](../attempts/002/costs.json) retain all shared authoring/checking runs, failures and retries.

| Requested exact goal | Bound theorem |
|---|---|
| Goal | `FiveGhSpeedNoError.Proof.no_error` |

The frozen specification is unchanged. No admitted goal or new proof axiom is introduced. The trust boundary is the pinned CompCert frontend/Csem/Cexec and inherited library declarations; no GCC/hardware or alternate sqrt-library equivalence is claimed.

Attempt001 history: its mathematical kernel checks and immutable compiled snapshots are valid. Its convenience input copies were overwritten by shared capture roles and failed full artifact acceptance; this was not a refuted mathematical proof. Attempt002 preserves the same Spec/Proof text and passed a complete post-finish audit of every captured input file SHA under unique roles.
