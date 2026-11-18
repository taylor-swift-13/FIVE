# Exact update/get readback

The new update model has49 exact independently kernel-checked goals across5 questions, and the actual update/get composition has2. All36 emitted traditional-CBMC properties are independently rechecked. The existing getter5 problems are reused unchanged. [Chinese review](review-report.zh-CN.md), [cost records](costs.json), [frozen core candidate](evidence/core-candidate.json).

Run `python3 paparazzi/report/lowpass_update_readback/check_all.py` from the repository root; add `--compile` for an independent cold rebuild of all11 active questions. The strict11-question delivery gate passed locally and independently in the parent review, with both complete CompCert gates and512 retained physical input copies; [local receipt](evidence/local-delivery-gate.json).
