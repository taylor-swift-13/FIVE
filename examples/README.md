# FIVE reference examples

## Verification status: INCOMPLETE

This repository snapshot is not a completed verification result. Sum3 safety and termination are proved. The complete CBMC harness recheck is not proved. Sum2 safety, all-successor termination and its complete recorded CBMC property set are now proved; see [the sum2 proof summary](models/sum2/rocq/report/report.md). The cross-model relation proves equality conditional on normal returns; it does not establish those executions exist.

## Reading problems and proofs

- `problem/Spec.v` defines the question. It is not a proof.
- `problem/report.md` explains the target and its conditions.
- `attempts/001/Proof.v` contains an attempted solution. Its adjacent `report.md` states exactly what passed and what remains open.
- `attempts/001/evidence/` contains compilation, kernel-check and assumption evidence; `costs.json` records costs and agent configuration.
- `align/model/Source.v` is the CompCert-exported program. `align/model/proof/` contains generated obligation scaffolding, not completed proof evidence.
- `support/*.v` and `Sum2Return.v` / `Sum3Return.v` are supporting proof lemmas, not additional user problems.

| Problem | Attempt report | Actual outcome |
| --- | --- | --- |
| [Sum3 no error](models/sum3/rocq/no_error/problem/Spec.v) | [001](models/sum3/rocq/no_error/attempts/001/report.md) | Stated goal proved |
| [Sum3 termination](models/sum3/rocq/termination/problem/Spec.v) | [001](models/sum3/rocq/termination/attempts/001/report.md) | Stated all-successor goal proved |
| [Sum3 CBMC recheck](models/sum3/rocq/cbmc_recheck/problem/Spec.v) | [001](models/sum3/rocq/cbmc_recheck/attempts/001/report.md) | INCOMPLETE: return-bit subgoal proved; complete harness obligations open |
| [Sum2 no error](models/sum2/rocq/no_error/problem/Spec.v) | [001](models/sum2/rocq/no_error/attempts/001/report.md) | Stated goal proved |
| [Sum2 termination](models/sum2/rocq/termination/problem/Spec.v) | [001](models/sum2/rocq/termination/attempts/001/report.md) | Stated all-successor goal proved |
| [Sum2 CBMC recheck](models/sum2/rocq/cbmc_recheck/problem/Spec.v) | [001](models/sum2/rocq/cbmc_recheck/attempts/001/report.md) | Entire actual emitted property set proved; scalar harness scope |
| [Sum2 / sum3 relation](relations/sum2_sum3/problem/Spec.v) | [001](relations/sum2_sum3/attempts/001/report.md) | Stated conditional normal-return equality proved |


`models/` contains single-entry cases with four stage directories. [sum3](models/sum3/README.md) is the reference for the full stage and proof reporting format. [sum2](models/sum2/README.md) provides an execution model with completed single-model proof tasks.

`relations/` holds cross-model problems. [The composition specification](relations/sum2_sum3/problem/Spec.v) imports both execution models. The sibling `attempts/001/` contains the composition proof and independent kernel evidence from GPT-6.1 Sol medium. The [problem report](relations/sum2_sum3/problem/report.md) records both model configurations and the proof status.

Each stage cost report uses the same `time`, `token`, and `memory` groups. Times are in seconds and peak tool RSS is in bytes. Unobserved fields are `null`. Raw tool metrics remain under `report/evidence/`.

Every single-model and cross-model proof attempt includes `attempts/<number>/costs.json` in the same `five-stage-costs/1` format. It records `time`, `token`, and `memory`. For a shared measurement, set unmeasured attempt fields to `null` and link the shared cost record. The proof attempt report links its `costs.json`.

Every proof attempt records the model ID, requested reasoning effort and actual reasoning effort in `costs.json` under `agent`, and summarizes them in `report.md`. Actual effort comes from runtime configuration evidence such as `turn_context`; use `null` when it is unavailable. Reasoning token count remains a separate metric.
