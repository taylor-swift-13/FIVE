# gh_set_omega

Verified original setter for all binary32 inputs and initialized writable original64-byte global state, including NaNs. All reachable-state no-error, all-successor termination, actual normal-return/state-update API and all15 actual CBMC property IDs proved.

[Proof report](rocq/report/report.md), [accepted gate](rocq/report/gate.json), [costs and recorded gap](rocq/report/costs.json).

Canonical questions and current proofs are under rocq/no_error, rocq/termination, rocq/cbmc_recheck, plus functional and execution support questions. Generated CompCert Source/Execution remain unchanged in align/model.
