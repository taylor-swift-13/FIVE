# CBMC: two nonzero control scenarios

Canonical harness is ready for direct replay. Matching diagnostic runs reported 122/122 SUCCESS per entry, including all fourteen assertion occurrences (the original seven properties in each branch) and all 108 automatic guards. This report does not yet claim a gate-ready canonical receipt.

Controls are v=(1,0), a=(2,0), dt=1/512 and inv_tau=2. Speed commands (1,+0) and (6,+0) produce unsaturated and saturated raw acceleration; accel commands (-0.0078125,-0) and (9.9921875,-0) match those raw bits. Position inputs remain arbitrary signed64 patterns subject the original safe-add guards; six unused float configuration fields remain arbitrary bit patterns, including NaNs. Every original postcondition and automatic guard is retained.

This is scenario-scoped BMC, not arbitrary-control BMC. The broad-control experiments are retained as timeouts. The execution models remain unrestricted, and full natural-domain Rocq safety, functional correctness and relation proofs remain mandatory. Source and the fixed integer-restoring binding are unchanged.
