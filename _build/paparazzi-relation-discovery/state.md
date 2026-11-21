# State and lazy representation relations: discovery only

Source: Paparazzi upstream commit `abfee3dd56eeab12c528635504a429db3daf409a`, `_build/paparazzi/upstream`. No model, proof, CBMC run, numerical experiment, or successful verification is claimed. These are source-grounded candidate specifications. Counts below mean distinct public top-entry functions, excluding a shared `stateInit` fixture and transitive callees. A sequence denotes independent executions from the specified matching initial state; returned structs must be copied at observation time, because the getters return mutable shared-state pointers.

Common conditions: single-threaded execution; no asynchronous producer or writes through returned pointers; valid nonaliasing input objects; identical target floating semantics, compilation options, libm, and configuration; relevant filter accepts the producer ID (`state.h:513`). Finite physically valid origins/coordinates and normalized finite attitude inputs are useful domain restrictions; conversion singularities and nonfinite intermediates must be excluded if making numerical equality meaningful. Bit equality is only a candidate for identical evaluation schedules, never an unrestricted coordinate or attitude roundtrip law. Shared `state` is the observable store, but comparisons below project only named output fields and valid bits, not padding or irrelevant stale fields.

## S1 — relocation invalidates local coordinates while retaining the global position (highest priority)

Four public functions: `stateSetLocalOrigin_i` (`state.h:519`), `stateSetPositionEcef_f` (`:708`), `stateGetPositionNed_f` (`:839`), `stateGetPositionEcef_f` (`:830`).

Top-entry sequences:

- A: `SetLocalOrigin_i(O1); SetPositionEcef_f(P); GetPositionNed_f(); SetLocalOrigin_i(O2); GetPositionNed_f(); GetPositionEcef_f()`.
- B: `SetLocalOrigin_i(O2); SetPositionEcef_f(P); GetPositionNed_f(); GetPositionEcef_f()`.

Candidate: final NED components in A equal B exactly under the same floating evaluation, final ECEF remains the input P, and the NED_F validity bit is set. This expresses frame relocation with a fixed physical global position and independence from a warmed local cache. Before the final getter, the origin setter must have cleared local coordinate validity; do not require stale numeric NED fields to be cleared.

Grounding: `state.h:523-537` copies the origin, converts all floating origin fields, clears `POS_LOCAL_COORD`, speed local bits and NED acceleration bits, then marks both NED origins initialized. `POS_LOCAL_COORD` (`:81`) contains NED/ENU integer/float bits but not ECEF. `state.c:582-645` selects valid ECEF_F and calls `ned_of_ecef_point_f` at `:593`. The latter (`math/pprz_geodetic_float.c:92`) calls `enu_of_ecef_point_f` (`:85`, subtract origin then matrix product) and swaps/negates ENU to NED. Preconditions include both accepted origin calls and accepted P setter, and no competing position representations remaining valid after the P setter. No claim that moving O changes every NED component, or that a global-to-local-to-global roundtrip is exact.

## S2 — an accepted attitude update removes dependence on old derived attitude caches

Three public functions: `stateSetNedToBodyQuat_f` (`state.h:1261`), `stateGetNedToBodyRMat_f` (`:1308`), `stateGetNedToBodyEulers_f` (`:1314`).

- A: `SetQuat_f(Qold); GetRMat_f(); GetEulers_f(); SetQuat_f(Qnew); GetRMat_f(); GetEulers_f()`.
- B: `SetQuat_f(Qnew); GetRMat_f(); GetEulers_f()`.

Candidate: final RMat and Euler component values agree between A and B, and the final valid attitude bits agree. This is a producer-update/consumer-query contract across three APIs, ensuring old estimates cannot leak through lazy attitude caches. Accepted new setter is essential; rejected setters intentionally preserve old estimates. The query order is deliberately identical after the new setter.

Grounding: state wrappers delegate to `orientationSetQuat_f` (`math/pprz_orientation_conversion.h:181`) which copies Q and assigns only QUAT_F status. Getters (`:233`, `:242`, `:251`) dispatch only on missing validity. `orientationCalcRMat_f` (`math/pprz_orientation_conversion.c:148-170`) selects `float_rmat_of_quat` (`math/pprz_algebra_float.c:244`), then `orientationCalcEulers_f` (`:173-195`) prefers the newly cached matrix and uses `float_eulers_of_rmat` (`pprz_algebra_float.c:674`). Do not generalize to swapping those two getters: directly asking Euler first uses `float_eulers_of_quat` (`:696`), a different floating computation.

## S3 — a deliberately materialized ECEF bridge agrees with direct LLA-to-NED consumption

Three public functions: `stateSetPositionLla_f` (`state.h:738`), `stateGetPositionEcef_f` (`:830`), `stateGetPositionNed_f` (`:839`). A common initialized NED origin is fixed throughout.

- A: `SetPositionLla_f(L); GetPositionNed_f()`.
- B: `SetPositionLla_f(L); GetPositionEcef_f(); GetPositionNed_f()`.

Candidate: final NED x/y/z agree exactly for this restricted schedule and finite supported input domain. Intermediate ECEF cache/status differ by design: B has valid ECEF_F, while A's direct helper uses a local temporary and need not set ECEF_F. This is a useful nontrivial observational noninterference law for inserting one representation getter, without demanding whole-state equality.

Grounding: `state.c:599-600` directly calls `ned_of_lla_point_f`. That helper (`math/pprz_geodetic_float.c:119-123`) calls `ecef_of_lla_f` (`:241`) into a temporary and then `ned_of_ecef_point_f` (`:92`). Explicit bridging uses the same ECEF conversion at `state.c:566-567`, followed by the same NED helper at `:592-593`. The LLA setter resets position validity to only LLA_F. Require `ned_initialized_f`, with no intervening integer getter or batch setter that introduces higher-priority representations; UTM-only origin configuration takes another branch. This does not assert LLA/ECEF inverse roundtrip accuracy.

## S4 — explicit quaternion warmup does not alter ZXY attitude output

Three public functions: `stateSetNedToBodyRMat_f` (`state.h:1268`), `stateGetNedToBodyQuat_f` (`:1302`), `stateGetNedToBodyEulersZxy_f` (`:1320`).

- A: `SetRMat_f(R); GetEulersZxy_f()`.
- B: `SetRMat_f(R); GetQuat_f(); GetEulersZxy_f()`.

Candidate: ZXY output components and final orientation valid bits agree. Preconditions: accepted matrix setter, finite proper rotation matrix, defined conversion domain, no intervening writes/getters. Unlike the unrestricted Euler/RMat order proposal, these schedules take the same conversion chain.

Grounding: `orientationSetRMat_f` (`math/pprz_orientation_conversion.h:189-194`) invalidates everything except RMat_F. `orientationCalcQuat_f` (`.c:123-145`) selects `float_quat_of_rmat` when RMAT_F is valid. `orientationCalcEulersZxy_f` (`.c:198-210`) explicitly materializes QUAT_F if absent and always invokes `float_eulers_of_quat_zxy` (`math/pprz_algebra_float.c:763`). Insertion of the explicit getter only moves that mandatory computation earlier. This is a representation-consumer relation, not equality of ZXY and ZYX angles.

## S5 — ECEF integer producer should isolate float ECEF consumers from stale local history (source flags a likely violation)

Three public functions per speed instance: `stateSetSpeedNed_i` (`state.h:892`), `stateSetSpeedEcef_i` (`:912`), `stateGetSpeedEcef_f` (`:1067`). Acceleration analogue: `stateSetAccelNed_i` (`:1135`), `stateSetAccelEcef_i` (`:1145`), `stateGetAccelEcef_f` (`:1212`). Six public functions for the two-instance family; each candidate separately has three.

- A: `SetSpeedNed_i(N1); SetSpeedEcef_i(E); GetSpeedEcef_f()`.
- B: `SetSpeedNed_i(N2); SetSpeedEcef_i(E); GetSpeedEcef_f()`.
- Repeat the analogous three-call sequences for acceleration.

Intended candidate: for any bounded valid N1/N2 and same E, the final ECEF float outputs should match and represent fixed-to-float conversion of E. This is producer provenance/history independence, stronger than a single getter formula. Current source inspection gives reason to expect rejection of the intended relation, so it must not be advertised as an established invariant.

Grounding: ECEF setters copy E and assign only ECEF_I validity, leaving local numeric fields stale. However, `stateCalcSpeedEcef_f` (`state.c:1127`, specifically `:1133-1134`) checks ECEF_I but converts **ned_speed_i** into ecef_speed_f. `stateCalcAccelEcef_f` (`:1315`, specifically `:1322-1323`) analogously converts **ned_accel_i** into ecef_accel_f. Distinct finite N1/N2 with unequal conversions therefore appear capable of affecting the global observation despite identical accepted global updates. This is a source-level issue hypothesis, not an executed counterexample or proof. It makes the coupled relation particularly valuable for later validation. Restrict N/E to conversion-safe bounded values; origin initialization is not required for these ECEF_I branches.

## Other tempting claims to avoid

Attitude getter order is observable through branch priority (`orientationCalcEulers_f:179-184`), so unrestricted cache-order bit invariance is unjustified. Float/integer getter insertion can similarly introduce quantization and higher-priority cache paths. `stateSetLocalOrigin_i` clears local SPEED coordinate bits but does not clear horizontal norm/direction bits (`state.h:532`); therefore do not assume all local-derived speed observations are invalidated by relocation without separately investigating that contract. Invalid-state getters may return stale fields after conversion failure; a nonzero validity flag alone says a representation was supplied/computed, not that the supplied matrix is orthogonal or the supplied quaternion normalized.

## Source fingerprints and accounting boundary

SHA256:

| Path under sw/airborne | SHA256 |
|---|---|
| state.c | 585051d825b3b86c92819550fe877c0228df5268a1b9e968dcb5f6442dcb3d65 |
| state.h | 27b86222dd1c2e8069a6176fed1c2df4cffa7f0e6e09d78bad41c763f5b7a39d |
| math/pprz_orientation_conversion.c | 2ac756f29fe75f790bcc8c4cca6da8c9d1d2dcca7057ffb4a6d0fe5bd144d0d0 |
| math/pprz_orientation_conversion.h | c43e1883a10a6b23fdf3c5f409f071cd872f4d4392019f081c4fd67786700829 |
| math/pprz_geodetic_float.c | 79e39141445dcc4764a1b86ff7242c62999e67223ed4768ee14e62ff8dcd4da2 |
| math/pprz_algebra_float.c | 68f0476a5cdfef046f71e11eed7146aef2e14d9ed2d2f3a140bd8f5c46b39c00 |

Actor session `01a1ac6b-2f7b-71a1-9ed3-04c21ec7b7b7`, verified `session_meta.source.subagent.thread_spawn.agent_path=/root/relations_state_medium`. Meter began before substantive source reads; initial access/CLI setup excluded. Telemetry uses supported `five-verify` classification solely for discovery accounting, with scope `proof_attempt:false`; the directory is not a verification attempt. Resource metrics cover the wrapped source-survey command, not hosted inference memory or all subsequent shell reads. Token receipt uses the actual actor JSONL and records its model/reasoning events; no inferred token or hosted-memory estimates are substituted. No commits/pushes.
