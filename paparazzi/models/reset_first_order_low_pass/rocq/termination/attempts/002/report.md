# reset_first_order_low_pass: termination current proof

Proved requested goals: AllSuccessorsTerminate.

For every raw list val argument list and arbitrary CompCert memory, including malformed calls and invalid or uninitialized states, Acc(successor Execution.ge)(Execution.entry args m) holds. This covers every original Csem successor and evaluation order, with no fuel or fixed step bound. Safety is separately established under its explicit precondition.

Target: CompCert 3.17 original Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32 nearest ties-to-even and manifest-bound CompCert/Archi NaN policy. C frontend/source export and inherited library semantics remain the trusted boundary. No GCC, native-hardware, or cross-tool NaN-payload equivalence is claimed.

Canonical question: [Spec.v](../../problem/Spec.v); checked proof: [Proof.v](Proof.v); reproducible cold checker: [check.py](check.py). Default check.py rebuilds the full source dependency closure in an empty temporary directory and performs independent kernel checking; no repository .vo cache supplies proof dependencies.

[Current exact theorem/type and physical-snapshot bindings](evidence/goal-validation.json); [independent kernel evidence](evidence/kernel-evidence.json); [typed GoalBinding Print Assumptions output](../../../../../../../_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq/logs/189-reset_first_order_low_pass-goal-certificate.stdout.log). Actual direct compile/kernel command IDs are in these receipts.

Actual worker runtime: gpt-6.1-sol, requested and observed medium, [whitelisted actual configuration receipt](../../../../../../../_build/lowpass-execution-worker/20261106T193120-c7e2b81a18/five-rocq/evidence/main-runtime-20261106T192316-c89d343f94.json).

The actual theorem-specific Print Assumptions output is retained in the bound compile and GoalBinding stdout logs. Across these dependencies, printed inherited declarations include ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. SourceGuards receipts additionally expose CompCert external_functions_sem and inline_assembly_sem semantic parameters; inspect each theorem receipt for its exact subset. No new goal axiom or admitted proof is introduced.

Prior main run184407-e47c999b12 contains real memory-proof development and invalid nested termination command indices; main run190518-8d27304b10 contains real mathematical work but invalid physical captures caused by basename collisions. Both remain CLOSED failed and are not accepted proof evidence. Current fresh run192316-c89d343f94 binds independently checked exact source snapshots, physical copies and typed GoalBinding certificates. Correction run190222-912614879e and physical-copy preflight191900-099f8ec038 remain separate successful evidence. Historical termination attempt001 retains its report/sources/receipts and is not accepted; active002 governs the current termination claim.

Costs record exact real shared token events, elapsed intervals and observed tool receipts. The first main120second memory compilation timeout lost its GNU time CPU receipt; the full CPU total stays null, with the actually observed subtotal retained. Source support costs retain their original unmetered direct-diagnostic CPU/RSS caveat. Other missing samples and setup CPU/RSS remain unknown. No post-hoc per-problem split, resource estimate, or replay substitutes them. Raw telemetry terminology is preserved in machine receipts. See [costs](costs.json) and its shared metrics links.

| Artifact | SHA256 |
|---|---|
| prepared C | 0eeb6d11befeb4d75eced7835cf064e2dfc623d4fab3e5143f2ea11e1ecd01b1 |
| Source.v | d8802732ddf24834833b4d3df9871faea45246affc7d960142fdf89b8f4c8a88 |
| Execution.v | c081027fa57c4fa78d79b8a5cc257e07798490e4051c59d22d1506c1d63cf03c |
| manifest | 5582d2642d4ef936f5555c93dc9aeb14e2eeb105f090f3c019869639e4c98513 |
| canonical Spec.v | 3dabb879755e9af46fb020b5ef76039e0c3caae1c28fdc7f7696e0f95019d04a |
| active Proof.v | 40ee93bacad31ba6ea861e3079abcd41745b061ec916930461bdea9e44f4023a |
| explicit Contract.v | 40fa4992e99f42da1f50e5ce4264c03e1082b5115bdd8278c92bc1a936a109dd |

Exact printed declaration names for this certificate: `ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`. Print Assumptions stdout SHA256: 8290beab106b27981ae0b067e2c21578f87537e97260f9c6aed2218c575e1a64.
