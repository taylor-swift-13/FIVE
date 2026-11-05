# sum2_sum3 attempt 001

Proved `composition_bits : Sum2EqualsSum3` against the unchanged `problem/Spec.v`. The theorem takes three actual CompCert Csem normal-return executions: sum2(a,b), sum2(ab,c), and sum3(a,b,c), and proves equality of returned binary32 bits. It quantifies over all six binary32 values and all five memories; no additional numeric or memory precondition was added. This conditional relation does not itself assert termination or safety.

The proof derives each actual execution return from checked source invariants, semantic preservation and parameter allocation/store/free proofs. The shared sum3 support was snapshotted here; sum2 support is the explicit two-parameter adaptation stored here. The old attempt was used as source material and rebuilt on current models. No old compiled artifacts are imported.

`check.py` copied the current source models and unchanged Spec into a fresh temporary directory, compiled all support and proof modules, printed assumptions for both return lemmas and `composition_bits`, then independently ran `rocq check -silent FiveExampleRelation.Proof`; exit 0. The compile/check command took 57.0304623109987 seconds. No admitted proof or newly declared axiom is present.

Inherited assumptions printed for composition_bits: ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, Events.inline_assembly_sem, FunctionalExtensionality.functional_extensionality_dep, Events.external_functions_sem, Classical_Prop.classic. These are inherited library assumptions; the modeled functions have no external calls. The trust boundary remains CompCert 3.17 Csem and the frozen source/model frontend, not a hardware or separately compiled binary equivalence claim.

Both actual model configurations are recorded in full in `provenance.json`, including source/model/Spec/proof SHA256, target, nan-policy semantic dependency hashes, frontend options and empty external bindings. All model manifest file hashes and semantic dependency hashes were checked and matched. Target: x86-64 standard ABI, Linux, little endian, IEEE754 binary32, round-to-nearest ties-to-even. Tool version is in the run tool-version stdout log.

Agent runtime: gpt-6.1-sol, requested medium, actual medium (own turn_context). Session: 01a1aba4-d7a6-7e82-9f3d-de383be88529. Only usage receipts and selected runtime configuration fields are archived, not full conversation content.

Costs: [costs.json](costs.json), schema five-stage-costs/1, separates the measured run from actual own-session setup/reporting usage outside its boundary. Unmeasured setup/reporting wall, CPU and RSS are null. Cache/reasoning are subsets, not added twice. RSS samples are tool process-tree observations at requested 10 ms intervals, may double-count shared pages and miss short peaks, and exclude model-server/desktop memory. No parent-session tokens are used.

Measured run: evidence

Measured wall 188.83438849449158 s; tool CPU 57.01 s; observed tool-tree RSS peak 1403334656 bytes. Measured run tokens 657406; setup 216785; reporting 190741.

Cost audit exit 0; evidence: evidence/logs/003-audit-costs.stdout.log. Proof evidence: evidence/logs/001-relation-compile-kernel.stdout.log.

All run metadata, raw usage receipts, selected runtime configuration, compile/check logs, GNU time logs, metrics, and audit output are archived in [evidence](evidence/); _build is not the sole evidence copy.
