# update_first_order_low_pass_tau: Rocq evidence

All five canonical questions are proved under their stated scopes: no-error1, functional3, termination1, execution correspondence8, plus 19 independent actual CBC property rechecks. The three cases jointly cover all24 raw execution correspondence goals and the final77 actual CBC IDs (31/19/27).

| Problem | Canonical question | Current proof | Requested goals |
|---|---|---|---|
| no_error | [question](../no_error/problem/Spec.v) | [active proof report](../no_error/attempts/001/report.md) | 1 |
| functional | [question](../functional/problem/Spec.v) | [active proof report](../functional/attempts/001/report.md) | 3 |
| termination | [question](../termination/problem/Spec.v) | [active proof report](../termination/attempts/002/report.md) | 1 |
| execution_correspondence | [question](../execution_correspondence/problem/Spec.v) | [active proof report](../execution_correspondence/attempts/001/report.md) | 8 |
| cbmc_recheck | [question](../cbmc_recheck/problem/Spec.v) | [active proof report](../cbmc_recheck/attempts/002/report.md) | 19 |

For every float32 tau,h and writable12 caller object, a normal Csem return exists and every normal return is Vundef with the first four bytes equal to encode_val Mfloat32 of coefficient=(2.0f*tau)/h in source operation order. All Mem.loadbytes observations outside those first four bytes on initially valid blocks are unchanged, including both previous fields even when their bytes are unknown.

writable12 means four-byte alignment of Ptrofs.unsigned p, p+12 within the pointer modulus without wrapping, and current Writable permission across all twelve bytes. The safety precondition additionally fixes the typed pointer/float argument list. It requires no initialized old field, finite value, nonNaN value or nonzero sample time. Unknown memvals remain unknown in frame observations.

Safety quantifies every reachable original Csem state under the typed/writable precondition. Termination is Acc for every successor for all raw argument lists and arbitrary memory. Functional questions separately establish existence, all normal returns and a nonempty precondition. Raw Cexec/Csem correspondence retains all operations, traces, values, byte changes and error prefixes without cutting down the input/memory model.

Final CBC scope is all original source/memcpy safety guards and complete binary32-bit init value copies, retune frame fields and reset return/copies/frame. CBC does not claim coefficient arithmetic equality; all original/guarded arithmetic CBC attempts remain unresolved history. The unrestricted exact original-model coefficient theorem is independently established in the functional proof above. Each of the 19 actual CBC IDs has its own canonical Rocq recheck goal; CBC results are not axioms.

Target: CompCert 3.17 original Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32 nearest ties-to-even and manifest-bound CompCert/Archi NaN policy. C frontend/source export and inherited library semantics remain the trusted boundary. No GCC, native-hardware, or cross-tool NaN-payload equivalence is claimed.

The actual theorem-specific Print Assumptions output is retained in the bound compile and GoalBinding stdout logs. Across these dependencies, printed inherited declarations include ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. SourceGuards receipts additionally expose CompCert external_functions_sem and inline_assembly_sem semantic parameters; inspect each theorem receipt for its exact subset. No new goal axiom or admitted proof is introduced.

Prior main run184407-e47c999b12 contains real memory-proof development and invalid nested termination command indices; main run190518-8d27304b10 contains real mathematical work but invalid physical captures caused by basename collisions. Both remain CLOSED failed and are not accepted proof evidence. Current fresh run192316-c89d343f94 binds independently checked exact source snapshots, physical copies and typed GoalBinding certificates. Correction run190222-912614879e and physical-copy preflight191900-099f8ec038 remain separate successful evidence. Historical termination attempt001 retains its report/sources/receipts and is not accepted; active002 governs the current termination claim.

Costs record exact real shared token events, elapsed intervals and observed tool receipts. The first main120second memory compilation timeout lost its GNU time CPU receipt; the full CPU total stays null, with the actually observed subtotal retained. Source support costs retain their original unmetered direct-diagnostic CPU/RSS caveat. Other missing samples and setup CPU/RSS remain unknown. No post-hoc per-problem split, resource estimate, or replay substitutes them. Raw telemetry terminology is preserved in machine receipts.

[Shared actual source-proof support costs](../../../../report/lowpass_recovery/support/retune_reset/costs.json); [stage cost references](costs.json); [conditional cross-model relation](../../../../relations/lowpass_recovery/problem/Spec.v).
