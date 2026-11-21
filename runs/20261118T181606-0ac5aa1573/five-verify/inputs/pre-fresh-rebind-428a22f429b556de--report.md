# Traditional CBMC passed

All 13 actual properties emitted by CBMC6.11.0 passed. The harness chooses arbitrary int32 angle in[-12867,12867], runs the original ordinary sine, and asserts returnrange[-16383,16383]. Both original normalization loops execute zero times under this explicit BMC precondition.

Traditional symbolic execution/BMC uses no function or loop contract replacement. Explicit init bounds: single loop4, multi loop42, outer loop3380, with unwinding assertions; sine bound1 where applicable. Automatic bounds, pointer, signedoverflow, division-by-zero and undefinedshift checks are enabled. Only actual emitted IDs are listed in properties.json. No unrestricted-angle source theorem or analytical sine-accuracy conclusion follows from this BMC evidence. Counterexample:not_applicable.
