# Traditional CBMC passed

All 37 actual properties emitted by CBMC6.11.0 passed. The harness runs the complete genuine initializer from original literal static data, asserts return0, and checks arbitrary index0<=i<6434 against the original ordinary literal table. It has no angle input. All actual init statements/loops and decoded lookup are retained.

Traditional symbolic execution/BMC uses no function or loop contract replacement. Explicit init bounds: single loop4, multi loop42, outer loop3380, with unwinding assertions; sine bound1 where applicable. Automatic bounds, pointer, signedoverflow, division-by-zero and undefinedshift checks are enabled. Only actual emitted IDs are listed in properties.json. No unrestricted-angle source theorem or analytical sine-accuracy conclusion follows from this BMC evidence. Counterexample:not_applicable.
