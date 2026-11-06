# Parameter-order independent review

Outcome: **PASSED**. Both original setter models and the relation were independently reviewed against the sum examples' unchanged validators.

- All 11 active problems passed the complete artifact gate, including exact current-source bindings, typed goal certificates, runtime metadata, report links and costs.
- All 11 proof modules were independently rebuilt from current source dependencies and checked by the Rocq kernel. Relation: command 007. Zeta recheck and execution correspondence: the first two successful checks within command 008. Omega no-error, termination, functional and recheck: command 009. Omega execution and zeta functional, no-error and termination: command 011. The complete command IDs and logs are retained in the measured run.
- Both original CBMC harnesses were independently replayed with exact bitvector Z3 encoding: omega 15/15 and zeta 3/3 actual emitted properties succeeded.
- Both frozen inputs contain all five original type/macro/entry slices unchanged; upstream hashes and exact slice bytes were independently checked. The slice hash excludes its terminal newline.
- The relation composes actual CompCert Csem calls, proves both routes have normal completions, establishes the exact final state for every normal execution, compares all 14 named fields by bits, and proves the initial condition is satisfiable.
- All float32 arguments and old float32 field values are quantified, including NaN and infinities. Preconditions state complete typed readable state, writable structure memory and the actual global symbol bindings. The executable models remain unrestricted.

The compared state is the original complete GuidanceHRef. Final omega and zeta are the source Bound results, omega_2 is the source-ordered rounded product omega*omega, and zeta_omega is zeta*omega in both routes. Other named fields are preserved. Target: pinned CompCert x86-64 Linux little-endian binary32 nearest-even semantics. The reports retain inherited library assumptions and do not assert GCC/hardware/CBMC universal NaN-payload equivalence.

Real review failures and retries are retained: initial slice-hash newline-convention mismatch; missing normalized cost runtime fields/relative evidence paths; stale ancillary align metadata in the zeta batch; and the reviewer's incorrect omega execution-directory name. These were corrected and the relevant checks passed. The first two proof rebuilds in the interrupted zeta batch succeeded; no failed batch is labelled wholly successful.

See [problem index](problem-index.json), [normalized review costs](costs.json), [relation overview](../../../relations/parameter_order/README.md), and [full project report](../report.md). Raw measured commands, token events, resource samples and the audit are in evidence/run/. Pre-boundary initial coordination tokens are separately recorded; CPU and RSS before monitoring began are unknown. Monitored resource measurements cover launched review tools only, not unmonitored UI/shell overhead or model-serving memory. Shared overlapping process peaks are not summed into a fictitious global peak.
