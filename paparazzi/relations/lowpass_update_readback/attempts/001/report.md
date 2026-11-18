# Attempt001 — relation

Proved 2 exact requested goals: NormalCompletion, AllReturns. Pending: none.

Actual update Csem output memory mu feeds actual getter Csem input. Normal completion exists; all normal returns have equal binary32 bits, including NaNs. Both mu/mf store input bytes4..8 and returned result bytes8..12; time_const0..4 unchanged; getter preserves all mu-valid caller blocks, update preserves original-valid caller bytes outside4..12.

[Proof.v](Proof.v) SHA-256 `ac2583c71ca1a673f70492a66607ceb198f30e423aebe7c339b5f6c85b0ac0cd`. [Canonical specification](../../problem/Spec.v) SHA-256 `6813a394666eeeab1577c8703bb738b521c43c0e0d6d2f90e85063c44092e0de`. Actual imported source/model/specification identities and immutable physical snapshots are in [provenance.json](provenance.json) and [goal validation](evidence/goal-validation.json).

Requested and runtime-observed worker: `gpt-6.1-sol`, reasoning effort `medium`; actual filtered session receipt: `../../../../report/lowpass_update_readback/evidence/runtime-config.json`. This is current runtime metadata, not a relabeled historical model.

The deterministic typed GoalBinding certificate was compiled by actual command `166-lowpass_update_readback-goal-certificate` and independently kernel checked by `167-lowpass_update_readback-certificate-kernel` in `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq`. The same compile emitted Print Assumptions. Raw assumptions/compile stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/166-lowpass_update_readback-goal-certificate.stdout.log`; kernel stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/167-lowpass_update_readback-certificate-kernel.stdout.log`. Inherited assumptions are the printed CompCert/library classical and functional-extensionality assumptions, plus external/inline-assembly semantic parameters where imported. The source closure has no reachable external calls; no new axiom or admitted proof was introduced.

All model fields, exact source, target and byte semantics are bound by the evidence. Conclusions concern the pinned CompCert semantics and selected textual upstream function extraction; no GCC/native-hardware or universal cross-tool NaN-payload equivalence is claimed.

[Costs](costs.json) reference the shared real Rocq authoring/checking phase. Per-attempt model tokens/direct authoring wall are null because six questions share one actual boundary; no invented split. All failed development commands, including two terminated proof-search attempts and the obsolete19-row certificate failure, remain in the raw shared run and [development history](../../../../report/lowpass_update_readback/evidence/development-history.json). Current36-row certificate was rebuilt in a fresh immutable directory; the failed physical certificate was retained. Historical getter artifacts and costs remain unchanged.

