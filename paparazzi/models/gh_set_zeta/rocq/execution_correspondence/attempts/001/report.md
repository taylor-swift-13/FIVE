# gh_set_zeta execution_correspondence — attempt001

Proved: DomainGoal, FloatGoal, IntGoal, MemoryGoal, ControlGoal, NormalGoal, InvalidGoal, WholeGoal. All eight execution-translation obligations. The exact raw one-step theorem covers original floats, integers, loads/stores and every possible evaluation order without replacing them. Bidirectional all-trace star equivalence is unbounded and domain unrestricted; error/nostep and byte observations use actual generated wrapper definitions.

The actual worker is GPT6.1Sol, medium effort, confirmed by its runtime session receipt. No new unproved axiom or admitted proof is used. Print Assumptions output and independent kernel receipts preserve inherited CompCert/library assumptions. Proofs establish the pinned CompCert Csem/Cexec result, with recorded frontend trust and no GCC/hardware equivalence claim.

[Proof](Proof.v), [canonical specification](../../problem/Spec.v), [reproducible checker](check.py), [goal validation](evidence/goal-validation.json), [kernel receipt](evidence/kernel-evidence.json), [costs](costs.json). Each checked-NNN directory preserves actual compiled source snapshots and retry evidence.

Source model SHA256 a2b14d1514fd06d22c8454faeb2a2486a07f92652e75ce43053848f9bbf31eb8; execution wrapper 3b4472bcbd4418905dcdaa962e036eda5eb8ee11946707814909e15947afebca; exact specification 4a2b07e72b9f65feb6c579228dd96698d910da7ef9f982cf107b47bf98d0fb55.

Resource measurements cover the shared five-rocq authoring and checking session; no per-problem token allocation was observed. Historical checker-wrapper telemetry nesting was corrected by direct instrumented checker runs; canonical receipts bind current real independent checks.
