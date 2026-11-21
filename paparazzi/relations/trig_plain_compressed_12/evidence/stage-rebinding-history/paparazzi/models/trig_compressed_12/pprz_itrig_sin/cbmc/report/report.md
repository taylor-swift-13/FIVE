# Traditional CBMC passed

All 51 actual properties emitted by CBMC6.11.0 passed. The harness runs the complete genuine initializer and asserts return0, then chooses arbitrary int32 angle in[-12867,12867] and checks exact int32 sine return against the original ordinary literal table with the same folding. Both normalization loops execute zero times under this BMC precondition.

Traditional symbolic execution/BMC uses no function or loop contract replacement. Explicit init bounds: single loop4, multi loop42, outer loop3380, with unwinding assertions; sine bound1 where applicable. Automatic bounds, pointer, signedoverflow, division-by-zero and undefinedshift checks are enabled. Only actual emitted IDs are listed in properties.json. No unrestricted-angle source theorem or analytical sine-accuracy conclusion follows from this BMC evidence. Counterexample:not_applicable.
