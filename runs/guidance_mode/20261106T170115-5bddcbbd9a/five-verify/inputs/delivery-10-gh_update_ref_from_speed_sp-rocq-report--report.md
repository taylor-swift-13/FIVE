# gh_update_ref_from_speed_sp ROCq verification

Status: PROVED.

The generated CompCert Csyntax/Cexec model remains unrestricted over all machine argument lists and all memories. Execution correspondence preserves original Csem successors, evaluation orders, traces, returns and invalid-operation behavior; all-successor Acc termination includes paths that end in errors.

No-error and functional proofs use the explicit natural caller domain: all fourteen GuidanceHRef fields represented in a writable 64-byte global object; an actual eight-byte struct-by-value input with typed readable float fields; valid source-order binary32-to-signed64 position conversions; signed position additions in range; and the separate fixed gh_max_accel symbol/read. Other float fields and input values retain arbitrary binary32 bits, including NaNs, infinities and signed zeros wherever the conversion conditions permit. Normal completion and every actual return satisfy the source-order full-state update, with written-byte and frame evidence.

The 122 CBMC property rechecks have the exact frozen harness scope: two explicit command scenarios, fixed old speed/acceleration/inverse-tau/dt controls, six nondeterministic configuration floats and integer positions subject to the harness margins. All eight parameter fields, including the two fixed controls, are observed by the frame assertion. These scoped checks supplement the wider natural-domain core proofs. Actual source call-position/permission packets, 53 integer-helper guards, strict cast and signed/unsigned bounds, official four-byte memcpy/Mint32 observations and C integer-equality assertions link the per-ID adapters to execution. The eight-parameter comparison threads memory across all eight tests and operand call orders.

The internal software square-root result is the exact source-derived evaluator of the frozen helper Csyntax, with a proved actual callee/body bridge. This does not assert ideal IEEE square-root accuracy or equivalence to another library implementation.

| Canonical problem | Status | Requested exact goals | Evidence |
|---|---|---:|---|
| cbmc_recheck | proved | 122 | [typed kernel receipt](../cbmc_recheck/attempts/002/evidence/goal-validation.json) |
| execution_correspondence | proved | 8 | [typed kernel receipt](../execution_correspondence/attempts/001/evidence/goal-validation.json) |
| functional | proved | 2 | [typed kernel receipt](../functional/attempts/002/evidence/goal-validation.json) |
| no_error | proved | 1 | [typed kernel receipt](../no_error/attempts/002/evidence/goal-validation.json) |
| termination | proved | 1 | [typed kernel receipt](../termination/attempts/001/evidence/goal-validation.json) |

Eight execution-translation categories:

- domain-preservation: proof-backed. The actual entry is the unchanged Internal function call for every list val and every memory; the syntax invariant is automatic.
- floating-point-correspondence: proof-backed. At every reachable original state, exact bidirectional raw successor equivalence preserves every float operation, value, NaN/error behavior and trace.
- machine-integer-correspondence: proof-backed. At every reachable original state, exact bidirectional raw successor equivalence preserves all machine-integer, shift, cast and pointer operations.
- memory-access-correspondence: proof-backed. At every reachable original state, exact raw successor equivalence preserves loads, stores, allocation, free, invalid access and unknown-byte behavior.
- control-and-exhaustion-correspondence: proof-backed. Unbounded bidirectional star equivalence from arbitrary entry arguments and memory; no fuel limit or selected order.
- normal-result-and-memory-correspondence: proof-backed. Every returned value and memory has equivalent raw source/model executions, and byte observations are literally the same Mem.loadbytes.
- invalid-operation-correspondence: proof-backed. At every reachable original state, source non-normal-return/nostep is equivalent to model non-normal-return/nostep.
- whole-execution-correspondence: proof-backed. Bidirectional unbounded whole-execution equivalence retains every Csem evaluation order, trace, final state and error.

Frozen harness input literals: `{1.0f,0.0f}`; `{6.0f,0.0f}`.


Costs include every discovered actual task five-rocq run, including retired semantics/all-order/checker/function actors and failed/retried authoring. Both cases reference the same shared records; there is no exclusive allocation. Deduplicate run IDs and actual token event IDs. Null measurements mean unavailable/unallocated, never zero; recorded CPU subtotals and observed child RSS remain labelled separately. The root/global frozen cost union owns cross-stage totals and review suffixes. See [costs.json](costs.json).

Trust boundary: pinned CompCert3.17 frontend/Csem/Cexec, inherited CompCert/Flocq library declarations and the recorded little-endian x86-64 target. No GCC/hardware or cross-tool NaN-payload equivalence is claimed. Failed/interrupted histories and raw metrics/status remain unchanged.


Shared recorded run figures (each run is counted once globally):

| Run | Raw status | Wall s | Tool CPU s | Sampled tool tree RSS bytes | Model tokens |
|---|---|---:|---:|---:|---:|
| `_build/guidance-mode-adapters/20261106T143544-3324208c4f/five-rocq` | passed | 1428.423 | 1231.490 | 1589084160 | 8980083 |
| `_build/guidance-mode-adapters/20261106T145948-f48f22f7d8/five-rocq` | passed | 3328.797 | 541.280 | 1795919872 | 20150689 |
| `_build/guidance-mode-allorder/20261106T121712-383a93583a/five-rocq` | interrupted | 52.402 | 0 | null | 512344 |
| `_build/guidance-mode-allorder/20261106T122019-5fbabb1f83/five-rocq` | passed | 5274.123 | 359.640 | 1394270208 | 41801812 |
| `_build/guidance-mode-cbc-dry-repair/20261106T171945-b3300e5bf2/five-rocq` | passed | 2009.062 | 1807.710 | 1254490112 | 23478775 |
| `_build/guidance-mode-checker/20261106T135140-a28ddbd7c3/five-rocq` | passed | 625.452 | 75.810 | 1209790464 | 1892175 |
| `_build/guidance-mode-core-input-repair/20261106T163945-82b2f0839c/five-rocq` | passed | 1067.447 | 262.520 | 1063219200 | 7242345 |
| `_build/guidance-mode-final-cbmc-recheck/20261106T160753-25928c6172/five-rocq` | passed | 1307.845 | 876.430 | 1242013696 | 4965760 |
| `_build/guidance-mode-function/20261106T141021-525ce654d4/five-rocq` | interrupted | 1899.047 | 0 | null | null |
| `_build/guidance-mode-function/20261106T141031-39253655a1/five-rocq` | passed | 928.079 | null; recorded subtotal 95.310 | 1208619008 | 3695941 |
| `_build/guidance-mode-guarded-entry/20261106T153752-f095ff9b11/five-rocq` | passed | 511.179 | 77.480 | 1186533376 | 5389908 |
| `_build/guidance-mode-helper-guards/20261106T142634-3489ae6ae1/five-rocq` | passed | 1699.595 | 368.130 | 10855755776 | 7889854 |
| `_build/guidance-mode-manual-assertions/20261106T145524-7ff019cebc/five-rocq` | passed | 566.582 | 80.390 | 1593737216 | 3897299 |
| `_build/guidance-mode-rocq-stage-metadata/20261106T160418-f84fad4b9b/five-rocq` | passed | 3767.722 | 12.090 | 46981120 | 21161968 |
| `_build/guidance-mode-rocq-stage-refresh/20261106T173118-122c2e38fa/five-rocq` | passed | 1373.355 | 3.630 | 49352704 | 1741413 |
| `_build/guidance-mode-saturation-prelimit/20261106T150547-20644e3540/five-rocq` | passed | 1863.946 | 97.300 | 1144094720 | 14224030 |
| `_build/guidance-mode-semantics/20261106T111233-1d5cf4386d/five-rocq` | passed | 3848.639 | null; recorded subtotal 547.520 | 12672221184 | 27641781 |
| `_build/guidance-mode-work/20261106T112253-97fe419e0f/five-rocq` | interrupted | 835.706 | null; recorded subtotal 46.760 | 4087320576 | 5089628 |
| `_build/guidance-mode-work/20261106T115415-c0dd78b855/five-rocq` | interrupted | 115.874 | 0 | null | 1069605 |
| `_build/guidance-mode-work/20261106T120058-3fb70c49ac/five-rocq` | interrupted | 1789.855 | 52.650 | 1386770432 | 14195720 |
| `_build/guidance-mode-work/20261106T123150-92d88522c3/five-rocq` | passed | 7254.062 | 84.310 | 594862080 | 52243522 |
| `_build/guidance-mode-work/20261106T143244-a503c9b080/five-rocq` | interrupted | 5708.941 | null; recorded subtotal 900.100 | 12530601984 | 43954181 |
| `runs/20261106T111221-7a25959e59/five-rocq` | interrupted | 4319.229 | null; recorded subtotal 345.340 | 10114342912 | 25993558 |
| `runs/20261106T122440-aeecb322be/five-rocq` | passed | 2951.553 | 109.660 | 1389989888 | 21316243 |
| `runs/20261106T131406-37a522857a/five-rocq` | passed | 1304.484 | 148.650 | 1208135680 | 10528522 |
| `runs/20261106T133625-e9c66e37e1/five-rocq` | passed | 3507.285 | 562.310 | 1594544128 | 25760062 |
| `_build/guidance-mode-parent-review/20261106T110341-587c1b50da/five-verify` | None | 21377.174 | null | null | 96746425 |
| `_build/guidance-mode-parent-review/20261106T110341-587c1b50da/five-verify` | None | 111.620 | null | null | 350996 |

Frozen shared review metrics: [authoring-review-costs.json](../../../../report/guidance_mode/independent-review/authoring-review-costs.json).

