# Prepare update_first_order_low_pass_tau

Preparation is complete. Entry update_first_order_low_pass_tau is defined in source/update_first_order_low_pass_tau.c; the sole dependency is the original FirstOrderLowPass struct. No callees, required includes, globals or external bindings. The prepared source is shared by CBMC and CompCert.

Source: Paparazzi commit abfee3dd56eeab12c528635504a429db3daf409a, sw/airborne/filters/low_pass_filter.h. Original header and license are retained; extraction.json gives exact upstream line ranges and hashes. Independent textual comparison confirms the struct and entire function body are unchanged.

Extraction removes only static inline: CompCert drops an unreferenced standalone static-inline entry, including a tested used attribute variant. The selected external entry retains the original parameter types, qualifiers, body and expression order. Original and prepared signatures are distinguished in source/bindings.json. Failed exports remain in align costs/logs; a syntax check does not establish whole-program extraction equivalence.

Target: CompCert 3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32, nearest ties to even; exact target/NaN policy is hash-bound by align. No input-domain precondition is imposed on the execution model. Proof-specific writable-memory assumptions belong to Rocq problem specifications.

The shared three-case prepare batch includes initial extraction, qualifier normalization and measured metadata/handoff finalization. costs.json retains each actual run including failures, without dividing shared model-token usage into invented per-case values. Time, token and tool-memory are separate; RSS excludes model-serving memory.
