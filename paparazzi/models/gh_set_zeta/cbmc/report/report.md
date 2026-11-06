# CBMC implementation checks

All actual emitted properties pass for all binary32 input and initialized named-state bits, including NaNs. Exact union scalar representation observations, complete original entry, source-order product and full named-field frame; no loops/recursion. Padding is excluded. Canonical run uses Z3 bitvector encoding, not SMT native floating-point encoding.

Retry history retained: default propositional conversion timed out after300s. Native SMT floating-point encoding lost NaN payloads and produced representation-only failures; unsuitable for this exact-bit request. Final Z3 bitvector run passed. No universal cross-tool NaN payload equality is claimed. All emitted property IDs require independent Rocq recheck.
