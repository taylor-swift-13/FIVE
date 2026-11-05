# FIVE reference examples

`models/` contains single-entry cases with four stage directories. [sum3](models/sum3/README.md) is the reference for the full stage and proof reporting format. [sum2](models/sum2/README.md) provides the additional execution model.

`relations/` holds cross-model problems. [The composition specification](relations/sum2_sum3/problem/Spec.v) imports both execution models. The sibling `attempts/001/` contains the composition proof and independent kernel evidence from GPT-6.1 Sol medium. The [problem report](relations/sum2_sum3/problem/report.md) records both model configurations and the proof status.

Each stage cost report uses the same `time`, `token`, and `memory` groups. Times are in seconds and peak tool RSS is in bytes. Unobserved fields are `null`. Raw tool metrics remain under `report/evidence/`.

Every single-model and cross-model proof attempt includes `attempts/<number>/costs.json` in the same `five-stage-costs/1` format. It records `time`, `token`, and `memory`. For a shared measurement, set unmeasured attempt fields to `null` and link the shared cost record. The proof attempt report links its `costs.json`.

Every proof attempt records the model ID, requested reasoning effort and actual reasoning effort in `costs.json` under `agent`, and summarizes them in `report.md`. Actual effort comes from runtime configuration evidence such as `turn_context`; use `null` when it is unavailable. Reasoning token count remains a separate metric.
