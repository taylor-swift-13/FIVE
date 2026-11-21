# sum2 termination attempt 001

Status: **COMPLETE / proved** for [the stated problem](../../problem/Spec.v). Generated proof: [Proof.v](Proof.v), theorem `generated_termination_goal`. The initial state is accessible under the full successor relation: every possible successor execution terminates, without a fuel bound.

Remaining work for this problem: none. These are original CompCert Csem statements; no selected execution path, bounded unrolling, numerical restriction, newly added axiom or admitted proof replaces the requested goal. Source/frontend translation remains the existing CompCert trust boundary. CBMC rechecking is a separate problem.

A structural natural-number rank on expressions, statements, continuations and states strictly decreases for every expression or statement step; well-founded induction proves Acc over all successors. The source syntax invariant is preserved under every step.

Configuration: CompCert 3.17; Rocq 9.2; OCaml 4.14.2; x86-64 Linux standard ABI, little endian; binary32 nearest ties to even. Entry `Source.f_sum2`; namespace `FiveSum2`. Exactly two binary32 arguments and arbitrary initial memory; no external source callees. [inputs.json](inputs.json) binds source, bindings, unchanged original generated model/obligations, specification version and support hashes. [Align input hash check](../../../support/evidence/handoff-hash-verification.json) verified every handoff output. [Checked source snapshots and actual command receipt](evidence/checker-run.json) bind precisely the fresh compiled modules.

Validation: fresh temporary build of all model, specification and support dependencies; Print Assumptions; independent `rocq check -silent FiveSum2Proof.Attempt`. Rerun `source scripts/env.sh && python3 examples/models/sum2/rocq/termination/attempts/001/check.py` from repository root. Raw stdout/stderr, GNU-time and RSS evidence are retained once in [the shared run](../../../support/evidence/shared-run/run.json). The checker receipt records the actual compile and independent kernel commands and successful exit codes.

Inherited assumptions: ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, dependent functional extensionality, Classical_Prop.classic, CompCert external_functions_sem and inline_assembly_sem. These come from checked imported dependencies; this goal introduces no new assumption. The source has no external calls.

Agent: `gpt-6.1-sol`; requested and observed reasoning effort `medium`; [actual runtime receipt](../../../support/evidence/runtime-config.json), own session 01a1abc9-400f-76c0-8538-b7bb67c91d2c.

Time, tokens and memory: [costs.json](costs.json) gives the measured final checker resources and links the single [shared skill-session cost record](../../../support/evidence/shared-costs.json). All proof analysis, construction and final checks belong to that shared run; per-problem model token attribution is unknown (null), so tokens are counted once. GNU-time max RSS is one process; RSS tree samples use a requested 10 ms interval, may miss brief peaks and double count shared pages, and exclude model-server/desktop memory. The first two checks overlapped; no combined concurrent-memory peak was sampled, so the shared aggregate memory field is null. Initial checks and their CPU costs remain included. The first command receipt was restored verbatim from its observed completed run.json after overlapping CLI writes; raw logs are unchanged.

Cost figures and audit receipt are finalized in costs.json and shared-costs.json. Metric reporting status is recorded; unknown metrics are null.
