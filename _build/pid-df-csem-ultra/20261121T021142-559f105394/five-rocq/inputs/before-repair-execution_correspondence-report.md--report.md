# Complete original Cexec/Csem execution correspondence: attempt 001

Proved all 8 canonical goals; pending goals: none.

For all argument lists and memories, prove entry/source domain preservation; reachable step equivalence for floating, integer and memory operations; whole trace/control/exhaustion equivalence; returned value and loadbytes equivalence; and error/stuck correspondence. There is no numerical input restriction and no clipped AST.

Entry update_pid_df; original full 32-byte PID_df model, namespace FivePidDf. Prepared source preserves the frozen upstream struct and function. Source lineage and target are bound by prepare/source/bindings.json and align/model/compcert-manifest.json. The proof concerns CompCert semantics and retains the frontend and target floating-point trusted boundary.

Source SHA-256: 51b255ae42a19ab9d5b30366132bf46f5ff70e31903e6d93aae018cb5578829f. Model SHA-256: 6358f092a83f1d67f2ea413a7448e525cd271d55bb030d64497ea0dffeef0650. Canonical Spec.v SHA-256: 5d6026e2398aa44f7aff7ec980618e293a22f2de0cb29669171b7b9a7e8a2420. Exact compiled snapshots and current consumed inputs are bound by [provenance.json](provenance.json) and [goal-validation.json](evidence/goal-validation.json).

Tool versions: Rocq 9.2 compiled with OCaml 4.14.2; CompCert 3.17, x86 model 64 standard ABI, little endian. Binary32 rounding and NaN semantics are exactly those of the pinned CompCert model. Byte observations use Mem.loadbytes, memval, encode_val. The source function has no external calls; the bits helper is separately linked to the existing official memcpy adapter.

Requested and observed worker model: gpt-6.1-sol. Requested and observed reasoning effort: ultra. Actual turn_context receipt: [runtime-receipt.json](../../../support/runtime-receipt.json), session 01a1fbbf-c41d-7973-96e0-585082994115.

Each goal is checked against its exact expected type in a deterministic GoalBinding certificate. Successful certificate compilation: 039-FivePidDfExecutionCorrespondence-goal-certificate; independent kernel command: 040-FivePidDfExecutionCorrespondence-independent-kernel; recorded run: _build/pid-df-csem-ultra/20261121T020015-4799b926cd/five-rocq. [Kernel receipt](evidence/kernel-evidence.json), [certificate receipt](evidence/certificate-kernel-evidence.json), [validation receipt](evidence/goal-validation.json). Reproduce with python3 check.py; add --record-run RUN_DIR for measured evidence. Commands, statement snapshots, source hashes and exact argv are retained by these receipts.

Inherited assumptions, union over this attempt's actual GoalBinding Print Assumptions output: Axioms, ClassicalDedekindReals.sig_forall_dec, ClassicalDedekindReals.sig_not_dec, Classical_Prop.classic, Events.external_functions_sem, Events.inline_assembly_sem, FunctionalExtensionality.functional_extensionality_dep. No target Axiom, Admitted or admit was introduced. Actual pergoal assumption output: _build/pid-df-csem-ultra/20261121T020015-4799b926cd/five-rocq/logs/039-FivePidDfExecutionCorrespondence-goal-certificate.stdout.log. Generic Events semantic parameters are inherited from CompCert; the source function has no external calls.

Costs are recorded in shared runs, including failed/retried compiles and independent kernels. Perproblem token/time/memory allocation is null because support work is shared; [costs.json](costs.json) links actual measured receipts without estimating a split. Tool memory uses sampled process-tree RSS plus GNU time per-process maxima; model/desktop memory is unobserved. First construction run remains failed, continuation passed, final checker closed passed at delivery.

Exact local Rocq dependency sources, with all current hashes in provenance:

- paparazzi/models/update_pid_df/align/model/Execution.v
- paparazzi/models/update_pid_df/align/model/Extraction.v
- paparazzi/models/update_pid_df/align/model/Source.v
- paparazzi/models/update_pid_df/align/model/proof/Obligations.v
- paparazzi/models/update_pid_df/align/model/proof/Precondition.v
- paparazzi/models/update_pid_df/align/model/proof/Proofs.v
- paparazzi/models/update_pid_df/rocq/execution_correspondence/attempts/001/Proof.v
- paparazzi/models/update_pid_df/rocq/execution_correspondence/problem/Closure.v
- paparazzi/models/update_pid_df/rocq/execution_correspondence/problem/Spec.v
- paparazzi/relations/guidance_mode/support/semantics/SemanticsSupport.v
- paparazzi/relations/guidance_mode/support/semantics/SourceClosure.v
- shared/verification/Obligations.v
