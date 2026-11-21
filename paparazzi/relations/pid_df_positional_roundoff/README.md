# Incremental PID_df and a positional PID reference

**Proved:** all nine symbolic goals, including exact-arithmetic equivalence, an arbitrary-horizon floating deviation bound and original Csem call-chain observations. See [the question](problem/Spec.v), [proof report](attempts/001/report.md), [checker](attempts/001/check.py), and [costs](attempts/001/costs.json).

The independent reference uses trapezoidal integration and a backward derivative with the same zero initialization. For stored coefficients and input samples that are finite and bounded by 1, the error after any symbolic n calls is at most 2^-20 n(n+1)+n Delta, where Delta explicitly measures stored coefficients against the nominal PID gains. Actual binary32 accumulation remains finite by rounding absorption; the growing bound is not a uniform small-error guarantee.

The relation consumes the [unchanged original update model](../../models/update_pid_df/align/model/Source.v). Original initializer expressions are instantiated exactly, while initializer Csem execution and whole-firmware linkage are outside this update-only model.
