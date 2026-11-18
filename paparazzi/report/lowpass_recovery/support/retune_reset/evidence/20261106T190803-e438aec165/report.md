# Retune valid-block preservation

Status: proved, direct compile and independent full-dependency kernel check passed.

retune_call_summary strengthens the previous retune_call_eval interface by proving that all blocks valid in the original memory remain valid after the full call. The proof composes real allocation, parameter stores, the original coefficient store and parameter free-list operations. It does not strengthen writable12 or restrict any binary32 input.

The old retune_call_eval theorem keeps exactly its previous type as a proved corollary. The new result lets the top-level relation chain the reset frame property after retune. Target: hash-bound CompCert3.17 Csem/Cexec x86-64 Linux little-endian binary32 nearest-ties-even; unsignedp+12<=2^64, aligned4 writable12, no old initialized-value premise.

Actual agent: gpt-6.1-sol medium. One source extension compiled and independently kernel-checked successfully; measured token/time/tool-memory receipts are retained. Imported standard-library and CompCert logical foundations are printed; no project axiom or admitted proof is introduced.
