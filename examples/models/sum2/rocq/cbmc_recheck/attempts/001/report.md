# Sum2 CBMC recheck — attempt 001

Problem: [Spec.v](../../problem/Spec.v). Generated solution: [Proof.v](Proof.v). Costs: [costs.json](costs.json).

Passed: all 1 actual emitted CBMC property IDs (main.assertion.1) independently rechecked. No remaining requested mapped property.

The first call accepts every binary32 value, including NaNs, infinities and signed zeros. arbitrary_call_safe covers every reachable original Csem state; arbitrary_call_returns constructs a genuine finite Csem return for every memory and typed argument pair using the independently proved accessibility ranking and progress. The assertion is a concrete ties-to-even test: 16777216.0f + 1.0f returns exact bits 0x4b800000. This is not a universal cross-tool NaN payload equivalence claim.

main_assertion_1 connects every actual Csem sum2 return to exact result bits and Cop.sem_binary_operation Oeq=Some(Vint Int.one). full_main_assertion_1 additionally constructs a fresh local float block, proves identity sem_cast, actual Mfloat32 store/load, then proves a genuine Csem star for the assertion expression: variable location reduction, scalar load, and equality reduction. local_r is an alpha-renaming of harness r. This is a property-by-property call/local-observation mapping, not a generated whole-main Csem trace.

The harness has no pointers, unions, memcpy, byte comparison or frame assertion, and CBMC emitted no pointer/byte property IDs. Those observations are not omitted: they are absent from this explicitly frozen harness. Local and parameter scalar allocation, initialization, load and release are covered by the imported checked entry construction. CBMC source nondet_float corresponds to universal typed arguments; it is not an external call assumed in the sum2 model.

Fresh temporary-directory compilation and independent rocq check rebuild all actual dependencies. Print Assumptions is retained. No new Axiom, Admitted or admit. Inherited library assumptions are ClassicalDedekindReals.sig_not_dec/sig_forall_dec, Classical_Prop.classic, FunctionalExtensionality.functional_extensionality_dep, and CompCert external_functions_sem/inline_assembly_sem parameters (the sum2 body has no external calls). The CompCert frontend and fixed target configuration remain trusted boundaries.

Model/target/configuration and every specification/source/dependency hash: provenance.json. Runtime: actual gpt-6.1-sol, requested and actual reasoning effort medium, evidenced by runtime-metadata.json. All failed compilation retries and final independent check are preserved in evidence/logs. Costs and raw actual usage receipts: costs.json and evidence/metrics.json. Resource figures are observed tool-process measurements, excluding model-server memory; 10ms RSS sampling can miss brief peaks and double count shared pages.

Observed costs: wall 591.432349 s; tool CPU 179.85999999999996 s; input/output/total tokens 2175594/13269/2188863; cached input 2155136; reasoning output 2000; sampled tool peak RSS 1037209600 bytes. Cost audit complete.

Supplemental canonical evidence run 20261105T131154-88f360ad8f: wall 281.645545 s; tool CPU 156.64000000000001 s; tokens input/output/total 1385235/8244/1393479; sampled tool RSS 1209376768 bytes. Both initial and supplemental cost audits complete; all records retained once.

Canonical receipt: ../../../spec-recheck.json (case path rocq/spec-recheck.json). The exact check_spec_recheck and kernel_record validators in scripts/compcert_gate.py passed: 1 proved, 0 refuted. The explicit successful direct kernel command is in evidence/final/run.json, command 036-independent-kernel-check; permanent directly compiled statements are evidence/checked/proof/RecheckSpec.v and Attempt.v. This validates property recheck evidence and does not claim the separate whole-execution-contract gate.
