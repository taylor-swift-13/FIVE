# Matrix CBMC semantic adequacy review

Verdict: semantic composition gaps confirmed in the current claims; do not publish all-ID closure on these claims alone. The review is read-only with respect to source/proof/canonical case artifacts.

All prepare/cbmc/align handoff output hashes were independently recomputed and matched. The exact 190 (2D) / 208 (3D) raw result IDs are recorded in source-trace-audit.json, together with full failed trace assignment/failure evidence and normalized trace hashes. Raw results and harness hashes remain authoritative.

Both 2D failed raw traces use [4272023241,1066696119,15406124,1877109524]. Both 3D failed raw traces use [3528688771,1493278778,2151094387,2151377975,2129459503,3901882368,4153000531,4286840832,7025870]. These agree with the actual TraceInputs.v constants, rather than a substitute diagonal input. Frozen fixed inputs and old output fixtures match the raw traces, including signed zeros. Failure sites are original 2D harness lines36/38 and 3D lines41/43, with residual assignment at37/42 respectively.

Source guard claims include all-reachable original Csem no_error under typed separate input/output memory. Their initial-cell permissions and bounds are consistent with actual source locations (2D constants0..3;3D constant rows/columns0..2). They cover source execution safety, not an independently generated full-main execution. Generic memcpy proofs use exact16/36-byte regions, separate blocks, live endpoints and frames; cross-object order guards are vacuous after separation, so no undefined C cross-object order is asserted.

Confirmed gaps:
1. 3D Assertions.v Assert4/8 combine FixedOutcome, scalar words3 and a generic WordBridge. The bridge is never instantiated on the actual returned Post bytes or composed into the original Csem word assertion. These are ingredients, not a completed observer proposition.
2. 3D Refutation9/10 retain nonvacuous sequential four-call Csem chains and raw trace constants, but do not evaluate the original status-equality/residual assertion expressions after that chain. Refutation10's scalar residual=-1 is separate from actual final-memory loads of large[0][0] and large_out[0][0].
3. 2D CaseWords does compose returned Post into copied Mint32 words. P189/P190 still lack an original failing Csem assertion-expression composition from the raw trace chain; P190 in particular conjoins scalar residual facts with replay.

The normative sum3 FullHarnessGoal explicitly includes actual returned prefix, memcpy observation, Mint32 load, and Csem expression evaluation (examples/models/sum3/rocq/cbmc_recheck/problem/Spec.v50-63). The matrix claims need analogous exact observation composition. Root authorized fresh scoped repairs after this review; this history is preserved before edits. Compilation/kernel acceptance of the existing propositions does not fix these adequacy gaps.

Evidence: source-trace-audit.json (all frozen/proof hashes, handoff validation, exact IDs and trace content), compact-original-traces.json (source writes and copied words), metered command logs. Resources are actual in metrics.json; no proof files were edited in this review.
