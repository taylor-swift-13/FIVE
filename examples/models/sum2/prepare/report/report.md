# Prepare sum2

Current preparation is complete. [Frozen source](../source/sum2.c), [bindings](../source/bindings.json) and [verification request](../verification-request.json) remain byte-identical. Entry `float sum2(float,float)` has no callees, required headers, globals or external bindings. Target: CompCert Csem/Cexec, x86-64 Linux, little endian, binary32 nearest ties to even.

A new measured GPT-6.1 Sol medium preparation independently reconstructed the C and bindings from the available frozen case seed, copied the existing verification request, compared every output byte, and passed C11 syntax and dependency checks. [Preparation receipt](evidence/current-preparation/evidence/preparation--receipt.json), [reconstruction script](evidence/current-preparation/reconstruct.py), [actual run](evidence/current-preparation/run.json), [runtime configuration](evidence/current-preparation/runtime-config.json), [cost audit](evidence/current-preparation/cost-audit.json).

[Costs](costs.json) distinguish the new observed preparation from historical unmeasured construction. The new measurement does not recover that historical expense. Upstream source provenance beyond the available frozen case seed is unavailable; no extraction equivalence or binary/hardware claim is inferred from a syntax check.
