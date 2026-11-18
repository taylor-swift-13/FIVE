# Horizontal guidance mode verification

Complete: all 11 current proof problems, all 244 individual CBMC rechecks, exact typed bindings, independent kernels and both full CompCert gates have passed. All 415 active captured input files pass SHA-256 validation. Every current problem has an actual isolated cold rebuild; the explicit multi-batch ledger preserves the failed intermediate aggregate checks rather than calling them successful.

## Questions and scope

The two cases are [speed-command update](../../models/gh_update_ref_from_speed_sp/README.md) and [acceleration-command update](../../models/gh_update_ref_from_accel_sp/README.md). Each follows `prepare/ -> cbmc/ -> align/ -> rocq/`, with separate canonical questions and retained numbered attempts for no_error, termination, functional, cbmc_recheck and execution_correspondence. The [relation question](../../relations/guidance_mode/problem/report.md) invokes both actual CompCert entry executions from independent memories representing the same logical old state.

Both routes first advance position and speed. The speed route then computes `(updated_speed - speed_command) * (-inv_tau)` in the original binary32 operand order. The relation requires the acceleration route command to match those actual pre-saturation bits. Both routes consequently finish with equal bits in every one of the 14 named fields. Normal completion exists on both sides; an actual original-Csem prefix reaches the pre-saturation call with the integrated global state and raw local command. Satisfiable witnesses exercise both branches with nonzero position and speed advancement.

The natural valid-input precondition requires typed writable64-byte state storage, a valid readable8-byte by-value vector argument, the actual fixed maximum-acceleration global with readable permission, successful float-to-int64 position conversion, and nonoverflowing signed position sums. It permits all other machine float patterns consistent with those requirements. NaN behavior follows the pinned CompCert target policy. CompCert signed integer addition wraps; the explicit no-overflow condition supplies the intended ISO-C/nonwrapping position meaning. Invalid conversions and memory operations remain present in the unrestricted execution model.

## Actual semantics and proof route

Source extraction binds the fixed upstream commit and exact original entry, type, macro and callee slices. Both CBMC and CompCert consume the same prepared C and fixed binding. Generated Source.v files are never edited. Full target configuration is x86-64 Linux little endian, IEEE binary32 nearest-even, with CompCert 3.17 Csyntax/Csem/Cexec.

The common C math binding is a finite integer-restoring square-root implementation: explicit special-value bit policy,23 normalization blocks and24 restoring steps. Its actual C body is verified through a source-derived value interpreter with a proved memory simulation, actual local allocation/by-value binding/body execution/return/free, and original Csem entry composition. A former hand-written word denotation is archived; the public functional interface is the exact source-derived denotation. No equality to an ideal IEEE square-root or native libm is assumed or claimed. No external sqrt contract or new target axiom is introduced.

Safety covers every reachable original Csem state under the natural input precondition. Termination is accessibility over all successors, rather than merely one normal witness. Entry proofs retain actual nested function calls and all expression evaluation orders. Complete functional state formulas and named field bit observations are linked to actual memory loads; helper and caller cleanup have typed-load, byte-frame and access-permission proofs. Eight execution correspondence categories cover unrestricted argument lists and memories, including invalid operations and errors.

## CBMC and independent rechecks

Each final direct CBMC run passed 122/122 properties: fourteen manual assertions and 108 automatic guards. The final commands use exact bit-vector Z3 semantics, no FPA mode, no function contracts and no replacement goto models. All actual IDs and original source locations are retained. The [independent ledger audit](independent-review/cbmc-property-audit.json) verifies counts, uniqueness and current input hashes; it does not replace Rocq reproof.

CBMC is explicitly scoped to two nonzero control scenarios. Old speed=(1,+0), old acceleration=(2,+0), dt=1/512 and inv_tau=2; speed commands1 and6 yield matching acceleration commands(-0.0078125,-0) and(9.9921875,-0). Both saturation branches execute. Signed64 initial positions remain arbitrary subject the original safe-sum assumptions. Six unrelated configuration floats retain arbitrary bits, including NaNs. Seven logical postconditions and every automatic check remain in both branches. This scope does not narrow the generated models or the broad natural-domain Rocq theorems.

All 244 actual IDs have individual canonical questions and independent reproofs. Automatic integer guards establish exact arithmetic/conversion bounds separately from Csem no-error. Software-helper guards connect explicit static source sites, instrumented actual-memory operand events, and any reachable helper call from either complete original entry. Initialized witnesses cover both canonical nonzero scenarios, and unsaturated original executions cannot call the helper. Four-byte bit adapters use real byte copies and distinguish objects before pointer-order guards. Manual properties derive complete post-state bits from actual entry execution.

## Retained attempts and costs

The initial compiler builtin binding was unsupported by CBMC; the failure is retained. Full symbolic-control and finite-box solver attempts timed out without complete ledgers. Software binding variants and concrete probes are preserved as history, and only the frozen integer-restoring version is active. Buffered JSON output did not establish the full timeout phase; a separate profile observed MiniSAT solving. Timeouts are neither successful checks nor source counterexamples.

The [actual run index](evidence/cost-run-index.json) includes successful work, failures, retries and retired workers. Every stage and proof attempt retains cost records with real runtime model/effort evidence. The [global cost record](costs.json) is prepared by independent review using actual actor session event-ID union, including setup and closing events. Parent inclusive token totals are not added to child totals. Shared stage windows are explicitly shared rather than allocated by guess. Unobserved complete CPU and parallel joint RSS remain null with reasons; raw known figures are retained.

Run [check_all.py](check_all.py) for unchanged reference metadata validation, all discovered actual problems, and both full CompCert gates. `--compile` additionally rebuilds every active proof in isolation. The [current complete metadata and input-copy audit](evidence/complete-metadata-validation.json) passed. The reviewer retains an explicit per-problem cold-rebuild coverage ledger, including both actual repaired default CBC checkers. No single failed batch is presented as an all-problem success. No push is authorized or performed.

## Final independent acceptance

[Final gates and frozen stage hashes](independent-review/final-validation.json) and [all eleven cold rebuilds](independent-review/cold-rebuild-coverage.json) bind the current attempts. The [final review cost](independent-review/final-review-costs.json) includes failed preflights and successful checks. The [task cost record](costs.json) and its token-only actor receipts use event-ID union, including setup, retries and closing events. Cached input and reasoning output remain subsets. Historical total CPU and simultaneous task RSS were not fully observed and remain null; this does not alter the proved propositions.

The final recorded task wall time is 7 h 0 min (25202.756 s). Observed model usage is 582,750,952 tokens, including 578,086,144 cached input tokens; these cached tokens are already included in input, not added again. The measurement ends at the cost record's explicit event boundaries; later delivery prose is outside that closed observation window.

## Float-to-int64 minimum boundary

The exact value `-2^63` is representable both as binary32 and as `INT64_MIN`. Converting this exact value is valid; the CompCert/Rocq execution model retains it. It must not be removed from the model merely to satisfy an extra checker.

```c
float x = -0x1p63f;       /* exactly -2^63 */
int64_t y = (int64_t)x;   /* INT64_MIN */
```

The retained [minimal source](evidence/float-int64-minimum/boundary.c) and [actual command/results](evidence/float-int64-minimum/result.json) reproduce this with CBMC 6.11.0 (cbmc-6.11.0) on the recorded 64-bit little-endian nearest-even target:

| Check | Actual result |
|---|---|
| Assert `y == INT64_MIN`, without `--conversion-check` | SUCCESS |
| The same assertion, with `--conversion-check` | SUCCESS |
| The extra float-to-signed-integer conversion guard | FAILURE |

This is a conservative boundary problem in this version's additional conversion check, not evidence that CBMC computes a different converted value. The original broad CBMC harness used the stronger lower assumption `scaled > -2^63`; its verification scope consequently excludes this otherwise legal boundary. The generated execution model remains unrestricted, and the natural Rocq safety domain admits the exact boundary when its other memory and position-sum conditions hold. The final two nonzero CBMC scenarios do not reach this endpoint, and their independently rechecked conversion obligations explicitly include strict lower/upper comparisons.

This follow-up diagnostic documents the boundary; it does not extend the two final CBMC scenario results or rewrite the already closed verification cost interval.

