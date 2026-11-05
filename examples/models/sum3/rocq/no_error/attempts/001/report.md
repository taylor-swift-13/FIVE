# no_error attempt 001

## Human-readable outcome

**Status: COMPLETE for the stated no-error goal.**

- **Question:** [../../problem/Spec.v](../../problem/Spec.v) is the problem statement; it contains no solution to this attempt.
- **Generated proof:** [Proof.v](Proof.v), theorem(s) `generated_no_error_goal`; supporting lemmas are explained below.
- **What was established:** Every Csem state reachable from an entry satisfying the stated precondition avoids the defined error.
- **Limits / remaining work:** This does not discharge termination or CBMC harness obligations.
- **Evidence:** the original report below records the fresh compilation, independent Rocq kernel check, inherited assumptions, model configuration and evidence paths.
- **Agent and costs:** GPT-6.1 Sol, requested and observed effort `medium`; [costs.json](costs.json) records time, token and memory measurements.

## Detailed evidence and configuration

Status: **proved**. Compilation: passed. Independent kernel check: passed. Artifact completeness: complete.

The original no-error Goal is proved for every reachable original Csem state, with exactly three binary32 arguments and arbitrary initial memory.

Delivered theorem: `generated_no_error_goal`. Original Spec SHA-256: `ac4eb14e579d239f39eb8730a4f08ae60296405828ba550492b708e101413a0e`. No specification, precondition or public support file was changed. No new axiom or admitted obligation is used.

## Model and inputs

CompCert 3.17 Csem/Cexec; x86-64 Linux standard ABI; little endian; IEEE754 binary32, nearest ties to even. Entry `sum3` / `f_sum3`; namespace `FiveSum3`. External source callees: none. Rocq 9.2, OCaml 4.14.2. Exact target, frontend/bindings and input/source/model/Spec/support SHA-256 values are bound in [inputs.json](inputs.json). Align handoff hashes were independently verified in [hash verification](evidence/handoff-hash-verification.json).

## Evidence and assumptions

Run `source scripts/env.sh && python3 examples/models/sum3/rocq/no_error/attempts/001/check.py` from repository root. The checker copies the current input model and support into a fresh temporary directory, recompiles them, compiles Proof.v, runs its Print Assumptions and independently runs `rocq check -silent FiveSum3Proof.Attempt`. Actual command logs, GNU time and RSS sampling receipts are retained in [shared run](evidence/shared-run/run.json) and its logs.

Print Assumptions reports inherited classical logic, dependent functional extensionality, classical real-number decision principles, and CompCert external-function/inline-assembly semantic constants. These are inherited from checked dependencies, not axioms added for this goal. Proof is within recorded CompCert C semantics; source/frontend translation remains the existing trust boundary.

## Agent and costs

Actual independent session `01a1aba4-6c31-7033-8266-9c29b084280c`; model `gpt-6.1-sol`; requested reasoning effort `medium`; actual effort `medium` from session turn_context in [runtime receipt](evidence/runtime-config.json).

[Costs](costs.json) record measured checker time/CPU/RSS. Model tokens belong once to the [shared skill-session cost record](evidence/shared-costs.json); attempt tokens are null because no separate per-problem model boundary was measured. Intermediate commands, metadata-command quoting failure and cancelled broad search remain in shared telemetry. Unobserved values are null. Reporting status is recorded, with raw telemetry preserved.

Final cost audit: passed (exit 0), [receipt](evidence/shared-run/logs/024-final-audit-costs.stdout.log). The first audit failure is retained; metadata default invocation_kind was corrected to reflect the actual measured skill-session. Raw resource/token observations were unchanged. Auxiliary cancellation has tool-only costs and null separate token measurement.
