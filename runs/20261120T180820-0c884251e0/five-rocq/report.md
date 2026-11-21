# five-rocq / 20261120T180820-0c884251e0

Verification: passed

Compiled original Float32 one-step finite/range/local-error theorem and independent kernel check passed; no pending numerical obligations.

Wall time: 674.857733 s

CPU tool time: 38.480000000000004 s

Observed tool-tree RSS peak: 1364586496 bytes

Model tokens: available; total=2600851

Measurement completeness: partial

run.json contains scope, input/output hashes, commands, token evidence and remaining obligations. metrics.json contains resource measurements and their limits.

Cost evidence audit: incomplete

- Missing sampled tool memory: 013-helper-read

- Missing sampled tool memory: 015-helper-current

## Numerical theorem and evidence

Numerical.step_bound_local proves the requested original six-operation Float32 tree for variable c in [1,2]. Its preconditions are only finiteness of the four inputs and their stated real bounds. It proves output finiteness, |output|<=2 and one-step absolute error<=2^-20. All intermediate finiteness and roundoff claims are derived via FloatBounds and Flocq operation-correctness results. No Axiom or Admitted was introduced. Numerical.one uses the exact CompCert bits1065353216 value.

The independent kernel command passed. Print Assumptions lists only ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. The exact compiled Numerical.v snapshot and semantic hashes are retained in evidence/. Runtime metadata confirms gpt-6.1-sol, effort ultra.

## Measurement limitations

Cost audit is incomplete: read-only commands 013-helper-read and 015-helper-current ended before a positive sampled RSS was observed. Compiler/kernel command RSS was observed. Additionally, interrupted inspection 003-inspect-3 has retained empty raw stdout/stderr/time logs, but its command entry was overwritten by concurrently launched 003-library because the telemetry CLI is not concurrency-safe. Its tool CPU and peak RSS are unavailable. The run wall-clock and own-session token boundary cover the entire proof effort. Recorded tool CPU/RSS are therefore lower-scope recorded-command observations, not a claim of full tool measurement. No measurements were estimated or replaced. See evidence/cost-audit.txt and measurement-gap.json.
