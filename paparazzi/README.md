# Paparazzi verification cases

## Horizontal guidance update verification

[Horizontal guidance mode relation](relations/guidance_mode/problem/report.md) compares the speed-command and acceleration-command routes after source-ordered integration. The two [speed](models/gh_update_ref_from_speed_sp/README.md) and [acceleration](models/gh_update_ref_from_accel_sp/README.md) cases retain separate canonical questions and proof attempts. Scope, status and costs are in the [aggregate report](report/guidance_mode/report.md).

## Horizontal PID relations

The sole model entry is `guidance_pid_h_run_pos`. The [relation specification](relations/pid_position_translation/problem/report.md) compares two calls whose reference and measured positions receive the same translation. The [relation proof](relations/pid_position_translation/attempts/002/report.md) establishes all six requested goals. The [current CBMC recheck acceptance](models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/report.md) binds all 124 original properties to their exact Rocq goals. [Stage evidence and costs](models/guidance_pid_h_run_pos/rocq/report/report.md) retain the original input domain and target configuration.

The [ground integral-history relation](relations/pid_ground_integral_independence/problem/report.md) uses the same `guidance_pid_h_run_pos` entry with four independent symbolic initial integral values. With `in_flight=false` and the recorded input preconditions, both calls clear the integral, produce identical effective output bits, and agree byte for byte outside the caller return region. The [proof attempt](relations/pid_ground_integral_independence/attempts/001/report.md) records the five checked goals, model configuration, assumptions and measured costs.

## Additional completed relations

| Relation | Outcome | Canonical explanation |
| --- | --- | --- |
| Ordinary sine table versus LOW12 flash storage | Proved for normalized Q12 angle codes[-12867,12867] after genuine initialization; bit-identical Q14 results | [Problem](relations/trig_plain_compressed_12/problem/report.md), [proof and costs](relations/trig_plain_compressed_12/attempts/001/report.md) |
| Low-pass initialized readback | Proved | [Problem](relations/lowpass_readback/problem/report.md) |
| Low-pass reset and coefficient-update recovery | Proved | [Problem](relations/lowpass_recovery/problem/report.md) |
| Low-pass update/readback consistency | Proved | [Problem](relations/lowpass_update_readback/problem/report.md) |
| PID measurement perturbation over arbitrary horizons | Proved under the stated input/environment contract | [Problem](relations/pid_measurement_robustness/problem/report.md), [proof and costs](relations/pid_measurement_robustness/attempts/001/report.md) |
| PID strict sign symmetry | Refuted by an actual CompCert Csem execution pair | [Problem](relations/pid_sign_symmetry/problem/report.md), [counterexample proof and costs](relations/pid_sign_symmetry/attempts/001/report.md) |
| PID integral drift under alternating zero-mean errors | Proved for symbolic amplitude, gains and arbitrary horizons | [Problem](relations/pid_alternating_bias/problem/report.md), [proof and costs](relations/pid_alternating_bias/attempts/001/report.md) |
| PID input-order invariance | Refuted by two executions from the same initial memory | [Problem](relations/pid_input_order/problem/report.md), [proof and costs](relations/pid_input_order/attempts/001/report.md) |

Each relation keeps its canonical question under `problem/` and actual proof
attempts under `attempts/`. A proved negation theorem is evidence that the
candidate relation is **refuted**, not that symmetry holds. The linked reports state the current status and scope of each relation.

## Symbolic PID integral drift

The [alternating-input relation](relations/pid_alternating_bias/problem/report.md)
uses the existing CompCert model with position-error codes +A and -A, zero initial
integral, fixed gains kp and ki, and zero remaining contributions. For every
0 <= A <= 4096, 0 <= kp,ki <= 100 and natural n, the actual stored integral after
2*n calls is zero when 64 divides kp*A, and -min(n*ki,1429*65536) otherwise.
The proof also constructs actual executions for every admitted parameter tuple
and finite horizon. This establishes the exact stored-integral drift caused
by asymmetric rounding.

The [attempt report](relations/pid_alternating_bias/attempts/001/report.md)
links the four checked goals, independent kernel receipts and archived runs.
[Costs](relations/pid_alternating_bias/attempts/001/costs.json) preserve actual
usage and the recorded command-index and memory-sampling gaps.

## Further PID questions (not yet proved)

All candidates below reuse `guidance_pid_h_run_pos` with valid NED caches and
thrust correction disabled. They require explicit safe arithmetic and memory
conditions and actual Csem execution sequences.

1. **Recovery after integral saturation.** Compare histories that reach the
   integral limit and then receive the same corrective PD input. Derive the exact
   number of calls before the stored integral leaves saturation, crosses zero,
   and the output resumes the opposite direction. This quantifies recovery delay;
   output clamping alone does not freeze the integral.
2. **Landing erases history for subsequent executions.** Two admissible histories
   followed by the same ground-mode call and then identical future inputs should
   have identical future control observations. This extends the existing one-call
   integral-history independence to arbitrary subsequent call counts.

## Implementation-to-reference candidates (not yet verified)

These candidates compare an explicit reference model with an optimized or
deployed implementation. The remaining configurations and observations below require separate
reference models and proofs. The LOW12 normalized-sine instance above is complete.

| Reference and implementation | Proposed relation |
| --- | --- |
| Other compressed sine backends and cosine | Extend the established LOW12 normalized-sine result to their separately pinned configurations and angle domains |
| Direct positional PID reference versus incremental PID_df | Align trapezoidal integration and backward-difference differentiation; establish exact-arithmetic equivalence, then quantify binary32 deviation |
| Existing first-order filter division versus proposed precomputed coefficients | Compare output bits or establish a finite-horizon error bound from matching input histories |
| Sine lookup backend versus floating backend | Check common output encoding before numerical error bounds; the floating branch uses ANGLE_BFP_OF_REAL while the lookup uses the trigonometric scale |

Source grounding at pinned Paparazzi commit
abfee3dd56eeab12c528635504a429db3daf409a:
[trigonometric backends](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_trig_int.c#L865),
[compressed lookup](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_trig_int.c#L609),
[PID_df](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L174),
[first-order filter](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L74).

The coefficient rewrite is a proposed optimization to construct. The PID
reference must use the same discretization as PID_df; update_pid_f is not
assumed equivalent. The sine-backend scale concern is a source-level
hypothesis, not a verified bug.

## Incremental floating PID versus positional reference

The [original update_pid_df model](models/update_pid_df/README.md) has completed safety, all-successor termination, execution correspondence and all81 original CBMC rechecks. The [symbolic relation](relations/pid_df_positional_roundoff/problem/report.md) proves exact-arithmetic equivalence with matching trapezoidal integration and backward differentiation. For every natural n, finite unit-bounded stored coefficients and samples, and zero histories, the actual binary32 result differs from the positional real reference by at most 2^-20*n*(n+1)+n*Delta. [Proof and explanation](relations/pid_df_positional_roundoff/attempts/001/report.md) separate update roundoff from coefficient precomputation. [Workflow costs](relations/pid_df_positional_roundoff/evidence/workflow-costs.json) retain actual time/token/memory scopes and missing observations.

## State speed cache protocol

[Cache-hit safety and exact memory preservation](models/stateGetSpeedEcef_f/rocq/cache_hit/attempts/001/report.md) are proved for the original getter. The [cross-model protocol](relations/state_speed_ecef_cache_protocol/attempts/001/report.md) proves bit-identical observations and no memory changes over arbitrary repeated cache hits, plus accepted-write invalidation and the next actual miss. Existing freshness and history-independence counterexamples persist for every number of repeated hits: cache consistency can retain the wrong old NED-derived result. The original getter remains refuted. [Workflow costs](relations/state_speed_ecef_cache_protocol/evidence/workflow-costs.json) reference reused historical stages and measure only this new proof and acceptance work.

## Matrix inverse scaling and numerical reliability

The [2D](models/float_mat_inv_2d/README.md) and [3D](models/float_mat_inv_3d/README.md) original entries have complete safety, all-successor termination, exact byte observations and execution correspondence proofs. All398 recorded traditional-CBMC properties are independently closed:394 proved and4 refuted with original-trace replay. The [six numerical goals](relations/matrix_inverse_scale/README.md) establish a symbolic dyadic family and refute scale-invariant acceptance and unconditional successful-result reliability. Finite nonsingular condition-one matrices can be rejected after shrinking, or reported successful after determinant overflow produces a zero inverse. [Proofs and explanation](relations/matrix_inverse_scale/attempts/001/report.md); [time/token/memory costs](relations/matrix_inverse_scale/evidence/workflow-costs.json).
