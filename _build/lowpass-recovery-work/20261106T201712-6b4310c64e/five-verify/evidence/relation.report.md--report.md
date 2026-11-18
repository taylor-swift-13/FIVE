# lowpass_recovery: relation current proof

Proved requested goals: NormalCompletion, AllNormalResults, Nonvacuity.

For arbitrary tau,h,value and two independent writable12 caller objects/memories, retune followed by reset and direct init both have normal completions. Every pair of normal executions has exact return values (Vundef,Vsingle value,Vundef), identical twelve-byte encode_val coefficient/value/value observations, preserved writable objects and unchanged Mem.loadbytes frames outside each twelve-byte caller region on initially valid blocks. Nonvacuity constructs distinct blocks with writable objects. Coefficient arithmetic retains all float32 inputs and the fixed CompCert NaN policy.

writable12 means four-byte alignment of Ptrofs.unsigned p, p+12 within the pointer modulus without wrapping, and current Writable permission across all twelve bytes. The safety precondition additionally fixes the typed pointer/float argument list. It requires no initialized old field, finite value, nonNaN value or nonzero sample time. Unknown memvals remain unknown in frame observations.

Target: CompCert 3.17 original Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32 nearest ties-to-even and manifest-bound CompCert/Archi NaN policy. C frontend/source export and inherited library semantics remain the trusted boundary. No GCC, native-hardware, or cross-tool NaN-payload equivalence is claimed.

Canonical question: [Spec.v](../../problem/Spec.v); checked proof: [Proof.v](Proof.v); reproducible cold checker: [check.py](check.py). Default check.py rebuilds the full source dependency closure in an empty temporary directory and performs independent kernel checking; no repository .vo cache supplies proof dependencies.

[Current exact theorem/type and physical-snapshot bindings](evidence/goal-validation.json); [independent kernel evidence](evidence/kernel-evidence.json); [typed GoalBinding Print Assumptions output](../../../../../_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq/logs/221-init_first_order_low_pass-goal-certificate.stdout.log). Actual direct compile/kernel command IDs are in these receipts.

Actual worker runtime: gpt-6.1-sol, requested and observed medium, [whitelisted actual configuration receipt](../../../../../_build/lowpass-execution-worker/20261106T193120-c7e2b81a18/five-rocq/evidence/main-runtime-20261106T192316-c89d343f94.json).

The actual theorem-specific Print Assumptions output is retained in the bound compile and GoalBinding stdout logs. Across these dependencies, printed inherited declarations include ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. SourceGuards receipts additionally expose CompCert external_functions_sem and inline_assembly_sem semantic parameters; inspect each theorem receipt for its exact subset. No new goal axiom or admitted proof is introduced.

Prior main run184407-e47c999b12 contains real memory-proof development and invalid nested termination command indices; main run190518-8d27304b10 contains real mathematical work but invalid physical captures caused by basename collisions. Both remain CLOSED failed and are not accepted proof evidence. Current fresh run192316-c89d343f94 binds independently checked exact source snapshots, physical copies and typed GoalBinding certificates. Correction run190222-912614879e and physical-copy preflight191900-099f8ec038 remain separate successful evidence. Historical termination attempt001 retains its report/sources/receipts and is not accepted; active002 governs the current termination claim.

Costs record exact real shared token events, elapsed intervals and observed tool receipts. The first main120second memory compilation timeout lost its GNU time CPU receipt; the full CPU total stays null, with the actually observed subtotal retained. Source support costs retain their original unmetered direct-diagnostic CPU/RSS caveat. Other missing samples and setup CPU/RSS remain unknown. No post-hoc per-problem split, resource estimate, or replay substitutes them. Raw telemetry terminology is preserved in machine receipts. See [costs](costs.json) and its shared metrics links.

Participating model/source hashes:

**init_first_order_low_pass**

| Artifact | SHA256 |
|---|---|
| prepared C | 4cdaf8372b15974ed7ed74f68f1c5be86fa20981f51e42ead9078509e90cbaed |
| Source.v | fdc17c1b261057faf36f61333ebded9fa4d0d7f93101c4035c882021e94ba61f |
| Execution.v | f44e1110996318d812d17cffa56ccac19188892e6c6b0854035b8a0f1824007f |
| manifest | 52c768cfdefd28ec2fb71293a047bba2a8ca67c49a3492bb480f175b656bceed |
| canonical Spec.v | a67098be9664389315263a64d1e04d23afd944b42edc4c2939b0886f205da32c |
| active Proof.v | f982b067fd925d9dcbcaf087c415923efa024ddcce18ac7b293582e4e613341e |
| explicit Contract.v | b7aec65bbc710f190c5f9c1cb289f7d3b54f9855ec6f0aac59668d600f9bc82a |

**update_first_order_low_pass_tau**

| Artifact | SHA256 |
|---|---|
| prepared C | ad38d2f64834cdaa80f95a5e670862d60be3a1b6fae57fa4838991b844f81ccd |
| Source.v | 4938088257ba8ab0fbbf4dc9757cdd8a318c1fff180449b95bf73b9af88bd6ee |
| Execution.v | 2b20e2802a9f01dfe9806082b43d980415c6748f0681ef1fda6eacaec2201797 |
| manifest | c3647b48f21fbf2aa91240899765c56a659d33949e192569334a3c8ec137c107 |
| canonical Spec.v | a67098be9664389315263a64d1e04d23afd944b42edc4c2939b0886f205da32c |
| active Proof.v | f982b067fd925d9dcbcaf087c415923efa024ddcce18ac7b293582e4e613341e |
| explicit Contract.v | d36d6378c2c8306321a49ccc20e1ed3676c0381f491a09cecc2ed21ea56b9025 |

**reset_first_order_low_pass**

| Artifact | SHA256 |
|---|---|
| prepared C | 0eeb6d11befeb4d75eced7835cf064e2dfc623d4fab3e5143f2ea11e1ecd01b1 |
| Source.v | d8802732ddf24834833b4d3df9871faea45246affc7d960142fdf89b8f4c8a88 |
| Execution.v | c081027fa57c4fa78d79b8a5cc257e07798490e4051c59d22d1506c1d63cf03c |
| manifest | 5582d2642d4ef936f5555c93dc9aeb14e2eeb105f090f3c019869639e4c98513 |
| canonical Spec.v | a67098be9664389315263a64d1e04d23afd944b42edc4c2939b0886f205da32c |
| active Proof.v | f982b067fd925d9dcbcaf087c415923efa024ddcce18ac7b293582e4e613341e |
| explicit Contract.v | 40fa4992e99f42da1f50e5ce4264c03e1082b5115bdd8278c92bc1a936a109dd |

Exact printed declaration names for this certificate: `ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`. Print Assumptions stdout SHA256: 6993ef9ebb6ea127937aacf67328a2a87072b94b86edc4ad441dc6561f801fb6.
