# Attempt001 — termination

Proved 1 exact requested goals: AllSuccessorsTerminate. Pending: none.

Acc over every original Csem successor for every machine argument list and memory, including states outside the safety precondition. No fixed execution bound.

[Proof.v](Proof.v) SHA-256 `b703bc2a8d0f1628a38b67103a4bbba9eb103f8af5b9ee59da137d98c72cf529`. [Canonical specification](../../problem/Spec.v) SHA-256 `ced7bd83eacc7ffb93f8817824b5222d64c022aa68ee64808d9bf0bdad07f812`. Actual imported source/model/specification identities and immutable physical snapshots are in [provenance.json](provenance.json) and [goal validation](evidence/goal-validation.json).

Requested and runtime-observed worker: `gpt-6.1-sol`, reasoning effort `medium`; actual filtered session receipt: `../../../../../../report/lowpass_update_readback/evidence/runtime-config.json`. This is current runtime metadata, not a relabeled historical model.

The deterministic typed GoalBinding certificate was compiled by actual command `103-update_first_order_low_pass-goal-certificate` and independently kernel checked by `104-update_first_order_low_pass-certificate-kernel` in `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq`. The same compile emitted Print Assumptions. Raw assumptions/compile stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/103-update_first_order_low_pass-goal-certificate.stdout.log`; kernel stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/104-update_first_order_low_pass-certificate-kernel.stdout.log`. Inherited assumptions are the printed CompCert/library classical and functional-extensionality assumptions, plus external/inline-assembly semantic parameters where imported. The source closure has no reachable external calls; no new axiom or admitted proof was introduced.

All model fields, exact source, target and byte semantics are bound by the evidence. Conclusions concern the pinned CompCert semantics and selected textual upstream function extraction; no GCC/native-hardware or universal cross-tool NaN-payload equivalence is claimed.

[Costs](costs.json) reference the shared real Rocq authoring/checking phase. Per-attempt model tokens/direct authoring wall are null because six questions share one actual boundary; no invented split. All failed development commands, including two terminated proof-search attempts and the obsolete19-row certificate failure, remain in the raw shared run and [development history](../../../../../../report/lowpass_update_readback/evidence/development-history.json). Current36-row certificate was rebuilt in a fresh immutable directory; the failed physical certificate was retained. Historical getter artifacts and costs remain unchanged.

