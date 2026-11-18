# init_first_order_low_pass: termination current proof

Proved requested goals: AllSuccessorsTerminate.

For every raw list val argument list and arbitrary CompCert memory, including malformed calls and invalid or uninitialized states, Acc(successor Execution.ge)(Execution.entry args m) holds. This covers every original Csem successor and evaluation order, with no fuel or fixed step bound. Safety is separately established under its explicit precondition.

Target: CompCert 3.17 original Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32 nearest ties-to-even and manifest-bound CompCert/Archi NaN policy. C frontend/source export and inherited library semantics remain the trusted boundary. No GCC, native-hardware, or cross-tool NaN-payload equivalence is claimed.

Canonical question: [Spec.v](../../problem/Spec.v); checked proof: [Proof.v](Proof.v); reproducible cold checker: [check.py](check.py). Default check.py rebuilds the full source dependency closure in an empty temporary directory and performs independent kernel checking; no repository .vo cache supplies proof dependencies.

[Current exact theorem/type and physical-snapshot bindings](evidence/goal-validation.json); [independent kernel evidence](evidence/kernel-evidence.json); [typed GoalBinding Print Assumptions output](../../../../../../../_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq/logs/063-init_first_order_low_pass-goal-certificate.stdout.log). Actual direct compile/kernel command IDs are in these receipts.

Actual worker runtime: gpt-6.1-sol, requested and observed medium, [whitelisted actual configuration receipt](../../../../../../../_build/lowpass-execution-worker/20261106T193120-c7e2b81a18/five-rocq/evidence/main-runtime-20261106T192316-c89d343f94.json).

The actual theorem-specific Print Assumptions output is retained in the bound compile and GoalBinding stdout logs. Across these dependencies, printed inherited declarations include ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. SourceGuards receipts additionally expose CompCert external_functions_sem and inline_assembly_sem semantic parameters; inspect each theorem receipt for its exact subset. No new goal axiom or admitted proof is introduced.

Prior main run184407-e47c999b12 contains real memory-proof development and invalid nested termination command indices; main run190518-8d27304b10 contains real mathematical work but invalid physical captures caused by basename collisions. Both remain CLOSED failed and are not accepted proof evidence. Current fresh run192316-c89d343f94 binds independently checked exact source snapshots, physical copies and typed GoalBinding certificates. Correction run190222-912614879e and physical-copy preflight191900-099f8ec038 remain separate successful evidence. Historical termination attempt001 retains its report/sources/receipts and is not accepted; active002 governs the current termination claim.

Costs record exact real shared token events, elapsed intervals and observed tool receipts. The first main120second memory compilation timeout lost its GNU time CPU receipt; the full CPU total stays null, with the actually observed subtotal retained. Source support costs retain their original unmetered direct-diagnostic CPU/RSS caveat. Other missing samples and setup CPU/RSS remain unknown. No post-hoc per-problem split, resource estimate, or replay substitutes them. Raw telemetry terminology is preserved in machine receipts. See [costs](costs.json) and its shared metrics links.

| Artifact | SHA256 |
|---|---|
| prepared C | 4cdaf8372b15974ed7ed74f68f1c5be86fa20981f51e42ead9078509e90cbaed |
| Source.v | fdc17c1b261057faf36f61333ebded9fa4d0d7f93101c4035c882021e94ba61f |
| Execution.v | f44e1110996318d812d17cffa56ccac19188892e6c6b0854035b8a0f1824007f |
| manifest | 52c768cfdefd28ec2fb71293a047bba2a8ca67c49a3492bb480f175b656bceed |
| canonical Spec.v | 9fb9a840bc11a8f62073b60c7da3c1468acbf8ef0478fe89fc086bbcf5a26214 |
| active Proof.v | 56d71b1e3bd0243148f80808f5405d9c81e0da09301921e32aa2a24420610246 |
| explicit Contract.v | b7aec65bbc710f190c5f9c1cb289f7d3b54f9855ec6f0aac59668d600f9bc82a |

Exact printed declaration names for this certificate: `ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`. Print Assumptions stdout SHA256: 8290beab106b27981ae0b067e2c21578f87537e97260f9c6aed2218c575e1a64.
