# Numeric operator support

All seven exact support goals are compiled and independently kernel checked; see `evidence/numeric-check-002/numeric-validation.json`. The theorem types are bound by a compiled GoalBinding certificate.

`numeric_kind` accepts precisely `tint`, `tuint`, `tulong`, and `tfloat` without attributes. Values are respectively Vint, Vint, Vlong and Vsingle. `safe_binop` enforces the actual usual arithmetic result type, rejects floating binary arithmetic, allows integer arithmetic/bitwise/comparison operators, accepts shifts only for a literal Vint below the left word width, and accepts division/modulo only for literal 2 of the actual RHS type. `safe_unop` admits typed negation, integer bit-not and numeric boolean-not with the exact result type. `safe_cast` admits 32/64 numeric word casts and binary32 identity.

`safe_binop_total` supplies one typed result for every composite environment and memory; `numeric_binop_independent` additionally proves equality of even partial operator results for arbitrary environments and memories. The unary, cast, and truth-value theorems have matching memory-independent results. These are the original CompCert Cop operations, with no axioms or admitted obligations added. The recorded target ABI is CompCert x86-64; signed word arithmetic is interpreted exactly as CompCert defines it.

Actual worker: gpt-6.1-sol medium, actor `/root/guidance_mode_complete_medium/guidance_entry`. Telemetry: `runs/20261106T131406-37a522857a/five-rocq`, including all failures/repairs. Operator support does not by itself prove the full C function or all-order safety; the parent owns the actual AST definite-assignment checker and heap/functional bridge.
