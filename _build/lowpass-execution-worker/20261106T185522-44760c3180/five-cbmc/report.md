# five-cbmc / 20261106T185522-44760c3180

Verification: blocked

Guarded arithmetic CBC remains unresolved despite exact refinement/CaDiCaL/Z3, native-FP and exact solve-eqs tactics. Reset27 succeeded. No concrete original-C counterexample inferred. Root explicitly authorizes next CBC scope: full safety/copy/frame/reset assertions; exact all-input coefficient arithmetic is independently proved in Rocq, not claimed checked by CBC. All attempts and formulas preserved.

Wall time: 1731.903872 s

CPU tool time: None s

Observed tool-tree RSS peak: 295948288 bytes

Model tokens: available; total=12004841

Measurement completeness: partial

run.json contains scope, input/output hashes, commands, token evidence and remaining obligations. metrics.json contains resource measurements and their limits.

Cost evidence audit: incomplete

- Missing CPU/RSS receipt: 005-update_first_order_low_pass_tau-formal-exact-refinement

- Missing CPU/RSS receipt: 007-init_first_order_low_pass-formal-exact-refinement

- Missing CPU/RSS receipt: 008-update_first_order_low_pass_tau-formal-native-fp-approved-observation

- Missing CPU/RSS receipt: 009-init_first_order_low_pass-formal-native-fp-approved-observation

- Missing CPU/RSS receipt: 011-update_first_order_low_pass_tau-formal-exact-cadical

- Missing CPU/RSS receipt: 013-update_first_order_low_pass_tau-formal-exact-z3-bitvectors

- Missing/mismatched tool CPU total

- Measurements are marked partial
