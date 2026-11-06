# Floating filter/controller cross-function relation discovery

Status: discovery only; all propositions below are proposed, unproved questions. No models, CBMC runs, proof attempts, Spec.v files, or stability results were produced. Read the canonical five-rocq skill, shared contract and example index; apply the gold standard to selecting a meaningful question before creating its future problem/attempt artifacts.

Source: `/home/yangfp/five/_build/paparazzi/upstream`, git HEAD `abfee3dd56eeab12c528635504a429db3daf409a`. All file paths below are relative to that source root. Exact source hashes:

- `sw/airborne/filters/pid.h`: `bbb610c5c24e667aaed0ba96682e0fdeb2c3f11e773b09da33d18a2df304ef1b`.
- `sw/airborne/filters/low_pass_filter.h`: `f2a29f114f47202858d37b9a010c7147d63e95fcce157fcef0888a491830bbcc`.
- `sw/airborne/filters/low_pass_filter_types.h`: `bea0badb5ffe116db7aaa1d5e1aace6727e733db4a6cabb31f526fe6c8795d5a`.

Notation/common scope: `bits` observes typed float field representations, excluding struct padding. Comparisons are between two executions using one pinned ABI, floating arithmetic/rounding/NaN policy and external math binding; they are not equality claims across host compilers or libm implementations. Fix every binary32 conversion and original expression evaluation order; do not reassociate the recurrence. All pointer objects must be live, initialized, correctly sized/aligned and writable/readable as required, with disjoint frames and no concurrent mutation. For vector/array inputs require no overlap with mutated filter storage. If byte-level conclusions are later wanted, separately state object allocation, endian and memval/frame observation. Finite inputs alone do not imply finite intermediates; a numerical interpretation additionally needs finite reached intermediates and nonzero divisors. These are replay/correspondence relations, not filter stability or real-valued approximation theorems. The finite numerical domain is independently satisfiable (e.g. zero histories and small positive parameters), not the desired conclusion smuggled into a premise.

## 1. Priority A: discrete PID reset/replay and online retuning compatibility

Exact entries in `sw/airborne/filters/pid.h`: `init_pid_df` 174-183; `update_pid_df` 191-199; `get_pid_df` 206-209; `reset_pid_df` 215-222; `set_gains_pid_df` 232-237. State declaration 160-164: history/output `u[2],e[3]`, coefficients `g[3]`.

Actual call graph: these five inline entries do not call one another. The following is a proposed client protocol over the same object, not a source-level call chain.

Question: for any prior defined controller state S and gains `(Kp,Kd,Ki,Ts)`, compare route A `set_gains_pid_df(S,...); reset_pid_df(S)` against route B fresh `init_pid_df(T,...)`. Their observed fields should agree bitwise. For every finite suffix of input values, feed the same suffix to `update_pid_df` on each route and interleave any `get_pid_df` calls; all update returns, getter values and full observed fields should match at every corresponding cycle. Reset and set-gains also commute on observed fields because the writes are disjoint. This yields arbitrary-cycle recovery equivalence from arbitrary stale history, while making retained/current coefficients explicit.

Independent functional observation: with computed coefficients A,B,C and initial histories zero, define `e[-1]=e[-2]=u[-1]=+0`, then use the exact float operation tree `u[k]=(((u[k-1]+A*e[k])+B*e[k-1])+C*e[k-2])`. Returned update and subsequent getter both observe u[k]; updated histories contain the last three inputs and two outputs. Parameter changes replace only A,B,C at that cycle, preserve accumulated histories, and use the same recurrence with the new coefficients. Reset starts a new zero-history epoch; a getter alone does not change it. This is a multi-entry protocol invariant, not just the trivial getter equality.

Conditions/classification: `Ts` nonzero and finite; finite representable gain-coefficient calculations for a numerical view. For pure paired execution with fixed IEEE semantics the recurrence may include infinities/NaNs, but bit equality then depends on the pinned NaN operation policy. Coefficient formulas from init and setter are syntactically identical, including binary32 literals and divisions, so the target is exact bits under the shared semantics, with no real PID approximation or stability claim. Note simple `PID_f` at 50-139 uses a different integrator: line72 computes `Ki*(sum+value)` and line78 accumulates value without dt; do not transfer the documentation's continuous formula to that implementation.

Value: restart testing and controller mode switching can be reasoned about for any number of cycles, without enumerating bounded traces. Gain changes are not resets; this question captures that distinction through observed history.

## 2. Priority A: first-order low-pass retune/reset lifecycle is a canonical replay protocol

Exact entries in `sw/airborne/filters/low_pass_filter.h`: struct 42-46; `init_first_order_low_pass` 60-66; `update_first_order_low_pass` 74-80; `reset_first_order_low_pass` 89-94; `get_first_order_low_pass` 101-104; `update_first_order_low_pass_tau` 112-116.

Actual call graph: all five entries act directly on fields; none calls another. Cross-entry ordering below is a proposed API protocol. Shared state is `time_const,last_in,last_out`.

Question: for arbitrary defined old state S, reset value v, parameters tau,h, compare A `update_first_order_low_pass_tau(S,tau,h); reset_first_order_low_pass(S,v)` with B fresh `init_first_order_low_pass(T,tau,h,v)`. All three fields should agree bitwise. Reset and retune commute on the same object. For every subsequent finite schedule of reset(v), retune(tau,h), update(x), and getter, matched schedules on A and B preserve state/return correspondence. In particular a retune preserves last_in,last_out and the currently visible getter, but changes the next update according to the new time_const.

Independent recurrence: T=fl(fl(2*tau)/h); reset makes L=Y=v; update(x) makes `Y'=fl((fl(x+L)+fl(fl(T-1)*Y))/fl(1+T))` with the exact original operation tree and L'=x; getter returns Y. A retune changes only T, and a reset changes only L,Y. Observe both state and an arbitrary suffix of outputs, not just reset's immediate return.

Conditions/classification: exact bit relation under common target arithmetic, no transcendental bindings. For a finite numerical view require h>0, tau>=0, finite computed T and finite intermediates; then 1+T is nonzero. For arbitrary schedules either impose those conditions at each event or explicitly allow IEEE exceptional outputs under the fixed semantics. No integer scaling is involved. Do not claim a reset to v is a fixed point for every float v: overflow/rounding and exceptional values defeat that generic statement.

Value: reusable arbitrary-cycle reasoning for changing bandwidth and resetting sensors without accidentally losing or retaining the wrong history. Stronger than a one-function assertion because it equates construction and recovery protocols plus future observation.

## 3. Priority B: fourth-order Butterworth is a stateful two-stage stream composition

Exact entries in `sw/airborne/filters/low_pass_filter.h`: `SecondOrderLowPass` 154-159; `init_second_order_low_pass` 170-181; `reset_second_order_low_pass` 190-194; `update_second_order_low_pass` 202-214; `get_second_order_low_pass` 221-224; `Butterworth4LowPass` 400-403; `init_butterworth_4_low_pass` 418-423; `update_butterworth_4_low_pass` 433-437; `get_butterworth_4_low_pass` 444-447; `reset_butterworth_4_low_pass` 455-459.

Actual call graph: fourth-order init calls second-order init twice; fourth-order update calls second-order update on lp1, then feeds its returned tmp to second-order update on lp2. Fourth-order getter reads lp2.o[0] directly. Fourth-order reset directly writes all eight history fields; it does not call the scalar reset. This mixed call-graph/direct-field relation is part of the reason to verify the whole lifecycle.

Question: compare initialized/reset fourth-order object F with two disjoint second-order objects P,Q whose fields correspond to F.lp1,F.lp2. Initialize P with Q-factor 1.30651 and Q with 0.51184, using exactly the conversions at the call sites; resets set both stages' histories to v while preserving their own a,b. For every finite input stream and every matched reset event, run z=update_second_order_low_pass(P,x), then y=update_second_order_low_pass(Q,z); compare to update_butterworth_4_low_pass(F,x). Stage fields and all output bits should match; subsequent fourth-order getter equals second-order getter Q. Coefficients remain stage-specific; no swapping of stages or collapsing into a single reassociated fourth-order polynomial is proposed.

Conditions/classification: exact bit stream composition under fixed arithmetic and deterministic `tanf` binding for matched initialization, or start after separately supplied equal coefficients to isolate the no-libm replay relation. Numeric coefficient domain needs finite tau>0,h>0; tan argument away from poles; finite K, poly, divisions and coefficients, poly nonzero. Each later numerical step additionally needs finite intermediates. C literal values are the actual code values, not mathematically exact Butterworth constants. No fixed-point/int relation: the integer routines have different coefficient construction, scaling and signed-overflow obligations.

Source discrepancy: comment at 408-409 says Q2=0.541184, but actual init at 422 uses 0.51184. This is a design-review lead, not a proved defect. The proposed theorem binds 0.51184 and would certify implementation composition only, not the claimed ideal Butterworth response.

Value: modular stream reasoning and reset propagation for a real cascaded filter; eliminates arbitrary-cycle re-expansion of internal histories while retaining actual floating evaluation order.

## 4. Priority A: Butterworth vector/rate interfaces are coherent under component renaming for an arbitrary lifecycle

Exact wrappers in `sw/airborne/filters/low_pass_filter_types.h`: `Butterworth2LowPassVect3` 210-214; `init_butterworth_2_low_pass_vect3` 223-229; `get_butterworth_2_low_pass_vect3` 237-244; `get_butterworth_2_low_pass_rates` 252-259; `update_butterworth_2_low_pass_vect3` 267-274; `update_butterworth_2_low_pass_rates` 282-289; `reset_butterworth_2_low_pass_vect3` 297-303; `reset_butterworth_2_low_pass_rates` 311-317. Scalar entries in `low_pass_filter.h`: init 313-317, update 325-328, reset 337-340, getter 347-350, delegating to the second-order entries listed above.

Actual call graph: vector/rate updates each call the same scalar update on x,y,z then their respective vector/rate getters; resets similarly call scalar reset three times. Init calls scalar init per axis with tau=1/omega_axis and v=0. The vector and rate entries do not call each other. Their lifecycle correspondence is a proposed relation between alternative interfaces on distinct equal objects.

Question: let component map rho(v)=(p=v.x,q=v.y,r=v.z). Start two independently initialized objects with identical omega,dt (or bit-identical valid per-axis scalar fields). On arbitrary finite schedules, pair update_vect3(v) with update_rates(rho(v)), reset_vect3(v) with reset_rates(rho(v)), and getter_vect3 with getter_rates. Then all per-axis coefficients/history fields agree, and returned vectors/rates agree componentwise under rho. Strengthening: each axis evolves exactly as an independent scalar Butterworth2LowPass protocol; changing only one input axis cannot change the other two axis states, and their update/get traces match scalar replays. Observe complete axis state as well as outputs to support induction across future events.

Conditions/classification: input/value objects must not alias the filter memory because later component reads occur after earlier mutations. FloatRates and FloatVect3 use different C types: the relation is fieldwise rho, never a layout cast. For init require finite positive omega and dt, finite reciprocal tau and the second-order coefficient domain; pin `tanf` and literal 0.7071 conversion. For replay from equal states no analytic interpretation of cutoff is required. Exact component bits under the common semantics; not approximate rotational equivariance (distinct per-axis cutoffs generally prohibit that claim).

Value: high-level sensor/body-rate interface coherence and axis isolation across complete lifecycles. The property crosses multiple actual wrappers, getters and scalar kernels and supports arbitrary-cycle reasoning, rather than checking a single update's assignment.

## Discovery evidence and resource accounting

Own session was located by exact `session_meta.source.subagent.thread_spawn.agent_path=/root/relations_filters_medium`, not by newest file. Session: `/mnt/c/Users/50635/.codex/sessions/2026/11/05/rollout-2026-11-05T23-54-44-01a1ac6b-6dee-7093-90c3-0d1d9cd1e1ed.jsonl`. Observed turn_context is `model=gpt-6.1-sol`, `effort=medium`; metadata provenance agrees with Sol. The actual session-bound five-rocq discovery meter was started before substantive source reads. Pre-boundary instruction/telemetry setup is outside its measured interval and not retrospectively allocated. Initial start rejected a scope string (required JSON path); the succeeding real run retained later failed `rg` lookup and a failed shell-variable read as evidence. WSL lacks rg; file discovery used Python/find instead.

Run and logs: `filters-evidence/20261105T155543-df99d5e2f4/five-rocq/`. Source read receipt is `logs/006-read-filters2.stdout.log`; source hash receipt is `logs/007-hashes.stdout.log`. Runtime receipt and normalized costs are in `filters-evidence/`. The report's final resource record references raw metrics, session usage receipts and independent cost audit. Unknown metrics remain null with reasons. No proof or successful kernel/CBMC result is claimed.
