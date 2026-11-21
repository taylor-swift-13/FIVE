Proved NoError with original source semantics.

Question: NoError.

Original CompCert3.17 Csyntax/Csem entry float_rmat_of_quat, x86-64 Linux little endian binary32 nearest ties-even. The model remains unrestricted. Proof precondition uses two disjoint valid blocks, zero-offset pointers, four initialized quaternion float32 values and nine writable output float32 slots. Every binary32 pattern is allowed; this covers the original shared CBMC harness finite bounded domain.

Safety quantifies every Csem-reachable original state. No evaluator/postcondition is assumed in the precondition. Normal-return existence, exact 36 output memval bytes, all9 typed scalar loads, frame outside output [0,36) on original valid blocks and original caller valid_access preservation are independently derived.

Active attempt001 is independently kernel checked; exact statements and dependencies are in its goal-validation/provenance receipts.

Actual runtime: gpt-6.1-sol / ultra; requested gpt-6.1-sol / ultra. Runtime receipt: _build/quat-rotation-ultra/ofquat-proof/20261120T102324-05e8746ec6/five-rocq/evidence/runtime-configuration.json.

Inherited library assumptions observed: ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep, Classical_Prop.classic. No new Axiom/Admitted/admit appears in this attempt.

Source SHA256 5d5e765cf53bd21025c740ed40c0ef5d7f2650b85c30fd125911826efb03e44e; Source.v 98aa27469ac90ded8c1f0720ae84e04b78f038d1281796696220d61f6e56689c; Execution.v 92a529f71bfdf4ea1cc35a4b5afb9871416e915184e574efdff739710b9d9b37; canonical Spec.v 4d9748ba227de482a345e48701532075ece9e50c76b43716857076bbca70b0fb; Proof.v e4bf3325018fc6f54c999c9b9eeb0452d8b8cb7fd2da0c55f05c74e7498d734a. Source is the exact pinned Paparazzi abfee3dd56eeab12c528635504a429db3daf409a body; M_SQRT2 remains double bits4609047870845172685, each product assigned through Float.to_single before binary32 matrix arithmetic. No external call or numeric-domain clipping.

Reproduce from repository root: source scripts/env.sh && python3 paparazzi/models/float_rmat_of_quat/rocq/no_error/attempts/001/check.py. The checker freshly compiles recursive source snapshots, exact-type GoalBinding/Print Assumptions and independently runs rocq check. The successful canonical receipts are evidence/{goal-validation,kernel-evidence,certificate-kernel-evidence}.json.

Costs: costs.json references one shared measured ofquat authoring/checking record; interrupted old phase and all failed compiles are retained. Per-problem token/time/memory allocation remains null; unknown server memory is not estimated.
