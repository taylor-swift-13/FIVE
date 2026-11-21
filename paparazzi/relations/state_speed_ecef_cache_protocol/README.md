# State ECEF speed cache protocol

The unchanged original Csem cache-hit getter preserves the entire memory and returns the exact cached-field pointer. Arbitrarily many reads retain each immediate postcall byte/bit observation; an accepted ECEF integer write invalidates the float flag and forces the next original miss.

The existing freshness and history-independence counterexamples remain valid through arbitrarily many cached reads: stable caching can retain incorrect old-NED-derived data.

- [Canonical protocol question](problem/Spec.v) and [Chinese scope](problem/report.md)
- [Checked attempt](attempts/001/report.md) and [exact current validation](attempts/001/evidence/goal-validation.json)
- [Generic original getter hit question](../../models/stateGetSpeedEcef_f/rocq/cache_hit/problem/Spec.v)

Reproduce both new active attempts from repository root with `source scripts/env.sh && python3 paparazzi/relations/state_speed_ecef_cache_protocol/support/Check.py --all`. Ordinary replay preserves published receipts.
