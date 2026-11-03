# identity

Status: Csem safety certificate (symbolic input, finite execution).

Execution models have no numeric input-domain restriction. Safety theorems, when present, require their explicit calling/memory preconditions. NaN/infinity are floating-point values, not errors. Error means a nonterminal state with no semantic successor. CompCert semantics do not establish hardware/GCC equivalence.

Proof helper models in proof/support are witnesses only; execution semantics are in model/ (or shared/strict_execution).


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. See ../../../reports/official-compcert-migration.json.
