# gh_update_ref_from_accel_sp: execution_correspondence

Proved for the frozen CompCert 3.17 x86-64 little-endian Csyntax/Csem model with the explicit integer-restoring five_sqrtf C binding. Specification: Spec.v; current attempt: ../attempts/001.

Domain: every CompCert list val argument list and every CompCert mem, including malformed, invalid and uninitialized inputs. No numerical or memory precondition narrows this domain. The source/model graph retains errors. Termination means Acc for every original Csem successor; execution correspondence preserves all evaluation orders, operations, errors, returned values and exact memory.

This problem does not assert no-error or the high-level guidance numerical update specification. C frontend provenance and inherited CompCert/Flocq classical and external-semantic declarations remain the documented boundary.

The proof imports FiveGuidanceSemantics.AccelSource. Exact current inputs, compiled snapshots, theorem-to-type GoalBinding.v, Print Assumptions, and independent kernel commands are recorded in evidence/goal-validation.json and provenance.json by check.py.

Actual runtime: gpt-6.1-sol, medium, actor /root/guidance_mode_complete_medium/guidance_semantics; runtime receipt is the shared run log collect-actual-model-receipt. Shared development run: _build/guidance-mode-semantics/20261106T111233-1d5cf4386d/five-rocq. Failures, timeouts and superseded source development remain in that run; these costs are not allocated inventively among the four attempts.

Pinned installed CompCert .v/.vo hashes: _build/guidance-mode-semantics/20261106T111233-1d5cf4386d/five-rocq/evidence/semantic-dependencies.json. All current exact theorem bindings and independent checks passed.

Cost audit: measured model tokens, wall time and sampled tool RSS are retained. Historical GNU time CPU/RSS receipts are unavailable for seven recorded development timeouts because the telemetry timeout killed the process group including GNU time. The final tool CPU total remains null and measurement status partial; no replay or invented value replaces those observations. See the shared run cost_audit and explicit-final-cost-audit log. Proof and strict artifact validations passed independently.
