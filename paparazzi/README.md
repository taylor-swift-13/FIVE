# Paparazzi verification cases

## Horizontal guidance update verification

[Horizontal guidance mode relation](relations/guidance_mode/problem/report.md) compares the speed-command and acceleration-command routes after source-ordered integration. The two [speed](models/gh_update_ref_from_speed_sp/README.md) and [acceleration](models/gh_update_ref_from_accel_sp/README.md) cases retain separate canonical questions and proof attempts. Scope, status and costs are in the [aggregate report](report/guidance_mode/report.md).

## Horizontal PID relations

The sole model entry is `guidance_pid_h_run_pos`. The [relation specification](relations/pid_position_translation/problem/report.md) compares two calls whose reference and measured positions receive the same translation. The [relation proof](relations/pid_position_translation/attempts/002/report.md) establishes all six requested goals. The [current CBMC recheck acceptance](models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/report.md) binds all 124 original properties to their exact Rocq goals. [Stage evidence and costs](models/guidance_pid_h_run_pos/rocq/report/report.md) retain the original input domain and target configuration.

The [ground integral-history relation](relations/pid_ground_integral_independence/problem/report.md) uses the same `guidance_pid_h_run_pos` entry with four independent symbolic initial integral values. With `in_flight=false` and the recorded input preconditions, both calls clear the integral, produce identical effective output bits, and agree byte for byte outside the caller return region. The [proof attempt](relations/pid_ground_integral_independence/attempts/001/report.md) records the five checked goals, model configuration, assumptions and measured costs.

## Additional completed relations

| Relation | Outcome | Canonical explanation |
| --- | --- | --- |
| Low-pass initialized readback | Proved | [Problem](relations/lowpass_readback/problem/report.md) |
| Low-pass reset and coefficient-update recovery | Proved | [Problem](relations/lowpass_recovery/problem/report.md) |
| Low-pass update/readback consistency | Proved | [Problem](relations/lowpass_update_readback/problem/report.md) |
| PID measurement perturbation over arbitrary horizons | Proved under the stated input/environment contract | [Problem](relations/pid_measurement_robustness/problem/report.md), [proof and costs](relations/pid_measurement_robustness/attempts/001/report.md) |
| PID strict sign symmetry | Refuted by an actual CompCert Csem execution pair | [Problem](relations/pid_sign_symmetry/problem/report.md), [counterexample proof and costs](relations/pid_sign_symmetry/attempts/001/report.md) |
| PID integral drift under alternating zero-mean errors | Proved for symbolic amplitude, gains and arbitrary horizons | [Problem](relations/pid_alternating_bias/problem/report.md), [proof and costs](relations/pid_alternating_bias/attempts/001/report.md) |

Each relation keeps its canonical question under `problem/` and actual proof
attempts under `attempts/`. A proved negation theorem is evidence that the
candidate relation is **refuted**, not that symmetry holds. Current inventory:
ten Paparazzi relations, nine established positive relations and one refutation.

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
