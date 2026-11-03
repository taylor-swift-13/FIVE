# lowpass

The model entry is `model/Execution.v`. Existing `theorem.txt` and kernel-check logs are historical evidence; no CBMC or Rocq verification was run for the repository organization and module naming changes on 2026-11-03.

Status: all-reachable Csem/Cexec no-error theorem.

Execution models have no numeric input-domain restriction. Safety theorems, when present, require their explicit calling/memory preconditions. NaN/infinity are floating-point values, not errors. Error means a nonterminal state with no semantic successor. CompCert semantics do not establish hardware/GCC equivalence.

Proof helper models in proof/support are witnesses only; execution semantics are in model/.

# Low-pass filter: all-reachable-state error freedom

This proof applies to the existing unrestricted `FiveCases.lowpass.model.Execution`
and original CompCert Csem low-pass function. The source C, execution model,
arithmetic semantics, memory semantics and error definition are unchanged.
No CBMC fact, finite input whitelist, concrete execution tree, path enumeration,
SMT certificate, new axiom or admitted lemma is used in the safety proof.

## Public precondition

`Entry.lowpass_pre m b fs` requires:

1. `b` is a live caller memory block, passed as `Vptr b Ptrofs.zero`.
2. The eight float slots at byte offsets0,4,...,28 load as the complete
   binary32 encodings held in arbitrary `filter_state fs`.
3. History slots16,20,24,28 have valid aligned writable float accesses.

The input is any `int` word. There is no finite-number, non-NaN, magnitude,
coefficient, positivity or nonoverflow assumption. Coefficient slots need only
the read permissions implied by their initialized loads. Requiring the entire
32-byte struct to be initialized/readable/writable is an easy stronger condition.
Private parameter/local allocation, their separation from the caller object,
initialization and final deallocation are all proved, not public assumptions.

## Invariant and proof organization

`Invariant.execution_invariant s` combines syntax closure, the permitted
statement/continuation shape, and successful denotation of the remaining code.
The denotation is the existing computational `NormalCorrespondence.state_eval`:
it describes values, casts, memory writes and freeing; it does not mention
error, reachability or no-successor predicates.

`PureProgress.v` proves by syntax/derivation/context induction that a successful
pure/flat denotation makes every evaluated subexpression immediately safe.
This excludes the Csem rule that jumps to `Stuckstate`, for **every** allowed
expression evaluation order. It is not just a proof of one evaluation strategy.

`Entry.structural_pre_establishes_invariant` derives the invariant from the
three caller conditions, constructing three fresh local blocks, two parameter
stores, five source stores, and the exact final free-list success.
`Invariant.invariant_preserved` handles an arbitrary Csem step.
`Invariant.invariant_progress` proves normal return or an actual Csem successor.
Induction on an arbitrary finite `Smallstep.star` path proves the public result.

`Nonvacuity.precondition_inhabited` constructs an allocated/initialized zero
struct through ordinary memory lemmas. This is only a non-vacuity witness;
the main theorem is universal over all caller memories/field bits/input bits.

## Exact theorems

* `NoError.lowpass_all_reachable_no_error`: all finite Csem reachable states
  under the precondition are not `source_error`.
* `NoError.lowpass_model_all_reachable_no_error`: same result for the original
  full executable model's `model_step`, using the already-proved correspondence.
* `NoError.lowpass_no_stuck_state`: explicit Stuckstate is unreachable.
* `NoError.lowpass_model_progress_at_every_reachable_state`: any reached state
  is normally returned or has a genuine transition in the animator's full list.
* `NoError.lowpass_every_execution_tree_leaf_no_error`: every tree leaf at
  every fuel budget is error-free. An exhausted budget is still distinct from
  termination and is not used as a normal-return proof.
* `NoError.source_error_matches_executable_error` connects the selected error
  with nonnormal/no-animator-successor using existing `blocked_exact`.

The selected error is exactly `~normal_return s /\ nostep Csem.step lowpass_ge s`.
No claim of numerical stability, finite output, real-number precision or
termination is added. NaN/Inf values remain normal IEEE values when permitted
by the fixed CompCert target semantics.

`Check.v` prints the public theorem types/precondition/error and actual inherited
assumptions. The original Csem types carry opaque CompCert external-function and
inline-assembly semantic parameters; the low-pass body reaches neither. Stdlib
classical/extensionality/real-decision assumptions are also reported. No new
axiom is used to discharge safety. The target remains CompCert Csyntax Csem,
x86-64 little-endian binary32 RN-even, with the previous target/trust scope.

## Reproduce

From `/home/yangfp/five`:

```
source scripts/env.sh
python3 scripts/verify-lowpass-noerror.py
```

The command copies the eleven original dependencies and six new proof modules
to a fresh build directory, compiles them and independently kernel-checks all
seventeen modules. It does not enumerate execution paths or rerun CBMC.
See `kernel-evidence.json` and the delivery report/metrics for the actual checked
run, dependency hashes, assumptions, token usage, time and observed peak memory.


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. See ../../../reports/official-compcert-migration.json.
