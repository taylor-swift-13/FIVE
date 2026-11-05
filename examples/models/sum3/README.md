# sum3

**Complete:** no error, all-successor termination and all ten properties of the unchanged original memcpy harness. [Rocq summary](rocq/report/report.md). The [examples index](../../README.md) is the authority for future artifact format.

| Stage | Frozen input and outputs | Report and observed costs |
| --- | --- | --- |
| prepare | [source](prepare/source/sum3.c), [bindings](prepare/source/bindings.json), [handoff](prepare/handoff.json) | [report](prepare/report/report.md), [costs](prepare/report/costs.json) |
| cbmc | [original harness](cbmc/harness.c), [actual ten properties](cbmc/properties.json), [handoff](cbmc/handoff.json) | [report](cbmc/report/report.md), [costs](cbmc/report/costs.json) |
| align | [original Source.v](align/model/Source.v), [Execution.v](align/model/Execution.v), [manifest](align/model/compcert-manifest.json), [mapping](align/spec-map.json), [handoff](align/handoff.json) | [report](align/report/report.md), [costs](align/report/costs.json) |
| rocq | [problem/attempt index](rocq/report/report.md), [canonical recheck](rocq/spec-recheck.json), [handoff](rocq/handoff.json) | [report](rocq/report/report.md), [costs](rocq/report/costs.json) |

The current recheck is [attempt 002](rocq/cbmc_recheck/attempts/002/report.md). [Attempt 001](rocq/cbmc_recheck/attempts/001/report.md) is preserved as incomplete historical evidence. All problems use problem/Spec.v as the question and numbered attempts/Proof.v as the solution; support modules are auxiliary lemmas.

Run `source scripts/env.sh && python3 scripts/check-example-artifacts.py` from repository root for current metadata, provenance hashes and canonical receipt checks. Add `--compile` to rebuild active attempts. Internal CBMC object guards are mapped explicitly to CompCert block separation; no C order between unrelated pointers is asserted.
