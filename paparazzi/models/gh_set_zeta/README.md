# gh_set_zeta

Verified the unchanged pinned setter over all binary32 parameter and initialized named-state field bit patterns, including NaNs, with a valid writable original64byte global object.

- [No-error question](rocq/no_error/problem/Spec.v): all reachable original Csem states.
- [Termination question](rocq/termination/problem/Spec.v): Acc over every successor.
- [Functional question](rocq/functional/problem/Spec.v): actual normal return existence and every return preserves the precise updated state.
- [CBMC recheck question](rocq/cbmc_recheck/problem/Spec.v): all3actual emitted scalar/union properties.
- [Execution question](rocq/execution_correspondence/problem/Spec.v): all8unrestricted Csyntax/Cexec correspondence obligations.

All current attempt001proofs include exact compiled snapshots, expected-type GoalBinding certificates, Print Assumptions and independent kernel checks. [Gate](rocq/report/evidence/final-gate.json) accepted; [full artifact validation](rocq/report/evidence/final-artifact-validation.json) passed. [Summary](rocq/report/report.md), [costs](rocq/report/costs.json).

Pinned CompCert3.17 x86-64 Linux little endian binary32 semantics, inherited library assumptions and frontend trust apply. Named scalar observations exclude padding; no universal cross-tool NaN-payload/GCC/hardware equivalence is claimed. Initial historical CBMC timeout CPU remains unobserved and null; successful current stage cost audits are retained separately.
