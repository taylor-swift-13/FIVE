# CompCert execution model and CBMC alignment

Both frozen C inputs were exported with CompCert3.17 Csyntax/Cexec on x86-64 Linux little endian, binary32 nearest-even. The actual Source.v is generated and unchanged; Execution.v invokes the real Internal entry using a list of machine values and arbitrary CompCert memory. The model domain includes every argument list and memory, including invalid inputs. No CBMC assumption restricts the execution model.

The manifest pins compiler, actual source, preprocessed input, semantic libraries, target and all generated outputs. The common integer-restoring C math binding is represented by its actual generated function body. No new external sqrt axiom or ideal IEEE sqrt assumption is used. Native-libm equivalence and formal IEEE accuracy are outside this verification scope.

The complete122-property ledger is mapped by exact emitted ID and actual source location in ../spec-map.json. Canonical questions and independent Rocq proofs live under ../rocq/cbmc_recheck; mapping alone is not a proof. The two scenario CBMC input assumptions remain a property scope, while broad natural-domain safety and functionality are separately proved over the unrestricted model.

Generated proof/Precondition.v and obligation scaffolding are immutable unproved interfaces, not the final canonical problem specifications. Actual proof questions are in rocq/<problem>/problem/Spec.v. Execution correspondence covers all eight categories and every original Csem state, including errors; the source and animator domain are not narrowed to valid proof inputs.

Historical model revisions and all measured authoring/tool costs are retained. Shared exports are counted once.
