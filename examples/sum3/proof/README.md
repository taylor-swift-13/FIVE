# Rocq goals and proofs

`Precondition.v` states the three-binary32 calling condition; `Obligations.v` states the no-error and termination goals. `NoError.v` and `Core.v` establish absence of error in all reachable states under the calling condition, with arbitrary initial CompCert memory. `Functional.v` proves the concrete pure Float32 calculation has zero result bits. `Proofs.v` imports the retained no-error proof; `build.py` is the archived rebuild script. `spec-recheck.json` records that the Csem return/CBMC byte-observation correspondence has not yet been proved. The termination goal is pending.

The compile log contains `Print Assumptions` output and the separate `rocq check` run is archived under [`../report/evidence/kernel/`](../report/evidence/kernel/). Proof and independent kernel-check costs are in [`../report/costs.json`](../report/costs.json), stage `five-rocq`.
