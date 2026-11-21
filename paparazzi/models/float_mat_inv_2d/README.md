# float_mat_inv_2d

**Complete:** all five model questions closed, including every original CBMC property and exact counterexample observations.

Original Paparazzi 2D matrix inverse, commit abfee3dd56eeab12c528635504a429db3daf409a. The entry body is unchanged; fabs is explicitly bound to the supported compiler intrinsic in the same prepared C consumed by CBMC and CompCert. Return 0 means success, return 1 means rejection.

- [Preparation](prepare/handoff.json), [source and bindings](prepare/source/bindings.json), [costs](prepare/report/costs.json).
- [Traditional CBMC](cbmc/report/report.md), [all actual properties](cbmc/properties.json), [original failed traces](cbmc/counterexamples.json), [costs](cbmc/report/costs.json).
- [Unrestricted Csyntax/Cexec model](align/model/compcert-manifest.json), [all-property mapping](align/spec-map.json), [costs](align/report/costs.json).
- [Complete Rocq model acceptance](rocq/report/report.md), [all-property recheck](rocq/spec-recheck.json), [costs](rocq/report/costs.json).
- [Cross-model numerical relation](../../relations/matrix_inverse_scale/README.md) compares scale sensitivity and residuals with the ideal inverse.

The two failed numerical assertions are refutations, never program correctness. Full execution semantics retain all arguments, aliases and memories; proof preconditions apply to the selected goals only. Original-libm implementation equivalence and the source/frontend boundary remain explicit. Stage costs use measured shared scopes without invented per-case splits.

Questions live in `rocq/<name>/problem/Spec.v`; checked proofs and readable reports live in `rocq/<name>/attempts/<number>/`. The export files under `align/model/proof/` are frozen generation-time declarations. Current proof status is recorded in [rocq/handoff.json](rocq/handoff.json).
