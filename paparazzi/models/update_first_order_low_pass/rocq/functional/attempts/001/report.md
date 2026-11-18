# Attempt001 — functional

Proved 3 exact requested goals: NormalCompletion, AllReturns, Nonvacuity. Pending: none.

Normal Csem completion, exact original-tree binary32 result, last_in=input bytes, last_out=returned output bytes, preserved time_const and old-valid caller frame outside4..12. All normal returns satisfy the same postcondition. Explicit Nonvacuity constructs initialized memory for every tc/li/lo binary32 triple.

[Proof.v](Proof.v) SHA-256 `e7341a6f1b81e117a3e7d4bd928db5e66c7f2e6b1382a50f360354432cfc798f`. [Canonical specification](../../problem/Spec.v) SHA-256 `9623b37504830ef2a2718b22d8340235124025368a828976a21feb983d8eb39d`. Actual imported source/model/specification identities and immutable physical snapshots are in [provenance.json](provenance.json) and [goal validation](evidence/goal-validation.json).

Requested and runtime-observed worker: `gpt-6.1-sol`, reasoning effort `medium`; actual filtered session receipt: `../../../../../../report/lowpass_update_readback/evidence/runtime-config.json`. This is current runtime metadata, not a relabeled historical model.

The deterministic typed GoalBinding certificate was compiled by actual command `108-update_first_order_low_pass-goal-certificate` and independently kernel checked by `109-update_first_order_low_pass-certificate-kernel` in `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq`. The same compile emitted Print Assumptions. Raw assumptions/compile stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/108-update_first_order_low_pass-goal-certificate.stdout.log`; kernel stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/109-update_first_order_low_pass-certificate-kernel.stdout.log`. Inherited assumptions are the printed CompCert/library classical and functional-extensionality assumptions, plus external/inline-assembly semantic parameters where imported. The source closure has no reachable external calls; no new axiom or admitted proof was introduced.

All model fields, exact source, target and byte semantics are bound by the evidence. Conclusions concern the pinned CompCert semantics and selected textual upstream function extraction; no GCC/native-hardware or universal cross-tool NaN-payload equivalence is claimed.

[Costs](costs.json) reference the shared real Rocq authoring/checking phase. Per-attempt model tokens/direct authoring wall are null because six questions share one actual boundary; no invented split. All failed development commands, including two terminated proof-search attempts and the obsolete19-row certificate failure, remain in the raw shared run and [development history](../../../../../../report/lowpass_update_readback/evidence/development-history.json). Current36-row certificate was rebuilt in a fresh immutable directory; the failed physical certificate was retained. Historical getter artifacts and costs remain unchanged.

