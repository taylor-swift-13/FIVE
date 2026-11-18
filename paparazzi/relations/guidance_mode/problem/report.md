# guidance_mode proof

Status: PROVED.

Two original-Csem guidance entries under their natural caller predicates and the command relation computed after integration. The exact five propositions cover normal completion, every-final-state formula, all fourteen named bits, actual prelimit reachability and both nontrivial branch witnesses.

The active attempt is [002](../attempts/002/Proof.v). Exact goal bindings and independent kernel evidence are in [goal-validation.json](../attempts/002/evidence/goal-validation.json). [Costs and actual runtime evidence](../attempts/002/costs.json) retain all shared authoring/checking runs, failures and retries.

| Requested exact goal | Bound theorem |
|---|---|
| NormalCompletion | `FiveGuidanceMode.Proof.normal_completion` |
| AllFinalStateFormula | `FiveGuidanceMode.Proof.all_final_state_formula` |
| AllFinalNamedBits | `FiveGuidanceMode.Proof.all_final_named_bits` |
| ActualPrelimitExists | `FiveGuidanceMode.Proof.actual_prelimit` |
| NontrivialWitnesses | `FiveGuidanceMode.Proof.nontrivial_witnesses` |

The frozen specification is unchanged. No admitted goal or new proof axiom is introduced. The trust boundary is the pinned CompCert frontend/Csem/Cexec and inherited library declarations; no GCC/hardware or alternate sqrt-library equivalence is claimed.

Attempt001 history: its mathematical kernel checks and immutable compiled snapshots are valid. Its convenience input copies were overwritten by shared capture roles and failed full artifact acceptance; this was not a refuted mathematical proof. Attempt002 preserves the same Spec/Proof text and passed a complete post-finish audit of every captured input file SHA under unique roles.
