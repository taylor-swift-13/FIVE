# Update verification

All five requested problems are proved: no_error1, termination1, functional3 (including Nonvacuity), execution_correspondence8 and actual CBMC recheck36, total49 exact typed goals. Every question has canonical problem/Spec.v and active attempts/001/Proof.v, immutable dependency snapshots, Print Assumptions, independent kernel receipt and exact typed goal bindings. The actual update/get relation separately proves2 goals.

Safety requires Initialized writable12/readable typed tc/li/lo; model and correspondence remain unrestricted. All binary32 inputs including NaNs/infinities are allowed, with no nonzero-denominator assumption. Exact expression order is retained. See each problem report and spec-recheck.json. Costs are shared observed-phase evidence, with failed commands retained; no old getter cost is reallocated.


Observed phase resources and audit limitations: [costs.json](costs.json). Metrics are recorded values; unknown per-command RSS remains null, and raw audit status is preserved. Historical getter expenses are excluded.
