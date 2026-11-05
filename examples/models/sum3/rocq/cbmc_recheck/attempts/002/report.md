# Original sum3 harness: attempt 002

The problem is `../../problem/Spec.v`; `ResultBitsGoal` remains verbatim for historical attempt 001, and `FullHarnessGoal` states the byte-level harness observation. Attempt 001 only established returned-value bits and remains historical incomplete evidence.

This attempt proves all ten checks of the unchanged original `cbmc/harness.c`. There is no scalar-only replacement harness. `HarnessPrefix` allocates result and bits as distinct four-byte caller locals before both calls. The first call has arbitrary binary32 arguments; the second has exactly the original three concrete binary32 inputs. Both calls use actual CompCert Csem stars. Earlier caller objects inhabit arbitrary base memory. The prefix exists for every base memory and every first-call binary32 triple, proved from progress and accessibility. Every normal return path preserves caller blocks; the proof follows actual callee allocation, parameter stores and frame frees using `Mem.unchanged_on`.

At memcpy, the proof stores the Csem return value in the actual result block, obtains its four `encode_val Mfloat32` bytes, supplies them to `extcall_memcpy_sem 4 1`, copies them with `Mem.storebytes`, loads Mint32 from bits, and proves that value is zero. The comparison reads the bits variable and performs actual Csem expression steps to `Vint Int.one`. `cbmc_main_assertion_1` covers every allowed memcpy outcome and also supplies a successful-copy witness.

CBMC builtin pointer guards are translated from its actual original goto instructions 32--40. The first three checks have guard `True /\ ~(bb <> br)`; the next three have guard `~(bb <> br \/ order1)`; nonoverlap is `(bb <> br \/ order1) \/ order2`. Both order predicates are universally quantified and uninterpreted. Fresh distinct blocks discharge the guards, so no cross-object C pointer ordering is asserted. Readable and writable four-byte permissions, live bases and live one-past pointers are additionally established from actual allocations and maintained permissions. The internal CBMC dead-object predicates correspond to live object evidence; in this exact harness their guard antecedents are false. This is a scoped memory/observation adapter, not a generated whole-main Csyntax export.

Model: unchanged generated sum3 Source.v and Execution.v; target and all input hashes are listed in `inputs.json`. The trusted boundary is CompCert Csem, its memory and memcpy semantics, the unchanged source export, and the explicit mapping of CBMC internal object IDs to distinct CompCert blocks. No numerical restriction, new axiom, or admitted goal is introduced.

Permanent statement sources are directly compiled in the measured skill-session, then checked with a direct independent `rocq check`. `Print Assumptions` is recorded for each delivered theorem. Inherited assumptions include CompCert's classical real/functional-extensionality axioms and its generic external_functions_sem / inline_assembly_sem parameters inherited by the progress/termination path; this closed sum3 program executes no such external call. The memcpy relation is its concrete proven CompCert builtin semantics.

Agent: actual gpt-6.1-sol, requested medium and actual medium (`evidence/runtime-metadata.json`). `costs.json` records the complete measured session including all failed compiles and retries. Setup/contract reading before telemetry start is excluded; cost and validation status are reported independently.

Final result: all ten original properties proved. Canonical ledger: `../../../spec-recheck.json`; kernel receipt: `evidence/kernel-check.json`. Permanent source compile commands 020/021 and independent kernel command 022 passed. The final model manifest has SHA-256 `c2b89dbaeda373e02257ee44576379a7a1eef3365b17f77e54f744af7e9e3b32`. The historical raw CBMC run is preserved, and the current ledger uses the auditor's exact same original C/harness replay with actual input snapshots.

## Review links and configuration

[Question](../../problem/Spec.v) · [Generated proof](Proof.v) · [Rebuild checker](check.py) · [Input/model hashes](inputs.json) · [Canonical ledger](../../../spec-recheck.json) · [Kernel evidence](evidence/kernel-check.json) · [Costs](costs.json).

CompCert 3.17 Csem/Cexec; Rocq 9.2; OCaml 4.14.2; x86-64 Linux standard ABI, little endian; IEEE754 binary32 nearest ties to even, including the hash-bound CompCert NaN policy. Entry sum3 / f_sum3, namespace FiveSum3. Source function has no external callees. The harness adapter uses CompCert concrete memcpy semantics. No numeric exclusion applies to the first call.

| Original property ID | Checked theorem in FiveSum3Attempt.Proof | Result |
| --- | --- | --- |
| memcpy.pointer.1 | `cbmc_memcpy_pointer_1` | Proved |
| memcpy.pointer_arithmetic.1 | `cbmc_memcpy_pointer_arithmetic_1` | Proved |
| memcpy.pointer_arithmetic.2 | `cbmc_memcpy_pointer_arithmetic_2` | Proved |
| memcpy.pointer.2 | `cbmc_memcpy_pointer_2` | Proved |
| memcpy.pointer_arithmetic.3 | `cbmc_memcpy_pointer_arithmetic_3` | Proved |
| memcpy.pointer_arithmetic.4 | `cbmc_memcpy_pointer_arithmetic_4` | Proved |
| main.precondition_instance.1 | `cbmc_main_precondition_instance_1` | Proved |
| main.precondition_instance.2 | `cbmc_main_precondition_instance_2` | Proved |
| main.precondition_instance.3 | `cbmc_main_precondition_instance_3` | Proved |
| main.assertion.1 | `cbmc_main_assertion_1` | Proved |

Actual authoring run: 1200.470 s wall, 284.93 s tool CPU; 6622578 model tokens (input 6594172, output 28406); 1023537152 bytes sampled tool-tree peak RSS. Cache/reasoning are subsets. Failed attempts and retries are included; setup before the measured boundary is excluded. The tool-tree observation excludes model-server/desktop memory and may miss short peaks or count shared pages twice.
