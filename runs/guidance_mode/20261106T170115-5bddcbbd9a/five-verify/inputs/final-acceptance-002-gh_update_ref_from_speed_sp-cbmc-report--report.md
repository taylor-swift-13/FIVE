# CBMC scenario verification

The canonical direct CBMC execution passed all 122 actual properties: fourteen assertion occurrences (seven in each branch) and 108 automatic guards. Exact original property rows are retained in `../properties.json`; no property is omitted. Counterexample: not applicable (all properties succeeded).

This is traditional bounded model checking of the actual prepared C and fixed integer-restoring math binding. It uses exact bit-vector arithmetic with Z3, no floating-point SMT abstraction, no function contracts, no loops and unwind 1. Target: x86-64 Linux little endian, binary32 nearest-even. The raw command, source snapshots and JSON ledger are hash-bound by the handoff.

Controls are speed=(1,+0), acceleration=(2,+0), dt=1/512 and inv_tau=2. Speed commands (1,+0) and (6,+0) yield raw accelerations (-0.0078125,-0) and (9.9921875,-0); acceleration commands match these exact bits. Both saturation branches execute. Initial positions remain arbitrary signed64 patterns satisfying the harness safe-conversion and safe-sum guards. Six unrelated float configuration fields retain arbitrary bit patterns including NaNs. All seven postconditions and all automatic guards remain in both branches.

This result is scoped to these two nonzero control scenarios. Broad-control and finite-box attempts did not produce complete results and remain recorded as timeouts. Buffered solver status did not identify the full timeout phase; a separate diagnostic profile observed MiniSAT solving. The generated execution models remain unrestricted. Broad natural-domain safety, functionality and relation are separate Rocq obligations. Every emitted property is independently rechecked in the canonical cbmc_recheck problem.

Cost records include successful replay, actual authoring and failed attempts. Zero model tokens describe only pure replay. Shared intervals use event-ID union; CPU coverage gaps remain null with reasons and raw known values retained.
