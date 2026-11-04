# Connected Paparazzi proof bundles

77 new entry interfaces, 351 cumulative entries. Seven connected API/state families are organized below. Existing functions needed for composition are retained inside each shared Source.v but are not recounted as new entry interfaces. No CBMC or program-property proofs were run.

The protocols below describe API sequences suitable for future proofs. They are not claims that an entire Paparazzi firmware executes this invented combined pipeline. `callgraph.json` separately records actual source-level calls. All functions in one bundle use the same CompCert global environment and memory semantics; cross-bundle composition requires its own state/frame relations.

## PID controller lifecycle

Model: [Source.v](../groups/pid_lifecycle/model/Source.v)

Shared state: PID_f / PID_df / PI_D_df

Protocol: `init -> set gains -> updates -> get -> reset`

Proposed functional requirements: Reset is idempotent on the controller object projection and preserves gains; getters expose the last command; update histories match the exact rounded controller recurrence. Effective integral clamping is distinguished from the stored sum field. Prove preservation over any finite input sequence.

Proof boundaries: Writable controller object, separation/frame assumptions; later bounded-output theorems need explicit numeric hypotheses. No stability theorem is assumed.

## Low-pass filter lifecycle

Model: [Source.v](../groups/lowpass_lifecycle/model/Source.v)

Shared state: FirstOrderLowPass / SecondOrderLowPass / Butterworth histories

Protocol: `init/reset -> repeated update -> get`

Proposed functional requirements: Reset establishes the specified history; each step shifts history and computes the source-order rounded recurrence; any finite sequence agrees with iterating that transition.

Proof boundaries: Initialization may call target libm. Existing lowpass proofs require explicit transport to the new environment, not reuse by filename.

## Kinematic state estimator

Model: [Source.v](../groups/kalman_lifecycle/model/Source.v)

Shared state: SimpleKinematicKalman state[6], P, Q, r, dt, Hp/Hs

Protocol: `init -> set state/noise -> predict -> update position/speed -> get state`

Proposed functional requirements: Set/get round-trip preserves component bits under separated output memories. Prediction preserves velocity slots and updates each position by add32(p,mul32(v,dt)); prove its iterated recurrence. Correction obeys a separate gain/state transition.

Proof boundaries: Correction calls matrix-inversion support; its executable coverage/contract must be established before a complete predict-correct theorem. Symmetry or positive definiteness is not presumed bit-exact.

## Lazy orientation representation cache

Model: [Source.v](../groups/orientation_cache/model/Source.v)

Shared state: OrientationReps status and seven representation payloads

Protocol: `set -> cache-hit get, or get -> calculate -> cache valid`

Proposed functional requirements: Setters invalidate other representations and preserve the new payload; cache-hit getters return the stored representation without modifying its object bytes; cache-miss paths establish the corresponding valid bit under conversion contracts. Induct over permitted API histories.

Proof boundaries: Bitwise round-trip equality between different orientation representations is not assumed. Conversion calls and permitted status/payload invariant remain explicit obligations.

## Delayed bounded-increment filter

Model: [Source.v](../groups/delayed_filter_lifecycle/model/Source.v)

Shared state: delayed_first_order_lowpass_filter_t buffer[20], idx, delay, alpha

Protocol: `initialize -> configure delay/omega -> repeated propagate`

Proposed functional requirements: Configured delay is below 20; propagation preserves the circular index range and implements the exact integer recurrence and clamp. Compose this into a delayed-stream relation for arbitrary finite samples.

Proof boundaries: Signed arithmetic and shift/division conditions belong in the future proof precondition, not the execution model.

## Attitude rate/acceleration saturation

Model: [Source.v](../groups/attitude_saturation/model/Source.v)

Shared state: FloatRates / Int32Rates

Protocol: `saturate each control-cycle reference`

Proposed functional requirements: State a bounded-rate and boundary-acceleration property for the implemented clamps; use it as a local invariant lemma in a later control-cycle proof.

Proof boundaries: Float NaN/range and integer overflow hypotheses must be stated for the particular property; no whole-autopilot pipeline is invented.

## Framed byte FIFO

Model: [Source.v](../groups/framed_buffer_lifecycle/model/Source.v)

Shared state: framed_ring_buffer offsets, backing bytes and frame lengths

Protocol: `init -> put -> available/get/drop_last -> clear`

Proposed functional requirements: Clear establishes empty state; accepted puts followed by gets preserve message order and exact payload bytes, including wraparound; valid frame layout bounds the drop_last traversal. Prove preservation over operation histories.

Proof boundaries: Actual memcpy/builtin interfaces, aliasing, capacity and valid frame layout must be discharged. A malformed buffer is not removed from the model.

## Recommended proof order

1. PID reset/get and Kalman set/get bit-preserving properties, including the memory frame.
2. PID_df/PI_D_df and low-pass one-step rounded recurrences; delayed-filter index and clamp lemmas.
3. Induction over arbitrary finite input/operation lists, using those step lemmas and explicit invariants.
4. Orientation cache-miss conversions and Kalman correction once their external/model correspondence obligations are available.

Object-state properties compare the specified fields/bytes. They do not equate entire CompCert memories after separate function calls, since local allocation can advance memory block allocation. Numerical hypotheses belong to the later theorems; execution models remain unrestricted.

Use exact bit operations and source-order rounded operations in functional recurrences. Finite testing or path enumeration is not the proposed route to arbitrary-cycle properties. All requirements here are proposed proof tasks, not established theorems.
