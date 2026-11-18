# Attempt001 — execution_correspondence

Proved 8 exact requested goals: domain_preservation_goal, floating_point_correspondence_goal, machine_integer_correspondence_goal, memory_access_correspondence_goal, control_and_exhaustion_correspondence_goal, normal_result_and_memory_correspondence_goal, invalid_operation_correspondence_goal, whole_execution_correspondence_goal. Pending: none.

Eight unrestricted Csem/Cexec correspondence obligations: arbitrary machine arguments/memory, all reachable states, exact traces, values, bytes, errors and successor relation. No domain restriction.

[Proof.v](Proof.v) SHA-256 `baec52d89eea6c78ad438e724e5243188c7c28b00156d55821bd782285e6415c`. [Canonical specification](../../problem/Spec.v) SHA-256 `6c7115572420d1a1981f739097540446481c5eb179335c5959287903bb863226`. Actual imported source/model/specification identities and immutable physical snapshots are in [provenance.json](provenance.json) and [goal validation](evidence/goal-validation.json).

Requested and runtime-observed worker: `gpt-6.1-sol`, reasoning effort `medium`; actual filtered session receipt: `../../../../../../report/lowpass_update_readback/evidence/runtime-config.json`. This is current runtime metadata, not a relabeled historical model.

The deterministic typed GoalBinding certificate was compiled by actual command `114-update_first_order_low_pass-goal-certificate` and independently kernel checked by `115-update_first_order_low_pass-certificate-kernel` in `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq`. The same compile emitted Print Assumptions. Raw assumptions/compile stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/114-update_first_order_low_pass-goal-certificate.stdout.log`; kernel stdout: `_build/lowpass-update-readback/20261107T060803-fdf5b7a9fd/five-rocq/logs/115-update_first_order_low_pass-certificate-kernel.stdout.log`. Inherited assumptions are the printed CompCert/library classical and functional-extensionality assumptions, plus external/inline-assembly semantic parameters where imported. The source closure has no reachable external calls; no new axiom or admitted proof was introduced.

All model fields, exact source, target and byte semantics are bound by the evidence. Conclusions concern the pinned CompCert semantics and selected textual upstream function extraction; no GCC/native-hardware or universal cross-tool NaN-payload equivalence is claimed.

[Costs](costs.json) reference the shared real Rocq authoring/checking phase. Per-attempt model tokens/direct authoring wall are null because six questions share one actual boundary; no invented split. All failed development commands, including two terminated proof-search attempts and the obsolete19-row certificate failure, remain in the raw shared run and [development history](../../../../../../report/lowpass_update_readback/evidence/development-history.json). Current36-row certificate was rebuilt in a fresh immutable directory; the failed physical certificate was retained. Historical getter artifacts and costs remain unchanged.

