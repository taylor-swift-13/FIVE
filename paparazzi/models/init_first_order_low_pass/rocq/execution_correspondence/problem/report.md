# init_first_order_low_pass: raw execution correspondence

All eight goals in [Spec.v](Spec.v) quantify every raw argument list and arbitrary CompCert memory. The [current proof](../attempts/001/Proof.v) relates original Csem execution to the generated raw Cexec transition list. No pointer-validity, initialization, finite-value or argument-typing precondition narrows the domain.

Bidirectional reachable-step and whole finite-trace equivalence preserves every evaluation order, original operations, trace and final state. Normal returns preserve exact values and memory; observation is little-endian target Mem.loadbytes with unknown memvals retained. Invalid-operation equivalence concerns every reached state with no legal successor, including write prefixes. Fuel exhaustion is absent. These goals establish correspondence, not safety or termination of the C program.

The source-only invariant rules out callbacks, assembly, volatile and I/O in reachable code. Generic checked support is read only. Target: CompCert 3.17 x86-64 standard ABI Linux, binary32 nearest ties-to-even, recorded CompCert NaN policy. The frontend and inherited CompCert/Flocq assumptions remain the trust boundary; GCC/native-hardware equivalence is outside scope.
