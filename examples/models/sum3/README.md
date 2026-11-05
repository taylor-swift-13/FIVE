# sum3: stage review

| Stage | Input and output | Result |
| --- | --- | --- |
| Prepare | `prepare/handoff.json`, `prepare/source/sum3.c` | Entry and target fixed; source-level closure has no callees. |
| CBMC | `prepare/handoff.json` → `cbmc/handoff.json` | Traditional CBMC: 10 checks passed. Concrete output-bit assertion covers one input; the safety call has arbitrary binary32 arguments. |
| Align | `cbmc/handoff.json` → `align/handoff.json` | CompCert model generated and source audit passed; CBMC property mappings have explicit gaps. |
| Rocq | `align/handoff.json` → `rocq/handoff.json` | Sol medium proved no-error, all-successor termination and Csem returned-value bits. Complete harness recheck remains pending. |

Stage cost reports record observed figures with their measurement scope. Raw run evidence remains available for audit. Run `source scripts/env.sh && python3 examples/models/sum3/rocq/check.py` to rebuild and independently check the Rocq specifications. No end-to-end verification claim is made while the pending obligations remain.

## Authoritative case format

This case is the FIVE reference for four-stage handoffs and proof reporting. Rocq organizes `no_error`, `termination`, and `cbmc_recheck` as named problems. Each `problem/` holds its specification and report. Each numbered `attempts/` entry records the proof, actual outcome, model configuration, input hashes, evidence, and observed costs or a reference to the shared stage run. Each problem has a Sol medium attempt and its own runtime/configuration evidence and measured costs. Cross-model obligations use the same `problem/` and `attempts/` structure in `relations/<name>/`.
