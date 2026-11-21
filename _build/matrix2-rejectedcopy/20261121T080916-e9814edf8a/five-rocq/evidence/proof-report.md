# Rejected-output two-copy composition, 2D matrix inverse

Status: proof and independent kernel check passed. This is an auxiliary source-only proof for main.assertion.6 of the original harness; it does not claim a complete harness main execution.

Source: paparazzi/models/float_mat_inv_2d/rocq/support/RejectedCopyComposition.v
SHA-256: 65d92c25b2307ef546145cae382e95b83220d73c884cfab8607fa6b2295a159f
Import: From FiveInv2Case Require Import RejectedCopyComposition.
Claimed theorem: FiveInv2Case.RejectedCopyComposition.composed_assertion6
Expected type: FiveInv2Case.RejectedCopyComposition.ComposedAssert6

ComposedAssert6 conjoins:
- for every memory and separated output/input/before/after blocks satisfying PairPre, InitializedRejectedObservation follows;
- an inhabited PairPre and its InitializedRejectedObservation.

PairPre uses the unchanged small2 matrix, original initial_fixture [17.0f, +0.0f, +0.0f, 17.0f], valid source Inputs, both memcpy CopyPre conditions, and distinct copy destinations separated from the input. The inhabited proof uses the existing pair4_extend allocator for the source objects and two fresh Mem.alloc 0 16 buffers, without initializing the copy destinations.

rejected_copy_protocol is generic in arbitrary original CompCert memval bytes. It derives and records the actual memcpy16 external call and store before the call, the actual rejected normal Csem call and Post, uniqueness of every normal result, unchanged output bytes, the actual memcpy16 external call and store after the call, copy frames, the preserved before buffer, and the source input after the last copy. Undef and fragments are retained without conversion to invented zeroes.

The initialized instance derives actual final Mint32 loads in both copy destinations. decode_single_word relates Mfloat32 and Mint32 decoding only when an original initialized Vsingle load exists. The resulting words are [1099431936, 0, 0, 1099431936]. PairAssertion is the original left-associated short-circuit conjunction of four unsigned word equalities, with both operands loaded by Csem from their actual before/after blocks; its reduction yields Vint Int.one.

Validation:
- Final development compile: command 024-compile-rejected-composition-06, against _build/matrix-inv2-csem/development/current.
- Print Assumptions for rejected_copy_protocol and composed_assertion6 appears in that compile stdout.
- Independent rocq check: command 026-kernel-rejected-composition; all constants, including the final theorem, checked successfully.
- No new Axiom, Admitted, admit, source/model change, or canonical Spec/Proof/config/report edit was introduced.
- Earlier failed shell staging and proof iterations remain in the same run logs.
- Parent final canonical cold closure is separately owned by matrix_finish_ultra.

Inherited assumptions printed by Rocq are the existing classical real decision principles, classical logic, functional extensionality, and CompCert external_functions_sem / inline_assembly_sem parameters. No assumption was added for the target assertion.

Actual runtime metadata: evidence/runtime-model.json records gpt-6.1-sol with effort ultra from this worker's actual turn_context. Session thread: 01a1fd25-b0dd-7bd3-bd3e-064b5956fd61.

Actual measured costs from this skill-session boundary:
- Wall: 567.091160774231 seconds
- Tool CPU: 48.480000000000004 seconds
- Input: 1958774 tokens; output: 17959; total: 1976733
- Cached input subset: 1910144 tokens; reasoning output subset: 5970
- Observed tool process-tree sampled peak: 1385336832 bytes
- Maximum GNU time individual-process RSS: 1383612416 bytes

Cost audit status: incomplete, because two short cp staging commands (020-stage-rejected-composition-05 and 023-stage-rejected-composition-06) completed without a captured process-tree memory sample. Their missing samples are retained, not replaced by estimates or later replays. The actual global observed peak, GNU time data, all proof/checker samples, session boundary, and token events remain recorded. Memory sampling is at a requested 10ms interval, can miss brief peaks, can count shared pages twice, and excludes model-server/desktop memory.
