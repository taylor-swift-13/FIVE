# Generic all-order guidance support

Generic support is proved and independently kernel checked. Concrete whole-entry all-order safety and functional observations remain pending integration; this report does not claim those goals are discharged.

Actor: /root/guidance_mode_complete_medium/guidance_allorder. Runtime receipt records actual gpt-6.1-sol, medium effort, from the actor's own session. Skill run: _build/guidance-mode-allorder/20261106T122019-5fbabb1f83/five-rocq.

## Checked interfaces

- AtomicProgress.all_order_atomic_expression: every finite original Csem expression-reduction prefix of a defined pure/atomic expression remains defined, silent and not stuck. Atomic semantics includes actual compound-assignment load, arithmetic, cast and store.
- CallfreeExecution.normal_witness_certifies_all_orders and normal_witness_excludes_all_errors: a real normal execution of the syntactically call-free class, plus unique local names, yields progress at every reachable original Csem state and exact returned-value/final-memory uniqueness.
- ContinuationLift.callee_invariant_progress and callee_invariant_all_successors: callee proofs inside actual arbitrary Kcall frames, covering every successor before the exact return boundary.
- BlockExecution.block_context_entry, block_context_progress, block_context_all_successors: a real prefix witness to Sskip before cleanup gives an all-order certificate under any actual tail continuation, including forthcoming calls. Exact final memory is retained.
- FactorShell.factor_progress and factor_all_successors: complete factor-assignment shell, all 54 partial evaluation shapes, real certified leaf call, final float division/store. Facts are bindings, typed reads, preserved maximum read after the leaf, actual final store, and leaf normal witness/syntax/name facts. No ideal square-root or global permission-restoration assumption.
- StandaloneCallShell.call_certificate: standalone pointer-argument call with all nine function/address evaluation stages; composes an independently constructed callee certificate at the actual Kcall frame.
- PhaseComposition.chain_certificate, certificate_no_error, certificate_normal_unique: phase composition and final all-reachable no-error/unique-normal-return consequences for a terminal Returnstate target.

## Evidence and limits

evidence/checked-002/checked-inputs.json binds 13 exact source snapshots: two semantics dependencies and eleven all-order modules. The checker freshly compiled each snapshot strictly sequentially and independently checked FiveGuidanceAllOrder.StandaloneCallShell, including transitive imports. Canonical kernel receipt: 121-canonical-allorder002-kernel in the skill run. Print Assumptions outputs are retained in compile logs. Inherited assumptions are CompCert/Flocq classical and functional-extensionality infrastructure plus existing external-function/inline-assembly semantic parameters. No target-specific Axiom or Admitted was introduced.

These generic modules do not import or alter either frozen guidance model. Actual speed/accel instantiation and natural-domain phase construction remain with concrete integration. The software square-root source body normal witness is a separate dependency. Earlier checked-001 certifies the smaller call-free support version and remains intact. Failed source versions and compiler logs are retained.

Telemetry records actor-session token boundaries, session wall time, GNU-time/compiler CPU and RSS receipts, including failed attempts. Lightweight setup, source-write, and log-inspection shell commands outside Run.command were not separately CPU-metered; their CPU allocation is unavailable rather than estimated. Observed command figures are not exhaustive machine-wide CPU totals.
