# sum3

The model entry is `model/Execution.v`. Existing `theorem.txt` and kernel-check logs are historical evidence; no CBMC or Rocq verification was run for the repository organization and module naming changes on 2026-11-03.

Status: all-reachable Csem/Cexec no-error theorem.

Execution models have no numeric input-domain restriction. Safety theorems, when present, require their explicit calling/memory preconditions. NaN/infinity are floating-point values, not errors. Error means a nonterminal state with no semantic successor. CompCert semantics do not establish hardware/GCC equivalence.

Proof helper models in proof/support are witnesses only; execution semantics are in model/.


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. See ../../../reports/official-compcert-migration.json.
