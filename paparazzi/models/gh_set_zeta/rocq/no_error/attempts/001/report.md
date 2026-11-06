# gh_set_zeta no_error — attempt001

Proved: Goal, SatisfiableGoal. Every reachable original Csem state is not a non-normal state without a legal successor. Explicit caller precondition supplies one binary32 argument and a full initialized writable global object; every field and argument admits all bit patterns. A concrete zero-initialized original global memory proves the precondition satisfiable.

The actual worker is GPT6.1Sol, medium effort, confirmed by its runtime session receipt. No new unproved axiom or admitted proof is used. Print Assumptions output and independent kernel receipts preserve inherited CompCert/library assumptions. Proofs establish the pinned CompCert Csem/Cexec result, with recorded frontend trust and no GCC/hardware equivalence claim.

[Proof](Proof.v), [canonical specification](../../problem/Spec.v), [reproducible checker](check.py), [goal validation](evidence/goal-validation.json), [kernel receipt](evidence/kernel-evidence.json), [costs](costs.json). Each checked-NNN directory preserves actual compiled source snapshots and retry evidence.

Source model SHA256 a2b14d1514fd06d22c8454faeb2a2486a07f92652e75ce43053848f9bbf31eb8; execution wrapper 3b4472bcbd4418905dcdaa962e036eda5eb8ee11946707814909e15947afebca; exact specification 9d8e7f3b0933683cae20e03efb88da6ac95c62479607906bd81e9c6de75e8f9c.

Resource measurements cover the shared five-rocq authoring and checking session; no per-problem token allocation was observed. Historical checker-wrapper telemetry nesting was corrected by direct instrumented checker runs; canonical receipts bind current real independent checks.
