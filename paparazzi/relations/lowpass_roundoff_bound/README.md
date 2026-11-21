# First-order low-pass roundoff over arbitrary horizons

Proved for every natural n: absolute output error is at most
2^-19 * (1 - 2^-n), and therefore at most 2^-19 (about 1.90735e-6).
The input sequence and stored binary32 coefficient are symbolic.

Preconditions: finite c in [1,2], finite inputs with magnitude at most 1,
and a finite initial output with magnitude at most 1. The exact-real
reference uses the same stored coefficient and initial value. The original
CompCert execution model is unchanged. Gradual underflow is included.

- [Question and preconditions](problem/report.md)
- [Exact specification](problem/Spec.v) and [proof](attempts/001/Proof.v)
- [Explanation, configuration and acceptance](attempts/001/report.md)
- [Reproducible checker](attempts/001/check.py)
- [Exact goal bindings and kernel evidence](attempts/001/evidence/goal-validation.json)
- [Proof-stage costs](attempts/001/costs.json)
- [End-to-end costs and measurement limits](evidence/workflow-costs.json)

All six requested goals are closed, including actual Csem call existence,
all normal-return observations, stored field bytes and frame preservation.
The existing C preparation, CBMC, CompCert alignment and single-model proofs
are reused with their original evidence and author configurations. This
roundoff bound concerns update operations; coefficient synthesis, sensor
quantization and continuous-time discretization are separate questions.
