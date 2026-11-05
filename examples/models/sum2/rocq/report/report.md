# Sum2 proof-stage result

**COMPLETE for the listed sum2 verification request.** This does not change the incomplete sum3 harness recheck.

| Problem | Proof attempt and evidence | Result |
| --- | --- | --- |
| [No error](../no_error/problem/Spec.v) | [001 report](../no_error/attempts/001/report.md) | Proved for every reachable original Csem state |
| [Termination](../termination/problem/Spec.v) | [001 report](../termination/attempts/001/report.md) | Proved for all original Csem successors by a decreasing rank |
| [Full actual CBMC property recheck](../cbmc_recheck/problem/Spec.v) | [001 report](../cbmc_recheck/attempts/001/report.md) | All emitted property IDs rechecked; see exact mapping and observation scope |

## Configuration and scope

CompCert 3.17 Csem; x86-64 Linux standard ABI, little endian, binary32 nearest ties to even. Exactly two typed binary32 inputs and arbitrary initial memory; no numerical exclusions, including NaNs, infinities and signed zero. Source, bindings, generated model, problem and proof hashes are fixed in each attempt's inputs/provenance evidence. All proof workers ran GPT-6.1 Sol medium, confirmed by runtime metadata.

The real CBMC scalar harness emits `main.assertion.1`: the concrete call `sum2(16777216.0f, 1.0f)` equals positive finite `16777216.0f` (bits `0x4b800000`). It also calls sum2 with unrestricted binary32 inputs. It contains no pointer or byte observations. This is a property-by-property execution/observation recheck, not a claim about universal cross-tool NaN-payload equality or a generated whole-main execution trace. See the full attempt report for the formal assertion connection and inherited assumptions.

## Costs and evidence

[costs.json](costs.json) records time, token and memory with canonical shared costs counted once. Individual attempt reports link fresh compilation, Print Assumptions and independent Rocq kernel checks. Actual CBMC evidence and costs are in [the CBMC stage](../../cbmc/report/report.md).
