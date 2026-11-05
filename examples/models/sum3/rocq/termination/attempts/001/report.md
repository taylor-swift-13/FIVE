# termination attempt 001

Status: **proved**. Compilation: passed. Independent kernel check: passed. Artifact completeness: complete.

The original all-successor Acc Goal is proved by a natural-number rank on expressions, statements, continuations and states. Every original Csem estep and sstep decreases it; well_founded_ltof yields Acc. Both left and right expression evaluation contexts are covered. There is no execution fuel bound.

Delivered theorem: `generated_termination_goal`. Original Spec SHA-256: `5e1633a2e947d270c2811cc7909f1f99d4a08087107102e83f977b412fe099c4`. No specification, precondition or public support file was changed. No new axiom or admitted obligation is used.

## Model and inputs

CompCert 3.17 Csem/Cexec; x86-64 Linux standard ABI; little endian; IEEE754 binary32, nearest ties to even. Entry `sum3` / `f_sum3`; namespace `FiveSum3`. External source callees: none. Rocq 9.2, OCaml 4.14.2. Exact target, frontend/bindings and input/source/model/Spec/support SHA-256 values are bound in [inputs.json](inputs.json). Align handoff hashes were independently verified in [hash verification](../../../no_error/attempts/001/evidence/handoff-hash-verification.json).

## Evidence and assumptions

Run `source scripts/env.sh && python3 examples/models/sum3/rocq/termination/attempts/001/check.py` from repository root. The checker copies the current input model and support into a fresh temporary directory, recompiles them, compiles Proof.v, runs its Print Assumptions and independently runs `rocq check -silent FiveSum3Proof.Attempt`. Actual command logs, GNU time and RSS sampling receipts are retained in [shared run](../../../no_error/attempts/001/evidence/shared-run/run.json) and its logs.

Print Assumptions reports inherited classical logic, dependent functional extensionality, classical real-number decision principles, and CompCert external-function/inline-assembly semantic constants. These are inherited from checked dependencies, not axioms added for this goal. Proof is within recorded CompCert C semantics; source/frontend translation remains the existing trust boundary.

## Agent and costs

Actual independent session `01a1aba4-6c31-7033-8266-9c29b084280c`; model `gpt-6.1-sol`; requested reasoning effort `medium`; actual effort `medium` from session turn_context in [runtime receipt](../../../no_error/attempts/001/evidence/runtime-config.json).

[Costs](costs.json) record measured checker time/CPU/RSS. Model tokens belong once to the [shared skill-session cost record](../../../no_error/attempts/001/evidence/shared-costs.json); attempt tokens are null because no separate per-problem model boundary was measured. Intermediate commands, metadata-command quoting failure and cancelled broad search remain in shared telemetry. Unobserved values are null. Reporting status is recorded, with raw telemetry preserved.

Final cost audit: passed (exit 0), [receipt](../../../no_error/attempts/001/evidence/shared-run/logs/024-final-audit-costs.stdout.log). The first audit failure is retained; metadata default invocation_kind was corrected to reflect the actual measured skill-session. Raw resource/token observations were unchanged. Auxiliary cancellation has tool-only costs and null separate token measurement.
