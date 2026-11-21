# five-rocq / 20261119T195957-33f946921e

Verification: passed

Original getter named-call provenance closes the real direct-call graph while retaining the full frozen AST, all arguments and all memories. Exact Csem/Cexec correspondence and invalid-operation correspondence hold; all original Csem successors are accessible. Concrete lookup/budget and local variable type obligations are proved. Independent original and final cold GoalBinding kernel checks passed. No new axioms or admitted proofs. Standard inherited CompCert/classical/extensionality assumptions are listed in Print Assumptions.

Wall time: 1055.978218 s

CPU tool time: 159.24 s

Observed tool-tree RSS peak: 1385791488 bytes

Model tokens: available; total=4851971

Measurement completeness: complete

run.json contains scope, input/output hashes, commands, token evidence and remaining obligations. metrics.json contains resource measurements and their limits.

Cost evidence audit: complete
