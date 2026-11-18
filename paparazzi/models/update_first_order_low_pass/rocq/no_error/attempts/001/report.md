# Attempt001 — no_error

Proved 1 exact requested goals: NoError. Pending: none.

Every state reachable by original Csem is safe under Initialized: an aligned nonwrapping writable12-byte caller object with typed binary32 loads at0/4/8. No finite, non-NaN or nonzero-denominator restriction.

[Proof.v](Proof.v) SHA-256 `f656b4682b7483e8edbdd2062c9639f3bb771e899d3a3188a0b855c6a23d7e28`. [Canonical specification](../../problem/Spec.v) SHA-256 `389ade7c6abc7e8f1d5860d1976d0b2254e1f2646a01b3a48dd9f88bcdb04bec`. Actual imported source/model/specification identities and immutable physical snapshots are in [provenance.json](provenance.json) and [goal validation](evidence/goal-validation.json).

Requested and runtime-observed worker: `gpt-6.1-sol`, reasoning effort `medium`; actual filtered session receipt: `../../../../../../report/lowpass_update_readback/evidence/runtime-config.json`. This is current runtime metadata, not a relabeled historical model.

The deterministic typed GoalBinding certificate was compiled by actual command `099-update_first_order_low_pass-goal-certificate` and independently kernel checked by `100-update_first_order_low_pass-certificate-kernel` in `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq`. The same compile emitted Print Assumptions. Raw assumptions/compile stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/099-update_first_order_low_pass-goal-certificate.stdout.log`; kernel stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/100-update_first_order_low_pass-certificate-kernel.stdout.log`. Inherited assumptions are the printed CompCert/library classical and functional-extensionality assumptions, plus external/inline-assembly semantic parameters where imported. The source closure has no reachable external calls; no new axiom or admitted proof was introduced.

All model fields, exact source, target and byte semantics are bound by the evidence. Conclusions concern the pinned CompCert semantics and selected textual upstream function extraction; no GCC/native-hardware or universal cross-tool NaN-payload equivalence is claimed.

[Costs](costs.json) reference the shared real Rocq authoring/checking phase. Per-attempt model tokens/direct authoring wall are null because six questions share one actual boundary; no invented split. All failed development commands, including two terminated proof-search attempts and the obsolete19-row certificate failure, remain in the raw shared run and [development history](../../../../../../report/lowpass_update_readback/evidence/development-history.json). Current36-row certificate was rebuilt in a fresh immutable directory; the failed physical certificate was retained. Historical getter artifacts and costs remain unchanged.

