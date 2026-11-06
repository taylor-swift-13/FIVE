# cbmc_recheck

Canonical question: Spec.v. Actual original CompCert x86-64 Linux Csem/Cexec, little endian binary32, all NaNs/infinities/signed zeros retained. Caller precondition names a full initialized14-field gh_ref with writable64-byte region and actual global symbol; Public.caller_precondition_satisfiable supplies concrete original zero-initialized memory. No-error quantifies all reachable original states; termination uses Acc over all successors.

Active attempt001 proves memcpy.pointer.1, memcpy.pointer_arithmetic.1, memcpy.pointer_arithmetic.2, memcpy.pointer.2, memcpy.pointer_arithmetic.3, memcpy.pointer_arithmetic.4, bits.precondition_instance.1, bits.precondition_instance.2, bits.precondition_instance.3, main.assertion.1, main.assertion.2, main.assertion.3, main.assertion.4, memcpy.overflow.1, memcpy.overflow.2. See independently compiled exact GoalBinding, assumptions output and kernel receipts.
