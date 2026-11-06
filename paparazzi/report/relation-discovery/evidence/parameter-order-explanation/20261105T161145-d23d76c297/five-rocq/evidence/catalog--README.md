# Paparazzi cross-function relation candidates

Discovery is complete: this catalog contains **13 source-only, unproved candidate families**. No CompCert model, formal specification, CBMC check, proof attempt, executed counterexample, or verified bug is delivered here. The first six are the recommended shortlist; the remaining seven are useful secondary questions. Candidate families may contain multiple related instances; counts below identify distinct public top-entry functions, excluding transitive callees and shared setup fixtures.

Source pin: Paparazzi [`abfee3dd56eeab12c528635504a429db3daf409a`](https://github.com/paparazzi/paparazzi/tree/abfee3dd56eeab12c528635504a429db3daf409a), inspected in `_build/paparazzi/upstream`; clean source worktree was observed. Every source link below is pinned to that commit. The local source hash index and source-read receipts are in [discovery evidence](../report/relation-discovery/evidence/). This is a local catalog; nothing was committed or pushed.

## Shared observation and semantic scope

A relation compares **separate executions** from the specified related old states, or matched client protocols on distinct objects. It never means applying alternative updates sequentially to one live state. Observe named scalar/vector/history fields and specified returned values; float bit equality excludes padding, unrelated stale caches and allocation identity. Independent per-entry CompCert models must relate their logical shared-state encodings; literal equality of global block identifiers or whole `Mem` values is not appropriate. Copy getter-returned mutable structures when making observations.

Pin the target ABI, float/literal evaluation precision, rounding and exception/NaN policy, compiler options, configuration and all relevant external math bindings. Preserve the actual C operation tree and conversions: real-number reassociation is not an implementation relation. Finite inputs alone do not guarantee finite intermediates. Require live initialized properly aligned input/output objects, the stated alias restrictions, no concurrent mutation and defined arithmetic/conversions. Numerical predicates additionally exclude singularities, overflowing intermediates and zero divisors as specified below. Later byte claims need explicit endianness, `memval`, allocation and frame scope. None of the replay questions asserts analytic stability or a real-valued approximation bound.

## Recommended six


### G1 — Horizontal mode substitution preserves the next reference

Top entries (3): [`gh_update_ref_from_pos_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L105), [`gh_update_ref_from_speed_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L143), [`gh_update_ref_from_accel_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L170).

**Question.** From the same old `gh_ref=(p,v,a,dt,configuration)`, position, speed and acceleration modes share the integration prefix: componentwise `q=fl(v*dt)`, `r=fl(a*dt)`, `p1=p+trunc(q*2^37)`, `v1=fl(v+r)`. For speed command u, relate the acceleration input to the exact source-order raw command `c=fl(fl(v1-u)*(-inv_tau))`. Compare speed(S,u) with accel(S,c): next position, speed, acceleration and preserved configuration should agree fieldwise, including float bits. The command uses **post-integration speed v1**.

For a position command, the corresponding c must be the position entry's actual **pre-limiter local `accel_sp` bits**: compute its integer position error at p1, convert as the source does, form velocity demand, apply the speed limiter, then form acceleration. A future question can identify that execution prefix or use an independently justified exact-source-order command model. This is not a newly invented C function or an assumption that final outputs already agree. In particular, `omega*0.5/zeta` contains a **double `0.5` literal**; all conversions/evaluation precision must be pinned.

**Connection and value.** The sibling entries do not call each other. The real [mode dispatcher](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h.c#L273) selects them at lines 290/296/298. This relational replacement question supports mode handover without a one-cycle reference discontinuity when raw controller demand matches; saturation may remain active.

**Domain and outlook.** Mixed floating control and fixedpoint position integration. Require representable float-to-int64 conversions, no signed overflow in integration/error arithmetic, finite bounded command/norm computations, nonnegative finite limits and nonzero zeta for position mode. Both routes use the same [acceleration limiter](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L203), including an identical deterministic `sqrtf` binding. Exact equality is promising for the stated matched demand; a general position=speed-mode gain relation is not established. Subtraction order, gains and signed zero defeat a naive rewrite. No speed-limit invariant is implied by speed/accel entries, and a strict Euclidean acceleration bound needs floating error analysis.


### F1 — Discrete PID reset/retune recovery equals fresh replay

Top entries (5): [`init_pid_df`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L174), [`update_pid_df`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L191), [`get_pid_df`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L206), [`reset_pid_df`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L215), [`set_gains_pid_df`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/pid.h#L232).

**Question.** For arbitrary defined old history S and the same `(Kp,Kd,Ki,Ts)`, compare A=`set_gains(S,...); reset(S)` with B=`init(T,...)`. The coefficient array `g[3]` and histories `u[2],e[3]` should match bitwise. Every matched finite suffix of updates, getter observations, resets and retunes should preserve field/output correspondence. Reset and retune commute because their writes are disjoint; retuning alone retains history.

**Functional observation.** The recurrence keeps its actual floating evaluation tree: `u[k]=(((u[k-1]+A*e[k])+B*e[k-1])+C*e[k-2])`, with zero history at reset. Histories record the last inputs/outputs. This arbitrary-cycle recovery question is stronger than a getter identity and is useful for controller restarts and online tuning.

**Connection, domain and outlook.** The five inline entries are sibling operations, so the ordering is a client protocol, not a source call chain. Init and retune use identical coefficient expressions. Exact bit replay is promising with fixed float semantics and no external math binding. For a numerical domain require finite nonzero Ts, representable coefficient calculations and finite reached recurrence intermediates. Exceptional-value replay needs a specified NaN policy. The separate simple `PID_f` implementation has different integration behavior; this question does not establish continuous PID correctness or stability.


### F2 — First-order low-pass retune/reset recovery equals fresh replay

Top entries (5): [`init_first_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L60), [`update_first_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L74), [`reset_first_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L89), [`get_first_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L101), [`update_first_order_low_pass_tau`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L112).

**Question.** From arbitrary defined old S, compare A=`retune(S,tau,h); reset(S,v)` with B=`init(T,tau,h,v)`. Observe equal bits of `time_const,last_in,last_out`, then matching outputs/fields under any finite matched lifecycle schedule. Reset and retune commute. Retune preserves histories and the currently visible output while changing the next update.

**Functional observation.** With actual source ordering, `T=fl(fl(2*tau)/h)`, reset sets L=Y=v, and update(x) sets `Y'=fl((fl(x+L)+fl(fl(T-1)*Y))/fl(1+T))`, L'=x. Keep actual literal conversions. This yields reusable bandwidth-change/recovery reasoning over arbitrary cycles.

**Connection, domain and outlook.** Five sibling entries, no mutual calls; the relation is a client protocol. No transcendental binding. Exact bit replay is promising; for finite numerical use require h>0, tau>=0, finite T and recurrence intermediates. Impose these on every retune/update event in a schedule. Do not claim every float reset value is an exact fixed point: rounding and overflow can invalidate that stronger property.


### F4 — Vector and rates filter APIs describe the same independent axes

Top entries (7): [`init_butterworth_2_low_pass_vect3`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L223), [`get_butterworth_2_low_pass_vect3`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L237), [`get_butterworth_2_low_pass_rates`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L252), [`update_butterworth_2_low_pass_vect3`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L267), [`update_butterworth_2_low_pass_rates`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L282), [`reset_butterworth_2_low_pass_vect3`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L297), [`reset_butterworth_2_low_pass_rates`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter_types.h#L311).

**Question.** Let rho map `(x,y,z)` to `(p,q,r)`. Start independently initialized equal per-axis filter states. Pair vector updates/resets/getters with rates updates/resets/getters under rho for every finite schedule. All axis coefficient/history fields should match and returned components should agree bitwise under rho. Each axis should also match an independent scalar Butterworth2 replay; changing one input axis cannot change the other axis states.

**Connection and value.** Both wrapper families actually call the same scalar update/reset functions three times in x/y/z order, then their respective getters; sibling vector/rates entries do not call one another. Scalar [init](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L313), update:325, reset:337 and getter:347 delegate to the second-order kernel. This crosses representation-specific interfaces, lifecycle wrappers and scalar state, supporting sensor/body-rate interface coherence and axis isolation.

**Domain and outlook.** FloatRates and FloatVect3 are related fieldwise, never by casting layouts. Input/reset objects must not alias filter memory: later component reads follow earlier mutations. Init needs finite positive omega/dt, finite reciprocal tau and valid second-order coefficients; pin `tanf` and the actual 0.7071 conversion. Replay from already equal states isolates a no-libm relation. Exact component bits are promising. Arbitrary rotational equivariance is not claimed, particularly with different axis cutoffs.


### S1 — Origin relocation invalidates local caches and preserves global position

Top entries (4): [`stateSetLocalOrigin_i`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L519), [`stateSetPositionEcef_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L708), [`stateGetPositionNed_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L839), [`stateGetPositionEcef_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L830).

**Question.** Compare A=`Origin(O1); Ecef(P); GetNed(); Origin(O2); GetNed(); GetEcef()` with B=`Origin(O2); Ecef(P); GetNed(); GetEcef()`. Final NED component bits should match under the same conversion schedule; ECEF should remain P and NED_F should be valid. Immediately after relocation local validity must be cleared, while stale numeric cache fields need not be erased.

**Connection and value.** This is a client protocol over lazy shared state. The [origin setter](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L523) converts the origin and clears local position bits (523–537); [NED calculation](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.c#L582) selects valid ECEF_F and invokes `ned_of_ecef_point_f` at 593. This actual getter-to-helper chain supports a frame-relocation cache contract, avoiding dependence on an old warmed local cache.

**Domain and outlook.** Require accepted producer IDs/setters, initialized valid origins, finite supported coordinates and identical geodetic math bindings/evaluation. ECEF setter must leave no competing valid position representation. Observe fields and valid bits, not whole state. Exact same-schedule agreement is promising; no unrestricted global/local roundtrip equality follows. Origin relocation does not demonstrably invalidate every speed norm/direction cache bit, so that stronger claim is excluded.


### S5 — An ECEF producer should remove dependence on stale NED history

Top entries (6): [`stateSetSpeedNed_i`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L892), [`stateSetSpeedEcef_i`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L912), [`stateGetSpeedEcef_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1067), [`stateSetAccelNed_i`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1135), [`stateSetAccelEcef_i`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1145), [`stateGetAccelEcef_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1212).

**Question.** Two three-entry instances (six distinct top entries in the family). Speed: compare `SetNed_i(N1); SetEcef_i(E); GetEcef_f()` with the same protocol using N2. Acceleration: repeat with its analogous three entries. With equal accepted ECEF updates, final float ECEF outputs should be independent of stale NED history and represent E's fixed-to-float conversion.

**Source concern, not a verified bug.** ECEF setters assign only ECEF_I validity and leave local numeric fields stale. Yet [`stateCalcSpeedEcef_f`, state.c:1133–1134](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.c#L1133) checks ECEF_I and converts **ned_speed_i** into ecef_speed_f. [`stateCalcAccelEcef_f`, 1322–1323](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.c#L1322) similarly reads **ned_accel_i**. These exact reads strongly motivate trying to refute history isolation with unequal conversion-safe N1/N2. No execution or formal refutation has occurred.

**Connection, domain and value.** Proposed client histories exercise actual getter-to-converter calls. Require accepted producers, initialized readable state, bounded conversion-safe integer fields and no intervening mutation; no local origin is needed for ECEF_I branches. This is a mixed integer/float provenance relation, not a numerical inverse-coordinate claim. Likely refutation would be valuable because it exposes a cross-representation stale-state leak that a local getter specification can miss.


## Seven secondary families


### G2 — Omega/zeta tuning order preserves final configuration and future traces

For a short Chinese explanation of this two-entry relation, see [parameter setter order](parameter_order.md).

Top entries (2): [`gh_set_omega`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L78), [`gh_set_zeta`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L87).

Compare `set_omega(o); set_zeta(z)` with reversed ordering from equal initialized gh_ref. Let O and Z be the actual clamped inputs. Both final states should have omega=O, zeta=Z, omega_2=fl(O*O), zeta_omega=fl(Z*O), with all other fields preserved. Both cache writes use **zeta*omega in the same operand order**. Equal configurations/states should then support identical future reference-update observations under a matched command schedule.

These are sibling public APIs, not mutual calls; ordering is a client protocol. Exact bit equivalence is promising and guards cached mixed-coefficient consistency during online tuning. Require finite inputs, initialized old fields and fixed fenv; compare final fields, not chronological return order or exception flags. `Bound` in [std.h:144](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/include/std.h#L144) maps NaN to the lower endpoint, but extending to exceptional old coefficients needs intermediate-product analysis. No external math binding is used. Exclude padding/concurrent intermediate-state observations.


### G3 — Grid-aligned origin translation commutes with every horizontal reference mode

Top entries (3): [`gh_update_ref_from_pos_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L105), [`gh_update_ref_from_speed_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L143), [`gh_update_ref_from_accel_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L170).

Relate old states by pB=pA+K*d, K=2^(37-INT32_POS_FRAC), and identical speed/accel/configuration. In position mode relate commands by tB=tA+d; in speed/accel modes use identical input bits. Expected next relation: pB'=pA'+K*d with identical speed/accel/configuration bits. Integer-grid displacement cancels before the positional float conversion, while common integration preserves its offset.

The entries are alternatives in the real G1 dispatcher; this is a cross-entry frame-invariance family, not a direct call chain. Mixed float/fixedpoint exact offset invariance is promising and useful for local-coordinate origin independence. Require a nonzero representable translation domain, no overflow in either execution, representable integer error/conversion arithmetic and pinned signed-right-shift semantics. Arbitrary sub-grid offsets are excluded. Adding reset `gh_set_ref` as setup needs separate treatment of negative signed left shifts at H:98–99. Pin limiter `sqrtf` as in G1.


### G4 — Altitude and climb modes preserve one inward-pointing speed envelope

Top entries (2): [`gv_update_ref_from_z_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_v_ref.c#L95), [`gv_update_ref_from_zd_sp`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_v_ref.c#L129).

For old (z,v,a), both integrate vpre=v+a and zpre=z+v. With L=GV_MIN_ZD, H=GV_MAX_ZD and acceleration bounds Amin/Amax, ask both entries to establish v'=clamp(vpre,L,H), Amin<=a'<=Amax, v'=L implies a'>=0, v'=H implies a'<=0. Position mode has z'=zpre; climb mode clamps zpre to cur_z±GV_MAX_Z_DIFF. This is a common exact integer predicate across different next states, not trajectory equality.

Actual [navigation dispatcher](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_v.c#L303) calls each selected entry then `guidance_v_update_ref` (292–300) then its controller; sibling entries do not call each other. Value: mode-independent compatibility between saturation and outward acceleration. Fixedpoint fallback, no runtime float controller arithmetic. Require L<H, Amin<=0<=Amax, pinned constants/shifts, and no preceding overflow in integrations, error products or narrowing. Publication left-shifts negative signed fields and climb cur_z conversion need explicit target semantics or a valid restricted domain. Saturation cannot repair prior undefined arithmetic; physical flight limits/stability remain outside scope.


### F3 — Fourth-order filter equals an ordered two-stage stream lifecycle

Top entries (8): [`init_butterworth_4_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L418), [`update_butterworth_4_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L433), [`get_butterworth_4_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L444), [`reset_butterworth_4_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L455), [`init_second_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L170), [`update_second_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L202), [`get_second_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L221), [`reset_second_order_low_pass`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/filters/low_pass_filter.h#L190).

Relate F.lp1/F.lp2 to independent scalar objects P/Q. Initialize using actual Q-factors **1.30651 and 0.51184** with exact call-site conversions. Under arbitrary matched input streams/resets, compare fourth-order update with z=second_update(P,x); y=second_update(Q,z). All stage fields/output bits should match; resets zero/set each stage's histories to v while preserving its own coefficients.

This is grounded in actual fourth-order init/update calls; fourth-order reset writes eight histories directly and getter directly reads lp2.o[0]. Useful modular lifecycle composition, not merely a getter identity. Exact ordered replay is promising; do not swap stages or collapse to a reassociated polynomial. Pin `tanf` for initialization, or start from equal supplied coefficients. Require finite positive tau/h, tan arguments away from poles, nonzero polynomial divisor and finite coefficient/recurrence intermediates for numerical meaning. The comment says **0.541184** while executable init uses **0.51184**: this is only a design-review lead, not a proved response defect. No ideal Butterworth/stability theorem is proposed.


### S2 — An accepted quaternion update discards old derived attitude caches

Top entries (3): [`stateSetNedToBodyQuat_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1261), [`stateGetNedToBodyRMat_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1308), [`stateGetNedToBodyEulers_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1314).

Compare `SetQuat(Qold); GetRMat(); GetEulers(); SetQuat(Qnew); GetRMat(); GetEulers()` with `SetQuat(Qnew); GetRMat(); GetEulers()`. Final matrix/Euler components and valid attitude bits should agree, with the **same post-update query order**. This captures producer replacement plus consumer replay rather than an isolated getter.

Client protocol over actual orientation delegates: [orientationSetQuat_f:181](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_orientation_conversion.h#L181) resets validity to QUAT_F; [RMat conversion:148](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_orientation_conversion.c#L148) precedes Euler conversion:173, which then prefers the cached matrix. Exact history isolation is promising with accepted setter IDs, finite normalized inputs, supported conversion domains and identical algebra/libm bindings. Swapping getters selects quaternion-direct versus matrix-derived Euler computations. Different computation paths alone do **not** establish an actual bit difference; general getter-order equality is simply unsupported here.


### S3 — Inserting an ECEF bridge leaves the final LLA-to-NED observation unchanged

Top entries (3): [`stateSetPositionLla_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L738), [`stateGetPositionEcef_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L830), [`stateGetPositionNed_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L839).

With the same fixed initialized floating NED origin, compare `SetLla(L); GetNed()` against `SetLla(L); GetEcef(); GetNed()`. Only final NED component bits must agree; ECEF validity differs intentionally, so whole-state equality is excluded.

This client insertion follows actual matching helper paths: [state.c:599–600](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.c#L599) invokes `ned_of_lla_point_f`, whose [implementation:119–123](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_geodetic_float.c#L119) uses a temporary ECEF conversion then the NED helper. Explicit bridging uses the same ECEF calculation at state.c:566–567 then NED at 592–593. Useful representation-materialization noninterference. Exact restricted-schedule equality is promising with accepted LLA setter, only LLA_F initially valid, ned_initialized_f, finite supported geodetic domain and identical trig/sqrt bindings. UTM-only origins and intervening integer/batch getters can select other priority branches; no inverse-coordinate accuracy theorem follows.


### S4 — Explicit quaternion warmup preserves ZXY attitude consumption

Top entries (3): [`stateSetNedToBodyRMat_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1268), [`stateGetNedToBodyQuat_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1302), [`stateGetNedToBodyEulersZxy_f`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/state.h#L1320).

Compare `SetRMat(R); GetEulersZxy()` against `SetRMat(R); GetQuat(); GetEulersZxy()`. Expected equal ZXY component bits and final orientation validity. The matrix setter retains only RMAT_F validity; [orientationCalcEulersZxy_f:198–210](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/math/pprz_orientation_conversion.c#L198) necessarily materializes QUAT_F if absent and then uses the same quaternion-to-ZXY helper. The explicit getter moves that mandatory computation earlier.

This is a client insertion relation grounded in actual getter/helper composition, useful for consumer/cache coherence. Exact equality is promising with accepted setter, finite proper rotation matrix, supported conversion domain, no intervening mutation and fixed sqrt/trig/algebra bindings. Observe copied output fields rather than mutable pointer identities. It is neither ZXY=ZYX angle equality nor unrestricted orientation-getter order invariance.


## Future implementation boundary

If requested later, create **one entry model with its actual callee closure per function** under `paparazzi/models/`, freezing original sources, target and external-call bindings. Shared state needs explicit corresponding representations across those models. Then place each cross-model question under `paparazzi/relations/<name>/problem/` with its real `Spec.v`, readable report and status, following the repository's examples. Only an actual subsequent proof attempt creates an attempts directory and checkable evidence. Current CompCert models are absent following their earlier deletion; archived `_build` models are not authoritative gold-standard inputs. This catalog is human-readable question discovery, **not already formalized pending proof obligations**.

## Discovery evidence and costs

[Costs](../report/relation-discovery/costs.json) retains one shared event scope for each domain and a separate integration interval, with actual runtime GPT-6.1 Sol medium receipts. Shared discovery is not allocated into fictional per-family proof costs. Raw metering files/statuses remain unchanged in [evidence](../report/relation-discovery/evidence/); standalone domain surveys there are provenance snapshots, while this README is the canonical candidate catalog. Token sums use actual event IDs once; cache/reasoning counts are subsets. Domain intervals overlap, so their wall times cannot be added into an end-to-end elapsed time. Tool memory excludes model-serving/desktop memory and sampled RSS can miss peaks/count shared pages twice. The filter run has a real memory-sampling audit gap for a short hash command: its complete-run memory is unknown (`null`) while available sampled values are retained. No verification result follows from a metering tool's discovery-delivery `passed` field.
