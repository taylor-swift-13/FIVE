# sum2

**Completed:** no-error, all-successor termination, and every property emitted by the recorded CBMC run. [Proof-stage summary](rocq/report/report.md).

| Stage | Input | Output and report |
| --- | --- | --- |
| prepare | Selected `sum2` C entry and target | [sum2.c](prepare/source/sum2.c), [bindings](prepare/source/bindings.json), [verification request](prepare/verification-request.json), [handoff](prepare/handoff.json) |
| cbmc | Prepared source and explicit request | [harness](cbmc/harness.c), [actual properties](cbmc/properties.json), [report](cbmc/report/report.md), [costs](cbmc/report/costs.json) |
| align | Frozen C and actual CBMC property mapping | [CompCert source model](align/model/Source.v), [execution wrapper](align/model/Execution.v), [handoff](align/handoff.json) |
| rocq | Generated model/obligations and CBMC properties | [summary](rocq/report/report.md), [costs](rocq/report/costs.json), [handoff](rocq/handoff.json) |

`problem/Spec.v` is the question. `attempts/001/Proof.v` is the generated proof attempt. Every attempt has a readable `report.md`, `costs.json` and evidence. Supporting lemmas are under `rocq/support/`. The separate [sum2/sum3 relation](../../relations/sum2_sum3/problem/report.md) has its own problem and attempts.
