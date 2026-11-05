# FIVE reference examples — artifact standard

**Current requested proofs: COMPLETE.** Sum2 and sum3 no-error and all-successor termination goals are proved. Every property actually emitted by the unchanged recorded harnesses is independently rechecked: sum2 1/1, sum3 10/10. The cross-model theorem proves its stated equality conditional on three normal returns; single-model proofs separately establish safety, termination and return existence.

This index, the [sum3 case](models/sum3/README.md), the [sum2 case](models/sum2/README.md) and the [relation problem](relations/sum2_sum3/problem/Spec.v) define the format for future FIVE artifacts. Apply only requested stages and goals. A model-generation request ends with explicit unproved declarations; generation and type-checking never count as solving the problem.

## Find the question and its solution

| Question — exact problem/Spec.v | Current proof report | Established scope |
| --- | --- | --- |
| [Sum3 no error](models/sum3/rocq/no_error/problem/Spec.v) | [001](models/sum3/rocq/no_error/attempts/001/report.md) | Every reachable original Csem state |
| [Sum3 termination](models/sum3/rocq/termination/problem/Spec.v) | [001](models/sum3/rocq/termination/attempts/001/report.md) | Acc over every Csem successor |
| [Sum3 full CBMC recheck](models/sum3/rocq/cbmc_recheck/problem/Spec.v) | [002](models/sum3/rocq/cbmc_recheck/attempts/002/report.md) | All ten original memcpy-harness IDs, bytes and Csem assertion |
| [Sum2 no error](models/sum2/rocq/no_error/problem/Spec.v) | [001](models/sum2/rocq/no_error/attempts/001/report.md) | Every reachable original Csem state |
| [Sum2 termination](models/sum2/rocq/termination/problem/Spec.v) | [001](models/sum2/rocq/termination/attempts/001/report.md) | Acc over every Csem successor |
| [Sum2 full CBMC recheck](models/sum2/rocq/cbmc_recheck/problem/Spec.v) | [001](models/sum2/rocq/cbmc_recheck/attempts/001/report.md) | Entire actual scalar-harness property set |
| [Sum2 / sum3 relation](relations/sum2_sum3/problem/Spec.v) | [001](relations/sum2_sum3/attempts/001/report.md) | Conditional normal-return bit equality |

Each report links its generated Proof.v, actual model/specification hashes, checker, independent kernel receipts, inherited assumptions and costs. [Sum3 recheck 001](models/sum3/rocq/cbmc_recheck/attempts/001/report.md) remains an incomplete historical attempt that proved only returned-value bits. Its original ResultBitsGoal is retained verbatim in the expanded canonical Spec.v. Attempt 002 is current; history is never silently rewritten into success.

## Canonical layout

```text
examples/
  README.md
  models/<case>/
    README.md
    prepare/
      source/<entry>.c        # frozen selected C and real dependencies
      source/bindings.json   # source hashes, entry, target, actual call bindings
      handoff.json
      report/{report.md,costs.json,evidence/}
    cbmc/
      harness.c              # actual traditional-BMC input
      properties.json        # actual emitted IDs/results, if separately indexed
      handoff.json
      report/{report.md,costs.json,evidence/}
    align/
      model/Source.v         # automatic original CompCert Csyntax export
      model/Execution.v      # original Csem/Cexec wrapper
      model/compcert-manifest.json
      model/proof/           # generated parameterized obligation scaffolding
      spec-map.json          # or model/spec-map.json, fixed by handoff
      handoff.json
      report/{report.md,costs.json,evidence/}
    rocq/
      <problem>/
        problem/{Spec.v,report.md,status.json}
        attempts/<number>/{Proof.v,check.py,report.md,costs.json,evidence/}
      support/               # helper lemmas, not extra user questions
      spec-recheck.json
      handoff.json
      report/{report.md,costs.json,evidence/}
  relations/<name>/
    problem/{Spec.v,report.md,status.json}
    attempts/<number>/{Proof.v,check.py,report.md,costs.json,evidence/}
```

Keep one useful report per stage/problem/attempt. Auxiliary snapshots, provenance and raw measurements belong in evidence. Existing input/provenance receipts may be named inputs.json or provenance.json; they bind the exact sources actually compiled. Empty placeholders and duplicate summaries do not count as evidence.

The four stages hand off in order through case-relative paths and SHA-256 hashes. Pure Rocq tasks need only applicable problem/attempt/evidence artifacts; C/CBMC stages are explicitly not applicable. A status.json uses schema five-proof-problem/1, names the active numbered attempt and canonical Spec.v, records requested goals and their actual status. FullSpec.v, where present, is a compatibility helper rather than the user question.

## Acceptance and semantic scope

Every actual proof attempt records requested and runtime-observed model/effort, exact imported model configuration and source/spec/proof hashes, an outcome for every requested goal, compilation, Print Assumptions and an independent Rocq kernel check. Current proof workers use GPT-6.1 Sol medium. No admitted proof or new unproved axiom completes a goal. Generated align/model/proof scaffolding is separate.

For these cases, proof inputs are typed binary32 arguments and arbitrary CompCert memory. No-error quantifies every original Csem reachable state. Termination is accessibility of the full successor relation, not a fuel bound or selected path. CBMC assertions are independently proved, never imported as axioms. Return-existence lemmas make harness observation premises nonvacuous.

Sum3 checks four-byte caller objects allocated before both calls, preserved frames, copied binary32 bytes, uint32 load and Csem assertion evaluation. CBMC builtin guards short-circuit on distinct objects; their mapping never asserts undefined cross-object C pointer ordering. Both cases use an explicit property-by-property harness adapter rather than claiming a generated whole-main execution trace.

Target: CompCert 3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even with recorded NaN policy. The trust boundary includes the recorded frontend and inherited library assumptions. These proofs do not assert GCC/native-hardware equivalence or universal cross-tool NaN-payload equality.

## Costs and reproducibility

Stage report/costs.json and every attempt/costs.json use five-stage-costs/1 with time, token and memory groups. Times are seconds, tool RSS is bytes; cache and reasoning tokens are subsets. Retain failures and retries. Record observed values with scope and evidence; unknown historical values remain null. A genuinely new measured replay/reconstruction has its own record and does not recover missing past expense.

Shared authoring/verification sessions are referenced once. Per-attempt checker resources are subsets, not additional stage costs; per-attempt model tokens are null when no separate boundary existed. Token aggregates use event-ID union. End-to-end wall time is measured directly, never summed across overlapping stages. Sampled tool-tree RSS can miss peaks and count shared pages twice; it excludes model-server/desktop memory.

| Case | Prepare costs | CBMC costs | Align costs | Rocq and verification costs |
| --- | --- | --- | --- | --- |
| Sum2 | [record](models/sum2/prepare/report/costs.json) | [record](models/sum2/cbmc/report/costs.json) | [record](models/sum2/align/report/costs.json) | [record](models/sum2/rocq/report/costs.json) |
| Sum3 | [record](models/sum3/prepare/report/costs.json) | [record](models/sum3/cbmc/report/costs.json) | [record](models/sum3/align/report/costs.json) | [record](models/sum3/rocq/report/costs.json) |

[Relation costs](relations/sum2_sum3/attempts/001/costs.json) retain the cross-model attempt and reference its fresh verification subset. Historical incomplete attempts, interrupted runs and unmeasured expenses remain honestly scoped alongside complete current proofs.

From repository root:

```sh
source scripts/env.sh
python3 scripts/check-example-artifacts.py             # active pointers, hashes, metadata and canonical receipts
python3 scripts/check-example-artifacts.py --compile   # also rebuild every active proof attempt
python3 scripts/audit-costs.py --run <recorded-run>     # independent cost audit
```

The metadata validator does not replace semantic review. A model export, proof build, kernel check and cost receipt are distinct facts and are reported separately.
