# Retune and reset concrete execution proofs

Status: direct compilation and independent full-dependency kernel checking passed for the final natural-boundary sources. These are supporting lemmas; canonical per-model and relation proofs are packaged separately.

RetuneBody preserves the original Float32 multiply-then-divide expression and proves its concrete Csyntax body evaluator. RetuneCall.retune_call_eval proves complete allocation, parameter binding, actual body execution and cleanup, returning Vundef, preserving writable12, writing exact coefficient bytes, and preserving bytes outside its write zone on all originally valid blocks.

ResetBody proves the original two writes and return. ResetCall.reset_call_summary proves the same complete call protocol, exact Vsingle return, exact eight bytes at offsets4..12, writable12 preservation and originally-valid-block frame. All binary32 patterns are admitted. No old object initialization is assumed. Pointer offset is arbitrary, aligned4, with unsignedp+12<=2^64 and twelve writable bytes.

Iterations retained in command logs: body simplification required one residual scalar-load and store-bound reduction; one call-frame proof needed the extra zero-length loadbytes disjunct; reset had one parenthesis typo and one local proof-name collision. First independent kernel check had a55second limit and timed out while checking dependencies; a300second full-dependency retry passed. After weakening the object boundary from max_unsigned to modulus, calls were recompiled and all four final modules were kernel-checked together successfully.

Print Assumptions reports only imported CompCert/standard-library foundations: classical logic, functional extensionality and the standard real-number decision foundations. No project Admitted, admit or added Axiom occurs in these files.

The same measured Sol medium session includes the retune-to-reset scope extension. Actual time, token and sampled tool-memory receipts cover failed retries as well as successes. Shared supporting-work costs must be counted once, even when referenced by multiple canonical problems. This is not a claim of GCC or whole-firmware binary equivalence.
